# Maven image for building
FROM maven:3.9.6-amazoncorretto-17 AS build

WORKDIR /app
COPY . .

# Build the Spring Boot application
RUN mvn clean package -DskipTests

# for running the application
FROM amazoncorretto:17-alpine

WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 9191

# Use environment variables for configuration
ENV SPRING_DATASOURCE_URL="jdbc:mysql://my-mysql:3306/javatechie"
ENV SPRING_DATASOURCE_USERNAME="root"
ENV SPRING_DATASOURCE_PASSWORD="Password"

#  health check for monitoring
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD curl -f http://localhost:9191/health || exit 1

# Run the application
CMD ["java", "-jar", "app.jar"]
