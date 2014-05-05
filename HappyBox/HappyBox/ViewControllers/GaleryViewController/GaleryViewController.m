//
//  GaleryViewController.m
//  HappyBox
//
//  Created by Vasilii Kasnitski on 5/5/14.
//  Copyright (c) 2014 Vasilii.Kasnitski. All rights reserved.
//

#import "GaleryViewController.h"
#import "AsyncImageView.h"


@interface GaleryViewController ()

@end

@implementation GaleryViewController


#pragma mark - ViewController's lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [AsyncImageLoader sharedLoader].cache = [AsyncImageLoader defaultCache];
    
    NSString *serverIP = @"192.168.1.7";
    NSString *folderName = @"test";
    
    //Create the request
    NSString *urlString = [NSString stringWithFormat:@"http://%@/%@/?rev=1&tpl=list&folders-filter=recursive&sort=t", serverIP, folderName];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    //Open NSURLConnection with 'request'
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        //If we receive something
        if (data) {
            //Pass and decode to string
            NSString *receivedData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSArray *links = [receivedData componentsSeparatedByString:@"\r\n"];
            NSString *link1 = links[0];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                imageViewTest.imageURL = [NSURL URLWithString:link1];
            });
            NSLog(@"Received HTML: %@", receivedData);
        }
        
        //Something went wrong
        else {
            // ToDO: Sort out any errors
            
        }
    }];
}


@end
