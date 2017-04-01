//
//  ServiceHeaderView.h
//  myOffer
//
//  Created by xuewuguojie on 2017/3/27.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ServiceHeaderViewBlock)(NSString *countryName);
@interface ServiceHeaderView : UIView
@property(nonatomic,copy)ServiceHeaderViewBlock actionBlock;
+ (instancetype)headerViewWithFrame:(CGRect)frame ationBlock:(ServiceHeaderViewBlock)actionBlock;

@end
