package edu.cscie71.imm.slacker.plugin;

import android.content.Context;
import android.content.SharedPreferences;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.json.JSONArray;
import org.json.JSONException;
import edu.cscie71.imm.app.slacker.client.ISlackerClient;
import edu.cscie71.imm.app.slacker.client.SlackerClient;

public class Slacker extends CordovaPlugin {

    private ISlackerClient slackerClient = new SlackerClient();
    private String token = "xoxp-10020492535-10036686290-14227963249-1cb545e1ae";
    private String immTestChannel = "C0F6U0R5E";
    private static final String PREFS = "Slacker";

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("postMessage")) {
            String message = args.getString(0);
            this.postMessage(message, callbackContext);
        }
        return false;
    }

    private void postMessage(String message, CallbackContext callbackContext) {
        String response = slackerClient.postMessage(token, immTestChannel, message);
        if (response.contains("\"ok\":true"))
            callbackContext.success(message);
        else
            callbackContext.error("Error posting to the Slack channel.");
    }

    private void storeOAuthToken(String token) {
        Context context = cordova.getActivity();
    	SharedPreferences.Editor editor = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE).edit();
 		editor.putString("token", token);
 		editor.apply();
    }

    private String getOAuthToken() {
        Context context = cordova.getActivity();
    	SharedPreferences prefs = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE);
        // Return null as default value
    	return prefs.getString("token", null);
    }
}
