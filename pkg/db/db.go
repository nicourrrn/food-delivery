package db

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"food-delivery/pkg/models"
	"github.com/bxcodec/faker/v3/support/slice"
	_ "github.com/go-sql-driver/mysql"
	"time"
)

// TODO возможно убрать тип
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

var userTypes = map[string]int64{}

func UT() map[string]int64 {
	return userTypes
}
func InitDB(db *DB) error {
	InitClientRepo(db)
	InitHelperRepo(db)
	_, err := InitSupplierRepo(db)
	if err != nil {
		return err
	}
	uTypes, err := db.LoadTypes("users_types")
	for k, v := range uTypes {
		userTypes[v] = k
	}
	return err
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
		castedUser, err = globalSupplierRepo.LoadSupplier(user)
	case "Branch":
		castedUser, err = globalSupplierRepo.LoadBranch(user)
	case "Client":
		castedUser, err = globalClientRepo.LoadClient(user)
	default:
		err = errors.New("user type not found from db")
	}
	return castedUser, err
}

func SaveUser(db *DB, user *models.User, userType string, tx *sql.Tx, ctx context.Context) error {
	if _, ok := userTypes[userType]; !ok {
		return errors.New("user type unknown")
	}
	var (
		args = []interface{}{user.Name, user.Login, user.Email, user.PassHash}
		id   int64
		err  error
	)
	if user.ID == 0 {
		id, err = Saver{
			Query: "INSERT INTO users(name, login, email, pass_hash, user_type_id) VALUE (?, ?, ?, ?, ?);",
			Args:  append(args, userTypes[userType]),
		}.Save(tx, ctx)
	} else {
		id, err = Saver{
			Query: "UPDATE users SET name = ?, login = ?, email = ?, pass_hash = ? WHERE id = ?;",
			Args:  append(args, user.ID),
		}.Save(tx, ctx)
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

func (s Saver) Save(tx *sql.Tx, ctx context.Context) (int64, error) {
	result, err := tx.ExecContext(ctx, s.Query, s.Args...)
	if err != nil {
		errRollback := tx.Rollback()
		if errRollback != nil {
			return 0, err
		}
		return 0, err
	}
	id, err := result.LastInsertId()
	if err != nil {
		return 0, err
	}
	return id, nil
}

type Garbage interface {
	GarbageCollector()
}

func (db *DB) RunGarbage(Garbagers ...Garbage) {
	time.Sleep(time.Minute)
	for _, g := range Garbagers {
		g.GarbageCollector()
	}
}

func (db *DB) LoadTypes(tableName string) (map[int64]string, error) {
	rows, err := db.Conn.Query(fmt.Sprintf("SELECT id, name FROM %s", tableName))
	if err != nil {
		return nil, err
	}
	var (
		id   int64
		name string
	)
	newTypes := make(map[int64]string)
	for rows.Next() {
		err = rows.Scan(&id, &name)
		if err != nil {
			return nil, err
		}
		newTypes[id] = name
	}
	return newTypes, nil
}
