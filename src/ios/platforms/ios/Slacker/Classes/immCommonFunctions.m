//
//  immCommonFunctions.m
//  Slacker
//
//  Created by Manoj Shenoy on 11/12/15.
//
//

#import "immCommonFunctions.h"

@implementation immCommonFunctions

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
@end
