package models

import "errors"

type Ingredient *string

var ingredients map[int64]Ingredient

func GetIngredient(id int64) (Ingredient, error) {
	ing, ok := ingredients[id]
	if !ok {
		return nil, errors.New("ingredient not found")
	}
	return ing, nil
}
func UpdateIngredients(newTypes map[int64]string) {
	ingredients = make(map[int64]Ingredient)
	for id, str := range newTypes {
		ingredients[id] = &str
	}
}

func GetIngredients() map[int64]Ingredient {
	return ingredients
}

type ProductType *string

var productTypes map[int64]ProductType

func GetProductType(id int64) (ProductType, error) {
	productType, ok := productTypes[id]
	if !ok {
		return nil, errors.New("product not found")
	}
	return productType, nil
}
func UpdateProductTypes(newTypes map[int64]string) {
	productTypes = make(map[int64]ProductType)
	for id, str := range newTypes {
		productTypes[id] = &str
	}
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
	ID       int64
	Supplier *Supplier
	Price    float32
	// TODO переписать на отдельный тип Ингредиент
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
