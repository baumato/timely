# Build
docker image build -t de.baumato/timely .

# RUN
Use buildAndRun.sh
or execute:
docker rm -f timely || true && \
docker run -d \
  -p 9080:9080 \
  -p 9443:9443 \
  --name timely \
  de.baumato/timely \