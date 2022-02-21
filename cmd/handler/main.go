package main

import (
	"food-delivery/pkg/db"
	"food-delivery/pkg/models"
	"food-delivery/pkg/token"
	"log"
	"net/http"
)

func main() {
	models.InitModels()
	database, err := db.NewDB("student", "Stud_21g", "test_delivery")
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
	server.HandleFunc("/sing_up", SingUp)
	log.Println(http.ListenAndServe(":8080", server))
}
