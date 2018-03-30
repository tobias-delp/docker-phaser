# docker-phaser

![docker-logo](https://raw.githubusercontent.com/docker-library/docs/b449be7df57e9ed9086bb5821bfb5d6cdc5d67a4/docker-dev/logo.png)![phaser-logo](https://examples.phaser.io/assets/sprites/phaser2.png)

Easy quick phaser environment for anywhere Docker runs

## Version

Current latest version: Phaser 3.3

## Docker Hub

[chrisdlangton/docker-phaser](https://hub.docker.com/r/chrisdlangton/docker-phaser/)

## Install

Install docker-phaser nodejs runtime with the latest supported Phaser library

```bash
docker pull chrisdlangton/docker-phaser:latest
```

Specify a specific supported Phaser version

```bash
docker pull chrisdlangton/docker-phaser:3.3
```

## Using the helper functions

Enable the helper function in a UNIX-like environment (Mac/Linux) with

```bash
source phaser.bash
```

### Project structure

1) ensure you have a `package.json` in the project root

2) create a `.env` file in the project root (using the `.evn-example` as a reference)

  ```bash
  DOCKER_PHASER_ROOT=`pwd`
  PROJECT_NAME=docker-phaser
  DOCKERHUB_USER=chrisdlangton
  SERVER_PORT=3000
  HOST_PORT=3000
  HOST_ADDR=127.0.0.1
  ```

3) all of the phaser project files should be in the `src` directoy within the project root

4) the static web server expects an `src/index.html` file

5) OPTIONALLY: to preserve bash history between running containers create a `.bash_history_docker` file in the project root

### Build the docker container

Ensure you've followed the Project structure

```bash
phaser-build
```

this will run the latest supported version of phaser, alternatively you may provide a version

```bash
phaser-build 3.3
```

### Starting the web server

Ensure you've first run `build-phaser`

```bash
phaser-start
```

And now in the browser visit the address output. Default is [localhost:3000](http://localhost:3000/)

optionally you can start the web server with a specific `NODE_ENV` value with

```bash
phaser-start prod
```

### Access the shell of the web server container

you can run a 1-off command inside the contaienr with

```bash
phaser-exec ls -la
```

or drop into a shell with just `phaser-exec`

### Stop the web server

This can simply be done with `phaser-stop`

## Extending functionality

Extend the implementation by adding files and commands in your own project `Dockerfile` with `FROM chrisdlangton/docker-phaser`. If the functionality you're adding is useful to others please consider contributing to this project by forking and createding a pull request.