package edu.cscie71.imm.app.slacker.client;

public class SlackClient implements ISlackClient {
    @Override
    public boolean postMessage(String token, MessagePost message) {
        return true;
    }
}
