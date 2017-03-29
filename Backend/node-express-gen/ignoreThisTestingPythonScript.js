var express = require('express');
var router = express.Router();
var pythonshell = require('python-shell');
pythonshell.defaultOptions = { scriptPath: '/var/www/plantpal.uconn.edu/ProjectFiles/RecogAlgorithms/plant_classification/'
};

var plantName = '';
var options = {args: ['-p', '/var/www/plantpal.uconn.edu/ProjectFiles/Backend/node-express-gen/userImages/Hk5lUjO2g.jpg']}
var pyshell = new pythonshell('classify2.py', options);

pyshell.on('message', function(message) {
    // received a message sent from the Python script (a simple "print" statement)
    console.log(message);
    plantName = message;
});

pyshell.end(function(err) {
    if (err) throw err;
    console.log('Picture analysis complete');
    console.log('plantname: ' + plantName);
});