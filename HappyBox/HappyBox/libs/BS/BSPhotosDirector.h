//
//  BSPhotosDirector.h
//  BaseSolution
//
//  Created by Alexander Raukuts on 1/13/13.
//  Copyright (c) 2013 Alexander Raukuts. All rights reserved.
//

#import <Foundation/Foundation.h>

//**************************************************
// TODO: Need for available AssetsLibrary Framework!
//**************************************************

typedef enum {
    
    ImageSourceTypePhotoLibrary,
    ImageSourceTypeCamera,
    ImageSourceTypeSavedPhotosAlbum    
} ImageSourceType;


@interface BSPhotosDirector : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate>


+ (void)getImageFromLibraryType:(ImageSourceType)aImageSourceType
                       callback:(void(^)(UIImage *image, NSString *stringResult, BOOL successful)) callback;

+ (void)saveImageToSavedPhotosAlbum:(UIImage *)image
                           callback:(void(^)(NSString *stringResult, BOOL successful)) callback;

@end
