//
//  XWGJRankTableViewCell.h
//  myOffer
//
//  Created by xuewuguojie on 16/2/29.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CatigoryRank;
@interface XWGJRankTableViewCell : UITableViewCell
@property(nonatomic,strong)CatigoryRank *rank;

+(instancetype)cellInitWithTableView:(UITableView *)tableView;

@end
