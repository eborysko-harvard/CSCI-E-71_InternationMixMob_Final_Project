var exec = cordova.require('cordova/exec');

var Slacker = function (options) {

};

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
    exec(successCallback, errorCallback, 'Slacker', 'postMessage', [message]);
  },

  /**
   * Slacker object
   *
   * Expose Slacker directly. Used for testing, generally you would use init()
   */
  Slacker: Slacker
};
