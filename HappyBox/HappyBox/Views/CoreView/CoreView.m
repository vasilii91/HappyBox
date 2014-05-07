//
//  CoreView.m
//  changes
//
//  Created by Vasilii Kasnitski on 2/20/14.
//  Copyright (c) 2014 Vasilii.Kasnitski. All rights reserved.
//

#import "CoreView.h"

@implementation CoreView


+ (instancetype)loadView
{
    NSString *className = NSStringFromClass([self class]);
    
    NSArray *possibleClassNames = @[
                                    [NSString stringWithFormat:@"%@_iPhone", className],
                                    [NSString stringWithFormat:@"%@_iPad", className],
                                    className
                                    ];
    
    for (NSString *oneName in possibleClassNames) {
        
        if ([[NSBundle mainBundle] pathForResource:oneName ofType:@"nib"] != nil) {
            
            NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:oneName
                                                                owner:nil
                                                              options:nil];
            if (nibObjects) {
                return nibObjects[0];
            }
        }
    }
    
    return nil;
}


#pragma mark - Public methods

- (void)moveToPoint:(CGPoint)point animated:(BOOL)animated
{
    CGFloat animationTime = animated ? ANIMATION_TIME : 0.0;
    
    [UIView animateWithDuration:animationTime animations:^{
        CGRect r = self.frame;
        r.origin.x = point.x;
        r.origin.y = point.y;
        self.frame = r;
    } completion:^(BOOL finished) {
        self.isVisible = !self.isVisible;
    }];
}

@end
