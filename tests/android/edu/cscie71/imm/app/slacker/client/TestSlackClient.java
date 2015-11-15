package edu.cscie71.imm.app.slacker.client;

import junit.framework.Assert;
import junit.framework.TestCase;
import org.junit.Before;
import org.junit.Test;

public class TestSlackClient extends TestCase {
    ISlackClient slack;
    String token = "xoxp-10020492535-10036686290-14227963249-1cb545e1ae";

    @Before
    public void setUp() {
        slack = new edu.cscie71.imm.app.slacker.client.SlackClient();
    }

    /*@Test
    public void postMessageToSlack() {
        MessagePost msg = new MessagePost("#testchannel", "This is a test.");
        response = slack.postMessage(token, msg);
        assertTrue(response);
    }*/

    @Test
    public void testPostMessage() throws Exception {
        Assert.assertTrue(slack.postMessage("", null));
    }
}