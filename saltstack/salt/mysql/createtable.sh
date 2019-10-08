mysql -u root <<MYSQL
        DROP DATABASE IF EXISTS test;
        CREATE DATABASE IF NOT EXISTS test;
        USE test;
        CREATE TABLE users (user_id INT NOT NULL, name VARCHAR (30), PRIMARY KEY (user_id) );
MYSQL