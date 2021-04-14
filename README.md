# MPLAB® X / XC8 Docker Image

This Docker image will can be used to build a MPLAB® X / XC8 project.

It runs on Linux Ubuntu 20.04 and uses:

* [MPLAB X](https://www.microchip.com/en-us/development-tools-tools-and-software/mplab-x-ide) v5.45
* [XC8](https://www.microchip.com/en-us/development-tools-tools-and-software/mplab-xc-compilers) v1.34

## Prerequisities

In order to run this container you'll need [Docker](https://docs.docker.com/get-started/#set-up-your-docker-environment).

## Usage

### Command-line Examples

Build the `firmware.X` project with the `default` configuration:

```sh
docker run -ti -v $(pwd):/app mplabx /app/firmware.X default
```

## Acknowledgements

MPLAB® X and the MPLAB® XC compilers are registered trademarks of Microchip Technology Inc.
