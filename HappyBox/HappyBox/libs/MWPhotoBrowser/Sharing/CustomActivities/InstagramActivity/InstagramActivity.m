//
//  InstagramActivity.m
//  Photomat
//
//  Created by Vasilii Kasnitski on 12/24/13.
//  Copyright (c) 2013 OCSICO. All rights reserved.
//

#import "InstagramActivity.h"

@implementation InstagramActivity

- (NSString *)activityType
{
    return @"com.instagram.exclusivegram";
}

- (NSString *)activityTitle
{
    return @"Instagram";
}

- (UIImage *)activityImage
{
    // Note: These images need to have a transparent background and I recommend these sizes:
    // iPadShare@2x should be 126 px, iPadShare should be 53 px, iPhoneShare@2x should be 100
    // px, and iPhoneShare should be 50 px. I found these sizes to work for what I was making.

    return [UIImage imageNamed:@"instagram_share"];
//    return nil;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    NSLog(@"%s", __FUNCTION__);
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    NSLog(@"%s",__FUNCTION__);
}

- (UIViewController *)activityViewController
{
    NSLog(@"%s",__FUNCTION__);
    return nil;
}

- (void)performActivity
{
    // This is where you can do anything you want, and is the whole reason for creating a custom
    // UIActivity
    
//    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
//    [[UIApplication sharedApplication] openURL:instagramURL];
    [self activityDidFinish:YES];
}


@end
