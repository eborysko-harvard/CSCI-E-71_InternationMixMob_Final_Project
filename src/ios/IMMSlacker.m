#import "IMMSlacker.h"
#import "AppDelegate.h"
#import <Cordova/CDV.h>
#import <IMMSlackerClient/IMMSlackerClient.h>

id<CDVCommandDelegate> retainCommand;
NSString *currentCallBackID;
NSString *slackAccessToken;

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
            IMMSlacker *immSlacker = [IMMSlacker alloc];
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
        
        IMMSlackerClient *immSlackerClient = [IMMSlackerClient alloc];
        

        immSlackerClient.SlackClientID = [IMMSlacker getStoredCodes:@"SlackClientID"];
        immSlackerClient.SlackClientSecret = [IMMSlacker getStoredCodes:@"SlackClientSecret"];
        
        slackAccessToken = [immSlackerClient getSlackAccessCode:slackCode  ];
        
        if(!slackAccessToken)
        {
            //Send Error to client ?
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                              messageAsString:@"Unable to authenticate with Slack"];
            [retainCommand sendPluginResult:pluginResult callbackId:currentCallBackID];
            return;
        }
        
        //store the access token
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:slackAccessToken forKey:@"SlackAccessToken"];
        
        [defaults synchronize];
        
        NSDictionary *jsonObj = [ [NSDictionary alloc]  initWithObjectsAndKeys: @"true", @"success",nil];
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsDictionary:jsonObj];
        [retainCommand sendPluginResult:pluginResult callbackId:currentCallBackID ];
        
    }
    @catch (NSException *exception) {
        
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Error authenticating with Slack"];
       // NSLog(exception.description);
        [retainCommand sendPluginResult:pluginResult callbackId:currentCallBackID ];
    }
    
    
}

- (void)postMessage:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* echo = [command.arguments objectAtIndex:0];
    
    if (echo != nil && [echo length] > 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


- (void) slackAuthenticate:(CDVInvokedUrlCommand *)command
{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    slackAccessToken = [defaults objectForKey:@"SlackAccessToken"];

    currentCallBackID = command.callbackId;
    retainCommand = self.commandDelegate;
    IMMSlackerClient *immSlackerClient = [IMMSlackerClient alloc];
    if(![immSlackerClient checkTokenValidity:slackAccessToken])
    {
        immSlackerClient.SlackClientID =[IMMSlacker getStoredCodes:@"SlackClientID" ];
        
        NSDictionary *options  = [command.arguments objectAtIndex:0];
    
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
    
    IMMSlackerClient  *immSlackerClient = [IMMSlackerClient alloc];
    immSlackerClient.SlackAccessToken = slackAccessToken;

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:[immSlackerClient checkPresence:userID]];
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



@end
