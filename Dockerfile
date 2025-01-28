# Stage 1: Build the JAR file
FROM registry.access.redhat.com/ubi8/openjdk-17:1.15-1.1682053058 AS builder

# Set working directory
WORKDIR /build

# Copy Maven project files
COPY pom.xml .
COPY src ./src

# Install Maven and build the application
RUN yum install -y maven && mvn package -DskipTests

# Stage 2: Create final runtime container
FROM registry.access.redhat.com/ubi8/openjdk-17-runtime:1.15-1.1682053056
# Set the working directory
WORKDIR /app

# Copy the built JAR file from the builder stage
COPY --from=builder /build/target/*.jar app.jar

# Expose the application port
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "app.jar"]
