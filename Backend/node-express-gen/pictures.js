var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var Pictures = new Schema({
    picURL: String,
    classification: String,
    image: BSON,
    creator: {
        createdBy: mongoose.Schema.Types.ObjectId,
        ref: 'User'
    }
}, {
    timestamps: true
});

module.exports = mongoose.model('Pictures', Pictures);