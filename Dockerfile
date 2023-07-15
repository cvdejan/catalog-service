#bulding simple docker image
#FROM amazoncorretto:17-alpine3.17
#WORKDIR workspace
#ARG JAR_FILE=target/*.jar
#COPY ${JAR_FILE} catalog-service.jar
#ENTRYPOINT ["java", "-jar", "catalog-service.jar"]


FROM eclipse-temurin:17 AS builder
WORKDIR workspace
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} catalog-service.jar
RUN java -Djarmode=layertools -jar catalog-service.jar extract

FROM eclipse-temurin:17
RUN useradd spring
USER spring
WORKDIR workspace
COPY --from=builder workspace/dependencies/ ./
COPY --from=builder workspace/spring-boot-loader/ ./
COPY --from=builder workspace/snapshot-dependencies/ ./
COPY --from=builder workspace/application/ ./
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "org.springframework.boot.loader.JarLauncher"]