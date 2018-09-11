//
//  YSUserCommentVC.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/9/11.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSUserCommentVC : UIViewController
@property(nonatomic,copy)void(^actionBlock)(NSArray *items);
- (void)show;
- (void)hide;

@end
