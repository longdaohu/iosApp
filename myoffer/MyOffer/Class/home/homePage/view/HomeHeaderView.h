//
//  HomeHeaderView.h
//  myOffer
//
//  Created by xuewuguojie on 16/3/18.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeHeaderFrame.h"

typedef void(^HomeHeaderViewBlock)(NSInteger);
@interface HomeHeaderView : UIView
@property(nonatomic,strong)HomeHeaderFrame *headerFrame;
@property(nonatomic,copy)HomeHeaderViewBlock actionBlock;

+ (instancetype)headerViewWithFrame:(CGRect)frame actionBlock:(HomeHeaderViewBlock)actionBlock;

@end
