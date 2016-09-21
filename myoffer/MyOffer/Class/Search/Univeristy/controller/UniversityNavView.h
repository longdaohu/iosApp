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
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property(nonatomic,copy)UniversityNavViewBlock  actionBlock;
@property(nonatomic,strong)UniversityRightView   *rightView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

- (void)scrollViewContentoffset:(CGFloat)offsetY;
- (void)scrollViewForGongLueViewContentoffsetY:(CGFloat)offsetY andHeight:(CGFloat)contentHeight;

@end
