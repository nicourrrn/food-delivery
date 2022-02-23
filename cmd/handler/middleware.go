package main

import (
	"food-delivery/pkg/token"
	"net/http"
	"strings"
)

func AuthorizedUser(next http.Handler) http.Handler {
	return http.HandlerFunc(
		func(writer http.ResponseWriter, request *http.Request) {
			access := request.Header.Get("Access-Token")
			if access == "" {
				http.Error(writer, "Unauthorized", http.StatusUnauthorized)
				return
			}
			_, err := token.GetClaim(access, token.GetAccess())

			if err != nil {
				isExpired := strings.HasPrefix(err.Error(), "token is expired")
				if isExpired {
					http.Error(writer, "redirect to /refresh", http.StatusUnauthorized)
				} else {
					http.Error(writer, err.Error(), http.StatusUnauthorized)
				}
				return
			}
			next.ServeHTTP(writer, request)
		})
}
func Base(next http.Handler) http.Handler {
	return http.HandlerFunc(func(writer http.ResponseWriter, request *http.Request) {
		writer.Header().Add("Access-Control-Allow-Origin", "*")
		next.ServeHTTP(writer, request)
	})
}
