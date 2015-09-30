ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

JENKINS_HOME = /opt/jenkins/data

# android sdk
ANDROID_SDK_ROOT = $(ROOT_DIR)/android-sdk-ubuntu
ANDROID_SDK_DEST = $(JENKINS_HOME)/sdk/Android

ENV_ANDROID = "ANDROID_HOME=$(ANDROID_SDK_DEST)"
VOL_ANDROID = $(ANDROID_SDK_ROOT):$(ANDROID_SDK_DEST):ro

# cfgs
CFG_ROOT = $(ROOT_DIR)/cfg
CFG_DEST = $(JENKINS_HOME)/cfg

VOL_CONFIG = $(CFG_ROOT):$(CFG_DEST)

# jobs
JOBS_ROOT = $(ROOT_DIR)/jobs
JOBS_DEST = $(JENKINS_HOME)/jobs

VOL_JOBS = $(JOBS_ROOT):$(JOBS_DEST)

# plugins
PLUGIN_ROOT = $(ROOT_DIR)/plugins
PLUGIN_DEST = $(JENKINS_HOME)/plugins

VOL_PLUGIN = $(PLUGIN_ROOT):$(PLUGIN_DEST)

# gradle caches
GRADLE_CACHE_ROOT = $(ROOT_DIR)/gradle_caches
GRADLE_CACHE_DESC = /root/.gradle

VOL_GRADLE = $(GRADLE_CACHE_ROOT):$(GRADLE_CACHE_DESC)

#build
build:
	docker build -t larry/ci:v1 .
run:
	docker run -it --rm --name ci.run --privileged -e $(ENV_ANDROID) -v $(VOL_CONFIG) -v $(VOL_PLUGIN) -v $(VOL_ANDROID) -v $(VOL_JOBS) -v $(VOL_GRADLE) -p 80:8080 larry/ci:v1
debug:
	docker run -it --rm --name ci.debug --privileged -e $(ENV_ANDROID) -v $(VOL_CONFIG) -v $(VOL_PLUGIN) -v $(VOL_ANDROID) -v $(VOL_JOBS) -v $(VOL_GRADLE) -p 80:8080 larry/ci:v1 /bin/bash
deploy:
	docker run -it -d --name ci.d --privileged -e $(ENV_ANDROID) -v $(VOL_CONFIG) -v $(VOL_PLUGIN) -v $(VOL_ANDROID) -v $(VOL_JOBS) -v $(VOL_GRADLE) -p 80:8080 larry/ci:v1
