//
//  TKUploadView.h
//  EduClass
//
//  Created by lyy on 2018/5/5.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKUploadView : UIView

@property (nonatomic, copy) void(^dismiss)();
//显示视图
- (void)showOnView:(UIButton *)view;
//隐藏视图
- (void)dissMissView;

@end
