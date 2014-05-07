//
//  PhotorollViewController.h
//  Photomat
//
//  Created by Vasilii Kasnitski on 12/23/13.
//  Copyright (c) 2013 OCSICO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"
#import "PhotorollPreview.h"
#import "MBProgressHUD.h"


@class PhotorollNavBar, PhotorollToolbar;
@class ChangesOneObject;


enum
{
    StateTagPhotoroll = 100,
    StateTagPhotoBrowser = 101
};
typedef NSInteger StateTag;


@interface PhotorollViewController : UIViewController<MWPhotoBrowserDelegate, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, PhotorollPreviewDelegate>
{
    __weak IBOutlet UITableView *tableViewPhotoroll;
    __weak IBOutlet UIButton *buttonBack;
    __weak IBOutlet UIButton *buttonSelect;
    __weak IBOutlet UIButton *buttonShare;
    __weak IBOutlet UIButton *buttonDelete;
    __weak IBOutlet UIButton *buttonCreateVideo;
    __weak IBOutlet UILabel *labelTitle;
    
    MWPhotoBrowser *browser;
    MBProgressHUD *progressHUD;
    
    NSArray *fileManagerObjects;
    PhotorollNavBar *photorollNavBar;
    PhotorollToolbar *photorollToolBar;
    
    NSMutableArray *indexesOfSelected;
    BOOL selectionState;
    NSInteger indexForDelete;
}

@property (nonatomic, retain) UIActivityViewController *activityViewController;

@property (nonatomic, retain) ChangesOneObject *changesOneObject;

@end
