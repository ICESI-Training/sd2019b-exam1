sudo -u postgres -i -H sh -c "psql -c 'DROP DATABASE IF EXISTS db_distribuidos;
CREATE DATABASE db_distribuidos;'"

sudo -u postgres -i -H sh -c "psql -c '\c db_distribuidos'";