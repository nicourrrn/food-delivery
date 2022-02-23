package main

import (
	"food-delivery/pkg/db"
	"food-delivery/pkg/models"
	"food-delivery/pkg/token"
	"github.com/justinas/alice"
	"log"
	"net/http"
	"os"
)

func main() {

	err := Init()
	if err != nil {
		log.Println(err)
		return
	}
	server := ServerSetup()

	log.Println(http.ListenAndServe(":8080", server))
}

func Init() (err error) {
	models.InitModels()
	database, err := db.NewDB(os.Getenv("DB_LOGIN"), os.Getenv("DB_PASSWORD"), os.Getenv("DB_NAME"))
	if err != nil {
		return
	}
	err = db.InitDB(&database)
	if err != nil {
		return
	}
	err = token.InitJwt()
	return
}

func ServerSetup() *http.ServeMux {
	server := http.NewServeMux()
	authorizedMiddleware := alice.New(AuthorizedUser)

	server.HandleFunc("/sign_up", SignUp)
	server.HandleFunc("/sign_in", SignIn)
	server.HandleFunc("/refresh", Refresh)

	server.Handle("/get_me", authorizedMiddleware.ThenFunc(GetMe))
	server.Handle("/get_suppliers", authorizedMiddleware.ThenFunc(GetSupplierList))
	server.Handle("/get_products", authorizedMiddleware.ThenFunc(GetProductList))

	return server
}
