package db

import (
	"context"
	"database/sql"
	"errors"
	"food-delivery/pkg/models"
	"github.com/bxcodec/faker/v3/support/slice"
)

func CastToClient(u models.TypedUser) models.Client {
	return u.(models.Client)
}

func CastToSupplier(u models.TypedUser) models.Supplier {
	return u.(models.Supplier)
}

func CastToBranch(u models.TypedUser) models.Branch {
	return u.(models.Branch)
}

func CastToUser(u models.TypedUser) models.User {
	return u.GetUser()
}

func InitUserLoader() {

}

var keys = []string{
	"login", "email", "id",
}

var userTypes = map[string]int64{}

func GetUserTypes() map[string]int64 {
	return userTypes
}

func LoadUser(r *DB, key, value string) (models.TypedUser, error) {
	if !slice.Contains(keys, key) {
		return nil, errors.New("key unknown")
	}
	query :=
		"SELECT users.id, users.name, users.login, users.email, ut.name FROM" +
			" users JOIN users_types ut on users.user_type_id = ut.id WHERE users." +
			key + " = ?"
	row := r.Conn.QueryRow(query, value)
	user := models.User{}
	var userType string
	err := row.Scan(user.ID, user.Name, user.Login, user.Email, userType)
	if err != nil {
		return nil, err
	}
	var castedUser models.TypedUser
	switch userType {
	case "Supplier":
		castedUser, err = globalSupplierRepo.LoadSupplier(user)
	case "Branch":
		castedUser, err = globalSupplierRepo.LoadBranch(user)
	case "Client":
		castedUser, err = globalClientRepo.loadClient(user)
	default:
		err = errors.New("user type not found from db")
	}
	return castedUser, err
}

func SaveUser(typedUser *models.TypedUser, tx *sql.Tx, ctx context.Context) (int64, error) {
	userType := (*typedUser).GetType()
	user := CastToUser(*typedUser)
	if _, ok := userTypes[userType]; !ok {
		return 0, errors.New("user type unknown")
	}
	var saver Saver
	if user.ID == 0 {
		saver = Saver{
			Query: "INSERT INTO users(name, login, email, pass_hash, user_type_id) VALUE (?, ?, ?, ?, ?);",
			Args:  []interface{}{user.Name, user.Login, user.Email, user.PassHash, userTypes[userType]},
		}
	} else {
		saver = Saver{
			Query: "UPDATE users SET name = ?, login = ?, email = ?, pass_hash = ? WHERE id = ?;",
			Args:  []interface{}{user.Name, user.Login, user.Email, user.PassHash, user.ID},
		}
	}
	return saver.Save(tx, ctx)
}
