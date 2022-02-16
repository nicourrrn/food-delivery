package models

import "errors"

type Client struct {
	User
	Phone           string
	CoordinatesList []*Coordinate
}

func (c *Client) GetPassHash() {
}

func (c Client) GetType() string {
	return "Client"
}

func NewClient(u User) Client {
	return Client{
		User:            u,
		CoordinatesList: make([]*Coordinate, 0),
	}
}

func (c *Client) MakeBasket(coordinate *Coordinate) (Basket, error) {
	if coordinate == nil {
		return Basket{}, errors.New("coordinate is nil")
	}
	return Basket{
		Client:       c,
		CoordinateTo: coordinate,
		Products:     make([]*Product, 0),
	}, nil
}

func (c *Client) AddCoordinate(coordinate *Coordinate) {
	c.CoordinatesList = append(c.CoordinatesList, coordinate)
}

func (c Client) GetUser() User {
	return c.User
}
