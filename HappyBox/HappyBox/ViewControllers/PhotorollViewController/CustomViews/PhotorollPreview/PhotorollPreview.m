
//  PhotorollPreview.m
//  Photomat
//
//  Created by Vasilii Kasnitski on 12/25/13.
//  Copyright (c) 2013 OCSICO. All rights reserved.
//

#import "PhotorollPreview.h"
#import "AsyncImageView.h"

@implementation PhotorollPreview


#pragma mark - Private methods

- (void)setUrls:(NSArray *)urls
{
    for (UIView *containerView in containerViews) {
        containerView.hidden = YES;
    }
    
    for (int i = 0; i < [urls count]; i++) {
        
        UIView *containerView = containerViews[i];
        containerView.hidden = NO;
        UIImageView *imageView = imageViewsImage[i];
        imageView.imageURL = urls[i];
        
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
    NSInteger index = containerTag + self.row * 3;
    LOG(@"%d", index);
    
    UIImageView *imageView = imageViewsImage[containerTag];
    [self.delegate userTapOnImage:imageView.image];
}

@end
