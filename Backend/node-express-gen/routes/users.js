var express = require('express');
var router = express.Router();
var model = require('../models/models');
var mongoose = require('mongoose');
var bcrypt = require('bcrypt');
var formidable = require('formidable');
var shortid = require('shortid');
var fs = require('fs');

/* GET users listing. */
router.get('/', function(req, res, next) {
    res.send('respond with a resource');
});

router.post('/upload/', function(req, res) {
    var newName = shortid.generate();
    var form = new formidable.IncomingForm();

    // Rename the uploaded file :D
    form.parse(req);
    form.on('fileBegin', function(name, file) {
        file.path = '/var/www/plantpal.uconn.edu/ProjectFiles/Backend/node-express-gen/userImages/' + newName + '.jpg';
    });

    form.on('file', function(field, file) {
        console.log('Uploaded ' + file.name);
    });

    form.on('error', function(err) {
        console.log('An error has occured: \n' + err);
    });

    form.on('end', function() {
        res.end('success');
    });

    var username = req.body["username"];

    model.User.findOneAndUpdate({
            username: username
        }, {
            $set: {
                "pictures": {
                    location: "/var/www/plantpal.uconn.edu/ProjectFiles/Backend/node-express-gen/userImages/" + newName + ".jpg"
                }
            }
        }, {
            safe: true,
            upsert: false
        },
        function(err, user) {
            if (err) throw err;
        });

});

router.post('/login/', function(req, res, next) {
    //TODO: Send responses

    // Check for users
    var username = req.body["username"];
    var passAttempt = req.body["password"];

    console.log("Run");

    // Weird error happening with sending responses: To fix if we have time
    // Because it is otherwise functional :) 
    model.User.findOne({
        username: username
    }, function(err, user) {
        console.log("test");
        if (err) {
            console.log("Error 1");
            return next(error);
        }
        if (!user) {
            console.log("Error 2");
            return next(null, false, {
                message: 'Incorrect username. '
            });
        }

        if (bcrypt.compareSync(passAttempt, user.password)) {
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
        lastname: req.body["lastname"],
        username: req.body["username"],
        password: req.body["password"],
        email: req.body["email"]
    });

    newUser.hashPassword(function(err) {
        if (err) throw err;
    });

    model.User.findOne({
        username: req.body["username"]
    }, function(err, user) {
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
        } else {
            res.writeHead(200, {
                'Content-Type': 'text/plain'
            });
            res.end('User already exists!');
        }
    });
});

module.exports = router;