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

    imageViewPhoto.image = self.photo;
    
    shkMail = [[SHKMail alloc] init];
    shkFacebook = [[SHKFacebook alloc] init];
    shkVkontakte = [[SHKVkontakte alloc] init];
    
    shkMail.shareDelegate = self;
    shkFacebook.shareDelegate = self;
    shkVkontakte.shareDelegate = self;
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
            [SHKVkontakte logout];
        } break;
        case ButtonShareTypeVk:
        {
            [shkVkontakte loadItem:item];
            [shkVkontakte share];
        } break;
        case ButtonShareTypeFacebook:
        {
//            [shkFacebook loadItem:item];
            [SHKFacebook shareItem:item];
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

@end
