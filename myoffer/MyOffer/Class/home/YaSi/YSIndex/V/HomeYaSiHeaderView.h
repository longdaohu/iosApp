//
//  HomeYaSiHeaderView.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/27.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YaSiHomeModel;


typedef NS_ENUM(NSInteger,YSHomeHeaderActionType) {
    
    YSHomeHeaderActionTypeDefault = 0,
    YSHomeHeaderActionTypeSigned,//签到
    YSHomeHeaderActionTypeLiving,//直播
    YSHomeHeaderActionTypeClass,//教室
    YSHomeHeaderActionTypeTest,  //测评
    YSHomeHeaderActionTypeBanner, //轮播
    YSHomeHeaderActionTypeBuy, //报名
    YSHomeHeaderActionTypeValueChange //改变分类刷新页面
};

@interface HomeYaSiHeaderView : UIView
@property(nonatomic,strong)YaSiHomeModel *ysModel;
@property(nonatomic,copy)NSString *score_signed;
@property(nonatomic,copy)void(^actionBlock)(YSHomeHeaderActionType type);

//用户资料中得到U币
- (void)userScore:(NSString *)score;
- (void)userLoginChange;
- (void)removeBannerTimer;
- (void)addBannerTimer;

@end

