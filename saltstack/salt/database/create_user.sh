sudo su - postgres
psql
CREATE USER postgres_user WITH PASSWORD 'password';
CREATE DATABASE distribuidos OWNER postgres_user;
\q
exit
sudo su - postgres_user
psql distribuidos
