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

type SignResponse struct {
	AccessToken  string `json:"access_token"`
	RefreshToken string `json:"refresh_token"`
}

type SignUpRequest struct {
	Email        string `json:"email"`
	Login        string `json:"login"`
	Password     string `json:"password"`
	Type         string `json:"type"`
	SupplierType string `json:"supplier_type"`
}

func SignUp(writer http.ResponseWriter, request *http.Request) {
	if request.Method != http.MethodPost {
		http.Error(writer, "Method not alowed", http.StatusMethodNotAllowed)
	}
	userRepo := db.GetUserRepo()
	var body SignUpRequest
	err := json.NewDecoder(request.Body).Decode(&body)
	if err != nil {
		http.Error(writer, err.Error(), http.StatusBadRequest)
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
		if err != nil {
			http.Error(writer, err.Error(), http.StatusConflict)
			return
		}
		keys = token.NewTokenPair(client.ID)
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
	device.ID, err = db.GetHelperRepo().SaveDevice(device, tx, ctx)

	if err = tx.Commit(); err != nil {
		log.Println(err)
	}

	log.Println(json.NewEncoder(writer).Encode(response))
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
		log.Println(err)
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
		log.Println(err)
	}

	var user *models.User

	switch userType {
	case "Client":
		client, err := userRepo.GetClient(id)
		if err != nil {
			http.Error(writer, err.Error(), http.StatusNotFound)
			return
		}

		user = &client.User
	}

	userPassHash, err := userRepo.LoadPassHash(user.ID)
	if err != nil {
		log.Println(err)
	}

	err = bcrypt.CompareHashAndPassword([]byte(userPassHash), []byte(body.Password))
	if err != nil {
		log.Println(err)
	}

	var response SignResponse
	response.RefreshToken, response.AccessToken, err = token.NewTokenPair(user.ID).GetStrings()

	if err != nil {
		log.Println(err)
	}

	user.Devices, err = db.GetHelperRepo().GetDeviceByUser(user)
	if err != nil {
		log.Println(err)
	}

	var device *models.Device
	for _, d := range user.Devices {
		if d.UserAgent == request.UserAgent() {
			device = &d
			break
		}
	}
	if device == nil {
		device, err = user.MakeDevice(request.UserAgent())
		if err != nil {
			log.Println(err)
		}
	}

	device.RefreshKeyHash = response.RefreshToken
	device.LastVisit = time.Now()

	ctx := context.Background()
	tx, err := db.GetHelperRepo().Conn.BeginTx(ctx, nil)
	if err != nil {
		log.Println(err)
	}

	_, err = db.GetHelperRepo().SaveDevice(device, tx, ctx)
	if err != nil {
		log.Println(err)
	}
	if err = tx.Commit(); err != nil {
		log.Println(err)
	}

	err = json.NewEncoder(writer).Encode(response)
	if err != nil {
		log.Println(err)
	}
}

type RefreshRequest struct {
	RefreshToken string `json:"refresh_token"`
	AccessToken  string `json:"access_token"`
}

func Refresh(writer http.ResponseWriter, request *http.Request) {
	if request.Method != http.MethodPost {
		http.Error(writer, "Not allowed", http.StatusMethodNotAllowed)
		return
	}

	var body RefreshRequest
	err := json.NewDecoder(request.Body).Decode(&body)
	if err != nil {
		http.Error(writer, "", http.StatusBadRequest)
		return
	}

	pair, err := token.NewTokenPairFromStrings(body.RefreshToken, body.AccessToken)
	if err != nil {
		http.Error(writer, err.Error(), http.StatusBadRequest)
		return
	}

	refreshNotNil := pair.RefreshToken.UserId == 0
	accessNotNil := pair.AccessToken.UserId == 0
	idEquals := pair.AccessToken.UserId != pair.RefreshToken.UserId
	if refreshNotNil && accessNotNil && idEquals {
		http.Error(writer, "error tokens", http.StatusBadRequest)
		return
	}

	userId := pair.RefreshToken.UserId
	userType, err := db.GetUserRepo().GetUserType(userId)
	if err != nil {
		http.Error(writer, err.Error(), http.StatusNotFound)
		return
	}

	var user *models.User

	switch userType {
	case "Client":
		client, err := db.GetUserRepo().GetClient(userId)
		if err != nil {
			log.Println(err)
		}
		user = &client.User
	}

	user.Devices, err = db.GetHelperRepo().GetDeviceByUser(user)
	if err != nil {
		http.Error(writer, err.Error(), http.StatusNotFound)
		return
	}
	var response SignResponse

	for i, dev := range user.Devices {
		if dev.RefreshKeyHash == body.RefreshToken {
			response.RefreshToken, response.AccessToken, err = token.NewTokenPair(userId).GetStrings()
			user.Devices[i].RefreshKeyHash = response.RefreshToken
			ctx := context.Background()
			tx, err := db.GetHelperRepo().Conn.BeginTx(ctx, nil)
			if err != nil {
				log.Println(err)
			}
			_, err = db.GetHelperRepo().SaveDevice(&user.Devices[i], tx, ctx)
			if err != nil {
				log.Println(err)
			}
			err = tx.Commit()
			if err != nil {
				log.Println(err)
			}
			break
		}
	}

	if err != nil {
		http.Error(writer, err.Error(), http.StatusNotFound)
		return
	}
	log.Println(json.NewEncoder(writer).Encode(response))

}
