# Use official Maven image to build the application
FROM maven:3.8.6-openjdk-17 AS builder

# Set the working directory
WORKDIR /app

# Copy the project source code
COPY student-ui /app

# Run Maven build
RUN mvn clean package -DskipTests

# Use official Tomcat as the base image
FROM tomcat:9.0.98-jdk17

# Set environment variables
ENV MYSQL_HOST=db
ENV MYSQL_DATABASE=studentapp
ENV MYSQL_USER=sushant
ENV MYSQL_PASSWORD=sushant123

# Copy MySQL Connector to Tomcat lib directory
ADD https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.33.jar /usr/local/tomcat/lib/mysql-connector.jar

# Copy the built WAR file from the builder stage
COPY --from=builder /app/target/studentapp.war /usr/local/tomcat/webapps/

# Expose Tomcat's default port
EXPOSE 8080

# Start Tomcat server
CMD ["catalina.sh", "run"]
