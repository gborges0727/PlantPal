var express = require('express');
var router = express.Router();
var PythonShell = require('python-shell');

var plantName = '';
var options = {
    args: ['-p', '/var/www/plantpal.uconn.edu/ProjectFiles/RecogAlgorithms/plant_classification/images/plants/daisy2.jpg'],
    scriptPath: '/var/www/plantpal.uconn.edu/ProjectFiles/RecogAlgorithms/plant_classification/'
};
var pyshell = new pythonshell('myscript.py', options);

pyshell.on('message', function(message) {
    // received a message sent from the Python script
    console.log(message);
    plantName = message;
});

pyshell.end(function(err) {
    // This is where the error occurs
    if (err) throw err;
    console.log('Picture analysis complete');
    console.log('outputString: ' + plantName);
});