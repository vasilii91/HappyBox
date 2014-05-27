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

@interface ResultViewController ()

@end

@implementation ResultViewController


#pragma mark - ViewController's lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    imageViewPhoto.image = self.photo;
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
    
    [SHKFacebook shareItem:item];
    
//    [SHKFacebook logout];
}

@end
