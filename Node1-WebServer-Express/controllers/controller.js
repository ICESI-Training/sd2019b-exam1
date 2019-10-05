'use strict'

// Define the actual service IPv4 and hostname:
var operativeSystem = require('os');
var networkInterfaces = operativeSystem.networkInterfaces();
var apiServiceLocation = {
    apiServiceName:operativeSystem.hostname(),
    apiServiceAddress: networkInterfaces['Conexión de red inalámbrica'][1].address
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
