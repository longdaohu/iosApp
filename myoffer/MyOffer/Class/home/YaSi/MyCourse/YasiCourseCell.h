//
//  YasiCourseCell.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/28.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSCourseModel.h"

@interface YasiCourseCell : UITableViewCell

@property(nonatomic,strong) YSCourseModel *item;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UIButton *dateBtn;
@property(nonatomic,strong)UIButton *playBtn;

//@property(nonatomic,copy)void(^actionBlock)(YSCourseModel *item);

@end
