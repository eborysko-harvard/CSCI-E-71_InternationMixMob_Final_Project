//
//  immSlackClient.m
//  Slacker
//
//  Created by Manoj Shenoy on 11/11/15.
//
//

#import "immSlackClient.h"
#import "AppDelegate.h"
#import "immCommonFunctions.h"

//static void slackLoadMethod(Class class, SEL destinationSelector, SEL sourceSelector);

const NSString *slackAPIURL = @"https://slack.com/api/";
static NSString *slackClientID = @"10020492535.14066700832"; // need to move to UI - supplied by user
static NSString *slackClientSecret = @"75d676a163b2e485f8428a1b0d1f710c"; // move to UI - supplied by user

NSString *slackAccessToken;

@implementation AppDelegate (SlackReturnHandle)


- (BOOL)application: (UIApplication *)application
                     openURL: (NSURL *)url
           sourceApplication: (NSString *)sourceApplication
                  annotation: (id)annotation {
            // call super
    
    if([url.scheme isEqualToString:@"slacker"]){
        NSArray *queryParams = [[url query] componentsSeparatedByString:@"&"];
        NSArray *codeParam = [queryParams filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF BEGINSWITH %@", @"code="]];
        NSString *codeQuery = [codeParam objectAtIndex:0];
        NSString *code = [codeQuery stringByReplacingOccurrencesOfString:@"code=" withString:@""];
        
        
        if(!code)
        {
            return NO;
        }
        else {
            
            self.slackCode = code;
            NSURLConnection *slackConnection;
  

            // Create the REST call string.
            NSString *restCallString = [NSString stringWithFormat:@"%@/oauth.access?client_id=%@&client_secret=%@&code=%@", slackAPIURL , slackClientID , slackClientSecret , self.slackCode ];
        
            NSURL *restURL = [NSURL URLWithString:restCallString];
            NSURLRequest *restRequest = [NSURLRequest requestWithURL:restURL];
            
            NSString *responseString = [immCommonFunctions makeRestAPICall: restCallString];
            NSData* responseData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *jsonArray=[NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
           // NSDictionary *dict = [jsonArray objectAtIndex:0];
            slackAccessToken = [jsonArray objectForKey:@"access_token"];
           // NSString *accessToken =(NSString*)[(NSDictionary*)[jsonArray objectAtIndex:0] objectForKey:@"access_token"];
            
            
            slackConnection = [[NSURLConnection alloc]   initWithRequest:restRequest delegate:self];
     
            //This should be stub code. Need to figure how to move this one

            AppDelegate *slackAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            
            
            NSString *slackNavigatePath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"www"];
            [slackAppDelegate.viewController.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:slackNavigatePath]]];
            
         //   [self.window makeKeyAndVisible];
            
            
            return YES;
        }
    }
        return [self application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    
}




@end


@implementation immSlackClient


- (void) cordovaSlackAuthenticate:(CDVInvokedUrlCommand *)command
{
    
    [self slackAuthenticate];
    NSDictionary *jsonObj = [ [NSDictionary alloc]  initWithObjectsAndKeys: @"true", @"success",
                             slackAccessToken, @"clientID", nil];
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                  messageAsDictionary:jsonObj];
    [self.commandDelegate sendPluginResult:pluginResult callbackId: command.callbackId];
    
}

- (void) cordovaSlackPresence:(CDVInvokedUrlCommand *)command
{
    NSString *presence = [self slackPresence];
    NSDictionary *jsonObj = [[NSDictionary alloc] initWithObjectsAndKeys:@"true", @"success",
                             presence, @"presence", nil];
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:jsonObj];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}




#pragma mark - Slack_Utility

-(void)slackAuthenticate
{
   // NSURLConnection *currentConnection;
    
    NSString *slackAPIURL = [NSString  stringWithFormat:@"https://slack.com/oauth/authorize"];
    slackAPIURL = [slackAPIURL stringByAppendingString:@"?client_id=10020492535.14066700832"];
    slackAPIURL = [slackAPIURL stringByAppendingString:@"&scope=read"];
    //slackAPIURL = [slackAPIURL stringByAppendingString:<#(nonnull NSString *)#>]
    
    NSURL *requestURL = [NSURL URLWithString:slackAPIURL];
    NSURLRequest *slackRequest = [NSURLRequest requestWithURL:requestURL];
    
    [self.webView loadRequest:slackRequest];
    
}

- (NSString *)slackPresence
{
    NSString *restCallString = [NSString stringWithFormat:@"%@/users.getPresence?token=%@&user=%@", slackAPIURL, slackAccessToken , @"U1234567890" ];
    
    NSString *responseString = [immCommonFunctions makeRestAPICall: restCallString];
    NSData* responseData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *jsonArray=[NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
    
    return  [jsonArray objectForKey:@"presence"];

}




@end
