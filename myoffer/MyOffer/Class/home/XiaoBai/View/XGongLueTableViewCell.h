//
//  XGongLueTableViewCell.h
//  XUObject
//
//  Created by xuewuguojie on 16/4/19.
//  Copyright © 2016年 xuewuguojie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XGongLueTableViewCell : UITableViewCell
@property(nonatomic,strong)NSDictionary *item;

+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
