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
    operations.loginUser(req.body, next);
    //TODO: Send responses
});

router.post('/register/', function(req, res, next) {
    operations.createUser(req.body, next);
    //TODO: Send responses
});

module.exports = router;
