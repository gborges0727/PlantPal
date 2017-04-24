var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var PictureSchema = new Schema({
    fileName: String,
    plantName: String, 
    uploader: String
});

module.exports.PictureSchema = PictureSchema;