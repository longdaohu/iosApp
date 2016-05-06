//
//  ApplyStatusTableViewCell.h
//  myOffer
//
//  Created by xuewuguojie on 16/1/7.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XWGJApplyRecord;
@interface XWGJApplyStatusTableViewCell : UITableViewCell
@property(nonatomic,strong)XWGJApplyRecord *record;
+(instancetype)CreateCellWithTableView:(UITableView *)tableView;
@end
