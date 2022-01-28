package models

type Bucket struct {
	ID, UserID   int
	Address      *Branch
	Client       *struct{}
	CoordinateTo Coordinate
	Paid, Closed bool
	UserPhone    string
	Products     map[*Product]float32 // Product with price
}
