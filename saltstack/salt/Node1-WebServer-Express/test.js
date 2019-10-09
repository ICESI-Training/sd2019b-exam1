'use strict'

// Define the actual service IP:
var operativeSystem = require('os');
var networkInterfaces = operativeSystem.networkInterfaces();
var apiServiceLocation = {
    apiServiceName:operativeSystem.hostname(),
    apiServiceAddress: networkInterfaces['enp0s3'][1].address
};

console.log(apiServiceLocation);