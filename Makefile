CWD=$(shell pwd)
GOROOT:=
GOPATH:=$(shell pwd)
PATH=$(PATH):$(CWD)/bin

env:
	echo $(GOPATH)
	go env

# https://github.com/google/protobuf/releases/download/v2.6.1/protobuf-2.6.1.tar.gz
__install-protobuf:
	wget https://github.com/google/protobuf/archive/v3.0.0-alpha-2.tar.gz -O /tmp/protobuf-3.0.0-alpha.tar.gz
	tar zxvf /tmp/protobuf-3.0.0-alpha.tar.gz -C /tmp
	cd /tmp/protobuf-3.0.0-alpha-2 \
		&& ./autogen.sh \
		&& ./configure \
		--with-protoc=protoc \
		--prefix=$(CWD) \
		&& make && make check && make install

__setup:
	@go get -u -v github.com/golang/protobuf/proto
	@go get -u -v github.com/golang/protobuf/protoc-gen-go

install: __setup
	go get github.com/mattn/gom
	gom install

protoc-gen:
	protoc --go_out=plugins=grpc:. *.proto

save:
	gom gen gomfile

server:
	gom run server/main.go

client:
	gom run client/main.go

test:
	gom test -v

fmt:
	gofmt -w *.go

.PHONY: server client

