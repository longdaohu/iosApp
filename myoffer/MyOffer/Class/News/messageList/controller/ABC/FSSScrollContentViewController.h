//
//  FSSScrollContentViewController.h
//  MYOFFERDEMO
//
//  Created by xuewuguojie on 2017/7/14.
//  Copyright © 2017年 xuewuguojie. All rights reserved.
//

#import "BaseViewController.h"
#import "MessageTopiccGroup.h"

@interface FSSScrollContentViewController : UIViewController

@property (nonatomic, assign) BOOL vcCanScroll;
@property (nonatomic, strong) MyOfferTableView *tableView;
@property (nonatomic, strong) MessageTopiccGroup *group;

- (void)showError:(NSString *)error;


@end
