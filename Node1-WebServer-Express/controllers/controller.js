'use strict'

// Define the environmental variables (see .sample-env file and edit into .env)
var envirinmentalConfig = require('dotenv');
envirinmentalConfig.config();

var IPv4networkInterface = process.env.IPV4_NETWORK_INTERFACE;

// Define the actual service IPv4 and hostname:
var operativeSystem = require('os');
var networkInterfaces = operativeSystem.networkInterfaces();
var apiServiceLocation = {
    apiServiceName:operativeSystem.hostname(),
    apiServiceAddress: networkInterfaces[IPv4networkInterface][1].address
};

/**
 * Define the controller functions that will serve as the action listeners to respond to API requests.
 */
 var controller = {
    microservice: function(req, res){
        var microserviceId = req.params.microserviceId;
        return res.status(200).send({
            "status": "200 OK",
            "message": `Microservices API works for microserviceId: ${microserviceId}`,
            "webServerLocation": apiServiceLocation
        });
    }
 };

 module.exports = controller;
