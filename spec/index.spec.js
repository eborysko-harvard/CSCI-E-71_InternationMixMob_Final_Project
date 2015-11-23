/*!
 * Module dependencies.
 */

var cordova = require('./helper/cordova'),
  Slacker = require('../www/slacker'),
  execSpy,
  execWin,
  options;

/*!
 * Specification.
 */

describe('cordova-plugin-slacker', function () {
  beforeEach(function () {
    options = {android: {}, ios: {}};
    execWin = jasmine.createSpy();
    execSpy = spyOn(cordova.required, 'cordova/exec').andCallFake(execWin);
  });

  describe('Slacker', function () {
    it('should exist', function () {
      expect(Slacker).toBeDefined();
      expect(typeof Slacker == 'object').toBe(true);
      expect(typeof Slacker.init == 'function').toBe(true);
      expect(typeof Slacker.postMessage == 'function').toBe(true);
    });

    it('should init new Slacker', function () {
      var slacker = Slacker.init(null);
      expect(typeof slacker == 'object').toBe(true);
    });

    it('should post message', function () {
      var success = function () {};
      var error = function () {};
      Slacker.postMessage(success, error, 'message test');
      expect(execSpy).toHaveBeenCalledWith(
        success,
        error,
        'Slacker',
        'postMessage',
        ['message test']
      );
    });

    it('post message with empty callbacks should create default functions', function () {
      Slacker.postMessage(null, null, 'message test');
      expect(execSpy).toHaveBeenCalledWith(
        jasmine.any(Function),
        jasmine.any(Function),
        'Slacker',
        'postMessage',
        ['message test']
      );
    });
  });
});
