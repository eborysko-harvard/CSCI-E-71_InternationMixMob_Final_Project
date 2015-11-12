//
//  immSlackClient.m
//  Slacker
//
//  Created by Manoj Shenoy on 11/11/15.
//
//

#import "immSlackClient.h"

@implementation immSlackClient


- (void) cordovaSlackAuthenticate:(CDVInvokedUrlCommand *)command
{
    
    NSString *clientID = [self slackAuthenticate];
    NSDictionary *jsonObj = [ [NSDictionary alloc]  initWithObjectsAndKeys: @"true", @"success",
                             clientID, @"clientID", nil];
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                  messageAsDictionary:jsonObj];
    [self.commandDelegate sendPluginResult:pluginResult callbackId: command.callbackId];
    
}



#pragma mark - Slack_Utility

-(NSString *)slackAuthenticate
{
   // NSURLConnection *currentConnection;
    
    NSString *slackAPIURL = [NSString  stringWithFormat:@"https://slack.com/oauth/authorize"];
    slackAPIURL = [slackAPIURL stringByAppendingString:@"?client_id=10020492535.14066700832"];
    slackAPIURL = [slackAPIURL stringByAppendingString:@"&scope=read"];
    //slackAPIURL = [slackAPIURL stringByAppendingString:<#(nonnull NSString *)#>]
    
    //NSURL *requestURL = [NSURL URLWithString:slackAPIURL];
    
   // NSURLRequest *slackRequest = [NSURLRequest requestWithURL:requestURL];
    
    //currentConnection = [[NSURLConnection alloc] initWithRequest:slackRequest delegate: self];
    
    return slackAPIURL;
}


@end
