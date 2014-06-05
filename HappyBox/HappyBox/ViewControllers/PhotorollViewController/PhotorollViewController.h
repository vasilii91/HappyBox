//
//  PhotorollViewController.h
//  Photomat
//
//  Created by Vasilii Kasnitski on 12/23/13.
//  Copyright (c) 2013 OCSICO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotorollPreview.h"
#import "LDProgressView.h"

@class PhotorollNavBar, PhotorollToolbar;


@interface PhotorollViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, PhotorollPreviewDelegate, UIAlertViewDelegate>
{
    __weak IBOutlet UITableView *tableViewPhotoroll;
    __weak IBOutlet UILabel *labelTitle;
    __weak IBOutlet UIButton *buttonStatistics;
    __weak IBOutlet UIView *viewContainerForProgress;
    __weak IBOutlet UILabel *labelProgress;
    
    PhotorollNavBar *photorollNavBar;
    PhotorollToolbar *photorollToolBar;
    
    NSArray *listOfPhotos;
    
    __block NSInteger currentIndex;
    LDProgressView *progressView;
}

@property (nonatomic, retain) NSArray *photoURLs;

@end
