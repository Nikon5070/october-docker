#!/bin/bash

#composer install
if [[ ! -d ./vendor ]]; then
    docker run --rm --interactive --volume $PWD:/app --user $(id -u):$(id -g) composer install
fi


#run docker containers
docker-compose stop
docker-compose build
docker-compose up -d


#clear images and containers
containers=$(docker ps -qa --no-trunc --filter "status=exited")
images=$(docker images -f "dangling=true" -q)

if [[ -n "$containers" ]]
  then
    docker rm $containers
  else
    echo "Not containers"
fi

if [[ -n "$images" ]]
  then
    docker rmi $images
  else
    echo "Not images"
fi

