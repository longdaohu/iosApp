//
//  TKPageControlView.h
//  EduClass
//
//  Created by lyy on 2018/4/20.
//  Copyright © 2018年 talkcloud. All rights reserved.
//  Tabbar 文档控制按钮

#import <UIKit/UIKit.h>
#import "TKWBControlView.h"
@interface TKDocumentControlView : UIView

@property (nonatomic, copy) void(^showCurrenPageNum)(BOOL isSelected);
@property (nonatomic, assign) NSInteger curPage; 
- (void)updateView:(NSDictionary *)message;

- (void)destoy;
@property (nonatomic, strong) TKWBControlView *wbControlView;//放大、缩小、全屏、备注按钮
@end
