# MariaDB container image (fd_mariadb) for the frickeldave infrastructure

This describes the mariadb images for the frickeldave infrastructure. 

Go [back](./../README.md) to the root of the documentation. 

## Source for this image

The image is based on the frickeldave alpine image [alpine image](./../alpine/README.md).

## Quick reference

- Where to file issues: Not possible now, its just for private use. 
- Supported architecture: am64

## How to use this image

- Pull from commandline

  ``` docker pull ghcr.io/frickeldave/fd_mariadb:<tag> ```

- How to build by yourself

  ``` docker build -t ghcr.io/frickeldave/fd_mariadb --build-arg fd_buildnumber=<int> --build-arg fd_builddate=$(date -u +'%Y-%m-%dT%H:%M:%SZ') . ```

- How to run mariadb

  Please use the [docker-compose.yaml](./docker-compose.yaml) file in this repository as a reference implementation. 

  - **MDB_ROOTPWD**  
    The password which should be given to the root user. Cannot be used from outside the container.
  - **MDB_PORT**   
    The port where mariadb should listen to.
  - **MDB_ADMINUSER**    
    An additional user who is able to manage the mariadb instance.
  - **MDB_BACKUPUSER**  
    A user to backup database objects.
  - **MDB_ADMINPWD**  
    The password for the admin user.
  - **MDB_BACKUPPWD**  
    The password for the backup user.
  - **MDB_HEALTHUSER**  
    A user without any permission but to connect to the mariadb instance. Will primarly used for health checks.
  - **MDB_HEALTHPWD**  
    The password for the health user.
  - **MDB_COLLATION**  
    The collation for all databases.
  - **MDB_CHARACTERSET**  
    The characterset for all databases.
  - **MDB_APPDB**  
    The name of the database which should be created on startup.
  - **MDB_APPDB_USER**  
    The user with permissions to the app database.
  - **MDB_APPDB_PWD**  
    The apssword for the user who has access to the database.

## License

View license information for the software contained in this image.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.