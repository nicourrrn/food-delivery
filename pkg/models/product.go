package models

type Product struct {
	ID, SupplierID    int
	Price             float32
	Ingredients       []*string
	Name, Description string
	Image             string
	Type              string
}
