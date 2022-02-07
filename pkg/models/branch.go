package models

import "errors"

// Branch for Supplier
type Branch struct {
	User
	Supplier    *Supplier
	Coordinate  Coordinate
	Image       string
	WorkingHour struct {
		Open, Close string
	}
	Products map[int]struct {
		Exist   bool
		Product *Product
	}
}

func (b Branch) GetType() string {
	return "Branch"
}

func NewBranch(u User, s *Supplier) (Branch, error) {
	if u.GetType() != "User" {
		return Branch{}, errors.New("var u is not User")
	}
	return Branch{Supplier: s, Products: make(map[int]struct {
		Exist   bool
		Product *Product
	})}, nil
}

func (b *Branch) AddProductFromSupplier(id int) (*Product, error) {
	product, ok := b.Supplier.Products[id]
	if !ok {
		return nil, errors.New("product is exist from supplier")
	}
	b.Products[id] = struct {
		Exist   bool
		Product *Product
	}{Exist: true, Product: &product}
	return &product, nil
}
func (b *Branch) ChangeProductExist(id int) error {
	productInfo, ok := b.Products[id]
	if !ok {
		return errors.New("product not found")
	}
	b.Products[id] = struct {
		Exist   bool
		Product *Product
	}{Exist: !productInfo.Exist, Product: productInfo.Product}
	return nil
}
