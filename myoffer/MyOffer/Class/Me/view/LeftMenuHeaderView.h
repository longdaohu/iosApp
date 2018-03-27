//
//  LeftMenuHeaderView.h
//  myOffer
//
//  Created by xuewuguojie on 2016/11/1.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LeftBlock)();
@interface LeftMenuHeaderView : UIView
//根据网络请求数据加载header
@property(nonatomic,strong)MyofferUser *user;
//判断是否有头像
@property(nonatomic,assign)BOOL haveIcon;

@property(nonatomic,strong)UIImage *iconImage;

@property(nonatomic,copy)LeftBlock actionBlock;
//用户登出后还原头像
- (void)headerViewWithUserLoginOut;

+ (instancetype)headerViewWithTap:(LeftBlock)actionBlock;

@end
