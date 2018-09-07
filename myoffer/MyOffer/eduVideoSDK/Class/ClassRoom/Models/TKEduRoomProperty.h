//
//  TKEduClassRoomProperty.h
//  EduClassPad
//
//  Created by ifeng on 2017/5/11.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKMacro.h"
@interface TKEduRoomProperty : NSObject
//根据课堂返回的信息，可能重新复制
@property(nonatomic,copy) NSString * iRoomId;
@property(nonatomic,copy) NSString * iRoomName;//课堂名称
@property(nonatomic,copy) NSString * defaultServerArea;
@property(nonatomic,assign)RoomType iRoomType;//课堂类型
@property(nonatomic,copy)NSString *iPadLayout;//模板类型
@property(nonatomic,assign)UserType iUserType;//用户类型
@property(nonatomic,copy) NSString  *iUserId;//用户id
@property(nonatomic,copy) NSString  *iCompanyID;//公司id
@property(nonatomic,strong) NSNumber  *iMaxVideo;//最大视频路数


@property(nonatomic,assign) NSTimeInterval iEndTime;
@property(nonatomic,assign) NSTimeInterval iStartTime;
@property(nonatomic,assign) NSTimeInterval iCurrentTime;
@property(nonatomic,assign) NSTimeInterval iHowMuchTimeServerFasterThenMe;
//根据用户设置的信息，
@property(nonatomic,copy) NSString * sWebIp;
@property(nonatomic,copy) NSString * sWebPort;
@property(nonatomic,copy) NSString * sNickName;
@property(nonatomic,copy) NSString * sDomain;
@property(nonatomic,copy) NSString * sMeetingID;
@property(nonatomic,copy) NSString * sCmdPassWord;
@property(nonatomic,copy) NSString * sAuth;
@property(nonatomic,copy) NSString * sTS;
@property(nonatomic,copy) NSString * sLinkName;
@property(nonatomic,copy) NSString * sLinkUrl;
@property(nonatomic,copy) NSString * chairmanControl;

@property(nonatomic,assign) int  u32OtherID;
//用户自己设置的

@property(nonatomic,assign) int  sCmdUserRole;
@property(nonatomic,assign) int  sIsLiving;
@property(nonatomic,assign) bool  instFlag;
@property(nonatomic,assign) bool  bHorizontalScreen;
@property(nonatomic,assign) bool  bHideSelf;
@property(nonatomic,assign) bool  enableProximitySensor;
@property(nonatomic,assign) bool  videoType;

-(void)parseMeetingInfo:(NSDictionary*) params;
@end
