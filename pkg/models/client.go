package models

import "time"

type Client struct {
	ID             int
	Login, Email   string
	HomeCoordinate Coordinate
	Phone          string
	LastVisit      time.Time
	Devices        map[int]Device
}

func (c *Client) GetPassHash() {}
