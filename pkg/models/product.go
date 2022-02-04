package models

var Ingredients map[int]*string
var ProductTypes map[int]*string

type Product struct {
	ID                int
	Supplier          *Supplier
	Price             float32
	Ingredients       []*string
	Name, Description string
	Image             string
	Type              *string
}
