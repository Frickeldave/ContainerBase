FROM        ghcr.io/frickeldave/fd_alpine:3.14.3

LABEL		org.opencontainers.image.authors="David Koenig <dave@frickeldave.de>"
LABEL		org.opencontainers.image.created="2021-11-12"
LABEL		org.opencontainers.image.version="8.282.08-r1"
LABEL		org.opencontainers.image.url="https://github.com/Frickeldave/ContainerBase/jre8"
LABEL		org.opencontainers.image.documentation="https://github.com/Frickeldave/ContainerBase/jre8/README.md"
LABEL		org.opencontainers.image.source="https://github.com/Frickeldave/ContainerBase/jre8"
LABEL 		org.opencontainers.image.description "This is the java base image for the docker infrastructure of the Frickeldave environment."

# Install java
RUN         apk update; \
            apk --no-cache add openjdk8-jre=8.282.08-r1; \
            rm -rf /var/lib/apt/lists/*; \
            rm -rf /var/cache/apk/*

ENV         JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk
ENV         PATH=${PATH}:/usr/lib/jvm/java-1.8-openjdk/bin
