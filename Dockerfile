FROM node:9.10-alpine
ENV NODE_ENV development
LABEL author="github.com/chrisdlangton"

# The SUID flag on binaries has a vulnerability where intruders have a vector for assuming root access to the host
RUN for i in `find / -path /proc -prune -o -perm /6000 -type f`; do chmod a-s $i; done
RUN adduser -D -s /usr/local/bin/node phaser && mkdir /phaser && chown -R phaser /phaser
USER phaser
WORKDIR /phaser

COPY package.json .
RUN npm i phaser@3.3 --no-optional --no-package-lock

VOLUME [ "/phaser/src" ]