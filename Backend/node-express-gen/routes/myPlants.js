var fs = require('fs');
var express = require('express');
var router = express.Router();
var model = require('../models/models');
var mongoose = require('mongoose');

router.post('/allPlants', function(req, res, next) {
    console.log(req.body);
    model.User.findOne({
        username: req.body["username"]
    }, function(err, user) {
        if (err) {
            console.log(err);
            res.writeHead(404, {
                'Content-Type': 'text/plain'
            });
            res.end('Error: Username was not found! Please try again');
        }
        
        var userPictures = JSON.stringify ({
            pictures: user.pictures
        });
        
        res.writeHead(200, {
            'Content-Type': 'application/json'
        });
        
        res.end(userPictures);
    });
});

router.post('/specificPlant', function(req, res, next) {
    model.Flower.findOne({
        flowerID: req.body["flowerName"]
    }, function(err, flower) {
        if (err) {
            res.writeHead(404, {
                'Content-Type': 'text/plain'
            });
            res.end('Flower was not found! Please try again');
        }

        var flowerToSend = JSON.stringify ({
            name: flower.Name,
            sciName: flower.ScientificName,
            family: flower.Family,
            nativeRegion: flower.NativeRegion,
            Description: flower.Description
        });

        res.writeHead(200, {
            'Content-Type': 'application/json'
        });

        res.end(flowerToSend);
    });
});

module.exports = router;
