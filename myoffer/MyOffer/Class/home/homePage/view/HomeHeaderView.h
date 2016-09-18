//
//  HomeHeaderView.h
//  myOffer
//
//  Created by xuewuguojie on 16/3/18.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^HomeHeaderViewBlock)(NSInteger itemTag);
@interface HomeHeaderView : UIView
@property(nonatomic,strong)UIView *upView;
@property(nonatomic,copy)HomeHeaderViewBlock actionBlock;
+ (instancetype)headerViewWithFrame:(CGRect)frame withactionBlock:(HomeHeaderViewBlock)actionBlock;

@end
