sudo -u postgres -i -H sh -c "psql -d db_distribuidos -c 'DROP TABLE IF EXISTS minions; 
CREATE TABLE minions (
    cc VARCHAR(12) PRIMARY KEY,
    nombre varchar(30) NOT NULL,
    apellido varchar(30) NOT NULL);'"

sudo -u postgres -i -H sh -c "psql -c '\dt'";

sudo -u postgres -i -H sh -c "psql -c 'ALTER USER postgres PASSWORD '\'postgres\'';'";
