# Copyright © 2017 Zlatko Čalušić
#
# Use of this source code is governed by an MIT-style license that can be found in the LICENSE file.
#

DOCKER_IMAGE ?= payne8/rest-server-arm

REST_SERVER_VERSION := $(strip $(shell cat VERSION))

.PHONY: default rest-server install uninstall docker_build docker_push clean

default: rest-server

rest-server:
	@go run build.go

install: rest-server
	/usr/bin/install -m 755 rest-server /usr/local/bin/rest-server

uninstall:
	rm -f /usr/local/bin/rest-server

docker_build:
	docker pull alexellis2/go-armhf:1.7.4
	docker run --rm -it \
		-v $(CURDIR):/go/src/github.com/restic/rest-server \
		-w /go/src/github.com/restic/rest-server \
		alexellis2/go-armhf:1.7.4 \
		go run build.go
	# docker pull alpine
	docker build -t $(DOCKER_IMAGE):$(REST_SERVER_VERSION) .
	docker tag $(DOCKER_IMAGE):$(REST_SERVER_VERSION) $(DOCKER_IMAGE):latest

docker_push:
	docker push $(DOCKER_IMAGE):$(REST_SERVER_VERSION)
	docker push $(DOCKER_IMAGE):latest

clean:
	rm -f rest-server
