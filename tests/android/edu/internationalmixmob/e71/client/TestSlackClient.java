package edu.internationalmixmob.e71.client;

import edu.internationalmixmob.e71.client.*;

import static org.junit.Assert.*;

import org.junit.Before;
import org.junit.Test;

public class SlackClientTests {
    ISlackClient slack;
    String token = "xoxp-10020492535-10036686290-14227963249-1cb545e1ae";

    @Before
    public void setUp() {
        slack = new SlackClientHttpImp();
    }

    @Test
    public void postMessageToSlack() {
        MessagePost msg = new MessagePost("#testchannel", "This is a test.");
        response = slack.postMessage(token, msg);
        assertTrue(response);
    }
}