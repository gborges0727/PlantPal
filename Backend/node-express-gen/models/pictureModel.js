var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var PictureSchema = new Schema({
    fileName: String,
    plantName: String, 
    uploader: String,
    percentMatch: String, 
    secondClosest: String, 
    secondClosestPercent: String	
});

module.exports.PictureSchema = PictureSchema;
