.PHONY: all build test test-buf clean google

PATH := $(PWD)/build:$(PATH)

all:
	@drone exec

build:
	go build -o build/ ./cmd/...

test:
	twirp-swagger-gen -in example/example.proto -out example/simple/example.swagger.json -host test.example.com
	twirp-swagger-gen -in example/google_timestamp.proto -out example/simple/google_timestamp.swagger.json -host test.example.com

test-buf:
	# use go run so we do not have install buf command
	# go get -u github.com/bufbuild/buf/cmd/...@v1.0.0-rc10
	GOBIN=/usr/local/bin go install github.com/bufbuild/buf/cmd/...@v1.0.0-rc10
	buf generate --template example/buf.gen.yaml --path example

clean:
	go fmt ./...
	go mod download
	go mod tidy

google:
	git clone https://github.com/googleapis/googleapis google
