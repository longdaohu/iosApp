//
//  GongLueHeaderView.h
//  myOffer
//
//  Created by xuewuguojie on 16/4/21.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GonglueItem.h"

@interface GongLueHeaderView : UIView

@property(nonatomic,strong)GonglueItem *gonglue;

@property(nonatomic,assign)CGFloat top_View_Height;


@property(nonatomic,assign)CGFloat nav_Alpha;

//传入tableView的contentOffsetY
- (void)scrollViewDidScrollWithcontentOffsetY:(CGFloat)contentOffsetY;

@end
