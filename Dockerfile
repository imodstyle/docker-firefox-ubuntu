#
# firefox Dockerfile
#
# https://github.com/imodstyle/docker-firefox
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

# Define software versions.
#ARG FIREFOX_VERSION=120.0.1
#ARG PROFILE_CLEANER_VERSION=2.45

# Define software download URLs.
#ARG PROFILE_CLEANER_URL=https://github.com/graysky2/profile-cleaner/raw/v${PROFILE_CLEANER_VERSION}/common/profile-cleaner.in

# Define working directory.
WORKDIR /tmp

# Install Firefox.
RUN apt-get -o Acquire::Check-Valid-Until=false update && apt-get install -y \ 
        firefox

# Install extra packages.
#RUN apt-get -o Acquire::Check-Valid-Until=false update && apt-get install -y \
        # WebGL support.
#        mesa-dri-gallium \
        # Icons used by folder/file selection window (when saving as).
#        adwaita-icon-theme \
        # A font is needed.
#        font-dejavu \
        # The following package is used to send key presses to the X process.
#        xdotool 
#        && \
    # Remove unneeded icons.
#    find /usr/share/icons/Adwaita -type d -mindepth 1 -maxdepth 1 -not -name 16x16 -not -name scalable -exec rm -rf {} ';' && \
#    true

# Install profile-cleaner.
#RUN apt-get update \
#    apt-get install -y --virtual build-dependencies curl && \
#    curl -# -L -o /usr/bin/profile-cleaner {$PROFILE_CLEANER_URL} && \
#    sed-patch 's/@VERSION@/'${PROFILE_CLEANER_VERSION}'/' /usr/bin/profile-cleaner && \
#    chmod +x /usr/bin/profile-cleaner && \
#    apt-get update && apt-get install -y \
#        bash \
#        file \
#        coreutils \
#        bc \
#        parallel \
#        sqlite \
#        && \
    # Cleanup.
#    apt autoremove build-dependencies && \
#    rm -rf /tmp/* /tmp/.[!.]*

# Generate and install favicons.
RUN \
    APP_ICON_URL=https://raw.githubusercontent.com/imodstyle/docker-firefox/master/img/firefox-icon.png && \
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
      org.label-schema.vcs-url="https://github.com/imodstyle/docker-firefox" \
      org.label-schema.schema-version="1.0"
