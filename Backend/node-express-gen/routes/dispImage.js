var fs = require('fs');
var express = require('express');
var router = express.Router();
var model = require('../models/models');
var mongoose = require('mongoose');
var https = require('https');
var url = require('url');

router.get('/var/www/plantpal.uconn.edu/ProjectFiles/Backend/node-express-gen/userImages' + '/:picurl', function(req, res) {
	
	var pic = '/var/www/plantpal.uconn.edu/ProjectFiles/Backend/node-express-gen/userImages/' +  req.params.picurl;
	
	res.sendFile(pic);
});

module.exports = router;
