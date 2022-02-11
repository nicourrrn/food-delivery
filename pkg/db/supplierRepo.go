package db

import (
	"errors"
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

func InitSupplierRepo(db DB, group *sync.WaitGroup) *SupplierRepo {
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
	log.Println("Supplier repo Garbage Collerctor running")
	group.Add(1)
	go supplierRepo.GarbageCollector(group)
	GlobalSupplierRepo = &supplierRepo
	return GlobalSupplierRepo
}

func (r *SupplierRepo) GetSupplier(id int) (*models.Supplier, error) {
	if data, ok := r.CachedSupplier[id]; !ok {
		_, err := r.LoadByID(id)
		if err != nil {
			return nil, err
		}
		return r.GetSupplier(id)
	} else {
		data.DeadTime = time.Now().Add(time.Hour)
		return data.Supplier, nil
	}
}

func (r *SupplierRepo) GetBranch(id int) (*models.Branch, error) {
	if data, ok := r.CachedBranch[id]; !ok {
		_, err := r.LoadByID(id)
		if err != nil {
			return nil, err
		}
		return r.GetBranch(id)
	} else {
		data.DeadTime = time.Now().Add(time.Hour)
		return data.Branch, nil
	}
}

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

func (r *SupplierRepo) LoadByID(id int) (interface{}, error) {
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
	//TODO дописать получение координат и тд после оформления хелпера

	r.CachedBranch[user.ID] = &struct {
		Branch   *models.Branch
		DeadTime time.Time
	}{Branch: &branch, DeadTime: time.Now().Add(time.Hour)}
	// TODO вынести время жизни в конфигурацию
	return branch, nil
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

	r.CachedProduct[id] = &struct {
		Product  *models.Product
		DeadTime time.Time
	}{Product: &product, DeadTime: time.Now().Add(time.Hour)}
	return product, nil
}

func (r *SupplierRepo) GarbageCollector(group *sync.WaitGroup) {
	defer group.Done()
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
