//
//  HomeHeaderView.h
//  myOffer
//
//  Created by xuewuguojie on 16/3/18.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadItembgView.h"
@interface HomeHeaderView : UIView
@property(nonatomic,strong)UIView *upView;
+ (instancetype)headerViewWithFrame:(CGRect)frame withactionBlock:(HeadItembgViewBlock)actionBlock;

@end
