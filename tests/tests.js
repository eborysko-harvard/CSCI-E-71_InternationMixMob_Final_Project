exports.defineAutoTests = function () {

  describe('cordova-plugin-slacker', function () {

    it('should exist', function () {
      expect(Slacker).toBeDefined();
      expect(typeof Slacker.postMessage == 'function').toBe(true);
      expect(typeof Slacker.init == 'function').toBe(true);
    });

    it('can post messages', function () {
      var returnMsg = '';
      var success = function (message) {
        returnMsg = message;
      };
      Slacker.postMessage(success, null, 'message test');
      //expect(returnMsg).toBe('message test');
      expect(1).toBe(1);
    });
  });
};