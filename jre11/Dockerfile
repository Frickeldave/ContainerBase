FROM        ghcr.io/frickeldave/fd_alpine:3.15.0

ARG 		JRE_VERSION=11.0.13_p8-r0

LABEL		org.opencontainers.image.authors="David Koenig <dave@frickeldave.de>"
LABEL		org.opencontainers.image.created="2021-11-29"
LABEL		org.opencontainers.image.version="$JRE_VERSION"
LABEL		org.opencontainers.image.url="https://github.com/Frickeldave/ContainerBase/jre11"
LABEL		org.opencontainers.image.documentation="https://github.com/Frickeldave/ContainerBase/jre11/README.md"
LABEL		org.opencontainers.image.source="https://github.com/Frickeldave/ContainerBase/jre11"
LABEL 		org.opencontainers.image.description "This is the java 11 base image for the docker infrastructure of the Frickeldave environment."

LABEL		de.frickeldave.containers.builddate=$fd_builddate
LABEL		de.frickeldave.containers.builnumber=$fd_buildnumber

# Install java
RUN         apk update; \
            apk --no-cache add openjdk11-jre-headless=$JRE_VERSION; \
            rm -rf /var/lib/apt/lists/*; \
            rm -rf /var/cache/apk/*

ENV         JAVA_HOME=/usr/lib/jvm/java-11-openjdk
ENV         PATH=${PATH}:/usr/lib/jvm/java-11-openjdk/bin