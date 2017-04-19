var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var FlowerSchema = new Schema({
    Name: String, 
    ScientificName: String, 
    Family: String, 
    NativeRegion: String, 
    Description: String,    
    created_at: Date,
    updated_at: Date
});

module.exports.FlowerSchema = FlowerSchema;