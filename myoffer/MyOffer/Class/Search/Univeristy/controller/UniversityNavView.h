//
//  UniversityNavView.h
//  myOffer
//
//  Created by xuewuguojie on 16/8/26.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UniversityRightView.h"
typedef void(^UniversityNavViewBlock)(UIButton *sender);
@interface UniversityNavView : UIView
@property(nonatomic,copy)UniversityNavViewBlock  actionBlock;
//收藏、分享
@property(nonatomic,strong)UniversityRightView   *rightView;
@property(nonatomic,copy)NSString *titleName;
@property(nonatomic,assign)CGFloat nav_Alpha;

- (void)navigationWithFavorite:(BOOL)favorite;
//监听scollerView滚动  学校详情
- (void)scrollViewContentoffset:(CGFloat)offsetY  andContenHeight:(CGFloat)contentHeight;
//监听scollerView滚动  攻略列表
- (void)scrollViewForGongLueViewContentoffsetY:(CGFloat)offsetY andHeight:(CGFloat)contentHeight;

@end
