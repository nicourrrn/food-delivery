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

	models.InitModels()
	assert.NoError(t, db.InitDB(&newDB))

	suppTypes := *models.GetSupplierTypes()
	suppl, err := models.NewSupplier(getFullUser(), suppTypes[1])
	assert.NoError(t, err)

	ctx := context.Background()
	tx, err := newDB.Conn.BeginTx(ctx, nil)

	assert.NoError(t, err)
	assert.NoError(t, db.GetUserRepo().SaveSupplier(&suppl, tx, ctx))

	branch, err := suppl.MakeBranch(getFullUser())
	assert.NoError(t, err)

	branch.WorkingHour.Open = "10:10"
	branch.WorkingHour.Close = "21:10"
	branch.Coordinate = models.NewCoordinate(faker.Name(), rand.Float64(), rand.Float64())

	assert.NoError(t, db.GetHelperRepo().SaveCoordinate(&branch.Coordinate, tx, ctx))
	assert.NoError(t, db.GetUserRepo().SaveBranch(branch, tx, ctx))

	prodTypes := *models.GetProductTypes()
	p, err := models.NewProduct(faker.Name(), rand.Float32(), prodTypes[1])
	assert.NoError(t, err)

	product, err := suppl.AddProduct(p)
	assert.NoError(t, err)

	product.ID, err = db.GetProductRepo().SaveProduct(product, tx, ctx)
	log.Println(product.ID, product.Name)
	assert.NoError(t, err)

	for i := 0; i < 3; i++ {
		ing := faker.Word()
		if contain(&ing, product.Ingredients) {
			continue
		}
		product.Ingredients = append(product.Ingredients, &ing)
	}

	assert.NoError(t, db.GetProductRepo().SaveIngredients(product.Ingredients, tx, ctx))
	//for _, i := range product.Ingredients {
	//	log.Print(*i)
	//}
	//ings := *models.GetIngredients()
	//for k, v := range ings {
	//	log.Println(k, *v)
	//}

	assert.NoError(t, db.GetProductRepo().ConnectProductWithIngredient(*product, tx, ctx))

	assert.NoError(t, tx.Commit())
}

func getFullUser() models.User {
	user, _ := models.NewUser(faker.Username(), faker.Password())
	user.Email = faker.Email()
	user.Name = faker.Name()
	return user
}

func contain(s models.Ingredient, arr []models.Ingredient) bool {
	for _, i := range arr {
		if i == s {
			return true
		}
	}
	return false
}
