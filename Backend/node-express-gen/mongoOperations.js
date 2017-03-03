var assert = require('assert');
var MongoClient = require('mongodb').MongoClient;
var mongoose = require('mongoose');
var Models = require('./models/models');
var bcrypt = require('bcrypt');
var bcrypt = require('bcrypt');

exports.createUser = function(document, callback) {
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
        callback(result);
    });
};

exports.loginUser = function(document, callback) {
    //TODO: Functionality here to authenticate the users using whatever means we want.
    var username = document["username"];
    var passAttempt = document["password"];
    
    console.log("Run");
    
    User.findOne({ username: username }, function(err, user) {
        console.log("test");
        if (err) {
            console.log("Error 1");
            return callback(error);
        } 
        if (!user) {
            console.log("Error 2");
            return callback(null, false, { message: 'Incorrect username. '});
        }
        
        bcrypt.compare(passAttempt, user.password, function(err, result) {
            console.log("Got to password");
            if (res == true) {
                callback(user);
            } else {
                callback(null, false, {message: 'Incorrect password. '});
            }
        })
    });
};


