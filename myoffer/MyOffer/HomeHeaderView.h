//
//  HomeHeaderView.h
//  myOffer
//
//  Created by xuewuguojie on 16/3/18.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HeadItembgView;
@class HomeHeaderView;
@protocol HomeHeaderViewDelegate  <NSObject>
-(void)HomeHeaderView:(HomeHeaderView *)itemView WithItemtap:(UIButton *)sender;
@end

@interface HomeHeaderView : UIView
@property(nonatomic,strong)UIView *upView;
@property(nonatomic,weak)id<HomeHeaderViewDelegate> delegate;


@end
