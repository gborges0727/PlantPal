var fs = require('fs');
var express = require('express');
var router = express.Router();
var model = require('../models/models');
var mongoose = require('mongoose');
var sys = require('sys');
var exec = require('child_process').exec;

router.get('/', function(req, res, next) {
    var cmd = "ls -Aru | tail -n 10";
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
            var myTest = stdout;
            var pics = JSON.stringify({
                pictures: myTest
            });
            res.writeHead(200, {
                'Content-Type': 'application/json'
            });

            res.end(flowerToSend);
        }
    });
});

module.exports = router;