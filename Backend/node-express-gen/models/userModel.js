// grab the things we need
var mongoose = require('mongoose');
var Schema = mongoose.Schema;
var bcrypt = require('bcrypt');

// create a schema
var UserSchema = new Schema({
    username: {
        type: String,
        unique: true
    },
    password: String,
    firstname: String,
    lastname: String,
    email: String,
    pictures: [{
        location: String, 
        plantType: String,
        percentage: String, 
        secondClosest: String, 
        secondClosestPercent: String
    }],
    created_at: Date,
    updated_at: Date
});

// May need to create Picture in a seperate model file: cannot be true when creating a new user
var PictureSchema = new Schema({
    location: String,
    creator: {
        type: mongoose.Schema.Types.ObjectId,
        //required: true, 
        ref: 'UserSchema'
    }
});

UserSchema.methods.getName = function() {
    return (this.firstname + ' ' + this.lastname);
};

UserSchema.methods.hashPassword = function() {
    var salt = bcrypt.genSaltSync(10);
    var hash = bcrypt.hashSync(this.password, salt);
    this.password = hash;
};

UserSchema.methods.checkPassword = function(passAttempt) {
    bcrypt.compareSync(passAttempt, this.password);
};

//UserSchema.methods.getPictures = function() {
//};

// the schema is useless so far
// we need to create a model using it
module.exports.UserSchema = UserSchema;
module.exports.PictureSchema = PictureSchema;
