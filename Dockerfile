FROM eclipse-temurin:17-jre-alpine
LABEL maintainer="Prueba EE"
ENV spring.application.name prueba-ms-v1
COPY build/libs/prueba-ms-*SNAPSHOT.jar /opt/app/prueba-ms-v1.jar
ENTRYPOINT ["java", "-Djava.file.encoding=UTF-8","-jar","/opt/app/prueba-ms-v1.jar"]
