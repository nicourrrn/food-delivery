package token

import (
	"strings"
	"time"
)

type TokenPair struct {
	RefreshToken, AccessToken *UserClaim
}

func NewTokenPair(userId int64) TokenPair {
	return TokenPair{
		RefreshToken: NewUserClaim(userId, time.Now().Add(refreshLifeTime)),
		AccessToken:  NewUserClaim(userId, time.Now().Add(accessLifeTime)),
	}
}
func NewTokenPairFromStrings(refresh, access string) (pair TokenPair, err error) {
	pair.RefreshToken, err = GetClaim(refresh, refreshKey)
	if err != nil && !strings.HasPrefix(err.Error(), "token is expired ") {
		return
	}
	pair.AccessToken, err = GetClaim(access, accessKey)
	if err != nil && !strings.HasPrefix(err.Error(), "token is expired ") {
		return
	}
	err = nil
	return
}

func (p TokenPair) GetStrings() (refresh, access string, err error) {
	refresh, err = p.RefreshToken.SetKey(refreshKey)
	if err != nil {
		return "", "", err
	}
	access, err = p.AccessToken.SetKey(accessKey)
	return
}
