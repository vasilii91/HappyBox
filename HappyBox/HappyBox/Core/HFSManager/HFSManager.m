//
//  HFSManager.m
//  HappyBox
//
//  Created by Vasilii Kasnitski on 5/13/14.
//  Copyright (c) 2014 Vasilii.Kasnitski. All rights reserved.
//

#import "HFSManager.h"

@implementation HFSManager

+ (void)getAllPhotoLinksByServerURL:(NSString *)serverURL completionBlock:(void(^)(NSArray *))completionBlock
{
    //Create the request
    NSString *urlString = [NSString stringWithFormat:@"http://%@/?rev=1&tpl=list&folders-filter=recursive&sort=t", serverURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    //Open NSURLConnection with 'request'
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        //If we receive something
        if (data) {
            //Pass and decode to string
            NSString *receivedData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"Received HTML: %@", receivedData);
            
            NSArray *links = [receivedData componentsSeparatedByString:@"\r\n"];
            
            completionBlock(links);
        }
        
        //Something went wrong
        else {
            // ToDO: Sort out any errors
            LOGAlert(@"%@", error.description);
        }
    }];
}
@end
