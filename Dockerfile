FROM python:3.12-alpine AS build

WORKDIR /src

RUN apk add --no-cache bash

COPY build.sh ./
COPY content ./content
COPY images ./images

RUN bash build.sh

FROM nginx:1.27-alpine

COPY deploy/nginx/wiki-server.conf /etc/nginx/conf.d/default.conf
COPY --from=build /src/docs /usr/share/nginx/html

EXPOSE 80
