
//  PhotorollPreview.m
//  Photomat
//
//  Created by Vasilii Kasnitski on 12/25/13.
//  Copyright (c) 2013 OCSICO. All rights reserved.
//

#import "PhotorollPreview.h"

@implementation PhotorollPreview


#pragma mark - Private methods

- (void)setPhotos:(NSArray *)photos
{
    for (UIView *containerView in containerViews) {
        containerView.hidden = YES;
    }
    
    for (int i = 0; i < [photos count]; i++) {
        
        UIView *containerView = containerViews[i];
        containerView.hidden = NO;
        UIImageView *imageView = imageViewsImage[i];
        imageView.image = photos[i];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(tapOnContainerView:)];
        [containerView addGestureRecognizer:tap];
    }
}


#pragma mark - Actions

- (void)tapOnContainerView:(UITapGestureRecognizer *)gr
{
    UIView *containerView = gr.view;
    NSInteger containerTag = containerView.tag;
    NSInteger index = containerTag + self.row * 5;
    LOG(@"%d", index);
    
    [self.delegate userTapOnPhotoWithIndex:index];
}

@end
