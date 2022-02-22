package main

import (
	"context"
	"encoding/json"
	"food-delivery/pkg/db"
	"food-delivery/pkg/models"
	"food-delivery/pkg/token"
	"golang.org/x/crypto/bcrypt"
	"log"
	"net/http"
	"time"
)

type SignUpRequest struct {
	Email        string `json:"email"`
	Login        string `json:"login"`
	Password     string `json:"password"`
	Type         string `json:"type"`
	SupplierType string `json:"supplier_type"`
}

type SignResponse struct {
	AccessToken  string `json:"access_token"`
	RefreshToken string `json:"refresh_token"`
	Error        string `json:"error"`
}

func SignUp(writer http.ResponseWriter, request *http.Request) {
	if request.Method != http.MethodPost {
		http.Error(writer, "Method not alowed", http.StatusMethodNotAllowed)
	}
	userRepo := db.GetUserRepo()
	var body SignUpRequest
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
	response := SignResponse{}
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
	Devices                  []struct {
		UserAgent string
		LastVisit int64
	}
}

func GetMe(writer http.ResponseWriter, request *http.Request) {
	if request.Method != http.MethodGet {
		http.Error(writer, "Method not alowed", http.StatusMethodNotAllowed)
	}

	accessToken := request.Header.Get("AccessToken")
	if accessToken == "" {
		http.Error(writer, "Sing up or sing in please", http.StatusLocked)
		return
	}

	claim, err := token.GetClaim(accessToken, token.GetAccess())
	if err != nil {
		http.Error(writer, err.Error(), http.StatusLocked)
		return
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
			log.Println("Client error", err)
		}

		//TODO вынести в middleware
		devices, err := db.GetHelperRepo().GetDeviceByUser(&client.User)
		if err != nil {
			log.Println("Device error", err)
		}
		for i, d := range devices {
			if d.UserAgent == request.UserAgent() {
				devices[i].LastVisit = time.Now()
			}
			response.Devices = append(response.Devices, struct {
				UserAgent string
				LastVisit int64
			}{UserAgent: d.UserAgent, LastVisit: d.LastVisit.Unix()})
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

type SignInRequest struct {
	Login    string `json:"login"`
	Password string `json:"password"`
}

func SignIn(writer http.ResponseWriter, request *http.Request) {
	if request.Method != http.MethodPost {
		http.Error(writer, "Method not alowed", http.StatusMethodNotAllowed)
		return
	}
	var body SignInRequest
	if err := json.NewDecoder(request.Body).Decode(&body); err != nil {
		http.Error(writer, err.Error(), http.StatusBadRequest)
		return
	}

	userRepo := db.GetUserRepo()
	key := "login"
	for _, char := range body.Login {
		if char == '@' {
			key = "email"
		}
	}
	id, userType, err := userRepo.LoadUser(key, body.Login)
	if err != nil {
		http.Error(writer, err.Error(), http.StatusBadRequest)
		return
	}

	switch userType {
	case "Client":
		client, err := userRepo.GetClient(id)
		if err != nil {
			http.Error(writer, err.Error(), http.StatusNotFound)
			return
		}
		userPassHash, err := userRepo.LoadPassHash(client.ID)
		if err != nil {
			http.Error(writer, err.Error(), http.StatusNotFound)
			return
		}
		err = bcrypt.CompareHashAndPassword([]byte(userPassHash), []byte(body.Password))
		if err != nil {
			http.Error(writer, "Неверный пароль!", http.StatusUnauthorized)
			return
		}
		log.Println("Client id", client.ID)

		var response SignResponse
		response.RefreshToken, response.AccessToken, err = token.NewTokenPair(client.ID).GetStrings()

		err = json.NewEncoder(writer).Encode(response)
		if err != nil {
			log.Println(err)
		}
	}

}
