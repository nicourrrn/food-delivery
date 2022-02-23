package main

import (
	"context"
	"database/sql"
	"encoding/json"
	"food-delivery/pkg/db"
	"food-delivery/pkg/models"
	"food-delivery/pkg/token"
	"github.com/bxcodec/faker/v3/support/slice"
	"log"
	"net/http"
	"strings"
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

type GetSupplierListResponse struct {
	Suppliers []struct {
		ID          int64
		Name, Image string
		Description string
		Type        string
	}
}

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
	_, err := token.GetClaim(accessToken, token.GetAccess())
	if err != nil {
		http.Error(writer, err.Error(), http.StatusLocked)
		return
	}

	supplierTypes := make([]string, 0)
	err = json.Unmarshal([]byte(request.Header.Get("Supplier-Types")), &supplierTypes)
	if err != nil {
		http.Error(writer, err.Error(), http.StatusBadRequest)
		return
	}
	response := GetSupplierListResponse{}
	supplierList, err := db.GetUserRepo().GetSuppliersList()
	if err != nil {
		http.Error(writer, err.Error(), http.StatusBadRequest)
		return
	}

	for _, s := range supplierList {
		response.Suppliers = append(response.Suppliers, struct {
			ID          int64
			Name, Image string
			Description string
			Type        string
		}{ID: s.ID, Name: s.Name, Image: s.Image, Description: s.Description, Type: *s.Type})
	}

	if len(supplierTypes) == 0 {
		log.Println(json.NewEncoder(writer).Encode(response))
		return
	}

	for i, s := range response.Suppliers {
		if !slice.Contains(supplierTypes, s.Type) {
			response.Suppliers = append(response.Suppliers[:i], response.Suppliers[:i+1]...)
		}
	}

}

type GetProductsListResponse struct {
	Products []models.Product
}

func GetProductList(writer http.ResponseWriter, request *http.Request) {
	if request.Method != http.MethodGet {
		http.Error(writer, "Mehod not allowed", http.StatusMethodNotAllowed)
		return
	}

	query := "SELECT products.id, supplier_id, products.name, description, image, price, product_types.name \nFROM products JOIN product_types on type_id = product_types.id "
	var (
		rows *sql.Rows
		err  error
	)
	supplierId := request.Header.Get("SupplierID")
	if supplierId != "" {
		rows, err = db.GetProductRepo().Conn.Query(query+"WHERE supplier_id = ?;", supplierId)
	} else {
		rows, err = db.GetProductRepo().Conn.Query(query)
	}
	if err != nil {
		log.Println(err)
	}

	products := make([]models.Product, 0)

	for rows.Next() {
		var product models.Product
		product.Supplier = new(models.Supplier)
		err = rows.Scan(&product.ID, &product.Supplier.ID, &product.Name, &product.Description, &product.Image, &product.Price, &product.Type)
		if err != nil {
			log.Println(err)
		}
		products = append(products, product)
	}

	log.Println(json.NewEncoder(writer).Encode(GetProductsListResponse{Products: products}))

}

type PostBasketRequest struct {
	CoordinateTo int64   `json:"coordinate_to"`
	Products     []int64 `json:"products"`
}
type PostBasketResponse struct {
	BasketId int64 `json:"basket_id"`
}

func PostBasket(writer http.ResponseWriter, request *http.Request) {
	if request.Method != http.MethodPost {
		http.Error(writer, "", http.StatusMethodNotAllowed)
		return
	}

	var body PostBasketRequest
	err := json.NewDecoder(request.Body).Decode(&body)
	if err != nil {
		log.Println(err)
	}

	if len(body.Products) == 0 {
		http.Error(writer, "no products", http.StatusBadRequest)
		return
	}

	userToken, err := token.GetClaim(request.Header.Get("Access-Token"), token.GetAccess())
	if err != nil {
		log.Println(err)
	}
	client, err := db.GetUserRepo().GetClient(userToken.UserId)
	if err != nil {
		log.Println(err)
	}

	coordinate, err := db.GetHelperRepo().LoadCoordinate(body.CoordinateTo)
	if err != nil {
		log.Println(err)
	}
	basket, err := client.MakeBasket(&coordinate)
	if err != nil {
		log.Println(err)
	}

	ctx := context.Background()
	tx, err := db.GetProductRepo().Conn.BeginTx(ctx, nil)
	if err != nil {
		log.Println(err)
	}
	basket.ID, err = db.GetProductRepo().SaveBasket(&basket, tx, ctx)
	if err != nil {
		log.Println(err)
	}

	args := make([]interface{}, 0)

	for _, prodId := range body.Products {
		args = append(args, prodId, basket.ID)
	}

	_, err = tx.ExecContext(ctx,
		"INSERT INTO products_basket(product_id, basket_id) VALUES "+
			strings.Repeat(",(?, ?)", len(body.Products))[1:],
		args...)

	if err != nil {
		log.Println(err)
		log.Println(tx.Rollback())
	}

	response := PostBasketResponse{
		BasketId: basket.ID,
	}

	log.Println(tx.Commit())
	log.Println(json.NewEncoder(writer).Encode(response))
}

type UpdateBasketRequest struct {
	BasketId       int64   `json:"basket_id"`
	Paid           bool    `json:"paid"`
	Closed         bool    `json:"closed"`
	Editable       bool    `json:"editable"`
	CoordinateTo   int64   `json:"coordinate_to"`
	NewProductList []int64 `json:"new_product_list"`
}

func UpdateBasket(writer http.ResponseWriter, request *http.Request) {
	if request.Method != http.MethodPost {
		http.Error(writer, "", http.StatusMethodNotAllowed)
		return
	}

	var body UpdateBasketRequest
	err := json.NewDecoder(request.Body).Decode(&body)
	if err != nil {
		log.Println(err)
	}
	userToken, err := token.GetClaim(request.Header.Get("Access-Token"), token.GetAccess())
	if err != nil {
		log.Println(err)
	}
	client, err := db.GetUserRepo().GetClient(userToken.UserId)
	if err != nil {
		log.Println(err)
	}

	var basket models.Basket
	var clientId int64
	err = db.GetProductRepo().Conn.QueryRow(
		"SELECT id, client_id, paid, closed, editable FROM baskets WHERE id = ?",
		body.BasketId).Scan(
		&basket.ID, &clientId,
		&basket.Paid, &basket.Closed, &basket.Editable)
	if err != nil {
		log.Println(err)
	}

	if clientId != client.ID {
		http.Error(writer, "", http.StatusUnauthorized)
		return
	}

	ctx := context.Background()
	tx, err := db.GetProductRepo().Conn.BeginTx(ctx, nil)
	if err != nil {
		log.Println(err)
	}
	if basket.Editable && len(body.NewProductList) != 0 {
		_, err = tx.ExecContext(ctx,
			"DELETE FROM products_basket WHERE basket_id = ?;",
			basket.ID)
		args := make([]interface{}, 0)
		for _, prodId := range body.NewProductList {
			args = append(args, prodId)
		}
		_, err := tx.ExecContext(ctx,
			"INSERT INTO products_basket VALUES "+
				strings.Repeat(",(?,?)", len(body.NewProductList))[1:], args...)
		if err != nil {
			log.Println(err)
			log.Println(tx.Rollback())
		}
	}

	if !basket.Closed && !basket.Paid {
		basket.Paid = body.Paid
	}
	if !basket.Closed && !basket.Editable {
		basket.Editable = body.Editable
	}
	if !basket.Closed {
		basket.Closed = body.Closed
	}

	ctx = context.Background()
	tx, err = db.GetProductRepo().Conn.BeginTx(ctx, nil)
	if err != nil {
		log.Println(err)
	}
	_, err = db.GetProductRepo().SaveBasket(&basket, tx, ctx)
	if err != nil {
		log.Println(err)
	}
	log.Println(tx.Commit())

}
