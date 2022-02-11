package db

import (
	"food-delivery/pkg/models"
	"time"
)

type HelperRepo struct {
	DB
	CachedDevices map[int]struct {
		Supplier *models.Device
		DeadTime time.Time
	}
	CachedCoordinates map[int]struct {
		Branch   *models.Coordinate
		DeadTime time.Time
	}
}
