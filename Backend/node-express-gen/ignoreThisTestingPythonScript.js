var express = require('express');
var router = express.Router();
var PythonShell = require('python-shell');
var exec = require('child_process').exec;
var cmd = 'python -W ignore /var/www/plantpal.uconn.edu/ProjectFiles/RecogAlgorithms/plant_classification/classify2.py -p /var/www/plantpal.uconn.edu/ProjectFiles/RecogAlgorithms/plant_classification/images/plants/daisy2.jpg';

exec(cmd, function(error, stdout, stderr) {
    if(stderr) {
        console.log(stderr);
    }
    console.log(stdout);
});
/*
var plantName = '';
var options = {
    args: ['-p', '/var/www/plantpal.uconn.edu/ProjectFiles/RecogAlgorithms/plant_classification/images/plants/daisy2.jpg'],
    scriptPath: '/var/www/plantpal.uconn.edu/ProjectFiles/RecogAlgorithms/plant_classification/'
};
var pyshell = new PythonShell('classify2.py', options);

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
}); */