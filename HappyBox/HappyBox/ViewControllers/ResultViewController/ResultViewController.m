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
#import "StatisticsManager.h"


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
    buttonPrint.hidden = YES;
    buttonFacebook.hidden = YES;
    buttonVK.hidden = YES;
    buttonEmail.hidden = YES;
    
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
    [[FBSession activeSession] closeAndClearTokenInformation];
    [SHKVkontakte logout];
    
    [self buildButtons];
}

- (void)buildButtons
{
    NSInteger countOfActive = 0;
    NSInteger activeIndex = 0;
    
    if (UDBool(SETTINGS_PRINT_ENABLED)) {
        countOfActive++;
        buttonPrint.frame = [viewsForButtons[activeIndex] frame];
        buttonPrint.hidden = NO;
        activeIndex++;
    }
    if (UDBool(SETTINGS_VK_ENABLED)) {
        countOfActive++;
        buttonVK.frame = [viewsForButtons[activeIndex] frame];
        buttonVK.hidden = NO;
        activeIndex++;
    }
    if (UDBool(SETTINGS_FACEBOOK_ENABLED)) {
        countOfActive++;
        buttonFacebook.frame = [viewsForButtons[activeIndex] frame];
        buttonFacebook.hidden = NO;
        activeIndex++;
    }
    
    if (UDBool(SETTINGS_EMAIL_ENABLED)) {
        countOfActive++;
        buttonEmail.frame = [viewsForButtons[activeIndex] frame];
        buttonEmail.hidden = NO;
        activeIndex++;
    }
    
    if (countOfActive > 0) {
        UIView *firstContainer = viewsForButtons[0];
        UIView *lastContainer = viewsForButtons[countOfActive - 1];
        
        CGFloat containerHeight = ViewY(firstContainer) + ViewY(lastContainer) + ViewHeight(lastContainer);
        CGFloat containerWidth = ViewWidth(viewContainer);
        if (countOfActive == 1) {
            containerWidth = ViewWidth(firstContainer);
        }
        
        viewContainer.frame = CGRectMake(ViewX(viewContainer),
                                         ViewY(viewContainer),
                                         containerWidth,
                                         containerHeight);
        
        viewContainer.center = viewBigContainer.center;
    }
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
            [StatisticsManager increaseCountForKey:PRINT_COUNT];
            NSString *photoName = [self.photoURLString lastPathComponent];
            [self printPhotoWithName:photoName];
            [self showAlertWithTitle:@"HAPPY BOX печатает фото"];
            
        } break;
        case ButtonShareTypeVk:
        {
            [shkVkontakte loadItem:item];
            [shkVkontakte share];
        } break;
        case ButtonShareTypeFacebook:
        {
//            [shkFacebook loadItem:item];
//            [shkFacebook share];
            [self openFacebookAuthentication];
        } break;
    }
}


#pragma mark - @protocol UIAlertViewDelegate <NSObject>

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - @protocol SHKSharerDelegate <NSObject>

- (void)sharerStartedSending:(SHKSharer *)sharer
{
    if ([sharer isKindOfClass:[SHKFacebook class]]) {
        [StatisticsManager increaseCountForKey:FACEBOOK_COUNT];
        [self showAlertWithTitle:@"HAPPY BOX шарит фото в Facebook"];
    }
    else if ([sharer isKindOfClass:[SHKVkontakte class]]) {
        [StatisticsManager increaseCountForKey:VK_COUNT];
        [self showAlertWithTitle:@"HAPPY BOX шарит фото в VK"];
    }
    LOG(@"1");
}

- (void)sharerFinishedSending:(SHKSharer *)sharer
{
    if ([sharer isKindOfClass:[SHKMail class]]) {
        [StatisticsManager increaseCountForKey:EMAIL_COUNT];
        [self showAlertWithTitle:@"HAPPY BOX отправляет фото на почтовый ящик"];
    }
    else if ([sharer isKindOfClass:[SHKFacebook class]]) {
        [[FBSession activeSession] closeAndClearTokenInformation];
    }
    else if ([sharer isKindOfClass:[SHKVkontakte class]]) {
        [SHKVkontakte logout];
    }
    
    LOG(@"2");
}

- (void)sharer:(SHKSharer *)sharer failedWithError:(NSError *)error shouldRelogin:(BOOL)shouldRelogin
{
    if ([sharer isKindOfClass:[SHKFacebook class]]) {
        [[FBSession activeSession] closeAndClearTokenInformation];
    }
    else if ([sharer isKindOfClass:[SHKVkontakte class]]) {
        [SHKVkontakte logout];
    }
}

- (void)sharerCancelledSending:(SHKSharer *)sharer
{
    if ([sharer isKindOfClass:[SHKFacebook class]]) {
        [[FBSession activeSession] closeAndClearTokenInformation];
    }
    else if ([sharer isKindOfClass:[SHKVkontakte class]]) {
        [SHKVkontakte logout];
    }
}

- (void)sharerShowBadCredentialsAlert:(SHKSharer *)sharer
{
    
}

- (void)sharerShowOtherAuthorizationErrorAlert:(SHKSharer *)sharer
{
    
}

- (void)hideActivityIndicatorForSharer:(SHKSharer *)sharer
{
    
}

- (void)displayActivity:(NSString *)activityDescription forSharer:(SHKSharer *)sharer
{
    
}

- (void)displayCompleted:(NSString *)completionText forSharer:(SHKSharer *)sharer
{
    
}

- (void)showProgress:(CGFloat)progress forSharer:(SHKSharer *)sharer
{
    
}


#pragma mark - Private methods

- (void)showAlertWithTitle:(NSString *)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Спасибо!"
                                                    message:title
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Продолжить", nil];
    [alert show];
}

- (void)printPhotoWithName:(NSString *)photoName
{
    NSString *filePath = [NSString stringWithFormat:@"%@\%@", UDValue(SETTINGS_FULL_PATH_TO_THE_FOLDER), photoName];
    NSString *postMethod = [NSString stringWithFormat:@"http://%@:3000/printer", UDValue(SETTINGS_SERVER_ADDRESS)];
    NSString *printerName = UDValue(SETTINGS_PRINTER_NAME); // @"Samsung ML-2010 Series";
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"printer" : printerName,
                                 @"filename" : filePath};
    [manager POST:postMethod parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                
//                [SHKFacebook shareItem:item];
                [shkFacebook loadItem:item];
                [shkFacebook share];
                
            } break;
                
            case FBSessionStateClosedLoginFailed:
            {
                NSString *errorReason = [[error userInfo] objectForKey:FBErrorLoginFailedReason];

                if (error.code == 2 && ![errorReason isEqualToString:@"com.facebook.sdk:UserLoginCancelled"]) {
                    UIAlertView *errorMessage = [[UIAlertView alloc] initWithTitle:@"Ошибка"
                                                                           message:error.description
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"Ok"
                                                                 otherButtonTitles:nil];
                    [errorMessage performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
                    errorMessage = nil;
                }
            } break;
                
            default:
                break;
        }
    }];
}

@end
