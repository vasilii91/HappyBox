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
    
    NSURL *url1 = [self urlByIndex:0 + indexPath.row * 3];
    NSURL *url2 = [self urlByIndex:1 + indexPath.row * 3];
    NSURL *url3 = [self urlByIndex:2 + indexPath.row * 3];
    
    NSMutableArray *threeURLs = [NSMutableArray new];
    if (url1) [threeURLs addObject:url1];
    if (url2) [threeURLs addObject:url2];
    if (url3) [threeURLs addObject:url3];
    
    photorollPreview.urls = threeURLs;
    
    return photorollPreview;
}

- (NSURL *)urlByIndex:(NSInteger)index
{
    if (index < [self.photoURLs count]) {
        
        NSURL *url = [NSURL URLWithString:self.photoURLs[index]];
        return url;
    }
    return nil;
}

- (NSInteger)rowCounts
{
    return [self.photoURLs count] / 3 + ([self.photoURLs count] % 3 == 0 ? 0 : 1);
}


#pragma mark - @protocol UITableViewDelegate<NSObject, UIScrollViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return IS_IPHONE ? 130 : 270;
}


#pragma mark - @protocol PhotorollPreviewDelegate <NSObject>

- (void)userTapOnImage:(UIImage *)image
{
    LOG(@"3");
    ResultViewController *resultVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ResultVC"];
    resultVC.photo = image;
    [self.navigationController pushViewController:resultVC animated:YES];
}


#pragma mark - Private methods

- (void)updateData
{
    [AsyncImageLoader sharedLoader].cache = [AsyncImageLoader defaultCache];
    
    NSString *serverIP = @"192.168.1.2/test";
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [HFSManager getAllPhotoLinksByServerURL:serverIP completionBlock:^(NSArray *photoURLs) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [SVProgressHUD dismiss];
            self.photoURLs = photoURLs;
            [tableViewPhotoroll reloadData];
        });
    }];
}

@end
