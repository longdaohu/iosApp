//
//  EmallCatigroyHeaderView.h
//  myOffer
//
//  Created by xuewuguojie on 2017/3/28.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface EmallCatigroyHeaderView : UIView
@property(nonatomic,assign)CGFloat upHeight;
@property(nonatomic,copy)NSString *title;

+ (instancetype)headerViewWithFrame:(CGRect)frame;

@end
