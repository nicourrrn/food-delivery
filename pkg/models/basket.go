package models

type Basket struct {
	ID                     int
	FinalPrice             float32
	Client                 *Client
	Branch                 *Branch
	CoordinateTo           *Coordinate
	Products               []*Product
	Paid, Closed, Editable bool
}
