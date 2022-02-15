package test

import (
	"context"
	"food-delivery/pkg/db"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestInit(t *testing.T) {
	newDB, err := db.NewDB("student", "Stud_21g", "test_delivery")
	assert.NoError(t, err)
	assert.NoError(t, db.InitDB(&newDB))
	ctx := context.Background()
	tx, err := newDB.Conn.BeginTx(ctx, nil)
	assert.NoError(t, err)
	fake := GenerateFakeData()
	for _, client := range fake.Clients {
		client.ID = 0
		err = db.GetClientRepo().SaveClient(client, tx, ctx)
		assert.NoError(t, err)
	}
	assert.NoError(t, tx.Commit())
	tx, err = newDB.Conn.BeginTx(ctx, nil)
	assert.NoError(t, err)
	for _, supplier := range fake.Suppliers {
		supplier.ID = 0
		assert.NoError(t, db.GetSupplierRepo().SaveSupplier(supplier, tx, ctx))
		for _, product := range supplier.Products {
			assert.NoError(t, db.GetSupplierRepo().SaveIngredients(product.Ingredients, tx))
			assert.NoError(t, db.GetSupplierRepo().SaveProduct(product, tx, ctx))
		}
		for _, branch := range supplier.Branches {
			assert.NoError(t, db.GetSupplierRepo().SaveBranch(branch, tx, ctx))
		}
	}
	assert.NoError(t, tx.Commit())
}
