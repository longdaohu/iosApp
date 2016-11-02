//
//  UniverstyHeaderView.h
//  OfferDemo
//
//  Created by xuewuguojie on 16/8/19.
//  Copyright © 2016年 xuewuguojie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  UniversityNewFrame;
@class UniversityRightView;

typedef void(^UniverstyHeaderViewBlock)(UIButton *sender);
@class UniversityheaderCenterView;
@interface UniverstyHeaderView : UIView
@property(nonatomic,strong)UniversityNewFrame *itemFrame;
@property(nonatomic,copy)UniverstyHeaderViewBlock  actionBlock;

+ (instancetype)headerTableViewWithUniFrame:(UniversityNewFrame *)universityFrame;
//收藏
- (void)headerViewRightViewWithShadowFavorited:(BOOL)favorited;

@end

