package models

// Branch for Supplier
type Branch struct {
	ID, SupplierID int
	Coordinate     Coordinate
	Image          string
	WorkingHour    struct {
		Open, Close string
	}
	Products []*Product
}
