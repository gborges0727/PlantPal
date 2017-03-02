var assert = require('assert');
var MongoClient = require('mongodb').MongoClient;
var mongoose = require('mongoose');
var Models = require('./models/models');
var bcrypt = require('bcrypt');

checkPassword = function(password) {
    bcrypt.compare(password, hash, function(err, res) {
        if (res == true) {
            //TODO: Implement functionality to authenticate
        } else {
            console.log("Password was entered incorrectly");
        }
    });
};

exports.createUser = function(document, callback) {
    // Get the documents
    var newUser = new Models.User({
        firstname: document["firstname"],
        lastname: document["lastname"],
        username: document["username"],
        password: hashPassword(document["password"]),
        email: document["email"]
    });
    
    newUser.hashPassword(function(err) {
        if (err) throw err;
    });
    
    newUser.save(function(err, result) {
        if (err) throw err;
        console.log("User created successfully!");
        callback(result);
    });
};

exports.loginUser = function(document, callback) {
    User.find({
        username: document["username"]
    }, function(err, user) {
        if (err) throw err;
        console.log("User found!");
    });
    //TODO: Functionality here to authenticate the users using whatever means we want.
};