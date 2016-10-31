//
//  HomeFirstTableViewCell.h
//  myOffer
//
//  Created by xuewuguojie on 16/3/18.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeFirstTableViewCell : UITableViewCell
@property(nonatomic,strong)NSDictionary *itemInfo;
+(instancetype)cellInitWithTableView:(UITableView *)tableView;

@end
