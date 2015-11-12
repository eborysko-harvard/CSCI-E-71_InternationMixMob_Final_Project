//
//  immSlackClient.h
//  Slacker
//
//  Created by Manoj Shenoy on 11/11/15.
//
//

#import <Cordova/CDV.h>

@interface immSlackClient : CDVPlugin

- (void) cordovaSlackAuthenticate:(CDVInvokedUrlCommand *) command;

//- (void) cordovaSlackLogout:(CDVInvokedUrlCommand *) command;



#pragma mark - Slack_Utility

- (NSString *) slackAuthenticate;

//-(void) slackLogout;

@end
