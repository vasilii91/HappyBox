//
//  ResultViewController.h
//  HappyBox
//
//  Created by Vasilii Kasnitski on 5/13/14.
//  Copyright (c) 2014 Vasilii.Kasnitski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHKSharer.h"

enum
{
    ButtonShareTypePrint,
    ButtonShareTypeVk,
    ButtonShareTypeFacebook,
    ButtonShareTypeEmail
};
typedef NSInteger ButtonShareType;


@interface ResultViewController : UIViewController<SHKSharerDelegate>
{
    __weak IBOutlet UIImageView *imageViewPhoto;
    __weak IBOutlet UIView *viewBigContainer;
    __weak IBOutlet UIView *viewContainer;
    IBOutletCollection(UIView) NSArray *viewsForButtons;
    __weak IBOutlet UIButton *buttonPrint;
    __weak IBOutlet UIButton *buttonVK;
    __weak IBOutlet UIButton *buttonFacebook;
    __weak IBOutlet UIButton *buttonEmail;
}

@property (nonatomic, retain) UIImage *photo;
@property (nonatomic, retain) NSString *photoURLString;

@end
