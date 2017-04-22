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

        var userPictures = JSON.stringify({
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
        Name: req.body["flowerName"]
    }, function(err, flower) {
        if (err) throw err;
        if (!flower) {
            res.writeHead(404, {
                'Content-Type': 'text/plain'
            });
            res.end('Flower was not found! Please try again');
        } else {
            console.log(flower.Name);
            var flowerToSend = JSON.stringify({
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
        }
    });
});

router.post('/uploadPlant', function(req, res, next) {
    if (!req.body["name"] || !req.body["scientificName"] || !req.body["family"] ||
        req.body["nativeRegion"] || !Description: req.body["description"]) {
        res.writeHead(401, {
            'Content-Type': 'text/plain'
        });
        res.end('Missing flower elements!');
    } else {
        var newPlant = new model.Flower({
            Name: req.body["name"],
            ScientificName: req.body["scientificName"],
            Family: req.body["family"],
            NativeRegion: req.body["nativeRegion"],
            Description: req.body["description"]
        });

        model.Flower.findOne({
            Name: req.body["name"]
        }, function(err, flower) {
            if (err) throw err;
            else if (!flower) {
                newPlant.save(function(err, result) {
                    if (err) {
                        throw err;
                    } else {
                        console.log("Flower created successfully!");
                        res.writeHead(200, {
                            'Content-Type': 'text/plain'
                        });
                        res.end('Flower created successfully!');
                    }
                });
            } else {
                res.writeHead(401, {
                    'Content-Type': 'text/plain'
                });
                res.end('Flower already exists!');
            }
        });
    }
});

module.exports = router;
