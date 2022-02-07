package testing

import (
	"fmt"
	. "food-delivery/pkg/models"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestUser(t *testing.T) {
	user1, _ := NewUser("nicourrn", "200303")
	user2, _ := NewUser("diRayz", "199603")
	user3, _ := NewUser("randomName", "falshdfjh")
	userList := []User{user1, user2, user3}
	for _, u := range userList {
		assert.Equal(t, u.GetType(), "User")
		fmt.Println(u.PassHash)
	}
}
func TestSupplier(t *testing.T) {
	UpdateSupplTypes(map[int]string{
		0: "coffee", 1: "bar", 2: "hookan",
	})

	user, _ := NewUser("atb", "200303")
	branchUser, _ := NewUser("1atb", "2222222222")
	supl, _ := NewSupplier(user, GetSupplType(0))
	branch, _ := supl.MakeBranch(branchUser)

	pType, _ := GetProductType(2)
	product, _ := NewProduct("Лютый калик", 180, pType)
	supl.AddProduct(product)
	productS, _ := branch.AddProductFromSupplier(product.ID)
	branch.ChangeProductExist(productS.ID)
	assert.False(t, branch.Products[product.ID].Exist)
}
