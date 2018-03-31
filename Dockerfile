FROM node:9.10-alpine
LABEL author="github.com/chrisdlangton"

ARG PHASER_PORT=3000
ARG PHASER_INDEX=src/index.html

ENV PHASER_PORT $PHASER_PORT
ENV PHASER_INDEX $PHASER_INDEX
ENV NODE_ENV development

# The SUID flag on binaries has a vulnerability where intruders have a vector for assuming root access to the host
RUN for i in `find / -path /proc -prune -o -perm /6000 -type f`; do chmod a-s $i; done

RUN adduser -s /usr/local/bin/node -h /phaser -S -D phaser
WORKDIR /phaser

RUN apk update \
    && apk add --update wget git curl bash \
    && rm -rf /tmp/ \
    && rm -rf /var/cache/apk/*

COPY package.json .
RUN npm i -g generator-phaser-plus@3.0.0-beta.1 static-server@2.2 --no-optional --no-package-lock
RUN npm i phaser@3.3 --no-optional --no-package-lock

USER phaser

HEALTHCHECK --interval=10s --timeout=3s --start-period=3s \
    CMD curl --silent --fail http://localhost:$PHASER_PORT/ || exit 1

EXPOSE $PHASER_PORT
VOLUME [ "/phaser/src" ]
CMD [ "bash", "-c", "static-server -p ${PHASER_PORT} --cors --no-cache -i ${PHASER_INDEX}" ]
