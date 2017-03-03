var express = require('express');
var router = express.Router();
var model = require('../models/models')
var mongoose = require('mongoose');
var bcrypt = require('bcrypt');

/* GET users listing. */
router.get('/', function(req, res, next) {
  res.send('respond with a resource');
});

router.post('/login/', function(req, res, next) {
    //TODO: Send responses
    
    // Check for users
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
    });    
});

router.post('/register/', function(req, res, next) {
    //TODO: Send responses
    // Get the documents
    var newUser = new Models.User({
        firstname: document["firstname"],
        lastname: document["lastname"],
        username: document["username"],
        password: document["password"],
        email: document["email"]
    });

    newUser.hashPassword(function(err) {
        if (err) throw err;
    });

    // TODO: Add functionality here in order to check if the attempted creation
    // already exists. If so, return the proper response back to the client. If not, 
    // return an ok response to the client. 
    newUser.save(function(err, result) {
        if (err) throw err;
        console.log("User created successfully!");
        next(result);
    });    
});

module.exports = router;
