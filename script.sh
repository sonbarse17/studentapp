#!/bin/bash

# Install Tomcat
curl -O https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.99/bin/apache-tomcat-9.0.99.zip
echo "Download successful"
unzip apache-tomcat-9.0.99.zip
sudo yum install java-17 -y 
echo "Java installation successful"

# Start Tomcat
cd apache-tomcat-9.0.99/bin/
bash catalina.sh start 
sleep 10  # Wait for Tomcat to initialize

# Install MariaDB
sudo yum install mariadb105-server -y
sudo systemctl start mariadb
sudo systemctl enable mariadb
echo "MariaDB installed and started"

# Wait for MariaDB to be ready
sleep 5

# Create MySQL user and database
sudo mysql -u root <<EOF
CREATE USER 'sushant'@'localhost' IDENTIFIED BY 'sushant123';
GRANT ALL PRIVILEGES ON *.* TO 'sushant'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
CREATE DATABASE studentapp;
USE studentapp;
CREATE TABLE IF NOT EXISTS students (
    student_id INT NOT NULL AUTO_INCREMENT,
    student_name VARCHAR(100) NOT NULL,
    student_addr VARCHAR(100) NOT NULL,
    student_age VARCHAR(3) NOT NULL,
    student_qual VARCHAR(20) NOT NULL,
    student_percent VARCHAR(10) NOT NULL,
    student_year_passed VARCHAR(10) NOT NULL,
    PRIMARY KEY (student_id)
);
EOF
echo "Database and user setup completed"

# Install Git and Clone Student UI Repository
sudo yum install git -y
git clone https://github.com/Pritam-Khergade/student-ui.git

# Install Maven and Build Application
cd student-ui
sudo yum install maven -y
mvn clean package
cd target
mv studentapp-2.2-SNAPSHOT.war studentapp.war
mv studentapp.war ~/apache-tomcat-9.0.99/webapps/.
echo "WAR file deployed"

# Download MariaDB JDBC Driver
cd ~/apache-tomcat-9.0.99/lib/
curl -O https://downloads.mariadb.com/Connectors/java/connector-java-2.7.5/mariadb-java-client-2.7.5.jar

# Verify JDBC driver exists
if [[ -f mariadb-java-client-2.7.5.jar ]]; then
    echo "MariaDB JDBC driver downloaded successfully"
else
    echo "Error: MariaDB JDBC driver download failed!" && exit 1
fi

# Configure Tomcat Context
cat <<EOF > ~/apache-tomcat-9.0.99/conf/context.xml
<Context>
    <Resource name="jdbc/TestDB" auth="Container" type="javax.sql.DataSource"
           maxTotal="500" maxIdle="30" maxWaitMillis="1000"
           username="sushant" password="sushant123" 
           driverClassName="org.mariadb.jdbc.Driver"
           url="jdbc:mariadb://localhost:3306/studentapp?useUnicode=true&amp;characterEncoding=utf8"/>
</Context>
EOF
echo "Tomcat context.xml configured"

# Restart Tomcat
cd ~/apache-tomcat-9.0.99/bin/
bash catalina.sh stop
sleep 5
bash catalina.sh start
echo "StudentApp setup completed successfully."

# Debugging Info
echo "Checking Tomcat logs for errors..."
sleep 5
tail -n 20 ~/apache-tomcat-9.0.99/logs/catalina.out
