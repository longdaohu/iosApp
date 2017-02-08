//
//  ShareNView.h
//  myOffer
//
//  Created by xuewuguojie on 2017/2/8.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^shareViewBlock)(UIButton *,BOOL);

@interface ShareNView : UIView
@property(nonatomic,copy)shareViewBlock actionBlock;
+ (instancetype)shareViewWithAction:(shareViewBlock)actionBlock;
- (void)show;

@end


