//
//  SMHotCell.h
//  myOffer
//
//  Created by xuewuguojie on 2017/7/19.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMHotFrame.h"

@interface SMHotCell : UITableViewCell
@property(nonatomic,strong)SMHotFrame *hotFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
