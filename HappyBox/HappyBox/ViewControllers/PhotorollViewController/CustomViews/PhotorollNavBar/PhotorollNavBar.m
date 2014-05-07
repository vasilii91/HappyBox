//
//  PhotorollNavBar.m
//  Photomat
//
//  Created by Vasilii Kasnitski on 12/24/13.
//  Copyright (c) 2013 OCSICO. All rights reserved.
//

#import "PhotorollNavBar.h"


@implementation PhotorollNavBar

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [buttonBack setTitle:NSLocalizedString(@"key.back_button_text", @"Back") forState:UIControlStateNormal];
    buttonBack.exclusiveTouch = YES;
}


#pragma mark - Actions

- (IBAction)clickOnLeftButton:(id)sender
{
    [self.delegate photorollNavBarUserClickedOnLeftButton];
}


#pragma mark - Properties

- (void)setTitle:(NSString *)title
{
    labelTitle.text = title;
}

@end
