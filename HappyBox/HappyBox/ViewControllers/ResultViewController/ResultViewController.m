//
//  ResultViewController.m
//  HappyBox
//
//  Created by Vasilii Kasnitski on 5/13/14.
//  Copyright (c) 2014 Vasilii.Kasnitski. All rights reserved.
//

#import "ResultViewController.h"
#import "SHKVkontakte.h"
#import "SHKItem.h"
#import "SHKFacebook.h"
#import "SHKMail.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AFNetworking.h"

@interface ResultViewController ()
{
    SHKMail *shkMail;
    SHKVkontakte *shkVkontakte;
    SHKFacebook *shkFacebook;
}

@end

@implementation ResultViewController


#pragma mark - ViewController's lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for (UIView *v in viewsForButtons) {
        v.backgroundColor = [UIColor clearColor];
    }

    imageViewPhoto.image = self.photo;
    
    shkMail = [[SHKMail alloc] init];
    shkFacebook = [[SHKFacebook alloc] init];
    shkVkontakte = [[SHKVkontakte alloc] init];
    
    shkMail.shareDelegate = self;
    shkFacebook.shareDelegate = self;
    shkVkontakte.shareDelegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    LOG(@"%@", UDValue(@"server_address"));
}


#pragma mark - Actions

- (IBAction)clickOnBackButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickOnActionButton:(UIButton *)sender
{
    NSInteger tag = sender.tag;

    SHKItem *item = [SHKItem new];
    item.shareType = SHKShareTypeImage;
    item.image = self.photo;
    
    switch (tag) {
        case ButtonShareTypeEmail:
        {
            [shkMail loadItem:item];
            [shkMail share];
        } break;
        case ButtonShareTypePrint:
        {
            [[FBSession activeSession] closeAndClearTokenInformation];
            [SHKVkontakte logout];
            
            [self printPhotoWithName:@"print.JPG"];
        } break;
        case ButtonShareTypeVk:
        {
            [shkVkontakte loadItem:item];
            [shkVkontakte share];
        } break;
        case ButtonShareTypeFacebook:
        {
            [self openFacebookAuthentication];
        } break;
    }
}


#pragma mark - @protocol SHKSharerDelegate <NSObject>

- (void)sharerStartedSending:(SHKSharer *)sharer
{
    LOG(@"1");
}

- (void)sharerFinishedSending:(SHKSharer *)sharer
{
    LOG(@"2");
}

- (void)sharer:(SHKSharer *)sharer failedWithError:(NSError *)error shouldRelogin:(BOOL)shouldRelogin
{
    LOG(@"3");
}

- (void)sharerCancelledSending:(SHKSharer *)sharer
{
    LOG(@"4");
}


#pragma mark - Private methods

- (void)printPhotoWithName:(NSString *)photoName
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"filename" : photoName};
    [manager POST:@"http://192.168.1.4:3000/printer" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        LOG(@"%@", error.description);
    }];
}

- (void)openFacebookAuthentication
{
    [FBSession setActiveSession:[[FBSession alloc]
                                 initWithPermissions:@[@"user_photos"]]];
    
    [[FBSession activeSession] openWithBehavior:FBSessionLoginBehaviorForcingWebView completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        
        switch (status) {
            case FBSessionStateOpen:
            {
//                NSMutableDictionary *params = [NSMutableDictionary new];
//                [params setValue:@"#HAPPYBOX" forKey:@"message"];
//                
//                NSData *imageData = [NSData dataWithData:UIImageJPEGRepresentation(self.photo, 1.0)];
//                [params setObject:imageData forKey:@"source"];
//                
//                [FBRequestConnection startWithGraphPath:@"/me/photos" parameters:params HTTPMethod:@"POST"
//                                      completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//                                          LOG(@"completed"); 
//                                      }];
                
                SHKItem *item = [SHKItem new];
                item.shareType = SHKShareTypeImage;
                item.image = self.photo;
                item.text = @"HAPPYBOX";
                
                [SHKFacebook shareItem:item];
                
            } break;
                
            case FBSessionStateClosedLoginFailed: {
                // prefer to keep decls near to their use
                // unpack the error code and reason in order to compute cancel bool
                NSString *errorCode = [[error userInfo] objectForKey:FBErrorLoginFailedOriginalErrorCode];
                NSString *errorReason = [[error userInfo] objectForKey:FBErrorLoginFailedReason];

                
                if(error.code == 2 && ![errorReason isEqualToString:@"com.facebook.sdk:UserLoginCancelled"]) {
                    UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Ошибка"
                                                                           message:error.description
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"Ok"
                                                                 otherButtonTitles:nil];
                    [errorMessage performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                    errorMessage = nil;
                }
            }
                break;
                // presently extension, log-out and invalidation are being implemented in the Facebook class
            default:
                break; // so we do nothing in response to those state transitions
        }
    }];
}

@end
