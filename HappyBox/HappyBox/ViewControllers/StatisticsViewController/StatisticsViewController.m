//
//  StatisticsViewController.m
//  HappyBox
//
//  Created by Vasilii Kasnitski on 6/3/14.
//  Copyright (c) 2014 Vasilii.Kasnitski. All rights reserved.
//

#import "StatisticsViewController.h"
#import "StatisticsManager.h"


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
    [StatisticsManager clearAllData];
    [self updateLabels];
}

- (IBAction)clickOnBackButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Private methods

- (void)updateLabels
{
    labelVKCount.text = [NSString stringWithFormat:@"%d", [StatisticsManager countForKey:VK_COUNT]];
    labelFacebookCount.text = [NSString stringWithFormat:@"%d", [StatisticsManager countForKey:FACEBOOK_COUNT]];
    labelPrintCount.text = [NSString stringWithFormat:@"%d", [StatisticsManager countForKey:PRINT_COUNT]];
    labelEmailCount.text = [NSString stringWithFormat:@"%d", [StatisticsManager countForKey:EMAIL_COUNT]];
}

@end
