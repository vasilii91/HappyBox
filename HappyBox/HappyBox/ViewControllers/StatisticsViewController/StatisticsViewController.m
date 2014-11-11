//
//  StatisticsViewController.m
//  HappyBox
//
//  Created by Vasilii Kasnitski on 6/3/14.
//  Copyright (c) 2014 Vasilii.Kasnitski. All rights reserved.
//

#import "StatisticsViewController.h"
#import "StatisticsManager.h"
#import "FileManagerCoreMethods.h"
#import "BSImageCache.h"
#import "SDWebImageManager.h"


@implementation StatisticsViewController


#pragma mark - ViewController's lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateLabels];
}

#pragma mark - Actions

- (IBAction)clearStatisticsData:(id)sender
{
    [self showAlertWithTitle:@"Вы точно хотите обнулить счётчики?" tag:0];
    
}

- (IBAction)removeCachedPhotos:(id)sender
{
    [self showAlertWithTitle:@"Вы точно хотите удалить все закешированные фото?" tag:1];
}

- (IBAction)clickOnBackButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - @protocol UIAlertViewDelegate <NSObject>

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (alertView.tag == 0) {
            [StatisticsManager clearAllData];
            [self updateLabels];
        }
        else {
            NSArray *photoPathComponents = @[DIRECTORY_NAME_MAIN_HAPPYBOX_PHOTOS,
                                             DIRECTORY_NAME_FULLSIZE_PHOTOS];
            NSArray *photoPreviewPathComponents = @[DIRECTORY_NAME_MAIN_HAPPYBOX_PHOTOS,
                                                    DIRECTORY_NAME_PREVIEW_PHOTOS];
            [FileManagerCoreMethods deleteDirectoryWithPathComponents:photoPathComponents];
            [FileManagerCoreMethods deleteDirectoryWithPathComponents:photoPreviewPathComponents];
            [[BSImageCache sharedInstance] cleanCacheWithType:CacheTypeIsRAM];
            
            [[SDWebImageManager sharedManager].imageCache clearMemory];
        }
    }
}


#pragma mark - Private methods

- (void)updateLabels
{
    labelVKCount.text = [NSString stringWithFormat:@"%d", [StatisticsManager countForKey:VK_COUNT]];
    labelFacebookCount.text = [NSString stringWithFormat:@"%d", [StatisticsManager countForKey:FACEBOOK_COUNT]];
    labelPrintCount.text = [NSString stringWithFormat:@"%d", [StatisticsManager countForKey:PRINT_COUNT]];
    labelEmailCount.text = [NSString stringWithFormat:@"%d", [StatisticsManager countForKey:EMAIL_COUNT]];
    labelCountOfPhotos.text = [NSString stringWithFormat:@"%d", self.countOfPhotos];
}

- (void)showAlertWithTitle:(NSString *)title tag:(NSInteger)buttonTag
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Подтвердите"
                                                    message:title
                                                   delegate:self
                                          cancelButtonTitle:@"Отмена"
                                          otherButtonTitles:@"Да, сделать это", nil];
    alert.tag = buttonTag;
    [alert show];
}

@end
