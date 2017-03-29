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
    
});
