//
//  DiscountItem.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/4/2.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscountItem : NSObject
//@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *cId;//优惠券类型Id
@property(nonatomic,copy)NSString *state;//0表示已使用 1表示已使用
@property(nonatomic,copy)NSString *rules;//优惠价格
@property(nonatomic,copy)NSAttributedString *attriPrice;//优惠价格
@property(nonatomic,copy)NSString *name;//优惠券名称
@property(nonatomic,copy)NSString *statrTime;//优惠券开始时间
@property(nonatomic,copy)NSString *endTime;//优惠券过期时间
@property(nonatomic,copy)NSString *time;//优惠券时间
@property(nonatomic,copy)NSString *imageName;//图片名称
@property(nonatomic,assign)BOOL  disabled;//优惠券当前是否可用
@property(nonatomic,assign)BOOL  selected;//优惠券被选中


@end



