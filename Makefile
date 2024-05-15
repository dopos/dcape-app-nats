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
IMAGE_VER          ?= 2.10.14-linux

#- ip:port for external access
SERVICE_ADDR       ?= 127.0.0.1:4222

# ------------------------------------------------------------------------------
# app custom config

# Add user config part to .env.sample
ADD_USER           ?= yes

# ------------------------------------------------------------------------------
-include $(CFG)
export

# Find and include DCAPE/apps/drone/dcape-app/Makefile
DCAPE_COMPOSE ?= dcape-compose
DCAPE_ROOT    ?= $(shell docker inspect -f "{{.Config.Labels.dcape_root}}" $(DCAPE_COMPOSE))

ifeq ($(shell test -e $(DCAPE_ROOT)/Makefile.app && echo -n yes),yes)
  include $(DCAPE_ROOT)/Makefile.app
endif
