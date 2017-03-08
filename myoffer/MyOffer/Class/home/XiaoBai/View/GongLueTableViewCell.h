//
//  XGongLueTableViewCell.h
//  XUObject
//
//  Created by xuewuguojie on 16/4/19.
//  Copyright © 2016年 xuewuguojie. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GonglueItem;

@interface GongLueTableViewCell : UITableViewCell
@property(nonatomic,strong)GonglueItem *item;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
