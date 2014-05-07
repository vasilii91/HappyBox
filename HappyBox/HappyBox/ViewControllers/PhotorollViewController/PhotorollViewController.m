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

@interface PhotorollViewController ()
{
}

@end

@implementation PhotorollViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initializeControls];
    [self reloadDataByTag:StateTagPhotoroll];
}

- (void)initializeControls
{
    labelTitle.text = LOC(@"key.photoroll_title");
    [buttonBack setTitle:LOC(@"key.back_button_text") forState:UIControlStateNormal];
    [buttonSelect setTitle:LOC(@"key.button_select") forState:UIControlStateNormal];
    [buttonCreateVideo setTitle:LOC(@"key.button_create_video") forState:UIControlStateNormal];
    
    buttonBack.exclusiveTouch = YES;
    buttonSelect.exclusiveTouch = YES;
    buttonShare.exclusiveTouch = YES;
    buttonDelete.exclusiveTouch = YES;
    
    buttonShare.hidden = YES;
    buttonDelete.hidden = YES;
    
    photorollNavBar = [PhotorollNavBar loadView];
    photorollToolBar = [PhotorollToolbar loadView];
    
    // Create browser
    browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;
    browser.displayNavArrows = NO;
    browser.wantsFullScreenLayout = NO;
    browser.zoomPhotosToFill = NO;
    [browser setCurrentPhotoIndex:0];
    [browser setBackgroungColor:MAIN_APP_COLOR_BLUE];
    [browser setCustomNavigationBar:photorollNavBar];
    [browser setCustomToolBar:photorollToolBar];
    
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
    [self changeSelectionState];
    [tableViewPhotoroll reloadData];
}

- (void)photoSelectedAtIndex:(NSUInteger)index
{
    [browser setCurrentPhotoIndex:index];
    [self.navigationController pushViewController:browser animated:YES];
}


#pragma mark - Private methods

- (void)deleteSelectedFileManagerObjects:(NSArray *)selectedFileManagerObjects
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    for (FileManagerObject *fMO in selectedFileManagerObjects) {
        [FileManagerCoreMethods deleteFileByPath:fMO.pathToImage];
        [FileManagerCoreMethods deleteFileByPath:fMO.pathToImagePreview];
    }
    [tableViewPhotoroll reloadData];
    [SVProgressHUD dismiss];
}

- (void)reloadDataByTag:(StateTag)stateTag
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      
#warning THIS NEED TO CHANGE
//        fileManagerObjects = [FileManagerCoreMethods getAllPhotosByChangesOneName:self.changesOneObject.name isReverse:NO];
        indexesOfSelected = [NSMutableArray new];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            if ([fileManagerObjects count] == 0) {
                if (stateTag == StateTagPhotoroll) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else {
                    [self.navigationController popViewControllerAnimated:NO];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
            else {
                [tableViewPhotoroll reloadData];
                [browser reloadData];
                [SVProgressHUD dismiss];
            }
        });
    });
}

- (void)changeSelectionState
{
    selectionState = !selectionState;
    if (selectionState) {
        [buttonSelect setTitle:NSLocalizedString(@"key.cancel_title", @"Cancel") forState:UIControlStateNormal];
    }
    else {
        [buttonSelect setTitle:NSLocalizedString(@"key.button_select", @"Select") forState:UIControlStateNormal];
        [indexesOfSelected removeAllObjects];
    }
    [self updateBottomButtonsHiddenState];
}

- (void)updateBottomButtonsHiddenState
{
    buttonShare.hidden = [indexesOfSelected count] == 0;
    buttonDelete.hidden = [indexesOfSelected count] == 0;
    
    buttonCreateVideo.hidden = !buttonShare.hidden;
}

- (NSArray *)selectedFileManagerObjects
{
    NSMutableArray *selectedFileManagerObjects = [NSMutableArray new];
    for (NSNumber *index in indexesOfSelected) {
        FileManagerObject *fMO = fileManagerObjects[[index integerValue]];
        [selectedFileManagerObjects addObject:fMO];
    }
    
    return selectedFileManagerObjects;
}

- (BOOL)isIndexSelected:(NSInteger)indexToCheck
{
    for (NSNumber *index in indexesOfSelected) {
        if (indexToCheck == [index integerValue]) {
            return YES;
        }
    }
    
    return NO;
}


#pragma mark - Action Progress

- (MBProgressHUD *)progressHUD {
    if (!progressHUD) {
        progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        progressHUD.minSize = CGSizeMake(120, 120);
        progressHUD.minShowTime = 1;
        self.progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MWPhotoBrowser.bundle/images/Checkmark.png"]];
        [self.view addSubview:progressHUD];
    }
    return progressHUD;
}

- (void)showProgressHUDWithMessage:(NSString *)message {
    progressHUD.labelText = message;
    progressHUD.mode = MBProgressHUDModeIndeterminate;
    [progressHUD show:YES];
    self.navigationController.navigationBar.userInteractionEnabled = NO;
}

- (void)hideProgressHUD:(BOOL)animated {
    [progressHUD hide:animated];
    self.navigationController.navigationBar.userInteractionEnabled = YES;
}


#pragma mark - @protocol UIActionSheetDelegate <NSObject>

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        if (actionSheet.tag == StateTagPhotoroll) {
            
            [self deleteSelectedFileManagerObjects:[self selectedFileManagerObjects]];
            
            [self reloadDataByTag:StateTagPhotoroll];
            [self changeSelectionState];
        }
        else {
            FileManagerObject *fMO = fileManagerObjects[indexForDelete];
            [self deleteSelectedFileManagerObjects:@[fMO]];
            
            [self reloadDataByTag:StateTagPhotoBrowser];
        }
    }
}


#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return [fileManagerObjects count];
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    
    FileManagerObject *fMO = fileManagerObjects[index];
    
    MWPhoto *mwPhoto = [[MWPhoto alloc] initWithURL:[NSURL fileURLWithPath:fMO.pathToImage]];
    return mwPhoto;
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
    photorollPreview.selectionState = selectionState;
    photorollPreview.backgroundColor = [UIColor clearColor];
    
    UIImage *image1 = [self imageByIndex:0 + indexPath.row * 3];
    UIImage *image2 = [self imageByIndex:1 + indexPath.row * 3];
    UIImage *image3 = [self imageByIndex:2 + indexPath.row * 3];
    
    NSMutableArray *threeImages = [NSMutableArray new];
    if (image1) [threeImages addObject:image1];
    if (image2) [threeImages addObject:image2];
    if (image3) [threeImages addObject:image3];
    
    for (int i = 0; i < [threeImages count]; i++) {
        if ([self isIndexSelected:i + indexPath.row * 3]) {
            [photorollPreview selectItemAtIndex:i];
        }
        else {
            [photorollPreview deselectItemAtIndex:i];
        }
    }
    
    photorollPreview.images = threeImages;
    
    return photorollPreview;
}

- (UIImage *)imageByIndex:(NSInteger)index
{
    if (index < [fileManagerObjects count]) {
        
        FileManagerObject *fMO = (FileManagerObject *)fileManagerObjects[index];
        NSString *pathToImage = fMO.pathToImagePreview;
        UIImage *imagePreview = [UIImage imageWithContentsOfFile:pathToImage];
        return imagePreview;
    }
    return nil;
}

- (NSInteger)rowCounts
{
    return [fileManagerObjects count] / 3 + ([fileManagerObjects count] % 3 == 0 ? 0 : 1);
}


#pragma mark - @protocol UITableViewDelegate<NSObject, UIScrollViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return IS_IPHONE ? 130 : 270;
}


#pragma mark - @protocol PhotorollPreviewDelegate <NSObject>

- (void)userTapOnImageWithIndex:(NSInteger)imageIndex
{
    [self photoSelectedAtIndex:imageIndex];
}

- (void)userSelectedImageWithIndex:(NSInteger)imageIndex
{
    [indexesOfSelected addObject:@(imageIndex)];
    [self updateBottomButtonsHiddenState];
}

- (void)userDeselectedImageWithIndex:(NSInteger)imageIndex
{
    for (NSNumber *index in indexesOfSelected) {
        if ([index integerValue] == imageIndex) {
            [indexesOfSelected removeObject:index];
            break;
        }
    }
    [self updateBottomButtonsHiddenState];
}

@end
