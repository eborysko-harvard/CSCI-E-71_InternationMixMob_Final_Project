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
    
    it('should authenticate', function () {
      var success = function () {};
      var error = function () {};
      Slacker.authenticate(success, error, '');
      expect(execSpy).toHaveBeenCalledWith(
        success,
        error,
        'Slacker',
        'slackAuthenticate',
        ['']
      );
    });
    
    it('Authenticate with empty callbacks ', function () {
      Slacker.authenticate(null, null, '');
      expect(execSpy).toHaveBeenCalledWith(
        jasmine.any(Function),
        jasmine.any(Function),
        'Slacker',
        'slackAuthenticate',
        ['']
      );
    });
    
    it('should check presence', function () {
      var success = function () {};
      var error = function () {};
      Slacker.presence(success, error, 'S06158AV7');
      expect(execSpy).toHaveBeenCalledWith(
        success,
        error,
        'Slacker',
        'checkPresence',
        ['S06158AV7']
      );
    });
    
    it('Check Presence with empty callbacks ', function () {
      Slacker.presence(null, null, 'S06158AV7');
      expect(execSpy).toHaveBeenCalledWith(
        jasmine.any(Function),
        jasmine.any(Function),
        'Slacker',
        'checkPresence',
        ['S06158AV7']
      );
    });
    
    it('should disconnect from Slack', function () {
      var success = function () {};
      var error = function () {};
      Slacker.disconnect(success, error, '');
      expect(execSpy).toHaveBeenCalledWith(
        success,
        error,
        'Slacker',
        'slackDisconnect',
        []
      );
    });
    
    it('Disconnect with empty callbacks ', function () {
      Slacker.disconnect(null, null, '');
      expect(execSpy).toHaveBeenCalledWith(
        jasmine.any(Function),
        jasmine.any(Function),
        'Slacker',
        'slackDisconnect',
        []
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
