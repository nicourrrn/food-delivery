package db

import (
	"context"
	"database/sql"
	"food-delivery/pkg/models"
	"strings"
	"time"
)

type HelperRepo struct {
	*DB
	CachedDevices map[int64]*struct {
		Device   *models.Device
		DeadTime time.Time
	}
	CachedCoordinates map[int64]*struct {
		Coordinate *models.Coordinate
		DeadTime   time.Time
	}
}

var globalHelperRepo *HelperRepo

func InitHelperRepo(db *DB) *HelperRepo {
	globalHelperRepo = &HelperRepo{
		DB: db,
		CachedCoordinates: make(map[int64]*struct {
			Coordinate *models.Coordinate
			DeadTime   time.Time
		}),
		CachedDevices: make(map[int64]*struct {
			Device   *models.Device
			DeadTime time.Time
		}),
	}
	return globalHelperRepo
}

func GetHelperRepo() *HelperRepo {
	return globalHelperRepo
}

// Device methods
func (r *HelperRepo) GetDevice(id int64) (*models.Device, error) {
	if data, ok := r.CachedDevices[id]; !ok {
		_, err := r.LoadDevice(id)
		if err != nil {
			return nil, err
		}
		return r.GetDevice(id)
	} else {
		data.DeadTime = time.Now().Add(time.Hour)
		return data.Device, nil
	}
}
func (r *HelperRepo) LoadDevice(id int64) (models.Device, error) {
	row := r.Conn.QueryRow("SELECT user_id, last_visit, user_agent, refresh_key FROM devices WHERE id = ?;", id)
	device := models.Device{
		ID: id,
	}
	var (
		userId int
	)
	err := row.Scan(&userId, &device.LastVisit, &device.UserAgent, &device.RefreshKeyHash)
	if err != nil {
		return models.Device{}, err
	}
	r.CachedDevices[id] = &struct {
		Device   *models.Device
		DeadTime time.Time
	}{Device: &device, DeadTime: time.Now().Add(time.Hour)}
	// TODO вынести время жизни в конфигурацию
	return device, nil
}
func (r *HelperRepo) SaveDevice(device *models.Device, tx *sql.Tx, ctx context.Context) error {
	var (
		args = []interface{}{device.LastVisit, device.RefreshKeyHash}
		id   int64
		err  error
	)
	if device.ID == 0 {
		id, err = Saver{
			Query: "INSERT INTO devices(last_visit, refresh_key, user_id, user_agent) VALUE (?, ?, ?, ?);",
			Args:  append(args, device.User.ID, device.UserAgent),
		}.Save(tx, ctx)
	} else {
		id, err = Saver{
			Query: "UPDATE devices SET last_visit = ?, refresh_key = ? WHERE id = ?;",
			Args:  args,
		}.Save(tx, ctx)
	}
	if err != nil {
		return err
	}
	if device.ID == 0 {
		device.ID = id
	}
	return nil
}

// Coordinates methods
func (r *HelperRepo) GetCoordinate(id int64) (*models.Coordinate, error) {
	if data, ok := r.CachedCoordinates[id]; !ok {
		_, err := r.LoadCoordinate(id)
		if err != nil {
			return nil, err
		}
		return r.GetCoordinate(id)
	} else {
		data.DeadTime = time.Now().Add(time.Hour)
		return data.Coordinate, nil
	}
}
func (r *HelperRepo) LoadCoordinate(id int64) (models.Coordinate, error) {
	row := r.Conn.QueryRow("SELECT name, x, y, humanized FROM coordinates WHERE id = ?;", id)
	coordinate := models.Coordinate{
		ID: id,
	}
	err := row.Scan(&coordinate.Name, &coordinate.X, &coordinate.Y, &coordinate.Humanized)
	if err != nil {
		return models.Coordinate{}, err
	}
	r.CachedCoordinates[id] = &struct {
		Coordinate *models.Coordinate
		DeadTime   time.Time
	}{Coordinate: &coordinate, DeadTime: time.Now().Add(time.Hour)}
	// TODO вынести время жизни в конфигурацию
	return coordinate, nil
}
func (r *HelperRepo) SaveCoordinate(coordinate *models.Coordinate, tx *sql.Tx, ctx context.Context) error {
	var (
		args = []interface{}{coordinate.Name, coordinate.X, coordinate.Y, coordinate.Humanized}
		id   int64
		err  error
	)
	if coordinate.ID == 0 {
		id, err = Saver{
			Query: "INSERT INTO coordinates(name, x, y, humanized) VALUE (?, ?, ?, ?);",
			Args:  args,
		}.Save(tx, ctx)
	} else {
		id, err = Saver{
			Query: "UPDATE coordinates SET name = ?, x = ?, y = ?, humanized = ? WHERE  id = ?;",
			Args:  append(args, coordinate.ID),
		}.Save(tx, ctx)
	}
	if err != nil {
		return err
	}
	if coordinate.ID == 0 {
		coordinate.ID = id
	}
	return nil
}
func (r *HelperRepo) GetCoordinatesByClient(c *models.Client) ([]*models.Coordinate, error) {
	rows, err := r.Conn.Query("SELECT coordinate_id FROM client_coordinates WHERE client_id = ?", c.ID)
	if err != nil {
		return nil, err
	}
	coordinates := make([]*models.Coordinate, 0)
	var (
		coordinateId int64
		coordinate   *models.Coordinate
	)
	for rows.Next() {
		err = rows.Scan(&coordinateId)
		if err != nil {
			return nil, err
		}
		coordinate, err = r.GetCoordinate(coordinateId)
		if err != nil {
			return nil, err
		}
		coordinates = append(coordinates, coordinate)
	}
	c.CoordinatesList = coordinates
	return coordinates, nil
}
func (r *HelperRepo) ConnectCoordinateWithClient(c *models.Client, tx *sql.Tx, ctx context.Context) error {
	saverCoordinates, err := r.GetCoordinatesByClient(c)
	if err != nil {
		return err
	}
	var (
		queryCount = 0
		args       = make([]interface{}, 0)
	)
	for _, coordinate := range c.CoordinatesList {
		exist := false
		for _, savedCoordinate := range saverCoordinates {
			if savedCoordinate == coordinate {
				exist = true
				break
			}
		}
		if exist {
			continue
		}
		queryCount++
		args = append(args, c.ID, coordinate.ID)
	}
	if queryCount == 0 {
		return nil
	}
	_, err = Saver{
		Query: "INSERT INTO client_coordinates(client_id, coordinate_id)  VALUES " + strings.Repeat("(?, ?),", queryCount)[:7*queryCount-1],
		Args:  args,
	}.Save(tx, ctx)
	if err != nil {
		return err
	}
	return nil
}

func (r *HelperRepo) GarbageCollector() {
	now := time.Now()
	for i, p := range r.CachedDevices {
		if p.DeadTime.Before(now) {
			delete(r.CachedDevices, i)
		}
	}
	for i, p := range r.CachedCoordinates {
		if p.DeadTime.Before(now) {
			delete(r.CachedCoordinates, i)
		}
	}
}
