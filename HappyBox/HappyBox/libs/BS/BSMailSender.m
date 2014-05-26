//
//  BSMailSender.m
//  BaseSolution
//
//  Created by Alexander Raukuts on 1/13/13.
//  Copyright (c) 2013 Alexander Raukuts. All rights reserved.
//

#import "BSMailSender.h"


@interface BSMailSender ()

typedef void(^BSMailSenderDoneCallback)(NSString *stringResult, MFMailComposeResult composeResult);

@property (nonatomic, copy) BSMailSenderDoneCallback doneCallback;

@end


@implementation BSMailSender

static BSMailSender *instance = nil;

+ (BSMailSender *)sharedInstance {
    
    if (instance == nil) {
        
        instance = [BSMailSender new];
    }
    return instance;
}


//==============================================================================================
#pragma mark - Public methods
//==============================================================================================

+ (void)mailWithSubject:(NSString *)subject body:(NSString *)body isHTML:(BOOL)isHTML viewController:(UIViewController *)viewController callback:(void(^)(NSString *stringResult, MFMailComposeResult composeResult)) callback {
    
    [[BSMailSender sharedInstance] mailForRecipients:nil
                                             subject:subject
                                               image:nil
                                                body:body
                                              isHTML:isHTML
                                      viewController:viewController
                                            callback:callback];
}

+ (void)mailWithSubject:(NSString *)subject body:(NSString *)body isHTML:(BOOL)isHTML viewController:(UIViewController *)viewController image:(UIImage *)image callback:(void(^)(NSString *stringResult, MFMailComposeResult composeResult)) callback {
    
    [[BSMailSender sharedInstance] mailForRecipients:nil
                                             subject:subject
                                               image:image
                                                body:body
                                              isHTML:isHTML
                                      viewController:viewController
                                            callback:callback];
}


//==============================================================================================
#pragma mark - Private methods
//==============================================================================================

- (void)mailForRecipients:(NSArray *)recipients
                  subject:(NSString *)subject
                    image:(UIImage *)image
                     body:(NSString *)body
                   isHTML:(BOOL)isHTML
           viewController:(UIViewController *)viewController
                 callback:(BSMailSenderDoneCallback) callback {
    
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        
        // Set Recipients
        [mailer setToRecipients:recipients];
        
        // Set Subject
        [mailer setSubject:subject];
        
        // Set Attachment
        if (image) {
            
            NSData *imageData = UIImagePNGRepresentation(image);
            [mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"AttachedImage.png"];
        }
        
        // Set Body
        [mailer setMessageBody:body isHTML:isHTML];
        
        // Set Callback
        self.doneCallback = callback;
        
        // Present Mail Controller
        presentedViewController = viewController;
        [viewController presentViewController:mailer animated:YES completion:nil];
        [mailer release];
    }
    else if (callback) {
        
        callback(NSLocalizedString(@"key.please_configure_your_email", nil), MFMailComposeResultFailed);
    }
}

- (UIViewController *)getRootViewController {
    
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}


//==============================================================================================
#pragma mark - MFMailComposeViewController Delegate methods
//==============================================================================================

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    // Remove the mail view
    [presentedViewController dismissViewControllerAnimated:YES completion:nil];
    
    if(self.doneCallback) {

        switch (result) {
                
            case MFMailComposeResultCancelled:
                self.doneCallback(@"Mail cancelled: you cancelled the operation and no email message was queued.", result); break;
                
            case MFMailComposeResultSaved:
                self.doneCallback(@"Mail saved: you saved the email message in the drafts folder.", result); break;
                
            case MFMailComposeResultSent:
                self.doneCallback(@"Mail send: the email message is queued in the outbox. It is ready to send.", result); break;
                
            case MFMailComposeResultFailed:
                self.doneCallback(@"Mail failed: the email message was not saved or queued, possibly due to an error.", result); break;
                
            default:
                self.doneCallback(@"Mail not sent.", result);
                break;
        }
    }
}


//==============================================================================================
#pragma mark - Memory management
//==============================================================================================

- (void)dealloc {
    
    [_doneCallback release];
    [super dealloc];
}

@end
