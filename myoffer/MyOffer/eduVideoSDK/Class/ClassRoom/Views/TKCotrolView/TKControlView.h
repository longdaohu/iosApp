//
//  TKControlView.h
//  EduClass
//
//  Created by lyy on 2018/4/28.
//  Copyright © 2018年 talkcloud. All rights reserved.
//  操作页面

#import "TKBaseView.h"

@interface TKControlView : TKBaseView

- (id)initWithFrame:(CGRect)frame controlController:(NSString *)controlController;

@property(nonatomic,copy) void(^ _Nullable resetBlock)(void);//分屏回调

- (void)refreshUI;

@end
