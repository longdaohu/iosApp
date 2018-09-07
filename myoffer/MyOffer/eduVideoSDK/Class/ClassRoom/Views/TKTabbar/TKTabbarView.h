//
//  TKTabbarView.h
//  EduClass
//
//  Created by lyy on 2018/4/19.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKDocumentControlView.h"

@interface TKTabbarView : UIView



@property (nonatomic, copy) void(^showCoursewareViewBlock)(BOOL isSelected);
@property (nonatomic, copy) void(^showChatViewBlock)(BOOL isSelected);
@property (nonatomic, copy) void(^showControlViewBlock)(BOOL isSelected);
@property (nonatomic, copy) void(^showCamareViewBlock)(BOOL isSelected);
@property (nonatomic, copy) void(^showMemberViewBlock)(BOOL isSelected);

/** *  当前的用户 */
@property(strong,nonatomic)TKRoomUser *_Nullable iRoomUser;

@property (nonatomic, assign) BOOL showRedDot;

// 工具
@property (nonatomic, copy) void(^showToolsViewBlock)(BOOL isSelected);

@property (nonatomic, strong) UIButton *brushButton;//画笔
@property (nonatomic, strong) UIButton *camareButton;//相机选择

@property (nonatomic, strong) TKDocumentControlView *pageControlView;

@property (nonatomic, strong) UIButton *messageButton;//消息

@property (nonatomic, strong) UIButton *toolsButton;//工具

@property (nonatomic, strong) UIButton *controlButton;//控制

@property (nonatomic, strong) UIButton *coursewareButton;//课件库

@property (nonatomic, strong) UIButton *memberButton;//成员列表

- (instancetype)initWithFrame:(CGRect)frame roomType:(RoomType)roomType;

- (void)refreshUI;
- (void)updateView:(NSDictionary *)message;

/**
 隐藏所有控制按钮
 */
- (void)hideAllButton;


- (void)destoy;

@end
