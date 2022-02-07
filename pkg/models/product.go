package models

import "errors"

type Ingredient *string

var ingredients map[int]Ingredient

func GetIngredientById(id int) (Ingredient, error) {
	ing, ok := ingredients[id]
	if !ok {
		return nil, errors.New("ingredient not found")
	}
	return ing, nil
}
func UpdateIngredients(newTypes map[int]string) {
	ingredients = make(map[int]Ingredient)
	for id, str := range newTypes {
		ingredients[id] = &str
	}
}

type ProductType *string

var productTypes map[int]ProductType

func GetProductType(id int) (ProductType, error) {
	productType, ok := productTypes[id]
	if !ok {
		return nil, errors.New("ingredient not found")
	}
	return productType, nil
}
func UpdateProductTypes(newTypes map[int]string) {
	productTypes = make(map[int]ProductType)
	for id, str := range newTypes {
		productTypes[id] = &str
	}
}

type Product struct {
	ID                int
	Supplier          *Supplier
	Price             float32
	Ingredients       []*string
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
