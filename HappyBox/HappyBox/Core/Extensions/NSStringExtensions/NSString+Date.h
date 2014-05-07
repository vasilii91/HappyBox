//
//  FileManagerCoreMethods.m
//  changes
//
//  Created by Vasilii Kasnitski on 2/19/14.
//  Copyright (c) 2014 Vasilii.Kasnitski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Date)

+ (NSDate *)dateFromString:(NSString*)string;
+ (NSString *)stringFromDate:(NSDate*)date;

@end
