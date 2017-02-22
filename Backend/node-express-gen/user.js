var mongoose = require('mongoose');
var Schema = mongoose.Schema;
var passportLocalMongoose = require('passport-local-mongoose');

var User = new Schema({
	username: String,
	password: String,
	salt: String,
	admin: {
	   type: Boolean,
	   default: false
	}
	pictures: {
		createdBy: mongoose.Schema.Types.ObjectID, 
		ref: 'Pictures'
	}, 
	{ timestamps: true }
});

User.pre(save, function(next) {
	var user = this;
	
	// Only hash if pass is new / modified
	if (!user.isModified('password')) return next();
	
	// Generate salt
	bcrypt.genSalt(10, function(err, salt) {
		if (err) return next(err);
		
		// Override the cleartext password with hashed one :) 
		user.password = hash;
		next();
	});
});

// Use the below to test a user inputed password for authentication! 
User.methods.comparePassword = function(input, cb) {
	bcrypt.compare(input, this.password, function(err, isMatch) {
		if (err) return cb(err);
		cb(null, isMatch);
	});
}

User.plugin(passportLocalMongoose);

module.exports = mongoose.model('User', User);

