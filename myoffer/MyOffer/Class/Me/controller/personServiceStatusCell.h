//
//  personServiceStatusCell.h
//  myOffer
//
//  Created by xuewuguojie on 2017/8/21.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ApplyStatusModelFrame.h"

@interface personServiceStatusCell : UITableViewCell

@property(nonatomic,strong)ApplyStatusModelFrame *statusFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
