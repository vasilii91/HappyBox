//
//  BSPhotosDirector.m
//  BaseSolution
//
//  Created by Alexander Raukuts on 1/13/13.
//  Copyright (c) 2013 Alexander Raukuts. All rights reserved.
//

#import "BSPhotosDirector.h"
#import <AssetsLibrary/AssetsLibrary.h>


@interface BSPhotosDirector ()

typedef void(^BSGetPhotosDirectorDoneCallback)  (UIImage *image, NSString *stringResult, BOOL successful);
typedef void(^BSSavePhotosDirectorDoneCallback) (NSString *stringResult, BOOL successful);

@property (nonatomic, copy) BSSavePhotosDirectorDoneCallback saveCallback;
@property (nonatomic, copy) BSGetPhotosDirectorDoneCallback  getCallback;

@end


@implementation BSPhotosDirector

static BSPhotosDirector *instance = nil;

+ (BSPhotosDirector *)sharedInstance {
    
    if (instance == nil) {
        
        instance = [BSPhotosDirector new];
    }
    return instance;
}


//==============================================================================================
#pragma mark - Public methods
//==============================================================================================

+ (void)getImageFromLibraryType:(ImageSourceType)aImageSourceType callback:(void(^)(UIImage *image, NSString *stringResult, BOOL successful)) callback {
    
    [[BSPhotosDirector sharedInstance] readImageFromLibraryType:aImageSourceType callback:callback];
}

+ (void)saveImageToSavedPhotosAlbum:(UIImage *)image callback:(void(^)(NSString *stringResult, BOOL successful)) callback {
    
    [[BSPhotosDirector sharedInstance] writeImage:image callback:callback];
}


//==============================================================================================
#pragma mark - Private methods
//==============================================================================================

- (void)readImageFromLibraryType:(ImageSourceType)aImageSourceType callback:(BSGetPhotosDirectorDoneCallback) callback {
    
    // Set Callback
    self.getCallback = callback;
    
    UIImagePickerController * picker = [[UIImagePickerController new] autorelease];
    picker.delegate = self;
    picker.sourceType = aImageSourceType;
    [[self getRootViewController] presentViewController:picker animated:YES completion:nil];
}

- (void)writeImage:(UIImage *)image callback:(BSSavePhotosDirectorDoneCallback) callback {
    
    // Set Callback
    self.saveCallback = callback;
    
    ALAssetsLibrary *library = [[ALAssetsLibrary new] autorelease];
    
    [library writeImageToSavedPhotosAlbum:[image CGImage]
                              orientation:image.imageOrientation
                          completionBlock:^(NSURL *assetURL, NSError *error) {
                              
                              if (self.saveCallback) {
                                  
                                  if (error) {
                                      
                                      self.saveCallback([error localizedDescription], NO);
                                  }
                                  else {
                                      
                                      self.saveCallback(LOC(@"key.successfull"), YES);
                                  }
                              }
                          }];
}

- (UIViewController *)getRootViewController {
    
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}


//==============================================================================================
#pragma mark - UIImagePickerController Delegate methods
//==============================================================================================

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // Remove the picker view
    [[self getRootViewController] dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *pickedImage =  [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (self.getCallback) {
        
        if (pickedImage) {
            
            self.getCallback(pickedImage, @"",YES);
        }
        else {
            
            self.getCallback(nil, @"Image not found", NO);
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    // Remove the picker view
    [[self getRootViewController] dismissViewControllerAnimated:YES completion:nil];
    
    if (self.getCallback) {
        
        self.getCallback(nil, @"Picker cancelled: you cancelled the operation", NO);
    }
}


//==============================================================================================
#pragma mark - Memory management
//==============================================================================================

- (void)dealloc {
    
    [_saveCallback release];
    [_getCallback release];
    [super dealloc];
}

@end
