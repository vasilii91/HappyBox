
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
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(tapOnContainerView:)];
        tap1.numberOfTapsRequired = 1;
        
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(doubleTapOnContainerView:)];
        tap2.numberOfTapsRequired = 2;
        
        [tap1 requireGestureRecognizerToFail:tap2];
        
        containerView.gestureRecognizers = @[tap1, tap2];
    }
}


#pragma mark - Actions

- (void)tapOnContainerView:(UITapGestureRecognizer *)gr
{
    NSInteger index = gr.view.tag + self.row * 5;
    LOG(@"%d", index);
    
    [self.delegate userTapOnPhotoWithIndex:index];
}

- (void)doubleTapOnContainerView:(UITapGestureRecognizer *)gr
{
    NSInteger index = gr.view.tag + self.row * 5;
    [self.delegate userDoubleTapOnPhotoWithIndex:index];
}


#pragma mark - @protocol UIGestureRecognizerDelegate <NSObject>

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
