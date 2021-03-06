//
//  StatisticsViewController.h
//  HappyBox
//
//  Created by Vasilii Kasnitski on 6/3/14.
//  Copyright (c) 2014 Vasilii.Kasnitski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatisticsViewController : UIViewController<UIAlertViewDelegate>
{
    __weak IBOutlet UILabel *labelFacebookCount;
    __weak IBOutlet UILabel *labelVKCount;
    __weak IBOutlet UILabel *labelEmailCount;
    __weak IBOutlet UILabel *labelPrintCount;
    __weak IBOutlet UILabel *labelCountOfPhotos;
    
}

@property (nonatomic, assign) NSInteger countOfPhotos;

@end
