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
  
  

var Slacker = function () {};
Slacker.authenticate = function() {
    cordova.exec(function callback(data){
                 ''
                 },function errorHandler(err){
                 ''
                 },pluginName, 'authenticate', []);
}

Slacker.presence = function(userid) {
    cordova.exec(function callback(data){
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
