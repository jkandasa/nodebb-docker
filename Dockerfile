FROM alpine:3.14
  
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ARG NODE_ENV
ENV NODE_ENV $NODE_ENV

COPY ./NodeBB/ /usr/src/app/

RUN apk --no-cache add tzdata npm git && \
    npm install --only=prod && \
    npm cache clean --force


ENV NODE_ENV=production \
    daemon=false \
    silent=false

EXPOSE 4567

CMD node ./nodebb build ;  node ./nodebb start
