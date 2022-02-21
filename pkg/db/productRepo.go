package db

import (
	"context"
	"database/sql"
	"errors"
	"food-delivery/pkg/models"
	"strings"
	"time"
)

type ProductRepo struct {
	*DB
	CachedProduct map[int64]*struct {
		Product  *models.Product
		DeadTime time.Time
	}
	CachedBaskets map[int64]*struct {
		Basket   *models.Basket
		DeadTime time.Time
	}
}

var globalProductRepo *ProductRepo

func InitProductRepo(db *DB) (*ProductRepo, error) {
	globalProductRepo = &ProductRepo{
		DB: db,
		CachedBaskets: make(map[int64]*struct {
			Basket   *models.Basket
			DeadTime time.Time
		}),
		CachedProduct: make(map[int64]*struct {
			Product  *models.Product
			DeadTime time.Time
		}),
	}

	newProductTypes, err := globalProductRepo.LoadTypes("product_types")
	if err != nil {
		return nil, err
	}
	productTypes := *models.GetProductTypes()
	for k, v := range newProductTypes {
		productTypes[k] = &v
	}

	newIngredients, err := globalProductRepo.LoadTypes("ingredients")
	if err != nil {
		return nil, err
	}
	ingredients := *models.GetIngredients()
	for k, v := range newIngredients {
		value := v
		ingredients[k] = &value
	}

	return globalProductRepo, nil
}
func GetProductRepo() *ProductRepo {
	return globalProductRepo
}

// Product methods
func (r *ProductRepo) GetProduct(id int64) (*models.Product, error) {
	if data, ok := r.CachedProduct[id]; !ok {
		_, err := r.loadProduct(id)
		if err != nil {
			return nil, err
		}
		return r.GetProduct(id)
	} else {
		data.DeadTime = time.Now().Add(time.Hour)
		return data.Product, nil
	}
}
func (r *ProductRepo) loadProduct(id int64) (models.Product, error) {
	// Product getting
	row := r.Conn.QueryRow("SELECT supl_id, name, description, image, price, type_id FROM products WHERE id = ?", id)
	product := models.Product{ID: id}
	var (
		supplierId, typeId int64
	)
	err := row.Scan(&supplierId, &product.Name, &product.Description, &product.Image, &product.Price, &typeId)
	if err != nil {
		return models.Product{}, err
	}

	// Product setup
	var ok bool
	product.Type, ok = (*models.GetProductTypes())[typeId]
	if !ok {
		return models.Product{}, errors.New("product not found")
	}
	product.Supplier, err = globalUserRepo.GetSupplier(supplierId)
	if err != nil {
		return models.Product{}, err
	}
	_, err = r.GetAndLoadIngredients(&product)
	if err != nil {
		return models.Product{}, err
	}
	r.AddProduct(product)
	return product, nil
}
func (r *ProductRepo) SaveProduct(product *models.Product, tx *sql.Tx, ctx context.Context) (int64, error) {
	typeId := models.GetProductTypeId(product.Type)
	if typeId == 0 {
		return 0, errors.New("product type unknown (is 0)")
	}
	var (
		args  = []interface{}{product.Description, product.Image, product.Price}
		saver Saver
	)
	if product.ID == 0 {
		saver = Saver{
			Query: "INSERT INTO products(description, image, price, type_id, supplier_id, name) VALUE (?, ?, ?, ?, ?, ?);",
			Args:  append(args, typeId, product.Supplier.ID, product.Name),
		}
	} else {
		saver = Saver{
			Query: "UPDATE products SET description = ?, image = ?, price = ? WHERE id = ?;",
			Args:  append(args, product.ID),
		}
	}
	return saver.Save(tx, ctx)
}
func (r *ProductRepo) AddProduct(product models.Product) {
	r.CachedProduct[product.ID] = &struct {
		Product  *models.Product
		DeadTime time.Time
	}{Product: &product, DeadTime: time.Now().Add(time.Hour)}
}

// Product hepler methods
func (r *ProductRepo) GetAndLoadIngredients(product *models.Product) ([]models.Ingredient, error) {
	if product.ID == 0 && product == nil {
		return nil, nil
	}
	rows, err := r.Conn.Query("SELECT product_ingredients.ingredient_id, i.name FROM product_ingredients JOIN ingredients i on product_ingredients.ingredient_id = i.id;", product.ID)
	if err != nil {
		return nil, err
	}
	var (
		ingredientId   int64
		ingredientName string
		ingredients    = *models.GetIngredients()
	)
	for rows.Next() {
		err = rows.Scan(&ingredientId, &ingredientName)
		if err != nil {
			return nil, err
		}
		_, ok := ingredients[ingredientId]
		if !ok {
			ing := ingredientName
			ingredients[ingredientId] = &ing
		}
		product.Ingredients = append(product.Ingredients, ingredients[ingredientId])
	}
	return product.Ingredients, nil
}
func (r *ProductRepo) ConnectProductWithIngredient(product models.Product, tx *sql.Tx, ctx context.Context) error {
	var (
		queryCount = len(product.Ingredients)
		args       = make([]interface{}, 0)
	)

	for _, v := range product.Ingredients {
		id := models.GetIngredientId(v)
		args = append(args, product.ID, id)
	}
	_, err := Saver{
		Query: "INSERT INTO product_ingredients(product_id, ingredient_id) VALUES " + strings.Repeat(",(?, ?)", queryCount)[1:],
		Args:  args,
	}.Save(tx, ctx)
	return err

}
func (r *ProductRepo) SaveIngredients(ingredients []models.Ingredient, tx *sql.Tx, ctx context.Context) error {
	saver := Saver{
		Query: "INSERT IGNORE INTO ingredients(name) VALUES " +
			strings.Repeat(",(?)", len(ingredients))[1:],
		Args: make([]interface{}, 0),
	}
	for _, ingredient := range ingredients {
		saver.Args = append(saver.Args, *ingredient)
	}
	firstId, err := saver.Save(tx, ctx)
	if err != nil {
		return err
	}
	var lastId int64
	if err = tx.QueryRow("SELECT MAX(id) FROM ingredients").Scan(&lastId); err != nil {
		return err
	}
	nameRows, err := tx.Query("SELECT id, name  FROM ingredients WHERE id >= ? AND  id <= ?", firstId, lastId)
	if err != nil {
		return err
	}
	var (
		id   int64
		name string
	)
	globalIngredients := *models.GetIngredients()
	for nameRows.Next() {
		if err = nameRows.Scan(&id, &name); err != nil {
			return err
		}
		newName := name
		globalIngredients[id] = &newName
	}
	return nil
}
func (r *ProductRepo) LoadIngredient() error {
	rows, err := r.Conn.Query("SELECT id, name FROM ingredients;")
	if err != nil {
		return err
	}
	var (
		id   int64
		name string
	)
	globalIngredients := *models.GetIngredients()
	for rows.Next() {
		err = rows.Scan(&id, &name)
		if err != nil {
			return err
		}
		globalIngredients[id] = &name
	}

	return nil
}
func (r *ProductRepo) GetProductsForBasket(basket *models.Basket) ([]*models.Product, error) {
	if basket.ID == 0 {
		return nil, nil
	}
	rows, err := r.Conn.Query("SELECT product_id FROM products_basket WHERE basket_id = ?;", basket.ID)
	if err != nil {
		return nil, err
	}
	var (
		productId int64
		product   *models.Product
	)
	for rows.Next() {
		if err = rows.Scan(&productId); err != nil {
			return nil, err
		}
		product, err = r.GetProduct(productId)
		if err != nil {
			return nil, err
		}
		basket.Products = append(basket.Products, product)
	}
	return basket.Products, nil
}
func (r *ProductRepo) GetProductsForBranch(branch *models.Branch) error {
	rows, err := r.Conn.Query("SELECT product_id, exist FROM products_branch WHERE branch_id = ?;", branch.ID)
	if err != nil {
		return err
	}
	var (
		productId int64
		exist     bool
	)
	for rows.Next() {
		err = rows.Scan(&productId, &exist)
		if err != nil {
			return err
		}
		_, err = branch.AddProductFromSupplier(productId, exist)
		if err != nil {
			return err
		}
	}
	return nil
}
func (r *ProductRepo) ConnectBranchWithProducts(branch models.Branch, tx *sql.Tx, ctx context.Context) error {
	var (
		queryCount = len(branch.Products)
		args       = make([]interface{}, 0)
	)
	for id, product := range branch.Products {
		args = append(args, branch.ID, id, product.Exist)
	}
	_, err := Saver{
		Query: "INSERT INTO products_branch(branch_id, product_id, exist) VALUES " + strings.Repeat(",(?, ?, ?)", queryCount)[1:],
		Args:  args,
	}.Save(tx, ctx)
	return err
}

// Basket methods
func (r *ProductRepo) loadBasket(id int64) (models.Basket, error) {
	row := r.Conn.QueryRow("SELECT client_id, coordinates_to_id, paid, closed, editable FROM baskets WHERE id = ?", id)
	basket := models.Basket{
		ID: id,
	}
	var clientId, coordinateToId int64

	err := row.Scan(&clientId, &coordinateToId, &basket.Paid, &basket.Closed, &basket.Editable)
	if err != nil {
		return models.Basket{}, err
	}
	basket.CoordinateTo, err = globalHelperRepo.GetCoordinate(coordinateToId)
	if err != nil {
		return models.Basket{}, err
	}
	basket.Client, err = globalUserRepo.GetClient(clientId)
	if err != nil {
		return models.Basket{}, err
	}
	_, err = globalProductRepo.GetProductsForBasket(&basket)
	if err != nil {
		return models.Basket{}, err
	}
	r.CachedBaskets[id] = &struct {
		Basket   *models.Basket
		DeadTime time.Time
	}{Basket: &basket, DeadTime: time.Now().Add(time.Hour)}
	return basket, nil
}
func (r *ProductRepo) GetBasket(id int64) (*models.Basket, error) {
	if data, ok := r.CachedBaskets[id]; !ok {
		_, err := r.loadBasket(id)
		if err != nil {
			return nil, err
		}
		return r.GetBasket(id)
	} else {
		data.DeadTime = time.Now().Add(time.Hour)
		return data.Basket, nil
	}
}
func (r *ProductRepo) SaveBasket(basket *models.Basket, tx *sql.Tx, ctx context.Context) (int64, error) {
	var (
		args  = []interface{}{basket.Paid, basket.Closed, basket.Editable}
		saver Saver
	)
	if basket.ID == 0 {
		saver = Saver{
			Query: "INSERT INTO baskets(paid, closed, editable, client_id, coordinates_to_id) VALUE (?, ?, ?, ?, ?);",
			Args:  append(args, basket.Client.ID, basket.CoordinateTo.ID),
		}
	} else {
		saver = Saver{
			Query: "UPDATE baskets SET paid = ?, closed = ?, editable = ?, final_price = ? WHERE id = ?;",
			Args:  append(args, basket.FinalPrice, basket.ID),
		}
	}
	return saver.Save(tx, ctx)
}
func (r *ProductRepo) ConnectBasketWithProducts(basket *models.Basket, tx *sql.Tx, ctx context.Context) error {
	if len(basket.Products) == 0 {
		return errors.New("len prod == 0")
	}
	var (
		queryCount = len(basket.Products)
		args       = make([]interface{}, 0)
	)
	for _, product := range basket.Products {
		args = append(args, product.ID, basket.ID)
	}
	_, err := Saver{
		Query: "INSERT INTO products_basket(product_id, basket_id) VALUES " + strings.Repeat(",(?, ?)", queryCount)[1:],
		Args:  args,
	}.Save(tx, ctx)
	return err
}
