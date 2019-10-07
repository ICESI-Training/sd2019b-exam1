#!/bin/bash

sudo -u postgres -H sh -c "psql -c 'CREATE DATABASE pg_ds;'" -v

sudo -u postgres -H sh -c "psql -c '\c pg_ds'" -v

sudo -u postgres -H sh -c "psql -d pg_ds -c 'CREATE TABLE person(
    idnumber integer NOT NULL PRIMARY KEY,
    person_name VARCHAR (50) NOT NULL,
    lastname VARCHAR (50) NOT NULL
);'" -v

sudo -u postgres -H sh -c "psql -c 'ALTER USER postgres PASSWORD '\'postgres\'';'" -v 