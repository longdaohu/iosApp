//
//  GongLueListCell.h
//  myOffer
//
//  Created by xuewuguojie on 16/4/21.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GongLueListCell : UITableViewCell

@property(nonatomic,strong)NSDictionary *item;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
