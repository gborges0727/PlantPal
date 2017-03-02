// This file is used to open the connection to the database as well as 
// to accumulate all of the various models into one file.
var mongoose = require('mongoose');
var Users = require('./userModel');

mongoose.connect('mongodb://localhost:27017/plantpal');
var db = mongoose.connection;

db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', function() {
    // we're connected!
    console.log("Connected correctly to database");
});

var User = mongoose.model('User', Users.UserSchema);

module.exports.User = User;