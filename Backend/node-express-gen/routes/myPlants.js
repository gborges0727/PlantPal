var fs = require('fs');
var express = require('express');
var router = express.Router();
var model = require('../models/models');
var mongoose = require('mongoose');

router.get('/allPlants', function(req, res, next) { 
    model.User.findOne({username: req.body}, function(err, user){
	console.log(JSON.stringify('Got user: ' + req.body))
	if (err) throw err;
	else
	console.log('I GOT A USER!!!')
    })	
});

router.get('/specificPlant', function(req, res, next) {
    model.Flower.findOne({name: req.body}, function(err, flower){
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
            Description: flower.Description
        }
        
        res.writeHead(200, {
            'Content-Type': 'application/json'
        });
        
        res.end(flowerToSend);
    });
});
    
