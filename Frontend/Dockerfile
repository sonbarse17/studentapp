# Use official Maven image with OpenJDK 17
FROM maven:latest AS builder

# Set the working directory
WORKDIR /app

# Copy the project source code
COPY . /app/

# Run Maven build
RUN mvn clean package -DskipTests

# Use official Tomcat with OpenJDK 17
FROM tomcat:9.0.99-jdk17

# Set environment variables for database connection
ENV MYSQL_HOST=db
ENV MYSQL_DATABASE=studentapp
ENV MYSQL_USER=sushant
ENV MYSQL_PASSWORD=sushant123

# Copy MySQL Connector (ensure it's in your project root)
COPY mysql-connector.jar /usr/local/tomcat/lib/

# Copy the built WAR file from the builder stage
COPY --from=builder /app/target/studentapp.war /usr/local/tomcat/webapps/

# Ensure Tomcat has proper permissions
RUN chown -R tomcat:tomcat /usr/local/tomcat/webapps /usr/local/tomcat/lib

# Expose Tomcat's default port
EXPOSE 8080

# Start Tomcat server
CMD ["catalina.sh", "run"]
