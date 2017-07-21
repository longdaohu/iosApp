//
//  SMTagCell.h
//  myOffer
//
//  Created by xuewuguojie on 2017/7/19.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMTagFrame.h"

typedef void(^SMTagCellBlock)(NSString *topic,NSString *subject_id);

@interface SMTagCell : UITableViewCell

@property(nonatomic,strong)SMTagFrame *tagFrame;

@property(nonatomic,copy)SMTagCellBlock  actionBlock;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
