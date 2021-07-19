FROM alpine:3.14
  
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ARG NODE_ENV
ENV NODE_ENV $NODE_ENV

RUN apk --no-cache add tzdata npm git

COPY package.json /usr/src/app/package.json

RUN npm install --only=prod && \
    npm cache clean --force

COPY . /usr/src/app

ENV NODE_ENV=production \
    daemon=false \
    silent=false

EXPOSE 4567

CMD node ./nodebb build ;  node ./nodebb start
