var express = require('express')
var app = express()
var path = require('path')
app.set('view engine', 'ejs')

app.use(express.static(__dirname + '/userImages'))

app.get('/getimages/:picurl',function(req,res){	
	
	var pic ='/'+ req.params.picurl
	
	res.render('display', {dispImg: pic })
})

app.listen(80,function(){
	console.log('App listening on port 80')
})
