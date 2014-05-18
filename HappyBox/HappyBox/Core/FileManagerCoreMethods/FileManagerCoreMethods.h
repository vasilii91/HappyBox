//
//  FileManagerCoreMethods.m
//  changes
//
//  Created by Vasilii Kasnitski on 2/19/14.
//  Copyright (c) 2014 Vasilii.Kasnitski. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PhotoVideoObject;

@interface FileManagerCoreMethods : NSObject

+ (NSString *)pathFromPathComponents:(NSArray *)pathComponents;
+ (BOOL)createNewDirectoryWithPathComponents:(NSArray *)pathComponents;
+ (BOOL)deleteDirectoryWithPathComponents:(NSArray *)pathComponents;
+ (BOOL)deleteFile:(NSString *)fileName fromPathComponents:(NSArray *)pathComponents;
+ (BOOL)deleteFileByPath:(NSString *)path;

+ (NSArray *)listOfFilesInDirectoryFromPathComponents:(NSArray *)pathComponents;
+ (NSArray *)listOfSortedFilesInDirectoryFromPathComponents:(NSArray *)pathComponents extension:(NSString *)extension;

+ (BOOL)isExistFileByPath:(NSString *)path;
+ (BOOL)isExistFileByPathComponents:(NSArray *)pathComponents;
+ (float)getFreeSpace;
+ (NSString *)getFreeSpaceInHumanFormat;

+ (NSString *)addItem:(id)item toDirectoryWithPathComponents:(NSArray *)directoryPathComponents;


+ (UIImage *)photoByPhotoName:(NSString *)photoName isFullsize:(BOOL)isFullsize;
+ (NSString *)escapeString:(NSString *)stringToEscape;

@end
