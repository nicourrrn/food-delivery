package models

import (
	"errors"
	"golang.org/x/crypto/bcrypt"
)

type User struct {
	ID                 int64
	Name, Login, Email string
	PassHash           string
	Devices            []Device
}

func NewUser(login, pass string) (User, error) {
	passHash, err := bcrypt.GenerateFromPassword([]byte(pass), bcrypt.DefaultCost)
	if err != nil {
		return User{}, err
	}
	return User{Login: login, PassHash: string(passHash)}, nil
}

func (u *User) MakeDevice(userAgent string) (*Device, error) {
	if len(u.Devices) > 5 {
		return nil, errors.New("user have max devices")
	}
	device := NewDevice(u, userAgent)
	u.Devices = append(u.Devices, device)
	return &u.Devices[len(u.Devices)-1], nil

}

func (u *User) ComparePassword(pass string) bool {
	return bcrypt.CompareHashAndPassword([]byte(u.PassHash), []byte(pass)) == nil
}
