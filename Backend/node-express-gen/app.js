var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var index = require('./routes/index');
var users = require('./routes/users');
var myPlants = require('./routes/myPlants');
var feed = require('./routes/feed');
var dispImg = require('./routes/dispImage');

var app = express();

// TODO: Implement HTTPS functionality for security  :) 

/*// Secure traffic only
app.all('*', function(req, res, next){
   if (req.secure) {
	return next();
   };
   res.redirect('https://'+req.hostname+':'+app.get('secPort')+req.url);
});
*/
// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

// uncomment after placing your favicon in /public
//app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({
    extended: false
}));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));
app.use('/', index);
app.use('/users', users);
app.use('/myPlants', myPlants);
app.use('/feed', feed);
app.use('/dispImages', dispImg);
// catch 404 and forward to error handler
app.use(function(req, res, next) {
    var err = new Error('Not Found');
    err.status = 404;
    next(err);
});

// error handler
app.use(function(err, req, res, next) {
    // set locals, only providing error in development
    res.locals.message = err.message;
    res.locals.error = req.app.get('env') === 'development' ? err : {};

    // render the error page
    res.status(err.status || 500);
    res.render('error');
});

module.exports = app;
