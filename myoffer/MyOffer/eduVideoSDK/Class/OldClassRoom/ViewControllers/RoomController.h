//
//  RoomController.h
//  classdemo
//
//  Created by mac on 2017/4/28.
//  Copyright © 2017年 talkcloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKBaseViewController.h"
#import "TKImagePickerController.h"

//reconnection
#import "TKTimer.h"
#import "TKProgressHUD.h"
#import "TKRCGlobalConfig.h"

#import "TKUtil.h"
#import "TKEduSessionHandle.h"
#import "TKOldVideoSmallView.h"
#import "TKSplitScreenView.h"

#import "TKMessageTableViewCell.h"


#import "TKEduRoomProperty.h"

#import "TKChatMessageModel.h"

//getGifNum
#import "TKEduNetManager.h"
#import "TKClassTimeView.h"


#import "TKBaseMediaView.h"

@class TKEduRoomProperty;


#pragma mark nav
static const CGFloat sDocumentButtonWidth = 55;
static const CGFloat sRightWidth          = 236;
static const CGFloat sClassTimeViewHeigh  = 57.5;
static const CGFloat sViewCap             = 10;
static const CGFloat sBottomViewHeigh     = 144;
static const CGFloat sTeacherVideoViewHeigh     = 182;

static const CGFloat sStudentVideoViewHeigh     = 112;
static const CGFloat sStudentVideoViewWidth     = 120;
static const CGFloat sRightViewChatBarHeight    = 50;
static const CGFloat sSendButtonWidth           = 64;

static NSString *const sMessageCellIdentifier           = @"messageCellIdentifier";
static NSString *const sStudentCellIdentifier           = @"studentCellIdentifier";
static NSString *const sDefaultCellIdentifier           = @"defaultCellIdentifier";

@interface RoomController : TKBaseViewController

@property (nonatomic, strong) NSTimer *iClassCurrentTimer;
@property (nonatomic, strong) NSTimer *iClassTimetimer;
@property (nonatomic, assign) BOOL iIsCanRaiseHandUp;//是否可以举手
//移动
@property(nonatomic,assign)CGPoint iCrtVideoViewC;
@property(nonatomic,assign)CGPoint iStrtCrtVideoViewP;


@property (nonatomic, strong) UIView *iTKEduWhiteBoardView;//白板视图

@property (nonatomic, assign) RoomType iRoomType;//当前会议室
@property (nonatomic, assign) UserType iUserType;//当前身份


@property (nonatomic, assign) NSDictionary* iParamDic;//加入会议paraDic

@property (nonatomic, strong) TKClassTimeView *iClassTimeView;

@property(nonatomic,retain)UIView   *iRightView;//左视图
@property(nonatomic,retain)UIView   *iBottomView;//视频视图

//共享桌面
@property (nonatomic, strong) TKBaseMediaView *iScreenView;
//共享电影
@property (nonatomic, strong) TKBaseMediaView *iFileView;

@property (nonatomic, strong) UIButton *iUserButton;

@property (nonatomic, strong) TKEduSessionHandle *iSessionHandle;
@property (nonatomic, strong) TKEduRoomProperty *iRoomProperty;//课堂数进行
@property (nonatomic, strong) NSMutableDictionary    *iPlayVideoViewDic;//播放的视频view的字典

//视频相关
@property (nonatomic, strong) TKOldVideoSmallView *iTeacherVideoView;//老师视频
@property (nonatomic, strong) NSMutableArray  *iStudentVideoViewArray;//存放学生视频数组
@property (nonatomic, strong) TKSplitScreenView *splitScreenView;//分屏视图
@property (nonatomic, strong) NSMutableArray  *iStudentSplitViewArray;//存放学生视频数组
@property (nonatomic, strong) NSMutableArray  *iStudentSplitScreenArray;//存放学生分屏视频数组
@property (nonatomic, strong) NSDictionary    *iScaleVideoDict;//记录缩放的视频
@property (nonatomic, assign) BOOL            addVideoBoard;
@property (nonatomic, assign) BOOL            isLocalPublish;


@property(nonatomic,retain)UIView *iMediaListView;

@property (nonatomic,assign) CGRect inputContainerFrame;

//拖动进来时的状态
@property (nonatomic, strong) NSMutableDictionary    *iMvVideoDic;
//媒体流
@property (nonatomic, strong) TKBaseMediaView  *iMediaView;
@property (nonatomic, strong) TKTimer   *iCheckPlayVideotimer;

@property (nonatomic, strong) TKImagePickerController * iPickerController;

@property (nonatomic, copy) NSString *currentServer;

@property (nonatomic, assign) BOOL isQuiting;

// 发生断线重连设置为YES，恢复后设置为NO
@property (nonatomic, assign) BOOL networkRecovered;


/**
 初始化课堂

 @param aRoomDelegate 进入房间回调
 @param aParamDic 进入课堂所需参数
 @param aRoomName roomName
 @param aRoomProperty 课堂参数
 @return self
 */
- (instancetype)initWithDelegate:(id<TKEduRoomDelegate>)aRoomDelegate
                       aParamDic:(NSDictionary *)aParamDic
                       aRoomName:(NSString *)aRoomName
                   aRoomProperty:(TKEduRoomProperty *)aRoomProperty;

/**
 初始化回放课堂
 
 @param aRoomDelegate 进入房间回调
 @param aParamDic 进入课堂所需参数
 @param aRoomName roomName
 @param aRoomProperty 课堂参数
 @return self
 */
- (instancetype)initPlaybackWithDelegate:(id<TKEduRoomDelegate>)aRoomDelegate
                               aParamDic:(NSDictionary *)aParamDic
                               aRoomName:(NSString *)aRoomName
                           aRoomProperty:(TKEduRoomProperty *)aRoomProperty;

-(void)prepareForLeave:(BOOL)aQuityourself;
@end
