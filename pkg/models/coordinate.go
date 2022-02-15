package models

type Coordinate struct {
	ID        int64
	X, Y      float64
	Humanized string
	Name      string
}

func NewCoordinate(name string, x, y float64) Coordinate {
	return Coordinate{
		Name: name,
		X:    x,
		Y:    y,
	}
}
