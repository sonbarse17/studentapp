# Base image
FROM tomcat:9.0.99-jdk17

# Set working directory
WORKDIR /app

# Install Git and Maven
RUN apt-get update && apt-get install -y git maven && rm -rf /var/lib/apt/lists/*

# Clone the Student UI repository
RUN git clone https://github.com/Pritam-Khergade/student-ui.git

# Build the application
WORKDIR /app/student-ui
RUN mvn clean package

# Copy the built WAR file to Tomcat webapps directory
RUN cp target/studentapp-2.2-SNAPSHOT.war /usr/local/tomcat/webapps/studentapp.war

# Download MariaDB JDBC Driver
RUN curl -o /usr/local/tomcat/lib/mariadb-java-client-2.7.5.jar \
    https://downloads.mariadb.com/Connectors/java/connector-java-2.7.5/mariadb-java-client-2.7.5.jar

# Configure Tomcat Context.xml
RUN echo '<Context>' \
    '<Resource name="jdbc/TestDB" auth="Container" type="javax.sql.DataSource"' \
    'maxTotal="500" maxIdle="30" maxWaitMillis="1000"' \
    'username="sushant" password="sushant123"' \
    'driverClassName="org.mariadb.jdbc.Driver"' \
    'url="jdbc:mariadb://mariadb:3306/studentapp?useUnicode=true&amp;characterEncoding=utf8"/>' \
    '</Context>' > /usr/local/tomcat/conf/context.xml

# Expose Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
