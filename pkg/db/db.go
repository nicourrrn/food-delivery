package db

import (
	"database/sql"
	"errors"
	"fmt"
	"food-delivery/pkg/models"
	"sync"
)

type DB struct {
	Conn *sql.DB
}

func NewDB(login, password, dbName string) (DB, error) {
	db, err := sql.Open("mysql", fmt.Sprintf("%s:%s@/%s", login, password, dbName))
	if err != nil {
		return DB{}, err
	}
	err = db.Ping()
	if err != nil {
		return DB{}, err
	}
	return DB{
		Conn: db,
	}, nil
}

type Garbage interface {
	GarbageCollector(group sync.WaitGroup)
}

func (r *DB) LoadUserByID(id int) (models.TypedUser, error) {
	row := r.Conn.QueryRow("SELECT users.id, users.name, users.login, users.email, ut.name FROM users JOIN users_types ut on users.user_type_id = ut.id WHERE users.id = ?", id)
	user := models.User{}
	var userType string
	err := row.Scan(user.ID, user.Name, user.Login, user.Email, userType)
	if err != nil {
		return nil, err
	}
	var castedUser models.TypedUser
	switch userType {
	case "Supplier":
		castedUser, err = GlobalSupplierRepo.LoadSupplier(user)
	case "Branch":
		castedUser, err = GlobalSupplierRepo.LoadBranch(user)
	case "Client":
		castedUser, err = GlobalClientRepo.LoadClient(user)
	default:
		err = errors.New("user type not found from db")
	}
	return castedUser, err
}
