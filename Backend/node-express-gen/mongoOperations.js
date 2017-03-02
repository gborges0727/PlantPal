var assert = require('assert');
var MongoClient = require('mongodb').MongoClient;
var mongoose = require('mongoose');
var Models = require('./models/models');
var bcrypt = require('bcrypt');
var passport = require('passport');
var LocalStrategy = require('passport-local').Strategy;
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
    var password = document["password"];
    
    passport.use(new LocalStrategy(
        function(username, password) {
            User.findOne({
                username: username
            }, function(err, user) {
                if (err) {
                    return callback(err);
                }
                if (!user) {
                    return callback(null, false, {
                        message: 'Incorrect username.'
                    });
                }
                
                // Checks password using bcrypt
                bcrypt.compareSync(passAttempt, password, function(err, result) {
                    if (err) return callback(err);
                    if (result === false) {
                        return callback(null, false, {
                            message: 'Incorrect password.'
                        });
                    } else {
                        console.log("Sign in successful");
                        return callback(null, user, {
                            message: 'User signed in successfully'
                        });
                    }
                });
            });
        }
    ));
};