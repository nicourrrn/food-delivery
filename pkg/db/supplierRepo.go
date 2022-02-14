package db

import (
	"errors"
	"fmt"
	"food-delivery/pkg/models"
	"log"
	"sync"
	"time"
)

type SupplierRepo struct {
	DB
	CachedSupplier map[int]*struct {
		Supplier *models.Supplier
		DeadTime time.Time
	}
	CachedBranch map[int]*struct {
		Branch   *models.Branch
		DeadTime time.Time
	}
	CachedProduct map[int]*struct {
		Product  *models.Product
		DeadTime time.Time
	}
}

var GlobalSupplierRepo *SupplierRepo

func InitSupplierRepo(db DB, group *sync.WaitGroup) (*SupplierRepo, error) {
	supplierRepo := SupplierRepo{
		DB: db,
		CachedSupplier: make(map[int]*struct {
			Supplier *models.Supplier
			DeadTime time.Time
		}),
		CachedBranch: make(map[int]*struct {
			Branch   *models.Branch
			DeadTime time.Time
		}),
		CachedProduct: make(map[int]*struct {
			Product  *models.Product
			DeadTime time.Time
		}),
	}

	newSupplierTypes, err := supplierRepo.LoadTypes("supplier_types")
	if err != nil {
		return nil, err
	}
	models.UpdateSupplTypes(newSupplierTypes)

	newProductTypes, err := supplierRepo.LoadTypes("products_types")
	if err != nil {
		return nil, err
	}
	models.UpdateProductTypes(newProductTypes)

	newIngredients, err := supplierRepo.LoadTypes("ingredients")
	if err != nil {
		return nil, err
	}
	models.UpdateIngredients(newIngredients)

	GlobalSupplierRepo = &supplierRepo
	return GlobalSupplierRepo, nil
}

func (r *SupplierRepo) LoadUser(id int) (interface{}, error) {
	row := r.Conn.QueryRow("SELECT users.id, users.name, users.login, users.email, ut.name FROM users JOIN users_types ut on users.user_type_id = ut.id WHERE users.id = ?", id)
	user := models.User{}
	var userType string
	row.Scan(user.ID, user.Name, user.Login, user.Email, userType)
	var (
		castedUser interface{}
		err        error
	)
	switch userType {
	case "Supplier":
		castedUser, err = r.LoadSupplier(user)
	case "Branch":
		castedUser, err = r.LoadBranch(user)
	default:
		err = errors.New("user type not found from db")
	}
	return castedUser, err
}

// Branch methods
func (r *SupplierRepo) GetBranch(id int) (*models.Branch, error) {
	if data, ok := r.CachedBranch[id]; !ok {
		_, err := r.LoadUser(id)
		if err != nil {
			return nil, err
		}
		return r.GetBranch(id)
	} else {
		data.DeadTime = time.Now().Add(time.Hour)
		return data.Branch, nil
	}
}
func (r SupplierRepo) LoadBranch(user models.User) (models.Branch, error) {
	row := r.Conn.QueryRow("SELECT coordinate_id, image, open_time, close_time, supplier_id FROM supl_branches WHERE id = ?", user.ID)
	branch := models.Branch{
		User: user,
	}
	var (
		supplId, coordinatesId int
	)
	err := row.Scan(&coordinatesId, &branch.Image, &branch.WorkingHour.Open, &branch.WorkingHour.Close, &supplId)
	if err != nil {
		return models.Branch{}, err
	}
	coordinate, err := GlobalHelperRepo.GetCoordinate(coordinatesId)
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

// Supplier methods
func (r *SupplierRepo) GetSupplier(id int) (*models.Supplier, error) {
	if data, ok := r.CachedSupplier[id]; !ok {
		_, err := r.LoadUserByID(id)
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
	var supplTypeId int
	err := row.Scan(&supplier.Description, &supplTypeId)
	if err != nil {
		return models.Supplier{}, err
	}
	supplier.Type = models.GetSupplType(supplTypeId)
	r.CachedSupplier[user.ID] = &struct {
		Supplier *models.Supplier
		DeadTime time.Time
	}{Supplier: &supplier, DeadTime: time.Now().Add(time.Hour)}
	// TODO вынести время жизни в конфигурацию
	return supplier, nil
}

// Product methods
func (r *SupplierRepo) GetProduct(id int) (*models.Product, error) {
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
func (r *SupplierRepo) LoadProduct(id int) (models.Product, error) {
	// Product getting
	row := r.Conn.QueryRow("SELECT supl_id, name, description, image, price, type_id FROM products WHERE id = ?", id)
	product := models.Product{ID: id}
	var (
		supplierId, typeId int
	)
	err := row.Scan(&supplierId, &product.Name, &product.Description, &product.Image, &product.Price, &typeId)
	if err != nil {
		return models.Product{}, err
	}

	// Product setup
	product.Type, err = models.GetProductType(typeId)
	if err != nil {
		return models.Product{}, err
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
		ingredientId int
		ingredient   models.Ingredient
	)
	for rows.Next() {
		err = rows.Scan(&ingredientId)
		if err != nil {
			return nil, err
		}
		ingredient, err = models.GetIngredient(ingredientId)
		if err != nil {
			return nil, err
		}
		product.Ingredients = append(product.Ingredients, ingredient)
	}
	return product.Ingredients, nil
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
		productId int
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
		productId int
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
	time.Sleep(time.Minute)
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
func (r *SupplierRepo) LoadTypes(tableName string) (map[int]string, error) {
	rows, err := r.Conn.Query(fmt.Sprintf("SELECT id, name FROM %s", tableName))
	if err != nil {
		return nil, err
	}
	var (
		id   int
		name string
	)
	newTypes := make(map[int]string)
	for rows.Next() {
		err = rows.Scan(&id, &name)
		if err != nil {
			return nil, err
		}
		newTypes[id] = name
	}
	return newTypes, nil
}
