package models

import (
	"errors"
)

type SupplierType *string

var supplierTypes map[int64]SupplierType

func GetSupplierTypes() *map[int64]SupplierType {
	return &supplierTypes
}
func GetSupplierTypeId(supplierType SupplierType) int64 {
	for k, v := range supplierTypes {
		if v == supplierType {
			return k
		}
	}
	return 0
}

type Supplier struct {
	User
	Branches    map[int64]*Branch
	Description string
	Type        SupplierType
	Image       string
	Products    map[int64]*Product // key -- id for Product
}

func NewSupplier(u User, supplierType SupplierType) (Supplier, error) {
	if supplierType == nil {
		return Supplier{}, errors.New("type is nil")
	}
	if u.GetType() != "User" {
		return Supplier{}, errors.New("var u is not User")
	}
	return Supplier{User: u, Type: supplierType,
		Branches: make(map[int64]*Branch),
		Products: make(map[int64]*Product)}, nil
}

func (s *Supplier) AddProduct(p Product) (*Product, error) {
	if p.Supplier != s && p.Supplier != nil {
		return nil, errors.New("product does not belong to the supplier")
	}
	var err error
	if _, ok := s.Products[p.ID]; ok {
		err = errors.New("product id was exist, but rewrite")
	}
	s.Products[p.ID] = &p
	s.Products[p.ID].Supplier = s
	return s.Products[p.ID], err
}

func (s *Supplier) MakeBranch(u User) (*Branch, error) {
	branch, err := NewBranch(u, s)
	if err != nil {
		return nil, err
	}
	s.Branches[u.ID] = &branch
	return s.Branches[u.ID], nil
}

func (s *Supplier) GetBranch(id int64) (*Branch, error) {
	branch, ok := s.Branches[id]
	if !ok {
		return nil, errors.New("branch not found")
	}
	return branch, nil
}

func (s Supplier) GetType() string {
	return "Supplier"
}
