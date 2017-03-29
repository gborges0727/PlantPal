var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var FlowerSchema = new Schema({
    
    
    created_at: Date,
    updated_at: Date
});

module.exports.FlowerSchema = FlowerSchema;