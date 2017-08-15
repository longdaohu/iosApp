//
//  ApplyStatusHistoryViewController.h
//  myOffer
//
//  Created by xuewuguojie on 2017/8/14.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApplyStatusModelFrame.h"

@interface ApplyStatusHistoryViewController : UITableViewController
@property(nonatomic,strong)ApplyStatusModelFrame *status_frame;
@property(nonatomic,strong)NSDictionary *status_history;

@end
