package testing

import (
	"food-delivery/pkg/models"
	"github.com/bxcodec/faker/v3"
	"log"
	"math/rand"
	"time"
)

type FakeData struct {
	Suppliers []models.Supplier
	//Branches  []models.Branch
	Clients []models.Client
}

func GenerateFakeData() FakeData {
	data := FakeData{
		Suppliers: make([]models.Supplier, 0),
		Clients:   make([]models.Client, 0),
	}
	rand.Seed(time.Now().Unix())
	var (
		hookah = "hookah"
		sport  = "sport"
		smoke  = "smoke"
		box    = "box"
	)
	*models.GetSupplierTypes() = map[int64]models.SupplierType{
		1: models.SupplierType(&hookah),
		2: models.SupplierType(&sport),
	}
	*models.GetProductTypes() = map[int64]models.ProductType{
		1: models.ProductType(&smoke),
		2: models.ProductType(&box),
	}
	ing := make(map[int64]models.Ingredient)
	var i int64
	for i = 0; i < 10; i++ {
		word := faker.Word()
		ing[i] = &word
	}
	*models.GetIngredients() = ing

	for i := 0; i < 10; i++ {
		user, err := models.NewUser(faker.Username(), faker.Password())
		if err != nil {
			log.Fatalln(err)
		}
		//log.Println(user.Name)
		suppl, err := models.NewSupplier(user, (*models.GetSupplierTypes())[int64(rand.Int()%2+1)])
		if err != nil {
			log.Fatalln(err)
		}
		for j := 0; j < 6; j++ {
			pType, ok := (*models.GetProductTypes())[int64(rand.Int()%2+1)]
			if !ok {
				log.Fatalln("prod fatal")
			}
			prod, err := models.NewProduct(faker.Name(), rand.Float32(), pType)
			if err != nil {
				log.Fatalln(err)
			}
			prod.ID = int64(j)
			prodPrt, err := suppl.AddProduct(prod)
			if err != nil {
				log.Fatalln(err)
			}

			ingredient, ok := (*models.GetIngredients())[int64(rand.Int()%10)]
			if !ok {
				log.Fatalln("ing fatal")
			}
			prodPrt.Ingredients = append(prodPrt.Ingredients, ingredient)
		}
		for j := 0; j < 3; j++ {
			user, err = models.NewUser(faker.Username(), faker.Password())
			if err != nil {
				log.Fatalln(err)
			}
			branch, err := suppl.MakeBranch(user)
			if err != nil {
				log.Fatalln(err)
			}
			for c := 0; c < 2; c++ {
				prodPtr, err := branch.AddProductFromSupplier(int64(rand.Int() % 6))
				if err != nil {
					log.Fatalln(err)
				}

				ingredients := make([]string, 0)
				for _, ing := range prodPtr.Ingredients {
					ingredients = append(ingredients, *ing)
				}
				//log.Printf("Product ingredient: %s", strings.Join(ingredients, " "))
				err = branch.ChangeProductExist(prodPtr.ID)
				if err != nil {
					log.Fatalln(err)
				}
			}
		}
		data.Suppliers = append(data.Suppliers, suppl)
	}
	for i := 0; i < 3; i++ {
		user, err := models.NewUser(faker.Username(), faker.Password())
		if err != nil {
			log.Fatalln(err)
		}
		client := models.NewClient(user)
		data.Clients = append(data.Clients, client)
	}
	return data
}

func (d *FakeData) GetRandClient() *models.Client {
	return &d.Clients[rand.Int()%len(d.Clients)]
}
func (d *FakeData) GetRandSupplier() *models.Supplier {
	return &d.Suppliers[rand.Int()%len(d.Suppliers)]
}
func (d *FakeData) GetRandBranch() *models.Branch {
	s := d.GetRandSupplier()
	branch, _ := s.Branches[int64(rand.Int()%len(s.Branches))]
	return branch
}
func (d FakeData) GetRandProductFromB() models.ProdWithStatus {
	b := d.GetRandBranch()
	products := make([]models.ProdWithStatus, 0)
	for _, v := range b.Products {
		products = append(products, v)
	}
	prod := products[rand.Int()%len(products)]
	return prod
}
