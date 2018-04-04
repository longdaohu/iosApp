//
//  DiscountCell.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/4/2.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,OrderDiscountCellType){
    OrderDiscountCellTypeDefault = 0,
    OrderDiscountCellTypeNoClickButton
};

@class DiscountItem;

@interface DiscountCell : UITableViewCell
@property(nonatomic,strong)DiscountItem *item;
@property(nonatomic,assign) OrderDiscountCellType type;
@property(nonatomic,copy)void(^discountCellBlock)(NSString *);

@end
