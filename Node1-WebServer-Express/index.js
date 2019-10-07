'use strict'

/** Require NodeJS libraries:
 * 1. Express: WebServer, https://www.npmjs.com/package/express  
 * 2. Body-Parser: to process any request in JSON format, https://www.npmjs.com/package/body-parser 
 */
var express = require('express');
var bodyParser = require('body-parser');

// Creates an api Web Server application:
var apiService = express();
var port = 7894;

// API endpoints:
var apiEndpoints = require('./routes/routes');

// Middleware to process requests in JSON format:
apiService.use(bodyParser.urlencoded({
    extended: "false"
}));
// Middleware process only requests that have 'Content-Type':'application/json' as header:
apiService.use(bodyParser.json());

// CORS Policy to allow different origins to make request to this web server:
apiService.use((req, res, next) => {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Headers', 'Authorization, X-API-KEY, Origin, X-Requested-With, Content-Type, Accept, Access-Control-Allow-Request-Method');
    res.header('Access-Control-Allow-Methods', 'GET, POST');
    res.header('Allow', 'GET, POST');
    next();
});

// API Host URL and API endpoints:
apiService.use('/api/sd2019bExam1/', apiEndpoints);

// Start the API Service
apiService.listen(port, () => {
    console.log('API Service running ...');
});