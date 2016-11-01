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
//背景图片
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property(nonatomic,copy)UniversityNavViewBlock  actionBlock;
//收藏、分享
@property(nonatomic,strong)UniversityRightView   *rightView;
//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
//监听scollerView滚动
- (void)scrollViewContentoffset:(CGFloat)offsetY;

- (void)scrollViewForGongLueViewContentoffsetY:(CGFloat)offsetY andHeight:(CGFloat)contentHeight;

@end
