//
//  BottomBackgroudView.h
//  myOffer
//
//  Created by xuewuguojie on 15/12/16.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BottomBackgroudView;
//typedef void(^BottomBackgroudViewBlock)(UIButton *);

@protocol BottomBackgroudViewDelegate  <NSObject>

-(void)BottomBackgroudView:(BottomBackgroudView *)bgView andButtonItem:(UIButton *)sender;

@end

@interface BottomBackgroudView : UIView
//@property(nonatomic,copy)BottomBackgroudViewBlock actionBlock;
@property(nonatomic,weak)id<BottomBackgroudViewDelegate> delegate;

@end
