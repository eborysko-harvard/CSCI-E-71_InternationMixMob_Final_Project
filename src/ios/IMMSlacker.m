#import "IMMSlacker.h"
#import "AppDelegate.h"
#import <Cordova/CDV.h>


//static void slackLoadMethod(Class class, SEL destinationSelector, SEL sourceSelector);

const NSString *slackAPIURL = @"https://slack.com/api/";
NSString *slackClientSecret;
NSString *slackClientID;
NSString *currentCallBackID;


NSString *slackAccessToken;

@implementation AppDelegate (SlackReturnHandle)


- (BOOL)application: (UIApplication *)application
            openURL: (NSURL *)url
  sourceApplication: (NSString *)sourceApplication
         annotation: (id)annotation {
    // call super
    
    if([url.scheme isEqualToString:@"slacker"]){
        
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
            //return [self application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
              CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                                messageAsString:@"Unable to authenticate with Slack"];
            CDVPlugin *plugin = [CDVPlugin alloc];
            [plugin.commandDelegate sendPluginResult:pluginResult callbackId:currentCallBackID ];
        }
        else
        {
            NSString *codeQuery = [codeParam objectAtIndex:0];
            NSString *code = [codeQuery stringByReplacingOccurrencesOfString:@"code=" withString:@""];
            //            IMMSlacker *immSlacker = [immSlacker init];
            [self getSlackAccessCode:code];
        }
        
        
        
        
    }
    
    
    return YES;
    
}

- (void) getSlackAccessCode:(NSString *) slackCode
{
    
    @try {
        
        if(!slackClientID)
        {
            slackClientID = [IMMSlacker getStoredCodes:@"SlackClientID"];
        }
        
        if(!slackCode)
        {
            //Send Error to client ?
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                              messageAsString:@"Unable to authenticate with Slack"];
            CDVPlugin *plugin = [CDVPlugin alloc];
            [plugin.commandDelegate sendPluginResult:pluginResult callbackId:currentCallBackID ];
            return;
        }
        
        // Create the REST call string.
        if(!slackClientSecret)
        {
            slackClientSecret = [IMMSlacker getStoredCodes:@"SlackClientSecret"];
        }
        NSString *restCallString = [NSString stringWithFormat:@"%@/oauth.access?client_id=%@&client_secret=%@&code=%@", slackAPIURL , slackClientID , slackClientSecret , slackCode ];
        
        
        NSString *responseString = [IMMSlacker makeRestAPICall: restCallString];
        NSData* responseData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *jsonArray=[NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
        slackAccessToken = [jsonArray objectForKey:@"access_token"];
        
        
        //store the access token
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:slackAccessToken forKey:@"SlackAccessToken"];
        
        [defaults synchronize];
        
        //slackConnection = [[NSURLConnection alloc]   initWithRequest:restRequest delegate:self];
        
        //This should be stub code. Need to figure how to move this one
        
        //  AppDelegate *slackAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        
        // NSString *slackNavigatePath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"www"];
        // [slackAppDelegate.viewController.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:slackNavigatePath]]];
        
        NSDictionary *jsonObj = [ [NSDictionary alloc]  initWithObjectsAndKeys: @"true", @"success",
                                 slackAccessToken, @"accessToken", nil];
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsDictionary:jsonObj];
        //   [self.commandDelegate sendPluginResult:pluginResult callbackId:currentCallBackID ]; //This callback is not working
        
    }
    @catch (NSException *exception) {
        
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                          messageAsString:@"Error authenticating with Slack"];
    }
    
    
}


@end

@implementation IMMSlacker


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
    
    currentCallBackID = command.callbackId;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    slackAccessToken = [defaults objectForKey:@"SlackAccessToken"];
    if(!slackAccessToken)
    {
        slackClientID =[IMMSlacker getStoredCodes:@"SlackClientID" ];
        
        if(!slackClientID)
        {
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                              messageAsString:@"Missing client ID url scheme in app .plist"];
            [self.commandDelegate sendPluginResult:pluginResult callbackId: command.callbackId];
            return;
        }
        
        NSString *slackAPIURL = [NSString  stringWithFormat:@"https://slack.com/oauth/authorize?client_id=%@&scope=read", slackClientID];
        NSURLRequest *slackRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:slackAPIURL]];
        
        CDVViewController* viewController = [CDVViewController new];
        viewController.view.tag = 5;
        [self.viewController.view addSubview:viewController.view];
        
        [viewController.webView loadRequest:slackRequest];
        
        NSDictionary *jsonObj = [ [NSDictionary alloc]  initWithObjectsAndKeys: @"true", @"success",
                                 slackAccessToken, @"accessToken", nil];
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                      messageAsDictionary:jsonObj];
        [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
        
        //[self.commandDelegate sendPluginResult:pluginResult callbackId: currentCallBackID];
        
    }
    
    
}

- (void) checkPresence:(CDVInvokedUrlCommand *)command
{
    NSString* userID = [command.arguments objectAtIndex:0];
    
    NSString *restCallString = [NSString stringWithFormat:@"%@/users.getPresence?token=%@&user=%@", slackAPIURL, slackAccessToken , userID ];
    
    NSString *responseString = [IMMSlacker makeRestAPICall: restCallString];
    NSData* responseData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *jsonArray=[NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
    
    NSDictionary *jsonObj = [[NSDictionary alloc] initWithObjectsAndKeys:@"true", @"success",
                             [jsonArray objectForKey:@"presence"], @"presence", nil];
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:jsonObj];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}



#pragma mark - Slack_Utility


+ (NSString *) makeRestAPICall : (NSString*) reqURLStr
{
    NSURLRequest *Request = [NSURLRequest requestWithURL:[NSURL URLWithString: reqURLStr]];
    NSURLResponse *resp = nil;
    NSError *error = nil;
    NSData *response = [NSURLConnection sendSynchronousRequest: Request returningResponse: &resp error: &error];
    NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"%@",responseString);
    return responseString;
}

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
