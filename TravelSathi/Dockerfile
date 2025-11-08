# TravelSathi Backend Dockerfile
# Multi-stage build: Maven -> slim JRE image
FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
# Copy source
COPY src ./src
# Build application (skip tests for speed)
RUN mvn -q -DskipTests package

FROM eclipse-temurin:17-jre
WORKDIR /app
# Copy built jar
COPY --from=build /app/target/*.jar app.jar
ENV JAVA_OPTS=""
EXPOSE 9000
ENTRYPOINT ["sh","-c","java $JAVA_OPTS -jar app.jar"]
