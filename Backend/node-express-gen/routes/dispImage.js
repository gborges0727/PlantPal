var fs = require('fs');
var express = require('express');
var router = express.Router();
var model = require('../models/models');
var mongoose = require('mongoose');

router.get('/getimages/:picurl', function(req, res, next) {
	res.writeHead(200, {
		'Content-Type': 'text/plain'
	});

	var pic = '/'+req.params.picurl
	
	res.end('display', {dispImg: pic});
});

module.exports = router;
