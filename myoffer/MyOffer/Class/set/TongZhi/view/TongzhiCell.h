//
//  NotiTableViewCell.h
//  myOffer
//
//  Created by xuewuguojie on 15/12/31.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NotiItem;
@interface TongzhiCell : UITableViewCell

@property(nonatomic,strong)NotiItem *noti;

+(instancetype)cellWithTableView:(UITableView *)tableView;

- (void)separatorLineShow:(BOOL)show;

@end