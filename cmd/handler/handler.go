package main

import (
	"context"
	"encoding/json"
	"food-delivery/pkg/db"
	"food-delivery/pkg/models"
	"food-delivery/pkg/token"
	"log"
	"net/http"
	"time"
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
		user.ID, err = userRepo.SaveClient(&client, tx, ctx)
		if err != nil {
			http.Error(writer, err.Error(), http.StatusConflict)
			return
		}
		keys = token.NewTokenPair(user.ID)
		//case "Supplier:":
	}

	// Return keys
	response := SingUpResponse{}
	response.RefreshToken, response.AccessToken, err = keys.GetStrings()
	if err != nil {
		log.Println(err)
	}

	device, err := user.MakeDevice(request.UserAgent())
	if err != nil {
		log.Println(err)
	}
	device.RefreshKeyHash = response.RefreshToken
	device.LastVisit = time.Now()
	log.Println(device.User.ID, user.ID)
	device.ID, err = db.GetHelperRepo().SaveDevice(device, tx, ctx)

	if err != nil {
		http.Error(writer, err.Error(), http.StatusConflict)
		return
	}

	if err = tx.Commit(); err != nil {
		http.Error(writer, err.Error(), http.StatusConflict)
		return
	}

	err = json.NewEncoder(writer).Encode(response)
	if err != nil {
		log.Println(err)
	}
}

type GetMeResponse struct {
	Name, Email, Login, Type string
}

func GetMe(writer http.ResponseWriter, request *http.Request) {
	if request.Method != http.MethodGet {
		http.Error(writer, "Method not alowed", http.StatusMethodNotAllowed)
	}

	accessToken := request.Header.Get("AccessToken")
	if accessToken == "" {
		http.Error(writer, "Sing up or sing in please", http.StatusLocked)
	}

	claim, err := token.GetClaim(accessToken, token.GetAccess())
	if err != nil {
		http.Error(writer, "Token has expired", http.StatusLocked)
		log.Println(err)
	}
	userType, err := db.GetUserRepo().GetUserType(claim.UserId)
	if err != nil {
		log.Println(err)
	}
	var response GetMeResponse
	switch userType {
	case "Client":
		client, err := db.GetUserRepo().GetClient(claim.UserId)
		if err != nil {
			log.Println(err)
		}

		//TODO вынести в middleware
		devices, err := db.GetHelperRepo().GetDeviceByUser(&client.User)
		if err != nil {
			log.Println(err)
		}
		for i, d := range devices {
			if d.UserAgent == request.UserAgent() {
				devices[i].LastVisit = time.Now()
				break
			}
		}
		client.Devices = devices

		response.Name = client.Name
		response.Email = client.Email
		response.Type = "Client"
		response.Login = client.Login
	}

	err = json.NewEncoder(writer).Encode(response)
	if err != nil {
		http.Error(writer, err.Error(), http.StatusNotAcceptable)
		log.Println(err)
	}

}
