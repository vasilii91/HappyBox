//
//  StatisticsManager.h
//  HappyBox
//
//  Created by Vasilii Kasnitski on 6/3/14.
//  Copyright (c) 2014 Vasilii.Kasnitski. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *VK_COUNT = @"VK_COUNT";
static NSString *FACEBOOK_COUNT = @"FACEBOOK_COUNT";
static NSString *EMAIL_COUNT = @"EMAIL_COUNT";
static NSString *PRINT_COUNT = @"PRINT_COUNT";


@interface StatisticsManager : NSObject

+ (void)increaseCountForKey:(NSString *)key;
+ (NSInteger)countForKey:(NSString *)key;
+ (void)clearAllData;

@end
