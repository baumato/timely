#!/bin/sh

# do the buid with maven inside docker
docker build -t de.baumato/timely .

# run the container
docker rm -f timely || true && container=$(docker run -d -p 9080:9080 -p 9443:9443 --name timely de.baumato/timely) 
