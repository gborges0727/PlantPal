var fs = require('fs');
var express = require('express');
var router = express.Router();
var model = require('../models/models');
var mongoose = require('mongoose');

router.get('/allPlants', function(req, res, next) {
    model.User.findOne({
        username: req.body
    }, function(err, user) {
        if (err) throw err;
	var pictures = JSON.stringify {
		location: user.location
		plantType : user.plantType
	}
	
	res.writeHead(200,{
	'Content-Type': 'application/json'
         });
	res.end(pictures);	
    });
});

router.get('/specificPlant', function(req, res, next) {
    model.Flower.findOne({
        name: req.body
    }, function(err, flower) {
        if (err) {
            res.writeHead(404, {
                'Content-Type': 'text/plain'
            });
            res.end('Flower was not found! Please try again');
        }

        var flowerToSend = JSON.stringify {
            name: flower.name,
            sciName: flower.scientificName,
            family: flower.family,
            nativeRegion: flower.nativeRegion,
        
        }

        res.writeHead(200, {
            'Content-Type': 'application/json'
        });

        res.end(flowerToSend);
    });
});
