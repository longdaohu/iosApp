//
//  YaSiScheduleOnLivingCell.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/28.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YSScheduleModel;

@interface YaSiScheduleOnLivingCell : UITableViewCell
@property(nonatomic,copy)void(^actionBlock)(void);
@property(nonatomic,strong)YSScheduleModel *item;

- (void)ToplineHiden:(BOOL)hide;

@end
