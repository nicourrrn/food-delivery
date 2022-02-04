package models

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
