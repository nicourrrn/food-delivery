package db

import (
	"context"
	"errors"
	"food-delivery/pkg/models"
	"log"
	"strconv"
	"time"
)

type SupplierRepo struct {
	*DB
	CachedSupplier map[int64]*struct {
		Supplier *models.Supplier
		DeadTime time.Time
	}
	CachedBranch map[int64]*struct {
		Branch   *models.Branch
		DeadTime time.Time
	}
	CachedProduct map[int64]*struct {
		Product  *models.Product
		DeadTime time.Time
	}
}

var globalSupplierRepo *SupplierRepo

func InitSupplierRepo(db *DB) (*SupplierRepo, error) {
	globalSupplierRepo = &SupplierRepo{
		DB: db,
		CachedSupplier: make(map[int64]*struct {
			Supplier *models.Supplier
			DeadTime time.Time
		}),
		CachedBranch: make(map[int64]*struct {
			Branch   *models.Branch
			DeadTime time.Time
		}),
		CachedProduct: make(map[int64]*struct {
			Product  *models.Product
			DeadTime time.Time
		}),
	}

	newSupplierTypes, err := globalSupplierRepo.LoadTypes("supplier_types")
	if err != nil {
		return nil, err
	}
	supplierTypes := *models.GetSupplierTypes()
	for k, v := range newSupplierTypes {
		supplierTypes[k] = &v
	}

	newProductTypes, err := globalSupplierRepo.LoadTypes("products_types")
	if err != nil {
		return nil, err
	}
	productTypes := *models.GetProductTypes()
	for k, v := range newProductTypes {
		productTypes[k] = &v
	}

	newIngredients, err := globalSupplierRepo.LoadTypes("ingredients")
	if err != nil {
		return nil, err
	}
	ingredients := *models.GetIngredients()
	for k, v := range newIngredients {
		ingredients[k] = &v
	}

	return globalSupplierRepo, nil
}

// Branch methods
func (r *SupplierRepo) GetBranch(id int64) (*models.Branch, error) {
	if data, ok := r.CachedBranch[id]; !ok {
		//_, err := r.LoadUser(id)
		_, err := LoadUser(r.DB, "id", strconv.FormatInt(id, 10))
		if err != nil {
			return nil, err
		}
		return r.GetBranch(id)
	} else {
		data.DeadTime = time.Now().Add(time.Hour)
		return data.Branch, nil
	}
}
func (r *SupplierRepo) LoadBranch(user models.User) (models.Branch, error) {
	row := r.Conn.QueryRow("SELECT coordinate_id, image, open_time, close_time, supplier_id FROM supl_branches WHERE id = ?", user.ID)
	branch := models.Branch{
		User: user,
	}
	var (
		supplId, coordinatesId int64
	)
	err := row.Scan(&coordinatesId, &branch.Image, &branch.WorkingHour.Open, &branch.WorkingHour.Close, &supplId)
	if err != nil {
		return models.Branch{}, err
	}
	coordinate, err := globalHelperRepo.GetCoordinate(coordinatesId)
	if err != nil {
		log.Println(err, "when load branch from coordinate")
		return models.Branch{}, err
	}
	branch.Coordinate = *coordinate
	r.CachedBranch[user.ID] = &struct {
		Branch   *models.Branch
		DeadTime time.Time
	}{Branch: &branch, DeadTime: time.Now().Add(time.Hour)}
	// TODO вынести время жизни в конфигурацию
	return branch, nil
}
func (r *SupplierRepo) SaveBranch(branch models.Branch) error {
	ctx := context.Background()
	tx, err := r.Conn.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	err = SaveUser(r.DB, &branch.User, tx, ctx)
	if err != nil {
		return err
	}
	var (
		args = []interface{}{branch.Image, branch.WorkingHour.Open, branch.WorkingHour.Close}
		id   int64
	)
	if branch.ID != 0 {
		id, err = Saver{
			Query: "INSERT INTO supl_branches(image, open_time, close_time, supplier_id, coordinate_id,) VALUE (?, ?, ?, ?, ?);",
			Args:  append(args, branch.Supplier.ID, branch.Coordinate.ID),
		}.Save(r.DB, tx, ctx)
	} else {
		id, err = Saver{
			Query: "UPDATE supl_branches SET image = ?, open_time = ?, close_time = ? WHERE id = ?;",
			Args:  append(args, branch.ID),
		}.Save(r.DB, tx, ctx)
	}
	if err != nil {
		return err
	}
	if branch.ID == 0 {
		branch.ID = id
	}
	return nil
}

// Supplier methods
func (r *SupplierRepo) GetSupplier(id int64) (*models.Supplier, error) {
	if data, ok := r.CachedSupplier[id]; !ok {
		_, err := LoadUser(r.DB, "id", strconv.FormatInt(id, 10))
		if err != nil {
			return nil, err
		}
		return r.GetSupplier(id)
	} else {
		data.DeadTime = time.Now().Add(time.Hour)
		return data.Supplier, nil
	}
}
func (r *SupplierRepo) LoadSupplier(user models.User) (models.Supplier, error) {
	row := r.Conn.QueryRow("SELECT supplier_info.description, supplier_info.supplier_type_id FROM supplier_info WHERE id = ?", user.ID)
	supplier := models.Supplier{User: user}
	var supplTypeId int64
	err := row.Scan(&supplier.Description, &supplTypeId)
	if err != nil {
		return models.Supplier{}, err
	}
	supplier.Type = (*models.GetSupplierTypes())[supplTypeId]
	r.CachedSupplier[user.ID] = &struct {
		Supplier *models.Supplier
		DeadTime time.Time
	}{Supplier: &supplier, DeadTime: time.Now().Add(time.Hour)}
	// TODO вынести время жизни в конфигурацию
	return supplier, nil
}
func (r SupplierRepo) SaveSupplier(supplier *models.Supplier) error {
	ctx := context.Background()
	tx, err := r.Conn.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	err = SaveUser(r.DB, &supplier.User, tx, ctx)
	if err != nil {
		return err
	}
	typeId := models.GetSupplierTypeId(supplier.Type)
	if typeId == 0 {
		return errors.New("supplier type unknown")
	}
	var (
		args = []interface{}{supplier.Description, typeId, supplier.Image, supplier.User.ID}
		id   int64
	)
	if supplier.ID != 0 {
		id, err = Saver{
			Query: "INSERT INTO supplier_info(description, supplier_type_id, image, user_id) VALUE (?, ?, ?, ?);",
			Args:  args,
		}.Save(r.DB, tx, ctx)
	} else {
		id, err = Saver{
			Query: "UPDATE supplier_info SET description = ?, supplier_type_id = ?, image = ? WHERE user_id = ?;",
			Args:  args,
		}.Save(r.DB, tx, ctx)
	}
	if err != nil {
		return err
	}
	if supplier.ID == 0 {
		supplier.ID = id
	}
	return nil
}

// Product methods
func (r *SupplierRepo) GetProduct(id int64) (*models.Product, error) {
	if data, ok := r.CachedProduct[id]; !ok {
		_, err := r.LoadProduct(id)
		if err != nil {
			return nil, err
		}
		return r.GetProduct(id)
	} else {
		data.DeadTime = time.Now().Add(time.Hour)
		return data.Product, nil
	}
}
func (r *SupplierRepo) LoadProduct(id int64) (models.Product, error) {
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
	product.Supplier, err = r.GetSupplier(supplierId)
	if err != nil {
		return models.Product{}, err
	}
	_, err = r.GetIngredients(&product)
	if err != nil {
		return models.Product{}, err
	}

	r.CachedProduct[id] = &struct {
		Product  *models.Product
		DeadTime time.Time
	}{Product: &product, DeadTime: time.Now().Add(time.Hour)}
	return product, nil
}
func (r *SupplierRepo) SaveProduct(product *models.Product) error {
	ctx := context.Background()
	tx, err := r.Conn.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	typeId := models.GetProductTypeId(product.Type)
	if typeId == 0 {
		return errors.New("supplier type unknown")
	}
	var (
		args = []interface{}{product.Description, product.Image, product.Price}
		id   int64
	)
	if product.ID != 0 {
		id, err = Saver{
			Query: "INSERT INTO products(description, image, price, type_id, supl_id, name) VALUE (?, ?, ?, ?, ?, ?);",
			Args:  append(args, typeId, product.Supplier.ID, product.Name),
		}.Save(r.DB, tx, ctx)
	} else {
		id, err = Saver{
			Query: "UPDATE products SET description = ?, image = ?, price = ? WHERE id = ?;",
			Args:  append(args, product.ID),
		}.Save(r.DB, tx, ctx)
	}
	if err != nil {
		return err
	}
	if product.ID == 0 {
		product.ID = id
	}
	return nil
}

// Product hepler methods
func (r *SupplierRepo) GetIngredients(product *models.Product) ([]*string, error) {
	if product.ID == 0 {
		return nil, nil
	}
	rows, err := r.Conn.Query("SELECT ingredient_id FROM product_ingredients WHERE product_id = ?", product.ID)
	if err != nil {
		return nil, err
	}
	var (
		ingredientId int64
		ingredient   models.Ingredient
		ok           bool
	)
	for rows.Next() {
		err = rows.Scan(&ingredientId)
		if err != nil {
			return nil, err
		}
		ingredient, ok = (*models.GetIngredients())[ingredientId]
		if !ok {
			return nil, errors.New("ingredient not found")
		}
		product.Ingredients = append(product.Ingredients, ingredient)
	}
	return product.Ingredients, nil
}
func (r *SupplierRepo) SaveIngredients(ingredients []models.Ingredient) error {
	globalIngredients := models.GetIngredients()
	query, err := r.Conn.Prepare("INSERT INTO ingredients(name) VALUE (?)")
	if err != nil {
		return err
	}
	for _, i := range ingredients {
		result, err := query.Exec(i)
		if err != nil {
			return err
		}
		id, err := result.LastInsertId()
		if err != nil {
			return err
		}
		(*globalIngredients)[id] = i
	}
	// TODO update ingredients
	//models.UpdateIngredients(globalIngredients)
	return nil
}
func (r *SupplierRepo) GetProductsForBasket(basket *models.Basket) ([]*models.Product, error) {
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
		err = rows.Scan(&productId)
		if err != nil {
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
func (r *SupplierRepo) GetProductsForBranch(branch models.Branch) error {
	if branch.ID == 0 {
		return errors.New("branch not exist")
	}
	rows, err := r.Conn.Query("SELECT product_id FROM products_branch WHERE branch_id = ?;", branch.ID)
	if err != nil {
		return err
	}
	var (
		productId int64
		//product   *models.Product
	)
	for rows.Next() {
		err = rows.Scan(&productId)
		if err != nil {
			return err
		}
		_, err = branch.AddProductFromSupplier(productId)
		if err != nil {
			return err
		}
	}
	return nil
}

// Garbage interface
func (r *SupplierRepo) GarbageCollector() {
	now := time.Now()
	for i, p := range r.CachedProduct {
		if p.DeadTime.Before(now) {
			delete(r.CachedProduct, i)
		}
	}
	for i, p := range r.CachedBranch {
		if p.DeadTime.Before(now) {
			delete(r.CachedProduct, i)
		}
	}
	for i, p := range r.CachedSupplier {
		if p.DeadTime.Before(now) {
			delete(r.CachedProduct, i)
		}
	}
}

// Helper func
