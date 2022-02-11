package models

import (
	"errors"
)

type ProdWithStatus struct {
	Exist   bool
	Product *Product
}

// Branch for Supplier
type Branch struct {
	User
	Supplier    *Supplier
	Coordinate  Coordinate
	Image       string
	WorkingHour struct {
		Open, Close string
	}
	Products map[int]ProdWithStatus
}

func (b Branch) GetType() string {
	return "Branch"
}

func NewBranch(u User, s *Supplier) (Branch, error) {
	if u.GetType() != "User" {
		return Branch{}, errors.New("var u is not User")
	}
	return Branch{
		Supplier: s,
		Products: make(map[int]ProdWithStatus),
	}, nil
}

func (b *Branch) AddProductFromSupplier(id int) (*Product, error) {
	product, ok := b.Supplier.Products[id]
	if !ok {
		return nil, errors.New("product is exist from supplier")
	}
	b.Products[id] = ProdWithStatus{Exist: true, Product: product}
	return product, nil
}
func (b *Branch) ChangeProductExist(id int) error {
	productInfo, ok := b.Products[id]
	if !ok {
		return errors.New("product not found")
	}
	b.Products[id] = ProdWithStatus{Exist: !productInfo.Exist, Product: productInfo.Product}
	return nil
}
