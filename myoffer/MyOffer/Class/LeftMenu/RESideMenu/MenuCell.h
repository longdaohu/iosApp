//
//  MenuCell.h
//  myOffer
//
//  Created by xuewuguojie on 16/6/28.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuItem.h"
@interface MenuCell : UITableViewCell
@property(nonatomic,strong)MenuItem *item;
+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end
