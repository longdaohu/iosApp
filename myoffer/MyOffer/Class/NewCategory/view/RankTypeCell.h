//
//  RankTypeCell.h
//  MyOffer
//
//  Created by xuewuguojie on 2017/10/12.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RankTypeItemFrame.h"

@interface RankTypeCell : UITableViewCell
@property(nonatomic,strong)RankTypeItemFrame *itemFrame;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
