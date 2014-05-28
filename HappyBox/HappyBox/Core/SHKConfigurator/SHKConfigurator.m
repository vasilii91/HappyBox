//
//  SOSHKConfigurator.m
//  sochi
//
//  Created by Vasilii Kasnitski on 11/21/13.
//  Copyright (c) 2013 измайлов. All rights reserved.
//

#import "SHKConfigurator.h"
#import <Social/Social.h>


@implementation SHKConfigurator

- (NSString*)facebookAppId {
	return @"136875329780383"; // OCSICO Test App
//    return @"561368223932845";  // test app
}

- (NSNumber*)forcePreIOS6FacebookPosting {
	BOOL result = NO;
    //if they have an account on their device, then use it, but don't force a device level login
    if (NSClassFromString(@"SLComposeViewController")) {
        result = ![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook];
    }
    return [NSNumber numberWithBool:result];
    
//    return @YES;
}

//- (NSArray*)facebookWritePermissions {
//    return [NSArray arrayWithObjects:@"publish_actions", @"publish_stream", @"offline_access", nil];
//}
//- (NSArray*)facebookReadPermissions {
//    return @[@"read_stream", @"basic_info", @"email", @"user_likes"];
//}

- (NSString*)vkontakteAppId {
	return @"4384549";
}


#pragma mark - Basic UI Configuration

/*
 UI Configuration : Basic
 ------------------------
 These provide controls for basic UI settings.  For more advanced configuration see below.
 */

- (UIColor*)barTintForView:(UIViewController*)vc {
    return nil;
}

// Forms
- (UIColor *)formFontColor {
    return nil;
}

// iPad views. You can change presentation style for different sharers
- (NSString *)modalPresentationStyleForController:(UIViewController *)controller {
	return @"UIModalPresentationPageSheet";// See: http://developer.apple.com/iphone/library/documentation/UIKit/Reference/UIViewController_Class/Reference/Reference.html#//apple_ref/occ/instp/UIViewController/modalPresentationStyle
}

- (NSString*)modalTransitionStyleForController:(UIViewController *)controller {
	return @"UIModalTransitionStyleCoverVertical";// See: http://developer.apple.com/iphone/library/documentation/UIKit/Reference/UIViewController_Class/Reference/Reference.html#//apple_ref/occ/instp/UIViewController/modalTransitionStyle
}


@end
