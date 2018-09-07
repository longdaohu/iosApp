//
//  TKEduClassRoom.m
//  EduClassPad
//
//  Created by ifeng on 2017/5/10.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKEduClassRoom.h"
#import "TKNavigationController.h"
#import "TKEduNetManager.h"
#import "TKEduRoomProperty.h"
#import "TKOneToMoreRoomController.h"
#import "TKOneToOneRoomController.h"
#import "RoomController.h"
#import "TKHUD.h"
#import "TKMacro.h"
#import "TKUtil.h"
#import "TKAlertView.h"
#import "TKLoginViewController.h"

typedef NS_ENUM(NSInteger, EClassStatus) {
    EClassStatus_IDLE = 0,//
    EClassStatus_CHECKING,
    EClassStatus_CONNECTING,
    EClassStatus_Finished,
};

TKNavigationController* _iEduNavigationController = nil;
@interface TKEduClassRoom ()<TKEduSessionClassRoomDelegate>

@property (atomic) EClassStatus iStatus;
@property (nonatomic, weak ) UIViewController *iController;
@property (nonatomic, strong) TKLoginViewController *loginVC;//登录页面
@property (nonatomic, strong) TKOneToMoreRoomController *iMoreController;
@property (nonatomic, strong) TKOneToOneRoomController *iOneController;
@property (nonatomic, strong) RoomController *oldRoomController;

@property (nonatomic, weak) id<TKEduRoomDelegate> iRoomDelegate;
@property (nonatomic, strong) TKEduRoomProperty * iRoomProperty;

@property (nonatomic, strong) NSDictionary * iParam;
@property (nonatomic, assign) BOOL  isFromWeb;
@property (nonatomic, readwrite) BOOL enterClassRoomAgain;
// change openurl
@property (nonatomic, readwrite) NSString* url;//记录进入课堂或回放的链接地址
@property (nonatomic, strong) TKAlertView *errorAlert;


@end

@implementation TKEduClassRoom

+(instancetype )shareInstance{
    
    static TKEduClassRoom *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      singleton = [[TKEduClassRoom alloc] init];
                  });
    
    return singleton;
}
//加入回放
+ (int)joinPlaybackRoomWithParamDic:(NSDictionary *)paramDic
                     ViewController:(UIViewController*)controller
                           Delegate:(id<TKEduRoomDelegate>)delegate
                          isFromWeb:(BOOL)isFromWeb
{
    return [[TKEduClassRoom shareInstance] enterPlaybackClassRoomWithParamDic:paramDic ViewController:controller Delegate:delegate isFromWeb:isFromWeb];
}

- (int)enterPlaybackClassRoomWithParamDic:(NSDictionary*)paramDic
                           ViewController:(UIViewController*)controller
                                 Delegate:(id<TKEduRoomDelegate>)delegate
                                isFromWeb:(BOOL)isFromWeb {
    
    if (_iStatus != EClassStatus_IDLE)
    {
        return -1;//正在开会
    }
    
    _iController = controller;
    _iRoomDelegate = delegate;
    _iStatus = EClassStatus_CHECKING;
    _iParam = paramDic;
    _isFromWeb = isFromWeb;
    _iRoomProperty = [[TKEduRoomProperty alloc]init];
    [_iRoomProperty parseMeetingInfo:paramDic];
    _iRoomProperty.iRoomType = (RoomType)[[paramDic objectForKey:@"type"] integerValue];
    bool isConform = [TKUtil deviceisConform];
    //     isConform      = true;  // 注释掉开启低功耗模式
    if (!isConform) {
        _iRoomProperty.iMaxVideo = @(2);
    }else{
        _iRoomProperty.iMaxVideo = @(6);
    }
    
    
    if ((_iRoomProperty.sCmdUserRole ==UserType_Teacher && [_iRoomProperty.sCmdPassWord isEqualToString:@""]&&_iRoomProperty.sCmdPassWord) && !isFromWeb) {
        
        [self reportFail:TKErrorCode_CheckRoom_NeedPassword aDescript:@""];
        return -1;
        
    }
    
    //获取room.json数据
    [TKEduNetManager getRoomJsonWithPath:paramDic[@"path"] Complete:^int(id  _Nullable response) {
        
        if (response) {
            _iStatus = EClassStatus_CONNECTING;
            int ret = 0;
            TKLog(@"tlm-----checkRoom 进入房间之前的时间: %@", [TKUtil currentTimeToSeconds]);
            ret = [[response objectForKey:@"result"] intValue];
            if (ret == 0) {
                
                NSDictionary *tRoom = [response objectForKey:@"room"];
                if (tRoom) {
                    
                    _iRoomProperty.iRoomType = [tRoom objectForKey:@"roomtype"]?(RoomType)[[tRoom objectForKey:@"roomtype"]intValue]:RoomType_OneToOne;
                    _iRoomProperty.iRoomId = [tRoom objectForKey:@"serial"]?[tRoom objectForKey:@"serial"]:@"";
                    _iRoomProperty.iRoomName = [tRoom objectForKey:@"roomname"]?[tRoom objectForKey:@"roomname"]:@"";
                    _iRoomProperty.iCompanyID = [tRoom objectForKey:@"companyid"]?[tRoom objectForKey:@"companyid"]:@"";
                    int  tMaxVideo = [[tRoom objectForKey:@"maxvideo"]intValue];
                    _iRoomProperty.iMaxVideo = @(tMaxVideo);
                    
                    //                    _iRoomProperty.chairmanControl = [TKUtil optString:tRoom Key:@"chairmancontrol"];
                    
                    bool isConform = [TKUtil deviceisConform];
                    if (!isConform) {
                        _iRoomProperty.iMaxVideo = @(2);
                    }
                    
                }
                
                //roomrole
                UserType tUserRole = [response objectForKey:@"roomrole"]?(UserType)[[response objectForKey:@"roomrole"]intValue ]:UserType_Teacher;
                _iRoomProperty.iUserType = tUserRole;
                
                //padlayout
                NSString *tPadLayout = [NSString stringWithFormat:@"%@",[response objectForKey:@"padlayout"]];
                
                _iRoomProperty.iPadLayout = tPadLayout;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    _enterClassRoomAgain = NO;
                    
                    // skins
                    NSDictionary *dicSkins = [response objectForKey:@"skins"][@"ios"];

                    [self enterPlaybackRootViewControllerWithTplId:dicSkins[@"tplId"] SkinId:dicSkins[@"skinId"]];
                  
                });
            }
        }
        return 0;
    } aNetError:^int(id  _Nullable response) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [TKHUD hideForView:TKMainWindow];
            _enterClassRoomAgain = NO;
            
            UIViewController *viewController;
            if (_iRoomProperty.iRoomType != RoomType_OneToOne) {
                
                _iMoreController = [[TKOneToMoreRoomController alloc]initPlaybackWithDelegate:delegate aParamDic:paramDic aRoomName:@"roomName" aRoomProperty:_iRoomProperty];
                viewController = _iMoreController;
                
            }else{
                
                _iOneController = [[TKOneToOneRoomController alloc]initPlaybackWithDelegate:delegate aParamDic:paramDic aRoomName:@"roomName" aRoomProperty:_iRoomProperty];
                viewController = _iOneController;
            }
            
            _iEduNavigationController = [[TKNavigationController alloc] initWithRootViewController:viewController];
            [controller presentViewController:_iEduNavigationController animated:YES completion:^{
                //                [_HUD hide:YES];
            }];
            
        });
        return -1;
    }];
    
    //默认返回0
    return  0;
}

+(int)joinRoomWithParamDic:(NSDictionary*)paramDic
            ViewController:(UIViewController*)controller
                  Delegate:(id<TKEduRoomDelegate>)delegate
                 isFromWeb:(BOOL)isFromWeb
{
    return  [[TKEduClassRoom shareInstance] enterClassRoomWithParamDic:paramDic ViewController:controller Delegate:delegate isFromWeb:isFromWeb];
    
}
-(int)enterClassRoomWithParamDic:(NSDictionary*)paramDic
                  ViewController:(UIViewController*)controller
                        Delegate:(id<TKEduRoomDelegate>)delegate
                       isFromWeb:(BOOL)isFromWeb
{
    TKLog(@"tlm----- 进入房间之前的时间: %@", [TKUtil currentTimeToSeconds]);
    if (_iStatus != EClassStatus_IDLE)
    {
        return -1;//正在开会
    }
    
    _iController = controller;
    _iRoomDelegate = delegate;
    _iStatus = EClassStatus_CHECKING;
    _iParam = paramDic;
    _isFromWeb = isFromWeb;
    _iRoomProperty = [[TKEduRoomProperty alloc] init];
    [_iRoomProperty parseMeetingInfo:paramDic];
    
    
    //除了学生可以没有密码，其他身份都需要密码
    if ((_iRoomProperty.sCmdUserRole !=UserType_Student && [_iRoomProperty.sCmdPassWord isEqualToString:@""]&&_iRoomProperty.sCmdPassWord) && !isFromWeb) {
        [self reportFail:TKErrorCode_CheckRoom_NeedPassword aDescript:@""];
        return -1;
    }else{
        
        [TKHUD showAtView:TKMainWindow message:MTLocalized(@"HUD.EnteringClass") hudType:TKHUDLoadingTypeCustomAnimations];
        
    }
    
    [[TKEduSessionHandle shareInstance] configureSession:paramDic aClassRoomDelgate:self aRoomDelegate:delegate aRoomProperties:nil];
    
    //默认返回0
    return  0;
}

#pragma mark - checkroom 回调
- (void)sessionRoomManagerDidOccuredWaring:(TKRoomWarningCode)code{
    
    if (_iStatus == EClassStatus_Finished) {
        return;
    }
    
    if (code == TKRoomWarning_CheckRoom_Success) {
        // 下载发奖杯 音频
        // 自定义奖杯和声音
        NSArray *array = [[TKEduSessionHandle shareInstance].roomMgr getRoomProperty].trophy;
        
        for (NSDictionary *dic in array) {
            
            NSString *trophyIconURL = [NSString stringWithFormat:@"http://%@:%@",[TKUtil optString:_iParam Key:@"host"], [TKUtil optString:_iParam Key:@"port"]];
            [TKEduNetManager downLoadTaskToSandboxWithHost:trophyIconURL
                                                   taskDic:dic
                                                  complete:^int(id  _Nullable response) {
                                                      
                                                      
                                                      return 0;
                                                  } aNetError:^int(id  _Nullable response) {
                                                      return 0;
                                                  }];
            
        }
        
        //checkroom 成功
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // change openurl
            _enterClassRoomAgain = NO;
            
            //课堂为1vn课堂或者 允许助教上下台的需进入一对多的界面
            
            TKRoomProperty *property = [[TKRoomManager instance] getRoomProperty];
            
            [self initRootViewControllerWithRoomProperty:property];
            
            
        });
        
    }
    
   
    
}
- (void)showMessage:(NSString *)message {
    NSArray *array = [UIApplication sharedApplication].windows;
    int count = (int)array.count;
    [TKRCGlobalConfig HUDShowMessage:message addedToView:[array objectAtIndex:(count >= 2 ? (count - 2) : 0)] showTime:2];
}
-(void)sessionClassRoomDidOccuredError:(NSError *)error{
    
    if (_iStatus == EClassStatus_Finished) {
        return;
    }
    
    [self reportFail:error.code aDescript:@""];

}
- (void)initRootViewControllerWithRoomProperty:(TKRoomProperty *)property {
    
    
    _iRoomProperty.iRoomType =(RoomType) [property.roomtype intValue];
    _iRoomProperty.iRoomId = property.roomid;
    
    _iRoomProperty.iRoomName = property.roomname?property.roomname:@"";
    _iRoomProperty.iCompanyID = property.companyid? property.companyid:@"";
    int  tMaxVideo = [property.maxvideo intValue];
    _iRoomProperty.iMaxVideo = @(tMaxVideo);
    
    _iRoomProperty.chairmanControl = property.chairmancontrol;
    
    //roomrole
    UserType tUserRole = property.roomrole?(UserType)[property.roomrole intValue]:UserType_Teacher;
    
    _iRoomProperty.iUserType = tUserRole;
    
    [[TKEduSessionHandle shareInstance] configureDrawAndPageWithControl:_iRoomProperty.chairmanControl];
    
    
    bool isConform = [TKUtil deviceisConform];
    //                    isConform      = true;     // 注释掉开启低功耗模式
    if (!isConform) {
        _iRoomProperty.iMaxVideo = @(2);
    }
    //模板id
    NSString *tplId = [[TKEduSessionHandle shareInstance].roomMgr getRoomProperty].tplId;
    
    //皮肤id
    NSString *skinId = [[TKEduSessionHandle shareInstance].roomMgr getRoomProperty].skinId;
  
    
#pragma mark - 模板切换
//    tplId = TKDefaultTPL;
//    skinId = TKDefaultSkin;
    [self enterRootViewControllerWithTplId:tplId SkinId:skinId];
}
- (void)enterRootViewControllerWithTplId:(NSString *)tplId SkinId:(NSString *)skinId{
  
    
    //模板id
    if (tplId.length == 0)
        tplId = TKDefaultTPL;
    
    //皮肤id
    if (skinId.length == 0)
        skinId = TKDefaultSkin;
    
    UIViewController *viewController;
    
    if ([tplId isEqualToString:TKClassicTPL]) {//经典
        
        if([skinId isEqualToString:TKOriginSkin]) {
            [TXSakuraManager shiftSakuraWithName:TKOriginSkin type:TXSakuraTypeMainBundle];
        }
        
        if(_iRoomProperty.iRoomType != RoomType_OneToOne  || [[TKEduSessionHandle shareInstance].roomMgr getRoomConfigration].assistantCanPublish) {
            
            //只允许1vN
            _oldRoomController = [[RoomController alloc] initWithDelegate:_iRoomDelegate aParamDic:_iParam aRoomName:@"roomName" aRoomProperty:_iRoomProperty];
            viewController = _oldRoomController;
            
        }
        else {
            
            _iOneController = [[TKOneToOneRoomController alloc] initWithDelegate:_iRoomDelegate aParamDic:_iParam aRoomName:@"roomName" aRoomProperty:_iRoomProperty];
            viewController = _iOneController;
        }
        
    }
    else if([tplId isEqualToString:TKDefaultTPL]) {//默认
        
        if([skinId isEqualToString:TKDefaultSkin]) {//少儿默认
            
            [TXSakuraManager shiftSakuraWithName:TKDefaultTPL type:TXSakuraTypeMainBundle];
            
        }
        else if([skinId isEqualToString:TKBlackSkin]) { //黑色严肃
            
            [TXSakuraManager shiftSakuraWithName:TKBlackSkin type:TXSakuraTypeMainBundle];
        }
        
        if (_iRoomProperty.iRoomType != RoomType_OneToOne  || [[TKEduSessionHandle shareInstance].roomMgr getRoomConfigration].assistantCanPublish)
        {
            
            _iMoreController = [[TKOneToMoreRoomController alloc] initWithDelegate:_iRoomDelegate aParamDic:_iParam aRoomName:@"roomName" aRoomProperty:_iRoomProperty];
            viewController = _iMoreController;
            
        }else{
            
            _iOneController = [[TKOneToOneRoomController alloc] initWithDelegate:_iRoomDelegate aParamDic:_iParam aRoomName:@"roomName" aRoomProperty:_iRoomProperty];
            viewController = _iOneController;
            
        }
    }else{//都不存在（少儿默认模板）
        
        
        [TXSakuraManager shiftSakuraWithName:TKDefaultTPL type:TXSakuraTypeMainBundle];
        
        if (_iRoomProperty.iRoomType != RoomType_OneToOne  || [[TKEduSessionHandle shareInstance].roomMgr getRoomConfigration].assistantCanPublish)
        {
            
            _iMoreController = [[TKOneToMoreRoomController alloc] initWithDelegate:_iRoomDelegate aParamDic:_iParam aRoomName:@"roomName" aRoomProperty:_iRoomProperty];
            viewController = _iMoreController;
            
        }else{
            
            _iOneController = [[TKOneToOneRoomController alloc] initWithDelegate:_iRoomDelegate
                                                                       aParamDic:_iParam aRoomName:@"roomName" aRoomProperty:_iRoomProperty];
            viewController = _iOneController;
            
        }
        
    }
    
    _iEduNavigationController = [[TKNavigationController alloc] initWithRootViewController:viewController];
    
    [TKHUD hideForView:TKMainWindow];
    
    [_iController presentViewController:_iEduNavigationController animated:YES completion:^{
        
        _iStatus = EClassStatus_Finished;
    }];
}
- (void)enterPlaybackRootViewControllerWithTplId:(NSString *)tplId SkinId:(NSString *)skinId{
    
    
    //模板id
    if (tplId.length == 0)
        tplId = TKDefaultTPL;
    
    //皮肤id
    if (skinId.length == 0)
        skinId = TKDefaultSkin;
    
    UIViewController *viewController;
    
    if ([tplId isEqualToString:TKClassicTPL]) {//经典
        
        if([skinId isEqualToString:TKOriginSkin]) {
            [TXSakuraManager shiftSakuraWithName:TKOriginSkin type:TXSakuraTypeMainBundle];
        }
        
        if(_iRoomProperty.iRoomType != RoomType_OneToOne  || [[TKEduSessionHandle shareInstance].roomMgr getRoomConfigration].assistantCanPublish) {
            
            //只允许1vN
            _oldRoomController = [[RoomController alloc] initPlaybackWithDelegate:_iRoomDelegate aParamDic:_iParam aRoomName:@"roomName" aRoomProperty:_iRoomProperty];
            
            viewController = _oldRoomController;
            
        }
        else {
            
            _iOneController = [[TKOneToOneRoomController alloc] initPlaybackWithDelegate:_iRoomDelegate aParamDic:_iParam aRoomName:@"roomName" aRoomProperty:_iRoomProperty];
            viewController = _iOneController;
        }
        
    }
    else if([tplId isEqualToString:TKDefaultTPL]) {//默认
        
        if([skinId isEqualToString:TKDefaultSkin]) {//少儿默认
            
            [TXSakuraManager shiftSakuraWithName:TKDefaultTPL type:TXSakuraTypeMainBundle];
            
        }
        else if([skinId isEqualToString:TKBlackSkin]) { //黑色严肃
            
            [TXSakuraManager shiftSakuraWithName:TKBlackSkin type:TXSakuraTypeMainBundle];
        }
        
        if (_iRoomProperty.iRoomType != RoomType_OneToOne  || [[TKEduSessionHandle shareInstance].roomMgr getRoomConfigration].assistantCanPublish)
        {
            
            _iMoreController = [[TKOneToMoreRoomController alloc] initPlaybackWithDelegate:_iRoomDelegate aParamDic:_iParam aRoomName:@"roomName" aRoomProperty:_iRoomProperty];
            viewController = _iMoreController;
            
        }else{
            
            _iOneController = [[TKOneToOneRoomController alloc] initPlaybackWithDelegate:_iRoomDelegate aParamDic:_iParam aRoomName:@"roomName" aRoomProperty:_iRoomProperty];
            viewController = _iOneController;
            
        }
    }else{//都不存在（少儿默认模板）
        
        
        [TXSakuraManager shiftSakuraWithName:TKDefaultTPL type:TXSakuraTypeMainBundle];
        
        if (_iRoomProperty.iRoomType != RoomType_OneToOne  || [[TKEduSessionHandle shareInstance].roomMgr getRoomConfigration].assistantCanPublish)
        {
            
            _iMoreController = [[TKOneToMoreRoomController alloc] initPlaybackWithDelegate:_iRoomDelegate aParamDic:_iParam aRoomName:@"roomName" aRoomProperty:_iRoomProperty];
            viewController = _iMoreController;
            
        }else{
            
            _iOneController = [[TKOneToOneRoomController alloc] initPlaybackWithDelegate:_iRoomDelegate aParamDic:_iParam aRoomName:@"roomName" aRoomProperty:_iRoomProperty];
            viewController = _iOneController;
            
        }
        
    }
    
    _iEduNavigationController = [[TKNavigationController alloc] initWithRootViewController:viewController];
    
    [TKHUD hideForView:TKMainWindow];
    
    [_iController presentViewController:_iEduNavigationController animated:YES completion:^{
        
        _iStatus = EClassStatus_Finished;
    }];
}
+(UIViewController *)currentRoomViewController{
    return [TKEduClassRoom shareInstance].iMoreController ;
}
+(void)leftRoom{
    //    [[TKEduClassRoom shareInstance].iRoomController prepareForLeave:YES];
    //    [[TKEduClassRoom shareInstance].iClassRoomController prepareForLeave:YES];
}

- (void)onRoomControllerDisappear:(NSNotification*)__unused notif
{
    _iEduNavigationController = nil;
    _iMoreController = nil;
    _iOneController = nil;
    
    _iStatus = EClassStatus_IDLE;
    _iRoomDelegate = nil;
    _iController = nil;
    // change openurl
    
    //如果是因为再次进入而产生的退出，则需要重新进入
    if ( self.enterClassRoomAgain) {
        [self joinRoomFromWebUrl:self.url];
    }
}

#pragma mark 加入会议
- (void)reportFail:(TKRoomErrorCode)ret  aDescript:(NSString *)aDescript
{
    
    if(_iRoomDelegate)
    {
        bool report            = true;
        NSString *alertMessage = nil;
        switch (ret) {
            case TKErrorCode_CheckRoom_ServerOverdue: {//3001  服务器过期
                alertMessage = MTLocalized(@"Error.ServerExpired");
                //alertMessage = @"服务器过期";
            }
                break;
            case TKErrorCode_CheckRoom_RoomFreeze: {//3002  公司被冻结
                alertMessage = MTLocalized(@"Error.CompanyFreeze");
                //alertMessage = @"公司被冻结";
            }
                break;
            case TKErrorCode_CheckRoom_RoomDeleteOrOrverdue: //3003  房间被删除或过期
            case TKErrorCode_CheckRoom_RoomNonExistent: {//4007 房间不存在 房间被删除或者过期
                alertMessage = MTLocalized(@"Error.RoomDeletedOrExpired");
                // alertMessage = @"房间被删除或者过期";
            }
                break;
            case TKErrorCode_CheckRoom_RequestFailed:
                alertMessage = MTLocalized(@"Error.WaitingForNetwork");
                break;
            case TKErrorCode_CheckRoom_PasswordError: {//4008  房间密码错误
                alertMessage = MTLocalized(@"Error.PwdError");
                //                 alertMessage = @"房间密码错误";
            }
                break;
                
            case TKErrorCode_CheckRoom_WrongPasswordForRole: {//4012  密码与角色不符
                alertMessage = MTLocalized(@"Error.PwdError");
                //alertMessage = @"房间密码错误";
            }
                break;
                
            case TKErrorCode_CheckRoom_RoomNumberOverRun: {//4103  房间人数超限
                alertMessage = MTLocalized(@"Error.MemberOverRoomLimit");
                //alertMessage = @"房间人数超限";
            }
                break;
                
            case TKErrorCode_CheckRoom_NeedPassword: {//4110  该房间需要密码，请输入密码
                alertMessage = MTLocalized(@"Error.NeedPwd");
                //                 alertMessage = @"该房间需要密码，请输入密码";
            }
                break;
                
            case TKErrorCode_CheckRoom_RoomPointOverrun: {//4112  企业点数超限
                alertMessage = MTLocalized(@"Error.pointOverRun");
                //                 alertMessage = @" 企业点数超限";
            }
                break;
            case TKErrorCode_CheckRoom_RoomAuthenError: {//4109
                alertMessage = MTLocalized(@"Error.AuthIncorrect");
                //                 alertMessage = @"认证错误";
            }
                break;
                
            default:{
                report = YES;
                //alertMessage = aDescript;
                alertMessage = [NSString stringWithFormat:@"%@(%ld)",MTLocalized(@"Error.WaitingForNetwork"),(long)ret];
                
                break;
            }
                
        }
        
        
        if (ret == TKErrorCode_CheckRoom_NeedPassword || ret == TKErrorCode_CheckRoom_PasswordError ||  ret ==  TKErrorCode_CheckRoom_WrongPasswordForRole)
        {//密码弹出
            
            
            [TKHUD hideForView:TKMainWindow];
            
            if (self.errorAlert) {
                [self.errorAlert dismissAlert];
                self.errorAlert = nil;
            }
            
            
             self.errorAlert = [[TKAlertView alloc]initWithInputTitle:MTLocalized(@"Prompt.prompt") style:ret confirmTitle:MTLocalized(@"Prompt.OK")];
            
            [self.errorAlert show];
            
            NSDictionary *tDict = _iParam;
            BOOL tIsFromWeb = _isFromWeb;
            
            tk_weakify(self);
            self.errorAlert.confirmBlock = ^(NSString *password) {
                
                weakSelf.iRoomProperty.sCmdPassWord = password;
                NSMutableDictionary *tHavePasswordDic = [NSMutableDictionary dictionaryWithDictionary:tDict];
                [tHavePasswordDic setObject:password forKey:@"password"];
                [TKEduClassRoom joinRoomWithParamDic:tHavePasswordDic ViewController:weakSelf.iController Delegate:weakSelf.iRoomDelegate isFromWeb:tIsFromWeb];
                
            };
            
            
            
        }else{
            
            
            [TKHUD hideForView:TKMainWindow];
            
            if (self.errorAlert) {
                [self.errorAlert dismissAlert];
                self.errorAlert = nil;
            }
            self.errorAlert = [[TKAlertView alloc]initWithTitle:MTLocalized(@"Prompt.prompt") contentText:alertMessage confirmTitle:MTLocalized(@"Prompt.OK")];
            [self.errorAlert show];
           
            
            
        }
        if (report)
        {
            if ([_iRoomDelegate respondsToSelector:@selector(onEnterRoomFailed:Description:)]) {
                [(id<TKEduRoomDelegate>)_iRoomDelegate onEnterRoomFailed:ret Description:alertMessage];
            }
            _iStatus = EClassStatus_IDLE;
            
        }
    }
}

#pragma mark joinRoom
// change openurl
+(void)joinRoomFromWebUrl:(NSString*)url{
    [[TKEduClassRoom shareInstance]joinRoomFromWebUrl:url];
}
-(void)joinRoomFromWebUrl:(NSString*)url{
    self.url = url;
    //此时正在课堂中,需要退出
    if (self.iStatus != EClassStatus_IDLE) {
        
        self.enterClassRoomAgain = YES;
        
        NSString *skinId = [[TKEduSessionHandle shareInstance].roomMgr getRoomProperty].skinId;
        
        if (_iRoomProperty.iRoomType != RoomType_OneToOne) {
            if ([skinId isEqualToString:TKOriginSkin]) {
                
                [_oldRoomController prepareForLeave:YES];
            }else{
                
                [_iMoreController prepareForLeave:YES];
            }
        }else{
            [_iOneController prepareForLeave:YES];
        }
        
    }else{
        
        
        if (!self.loginVC) {
            self.loginVC = [[TKLoginViewController alloc]init];
            self.loginVC.modalPresentationStyle=UIModalPresentationOverCurrentContext;
            
            UIViewController *tRoomRoot = (UIViewController*) [UIApplication sharedApplication].keyWindow.rootViewController;
            [tRoomRoot presentViewController:self.loginVC animated:NO completion:^{
                
                [self.loginVC openUrl:self.url];
            }];
        }else{
            [self.loginVC openUrl:self.url];
        }
    }
}

+(void)clearWebUrlData{
    [TKEduClassRoom shareInstance].loginVC = nil;
}


#pragma mark - private
- (id)init
{
    if (self = [super init]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRoomControllerDisappear:) name:sTKRoomViewControllerDisappear object:nil];
    }
    return self;
}
@end
