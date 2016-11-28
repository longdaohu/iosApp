//
//  OrderDetailHeaderView.h
//  myOffer
//
//  Created by xuewuguojie on 16/6/21.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderItem.h"

typedef void(^OrderDetailHeaderViewBlock)(UIButton *sender);
@interface OrderDetailHeaderView : UIView
@property(nonatomic,copy)OrderDetailHeaderViewBlock actionBlock;
@property(nonatomic,strong)OrderItem *order;
@property(nonatomic,assign)BOOL selected;
@property(nonatomic,assign)CGFloat headHeight;

- (void)headerSelectButtonHiden;

@end
