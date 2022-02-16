package models

import "errors"

type Ingredient *string

var ingredients map[int64]Ingredient

func GetIngredients() *map[int64]Ingredient {
	return &ingredients
}

func GetIngredientId(ingredient Ingredient) int64 {
	for k, v := range ingredients {
		if v == ingredient {
			return k
		}
	}
	return 0
}

type ProductType *string

var productTypes map[int64]ProductType

func GetProductTypes() *map[int64]ProductType {
	return &productTypes
}

func GetProductTypeId(productType ProductType) int64 {
	for k, v := range productTypes {
		if v == productType {
			return k
		}
	}
	return 0
}

type Product struct {
	ID                int64
	Supplier          *Supplier
	Price             float32
	Ingredients       []Ingredient
	Name, Description string
	Image             string
	Type              ProductType
}

func NewProduct(name string, price float32, prodType ProductType) (Product, error) {
	if prodType == nil {
		return Product{}, errors.New("product type is nil")
	}
	return Product{Name: name, Price: price, Type: prodType}, nil
}
