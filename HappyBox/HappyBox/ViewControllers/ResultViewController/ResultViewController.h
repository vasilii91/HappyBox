//
//  ResultViewController.h
//  HappyBox
//
//  Created by Vasilii Kasnitski on 5/13/14.
//  Copyright (c) 2014 Vasilii.Kasnitski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHKSharer.h"

@interface ResultViewController : UIViewController<SHKSharerDelegate>
{
    __weak IBOutlet UIImageView *imageViewPhoto;
}

@property (nonatomic, retain) UIImage *photo;

@end
