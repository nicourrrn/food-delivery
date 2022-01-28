package models

// Branch for Supplier
type Branch struct {
	ID          int
	Supplier    *Supplier
	Coordinate  Coordinate
	Image       string
	WorkingHour struct {
		Open, Close string
	}
	Products []*Product
	Devices  []*Device
}
