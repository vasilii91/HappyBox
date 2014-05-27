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
//	BOOL result = NO;
//    //if they have an account on their device, then use it, but don't force a device level login
//    if (NSClassFromString(@"SLComposeViewController")) {
//        result = ![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook];
//    }
//    return [NSNumber numberWithBool:result];
    
    return @YES;
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


@end
