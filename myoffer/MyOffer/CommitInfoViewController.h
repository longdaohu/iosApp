//
//  CommitInfoViewController.h
//  MyOffer
//
//  Created by xuewuguojie on 15/10/14.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommitInfoViewController : BaseViewController
- (instancetype)initWithApplyInfo:(NSArray *)info selectedIDs:(NSArray *)courseIds;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;

@end
