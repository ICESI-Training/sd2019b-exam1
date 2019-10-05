'use strict'
/** Require NodeJS libraries:
 * 1. Express: Router for define the API Endpoints, https://www.npmjs.com/package/express  
 */
var express = require('express');
var apiController = require('../controllers/controller');
var apiEndpoint = express.Router();

apiEndpoint.get('/microservices/:microserviceId', apiController.microservice);

module.exports = apiEndpoint;