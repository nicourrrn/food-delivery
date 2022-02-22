package main

import (
	"food-delivery/pkg/db"
	"food-delivery/pkg/models"
	"food-delivery/pkg/token"
	"log"
	"net/http"
	"os"
)

func main() {
	models.InitModels()
	database, err := db.NewDB(os.Getenv("DB_LOGIN"), os.Getenv("DB_PASSWORD"), os.Getenv("DB_NAME"))
	if err != nil {
		log.Println(err)
		return
	}
	err = db.InitDB(&database)
	if err != nil {
		log.Println(err)
		return
	}
	err = token.InitJwt()
	if err != nil {
		log.Println(err)
		return
	}

	server := http.NewServeMux()
	server.HandleFunc("/sign_up", SignUp)
	server.HandleFunc("/sign_in", SignIn)
	server.HandleFunc("/get_me", GetMe)
	server.HandleFunc("/get_suppliers", GetSupplierList)

	log.Println(http.ListenAndServe(":8080", server))
}
