# dcape-app-nats Makefile

SHELL               = /bin/bash
CFG                ?= .env

# Stats site host
APP_SITE           ?= nats.dev.lan
# Stats login
STATS_USER         ?= admin
# Stats password
STATS_PASS         ?= $(shell < /dev/urandom tr -dc A-Za-z0-9 | head -c8; echo)

# Docker image name
IMAGE              ?= nats
# Docker image tag
IMAGE_VER          ?= 1.0.4
# Docker-compose project name (container name prefix)
PROJECT_NAME       ?= dcape
# dcape container name prefix
DCAPE_PROJECT_NAME ?= dcape
# dcape network attach to
DCAPE_NET          ?= $(DCAPE_PROJECT_NAME)_default

define CONFIG_DEF
# ------------------------------------------------------------------------------
# NATS settings

# Stats site host
APP_SITE=$(APP_SITE)

# Stats login
STATS_USER=$(STATS_USER)
# Stats password
STATS_PASS=$(STATS_PASS)

# Docker details

# Docker image name
IMAGE=$(IMAGE)
# Docker image tag
IMAGE_VER=$(IMAGE_VER)
# Docker-compose project name (container name prefix)
PROJECT_NAME=$(PROJECT_NAME)
# dcape network attach to
DCAPE_NET=$(DCAPE_NET)

endef
export CONFIG_DEF

-include $(CFG)
export

.PHONY: all $(CFG) setup start stop up reup down dc help

all: help

# ------------------------------------------------------------------------------
# webhook commands

start: up

start-hook: reup

stop: down

update: reup

# ------------------------------------------------------------------------------
# docker commands

## старт контейнеров
up:
up: CMD=up -d
up: dc

## рестарт контейнеров
reup:
reup: CMD=up --force-recreate -d
reup: dc

## остановка и удаление всех контейнеров
down:
down: CMD=rm -f -s
down: dc

# ------------------------------------------------------------------------------

# $$PWD используется для того, чтобы текущий каталог был доступен в контейнере по тому же пути
# и относительные тома новых контейнеров могли его использовать
## run docker-compose
dc: docker-compose.yml
	@AUTH=$$(htpasswd -nb $$STATS_USER $$STATS_PASS) ; \
	docker run --rm  \
	  -v /var/run/docker.sock:/var/run/docker.sock \
	  -v $$PWD:$$PWD \
	  -w $$PWD \
	  --env=AUTH=$$AUTH \
	  docker/compose:1.14.0 \
	  -p $$PROJECT_NAME \
	  $(CMD)

# ------------------------------------------------------------------------------

$(CFG):
	@[ -f $@ ] || echo "$$CONFIG_DEF" > $@

# ------------------------------------------------------------------------------

## List Makefile targets
help:
	@grep -A 1 "^##" Makefile | less

##
## Press 'q' for exit
##
