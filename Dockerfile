# Use  Maven image for building
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app
COPY . .

# Build the Spring Boot application
RUN mvn clean package -DskipTests

# Use a compatible JDK image for running the application
FROM eclipse-temurin:17-jdk

WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

EXPOSE 9191

CMD ["java", "-jar", "app.jar"]
