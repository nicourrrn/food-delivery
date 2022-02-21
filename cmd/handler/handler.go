package main

import (
	"context"
	"encoding/json"
	"food-delivery/pkg/db"
	"food-delivery/pkg/models"
	"food-delivery/pkg/token"
	"log"
	"net/http"
)

type SingUpRequest struct {
	Email        string `json:"email"`
	Login        string `json:"login"`
	Password     string `json:"password"`
	Type         string `json:"type"`
	SupplierType string `json:"supplier_type"`
}

type SingUpResponse struct {
	AccessToken  string `json:"access_token"`
	RefreshToken string `json:"refresh_token"`
	Error        string `json:"error"`
}

func SingUp(writer http.ResponseWriter, request *http.Request) {
	if request.Method != http.MethodPost {
		http.Error(writer, "Method not alowed", http.StatusMethodNotAllowed)
	}
	userRepo := db.GetUserRepo()
	var body SingUpRequest
	err := json.NewDecoder(request.Body).Decode(&body)
	if err != nil {
		http.Error(writer, err.Error(), http.StatusNotAcceptable)
	}
	// Проверка на занятость
	id, _, err := userRepo.LoadUser("email", body.Email)
	if err != nil {
		log.Println(err)
	}
	if id != 0 {
		http.Error(writer, "email занят", http.StatusNotAcceptable)
	}
	id, _, err = userRepo.LoadUser("login", body.Login)
	if err != nil {
		log.Println(err)
	}
	if id != 0 {
		http.Error(writer, "email занят", http.StatusNotAcceptable)
	}

	// регистрация

	user, err := models.NewUser(body.Login, body.Password)
	if err != nil {
		log.Println(err)
	}
	user.Email = body.Email

	ctx := context.Background()
	tx, err := userRepo.Conn.BeginTx(ctx, nil)
	if err != nil {
		log.Println(err)
	}
	var keys token.TokenPair
	switch body.Type {
	case "Client":
		client := models.NewClient(user)
		client.ID, err = userRepo.SaveClient(&client, tx, ctx)
		keys = token.NewTokenPair(client.ID)
		//case "Supplier:":
	}

	// Return keys
	refresh, access, err := keys.GetStrings()
	if err != nil {
		log.Println(err)
	}
	response := SingUpResponse{
		RefreshToken: refresh,
		AccessToken:  access,
	}
	err = json.NewEncoder(writer).Encode(response)
	if err != nil {
		log.Println(err)
	}
}
