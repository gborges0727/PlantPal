var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var PictureSchema = new Schema({
    fileName: String,
    plantName: String, 
    uploader: String,
    percentage: String	
});

module.exports.PictureSchema = PictureSchema;
