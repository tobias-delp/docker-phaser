#!/usr/bin/env bash

WORKDIR=`pwd`
declare -a versions=(
  "3.0" "3.0.0" 
  "3.1" "3.1.0" "3.1.1" "3.1.2"
  "3.2" "3.2.0" "3.2.1"
  "3.3" "3.3.0"
)

source phaser.bash
source .env
phaser-stop

if [ -z ${DOCKERHUB_USER} ] || [ -z ${PROJECT_NAME} ]; then
  echo "variables [DOCKERHUB_USER,PROJECT_NAME] not fond"
  exit 1
fi
if [ -z ${PHASER_PORT} ]; then
  PHASER_PORT=3000
fi
if [ -z ${PHASER_INDEX} ]; then
  PHASER_INDEX=src/index.html
fi

LAST_VERSION=''
for VERSION in "${versions[@]}"
do
  if [ -z ${LAST_VERSION} ]; then
    for v in "${versions[@]}"
    do
      docker rmi ${DOCKERHUB_USER}/${PROJECT_NAME}:${v} 2>/dev/null
    done
  else
    docker rmi ${DOCKERHUB_USER}/${PROJECT_NAME}:${LAST_VERSION}
  fi
  cd ${WORKDIR}/docker/${VERSION}/
  docker build . \
  --compress \
  --force-rm \
  --rm \
  -f ${WORKDIR}/docker/${VERSION}/Dockerfile \
  -t ${DOCKERHUB_USER}/${PROJECT_NAME}:${VERSION}

  cd $WORKDIR
  dockerhub-push ${VERSION}
  LAST_VERSION=$VERSION

done

docker rmi ${DOCKERHUB_USER}/${PROJECT_NAME}:${LAST_VERSION}
