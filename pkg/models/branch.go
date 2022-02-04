package models

// Branch for Supplier
type Branch struct {
	User
	Supplier    *Supplier
	Coordinate  Coordinate
	Image       string
	WorkingHour struct {
		Open, Close string
	}
	Products map[*Product]bool
}

func (b Branch) GetType() string {
	return "Branch"
}
