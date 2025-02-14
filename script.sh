#!/bin/bash

# Install Tomcat
curl -O https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.98/bin/apache-tomcat-9.0.98.zip
unzip apache-tomcat-9.0.98.zip
sudo yum install java-17 -y 

# Start Tomcat
cd apache-tomcat-9.0.98/bin/
bash catalina.sh start 

# Install MariaDB
sudo yum install mariadb105-server -y
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Create MySQL user and database
sudo mysql -u root <<EOF
CREATE USER 'sushant' IDENTIFIED BY 'sushant123';
GRANT ALL PRIVILEGES ON *.* TO 'sushant';
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
EXIT;
EOF

# Install Git and Clone Student UI Repository
sudo yum install git -y
git clone https://github.com/Pritam-Khergade/student-ui.git

# Install Maven and Build Application
cd student-ui
sudo yum install maven -y
mvn clean package
cd target
mv studentapp-2.2-SNAPSHOT.war studentapp.war
mv studentapp.war ~/apache-tomcat-9.0.98/webapps/.

# Download MySQL Connector
cd ~/apache-tomcat-9.0.98/lib/
curl -O https://s3-us-west-2.amazonaws.com/studentapi-cit/mysql-connector.jar

# Configure Tomcat Context
cat <<EOT >> ~/apache-tomcat-9.0.98/conf/context.xml
<Resource name="jdbc/TestDB" auth="Container" type="javax.sql.DataSource"
           maxTotal="500" maxIdle="30" maxWaitMillis="1000"
           username="sushant" password="sonbarse17" driverClassName="com.mysql.jdbc.Driver"
           url="jdbc:mysql://localhost:3306/studentapp?useUnicode=yes&amp;characterEncoding=utf8"/>
EOT

# Restart Tomcat
cd ~/apache-tomcat-9.0.98/bin/
bash catalina.sh stop
bash catalina.sh start

echo "StudentApp setup completed successfully."
