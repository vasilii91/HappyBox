//
//  PhotorollNavBar.h
//  Photomat
//
//  Created by Vasilii Kasnitski on 12/24/13.
//  Copyright (c) 2013 OCSICO. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotorollNavBarDelegate <NSObject>

- (void)photorollNavBarUserClickedOnLeftButton;

@end


@interface PhotorollNavBar : CoreView
{
    __weak IBOutlet UILabel *labelTitle;
    __weak IBOutlet UIButton *buttonBack;
}

@property (nonatomic, assign) NSObject<PhotorollNavBarDelegate> *delegate;
@property (nonatomic, retain) NSString *title;

@end
