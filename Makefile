NAME = aspnet5api
CONTAINER_NAME = apsnet5api
IMAGE = $(shell echo $(NAME) | tr A-Z a-z)
REGISTRY_NAME = mconi2007
RUN_ARGS = -p 1000:1000

# Variables below should not need changing

TAG = latest
MACHINE_NAME = smbc
LOCALPROXY = $(shell env | grep -i http_proxy | grep -q -E "(localhost|127\.0\.)" ; echo $$?)
ISPROXY = $(shell env | grep -i -q http_proxy ; echo $$?)
HTTP_PROXY = $(shell env | grep -i http_proxy | cut -f 2 -d'=')
HTTPS_PROXY = $(shell env | grep -i https_proxy | cut -f 2 -d'=')
NO_PROXY = $(shell env | grep -i no_proxy | cut -f 2 -d'=')
NEEDMOUNT = $(shell pwd | grep -q "/Users/" ; echo $$?)


ifeq ($(LOCALPROXY),0)
BUILD_ARGS = --build-arg HTTP_PROXY=http://10.0.2.2:3128 --build-arg HTTPS_PROXY=http://10.0.2.2:3128 --build-arg NO_PROXY=192.168.*,localhost,127.0.*,172.16.*
RUN_ENV = -e HTTP_PROXY=http://10.0.2.2:3128 -e HTTPS_PROXY=http://10.0.2.2:3128 -e NO_PROXY=192.168.*,localhost,127.0.*,172.16.*,content
else ifeq ($(ISPROXY),0)
BUILD_ARGS = --build-arg HTTP_PROXY=$(HTTP_PROXY) --build-arg HTTPS_PROXY=$(HTTPS_PROXY) --build-arg NO_PROXY=$(NO_PROXY)
RUN_ENV =  -e HTTP_PROXY=$(HTTP_PROXY) -e HTTPS_PROXY=$(HTTPS_PROXY) -e NO_PROXY=$(NO_PROXY),content
else
BUILD_ARGS =
RUN_ENV =
endif

ifeq ($(NO_TEST),1)
TAG = notest
DOCKERFILE = DockerfileNoTest
else
DOCKERFILE = Dockerfile
endif

.PHONY: help build run clean machine-start machine-create machine-stop machine-rm machine-ip machine-env tag push

help:
	@echo "Targets available:"
	@echo "   [OPTIONS] build: build the Dockerfile"
	@echo "   [OPTIONS] run:   run the current app container"
	@echo "   clean:           remove the current app container"
	@echo "   machine-start:   start docker machine"
	@echo "   machine-create:  create the docker machine"
	@echo "   machine-stop:    stop the docker machine"
	@echo "   machine-rm:      remove the docker machine"
	@echo "   machine-ip:      print the docker machine ip"
	@echo "   machine-env:     print the env of the docker machine"
	@echo ""
	@echo "available OPTIONS:"
	@echo "	  NO_TEST=1"
	@echo ""
	@echo "Deployment targets:"
	@echo "   tag:             tag the current image with pipeline number"
	@echo "   push:            push the tagged image,with pipeline number, to the registery. Creates image_version file"

# Docker container tasks
build:
	docker build $(BUILD_ARGS) -t $(IMAGE):$(TAG) --file $(DOCKERFILE) .

run:
	docker run --name $(CONTAINER_NAME) $(RUN_ARGS) $(RUN_ENV) $(IMAGE):$(TAG)

clean:
	docker rm -f $(CONTAINER_NAME)

restart:
	docker rm -f $(CONTAINER_NAME)
	docker build $(BUILD_ARGS) -t $(IMAGE):$(TAG) --file $(DOCKERFILE) .
	docker run --name $(CONTAINER_NAME) $(RUN_ARGS) $(RUN_ENV) $(IMAGE):$(TAG)

machine-start:
	docker-machine start $(MACHINE_NAME)

machine-stop:
	docker-machine stop $(MACHINE_NAME)

machine-create:
ifeq ($(LOCALPROXY),0)
	docker-machine create --driver virtualbox \
	--engine-env HTTP_PROXY=http://10.0.2.2:3128 \
	--engine-env HTTPS_PROXY=http://10.0.2.2:3128 \
	--engine-env NO_PROXY=127.0.0.1,localhost \
	$(MACHINE_NAME)
else ifeq ($(ISPROXY),0)
	docker-machine create --driver virtualbox \
	--engine-env HTTP_PROXY=$(HTTP_PROXY) \
	--engine-env HTTPS_PROXY=$(HTTPS_PROXY) \
	--engine-env NO_PROXY=$(NO_PROXY) \
	$(MACHINE_NAME)
else
	docker-machine create --driver virtualbox \
	$(MACHINE_NAME)
endif
ifeq ($(NEEDMOUNT),1)
	docker-machine stop $(MACHINE_NAME)
	MSYS_NO_PATHCONV=1 VBoxManage sharedfolder add $(MACHINE_NAME) --name "$(shell echo $(CURDIR) | sed -e 's/^\///' )" --hostpath "$(PWD)" --automount
	docker-machine start $(MACHINE_NAME)
	MSYS_NO_PATHCONV=1 docker-machine ssh $(MACHINE_NAME) sudo mkdir "$(CURDIR)"
	MSYS_NO_PATHCONV=1 docker-machine ssh $(MACHINE_NAME) sudo mount -t vboxsf -o uid=1000,gid=50 "$(shell echo $(CURDIR) | sed -e 's/^\///' )" "$(CURDIR)"
endif

machine-env:
	@docker-machine env $(MACHINE_NAME)

machine-ip:
	@docker-machine ip $(MACHINE_NAME)

machine-rm:
	docker-machine rm $(MACHINE_NAME)

# Deployment tasks
tag:
	docker tag $(IMAGE) $(REGISTRY_NAME)/$(IMAGE):latest

push:
	docker push $(REGISTRY_NAME)/$(IMAGE):latest
#	docker rmi $(IMAGE)
