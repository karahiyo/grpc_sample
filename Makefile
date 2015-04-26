CWD=$(shell pwd)
GOROOT:=
GOPATH:=$(shell pwd)
PATH=$(CWD)/bin

env:
	echo $(GOPATH)
	go env

__install-protobuf:
	wget https://github.com/google/protobuf/releases/download/v2.6.1/protobuf-2.6.1.tar.gz -O /tmp/protobuf-2.6.1.tar.gz
	tar zxvf /tmp/protobuf-2.6.1.tar.gz -C /tmp/protobuf-2.6.1
	popd /tmp/protobuf-2.6.1 && ./configure \
		--with-protoc=protoc \
		--prefix=$(CWD) \
		&& make && make check && make install && popd

setup:
	@go get -u -v github.com/golang/protobuf/proto
	@go get -u -v github.com/golang/protobuf/protoc-gen-go

save:
	gom gen gomfile

install:
	go get github.com/mattn/gom
	gom install

protoc-gen:
	protoc --go_out=. *.proto

run:
	go run main.go test.pb.go

test:
	gom test -v

fmt:
	gofmt -w *.go


