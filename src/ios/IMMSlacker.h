#import <Cordova/CDV.h>

@interface IMMSlacker : CDVPlugin



@property (nonatomic, copy) NSString* clientID;
@property (nonatomic, assign) BOOL isSigningIn;
@property (nonatomic, assign) NSString* slackCode;


- (void)postMessage:(CDVInvokedUrlCommand*)command;


- (void) cordovaSlackAuthenticate:(CDVInvokedUrlCommand *) command;

- (void) cordovaSlackPresence:(CDVInvokedUrlCommand *) command;

//- (void) cordovaSlackLogout:(CDVInvokedUrlCommand *) command;

//- (void) getSlackAccessCode:(NSString* ) slackCode;

#pragma mark - Slack_Utility

- (void) slackAuthenticate;

- (NSString *) slackPresence:(NSString* ) userID;

+ (NSString *) makeRestAPICall : (NSString*) reqURLStr;

+ (NSString*) getClientID;


//-(void) slackLogout;

@end