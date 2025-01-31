# Stage 1: Build the JAR file
FROM registry.access.redhat.com/ubi8/openjdk-17:1.15-1.1682053058 AS builder

WORKDIR /build

# 1. Create target directory explicitly
RUN mkdir -p target

# 2. Optimize Maven build caching
COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src

# 3. Ensure directory exists before building
RUN mvn package -DskipTests

# Stage 2: Create final runtime container
FROM registry.access.redhat.com/ubi8/openjdk-17-runtime:1.15-1.1682053056

USER root

WORKDIR /app

RUN groupadd -r appgroup && useradd -r -g appgroup appuser
USER appuser

COPY --from=builder /build/target/*.jar app.jar

EXPOSE 8080

CMD ["java", "-XX:+UseContainerSupport", "-XX:MaxRAMPercentage=75.0", "-jar", "app.jar"]docker build -t petclinic:latest .
