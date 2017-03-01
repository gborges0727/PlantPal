// grab the things we need
var mongoose = require('mongoose');
var Schema = mongoose.Schema;
var url = 'mongodb://localhost:27017/plantpal';

mongoose.connect(url);
var db = mongoose.connection;

db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', function () {
    // we're connected!
    console.log("Connected correctly to database");
});


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
    },
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

UserSchema.methods.getName = function() {
    return (this.firstname + ' ' + this.lastname);
};

UserSchema.methods.insertUser = function(db, document, 'User', callback) {
    // Get the documents collection
    var coll = db.collection(collection);
    // Insert some documents
    coll.insert(document, function(err, result) {
        assert.equal(err, null);
        console.log("Inserted " + result.result.n + " documents into the document collection " +
            collection);
        callback(result);
    });
};

// the schema is useless so far
// we need to create a model using it
module.exports = mongoose.model('User', UserSchema);
module.exports = mongoose.model('Picture', PictureSchema);
