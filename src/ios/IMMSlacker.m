#import "IMMSlacker.h"
#import "AppDelegate.h"
#import <Cordova/CDV.h>
#import <IMMSlackerClient/IMMSlackerClient.h>

id<CDVCommandDelegate> retainCommand;
NSString *currentCallBackID;
//NSString const *slackTestChannel = @"C0F6U0R5E";

@implementation AppDelegate (SlackReturnHandle)


- (BOOL)application: (UIApplication *)application
            openURL: (NSURL *)url
  sourceApplication: (NSString *)sourceApplication
         annotation: (id)annotation {
    // call super
    
    //This should match the client scheme not slacker scheme
    if([url.scheme isEqualToString:[IMMSlacker getStoredCodes:@"edu.cscie71.imm.app" ]]){
        
        //unload the authentication page if loaded.
        for(UIView *subview in [self.viewController.view subviews]){
            if(subview.tag == 5)
            {
                [subview removeFromSuperview];
            }
        }
        
        NSArray *queryParams = [[url query] componentsSeparatedByString:@"&"];
        NSArray *codeParam = [queryParams filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF BEGINSWITH %@", @"code="]];
        
        if([codeParam count] == 0)
        {
            // Need to send error to UI here.
            
            CDVPluginResult *pluginResult = [CDVPluginResult  resultWithStatus:CDVCommandStatus_ERROR
                                                              messageAsString:@"Unable to authenticate with Slack"];
            [retainCommand sendPluginResult:pluginResult callbackId:currentCallBackID ];
            return  NO;
            //return [self application:application handleOpenURL:url];
        }
        else
        {
            NSString *codeQuery = [codeParam objectAtIndex:0];
            NSString *code = [codeQuery stringByReplacingOccurrencesOfString:@"code=" withString:@""];
            IMMSlacker *immSlacker = [IMMSlacker sharedInstance];
            [immSlacker getSlackAccessCode:code];
        }
        
    }
    
    return YES;
    
}

@end

@implementation IMMSlacker

@synthesize loggedinUserName;


- (void) getSlackAccessCode:(NSString *) slackCode
{
    
    @try {
        
        IMMSlackerClient *immSlackerClient = [IMMSlackerClient sharedInstance];
        

        immSlackerClient.SlackClientID = [IMMSlacker getStoredCodes:@"SlackClientID"];
        immSlackerClient.SlackClientSecret = [IMMSlacker getStoredCodes:@"SlackClientSecret"];
        
        [immSlackerClient setSlackAccessCode:slackCode ];
        
        
        //store the access token
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:immSlackerClient.SlackAccessToken forKey:@"SlackAccessToken"];
        
        [defaults synchronize];
        
        NSDictionary *jsonObj = [ [NSDictionary alloc]  initWithObjectsAndKeys: @"true", @"success",nil];
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsDictionary:jsonObj];
        [retainCommand sendPluginResult:pluginResult callbackId:currentCallBackID ];
        
    }
    @catch (NSException *exception) {
        
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Error authenticating with Slack"];
        //NSLog(exception.description);
        [retainCommand sendPluginResult:pluginResult callbackId:currentCallBackID ];
    }
    
    
}

- (void)postMessage:(CDVInvokedUrlCommand*)command
{
    @try {
        
        
        
        NSString* message = [command.arguments objectAtIndex:0];
        NSString *channelID = @"C0F6U0R5E";
        if(command.arguments.count > 1)
            channelID = [command.arguments objectAtIndex:1];
        
        IMMSlackerClient *immSlackerClient = [IMMSlackerClient sharedInstance];
        
        [immSlackerClient postMessage:channelID :message];
        
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:message];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        
    }
    @catch (NSException *exception) {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Unable to post message"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }
}


- (void) slackAuthenticate:(CDVInvokedUrlCommand *)command
{
    
    currentCallBackID = command.callbackId;
    retainCommand = self.commandDelegate;
    IMMSlackerClient *immSlackerClient = [IMMSlackerClient sharedInstance];

    if (!immSlackerClient.SlackAccessToken) {
        immSlackerClient.SlackAccessToken = [self getStoredAccessCode];
    }
    
    if(![immSlackerClient checkTokenValidity])
    {
        immSlackerClient.SlackClientID =[IMMSlacker getStoredCodes:@"SlackClientID" ];
        
        NSArray *options;
        if(!command.arguments)
            options = [command.arguments objectAtIndex:0];
    
        NSURLRequest *slackRequest = [immSlackerClient slackAuthenticateURL:options];
        
        CDVViewController* viewController = [CDVViewController new];
        viewController.view.tag = 5;
        [self.viewController.view addSubview:viewController.view];
        
        [viewController.webView loadRequest:slackRequest];
    }
    else
    {
        NSDictionary *jsonObj = [ [NSDictionary alloc]  initWithObjectsAndKeys: @"true", @"success",nil];
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsDictionary:jsonObj];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId ];
    }
}

- (void) checkPresence:(CDVInvokedUrlCommand *)command
{
    NSString* userID = [command.arguments objectAtIndex:0];
    
    IMMSlackerClient  *immSlackerClient = [IMMSlackerClient sharedInstance];

    if (!immSlackerClient.SlackAccessToken) {
        immSlackerClient.SlackAccessToken = [self getStoredAccessCode];
    }

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:[immSlackerClient checkPresence:userID]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


-(void) getChannelList:(CDVInvokedUrlCommand *)command
{
    IMMSlackerClient *immSlackerClient = [IMMSlackerClient sharedInstance];
    
    if (!immSlackerClient.SlackAccessToken) {
        immSlackerClient.SlackAccessToken = [self getStoredAccessCode];
    }
    
    BOOL excludeArchived = [command.arguments objectAtIndex:0];
    
    NSDictionary *jsonObj = [immSlackerClient getChannelList:excludeArchived ];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObj
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                  messageAsString:jsonString];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}




#pragma mark - Slack_Utility



+ (NSString*) getStoredCodes : (NSString* ) key {
    NSArray* URLTypes = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"];
    
    if (URLTypes != nil) {
        for (NSDictionary* dict in URLTypes) {
            NSString *urlName = [dict objectForKey:@"CFBundleURLName"];
            if ([urlName isEqualToString:key]) {
                NSArray* URLSchemes = [dict objectForKey:@"CFBundleURLSchemes"];
                if (URLSchemes != nil) {
                    return [URLSchemes objectAtIndex:0];
                }
            }
        }
    }
    return nil;
}

- (void) slackDisconnect:(CDVInvokedUrlCommand *)command
{
    @try {
        
        //Remove the Stored access token
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"SlackAccessToken"];
        
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        
    }
    @catch (NSException *exception) {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Unable to post message"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }

}

- (NSString*) getStoredAccessCode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return ([defaults objectForKey:@"SlackAccessToken"]);
}

+ (id)sharedInstance
{
    //This will ensure that only one instance of the IMMSlacker object exists
    static dispatch_once_t p = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

@end
