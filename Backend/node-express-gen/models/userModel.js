// grab the things we need
var mongoose = require('mongoose');
var Schema = mongoose.Schema;

// create a schema
var UserSchema = new Schema({
    username: String,
    password: String,
    firstname: {
      type: String,
        default: ''
    },
    lastname: {
      type: String,
        default: ''
    },
    pictures:   {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'PictureSchema'
    }
});

var PictureSchema = new Schema({
    location: String, 
    creator: {
        type: mongoose.Schema.Types.ObjectId, 
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