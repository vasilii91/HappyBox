
//  PhotorollPreview.m
//  Photomat
//
//  Created by Vasilii Kasnitski on 12/25/13.
//  Copyright (c) 2013 OCSICO. All rights reserved.
//

#import "PhotorollPreview.h"

@implementation PhotorollPreview


#pragma mark - Private methods

- (void)setImages:(NSArray *)images
{
    for (UIView *containerView in containerViews) {
        containerView.hidden = YES;
    }
    
    for (int i = 0; i < [images count]; i++) {
        
        UIView *containerView = containerViews[i];
        containerView.hidden = NO;
        UIImageView *imageView = imageViewsImage[i];
        imageView.image = images[i];
        
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
    
    if (self.selectionState) {
        UIButton *selectionButton = buttonsSelection[containerTag];
        selectionButton.selected = !selectionButton.selected;
        
        if (selectionButton.selected) {
            [self.delegate userSelectedImageWithIndex:index];
        }
        else {
            [self.delegate userDeselectedImageWithIndex:index];
        }
    }
    else {
        [self.delegate userTapOnImageWithIndex:index];
    }
}

- (void)setSelectionState:(BOOL)selectionState
{
    _selectionState = selectionState;
    if (_selectionState == NO) {
        for (UIButton *selectionButton in buttonsSelection) {
            selectionButton.selected = NO;
        }
    }
}


#pragma mark - Public methods

- (void)selectItemAtIndex:(NSInteger)index
{
    if (index >= 0 && index < 3) {
        UIButton *button = buttonsSelection[index];
        button.selected = YES;
    }
}

- (void)deselectItemAtIndex:(NSInteger)index
{
    if (index >= 0 && index < 3) {
        UIButton *button = buttonsSelection[index];
        button.selected = NO;
    }
}

@end
