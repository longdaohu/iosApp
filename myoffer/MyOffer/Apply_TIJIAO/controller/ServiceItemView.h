//
//  ServiceItemView.h
//  myOffer
//
//  Created by xuewuguojie on 16/7/29.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ServiceItemViewBlock)(UIButton *sender,NSString *orderId);
@interface ServiceItemView : UIView
@property(nonatomic,strong)NSDictionary *serviceDict;       //服务名称
@property(nonatomic,copy)ServiceItemViewBlock actionBlock;
+(instancetype)View;
-(void)click;
@end
