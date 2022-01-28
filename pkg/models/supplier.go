package models

type Supplier struct {
	ID                int
	Login, Email      string
	Branches          []Branch
	Name, Description string
	Type              *string
	Image             string
	Products          map[int]Product // key -- id for Product
}

func (s Supplier) GetPassHash() {
}
