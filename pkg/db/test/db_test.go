package test

import (
	"context"
	"food-delivery/pkg/db"
	"food-delivery/pkg/models"
	"github.com/bxcodec/faker/v3"
	"github.com/stretchr/testify/assert"
	"log"
	"math/rand"
	"os"
	"testing"
)

func TestInit(t *testing.T) {
	models.InitModels()
	newDB, err := db.NewDB(os.Getenv("DB_LOGIN"), os.Getenv("DB_PASSWORD"), os.Getenv("DB_NAME"))
	assert.NoError(t, err)

	models.InitModels()
	assert.NoError(t, db.InitDB(&newDB))

	suppTypes := *models.GetSupplierTypes()
	suppl, err := models.NewSupplier(getFullUser(), suppTypes[4])
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

	branch.Coordinate.ID, err = db.GetHelperRepo().SaveCoordinate(branch.Coordinate, tx, ctx)
	assert.NoError(t, err)
	assert.NoError(t, db.GetUserRepo().SaveBranch(branch, tx, ctx))

	prodTypes := *models.GetProductTypes()
	p, err := models.NewProduct(faker.Name(), rand.Float32(), prodTypes[3])
	assert.NoError(t, err)

	assert.NoError(t, err)
	assert.NoError(t, err)
	product, err := suppl.AddProduct(p)
	log.Println(product.ID)

	newProductId, err := db.GetProductRepo().SaveProduct(product, tx, ctx)
	assert.NoError(t, err)
	delete(suppl.Products, product.ID)
	product.ID = newProductId
	suppl.Products[product.ID] = product
	_, err = branch.AddProductFromSupplier(product.ID, false)
	assert.NoError(t, err)

	for i := 0; i < 3; i++ {
		ing := faker.Word()
		if contain(&ing, product.Ingredients) {
			continue
		}
		product.Ingredients = append(product.Ingredients, &ing)
	}

	assert.NoError(t, db.GetProductRepo().SaveIngredients(product.Ingredients, tx, ctx))
	assert.NoError(t, db.GetProductRepo().ConnectProductWithIngredient(*product, tx, ctx))

	log.Println(branch.Products)
	assert.NoError(t, db.GetProductRepo().ConnectBranchWithProducts(*branch, tx, ctx))

	client := models.NewClient(getFullUser())
	client.ID, err = db.GetUserRepo().SaveClient(&client, tx, ctx)
	assert.NoError(t, err)

	clientHome := models.NewCoordinate("home", rand.Float64(), rand.Float64())
	client.AddCoordinate(&clientHome)

	clientHome.ID, err = db.GetHelperRepo().SaveCoordinate(clientHome, tx, ctx)
	assert.NoError(t, err)
	assert.NoError(t, db.GetHelperRepo().ConnectCoordinateWithClient(&client, tx, ctx))

	clientBasket, err := client.MakeBasket(&clientHome)
	clientBasket.ID, err = db.GetProductRepo().SaveBasket(&clientBasket, tx, ctx)
	assert.NoError(t, err)

	assert.NoError(t, clientBasket.AddProduct(product))
	assert.NoError(t, db.GetProductRepo().ConnectBasketWithProducts(&clientBasket, tx, ctx))

	device, err := client.MakeDevice("Mozilla")
	assert.NoError(t, err)
	device.ID, err = db.GetHelperRepo().SaveDevice(device, tx, ctx)
	assert.NoError(t, err)

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
