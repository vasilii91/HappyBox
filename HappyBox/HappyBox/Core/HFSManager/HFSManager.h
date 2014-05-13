//
//  HFSManager.h
//  HappyBox
//
//  Created by Vasilii Kasnitski on 5/13/14.
//  Copyright (c) 2014 Vasilii.Kasnitski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFSManager : NSObject

+ (void)getAllPhotoLinksByServerURL:(NSString *)serverURL completionBlock:(void(^)(NSArray *))completionBlock;

@end
