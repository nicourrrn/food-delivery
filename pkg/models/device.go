package models

type Device struct {
	ID, UserID int
	UserAgent  string
	RefreshKey string
}

func (d *Device) EqualsUserAgent(userAgent string) bool {
	return userAgent == d.UserAgent
}
