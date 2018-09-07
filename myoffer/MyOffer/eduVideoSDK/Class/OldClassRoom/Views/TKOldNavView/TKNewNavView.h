//
//  TKNewNavView.h
//  EduClass
//
//  Created by talkqa on 2018/6/4.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TKDocumentControlView;

@interface TKNewNavView : UIView


@property (nonatomic, copy) void(^showCoursewareViewBlock)(BOOL isSelected);
@property (nonatomic, copy) void(^showChatViewBlock)(BOOL isSelected);
@property (nonatomic, copy) void(^showControlViewBlock)(BOOL isSelected);
@property (nonatomic, copy) void(^showMemberViewBlock)(BOOL isSelected);

@property (nonatomic, copy) void(^showCamareViewBlock)(BOOL isSelected);
@property (nonatomic, copy) void(^showPictureViewBlock)(BOOL isSelected);
@property (nonatomic, copy) void(^showToolsViewBlock)(BOOL isSelected);

@property (nonatomic, copy) void(^leaveButtonBlock)();
@property (nonatomic, copy) void(^classoverBlock)();

@property (nonatomic, copy) void(^classBeginBlock)();

@property (nonatomic, assign) BOOL showRedDot;
@property (nonatomic, strong) UIButton *picButton;//画笔
@property (nonatomic, strong) UIButton *camareButton;//相机选择

@property (nonatomic, strong) UIButton *toolsButton;//工具

@property (nonatomic, strong) UIButton *controlButton;// 控制按钮

@property (nonatomic, strong) UIButton *coursewareButton;//课件库

@property (nonatomic, strong) UIButton *memberButton;//成员列表


@property (nonatomic, strong) TKDocumentControlView *pageControlView;



- (instancetype)initWithFrame:(CGRect)frame aParamDic:(NSDictionary *)aParamDic roomType:(RoomType)roomType;

- (void)setTitle:(NSString *)title;
- (void)setTime:(NSTimeInterval)time;

- (void)refreshUI:(BOOL)add;
- (void)updateView:(NSDictionary *)message;

- (void)refreshUI;
- (void)setHandButtonState:(BOOL)isHandup;
@end
