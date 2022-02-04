package models

import "time"

type Device struct {
	ID             int
	User           User
	LastVisit      time.Time
	UserAgent      string
	RefreshKeyHash string
}

func (d *Device) EqualsUserAgent(userAgent string) bool {
	return userAgent == d.UserAgent
}
