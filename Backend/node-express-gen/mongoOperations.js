var assert = require('assert');
var MongoClient = require('mongodb').MongoClient;
var mongoose = require('mongoose');
var User = require('./models/userModel');

var url = 'mongodb://localhost:27017/plantpal';

var mongoose.Promise = global.Promise;
mongoose.connect(url);
var db = mongoose.connection;

db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', function () {
    // we're connected!
    console.log("Connected correctly to database");
});

exports.insertUser = function(document) {
    // Get the documents
    var newUser = new User({
        firstname: document["firstname"],
        lastname: document["lastname"],
        username: document["username"], 
        password: document["password"],
        email: document["email"]
    });
    
    newUser.save(function(err) {
        if (err) throw err;
        
        console.log("User created successfully!");
    });
    
    //callback(result);
    
    /* Below is backup
    var coll = db.collection(collection);
    // Insert some documents
    coll.insert(document, function(err, result) {
        assert.equal(err, null);
        console.log("Inserted " + result.result.n + " documents into the document collection " +
            collection);
        callback(result);
    }); */
};

exports.findDocuments = function(db, collection, callback) {
    // Get the documents collection
    var coll = db.collection(collection);

    // Find some documents
    coll.find({}).toArray(function(err, docs) {
        assert.equal(err, null);
        callback(docs);
    });
};

exports.removeDocument = function(db, document, collection, callback) {

    // Get the documents collection
    var coll = db.collection(collection);

    // Delete the document
    coll.deleteOne(document, function(err, result) {
        assert.equal(err, null);
        console.log("Removed the document " + document);
        callback(result);
    });
};

exports.updateDocument = function(db, document, update, collection, callback) {

    // Get the documents collection
    var coll = db.collection(collection);

    // Update document
    coll.updateOne(document, {
        $set: update
    }, null, function(err, result) {

        assert.equal(err, null);
        console.log("Updated the document with " + update);
        callback(result);
    });
};
