//
//  UIView+Nib.h
//  WaterInventory
//
//  Created by Andrey Kudris on 09.01.13.
//  Copyright (c) 2013 OCSICO. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIView (Nib)

+ (id)viewFromDefNib;
+ (id)viewFromNibName:(NSString*)xibName;

@end
