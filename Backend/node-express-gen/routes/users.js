var express = require('express');
var router = express.Router();
var model = require('../models/models');
var mongoose = require('mongoose');
var bcrypt = require('bcrypt');
var multer = require('multer');
var upload = multer({ storage: multer.memoryStorage() });
var shortid = require('shortid');

var storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, '/var/www/plantpal.uconn.edu/ProjectFiles/Backend/node-express-gen/userImages')
    }, 
    filename: function(req, file, cb) {
        cb(null, file.fieldname + '-' + Date.now())
    }
});
var upload = multer({storage: storage});

/* GET users listing. */
router.get('/', function(req, res, next) {
  res.send('respond with a resource');
});

router.post('/upload/', upload.single('plantPic'), (req, res) => {
    // Save here - req.file = picture, req.body = other data (username)
    var username = req.body;
    var newName = shortid.generate();
    var pic = fs.rename(req.file, newName, function(err) {
        if err throw err; 
        console.log("Image renamed");
    });
    
    // Analyze image here! Then save analysis alongside the image (somehow :D, may need to modify schema)
    upload(pic, res, function(err) {
        if err throw err;
        console.log("Image uploaded successfully");
        var id = model.User.findOne(username._id);
        model.User.findOneAndUpdate({username: username},
            {$push: {"pictures": {location: "/var/www/plantpal.uconn.edu/ProjectFiles/Backend/node-express-gen/userImages/" + newName}}},
            {safe: true, upsert: true},
            function(err, user) {
            if err throw err;
        });
    });
    
    // save pic & username here -- also the code to analyze images goes here :) 
});

router.post('/login/', function(req, res, next) {
    //TODO: Send responses
    
    // Check for users
    var username = req.body["username"];
    var passAttempt = req.body["password"];
    
    console.log("Run");
    
    // Weird error happening with sending responses: To fix if we have time
    // Because it is otherwise functional :) 
    model.User.findOne({ username: username }, function(err, user) {
        console.log("test");
        if (err) {
            console.log("Error 1");
            return next(error);
        } 
        if (!user) {
            console.log("Error 2");
            return next(null, false, { message: 'Incorrect username. '});
        }
        
        if(bcrypt.compareSync(passAttempt, user.password)) {
            console.log("Password success");
            res.writeHead(200, {
                'Content-Type': 'text/plain'
            });
            // res.write -- JSON object with user info to add here
            res.end('User: ' + username + ' has signed in succesfully');
        } else {
            res.writeHead(200, {
                'Content-Type': 'text/plain'
            });
            res.end('Username: ' + username + ' has entered an incorrect password');
            console.log("Incorrect password");
        }
    });    
});

router.post('/register/', function(req, res, next) {
    //TODO: Send responses
    // Get the documents
    var newUser = new model.User({
        firstname: req.body["firstname"],
        lastname:  req.body["lastname"],
        username:  req.body["username"],
        password:  req.body["password"],
        email:     req.body["email"]
    });

    newUser.hashPassword(function(err) {
        if (err) throw err;
    });
    
    model.User.findOne({username: req.body["username"]}, function(err, user){
        if (err) throw err;
        else if (!user) {
            newUser.save(function(err, result) {
                if (err) {
                    throw err;
                } else {
                    console.log("User created successfully!");
                    res.writeHead(200, {
                        'Content-Type': 'text/plain'
                    });
                    res.end('User created successfully!');
                }
            });   
        }
        else {
            res.writeHead(200, {
                'Content-Type': 'text/plain'
            });
            res.end('User already exists!');
        }
    });
});

module.exports = router;
