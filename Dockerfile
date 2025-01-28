FROM image-registry.openshift-image-registry.svc:5000/openshift/java:openjdk-17-ubi8

# Set the working directory
WORKDIR /tmp

# Copy the Maven project files
COPY pom.xml .
COPY src ./src

# Set permissions for non-root execution
USER root
RUN chown -R 1001:0 /tmp

# Switch to non-root user
USER 1001

# Build the application JAR file
RUN mvn package -DskipTests

# Set working directory for runtime
WORKDIR /app

# Copy the built JAR file to the container
COPY --from=0 /tmp/target/*.jar app.jar

# Expose the application port (change it if needed)
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "app.jar"]
