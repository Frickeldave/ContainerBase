FROM        ghcr.io/frickeldave/fd_alpine:3.15.0

ARG 		PSH_VERSION=7.2.0

LABEL		org.opencontainers.image.authors="David Koenig <dave@frickeldave.de>"
LABEL		org.opencontainers.image.created="2021-11-29"
LABEL		org.opencontainers.image.version="$PSH_VERSION"
LABEL		org.opencontainers.image.url="https://github.com/Frickeldave/ContainerBase/pwsh"
LABEL		org.opencontainers.image.documentation="https://github.com/Frickeldave/ContainerBase/pwsh/README.md"
LABEL		org.opencontainers.image.source="https://github.com/Frickeldave/ContainerBase/pwsh"
LABEL 		org.opencontainers.image.description "This is the powershell base image for the docker infrastructure of the Frickeldave environment."

LABEL		de.frickeldave.containers.builddate=$fd_builddate
LABEL		de.frickeldave.containers.builnumber=$fd_buildnumber

RUN         apk add --no-cache \
                ca-certificates \
                less \
                ncurses-terminfo-base \
                krb5-libs \
                libgcc \
                libintl \
                libssl1.1 \
                libstdc++ \
                tzdata \
                userspace-rcu \
                zlib \
                icu-libs \
                curl \
                && apk -X https://dl-cdn.alpinelinux.org/alpine/edge/main add --no-cache lttng-ust \
                && curl -L https://github.com/PowerShell/PowerShell/releases/download/v${PSH_VERSION}/powershell-${PSH_VERSION}-linux-alpine-x64.tar.gz -o /tmp/powershell.tar.gz \
                && mkdir -p /opt/microsoft/powershell/7 \
                && tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7 \
                && chmod +x /opt/microsoft/powershell/7/pwsh \
                && ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh \
                && rm -rf /var/lib/apt/lists/* \
                && rm -rf /var/cache/apk/*
