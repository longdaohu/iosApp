//
//  OrderDetailTableViewCell.h
//  myOffer
//
//  Created by xuewuguojie on 16/6/22.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderServiceItem.h"
@interface OrderDetailCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@property(nonatomic,strong)OrderServiceItem *leftItem;
@property(nonatomic,strong)OrderServiceItem *rightItem;
@end
