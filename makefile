all:
	GOOS=linux GOARCH=amd64 go build -mod vendor
