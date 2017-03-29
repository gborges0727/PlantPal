var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var FlowerSchema = new Schema({
    name: String, 
    scientificName: String, 
    family: String, 
    nativeRegion: String, 
    Description: String,    
    created_at: Date,
    updated_at: Date
});

module.exports.FlowerSchema = FlowerSchema;