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

getChannelList: function (successCallback, errorCallback, excludeArchivedChannels) {
    if (successCallback == null) {
        successCallback = function () {
        }
    }
    if (errorCallback == null) {
        errorCallback = function () {
        }
    }
    exec(successCallback, errorCallback, pluginName, 'getChannelList', [excludeArchivedChannels]);
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

presence: function(successCallback, errorCallback, userid) {
               if (successCallback == null) {
               successCallback = function () {
               }
               }
               if (errorCallback == null) {
               errorCallback = function () {
               }
               }
    exec(successCallback,errorCallback,pluginName, 'checkPresence', [userid]);
},


disconnect: function(successCallback, errorCallback) {
               if (successCallback == null) {
               successCallback = function () {
               }
               }
               if (errorCallback == null) {
               errorCallback = function () {
               }
               }
               exec(successCallback,errorCallback,pluginName, 'slackDisconnect', []);
},

    /**
     * Slacker object
     *
     * Expose Slacker directly. Used for testing, generally you would use init()
     */
Slacker: Slacker
};
