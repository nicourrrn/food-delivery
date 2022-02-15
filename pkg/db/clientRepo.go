package db

import (
	"context"
	"food-delivery/pkg/models"
	"strconv"
	"time"
)

type ClientRepo struct {
	*DB
	CachedClients map[int64]*struct {
		Client   *models.Client
		DeadTime time.Time
	}
	CachedBaskets map[int64]*struct {
		Basket   *models.Basket
		DeadTime time.Time
	}
}

var globalClientRepo *ClientRepo

func InitClientRepo(db *DB) *ClientRepo {
	globalClientRepo = &ClientRepo{
		DB: db,
		CachedClients: make(map[int64]*struct {
			Client   *models.Client
			DeadTime time.Time
		}),
		CachedBaskets: make(map[int64]*struct {
			Basket   *models.Basket
			DeadTime time.Time
		}),
	}
	return globalClientRepo
}
func GetClientRepo() *ClientRepo {
	return globalClientRepo
}

// Client methods
func (r *ClientRepo) LoadClient(user models.User) (models.Client, error) {
	row := r.Conn.QueryRow("SELECT phone FROM client_info WHERE user_id = ?", user.ID)
	client := models.Client{User: user}
	err := row.Scan(&client.Phone)
	if err != nil {
		return models.Client{}, err
	}
	globalHelperRepo.GetCoordinatesByClient(&client)
	r.CachedClients[user.ID] = &struct {
		Client   *models.Client
		DeadTime time.Time
	}{Client: &client, DeadTime: time.Now().Add(time.Hour)}
	// TODO вынести время жизни в конфигурацию
	return client, nil
}
func (r *ClientRepo) GetClient(id int64) (*models.Client, error) {
	if data, ok := r.CachedClients[id]; !ok {
		_, err := LoadUser(r.DB, "id", strconv.FormatInt(id, 10))
		if err != nil {
			return nil, err
		}
		return r.GetClient(id)
	} else {
		data.DeadTime = time.Now().Add(time.Hour)
		return data.Client, nil
	}
}
func (r *ClientRepo) SaveClient(client models.Client) error {
	ctx := context.Background()
	tx, err := r.Conn.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	err = SaveUser(r.DB, &client.User, tx, ctx)
	if err != nil {
		return err
	}
	var (
		args = []interface{}{client.Phone, client.ID}
		id   int64
	)
	if client.ID != 0 {
		id, err = Saver{
			Query: "INSERT INTO client_info(phone, user_id) VALUE (?, ?);",
			Args:  args,
		}.Save(r.DB, tx, ctx)
	} else {
		id, err = Saver{
			Query: "UPDATE client_info SET phone = ? WHERE user_id = ?;",
			Args:  args,
		}.Save(r.DB, tx, ctx)
	}
	for _, coordinate := range client.CoordinatesList {
		err = globalHelperRepo.SaveCoordinate(coordinate)
		if err != nil {
			return err
		}
	}

	if err != nil {
		return err
	}
	if client.ID == 0 {
		client.ID = id
	}
	return nil
}

// Basket methods
func (r *ClientRepo) LoadBasket(id int64) (models.Basket, error) {
	row := r.Conn.QueryRow("SELECT client_id, coordinates_to_id, paid, closed, editable FROM baskets WHERE id = ?", id)
	basket := models.Basket{
		ID: id,
	}
	var (
		clientId, coordinateToId int64
	)
	err := row.Scan(&clientId, &coordinateToId, &basket.Paid, &basket.Closed, &basket.Editable)
	if err != nil {
		return models.Basket{}, err
	}
	basket.CoordinateTo, err = globalHelperRepo.GetCoordinate(coordinateToId)
	if err != nil {
		return models.Basket{}, err
	}
	basket.Client, err = r.GetClient(clientId)
	if err != nil {
		return models.Basket{}, err
	}
	_, err = globalSupplierRepo.GetProductsForBasket(&basket)
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
func (r *ClientRepo) GetBasket(id int64) (*models.Basket, error) {
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
func (r *ClientRepo) SaveBasket(basket *models.Basket) error {
	ctx := context.Background()
	tx, err := r.Conn.BeginTx(ctx, nil)
	if err != nil {
		return err
	}
	var (
		args = []interface{}{basket.Paid, basket.Closed, basket.Editable}
		id   int64
	)
	if basket.ID != 0 {
		id, err = Saver{
			Query: "INSERT INTO baskets(paid, closed, editable, client_id, coordinates_to_id) VALUE (?, ?, ?, ?, ?);",
			Args:  append(args, basket.Client.ID, basket.CoordinateTo.ID),
		}.Save(r.DB, tx, ctx)
	} else {
		id, err = Saver{
			Query: "UPDATE baskets SET paid = ?, closed = ?, editable = ?, final_price = ? WHERE id = ?;",
			Args:  append(args, basket.FinalPrice, basket.ID),
		}.Save(r.DB, tx, ctx)
	}
	if err != nil {
		return err
	}
	if basket.ID == 0 {
		basket.ID = id
	}
	return nil
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
