//
//  PhotorollToolbar.m
//  Photomat
//
//  Created by Vasilii Kasnitski on 12/25/13.
//  Copyright (c) 2013 OCSICO. All rights reserved.
//

#import "PhotorollToolbar.h"

@implementation PhotorollToolbar

#pragma mark - Actions

- (IBAction)clickOnLeftButton:(id)sender
{
    [self.delegate photorollToolbarUserClickedOnLeftButton];
}

- (IBAction)clickOnRightButton:(id)sender
{
    [self.delegate photorollToolbarUserClickedOnRightButton];
}

@end
