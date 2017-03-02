// grab the things we need
var mongoose = require('mongoose');
var Schema = mongoose.Schema;

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
    pictures: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'PictureSchema'
    },
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

UserSchema.methods.hashPassword = function(this.password) {
    bcrypt.hash(this.password, 10, function(err, hash) {
        if err throw err;
        this.password = hash;
    });
};

//UserSchema.methods.getPictures = function() {
//};

// the schema is useless so far
// we need to create a model using it
module.exports.UserSchema = UserSchema;
module.exports.PictureSchema = PictureSchema;