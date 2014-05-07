//
//  CoreView.h
//  changes
//
//  Created by Vasilii Kasnitski on 2/20/14.
//  Copyright (c) 2014 Vasilii.Kasnitski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoreView : UIView

+ (instancetype)loadView;
- (void)moveToPoint:(CGPoint)point animated:(BOOL)animated;

@property (nonatomic, assign) BOOL isVisible;

@end
