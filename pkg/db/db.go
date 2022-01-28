package db

import "database/sql"

type DB struct {
	conn *sql.DB
}
