package token

import (
	"errors"
	"github.com/golang-jwt/jwt"
	"os"
	"strconv"
	"time"
)

var (
	accessKey, refreshKey           string
	accessLifeTime, refreshLifeTime time.Duration
)

func InitJwt() error {
	refreshKey = os.Getenv("REFRESH_KEY")
	accessKey = os.Getenv("ACCESS_KEY")
	tempInt, err := strconv.Atoi(os.Getenv("ACCESS_LIFETIME_SECOND"))
	if err != nil {
		return err
	}
	refreshLifeTime = time.Second * time.Duration(tempInt)
	tempInt, err = strconv.Atoi(os.Getenv("REFRESH_LIFETIME_SECOND"))
	if err != nil {
		return err
	}
	refreshLifeTime = time.Second * time.Duration(tempInt)
	return nil
}

type UserClaim struct {
	jwt.StandardClaims
	UserId int64
}

func NewUserClaim(userId int64, lifeTime time.Time) *UserClaim {
	return &UserClaim{
		StandardClaims: jwt.StandardClaims{
			ExpiresAt: lifeTime.Unix(),
		},
		UserId: userId,
	}
}

func (c *UserClaim) SetKey(key string) (string, error) {
	return jwt.NewWithClaims(jwt.SigningMethodHS256, c).SignedString(key)
}

func GetClaim(token, key string) (*UserClaim, error) {
	jwtToken, err := jwt.ParseWithClaims(token, &UserClaim{}, func(t *jwt.Token) (interface{}, error) {
		return []byte(key), nil
	})
	if err != nil {
		return nil, err
	}
	claims, ok := jwtToken.Claims.(*UserClaim)
	if !ok || !jwtToken.Valid {
		return nil, errors.New("failed to parse")
	}
	return claims, nil
}
