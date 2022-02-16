package test

import (
	"context"
	"food-delivery/pkg/db"
	"food-delivery/pkg/models"
	"github.com/bxcodec/faker/v3"
	"github.com/stretchr/testify/assert"
	"log"
	"math/rand"
	"testing"
)

func TestInit(t *testing.T) {
	newDB, err := db.NewDB("student", "Stud_21g", "test_delivery")
	assert.NoError(t, err)
	assert.NoError(t, db.InitDB(&newDB))
	ctx := context.Background()
	tx, err := newDB.Conn.BeginTx(ctx, nil)
	assert.NoError(t, err)
	assert.NoError(t, db.InitDB(&newDB))
	log.Println(*models.GetSupplierTypes())
	fake := GenerateFakeData()
	*models.GetIngredients() = make(map[int64]models.Ingredient, 0)
	for _, client := range fake.Clients {
		client.ID = 0
		err = db.GetClientRepo().SaveClient(client, tx, ctx)
		assert.NoError(t, err)
	}
	assert.NoError(t, tx.Commit())
	tx, err = newDB.Conn.BeginTx(ctx, nil)
	assert.NoError(t, err)
	for _, supplier := range fake.Suppliers {
		supplier.ID = 0
		assert.NoError(t, db.GetSupplierRepo().SaveSupplier(supplier, tx, ctx))
		for _, product := range supplier.Products {
			for _, ingredient := range product.Ingredients {
				if models.GetIngredientId(ingredient) < 100 {
					log.Println(models.GetIngredientId(ingredient))
					delete(*models.GetIngredients(), models.GetIngredientId(ingredient))
				}
				if models.GetIngredientId(ingredient) == 0 {
					assert.NoError(t, db.GetSupplierRepo().SaveIngredient(ingredient, tx, ctx))
				}
			}
			product.ID = 0
			assert.NoError(t, db.GetSupplierRepo().SaveProduct(product, tx, ctx))
		}
		for _, branch := range supplier.Branches {
			assert.NoError(t, db.GetSupplierRepo().SaveBranch(branch, tx, ctx))
		}
	}
	assert.NoError(t, tx.Commit())
}

func getFullUser() models.User {
	user, _ := models.NewUser(faker.Username(), faker.Password())
	user.Email = faker.Email()
	user.Name = faker.Name()
	return user
}

func TestSave(t *testing.T) {
	database, err := db.NewDB("student", "Stud_21g", "test_delivery")
	assert.NoError(t, err)
	assert.NoError(t, db.InitDB(&database))
	sTypes := *models.GetSupplierTypes()
	id := int64(rand.Int() % (len(sTypes) - 1))
	sType, _ := sTypes[id+1]
	supplier, err := models.NewSupplier(getFullUser(), sType)
	assert.NoError(t, err)
	supplier.Description = faker.Date()
	pTypes := *models.GetProductTypes()
	product, err := models.NewProduct(faker.Name(), rand.Float32(), pTypes[int64(rand.Int()%len(pTypes))])
	assert.NoError(t, err)
	productSuppl, err := supplier.AddProduct(product)
	assert.NoError(t, err)
	ctx := context.Background()
	tx, err := database.Conn.BeginTx(ctx, nil)
	assert.NoError(t, err)
	for i := 0; i < 5; i++ {
		ing := faker.Word()
		assert.NoError(t, db.GetSupplierRepo().SaveIngredient(&ing, tx, ctx))
		productSuppl.Ingredients = append(productSuppl.Ingredients, &ing)
	}
	assert.NoError(t, db.GetSupplierRepo().SaveSupplier(&supplier, tx, ctx))
	assert.NoError(t, db.GetSupplierRepo().SaveProduct(productSuppl, tx, ctx))

}
