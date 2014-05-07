//
//  FileManagerCoreMethods.m
//  changes
//
//  Created by Vasilii Kasnitski on 2/19/14.
//  Copyright (c) 2014 Vasilii.Kasnitski. All rights reserved.
//

#import "NSString+Date.h"

@implementation NSString (Date)

+ (NSDateFormatter*)stringDateFormatter
{
    static NSDateFormatter* formatter = nil;
    if (formatter == nil) {
        
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss ZZZ"];
    }
    return formatter;
}

+ (NSDate *)dateFromString:(NSString*)string
{
    return [[NSString stringDateFormatter] dateFromString:string];
}

+ (NSString *)stringFromDate:(NSDate*)date
{
    return [[NSString stringDateFormatter] stringFromDate:date];
}

@end
