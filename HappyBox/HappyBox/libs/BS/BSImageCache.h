//
//  BSImageCache.h
//  BaseSolution
//
//  Created by Alexander Raukuts on 1/13/13.
//  Copyright (c) 2013 Alexander Raukuts. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    
    CacheTypeIsRAM, /* Source of cached information is Operation Device Memory */
    CacheTypeIsFS   /* Source of cached information is File System */
} CacheType;

@interface BSImageCache : NSObject

+ (BSImageCache *)sharedInstance;

- (void)cacheImage:(UIImage *)image withId:(NSString *)imageId cacheType:(CacheType)aCacheType;
- (UIImage *)getCachedImageFromId:(NSString *)imageId cacheType:(CacheType)aCacheType;

#pragma mark - Cache Setup

/*!
 @method
 @abstract   Set Compression Quality for Image Cache with type saving on FS
 @param      quality         The quality value 0.0 - 1.0. Default - 0.8.
 */
- (void)setCacheCompressionQuality:(float)quality;

/*!
 @method
 @abstract   Set maximum Cache size for Cache with type saving on FS
 @param      maxSize         The max size value in kb. Default - 10240 (10 Mb).
 */
- (void)setCacheMaxSize:(float)maxSize;

- (void)cleanCacheWithType:(CacheType)aCacheType;

@end
