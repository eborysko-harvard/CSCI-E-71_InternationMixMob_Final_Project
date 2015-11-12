package edu.cscie71.imm.app.slacker.client;

/**
 * Interface for the Slack plugin to exercise the Slack API.
 */

public interface ISlackClient {
    boolean postMessage(String token, MessagePost message);
}