#
# firefox Dockerfile
#
# https://github.com/imodstyle/docker-firefox-ubuntu
#

# Build the membarrier check tool.
FROM alpine:3.15 AS membarrier
WORKDIR /tmp
COPY membarrier_check.c .
RUN apk --no-cache add build-base linux-headers
RUN gcc -static -o membarrier_check membarrier_check.c
RUN strip membarrier_check

# Pull base image.
FROM imodstyle/baseimage-gui:ubuntu-22.04-v4.5.1

# Docker image version is provided via build arg.
ARG DOCKER_IMAGE_VERSION=

# Define working directory.
WORKDIR /tmp

# Install Firefox.
RUN apt-get -o Acquire::Check-Valid-Until=false update && apt-get install -y firefox

# Generate and install favicons.
RUN \
    APP_ICON_URL=https://raw.githubusercontent.com/imodstyle/docker-firefox-ubuntu/master/img/firefox-icon.png && \
    install_app_icon.sh "$APP_ICON_URL"

# Add files.
COPY rootfs/ /
COPY --from=membarrier /tmp/membarrier_check /usr/bin/

# Set internal environment variables.
RUN \
    set-cont-env APP_NAME "Firefox" && \
    set-cont-env APP_VERSION "$FIREFOX_VERSION" && \
    set-cont-env DOCKER_IMAGE_VERSION "$DOCKER_IMAGE_VERSION" && \
    true

# Set public environment variables.
ENV \
    FF_OPEN_URL= \
    FF_KIOSK=0

# Metadata.
LABEL \
      org.label-schema.name="firefox" \
      org.label-schema.description="Docker container for Firefox" \
      org.label-schema.version="${DOCKER_IMAGE_VERSION:-unknown}" \
      org.label-schema.vcs-url="https://github.com/imodstyle/docker-firefox-ubuntu" \
      org.label-schema.schema-version="1.0"
