package db

import (
	"food-delivery/pkg/models"
	"time"
)

type HelperRepo struct {
	DB
	CachedDevices map[int]*struct {
		Device   *models.Device
		DeadTime time.Time
	}
	CachedCoordinates map[int]*struct {
		Coordinate *models.Coordinate
		DeadTime   time.Time
	}
}

var GlobalHelperRepo HelperRepo

func InitHelperRepo() {
	helperRepo := HelperRepo{
		CachedCoordinates: make(map[int]*struct {
			Coordinate *models.Coordinate
			DeadTime   time.Time
		}),
		CachedDevices: make(map[int]*struct {
			Device   *models.Device
			DeadTime time.Time
		}),
	}
	GlobalHelperRepo = helperRepo
}

// Device methods
func (r *HelperRepo) GetDevice(id int) (*models.Device, error) {
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
func (r *HelperRepo) LoadDevice(id int) (models.Device, error) {
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

// Coordinates methods
func (r *HelperRepo) GetCoordinate(id int) (*models.Coordinate, error) {
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
func (r *HelperRepo) LoadCoordinate(id int) (models.Coordinate, error) {
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
func (r HelperRepo) GetCoordinatesByClient(c *models.Client) ([]*models.Coordinate, error) {
	rows, err := r.Conn.Query("SELECT coordinate_id FROM client_coordinates WHERE client_id = ?", c.ID)
	if err != nil {
		return nil, err
	}
	coordinates := make([]*models.Coordinate, 0)
	var (
		coordinateId int
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
