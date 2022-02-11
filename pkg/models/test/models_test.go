package testing

import (
	"food-delivery/pkg/models"
	"github.com/bxcodec/faker/v3"
	"github.com/stretchr/testify/assert"
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
	clientBasket := client.MakeBasket(client.CoordinatesList[0])
	for i := 0; i < 10; i++ {
		prod := data.GetRandProductFromB()
		assert.NotNil(t, prod)
		assert.NoError(t, clientBasket.AddProduct(prod.Product))
	}

}
