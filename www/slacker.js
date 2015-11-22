var exec = cordova.require('cordova/exec');

var Slacker = function (options) {

};

Slacker.prototype.postMessage = function (successCallback, errorCallback, message) {
  if (successCallback == null) {
    successCallback = function () {
    }
  }
  if (errorCallback == null) {
    errorCallback = function () {
    }
  }
  exec(successCallback, errorCallback, 'Slack', 'postMessage' [message]);
};

module.exports = {

  init: function (options) {
    return new Slacker(options);
  },

  /**
   * Slacker object
   *
   * Expose Slacker directly. Used for testing, generally you would use init()
   */
  Slacker: Slacker
};
