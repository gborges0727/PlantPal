
var fs = require('fs');
var express = require('express');
var router = express.Router();
var model = require('../models/models');
var mongoose = require('mongoose');

router.get('/', function(req, res, next) {
    res.writeHead(200, {
        'Content-Type': 'text/plain'
    });
    res.end('Success');
});

function getNewestFile(dir, files, callback) {
    if (!callback) return;
    if (!files || (files && files.length === 0)) {
        callback();
    }
    if (files.length === 1) {
        callback(files[0]);
    }
    var newest = {
        file: files[0]
    };
    var checked = 0;
    fs.stat(dir + newest.file, function(err, stats) {
        newest.mtime = stats.mtime;
        for (var i = 0; i < files.length; i++) {
            var file = files[i];
            (function(file) {
                fs.stat(file, function(err, stats) {
                    ++checked;
                    if (stats.mtime.getTime() > newest.mtime.getTime()) {
                        newest = {
                            file: file,
                            mtime: stats.mtime
                        };
                    }
                    if (checked == files.length) {
                        callback(newest);
                    }
                });
            })(dir + file);
        }
    });
}

module.exports = router;