/*!
 * Module dependencies.
 */

var cordova = require('./helper/cordova'),
  Slacker = require('../www/slack'),
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
    it("should exist", function () {
      expect(Slacker).toBeDefined();
      expect(typeof Slacker == 'object').toBe(true);
    });

    xit('should post message', function () {

    })
  });
});
