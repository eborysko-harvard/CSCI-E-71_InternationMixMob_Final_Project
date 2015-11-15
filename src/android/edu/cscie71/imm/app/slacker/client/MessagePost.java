package edu.cscie71.imm.app.slacker.client;

public class MessagePost {
    private String channel;
    private String message;
    private boolean as_user = true;

    public MessagePost(String channel, String message) {
        //this.token = token;
        this.channel = channel;
        this.message = message;
    }

    public String getChannel() {
        return channel;
    }

    public void setChannel(String channel) {
        this.channel = channel;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public boolean isAs_user() {
        return as_user;
    }

    public void setAs_user(boolean as_user) {
        this.as_user = as_user;
    }
}