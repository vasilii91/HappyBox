//
//  FileManagerCoreMethods.m
//  changes
//
//  Created by Vasilii Kasnitski on 2/19/14.
//  Copyright (c) 2014 Vasilii.Kasnitski. All rights reserved.
//

#import "FileManagerCoreMethods.h"
#import "NSString+Date.h"
#import "FileManagerObject.h"
#import "UIImage+Resizing.h"
#import "UserSettings.h"
#import "BSImageCache.h"

@implementation FileManagerCoreMethods


#pragma mark - Core methods

+ (NSString *)pathFromPathComponents:(NSArray *)pathComponents
{
    NSString *path = DocumentsDirectory();
    for (NSString *pathComponent in pathComponents) {
        path = [path stringByAppendingPathComponent:pathComponent];
    }
    
    return path;
}

+ (BOOL)createNewDirectoryWithPathComponents:(NSArray *)pathComponents
{
    NSString *path = [FileManagerCoreMethods pathFromPathComponents:pathComponents];
    
    if ([self isExistFileByPath:path]) {
        return NO;
    }
    else {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error = nil;
        if ([fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error] == NO) {
            LOG(@"%@", error.localizedDescription);
            return NO;
        }
        
        return YES;
    }
}

+ (BOOL)deleteDirectoryWithPathComponents:(NSArray *)pathComponents
{
    NSString *path = [FileManagerCoreMethods pathFromPathComponents:pathComponents];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:path error:nil];
}

+ (BOOL)deleteFile:(NSString *)fileName fromPathComponents:(NSArray *)pathComponents
{
    NSMutableArray *components = [NSMutableArray arrayWithArray:pathComponents];
    [components addObject:fileName];
    NSString *path = [FileManagerCoreMethods pathFromPathComponents:components];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    if ([fileManager removeItemAtPath:path error:&error] == NO) {
        LOG(@"%@", [error description]);
        return NO;
    }
    
    return YES;
}

+ (BOOL)deleteFileByPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    if ([fileManager removeItemAtPath:path error:&error] == NO) {
        LOG(@"%@", [error description]);
        return NO;
    }
    
    return YES;
}

+ (NSArray *)listOfFilesInDirectoryFromPathComponents:(NSArray *)pathComponents
{
    NSString *path = [FileManagerCoreMethods pathFromPathComponents:pathComponents];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSArray *fileList = [filemgr contentsOfDirectoryAtPath:path error:nil];
    
    return fileList;
}

+ (NSArray *)listOfFilesInDirectoryFromPathComponents:(NSArray *)pathComponents extension:(NSString *)extension
{
    NSArray *fileList = [self listOfFilesInDirectoryFromPathComponents:pathComponents];
    NSMutableArray *photosFileList = [NSMutableArray new];
    
    for (NSString *fileName in fileList) {
        if ([fileName rangeOfString:extension].location != NSNotFound) {
            [photosFileList addObject:fileName];
        }
    }
    
    return photosFileList;
}

+ (NSArray *)listOfSortedFilesInDirectoryFromPathComponents:(NSArray *)pathComponents extension:(NSString *)extension
{
    NSArray *fileList = [self listOfFilesInDirectoryFromPathComponents:pathComponents];
    NSMutableArray *photosFileList = [NSMutableArray new];
    
    for (NSString *fileName in fileList) {
        if ([fileName rangeOfString:extension].location != NSNotFound) {
            [photosFileList addObject:fileName];
        }
    }
    
    NSArray *photosFileListImmutable = [NSArray arrayWithArray:photosFileList];
    
    clock_t start = clock(); // перед входом в участок кода
    
    photosFileListImmutable = [photosFileListImmutable sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        NSNumber *d1 = @([[obj1 componentsSeparatedByString:extension][0] floatValue]);
        NSNumber *d2 = @([[obj2 componentsSeparatedByString:extension][0] floatValue]);
        
        return [d2 compare:d1];
    }];
    
    // здесь находится код, время выполнения которого мы хотим проверить
    clock_t finish = clock(); // на выходе из участка кода
    clock_t duration = finish - start;
    double durInSec = (double)duration / CLOCKS_PER_SEC; // время в секундах
    NSLog(@"%lu - %f", duration, durInSec);
    
    return photosFileListImmutable;
}

+ (BOOL)isExistFileByPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    return [fileManager fileExistsAtPath:path];
}


+ (BOOL)isExistFileByPathComponents:(NSArray *)pathComponents
{
    NSString *path = [FileManagerCoreMethods pathFromPathComponents:pathComponents];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    return [fileManager fileExistsAtPath:path];
}

+ (BOOL)renameDirectoryFrom:(NSString *)oldPath to:(NSString *)newPath
{
    NSFileManager *fileMan = [NSFileManager defaultManager];
    NSError *error = nil;
    if (![fileMan moveItemAtPath:oldPath toPath:newPath error:&error])
    {
        LOG(@"Failed to move '%@' to '%@': %@", oldPath, newPath, [error localizedDescription]);
        return NO;
    }
    return YES;
}

+ (float)getFreeSpace
{
    float freeSpace = 0.0f;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *fileSystemFreeSizeInBytes = [dictionary objectForKey: NSFileSystemFreeSize];
        freeSpace = [fileSystemFreeSizeInBytes floatValue];
    } else {
        LOG(@"%@", error);
    }
    
    return freeSpace;
}

+ (NSString *)getFreeSpaceInHumanFormat
{
    float value = [FileManagerCoreMethods getFreeSpace];
    int multiplyFactor = 0;
    
    NSArray *tokens = [NSArray arrayWithObjects:@"bytes",@"Kb",@"Mb",@"Gb",@"Tb",nil];
    
    while (value > 1024) {
        value /= 1024;
        multiplyFactor++;
    }
    
    return [NSString stringWithFormat:@"%.0f %@", value, [tokens objectAtIndex:multiplyFactor]];
}

+ (NSString *)addItem:(id)item toDirectoryWithPathComponents:(NSArray *)directoryPathComponents
{
    NSData *dataToWrite = UIImageJPEGRepresentation((UIImage *)item, 1.0);
    
    NSString *path = [FileManagerCoreMethods pathFromPathComponents:directoryPathComponents];
    
    NSError *error;
    BOOL success = [dataToWrite writeToFile:path options:0 error:&error];
    if (!success) {
        NSLog(@"writeToFile failed with error %@", error);
    }
    
    return path;
}

+ (UIImage *)photoByPhotoName:(NSString *)photoName isFullsize:(BOOL)isFullsize
{
    photoName = [self escapeString:photoName];
    
    UIImage *photo = nil;
    if (isFullsize) {
        NSArray *pathComponents = @[DIRECTORY_NAME_MAIN_HAPPYBOX_PHOTOS,
                                    DIRECTORY_NAME_FULLSIZE_PHOTOS,
                                    photoName];
        NSString *path = [self pathFromPathComponents:pathComponents];
        photo = [UIImage imageWithContentsOfFile:path];
    }
    else {
        photo = [[BSImageCache sharedInstance] getCachedImageFromId:photoName cacheType:CacheTypeIsRAM];
        
        if (photo == nil) {
            NSArray *pathComponents = @[DIRECTORY_NAME_MAIN_HAPPYBOX_PHOTOS,
                                        DIRECTORY_NAME_PREVIEW_PHOTOS,
                                        photoName];
            NSString *path = [self pathFromPathComponents:pathComponents];
            photo = [UIImage imageWithContentsOfFile:path];
            
            if (photo) {
                [[BSImageCache sharedInstance] cacheImage:photo withId:photoName cacheType:CacheTypeIsRAM];
            }
        }
    }

    return photo;
}

+ (NSString *)escapeString:(NSString *)stringToEscape
{
    NSString *escapedString = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                        (__bridge CFStringRef)stringToEscape,
                                                                                        NULL,
                                                                                        CFSTR("!*'();:@&=+$,/?%#[]\""),
                                                                                        kCFStringEncodingUTF8));
    
    return escapedString;
}

@end
