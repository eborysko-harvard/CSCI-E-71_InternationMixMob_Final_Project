/*!
 * Module dependencies.
 */

var cordova = require('./helper/cordova'),
  Slack = require('../www/slack'),
  execSpy,
  execWin,
  options;

/*!
 * Specification.
 */

describe('cordova-plugin-slack', function () {
  beforeEach(function () {
    options = {android: {}, ios: {}};
    execWin = jasmine.createSpy();
    execSpy = spyOn(cordova.required, 'cordova/exec').andCallFake(execWin);
  });

  describe('Slack', function () {
    it("should exist", function () {
      expect(Slack).toBeDefined();
      expect(typeof Slack == 'object').toBe(true);
    });
  });
});
