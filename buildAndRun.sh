#!/bin/sh

# do the buid with maven inside docker
docker image build -t de.baumato/timely .

# run the container
docker rm -f timely || true && \
docker run -d \
  -p 9080:9080 \
  -p 9443:9443 \
  --name timely \
  de.baumato/timely