//
//  UniversityNavView.h
//  myOffer
//
//  Created by xuewuguojie on 16/8/26.
//  Copyright © 2016年 UVIC. All rights reserved.
//

typedef enum{
    NavItemStyleFavorited = 0,  //喜欢
    NavItemStyleShare = 1,       //分享
    NavItemStyleBack
}NavItemStyle;

#import <UIKit/UIKit.h>
@class  UniversityRightView;
typedef void(^UniversityNavViewBlock)(UIButton *sender);
@interface UniversityNavView : UIView
@property(nonatomic,copy)UniversityNavViewBlock  actionBlock;
//title名称
@property(nonatomic,copy)NSString *titleName;
//导航栏背景  Alpha
@property(nonatomic,assign)CGFloat nav_Alpha;
 
//设置导航栏收藏UI
- (void)navigationWithFavorite:(BOOL)favorite;
//监听scollerView滚动  学校详情
- (void)scrollViewContentoffset:(CGFloat)offsetY  andContenHeight:(CGFloat)contentHeight;
//监听scollerView滚动  攻略列表
- (void)scrollViewForGongLueViewContentoffsetY:(CGFloat)offsetY andHeight:(CGFloat)contentHeight;
+ (instancetype)ViewWithBlock:(UniversityNavViewBlock)actionBlock;

@end
