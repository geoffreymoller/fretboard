
/**
 * Module dependencies.
 */

var express = require('express');

var app = module.exports = express.createServer();
var port = 80;

// Configuration

app.configure(function(){
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.compiler({ src: __dirname + '/public', enable: ['less', 'coffeescript'] }));
  app.use(express.logger());
  app.use(app.router);
  app.use(express.static(__dirname + '/public'));
});

app.configure('development', function(){
  port = 4000;
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true })); 
});

app.configure('production', function(){
  app.use(express.errorHandler()); 
});

// Routes
app.get('/', function(req, res){
  res.render('index', {
    title: 'Fretboard Visualizer'
  });
});

app.listen(port);
console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);
