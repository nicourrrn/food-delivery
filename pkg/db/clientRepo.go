package db

import (
	"food-delivery/pkg/models"
	"time"
)

type ClientRepo struct {
	DB
	CachedClients map[int]*struct {
		Client   *models.Client
		DeadTime time.Time
	}
	CachedBaskets map[int]*struct {
		Basket   *models.Basket
		DeadTime time.Time
	}
}

var GlobalClientRepo *ClientRepo

func InitClientRepo(db DB) *ClientRepo {
	clientRepo := ClientRepo{
		DB: db,
		CachedClients: make(map[int]*struct {
			Client   *models.Client
			DeadTime time.Time
		}),
		CachedBaskets: make(map[int]*struct {
			Basket   *models.Basket
			DeadTime time.Time
		}),
	}
	GlobalClientRepo = &clientRepo
	return GlobalClientRepo
}

// Client methods
func (r *ClientRepo) LoadClient(user models.User) (models.Client, error) {
	row := r.Conn.QueryRow("SELECT phone FROM client_info WHERE user_id = ?", user.ID)
	client := models.Client{User: user}
	err := row.Scan(&client.Phone)
	if err != nil {
		return models.Client{}, err
	}
	GlobalHelperRepo.GetCoordinatesByClient(&client)
	r.CachedClients[user.ID] = &struct {
		Client   *models.Client
		DeadTime time.Time
	}{Client: &client, DeadTime: time.Now().Add(time.Hour)}
	// TODO вынести время жизни в конфигурацию
	return client, nil
}
func (r *ClientRepo) GetClient(id int) (*models.Client, error) {
	if data, ok := r.CachedClients[id]; !ok {
		_, err := LoadUserByID(&r.DB, id)
		if err != nil {
			return nil, err
		}
		return r.GetClient(id)
	} else {
		data.DeadTime = time.Now().Add(time.Hour)
		return data.Client, nil
	}
}

// Basket methods
func (r *ClientRepo) LoadBasket(id int) (models.Basket, error) {
	row := r.Conn.QueryRow("SELECT client_id, coordinates_to_id, paid, closed, editable FROM baskets WHERE id = ?", id)
	basket := models.Basket{
		ID: id,
	}
	var (
		clientId, coordinateToId int
	)
	err := row.Scan(&clientId, &coordinateToId, &basket.Paid, &basket.Closed, &basket.Editable)
	if err != nil {
		return models.Basket{}, err
	}
	basket.CoordinateTo, err = GlobalHelperRepo.GetCoordinate(coordinateToId)
	if err != nil {
		return models.Basket{}, err
	}
	basket.Client, err = r.GetClient(clientId)
	if err != nil {
		return models.Basket{}, err
	}
	_, err = GlobalSupplierRepo.GetProductsForBasket(&basket)
	if err != nil {
		return models.Basket{}, err
	}
	r.CachedBaskets[id] = &struct {
		Basket   *models.Basket
		DeadTime time.Time
	}{Basket: &basket, DeadTime: time.Now().Add(time.Hour)}
	// TODO вынести время жизни в конфигурацию
	return basket, nil
}
func (r *ClientRepo) GetBasket(id int) (*models.Basket, error) {
	if data, ok := r.CachedBaskets[id]; !ok {
		_, err := r.LoadBasket(id)
		if err != nil {
			return nil, err
		}
		return r.GetBasket(id)
	} else {
		data.DeadTime = time.Now().Add(time.Hour)
		return data.Basket, nil
	}
}

// Garbage interface
func (r *ClientRepo) GarbageCollector() {
	now := time.Now()
	for i, b := range r.CachedBaskets {
		if b.DeadTime.Before(now) {
			delete(r.CachedBaskets, i)
		}
	}
	for i, c := range r.CachedClients {
		if c.DeadTime.Before(now) {
			delete(r.CachedClients, i)
		}
	}
}
