//
//  HeadItembgView.h
//  myOffer
//
//  Created by xuewuguojie on 16/3/22.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HeadItembgView;
@protocol HeadItembgViewDelegate  <NSObject>
-(void)HeadItembgView:(HeadItembgView *)itemView WithItemtap:(UIButton *)sender;
@end

@interface HeadItembgView : UIView
@property(nonatomic,weak)id<HeadItembgViewDelegate> delegate;
@end
