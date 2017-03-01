// grab the things we need
var mongoose = require('mongoose');
var Schema = mongoose.Schema;

// create a schema
var UserSchema = new Schema({
    username: { type: String, unique: true },
    password: String,
    firstname: String,
    lastname: String,
    email: String,
    pictures:   {
        type: mongoose.Schema.Types.ObjectId,
        required: false,
        ref: 'PictureSchema'
    }
    created_at: Date, 
    updated_at: Date
});

var PictureSchema = new Schema({
    location: String, 
    creator: {
        type: mongoose.Schema.Types.ObjectId,
        required: true, 
        ref: 'UserSchema'
    }
});

User.methods.getName = function() {
    return (this.firstname + ' ' + this.lastname);
};

// the schema is useless so far
// we need to create a model using it
module.exports = mongoose.model('User', UserSchema);
module.exports = mongoose.model('Picture', PictureSchema);

// make this available to our Node applications
module.exports = Dishes;