package test

import (
	"food-delivery/pkg/db"
	"github.com/stretchr/testify/assert"
	"sync"
	"testing"
)

func TestInit(t *testing.T) {
	newDB, err := db.NewDB("student", "Stud_21g", "test_delivery")
	assert.NoError(t, err)
	db.InitClientRepo(newDB)
	db.InitHelperRepo()
	_, err = db.InitSupplierRepo(newDB, &sync.WaitGroup{})
	assert.NoError(t, err)
}
