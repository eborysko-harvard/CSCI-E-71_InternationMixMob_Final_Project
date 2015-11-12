/*Copyright 2012 Bob Easterday, Adobe Systems

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.*/

/* global cordova:true */

/*!
 * Module dependencies.
 */

/**
 * cordova.js for node.
 *
 * Think of this as cordova-node, which would be similar to cordova-android
 * or cordova-browser. The purpose of this module is to enable testing
 * of a plugin's JavaScript interface.
 *
 * When this module is first required, it will insert a global cordova
 * instance, which can hijack cordova-specific commands within the plugin's
 * implementation.
 *
 * Remember to require this module before the plugin that you want to test.
 *
 * Example:
 *
 *     var cordova = require('./helper/cordova'),
 *         myPlugin = require('../www/myPlugin');
 */

module.exports = global.cordova = cordova = {

  /**
   * cordova.require Mock.
   *
   * Hijacks all cordova.requires. By default, it returns an empty function.
   * You can define your own implementation of each required module before
   * or after it has been required.
   *
   * See `cordova.required` to learn how to add your own module implementation.
   */

  require: function(moduleId) {
    // define a default function if it doesn't exist
    if (!cordova.required[moduleId]) {
      cordova.required[moduleId] = function() {};
    }
    // create a new module mapping between the module Id and cordova.required.
    return new ModuleMap(moduleId);
  },

  /**
   * Cordova module implementations.
   *
   * A key-value hash, where the key is the module such as 'cordova/exec'
   * and the value is the function or object returned.
   *
   * For example:
   *
   *     var exec = require('cordova/exec');
   *
   * Will map to:
   *
   *     cordova.required['cordova/exec'];
   */

  required: {
    // populated at runtime
  }
};

/**
 * Module Mapper.
 *
 * Returns a function that when executed will lookup the implementation
 * in cordova.required[id].
 *
 * @param {String} moduleId is the module name/path, such as 'cordova/exec'
 * @return {Function}.
 */

function ModuleMap(moduleId) {
  return function() {
    // lookup and execute the module's mock implementation, passing
    // in any parameters that were provided.
    return cordova.required[moduleId].apply(this, arguments);
  };
}