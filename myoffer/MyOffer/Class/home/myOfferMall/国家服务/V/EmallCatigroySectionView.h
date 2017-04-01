//
//  EmallCatigroySectionView.h
//  myOffer
//
//  Created by xuewuguojie on 2017/3/28.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ECatigroyBlock)(UIButton *sender);

@interface EmallCatigroySectionView : UIView
@property(nonatomic,copy)ECatigroyBlock actionBlock;

+ (instancetype)headerViewWithFrame:(CGRect)frame actionBlock:(ECatigroyBlock)action;

@end
