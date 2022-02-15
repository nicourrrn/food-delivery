package db

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"food-delivery/pkg/models"
	"github.com/bxcodec/faker/v3/support/slice"
	_ "github.com/go-sql-driver/mysql"
	"log"
	"time"
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

var keys = []string{
	"login", "email", "id",
}

//TODO edit this code
var userTypes = map[string]int{
	"Client":   1,
	"Supplier": 2,
	"Branch":   3,
}

func LoadUser(r *DB, key, value string) (models.TypedUser, error) {
	if !slice.Contains(keys, key) {
		return nil, errors.New("key unknown")
	}
	query :=
		"SELECT users.id, users.name, users.login, users.email, ut.name FROM" +
			" users JOIN users_types ut on users.user_type_id = ut.id WHERE users." +
			key + " = ?"
	row := r.Conn.QueryRow(query, key)
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

//func SaveUser(r *DB, user *models.User) error {
//	if _, ok := userTypes[user.GetType()]; !ok {
//		return errors.New("user type unknown")
//	}
//	ctx := context.Background()
//	tx, err := r.Conn.BeginTx(ctx, nil)
//	if err != nil {
//		return err
//	}
//	var (
//		args  = []interface{}{user.Name, user.Login, user.Email, user.PassHash}
//		query string
//	)
//	if user.ID != 0 {
//		query = "INSERT INTO users(name, login, email, pass_hash, user_type_id) VALUE (?, ?, ?, ?, ?);"
//		args = append(args, userTypes[user.GetType()])
//	} else {
//		query = "UPDATE users SET name = ?, login = ?, email = ?, pass_hash = ? WHERE id = ?;"
//		args = append(args, user.ID)
//	}
//	result, err := tx.ExecContext(ctx, query, args...)
//	if err != nil {
//		err = tx.Rollback()
//		if err != nil {
//			return err
//		}
//		return err
//	}
//	id, err := result.LastInsertId()
//	if err == nil {
//		log.Println(err)
//		user.ID = id
//	}
//	return nil
//}
func SaveUser(db *DB, user *models.User, tx *sql.Tx, ctx context.Context) error {
	if _, ok := userTypes[user.GetType()]; !ok {
		return errors.New("user type unknown")
	}
	var (
		args = []interface{}{user.Name, user.Login, user.Email, user.PassHash}
		id   int64
		err  error
	)
	if user.ID != 0 {
		id, err = Saver{
			Query: "INSERT INTO users(name, login, email, pass_hash, user_type_id) VALUE (?, ?, ?, ?, ?);",
			Args:  append(args, userTypes[user.GetType()]),
		}.Save(db, tx, ctx)
	} else {
		id, err = Saver{
			Query: "UPDATE users SET name = ?, login = ?, email = ?, pass_hash = ? WHERE id = ?;",
			Args:  append(args, user.ID),
		}.Save(db, tx, ctx)
	}
	if err != nil {
		return err
	}
	user.ID = id
	return nil
}

type Saver struct {
	Query string
	Args  []interface{}
}

func (s Saver) Save(db *DB, tx *sql.Tx, ctx context.Context) (int64, error) {
	result, err := tx.ExecContext(ctx, s.Query, s.Args...)
	if err != nil {
		err = tx.Rollback()
		if err != nil {
			return 0, err
		}
		return 0, err
	}
	id, err := result.LastInsertId()
	if err != nil {
		log.Println(err)
		return 0, err
	}
	return id, nil
}

type Garbage interface {
	GarbageCollector()
}

func (r *DB) RunGarbage(Garbagers ...Garbage) {
	time.Sleep(time.Minute)
	for _, g := range Garbagers {
		g.GarbageCollector()
	}
}
