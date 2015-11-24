var exec = cordova.require('cordova/exec');

var Slacker = function (options) {
    
};

var pluginName = "Slacker";

module.exports = {
    
init: function (options) {
    return new Slacker(options);
},
    
postMessage: function (successCallback, errorCallback, message) {
    if (successCallback == null) {
        successCallback = function () {
        }
    }
    if (errorCallback == null) {
        errorCallback = function () {
        }
    }
    exec(successCallback, errorCallback, pluginName, 'postMessage', [message]);
},
    
authenticate: function() {
    exec(function callback(data){
         ''
         },function errorHandler(err){
         ''
         },pluginName, 'slackAuthenticate', []);
},
    
presence: function(successCallback, errorCallback, message) {
    exec(function callback(data){
         ''
         },function errorHandler(err){
         ''
         },pluginName, 'checkPresence', [userid]);
},
    
    
    
    /**
     * Slacker object
     *
     * Expose Slacker directly. Used for testing, generally you would use init()
     */
Slacker: Slacker
};
