package main

import (
	"encoding/json"
	"food-delivery/pkg/db"
	"food-delivery/pkg/token"
	"log"
	"net/http"
	"time"
)

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
		return
	}

	accessToken := request.Header.Get("Access-Token")
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

//type GetSupplierListResponse struct {
//	Suppliers []models.Supplier
//}

func GetSupplierList(writer http.ResponseWriter, request *http.Request) {
	if request.Method != http.MethodGet {
		http.Error(writer, "Method not alowed", http.StatusMethodNotAllowed)
		return
	}

	accessToken := request.Header.Get("Access-Token")
	if accessToken == "" {
		http.Error(writer, "Sing up or sing in please", http.StatusLocked)
		return
	}

	supplierTypes := make([]string, 0)
	err := json.Unmarshal([]byte(request.Header.Get("Supplier-Types")), &supplierTypes)
	if err != nil {
		http.Error(writer, err.Error(), http.StatusBadRequest)
		return
	}
	supplierList, err := db.GetUserRepo().GetSuppliersList()
	if err != nil {
		http.Error(writer, err.Error(), http.StatusBadRequest)
		return
	}

	log.Println(json.NewEncoder(writer).Encode(supplierList))
}
