//
//  PhotorollViewController.m
//  Photomat
//
//  Created by Vasilii Kasnitski on 12/23/13.
//  Copyright (c) 2013 OCSICO. All rights reserved.
//

#import "PhotorollViewController.h"
#import "Constants.h"
#import "PhotorollNavBar.h"
#import "PhotorollToolbar.h"
#import "PhotorollPreview.h"
#import "FileManagerObject.h"
#import "SVProgressHUD.h"
#import "FileManagerCoreMethods.h"
#import "UIView+Nib.h"
#import "ResultViewController.h"
#import "AsyncImageView.h"
#import "HFSManager.h"
#import "SDWebImageManager.h"
#import "UIImage+Resize.h"
#import "BSImageCache.h"

@interface PhotorollViewController ()
{
}

@end

@implementation PhotorollViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeControls];
    
    [NSTimer scheduledTimerWithTimeInterval:10.0
                                     target:self
                                   selector:@selector(updateData)
                                   userInfo:nil
                                    repeats:YES];
    [self updateData];
}

- (void)initializeControls
{
    labelTitle.text = LOC(@"key.photoroll_title");
    
    photorollNavBar = [PhotorollNavBar loadView];
    photorollToolBar = [PhotorollToolbar loadView];
    
    NSString *postfix = IS_IPAD ? @"iPad" : @"iPhone";
    [tableViewPhotoroll registerNib:[UINib nibWithNibName:[NSString stringWithFormat:@"PhotorollPreview_%@", postfix] bundle:[NSBundle mainBundle]] forCellReuseIdentifier:PHOTOROLL_PREVIEW_CELL_ID];
    
    [tableViewPhotoroll setContentInset:UIEdgeInsetsMake(30, 0, 0, 0)];
}


#pragma mark - Actions

- (IBAction)clickOnBackButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickOnSelectButton:(id)sender
{
    [tableViewPhotoroll reloadData];
}


#pragma mark - @protocol UITableViewDataSource<NSObject>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self rowCounts];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhotorollPreview *photorollPreview = [tableView dequeueReusableCellWithIdentifier:PHOTOROLL_PREVIEW_CELL_ID];
    if (photorollPreview == nil) {
        photorollPreview = [PhotorollPreview viewFromDefNib];
    }
    photorollPreview.selectionStyle = UITableViewCellSelectionStyleNone;
    photorollPreview.row = indexPath.row;
    photorollPreview.delegate = self;
    photorollPreview.backgroundColor = [UIColor clearColor];
    
    NSMutableArray *photos = [NSMutableArray new];
    for (int i = 0; i < 5; i++) {
        UIImage *photo = [self photoByIndex:i + indexPath.row * 5 isFullsize:NO];
        if (photo) {
            [photos addObject:photo];
        }
    }
    photorollPreview.photos = photos;
    
    return photorollPreview;
}

- (UIImage *)photoByIndex:(NSInteger)index isFullsize:(BOOL)isFullsize
{
    if (index < [listOfPhotos count]) {
        
        UIImage *photo = [FileManagerCoreMethods photoByPhotoName:self.photoURLs[index] isFullsize:isFullsize];
        return photo;
    }
    return nil;
}

- (NSInteger)rowCounts
{
    return [listOfPhotos count] / 5 + ([listOfPhotos count] % 5 == 0 ? 0 : 1);
}


#pragma mark - @protocol UITableViewDelegate<NSObject, UIScrollViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return IS_IPHONE ? 130 : 270;
}


#pragma mark - @protocol PhotorollPreviewDelegate <NSObject>

- (void)userTapOnPhotoWithIndex:(NSInteger)index
{
    UIImage *photo = [FileManagerCoreMethods photoByPhotoName:self.photoURLs[index] isFullsize:YES];
    
    ResultViewController *resultVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ResultVC"];
    resultVC.photo = photo;
    [self.navigationController pushViewController:resultVC animated:YES];
}


#pragma mark - Private methods

- (void)updateData
{
    NSArray *photoURLs = @[@"http://oboi20.ru/originals/original_1548_oboi_gusenica_otdyhaet_2500x1875.jpg",
                           @"http://wallbox.ru/wallpapers/dl/201420/731cbd08fd41f46b661d4fa5f77116b0.jpg",
                           @"http://wallbox.ru/wallpapers/main/201149/peyzazhi-7a44861adef4.jpg",
                           @"http://wallbox.ru/wallpapers/main/201149/erotika-0d34e007e8ad.jpg",
                           @"http://wallbox.ru/wallpapers/main/201149/multfilmy-744290db703c.jpg",
                           @"http://wallbox.ru/wallpapers/main/201149/zhivotnye-f5503e09afb1.jpg",
                           @"http://wallbox.ru/wallpapers/main/201408/0389456445cda09.jpg",
                           @"http://wallbox.ru/wallpapers/main/201408/2ea4f968e3181df.jpg",
                           @"http://wallbox.ru/wallpapers/main/201408/de9b89c2e08751b.jpg",
                           @"http://wallbox.ru/wallpapers/main/201408/4feebe4baac7440.jpg",
                           @"http://wallbox.ru/wallpapers/main/201408/42a86f9828cc164.jpg",
                           @"http://wallbox.ru/wallpapers/main/201408/0a148435dd842e1.jpg",
                           @"http://wallbox.ru/wallpapers/main/201408/4118b9d7e898cd8.jpg",
                           @"http://wallbox.ru/wallpapers/main/201402/716b059d97a7d60.jpg",
                           @"http://wallbox.ru/wallpapers/main/201402/bfcd5b08f9ca9d6.jpg",
                           @"http://wallbox.ru/wallpapers/main/201402/2faedf0319f79b4.jpg",
                           @"http://wallbox.ru/wallpapers/main/201402/f9f17a89207dbc0.jpg",
                           @"http://wallbox.ru/wallpapers/main/201402/ab417ffe2e46ea0.jpg",
                           @"http://wallbox.ru/wallpapers/main/201402/8f1ebf428547d34.jpg",
                           @"http://wallbox.ru/wallpapers/main/201402/704e9eb63fe6686.jpg",
                           @"http://wallbox.ru/wallpapers/main/201402/adc29250334ff91.jpg",
                           @"http://wallbox.ru/wallpapers/main/201402/862dc0b905f259c.jpg",
                           @"http://wallbox.ru/wallpapers/main/201402/b0b982cb3ad50a9.jpg",
                           @"http://wallbox.ru/wallpapers/main/201402/777a6be9d580a33.jpg",
                           @"http://wallbox.ru/wallpapers/main/201402/5330528d74fc073.jpg",
                           @"http://wallbox.ru/wallpapers/main/201402/3647290b2393dc8.jpg",
                           @"http://wallbox.ru/wallpapers/main/201402/6574b5e9ca3ef39.jpg",
                           @"http://wallbox.ru/wallpapers/main/201402/bdd1332a95ae3eb.jpg",
                           @"http://wallbox.ru/wallpapers/main/201402/cc462fdbcbd891c.jpg",
                           ];
    
    if ([self.photoURLs count] != [photoURLs count]) {
        
        self.photoURLs = photoURLs;
        [self downloadPhotos];
    }
    
//    NSString *serverIP = @"192.168.1.2/test";
//    [HFSManager getAllPhotoLinksByServerURL:serverIP completionBlock:^(NSArray *photoURLs) {
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.photoURLs = photoURLs;
//            [self downloadPhotos];
//        });
//    }];
}

- (void)downloadPhotos
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    for (int i = 0; i < [self.photoURLs count]; i++) {
        
        NSString *photoName = self.photoURLs[i];
        photoName = [FileManagerCoreMethods escapeString:photoName];
        
        NSArray *photoPathComponents = @[DIRECTORY_NAME_MAIN_HAPPYBOX_PHOTOS,
                                         DIRECTORY_NAME_FULLSIZE_PHOTOS,
                                         photoName];
        NSArray *photoPreviewPathComponents = @[DIRECTORY_NAME_MAIN_HAPPYBOX_PHOTOS,
                                                DIRECTORY_NAME_PREVIEW_PHOTOS,
                                                photoName];
        
        if ([FileManagerCoreMethods isExistFileByPathComponents:photoPathComponents] == NO) {
            [manager downloadWithURL:self.photoURLs[i]
                             options:0
                            progress:^(NSInteger receivedSize, NSInteger expectedSize)
             {
                 // progression tracking code
             } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                 if (image)
                 {
                     UIImage *imageResized = [image resizedImage:CGSizeMake(250, 250) interpolationQuality:kCGInterpolationLow];
                     [FileManagerCoreMethods addItem:image toDirectoryWithPathComponents:photoPathComponents];
                     [FileManagerCoreMethods addItem:imageResized toDirectoryWithPathComponents:photoPreviewPathComponents];
                     [[BSImageCache sharedInstance] cacheImage:imageResized withId:photoName cacheType:CacheTypeIsRAM];
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                         listOfPhotos = [FileManagerCoreMethods listOfFilesInDirectoryFromPathComponents:@[DIRECTORY_NAME_MAIN_HAPPYBOX_PHOTOS, DIRECTORY_NAME_PREVIEW_PHOTOS]];
                         [tableViewPhotoroll reloadData];
                     });
                 }
             }];
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                listOfPhotos = [FileManagerCoreMethods listOfFilesInDirectoryFromPathComponents:@[DIRECTORY_NAME_MAIN_HAPPYBOX_PHOTOS, DIRECTORY_NAME_PREVIEW_PHOTOS]];
                [tableViewPhotoroll reloadData];
            });
        }
    }
}

@end
