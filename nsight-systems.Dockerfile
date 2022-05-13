FROM nvcr.io/nvidia/cudagl:11.4.2-devel-ubuntu20.04

ARG GIT_USER_EMAIL="dukeleimao@gmail.com"
ARG GIT_USER_NAME="Lei Mao"

ENV DEBIAN_FRONTEND noninteractive

# Install package dependencies
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        dbus \
        fontconfig \
        gnupg \
        libasound2 \
        libfreetype6 \
        libglib2.0-0 \
        libnss3 \
        libsqlite3-0 \
        libx11-xcb1 \
        libxcb-glx0 \
        libxcb-xkb1 \
        libxcomposite1 \
        libxcursor1 \
        libxdamage1 \
        libxi6 \
        libxml2 \
        libxrandr2 \
        libxrender1 \
        libxtst6 \
        openssh-client \
        wget \
        xcb \
        xkb-data && \
    apt-get clean

RUN apt-get update -y && \
    apt-get install -y qt5-default cuda-nsight-systems-11-4

# CMD ["nsys-ui"]
