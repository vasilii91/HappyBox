//
//  BSMailSender.h
//  BaseSolution
//
//  Created by Alexander Raukuts on 1/13/13.
//  Copyright (c) 2013 Alexander Raukuts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

//**************************************************
// TODO: Need for available MessageUI Framework!
//**************************************************

@interface BSMailSender : NSObject <MFMailComposeViewControllerDelegate>
{
    UIViewController *presentedViewController;
}

+ (void)mailWithSubject:(NSString *)subject
                   body:(NSString *)body
                 isHTML:(BOOL)isHTML
         viewController:(UIViewController *)viewController
               callback:(void(^)(NSString *stringResult, MFMailComposeResult composeResult)) callback;

+ (void)mailWithSubject:(NSString *)subject
                   body:(NSString *)body
                 isHTML:(BOOL)isHTML
         viewController:(UIViewController *)viewController
                  image:(UIImage *)image
               callback:(void(^)(NSString *stringResult, MFMailComposeResult composeResult)) callback;

@end




