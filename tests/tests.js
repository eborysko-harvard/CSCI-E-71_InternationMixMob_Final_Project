exports.defineAutoTests = function() {

  describe('cordova-plugin-slacker', function() {

    it('should exist', function() {
      expect(Slacker).toBeDefined();
      expect(typeof Slacker.postMessage == 'function').toBe(true);
    });
  });
};