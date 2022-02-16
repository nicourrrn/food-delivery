package db

import (
	"context"
	"database/sql"
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

func (r *ClientRepo) AddClient(client models.Client) {
	r.CachedClients[client.ID] = &struct {
		Client   *models.Client
		DeadTime time.Time
	}{Client: &client, DeadTime: time.Now().Add(time.Hour)}
}

// Client methods
func (r *ClientRepo) loadClient(user models.User) (models.Client, error) {
	row := r.Conn.QueryRow("SELECT phone FROM client_info WHERE user_id = ?", user.ID)
	if row.Err() != nil {
		return models.Client{}, row.Err()
	}
	client := models.Client{User: user}
	err := row.Scan(&client.Phone)
	if err != nil {
		return models.Client{}, err
	}
	_, err = globalHelperRepo.GetCoordinatesByClient(&client)
	if err != nil {
		return models.Client{}, err
	}
	r.AddClient(client)
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
func (r *ClientRepo) SaveClient(client *models.Client, tx *sql.Tx, ctx context.Context) error {
	typedUser := models.TypedUser(client)
	newId, err := SaveUser(&typedUser, tx, ctx)
	if err != nil {
		return err
	}
	var (
		args  = []interface{}{client.Phone, client.ID}
		saver Saver
	)
	if client.ID == 0 {
		saver = Saver{
			Query: "INSERT INTO client_info(phone, user_id) VALUE (?, ?);",
			Args:  args,
		}
	} else {
		saver = Saver{
			Query: "UPDATE client_info SET phone = ? WHERE user_id = ?;",
			Args:  args,
		}
	}
	client.ID = newId
	_, err = saver.Save(tx, ctx)
	if err != nil {
		return err
	}
	err = globalHelperRepo.ConnectCoordinateWithClient(client, tx, ctx)
	return err
}

// Basket methods
func (r *ClientRepo) loadBasket(id int64) (models.Basket, error) {
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
func (r *ClientRepo) SaveBasket(basket *models.Basket, tx *sql.Tx, ctx context.Context) error {
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
	id, err := saver.Save(tx, ctx)
	if err != nil {
		return err
	}
	err = globalHelperRepo.SaveCoordinate(basket.CoordinateTo, tx, ctx)
	if basket.ID == 0 {
		basket.ID = id
	}
	return err
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
