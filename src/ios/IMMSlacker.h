#import <Cordova/CDV.h>



@interface IMMSlacker : CDVPlugin



@property (nonatomic, copy) NSString* slackClientID;
@property (nonatomic, assign) BOOL isSigningIn;
@property (nonatomic, assign) NSString* slackClientSecret;
@property (nonatomic, retain) NSString* currentCommandID;
@property (nonatomic, retain) NSString* loggedinUserName;


- (void)postMessage:(CDVInvokedUrlCommand*)command;


- (void) slackAuthenticate:(CDVInvokedUrlCommand *) command;

- (void) checkPresence:(CDVInvokedUrlCommand *) command;


- (void) getSlackAccessCode:(NSString *) slackCode;

- (void) slackDisconnect:(CDVInvokedUrlCommand *) command;

- (void) getChannelList:(CDVInvokedUrlCommand *) command;

#pragma mark - Slack_Utility

-(NSString*) getStoredAccessCode;

+ (NSString*) getStoredCodes : (NSString* ) key;

+ (id)sharedInstance;

@end