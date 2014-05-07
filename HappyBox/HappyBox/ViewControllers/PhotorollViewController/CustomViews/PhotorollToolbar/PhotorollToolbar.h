//
//  PhotorollToolbar.h
//  Photomat
//
//  Created by Vasilii Kasnitski on 12/25/13.
//  Copyright (c) 2013 OCSICO. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PhotorollToolbarDelegate <NSObject>

- (void)photorollToolbarUserClickedOnLeftButton;
- (void)photorollToolbarUserClickedOnRightButton;

@end

@interface PhotorollToolbar : CoreView

@property (nonatomic, assign) NSObject<PhotorollToolbarDelegate> *delegate;

@end
