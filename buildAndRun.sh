#!/bin/sh
docker build -t de.baumato/timely .
docker rm -f timely || true && docker run -d -p 9080:9080 -p 9443:9443 --name timely de.baumato/timely 
