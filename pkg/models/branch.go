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
	Products map[int64]ProdWithStatus
}

func NewBranch(u User, s *Supplier) (Branch, error) {
	return Branch{
		User:     u,
		Supplier: s,
		Products: make(map[int64]ProdWithStatus),
	}, nil
}

func (b *Branch) AddProductFromSupplier(id int64, isExist bool) (*Product, error) {
	product, ok := b.Supplier.Products[id]
	if !ok {
		return nil, errors.New("product is exist from supplier")
	}
	b.Products[id] = ProdWithStatus{Exist: true, Product: product}
	return product, nil
}
func (b *Branch) ChangeProductExist(id int64) error {
	productInfo, ok := b.Products[id]
	if !ok {
		return errors.New("product not found")
	}
	b.Products[id] = ProdWithStatus{Exist: !productInfo.Exist, Product: productInfo.Product}
	return nil
}

func (b Branch) GetUser() User {
	return b.User
}
