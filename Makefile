## dcape-app-nats Makefile
## This file extends Makefile.app from dcape
#:

SHELL               = /bin/bash
CFG                ?= .env
CFG_BAK            ?= $(CFG).bak

#- App name
APP_NAME           ?= nats

# Hostname for external access
APP_SITE           ?= $(APP_NAME).dev.test

#- Docker image name
IMAGE              ?= nats

#- Docker image tag
IMAGE_VER          ?= 2.11.1

#- ip:port for external access
SERVICE_ADDR       ?= 127.0.0.1:4222

#- hostname for internal access
SERVICE_HOST       ?= $(APP_NAME)

#- NATS auth token
NATS_TOKEN         ?= $(shell openssl rand -hex 16; echo)

#- additional server args (eg.: -js)
ARGS_ADDON         ?=
# ------------------------------------------------------------------------------
# app custom config

# ------------------------------------------------------------------------------
-include $(CFG_BAK)
-include $(CFG)
export

# Find and include DCAPE/apps/drone/dcape-app/Makefile
DCAPE_COMPOSE ?= dcape-compose
DCAPE_ROOT    ?= $(shell docker inspect -f "{{.Config.Labels.dcape_root}}" $(DCAPE_COMPOSE))

ifeq ($(shell test -e $(DCAPE_ROOT)/Makefile.app && echo -n yes),yes)
  include $(DCAPE_ROOT)/Makefile.app
endif

admin: CMD=run -it --rm admin
admin: dc
