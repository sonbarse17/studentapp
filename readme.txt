
#tomcat install
curl -O https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.98/bin/apache-tomcat-9.0.98.zip
unzip apache-tomcat-9.0.98.zip
sudo yum install java-17 -y 
cd apache-tomcat-9.0.98/bin/
bash catalina.sh start 

#self hosted db installation
sudo yum install mariadb105-server -y
sudo systemctl start mariadb
sudo systemctl enable mariadb

sudo mysql -u root 

#create user in db
create user sushant identified by "sushant123" ;
grant all privileges on * . * to sushant ;
Exit

##user login
Sudo mysql -u sushant -p 
Enter:- password 


CREATE DATABASE studentapp;
use studentapp;
CREATE TABLE if not exists students(student_id INT NOT NULL AUTO_INCREMENT,
	student_name VARCHAR(100) NOT NULL,
    student_addr VARCHAR(100) NOT NULL,
	student_age VARCHAR(3) NOT NULL,
	student_qual VARCHAR(20) NOT NULL,
	student_percent VARCHAR(10) NOT NULL,
	student_year_passed VARCHAR(10) NOT NULL,
	PRIMARY KEY (student_id)
);
Exit

#git install 

sudo yum install git -y 
git clone https://github.com/Pritam-Khergade/student-ui.git

# build application

cd student-ui
sudo yum install maven -y 

mvn clean package 
cd student-ui/target
ls 
## find studentapp-2.2-SNAPSHOT.war
mv studentapp-2.2-SNAPSHOT.war studentapp.war
mv studentapp.war ~/apache-tomcat-9.0.98/webapps/.
cd ~/apache-tomcat-9.0.98/webapps/

## add mysql-connector 

cd ~/apache-tomcat-9.0.98/lib/
curl -O https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.33.jar
mv mysql-connector-java-8.0.33.jar ~/apache-tomcat-9.0.98/lib/mysql-connector.jar


# add configuration in tomcat
cd ~/apache-tomcat-9.0.98/conf
vim context.xml

<Resource name="jdbc/TestDB" auth="Container" type="javax.sql.DataSource"
           maxTotal="500" maxIdle="30" maxWaitMillis="1000"
           username="sushant" password="sonbarse17" driverClassName="com.mysql.cj.jdbc.Driver"
           url="jdbc:mysql://localhost:3306/studentapp?useUnicode=yes&amp;characterEncoding=utf8"/>

## add user name and password

# context
# ## add here
# /context
 
cd ~/apache-tomcat-9.0.98/bin
bash catalina.sh stop
bash catalina.sh start