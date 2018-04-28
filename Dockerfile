FROM airhacks/glassfish
COPY ./target/timely.war ${DEPLOYMENT_DIR}
