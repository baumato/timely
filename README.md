# Build
mvn clean package && docker build -t de.baumato/timely .

# RUN

docker rm -f timely || true && docker run -d -p 8080:8080 -p 4848:4848 --name timely de.baumato/timely 