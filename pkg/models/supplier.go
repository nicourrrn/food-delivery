package models

var SupplierTypes map[int]*string

type Supplier struct {
	User
	Branches    []Branch
	Description string
	Type        *string
	Image       string
	Products    map[int]Product // key -- id for Product
}

func (s Supplier) GetType() string {
	return "Supplier"
}

func (s Supplier) GetPassHash() {
}
