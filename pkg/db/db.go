package db

import (
	"database/sql"
	"fmt"
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
