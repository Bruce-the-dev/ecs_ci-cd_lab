# Stage 1: Build the application
FROM eclipse-temurin:21-jdk-alpine AS builder

# Set working directory inside the container
WORKDIR /build

# Copy Maven wrapper and pom.xml first (for layer caching)
COPY .mvn/ .mvn/
COPY mvnw pom.xml ./

# Make mvnw executable and download dependencies (cached if pom.xml doesn't change)
RUN chmod +x mvnw && ./mvnw dependency:go-offline -B

# Copy source code
COPY src/ src/

# Build the application JAR (skip tests for speed; remove -DskipTests if you want tests in CI)
RUN ./mvnw clean package -DskipTests -B

# Stage 2: Runtime image (minimal)
FROM eclipse-temurin:21-jre-alpine

# Create a non-root user for security
RUN addgroup -S spring && adduser -S spring -G spring

# Set working directory
WORKDIR /app

# Copy only the built JAR from the builder stage
COPY --from=builder /build/target/*.jar app.jar

# Change ownership to non-root user
RUN chown spring:spring app.jar

# Switch to non-root user
USER spring

# Expose the port the app runs on (documentation only — doesn't actually publish)
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]