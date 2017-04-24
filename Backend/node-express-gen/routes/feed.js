var fs = require('fs');
var express = require('express');
var router = express.Router();
var model = require('../models/models');
var mongoose = require('mongoose');
var sys = require('sys');
var exec = require('child_process').exec;

router.get('/', function(req, res, next) {
    var cmd = "ls -Aru /var/www/plantpal.uconn.edu/ProjectFiles/Backend/node-express-gen/userImages/ | tail -n 10";
    exec(cmd, function(error, stdout, stderr) {
        if(error) throw err;
        else if (stderr) {
            console.log(stderr);
            res.writeHead(501, {
                'Content-Type': 'text/plain'
            });
            res.end('Error Running server command.');
        }
        else {
            console.log(stdout);
            var myTest = stdout;
            var pics = JSON.stringify({
                pictures: myTest
            });
            res.writeHead(200, {
                'Content-Type': 'application/json'
            });

            res.end(pics);
        }
    });
});

// Takes one plant pic name at a time! 
router.post('/getPlantInfo', function(req, res, next) {
    var plantFileName = req.body["fileName"];
    console.log(plantFileName);
    model.Picture.findOne({
        fileName: plantFileName
    }, function(err, picture) {
        if (err) throw err;
        else if(!picture) {
            console.log("Picture not found! ");
            res.writeHead(404, {
                'Content-Type': 'text/plain'
            });
            
            res.end("Picture with that filename not found! ");
        }
        else {
            var picInfo = JSON.stringify({
                plantName: picture["plantName"], 
                uploader: picture["uploader"]
            });
            res.writeHead(200, {
                'Content-Type': 'application/json'
            });
            res.end(picInfo);
        }
    });
});

module.exports = router;