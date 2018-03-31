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

## Features

- Secure Docker Linux environment running nodejs 9.10 typical for Phaser3 projects
- Create Phaser Web games with ease: [rblopes/generator-phaser-plus](https://github.com/rblopes/generator-phaser-plus)
- A simple static server written in node.js [nbluis/static-server](https://github.com/nbluis/static-server) available on you're own configurable port (or default 3000)
- Helper functions that manage the Docker and Phaser web server (for UNIX-like environments)
- Official Phaser 3 Webpack Project Template [photonstorm/phaser3-project-template](https://github.com/photonstorm/phaser3-project-template) available in directory `/phaser/boilerplate`

## Using the Official Template

The official Phaser 3 Webpack Project Template in `/phaser/boilerplate` can be started with `npm start` in it directory which starts a web server on port 8080.

You should get familiar with this boilerplate by making changes and testing, when ready to start you're own project it is recommended you fork the project yourself on your host and when running docker-phaser mount that project to `/phaser/src` by following the next step below.

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
  PHASER_INDEX=src/index.html
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