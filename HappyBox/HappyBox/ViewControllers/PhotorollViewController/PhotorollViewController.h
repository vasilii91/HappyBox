//
//  PhotorollViewController.h
//  Photomat
//
//  Created by Vasilii Kasnitski on 12/23/13.
//  Copyright (c) 2013 OCSICO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotorollPreview.h"


@class PhotorollNavBar, PhotorollToolbar;


@interface PhotorollViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, PhotorollPreviewDelegate>
{
    __weak IBOutlet UITableView *tableViewPhotoroll;
    __weak IBOutlet UILabel *labelTitle;
    
    PhotorollNavBar *photorollNavBar;
    PhotorollToolbar *photorollToolBar;
}

@property (nonatomic, retain) NSArray *photoURLs;

@end
