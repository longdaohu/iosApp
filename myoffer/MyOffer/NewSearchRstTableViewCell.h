//
//  NewSearchRstTableViewCell.h
//  myOffer
//
//  Created by xuewuguojie on 15/12/14.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewSearchRstTableViewCell : UITableViewCell
@property(nonatomic,strong)NSDictionary *itemInfo;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
