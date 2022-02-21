package db

import (
	"context"
	"database/sql"
	"fmt"
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

func InitDB(db *DB) error {
	_, err := InitUserRepo(db)
	if err != nil {
		return err
	}
	InitHelperRepo(db)
	_, err = InitProductRepo(db)
	if err != nil {
		return err
	}
	uTypes, err := db.LoadTypes("users_types")
	if err != nil {
		return err
	}
	for k, v := range uTypes {
		userTypes[v] = k
	}
	if err != nil {
		return err
	}
	return err
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

type Saver struct {
	Query string
	Args  []interface{}
}

func (s Saver) Save(tx *sql.Tx, ctx context.Context) (int64, error) {
	result, err := tx.ExecContext(ctx, s.Query, s.Args...)
	if err != nil {
		//if strings.HasPrefix(err.Error(), "Error 1062") {
		//	return 0, err
		//}
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
