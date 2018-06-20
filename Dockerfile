FROM maven:3.5.3-jdk-10 as BUILD

ENV APP_NAME timely

WORKDIR /usr/src/timely
ENV MAVEN_OPTS=-Dmaven.repo.local=../m2repo/
# create intermediate image with all maven dependencies to decrease build time
COPY pom.xml .
RUN mvn -B -e -C -T 1C org.apache.maven.plugins:maven-dependency-plugin:3.1.1:go-offline
# now compile with the already downloaded dependencies
COPY src ./src
# Not using multiple CPUs, because flyway-maven-plugin may not be thread safe
#RUN mvn -B -e -o -T 1C -f /usr/src/timely/pom.xml clean package
RUN mvn -B -e -o -f /usr/src/timely/pom.xml clean package


FROM openjdk:10-jdk

LABEL maintainer="Tobias Baumann, baumato.de"
  
ENV PATH "$PATH":/bin:.:
ENV INSTALL_DIR /opt/

# Download latest liberty release
RUN LIBERTY_URL="https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/nightly" \
    && RELEASE=`curl -s "${LIBERTY_URL}/info.json" | \
        python -c "import sys, json; print json.load(sys.stdin)['versions'][-1]"` \
    && VERSIONED_FILE=`curl -s "${LIBERTY_URL}/$RELEASE/info.json" | \
        python -c "import sys, json; print json.load(sys.stdin)['driver_location']"` \
    && curl -O "${LIBERTY_URL}/${RELEASE}/${VERSIONED_FILE}" \
    && unzip ${VERSIONED_FILE} -d ${INSTALL_DIR} \
    && rm ${VERSIONED_FILE}
 
ENV LIBERTY_HOME ${INSTALL_DIR}/wlp/
ENV SERVER_HOME ${LIBERTY_HOME}/usr/servers/defaultServer/
ENV DEPLOYMENT_DIR ${SERVER_HOME}/dropins/


EXPOSE 9080 9443

COPY src/main/liberty/config/server.xml ${SERVER_HOME}
COPY --from=BUILD /usr/src/timely/target/timely.war ${DEPLOYMENT_DIR}

ENTRYPOINT /opt/wlp/bin/server run defaultServer

HEALTHCHECK --interval=5s --timeout=3s CMD curl --fail http://localhost:9080/timely/resources/ping || exit 1

