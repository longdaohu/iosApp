//
//  PayHeaderView.h
//  myOffer
//
//  Created by xuewuguojie on 16/6/21.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderItem;
@interface PayHeaderView : UIView
@property(nonatomic,strong)OrderItem *order;
@property(nonatomic,strong)NSDictionary *orderDict;

@end
