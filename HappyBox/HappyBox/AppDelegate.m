//
//  AppDelegate.m
//  HappyBox
//
//  Created by Vasilii Kasnitski on 5/5/14.
//  Copyright (c) 2014 Vasilii.Kasnitski. All rights reserved.
//

#import "AppDelegate.h"
#import "FileManagerCoreMethods.h"
#import "DefaultSHKConfigurator.h"
#import "SHKConfigurator.h"
#import "SHKConfiguration.h"
#import "SHKFacebook.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    // Override point for customization after application launch.
//    self.window.backgroundColor = [UIColor whiteColor];
//    [self.window makeKeyAndVisible];
    
    DefaultSHKConfigurator *configurator = [SHKConfigurator new];
    [SHKConfiguration sharedInstanceWithConfigurator:configurator];
    
    [FileManagerCoreMethods createNewDirectoryWithPathComponents:@[DIRECTORY_NAME_MAIN_HAPPYBOX_PHOTOS,
                                                                   DIRECTORY_NAME_FULLSIZE_PHOTOS]];
    [FileManagerCoreMethods createNewDirectoryWithPathComponents:@[DIRECTORY_NAME_MAIN_HAPPYBOX_PHOTOS,
                                                                   DIRECTORY_NAME_PREVIEW_PHOTOS]];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [SHKFacebook handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [SHKFacebook handleWillTerminate];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    NSString* scheme = [url scheme];
    
    if ([scheme hasPrefix:[NSString stringWithFormat:@"fb%@", SHKCONFIG(facebookAppId)]]) {
        return [SHKFacebook handleOpenURL:url];
    }
    
    return YES;
}

@end
