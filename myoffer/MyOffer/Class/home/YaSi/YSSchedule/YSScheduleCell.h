//
//  YSScheduleCell.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/28.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YSScheduleModel;

@interface YSScheduleCell : UITableViewCell
@property(nonatomic,strong)YSScheduleModel *item;
@property(nonatomic,copy)void(^actionBlock)(YSScheduleModel *item);

@end
