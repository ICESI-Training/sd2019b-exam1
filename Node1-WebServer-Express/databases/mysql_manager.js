'use strict'

// References: https://www.npmjs.com/package/mysql

// Define the environmental variables (see .sample-env file and edit into .env)
var environmentalConfig = require('dotenv');
environmentalConfig.config();

// Database connector configuration:
// References: https://stackoverflow.com/questions/44946270/er-not-supported-auth-mode-mysql-server
var mysql = require('mysql');
var connection = mysql.createConnection({
    host: process.env.DATABASE_HOSTNAME,
    user: process.env.DATABASE_USER,
    password: process.env.DATABASE_PASSWORD,
    database: process.env.DATABASE_SCHEMA,
    insecureAuth: true,
    port: process.env.DATABASE_PORT
});

module.exports = connection;