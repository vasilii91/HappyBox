//
//  UIImage+UIImageFunctions.h
//  Tiler
//
//  Created by Alexander on 12/22/12.
//  Copyright (c) 2012 Ocsico. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resizing)

- (UIImage *)scaleToSize:(CGSize)size;
- (UIImage *)scaleProportionalToSize:(CGSize)size;
- (UIImage *)imageWithThumbnailWidth:(CGFloat)thumbnailWidth;
- (UIImage *)crop:(CGRect)rect;

@end
