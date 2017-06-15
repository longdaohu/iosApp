//
//  OrderTableViewCell.h
//  myOffer
//
//  Created by xuewuguojie on 16/6/20.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderItemFrame;
@class OrderCell;

@protocol OrderTableViewCellDelegate <NSObject>
-(void)cellIndexPath:(NSIndexPath *)indexPath sender:(UIButton *)sender;
@end

@interface OrderCell : UITableViewCell
@property(nonatomic,strong)OrderItemFrame *orderFrame;
@property(nonatomic,weak)id <OrderTableViewCellDelegate>delegate;
@property(nonatomic,strong)NSIndexPath  *indexPath;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
