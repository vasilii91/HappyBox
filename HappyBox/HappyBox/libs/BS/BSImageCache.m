//
//  BSImageCache.m
//  BaseSolution
//
//  Created by Alexander Raukuts on 2/3/13.
//  Copyright (c) 2013 Alexander Raukuts. All rights reserved.
//

#import "BSImageCache.h"

#define BSCacheCleanLimit 20 /* cache clean limit in percent % */

@interface BSImageCache ()

@property (atomic, retain)      NSMutableDictionary *dicCache;
@property (nonatomic, retain)   NSString            *cacheDirectory;
@property (nonatomic)           float                imageCompressionQuality;
@property (nonatomic)           float                maxCacheSize;

@end


@implementation BSImageCache
@synthesize cacheDirectory, dicCache;

static BSImageCache *instance = nil;

+ (BSImageCache *)sharedInstance {
    
    if (instance == nil) {
        
        instance = [BSImageCache new];
    }
    return instance;
}

- (id)init {
    
    self = [super init];
    if (self) {
        
        self.imageCompressionQuality = 0.8;
        self.maxCacheSize = 10240;
        self.cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        dicCache = [NSMutableDictionary new];
        [self cleanCacheDirectory];
    }
    return self;
}


//==============================================================================================
#pragma mark - Public methods
//==============================================================================================

- (void)cacheImage:(UIImage *)image withId:(NSString *)imageId cacheType:(CacheType)aCacheType {
    
    if (aCacheType == CacheTypeIsRAM) {
        
        [self dictionaryCacheImage:image withId:imageId];
    }
    else if (aCacheType == CacheTypeIsFS) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [self directoryCacheImage:image withId:imageId];
        });

    }
}

- (UIImage *)getCachedImageFromId:(NSString *)imageId cacheType:(CacheType)aCacheType {
    
    if (aCacheType == CacheTypeIsRAM) {
        
        return [self getDictionaryCachedImageFromId:imageId];
    }
    else if (aCacheType == CacheTypeIsFS) {
        
        return [self getDirectoryCachedImageFromId:imageId];
    }
    return nil;
}

- (void)cleanCacheWithType:(CacheType)aCacheType {
    
    if (aCacheType == CacheTypeIsRAM) {
        
        [self cleanDictionaryCache];
    }
    else if (aCacheType == CacheTypeIsFS) {
        
        [self cleanCacheDirectory];
    }
}

- (void)setCacheCompressionQuality:(float)quality {
    
    self.imageCompressionQuality = quality;
}

- (void)setCacheMaxSize:(float)maxSize {
    
    self.maxCacheSize = maxSize;
}

//==============================================================================================
#pragma mark - Private methods
//==============================================================================================

- (void)directoryCacheImage:(UIImage *)image withId:(NSString *)imageId {
    
    NSString *uniquePath = [self.cacheDirectory stringByAppendingPathComponent: imageId];
    
    if ([self folderSize:self.cacheDirectory] > self.maxCacheSize) {
        
        [self removeOldFileInCacheDirectory];
    }
    
    // Check for file existence
    if(![[NSFileManager defaultManager] fileExistsAtPath: uniquePath]) {
        // The file doesn't exist, we should get a copy of it
        // Running the image representation function writes the data from the image to a file
        NSData *imageData = UIImageJPEGRepresentation(image, self.imageCompressionQuality);
        [imageData writeToFile: uniquePath atomically: YES];
    }
}

- (UIImage *)getDirectoryCachedImageFromId:(NSString *)imageId {
    
    NSString *uniquePath = [self.cacheDirectory stringByAppendingPathComponent: imageId];
    
    UIImage *image = [UIImage imageWithContentsOfFile:uniquePath];
    
    return image;
}

- (void)dictionaryCacheImage:(UIImage *)image withId:(NSString *)imageId {
    
    @synchronized (self.dicCache) {
        
        [self.dicCache setObject:image forKey:imageId];
    }
}

- (UIImage *)getDictionaryCachedImageFromId:(NSString *)imageId {
    
    return [self.dicCache objectForKey:imageId];
}

- (void)cleanDictionaryCache {
    
    @synchronized (self.dicCache) {
        
        [self.dicCache removeAllObjects];
    }
}

- (void)cleanCacheDirectory {
    
    NSError *error = nil;
    
    for (NSString *file in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cacheDirectory error:&error]) {
        
        [[NSFileManager defaultManager] removeItemAtPath:[cacheDirectory stringByAppendingPathComponent:file] error:&error];
    }
}

- (unsigned long long int)folderSize:(NSString *)folderPath {
    
    NSArray *filesArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:folderPath error:nil];
    NSEnumerator *filesEnumerator = [filesArray objectEnumerator];
    NSString *fileName;
    unsigned long long int fileSize = 0;
    
    while (fileName = [filesEnumerator nextObject]) {
        NSDictionary *fileDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:fileName] error:nil];
        fileSize += [fileDictionary fileSize];
    }
    
    return fileSize/1024; //folder size in kb
}

- (void)removeOldFileInCacheDirectory {
    
    NSMutableArray *unsortedFilesAttributes = [NSMutableArray new];
    NSError *error;
    
    // fetch file names in PSCacheFolder
    NSMutableArray *filesNames =[[[[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.cacheDirectory error:&error] mutableCopy] autorelease];
    
    //fetch file attributes for sorting
    for (NSString *fileName in filesNames) {
        
        NSString *uniquePath = [self.cacheDirectory stringByAppendingPathComponent:fileName];
        NSDictionary *file = [[NSFileManager defaultManager] attributesOfItemAtPath:uniquePath error:&error];
        [unsortedFilesAttributes addObject:file];
    }
    
    // sort files by NSFileModificationDate
    NSSortDescriptor * sortByDate = [[[NSSortDescriptor alloc] initWithKey:NSFileModificationDate ascending:YES] autorelease];
    
    NSArray * descriptors = [NSArray arrayWithObject:sortByDate];
    NSMutableArray * sorted = [NSMutableArray arrayWithArray:[unsortedFilesAttributes sortedArrayUsingDescriptors:descriptors]];
    
    // Delete old files
    
    int folderSize = 0;
    [self folderSize:self.cacheDirectory];
    
    do {
        
        NSDictionary *attributeFileForRemove = [sorted lastObject];
        NSNumber *systemFileNumberForRemove = [attributeFileForRemove objectForKey:NSFileSystemFileNumber];
        
        for (NSString *name in filesNames) {
            
            NSString *uniquePath = [self.cacheDirectory stringByAppendingPathComponent:name];
            NSDictionary *fileAttribute = [[NSFileManager defaultManager] attributesOfItemAtPath:uniquePath error:&error];
            NSNumber *systemFileNumber = [fileAttribute objectForKey:NSFileSystemFileNumber];
            
            if ([systemFileNumber isEqualToNumber: systemFileNumberForRemove]) {
                
                [[NSFileManager defaultManager]removeItemAtPath:uniquePath error:&error];
                [sorted removeObject:attributeFileForRemove];
            }
        }
        
        folderSize = [self folderSize:self.cacheDirectory];
        
    } while (folderSize > (self.maxCacheSize - (folderSize/100)*BSCacheCleanLimit));
    
    [unsortedFilesAttributes release];
}

//==============================================================================================
#pragma mark - Memory management
//==============================================================================================

- (void)dealloc {
    
    [dicCache release];
    [cacheDirectory release];
    [super dealloc];
}

@end
