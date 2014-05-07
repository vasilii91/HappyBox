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

- (void)userSelectedImageWithIndex:(NSInteger)imageIndex;
- (void)userDeselectedImageWithIndex:(NSInteger)imageIndex;
- (void)userTapOnImageWithIndex:(NSInteger)imageIndex;

@end


@interface PhotorollPreview : UITableViewCell
{
    IBOutletCollection(UIView) NSArray *containerViews;
    IBOutletCollection(UIImageView) NSArray *imageViewsImage;
    IBOutletCollection(UIButton) NSArray *buttonsSelection;
}

@property (nonatomic, assign) NSInteger row;
@property (nonatomic, retain) NSArray *images;
@property (nonatomic, assign) BOOL selectionState;
@property (nonatomic, assign) NSObject<PhotorollPreviewDelegate> *delegate;

- (void)selectItemAtIndex:(NSInteger)index;
- (void)deselectItemAtIndex:(NSInteger)index;

@end
