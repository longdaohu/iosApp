//
//  ApplyStatusTableViewCell.h
//  myOffer
//
//  Created by xuewuguojie on 16/1/7.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ApplyStatusRecord;
@interface ApplyStatusCell : UITableViewCell
@property(nonatomic,strong)ApplyStatusRecord *record;
+(instancetype)CreateCellWithTableView:(UITableView *)tableView;
@end
