var express = require('express');
var router = express.Router();
var user = require('../models/userModel')
var operations = require('../mongoOperations')
var mongoose = require('mongoose');

var url = 'mongodb://localhost:27017/plantpal';
mongoose.connect(url);
var db = mongoose.connection;

db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', function () {
    // we're connected!
    console.log("Connected correctly to database");
});

/* GET users listing. */
router.get('/', function(req, res, next) {
  res.send('respond with a resource');
});

router.post('/login/', function(req, res, next) {
    
});

router.post('/register/', function(req, res, next) {
    operations.insertDocument(db, req.body, 'User', next);
});

module.exports = router;
