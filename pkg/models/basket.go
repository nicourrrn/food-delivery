package models

import (
	"errors"
)

type Basket struct {
	ID                     int
	FinalPrice             float32
	Client                 *Client
	CoordinateTo           *Coordinate
	Products               []*Product
	Paid, Closed, Editable bool
}

func (b *Basket) AddProduct(product *Product) error {
	if product == nil {
		return errors.New("product is nil")
	}
	b.Products = append(b.Products, product)
	b.FinalPrice += product.Price
	return nil
}

func (b *Basket) CalcFinalPrice() {
	b.FinalPrice = 0
	for _, prod := range b.Products {
		b.FinalPrice += prod.Price
	}
}

func (b *Basket) RemoveProduct(product *Product) error {
	for i := range b.Products {
		if b.Products[i] == product {
			b.Products = append(b.Products[:i], b.Products[i+1:]...)
			return nil
		}
	}
	return errors.New("product not found")
}
