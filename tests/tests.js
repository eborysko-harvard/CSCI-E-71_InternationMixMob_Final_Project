exports.defineAutoTests = function () {

  describe('cordova-plugin-slacker', function () {

    it('should exist', function () {
      expect(Slacker).toBeDefined();
      expect(typeof Slacker.init == 'function').toBe(true);
    });

    it('postMessage should exist', function () {
      expect(typeof Slacker.postMessage == 'function').toBe(true);
    });

    it('authenticate should exist', function () {
      expect(typeof Slacker.getChannelList == 'function').toBe(true);
    });

    it('presence should exist', function () {
      expect(typeof Slacker.postMessage == 'function').toBe(true);
    });

    it('disconnect should exist', function () {
      expect(typeof Slacker.disconnect == 'function').toBe(true);
    });
  });
};
