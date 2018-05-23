#!/usr/bin/env bash

WORKDIR=`pwd`
declare -a versions=(
  "3.0" "3.0.0" 
  "3.1" "3.1.0" "3.1.1" "3.1.2"
  "3.2" "3.2.0" "3.2.1"
  "3.3" "3.3.0"
  "3.4" "3.4.0"
  "3.5" "3.5.0" "3.5.1"
  "3.6" "3.6.0" "3.6.1"
  "3.7" "3.7.0" "3.7.1"
  "3.8" "3.8.0"
)

LAST_VERSION=''
for VERSION in "${versions[@]}"
do
  if [ -z ${LAST_VERSION} ]; then
    for v in "${versions[@]}"
    do
      docker rmi ci/docker-phaser:${v} 2>/dev/null
    done
  else
    docker rmi ci/docker-phaser:${LAST_VERSION}
  fi
  cd ${WORKDIR}/docker/${VERSION}/
  docker build . \
  --compress \
  --force-rm \
  --rm \
  -f ${WORKDIR}/docker/${VERSION}/Dockerfile \
  -t ci/docker-phaser:${VERSION}

  LAST_VERSION=$VERSION

done

docker rmi ci/docker-phaser:${LAST_VERSION}
