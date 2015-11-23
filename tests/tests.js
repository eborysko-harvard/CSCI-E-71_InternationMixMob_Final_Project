exports.defineAutoTests = function () {

  describe('cordova-plugin-slacker', function () {

    it('should exist', function () {
      expect(Slacker).toBeDefined();
      expect(typeof Slacker.postMessage == 'function').toBe(true);
      expect(typeof Slacker.init == 'function').toBe(true);
    });

    it('can post messages', function (done) {
      var returnMsg = '';
      var success = function (message) {
        returnMsg = message;
      };
      setTimeout(function () {
        expect(returnMsg).toBe('message test');
        done();
      }, 100);
      Slacker.postMessage(success, null, 'message test');
    });
  });
};
