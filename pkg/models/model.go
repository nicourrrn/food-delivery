package models

func InitModels() {
	productTypes = make(map[int64]ProductType)
	supplierTypes = make(map[int64]SupplierType)
	ingredients = make(map[int64]Ingredient)
}
