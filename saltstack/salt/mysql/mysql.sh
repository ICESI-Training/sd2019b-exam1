wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm;
yum -y install mysql-community-release-el7-5.noarch.rpm;
sudo yum install -y mysql-server;
sudo systemctl start mysqld;
sudo systemctl enable mysqld;
mysql -u root <<MYSQL
        DROP DATABASE IF EXISTS test;
        CREATE DATABASE IF NOT EXISTS test;
        USE test;
        CREATE TABLE users (user_id INT NOT NULL, name VARCHAR (30), PRIMARY KEY (user_id) );
