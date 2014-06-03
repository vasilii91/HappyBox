//
//  StatisticsManager.m
//  HappyBox
//
//  Created by Vasilii Kasnitski on 6/3/14.
//  Copyright (c) 2014 Vasilii.Kasnitski. All rights reserved.
//

#import "StatisticsManager.h"


@implementation StatisticsManager


#pragma mark - Public methods

+ (void)increaseCountForKey:(NSString *)key
{
    NSInteger count = UDInteger(key);
    count++;
    UDSetInteger(key, count);
}

+ (NSInteger)countForKey:(NSString *)key
{
    return UDInteger(key);
}

+ (void)clearAllData
{
    UDSetInteger(VK_COUNT, 0);
    UDSetInteger(FACEBOOK_COUNT, 0);
    UDSetInteger(EMAIL_COUNT, 0);
    UDSetInteger(PRINT_COUNT, 0);
}

@end
