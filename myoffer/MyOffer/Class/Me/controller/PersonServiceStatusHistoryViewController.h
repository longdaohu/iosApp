//
//  PersonServiceStatusHistoryViewController.h
//  myOffer
//
//  Created by xuewuguojie on 2017/8/22.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ApplyStatusModelFrame;
@interface PersonServiceStatusHistoryViewController : UIViewController

@property(nonatomic,strong)ApplyStatusModelFrame *status_frame;


- (void)serviceHishtoryShow:(BOOL)show;

@end
