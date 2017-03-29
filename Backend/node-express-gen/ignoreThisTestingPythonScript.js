var express = require('express');
var router = express.Router();
var PythonShell = require('python-shell');

var plantName = '';
var options = {
    args: ['-p', '/var/www/plantpal.uconn.edu/ProjectFiles/Backend/node-express-gen/userImages/Hk5lUjO2g.jpg'],
    scriptPath: '/var/www/plantpal.uconn.edu/ProjectFiles/RecogAlgorithms/plant_classification/'
}

PythonShell.run('classify2.py', options, function(err, results) {
    if (err) throw err;
    // results is an array consisting of messages collected during execution
    console.log('results: %j', results);
});