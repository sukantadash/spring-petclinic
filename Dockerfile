# Stage 1: Build the JAR file
FROM registry.access.redhat.com/ubi8/openjdk-17:1.15-1.1682053058 AS builder

WORKDIR /build

# Optimize Maven build caching
COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src
RUN mvn package -DskipTests

# Stage 2: Create final runtime container
FROM registry.access.redhat.com/ubi8/openjdk-17-runtime-minimal:1.15-1.1682053056

WORKDIR /app

# Security: Add a non-root user
RUN groupadd -r appgroup && useradd -r -g appgroup appuser
USER appuser

# Copy built JAR file
COPY --from=builder /build/target/*.jar app.jar

# Expose the application port
EXPOSE 8080

# Run the application with optimized JVM settings
CMD ["java", "-XX:+UseContainerSupport", "-XX:MaxRAMPercentage=75.0", "-jar", "app.jar"]
