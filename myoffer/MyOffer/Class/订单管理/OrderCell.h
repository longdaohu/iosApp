//
//  OrderTableViewCell.h
//  myOffer
//
//  Created by xuewuguojie on 16/6/20.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderItemFrame;

typedef NS_ENUM(NSInteger,OrderCellType){
    OrderCellTypeNomal,
    OrderCellTypeDelete,
    OrderCellTypePay
};


@interface OrderCell : UITableViewCell
@property(nonatomic,strong)OrderItemFrame *orderFrame;

@property(nonatomic,copy)void(^orderBlock)(OrderCellType);

+(instancetype)cellWithTableView:(UITableView *)tableView;


@end
