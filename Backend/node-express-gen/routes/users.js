var express = require('express');
var router = express.Router();
var model = require('../models/models')
var operations = require('../mongoOperations')
var mongoose = require('mongoose');
var bcrypt = require('bcrypt');

/* GET users listing. */
router.get('/', function(req, res, next) {
  res.send('respond with a resource');
});

router.post('/login/', function(req, res, next) {
    var username = req.body["username"];
    var passAttempt = req.body["password"];
    
    console.log("Run");
    
    model.User.findOne({ username: username }, function(err, user) {
        console.log("test");
        if (err) {
            console.log("Error 1");
            return next(error);
        } 
        if (!user) {
            console.log("Error 2");
            return next(null, false, { message: 'Incorrect username. '});
        }
        
        if(bcrypt.compareSync(passAttempt, user.password)) {
            console.log("Password success");
            next(user);
        } else {
            console.log("Incorrect password");
            next(null, false, {message: 'Incorrect password. '});
        }
        /*
        bcrypt.compare(passAttempt, user.password, function(err, result) {
            console.log("Got to password");
            console.log(passAttempt);
            console.log(user.password);
            if (res == true) {
                console.log("Password success");
                next(user);
            } else {
                console.log("Incorrect password");
                next(null, false, {message: 'Incorrect password. '});
            }
        }) */
    });
    //TODO: Send responses
});

router.post('/register/', function(req, res, next) {
    operations.createUser(req.body, next);
    //TODO: Send responses
});

module.exports = router;
