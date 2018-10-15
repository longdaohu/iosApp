//
//  orderServiceAlertView.h
//  MyOffer
//
//  Created by longdao on 2018/10/10.
//  Copyright © 2018 UVIC. All rights reserved.
//  hdr

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderServicePopView : UIView

typedef void(^OrderServiceAlertViewBlock)(UIButton *sender);
@property(nonatomic,strong)NSDictionary *orderServiceDict;
@property(nonatomic,copy)OrderServiceAlertViewBlock actionBlock;

@end

NS_ASSUME_NONNULL_END
