//
//  UserSettings.m
//  changes
//
//  Created by Vasilii Kasnitski on 2/19/14.
//  Copyright (c) 2014 Vasilii.Kasnitski. All rights reserved.
//

#import "UserSettings.h"

@implementation UserSettings

static UserSettings *_sharedMySingleton = nil;


#pragma mark - Public methods

+ (UserSettings *)sharedSingleton
{
    @synchronized(self)
    {
        if (!_sharedMySingleton) {
            _sharedMySingleton = [[UserSettings alloc] init];
        }
    }
    
    return _sharedMySingleton;
}


#pragma mark - Public methods


@end
