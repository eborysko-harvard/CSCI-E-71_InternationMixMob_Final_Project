var exec = cordova.require('cordova/exec');

var Slacker = function (options) {

};

var pluginName = "Slacker";

module.exports = {

  init: function (options) {
    return new Slacker(options);
  },

  postMessage: function (successCallback, errorCallback, message, channelId) {
    if (successCallback == null) {
      successCallback = function () {
      }
    }
    if (errorCallback == null) {
      errorCallback = function () {
      }
    }

    var args = [];
    args.push(message);
    if (channelId)
      args.push(channelId);
    exec(successCallback, errorCallback, pluginName, 'postMessage', args);
  },

// successCallback(channels[])
// errorCallback(messageString);
  getChannelList: function (successCallback, errorCallback, excludeArchivedChannels) {
    if (successCallback == null) {
      successCallback = function () {
      }
    }
    var parseJSONStringSuccess = function (jsonString) {
      var response = JSON.parse(jsonString);
      successCallback(response.channels);
    };

    if (errorCallback == null) {
      errorCallback = function () {
      }
    }
    exec(parseJSONStringSuccess, errorCallback, pluginName, 'getChannelList', [excludeArchivedChannels]);
},

authenticate: function(successCallback,errorCallback,options) {
               if (successCallback == null) {
               successCallback = function () {
               }
               }
               if (errorCallback == null) {
               errorCallback = function () {
               }
               }
    exec(successCallback,errorCallback,pluginName, 'slackAuthenticate', [options]);
},
               
checkTokenAvailibility: function (successCallback, errorCallback, options) {
if (successCallback == null) {
successCallback = function () {
}
}

if (errorCallback == null) {
errorCallback = function () {
}
}
exec(successCallback, errorCallback, pluginName, 'checkTokenAvailibility', [options]);
},

  presence: function (successCallback, errorCallback, userid) {
    if (successCallback == null) {
      successCallback = function () {
      }
    }
    if (errorCallback == null) {
      errorCallback = function () {
      }
    }
    exec(successCallback, errorCallback, pluginName, 'checkPresence', [userid]);
  },


  disconnect: function (successCallback, errorCallback) {
    if (successCallback == null) {
      successCallback = function () {
      }
    }
    if (errorCallback == null) {
      errorCallback = function () {
      }
    }
    exec(successCallback, errorCallback, pluginName, 'slackDisconnect', []);
  },

  /**
   * Slacker object
   *
   * Expose Slacker directly. Used for testing, generally you would use init()
   */
  Slacker: Slacker
};