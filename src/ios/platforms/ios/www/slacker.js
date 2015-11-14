

var pluginName = "immSlackClient";
var initialized = false;

var Slacker = function () {};
Slacker.authenticate = function() {
    alert(pluginName);
    initialized = true;
    cordova.exec(function callback(data){
                 ''
                 },function errorHandler(err){
                 ''
                 },pluginName, 'cordovaSlackAuthenticate', []);
}

Slacker.presence = function(userid) {
    alert(pluginName);
    initialized = true;
    cordova.exec(function callback(data){
                 ''
                 },function errorHandler(err){
                 ''
                 },pluginName, 'cordovaSlackPresence', [userid]);
}


function errorHandlerFunction(err)
{
    confirm(err);
}
