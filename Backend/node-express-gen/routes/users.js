var express = require('express');
var router = express.Router();
var model = require('../models/models');
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
    
    // Weird error happening with sending responses: To fix if we have time
    // Because it is otherwise functional :) 
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
            res.writeHead(200, {
                'Content-Type': 'text/plain'
            });
            // res.write -- JSON object with user info to add here
            res.end('User: ' + username + ' has signed in succesfully');
            next(user);
        } else {
            res.writeHead(200, {
                'Content-Type': 'text/plain'
            });
            res.end('Username: ' + username + ' has entered an incorrect password');
            console.log("Incorrect password");
            next(null, false, {message: 'Incorrect password. '});
        }
    });    
});

router.post('/register/', function(req, res, next) {
    //TODO: Send responses
    // Get the documents
    var newUser = new model.User({
        firstname: req.body["firstname"],
        lastname:  req.body["lastname"],
        username:  req.body["username"],
        password:  req.body["password"],
        email:     req.body["email"]
    });

    newUser.hashPassword(function(err) {
        if (err) throw err;
    });

    // TODO: Add functionality here in order to check if the attempted creation
    // already exists. If so, return the proper response back to the client. If not, 
    // return an ok response to the client. 
    newUser.save(function(err, result) {
        if (err) {
            console.log("User already exists :(");
            next(err);
        } else {
            console.log("User created successfully!");
            res.writeHead(200, {
                'Content-Type': 'text/plain'
            });
            res.end('User created successfully!');
            next(result);
        }
    });    
});

module.exports = router;
