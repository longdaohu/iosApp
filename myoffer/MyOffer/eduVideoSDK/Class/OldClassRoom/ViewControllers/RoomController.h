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
static const CGFloat sRightWidth          = 236;
static const CGFloat sViewCap             = 10;
static const CGFloat sBottomViewHeigh     = 144;

static const CGFloat sStudentVideoViewHeigh     = 112;
static const CGFloat sStudentVideoViewWidth     = 120;

static NSString *const sMessageCellIdentifier           = @"messageCellIdentifier";
static NSString *const sStudentCellIdentifier           = @"studentCellIdentifier";
static NSString *const sDefaultCellIdentifier           = @"defaultCellIdentifier";

@interface RoomController : TKBaseViewController

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
