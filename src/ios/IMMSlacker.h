#import <Cordova/CDV.h>

@interface IMMSlacker : CDVPlugin



@property (nonatomic, copy) NSString* slackClientID;
@property (nonatomic, assign) BOOL isSigningIn;
@property (nonatomic, assign) NSString* slackClientSecret;


- (void)postMessage:(CDVInvokedUrlCommand*)command;


- (void) slackAuthenticate:(CDVInvokedUrlCommand *) command;

- (void) checkPresence:(CDVInvokedUrlCommand *) command;

- (BOOL) checkTokenValidity;

//- (void) cordovaSlackLogout:(CDVInvokedUrlCommand *) command;

//- (void) getSlackAccessCode:(NSString* ) slackCode;

#pragma mark - Slack_Utility


+ (NSString *) makeRestAPICall : (NSString*) reqURLStr;

+ (NSString*) getStoredCodes : (NSString* ) key;


//-(void) slackLogout;

@end