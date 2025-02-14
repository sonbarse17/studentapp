# Use official MariaDB image
FROM mariadb:10.5

# Set environment variables
ENV MYSQL_ROOT_PASSWORD=password
ENV MYSQL_DATABASE=studentapp
ENV MYSQL_USER=sushant
ENV MYSQL_PASSWORD=sushant123

# Copy initial database schema
COPY init.sql /docker-entrypoint-initdb.d/

EXPOSE 3306
