# Stage 1: Build the app
FROM eclipse-temurin:21-jdk AS builder

# Install Maven
RUN apt-get update && \
    apt-get install -y maven && \
    apt-get clean

WORKDIR /app

# Copy only source and pom.xml
COPY pom.xml ./ 
COPY src ./src

# Build the app (skip tests)
RUN mvn clean package -DskipTests

# Stage 2: Run the app
FROM eclipse-temurin:21-jdk

WORKDIR /app

# Copy built jar from builder stage
COPY --from=builder /app/target/*.jar app.jar

# Expose backend port
EXPOSE 8083

# Run the app
ENTRYPOINT ["java", "-jar", "app.jar"]
