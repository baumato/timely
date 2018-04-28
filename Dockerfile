FROM maven:3.5.3-jdk-8 as BUILD

ENV APP_NAME timely

COPY src /usr/src/timely/src
COPY pom.xml /usr/src/timely
RUN mvn -f /usr/src/timely/pom.xml clean package


FROM openjdk:8-jdk

LABEL maintainer="Tobias Baumann, baumato.de"
  
ENV PATH "$PATH":/bin:.:
ENV INSTALL_DIR /opt/

# Download latest liberty release
RUN LIBERTY_URL="https://public.dhe.ibm.com/ibmdl/export/pub/software/openliberty/runtime/release" \
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
ENTRYPOINT /opt/wlp/bin/server run defaultServer

COPY src/main/liberty/config/server.xml ${SERVER_HOME}
COPY --from=BUILD /usr/src/timely/target/timely.war ${DEPLOYMENT_DIR}


