FROM 		ghcr.io/frickeldave/fd_alpine:3.15.0

ARG 		MDB_VERSION=10.6.4-r1
ARG 		MDB_CLIENTVERSION=10.6.4-r1
ARG 		fd_builddate
ARG 		fd_buildnumber

LABEL		org.opencontainers.image.authors="David Koenig <dave@frickeldave.de>"
LABEL		org.opencontainers.image.created="2021-11-30"
LABEL		org.opencontainers.image.version="10.6.4-r1"
LABEL		org.opencontainers.image.url="https://github.com/Frickeldave/ContainerBase/mariadb"
LABEL		org.opencontainers.image.documentation="https://github.com/Frickeldave/ContainerBase/mariadb/README.md"
LABEL		org.opencontainers.image.source="https://github.com/Frickeldave/ContainerBase/mariadb"
LABEL 		org.opencontainers.image.description "This is the mariadb base image for the docker infrastructure of the Frickeldave environment."
LABEL		de.frickeldave.containers.builddate=$fd_builddate
LABEL		de.frickeldave.containers.buildnumber=$fd_buildnumber

# Additionally openssl is needed which is installed in alpine base.
RUN 		apk update; \
				apk add mariadb=$MDB_VERSION \
					mariadb-client=$MDB_CLIENTVERSION; \
				rm -rf /var/lib/apt/lists/*; \
				rm -rf /var/cache/apk/*

COPY 		setup.sql /home/appuser/app/setup.sql
COPY 		appdb.sql /home/appuser/app/appdb.sql
COPY 		start.sh /home/appuser/app/start.sh

RUN 		chmod +x /home/appuser/app/start.sh; \
				mkdir /home/appuser/data/mariadb; \
				mkdir /home/appuser/data/mariadb/db; \
				mkdir /home/appuser/data/mariadb/log; \
				touch /home/appuser/app/mariadb.pid; \
				touch /home/appuser/app/mariadb.socket; \
				chown -R appuser:appuser /home/appuser/app; \
				chown -R appuser:appuser /home/appuser/data

USER 		appuser

ENTRYPOINT 	["/home/appuser/app/start.sh"]
