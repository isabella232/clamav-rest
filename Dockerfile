#0
FROM maven:latest as builder
COPY . .
RUN mvn install -DskipTests
RUN find / | grep clamav-rest-.*.jar

#1
FROM openjdk:8-slim
ENV CLAMD_PORT=3310 \
    MAXSIZE=10240MB \
    TIMEOUT=10000

# Get the JAR file
RUN mkdir /var/clamav-rest
COPY --from=0 /target/clamav-rest-1.0.2.jar /var/clamav-rest/clamav-rest-1.0.2.jar

# Define working directory.
WORKDIR /var/clamav-rest/

# Open up the server
EXPOSE 8080

USER nobody

CMD ["/bin/bash", "-c", "java -jar /var/clamav-rest/clamav-rest-1.0.2.jar --clamd.host=${CLAMD_HOST} --clamd.port=${CLAMD_PORT} --clamd.maxfilesize=${MAXSIZE} --clamd.maxrequestsize=${MAXSIZE} --clamd.timeout=${TIMEOUT}" ]
