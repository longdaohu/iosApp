//
//  OrderDetailHeaderView.h
//  myOffer
//
//  Created by xuewuguojie on 16/6/21.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderItem.h"

@interface OrderDetailHeaderView : UIView
@property(nonatomic,strong)OrderItem *order;
@property(nonatomic,assign)CGFloat headHeight;


@end
