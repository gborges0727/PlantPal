var express = require('express');
var router = express.Router();
var user = require('../models/userModel')
var operations = require('../mongoOperations')
var mongoose = require('mongoose');

/* GET users listing. */
router.get('/', function(req, res, next) {
  res.send('respond with a resource');
});

router.post('/login/', function(req, res, next) {
    
});

router.post('/register/', function(req, res, next) {
    user.inserUser(req.body, next);
});

module.exports = router;
