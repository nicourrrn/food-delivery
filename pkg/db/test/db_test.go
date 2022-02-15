package test

import (
	"food-delivery/pkg/db"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestInit(t *testing.T) {
	newDB, err := db.NewDB("student", "Stud_21g", "test_delivery")
	assert.NoError(t, err)
	assert.NoError(t, db.InitDB(&newDB))
}
