var assert = require('assert');
var MongoClient = require('mongodb').MongoClient;
var mongoose = require('mongoose');
var User = require('./models/userModel');
//var mongopromise = require('mongodb-promise');

var url = 'mongodb://localhost:27017/plantpal';

//mongoose.Promise = global.Promise;
mongoose.connect(url);
var db = mongoose.connection;

db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', function() {
    // we're connected!
    console.log("Connected correctly to database");
});

hashPassword = function(password) {
    bcrypt.hash(password, 10, function(err, hash) {
        return hash;
    });
};

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
    var newUser = new User({
        firstname: document["firstname"],
        lastname: document["lastname"],
        username: document["username"],
        password: hashPassword(document["password"]),
        email: document["email"]
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