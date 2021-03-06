FROM	    docker.io/library/alpine:3.15.0

ARG 		fd_builddate
ARG 		fd_buildnumber

LABEL		org.opencontainers.image.authors="David Koenig <dave@frickeldave.de>"
LABEL		org.opencontainers.image.created="2021-11-29"
LABEL		org.opencontainers.image.version="3.15.0"
LABEL		org.opencontainers.image.url="https://github.com/Frickeldave/ContainerBase/alpine"
LABEL		org.opencontainers.image.documentation="https://github.com/Frickeldave/ContainerBase/alpine/README.md"
LABEL		org.opencontainers.image.source="https://github.com/Frickeldave/ContainerBase/alpine"
LABEL 		org.opencontainers.image.description "This is the base image for the docker infrastructure of the Frickeldave environment."

LABEL		de.frickeldave.containers.builddate=$fd_builddate
LABEL		de.frickeldave.containers.buildnumber=$fd_buildnumber

# add local user "appuser" which is used to run the application
RUN 		adduser -D -h "/home/appuser" -u 50000 -g 50000 -s /bin/sh appuser

RUN			mkdir /home/appuser/data; \
			mkdir /home/appuser/data/certificates; \
			mkdir /home/appuser/app; \
			mkdir /home/appuser/app/tools

RUN			chown -R appuser:appuser /home/appuser/data; \
			chown -R appuser:appuser /home/appuser/data/certificates; \
			chown -R appuser:appuser /home/appuser/app; \
			chown -R appuser:appuser /home/appuser/app/tools

# Install additionally required tools
RUN 		apk update; \
			apk --no-cache add jq \
				curl \
				ca-certificates \
				openssl && \
			rm -rf /var/lib/apt/lists/*; \
			rm -rf /var/cache/apk/*; \
			update-ca-certificates --fresh 2>/dev/null || true

# Get script file for certificate management
RUN 		curl https://raw.githubusercontent.com/Frickeldave/ScriptCollection/master/bash/create-self-signed-certificates/createcerts.sh --output /home/appuser/app/tools/createcerts.sh

# Set permission for newly created files and folders
RUN 		chown -R appuser:appuser /home/appuser/app/tools; \
			chmod +x /home/appuser/app/tools/createcerts.sh