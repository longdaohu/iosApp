//
//  HeadItembgView.h
//  myOffer
//
//  Created by xuewuguojie on 16/3/22.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HeadItembgViewBlock)(NSInteger itemTag);
@interface HeadItembgView : UIView
@property(nonatomic,copy)HeadItembgViewBlock actionBlock;
+ (instancetype)viewWithbgBlock:(HeadItembgViewBlock)actionBlock;

@end
