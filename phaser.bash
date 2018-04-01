loadenv() {
  if [[ -z `cat .env 2>/dev/null` ]]; then
    echo -e "Please add a .env file\nSee: https://github.com/chrisdlangton/docker-phaser"
    exit 1
  else
    source .env
  fi
}

phaser-stop() {
  loadenv
  if [ -z ${PROJECT_NAME} ]; then
    echo "variables [PROJECT_NAME] not fond"
    exit 1
  fi
  docker stop ${PROJECT_NAME} >/dev/null 2>/dev/null
  docker rm ${PROJECT_NAME} >/dev/null 2>/dev/null
  echo -e Stopped
}

phaser-start() {
  loadenv
  if [ -z ${DOCKER_PHASER_ROOT} ] || [ -z ${DOCKERHUB_USER} ] || [ -z ${PROJECT_NAME} ]; then
    echo "variables [DOCKER_PHASER_ROOT,DOCKERHUB_USER,PROJECT_NAME] not fond"
    exit 1
  fi
  NODE_ENV=$1
  if [ -z ${NODE_ENV} ]; then
    NODE_ENV=development
  fi
  if [ -z ${SERVER_PORT} ]; then
    SERVER_PORT=3000
  fi
  if [ -z ${PHASER_INDEX} ]; then
    PHASER_INDEX=src/index.html
  fi
  if [ -z ${HOST_ADDR} ]; then
    HOST_ADDR=127.0.0.1
  fi
  if [ -z ${HOST_PORT} ]; then
    HOST_PORT=3000
  fi
  if [ -z ${STATIC_SERVER_ARGS} ]; then
    STATIC_SERVER_ARGS="--no-cache"
  fi
  docker run \
  -v ${DOCKER_PHASER_ROOT}/.bash_history_docker:/home/phaser/.bash_history:rw \
  -v ${DOCKER_PHASER_ROOT}/src:/phaser/src:rw \
  -v ${DOCKER_PHASER_ROOT}/assets:/phaser/assets:rw \
  -v ${DOCKER_PHASER_ROOT}/index.html:/phaser/index.html:rw \
  -v ${DOCKER_PHASER_ROOT}/webpack.config.js:/phaser/webpack.config.js:rw \
  -p ${HOST_ADDR}:${HOST_PORT}:${SERVER_PORT}/tcp \
  -p ${HOST_ADDR}:8000:8000/tcp \
  -e NODE_ENV=${NODE_ENV} \
  -e PHASER_PORT=${SERVER_PORT} \
  -e PHASER_INDEX=${PHASER_INDEX} \
  -e STATIC_SERVER_ARGS=${STATIC_SERVER_ARGS} \
  --name ${PROJECT_NAME} \
  -t ${DOCKERHUB_USER}/${PROJECT_NAME}
}

phaser-build() {
  loadenv
  if [ -z ${DOCKERHUB_USER} ] || [ -z ${PROJECT_NAME} ]; then
    echo "variables [DOCKERHUB_USER,PROJECT_NAME] not fond"
    exit 1
  fi
  VERSION=$1
  if [ -z ${VERSION} ]; then
    VERSION=latest
  fi
  docker build . \
  --compress \
  --force-rm \
  --rm \
  -t ${DOCKERHUB_USER}/${PROJECT_NAME}:${VERSION}
}

phaser-exec() {
  loadenv
  if [ -z ${PROJECT_NAME} ]; then
    echo "variables [PROJECT_NAME] not fond"
    exit 1
  fi
  docker exec -it ${PROJECT_NAME} $@
}

dockerhub-push() {
  loadenv
  VERSION=$1
  if [ -z $VERSION ]; then
    VERSION=latest
  fi
  docker tag ${DOCKERHUB_USER}/${PROJECT_NAME} ${DOCKERHUB_USER}/${PROJECT_NAME}:${VERSION}
  docker push ${DOCKERHUB_USER}/${PROJECT_NAME}
}

phaser-rebuild() {
  echo -e Stopping
  phaser-stop
  echo -e Building
  phaser-build
  echo -e Starting
  phaser-start
}

phaser-restart() {
  echo -e Stopping
  phaser-stop
  echo -e Starting
  phaser-start
}

phaser-boilerplate() {
  cat <<EOF
The following files will be written (over-writen on the host):
.
├── assets
│   └── logo.png
├── index.html
├── src
│   └── index.js
└── webpack.config.js

Continue? (Y/n)
EOF
  WORKDIR=`pwd`
  read CONFIRM
  loadenv
  if [[ ${CONFIRM} == 'Y' ]]; then
    d=/phaser/boilerplate
    docker cp ${PROJECT_NAME}:${d}/webpack.config.js ${WORKDIR}/webpack.config.js
    docker cp ${PROJECT_NAME}:${d}/index.html ${WORKDIR}/index.html
    docker cp ${PROJECT_NAME}:${d}/assets ${WORKDIR}/
    docker cp ${PROJECT_NAME}:${d}/src ${WORKDIR}/
    tree

    echo -e "Install dependencies? (Y/n)"
    read CONFIRM
    if [[ ${CONFIRM} == 'Y' ]]; then
      docker exec -it ${PROJECT_NAME} npm i --save-dev webpack-dev-server@2.11 webpack@3.4 raw-loader@0.5 --no-optional

      echo -e "Update host package.json? (Y/n)"
      read CONFIRM
      if [[ ${CONFIRM} == 'Y' ]]; then
        docker cp ${PROJECT_NAME}:/phaser/package.json ${WORKDIR}/package.json
      fi

      echo -e "Update host package-lock.json? (Y/n)"
      read CONFIRM
      if [[ ${CONFIRM} == 'Y' ]]; then
        docker cp ${PROJECT_NAME}:/phaser/package-lock.json ${WORKDIR}/package-lock.json
      fi

    fi

    cat <<EOF
Consider adding the following to your package.json if not already.

"scripts": {
  "build": "webpack",
  "start": "npm run build && webpack-dev-server --port=8000"
}
EOF

    echo -e "Do you want to run webpack now? (Y/n)"
    read CONFIRM
    if [[ ${CONFIRM} == 'Y' ]]; then
      docker exec -it ${PROJECT_NAME} npm start
    fi

  fi
}
