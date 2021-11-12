# Powershell container image (fd_pwsh) for the frickeldave infrastructure

This describes the base images fro the whole frickeldave infrastructure. 

## Source for this image

The image is based on the official alpine image, stored on [docker hub](https://hub.docker.com/_/alpine) and is extended with powershell.

## Quick reference

- Where to file issues: Not possible now, its just for private use. 
- Supported architecture: am64

## How to use this image

- Pull from commandline

  ``` docker pull ghcr.io/frickeldave/fd_pwsh:<tag> ```

- Add to your image

  ``` FROM ghcr.io/frickeldave/fd_pwsh:<tag> ```

## License

View license information for the software contained in this image.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.