package token

import "time"

type TokenPair struct {
	RefreshToken, AccessToken *UserClaim
}

func NewTokenPair(userId int64) TokenPair {
	return TokenPair{
		RefreshToken: NewUserClaim(userId, time.Now().Add(refreshLifeTime)),
		AccessToken:  NewUserClaim(userId, time.Now().Add(accessLifeTime)),
	}
}

func (p TokenPair) GetStrings() (refresh, access string, err error) {
	refresh, err = p.RefreshToken.SetKey(refreshKey)
	if err != nil {
		return "", "", err
	}
	access, err = p.AccessToken.SetKey(accessKey)
	return
}
