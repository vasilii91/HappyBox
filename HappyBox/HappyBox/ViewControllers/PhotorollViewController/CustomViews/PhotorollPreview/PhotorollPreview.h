//
//  PhotorollPreview.h
//  Photomat
//
//  Created by Vasilii Kasnitski on 12/25/13.
//  Copyright (c) 2013 OCSICO. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PHOTOROLL_PREVIEW_CELL_ID @"photorollPreviewCellId"

@protocol PhotorollPreviewDelegate <NSObject>

- (void)userTapOnPhotoWithIndex:(NSInteger)index;
- (void)userDoubleTapOnPhotoWithIndex:(NSInteger)index;

@end


@interface PhotorollPreview : UITableViewCell<UIGestureRecognizerDelegate>
{
    IBOutletCollection(UIView) NSArray *containerViews;
    IBOutletCollection(UIImageView) NSArray *imageViewsImage;
}

@property (nonatomic, assign) NSInteger row;
@property (nonatomic, retain) NSArray *photos;
@property (nonatomic, assign) NSObject<PhotorollPreviewDelegate> *delegate;

@end
