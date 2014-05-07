//
//  UIView+Nib.h
//  WaterInventory
//
//  Created by Andrey Kudris on 09.01.13.
//  Copyright (c) 2013 OCSICO. All rights reserved.
//

#import "UIView+Nib.h"

@implementation UIView (Nib)

+ (id)viewFromDefNib {
    
    return [self viewFromNibName:NSStringFromClass([self class])];
}

+ (id)viewFromNibName:(NSString *)xibName {
    NSArray *views = nil;
    NSString *postfix = IS_IPHONE ? @"_iPhone" : @"_iPad";
    NSString *pathForXib =  [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@%@", xibName, postfix] ofType:@"nib"];
    
    if (pathForXib == nil) {
        pathForXib =  [[NSBundle mainBundle] pathForResource:xibName ofType:@"nib"];
    }
    else {
        xibName = [NSString stringWithFormat:@"%@%@", xibName, postfix];
    }
    
    if (pathForXib != nil) {
        views = [[NSBundle mainBundle] loadNibNamed:xibName owner:self options:nil];
        if ([views count] > 0) {
            for (UIView *view in views) {
                if ([view isKindOfClass:[self class]]) {
                    return view;
                }
            }
        }
    }
    return nil;
}

@end
