package models

import "time"

type Device struct {
	ID             int64
	User           User
	LastVisit      time.Time
	UserAgent      string
	RefreshKeyHash string
}

func (d *Device) EqualsUserAgent(userAgent string) bool {
	return userAgent == d.UserAgent
}
