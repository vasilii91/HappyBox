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
#import "StatisticsViewController.h"
#import "LDProgressView.h"

@interface PhotorollViewController ()
{
}

@end

@implementation PhotorollViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeControls];
}

- (void)initializeControls
{
    labelTitle.text = LOC(@"key.photoroll_title");
    
    photorollNavBar = [PhotorollNavBar loadView];
    photorollToolBar = [PhotorollToolbar loadView];
    
    NSString *postfix = IS_IPAD ? @"iPad" : @"iPhone";
    [tableViewPhotoroll registerNib:[UINib nibWithNibName:[NSString stringWithFormat:@"PhotorollPreview_%@", postfix] bundle:[NSBundle mainBundle]] forCellReuseIdentifier:PHOTOROLL_PREVIEW_CELL_ID];
    
    [tableViewPhotoroll setContentInset:UIEdgeInsetsMake(30, 0, 0, 0)];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOnStatisticsButton)];
    tapGR.numberOfTapsRequired = 4;
    buttonStatistics.gestureRecognizers = @[tapGR];
    
    UITapGestureRecognizer *tapGR2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateData)];
    tapGR.numberOfTapsRequired = 2;
    buttonUpdateData.gestureRecognizers = @[tapGR2];
    
    [self createProgressView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self updateData];
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

- (IBAction)clickOnLeftCorner:(id)sender
{
    [tableViewPhotoroll scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)clickOnStatisticsButton
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"STATISTICS" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil] ;
    alertView.delegate = self;
    alertView.tag = 2;
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *tf = [alertView textFieldAtIndex:0];
    tf.keyboardType = UIKeyboardTypeNumberPad;
    
    [alertView show];
}


#pragma mark - @protocol UIAlertViewDelegate <NSObject>

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *enteredText = [[alertView textFieldAtIndex:0] text];
        if ([enteredText isEqualToString:UDValue(SETTINGS_STATISTICS_PASSWORD)]) {
            StatisticsViewController *statisticsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StatisticsVC"];
            statisticsVC.countOfPhotos = [self.photoURLs count];
            [self.navigationController pushViewController:statisticsVC animated:YES];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Incorrect password" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] ;
            [alertView show];
        }
    }
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
        else {
            photo = [self photoByIndex:i + indexPath.row * 5 isFullsize:YES];
            if (photo) {
                [photos addObject:photo];
            }
        }
    }
    photorollPreview.photos = photos;
    
    return photorollPreview;
}

- (UIImage *)photoByIndex:(NSInteger)index isFullsize:(BOOL)isFullsize
{
    if (index < [self.photoURLs count]) {
        
        UIImage *photo = [FileManagerCoreMethods photoByPhotoName:self.photoURLs[index] isFullsize:isFullsize];
        return photo;
    }
    return nil;
}

- (NSInteger)rowCounts
{
    return [self.photoURLs count] / 5 + ([self.photoURLs count] % 5 == 0 ? 0 : 1);
}


#pragma mark - @protocol UITableViewDelegate<NSObject, UIScrollViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return IS_IPHONE ? 130 : 292;
}


#pragma mark - @protocol PhotorollPreviewDelegate <NSObject>

- (void)userTapOnPhotoWithIndex:(NSInteger)index
{
    UIImage *photo = [FileManagerCoreMethods photoByPhotoName:self.photoURLs[index] isFullsize:YES];
    
    ResultViewController *resultVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ResultVC"];
    resultVC.photo = photo;
    resultVC.photoURLString = self.photoURLs[index];
    
    [self.navigationController pushViewController:resultVC animated:YES];
}

- (void)userDoubleTapOnPhotoWithIndex:(NSInteger)index
{
    LOG(@"DOUBLE TAP - %d", index);
    [self downloadPhotoByIndex:index];
}


#pragma mark - Private methods (Views)

- (void)createProgressView
{
    progressView = [[LDProgressView alloc]
                    initWithFrame:CGRectMake(-1,
                                             0,
                                             ViewWidth(viewContainerForProgress) + 2,
                                             ViewHeight(viewContainerForProgress) + 1)];
    progressView.borderRadius = @0;
    progressView.animate = @YES;
    progressView.flat = @YES;
    progressView.type = LDProgressSolid;
    progressView.color = UIColorFromRGB(21.0, 150.0, 210.0);
    progressView.background = viewContainerForProgress.backgroundColor;
    progressView.showText = @YES;
    
    [viewContainerForProgress addSubview:progressView];
    
    progressView.hidden = YES;
    labelProgress.hidden = YES;
    viewContainerForProgress.hidden = YES;
}


#pragma mark - Private methods

- (void)updateData
{
    [FileManagerCoreMethods createNewDirectoryWithPathComponents:@[DIRECTORY_NAME_MAIN_HAPPYBOX_PHOTOS,
                                                                   DIRECTORY_NAME_FULLSIZE_PHOTOS]];
    [FileManagerCoreMethods createNewDirectoryWithPathComponents:@[DIRECTORY_NAME_MAIN_HAPPYBOX_PHOTOS,
                                                                   DIRECTORY_NAME_PREVIEW_PHOTOS]];
  
// V_1
    
//    currentIndex = 0;
//    NSArray *photoURLs = @[@"http://oboi20.ru/originals/original_1548_oboi_gusenica_otdyhaet_2500x1875.jpg",
//                           @"http://wallbox.ru/wallpapers/dl/201420/731cbd08fd41f46b661d4fa5f77116b0.jpg",
//                           @"http://wallbox.ru/wallpapers/main/201149/peyzazhi-7a44861adef4.jpg"];
//    
//    
//    self.photoURLs = photoURLs;
//    [self downloadPhotoStepByStep];


// V_2
    
//    currentIndex = 0;
//    NSArray *photoURLs = @[@"http://oboi20.ru/originals/original_1548_oboi_gusenica_otdyhaet_2500x1875.jpg",
//                           @"http://wallbox.ru/wallpapers/dl/201420/731cbd08fd41f46b661d4fa5f77116b0.jpg",
//                           @"http://wallbox.ru/wallpapers/main/201149/peyzazhi-7a44861adef4.jpg",
//                           @"http://uhdoityourself.files.wordpress.com/2012/11/nicole-meyer-ann-summers-1-768x1024.jpg",
//                           @"http://wallbox.ru/wallpapers/main/201149/multfilmy-744290db703c.jpg",
//                           @"http://wallbox.ru/wallpapers/main/201149/zhivotnye-f5503e09afb1.jpg",
//                           @"http://uhdoityourself.files.wordpress.com/2012/11/nicole-meyer-ann-summers-4-768x1024.jpg",
//                           @"http://wallbox.ru/wallpapers/main/201402/bfcd5b08f9ca9d6.jpg",
//                           @"http://wallbox.ru/wallpapers/main/201402/ab417ffe2e46ea0.jpg",
//                           @"http://wallbox.ru/wallpapers/main/201402/3647290b2393dc8.jpg",
//                           @"http://wallbox.ru/wallpapers/main/201402/6574b5e9ca3ef39.jpg",
//                           @"http://wallbox.ru/wallpapers/main/201402/bdd1332a95ae3eb.jpg",
//                           @"http://wallbox.ru/wallpapers/main/201402/cc462fdbcbd891c.jpg",
//                           ];
//    
//        
//    self.photoURLs = photoURLs;
//    [self downloadPhotoStepByStep];
  
// PRODUCTION
    
    currentIndex = 0;
    NSString *serverIP = [NSString stringWithFormat:@"%@:%@/%@", UDValue(SETTINGS_SERVER_ADDRESS), UDValue(SETTINGS_PORT), UDValue(SETTINGS_FOLDER_NAME)]; // @"192.168.1.2/test";
    [HFSManager getAllPhotoLinksByServerURL:serverIP completionBlock:^(NSArray *photoURLs) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photoURLs = photoURLs;
            [self downloadPhotoStepByStep];
        });
    }];
}

- (void)downloadPhotoStepByStep
{
    if (currentIndex < [self.photoURLs count]) {

        NSString *photoName = self.photoURLs[currentIndex];
        photoName = [FileManagerCoreMethods escapeString:photoName];
        
        NSArray *photoPathComponents = @[DIRECTORY_NAME_MAIN_HAPPYBOX_PHOTOS,
                                         DIRECTORY_NAME_FULLSIZE_PHOTOS,
                                         photoName];
        NSArray *photoPreviewPathComponents = @[DIRECTORY_NAME_MAIN_HAPPYBOX_PHOTOS,
                                                DIRECTORY_NAME_PREVIEW_PHOTOS,
                                                photoName];
        
        if ([FileManagerCoreMethods isExistFileByPathComponents:photoPathComponents] == NO) {
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
            dispatch_async(queue, ^(void) {
                
                NSURL *url = [NSURL URLWithString:self.photoURLs[currentIndex]];
                NSData *imageData = [NSData dataWithContentsOfURL:url];
                UIImage *image = [[UIImage alloc] initWithData:imageData];
                if (image) {
                    
                    UIImage *imageResized = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(250, 250) interpolationQuality:kCGInterpolationDefault];
                    [FileManagerCoreMethods addItem:image toDirectoryWithPathComponents:photoPathComponents];
                    [FileManagerCoreMethods addItem:imageResized toDirectoryWithPathComponents:photoPreviewPathComponents];
                    [[BSImageCache sharedInstance] cacheImage:imageResized withId:photoName cacheType:CacheTypeIsRAM];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [tableViewPhotoroll reloadData];
                        
                        viewContainerForProgress.hidden = NO;
                        NSString *status = [NSString stringWithFormat:@"%ld из %lu", (long)currentIndex, (unsigned long)[self.photoURLs count]];
                        labelProgress.hidden = NO;
                        labelProgress.text = status;
                        
                        if (currentIndex >= [self.photoURLs count]) {
                            labelProgress.hidden = YES;
                            viewContainerForProgress.hidden = YES;
                        }
                    });
                    
                    currentIndex++;
                    [self downloadPhotoStepByStep];
                }
            });
        }
        else {
            [tableViewPhotoroll reloadData];
            
            currentIndex++;
            [self downloadPhotoStepByStep];
        }
    }
    else {
        viewContainerForProgress.hidden = YES;
        labelProgress.hidden = YES;
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [NSTimer scheduledTimerWithTimeInterval:5.0
                                             target:self
                                           selector:@selector(updateData)
                                           userInfo:nil
                                            repeats:YES];
        });
    }
}

- (void)downloadPhotoByIndex:(NSInteger)photoIndex
{
    NSString *photoName = self.photoURLs[photoIndex];
    photoName = [FileManagerCoreMethods escapeString:photoName];
    
    NSArray *photoPathComponents = @[DIRECTORY_NAME_MAIN_HAPPYBOX_PHOTOS,
                                     DIRECTORY_NAME_FULLSIZE_PHOTOS,
                                     photoName];
    NSArray *photoPreviewPathComponents = @[DIRECTORY_NAME_MAIN_HAPPYBOX_PHOTOS,
                                            DIRECTORY_NAME_PREVIEW_PHOTOS,
                                            photoName];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^(void) {
        
        NSURL *url = [NSURL URLWithString:self.photoURLs[photoIndex]];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        
        if (image) {
            UIImage *imageResized = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(250, 250) interpolationQuality:kCGInterpolationDefault];
            [FileManagerCoreMethods addItem:image toDirectoryWithPathComponents:photoPathComponents];
            [FileManagerCoreMethods addItem:imageResized toDirectoryWithPathComponents:photoPreviewPathComponents];
            [[BSImageCache sharedInstance] cacheImage:imageResized withId:photoName cacheType:CacheTypeIsRAM];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [tableViewPhotoroll reloadData];
            });
        }
    });
}

- (void)changeProgressStatus
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        viewContainerForProgress.hidden = NO;
        NSString *status = [NSString stringWithFormat:@"%ld из %lu", currentIndex + 1, (unsigned long)[self.photoURLs count]];
        labelProgress.hidden = NO;
        labelProgress.text = status;
    });
}

@end
