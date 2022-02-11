package testing

import (
	"food-delivery/pkg/models"
	"github.com/bxcodec/faker/v3"
	"github.com/stretchr/testify/assert"
	"log"
	"math/rand"
	"testing"
)

func TestGenerateFakeData(t *testing.T) {
	data := GenerateFakeData()
	//for _, s := range data.Suppliers {
	//	log.Println(s.Login)
	//}
	client := data.GetRandClient()
	assert.NotNil(t, client)
	c := models.NewCoordinate(faker.Word(), rand.Float64(), rand.Float64())
	client.AddCoordinate(&c)
	clientBasket, err := client.MakeBasket(client.CoordinatesList[0])
	assert.NoError(t, err)
	var lastProduct *models.Product
	for i := 0; i < 10; i++ {
		prod := data.GetRandProductFromB()
		assert.NotNil(t, prod)
		assert.NoError(t, clientBasket.AddProduct(prod.Product))
		lastProduct = prod.Product
	}
	for _, p := range clientBasket.Products {
		log.Println(p.Price)
	}
	beforeCalc := clientBasket.FinalPrice
	clientBasket.CalcFinalPrice()
	assert.Equal(t, beforeCalc, clientBasket.FinalPrice)
	assert.NoError(t, clientBasket.RemoveProduct(lastProduct))
	assert.Equal(t, len(clientBasket.Products), 9)
	branch := data.GetRandBranch()
	keys := make([]int, 0)
	for k, _ := range branch.Products {
		keys = append(keys, k)
	}
	randProdId := keys[rand.Int()%len(keys)]
	beforeChange := branch.Products[randProdId].Exist
	assert.NoError(t, branch.ChangeProductExist(randProdId))
	assert.NotEqual(t, branch.Products[randProdId].Exist, beforeChange)

}
