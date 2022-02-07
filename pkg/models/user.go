package models

import (
	"golang.org/x/crypto/bcrypt"
)

type User struct {
	ID                 int
	Name, Login, Email string
	PassHash           string
}

func NewUser(login, pass string) (User, error) {
	passHash, err := bcrypt.GenerateFromPassword([]byte(pass), bcrypt.DefaultCost)
	if err != nil {
		return User{}, err
	}
	return User{Login: login, PassHash: string(passHash)}, nil
}

func (u User) GetType() string {
	return "User"
}