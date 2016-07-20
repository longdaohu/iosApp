//
//  HomeSearchView.h
//  myOffer
//
//  Created by xuewuguojie on 16/4/13.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^HomeSearchBlock)();
@interface HomeSearchView : UIView
@property(nonatomic,copy)HomeSearchBlock  actionBlock;
@property(nonatomic,strong)UIButton *LeftBtn;
@property(nonatomic,strong)UIButton *RightBtn;
+(instancetype)View;
-(void)searchViewWithScrollViewDidScrollContentOffsetY:(CGFloat)contentOffsetY;

@end
