//
//  YSUserCommentView.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/31.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSUserCommentView : UIView
+ (instancetype)commentView;
@property(nonatomic,copy)void(^actionBlock)(NSArray *items);
- (void)show;

@end
