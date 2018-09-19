//
//  RoomController.m
//  classdemo
//
//  Created by mac on 2017/4/28.
//  Copyright © 2017年 talkcloud. All rights reserved.
//
// change openurl

#import "TKOneToOneRoomController.h"
#import "TKEduSessionHandle.h"
#import "TKImagePickerController.h"
#import <objc/message.h>

#import "TKNavView.h"
#import "TKTabbarView.h"

#import "TKListView.h" //文档、媒体、用户列表切换视图
#import "TKChatView.h" //聊天视图
#import "TKControlView.h"//控制按钮视图
#import "TKUserListView.h"//用户列表视图

//reconnection
#import "TKTimer.h"
#import "TKRCGlobalConfig.h"

#import "TKUtil.h"
#import "TKEduSessionHandle.h"
#import "TKVideoSmallView.h"

#import "TKEduRoomProperty.h"

#import "TKChatMessageModel.h"

//getGifNum
#import "TKEduNetManager.h"


#import "TKBaseMediaView.h"

#import "sys/utsname.h"

#import "TKMediaDocModel.h"
#import "TKDocmentDocModel.h"
#import "TKPlaybackMaskView.h"
#import "TKProgressSlider.h"
#import <AVFoundation/AVFoundation.h>
#pragma mark 上传图片
#import "TKUploadImageView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>

static const CGFloat sViewCap             = 10;

@interface TKOneToOneRoomController() <TKEduBoardDelegate,TKEduSessionDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate,CAAnimationDelegate,UIImagePickerControllerDelegate,TKEduNetWorkDelegate,UINavigationControllerDelegate>
{
    CGFloat _maxVideo;
    CGFloat _sStudentVideoViewHeigh;
    CGFloat _sStudentVideoViewWidth;
    
    CGRect videoOriginFrame;      // 画中画视频初始frame
    BOOL isFullPIP;               // 是否全屏同步
    TKVideoSmallView *moveView;   // 需要移动的视频
}

@property (nonatomic, assign) RoomType iRoomType;//当前会议室
@property (nonatomic, assign) UserType iUserType;//当前身份

@property (nonatomic, strong) TKEduSessionHandle *iSessionHandle;

//视频的宽高属性
@property (nonatomic, strong) NSTimer *iClassCurrentTimer;
@property (nonatomic, strong) NSTimer *iClassTimetimer;

@property (nonatomic, assign) NSInteger tabbarHeight;//tabbar高度
@property (nonatomic, assign) NSInteger navbarHeight;//navbar高度
@property (nonatomic, strong) TKNavView *navbarView;//导航
@property (nonatomic, strong) TKTabbarView *tabbarView;//tabbar
@property (nonatomic, strong) TKListView *listView;//课件库
@property (nonatomic, strong) TKUserListView *userListView;//控制按钮视图
@property (nonatomic, strong) TKChatView *chatView;//聊天视图
@property (nonatomic, strong) TKControlView *controlView;//控制按钮视图

@property (nonatomic, strong) TKWhiteBoardView *iTKEduWhiteBoardView;//白板视图

@property (nonatomic, assign) NSDictionary* iParamDic;//加入会议paraDic

@property (nonatomic, strong) TKBaseMediaView *iScreenView;//共享桌面
@property (nonatomic, strong) TKBaseMediaView *iFileView;//共享电影

@property (nonatomic, strong) TKEduRoomProperty *iRoomProperty;//课堂数进行
@property (nonatomic, strong) NSMutableDictionary    *iPlayVideoViewDic;//播放的视频view的字典


@property (nonatomic, strong) TKVideoSmallView *iTeacherVideoView;//老师视频
@property (nonatomic, strong) TKVideoSmallView *iOurVideoView;//自己的视频

@property (nonatomic, assign) BOOL            addVideoBoard;//视频标注添加标识
@property (nonatomic, assign) BOOL            isLocalPublish;

@property (nonatomic, strong) TKBaseMediaView  *iMediaView;//媒体流
@property (nonatomic, strong) TKTimer   *iCheckPlayVideotimer;

@property (nonatomic, strong) TKImagePickerController * iPickerController;

@property (nonatomic, copy) NSString *currentServer;

@property (nonatomic, assign) BOOL isQuiting;

// 发生断线重连设置为YES，恢复后设置为NO
@property (nonatomic, assign) BOOL networkRecovered;

@property (nonatomic, assign) NSTimeInterval iLocalTime;
@property (nonatomic, assign) NSTimeInterval iClassStartTime;
@property (nonatomic, assign) NSTimeInterval iServiceTime;
@property(nonatomic,copy)     NSString * iRoomName;
@property (nonatomic, strong) NSTimer *iNavHideControltimer;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, assign) NSTimeInterval iClassReadyTime;
@property (nonatomic, strong) NSTimer *iClassReadyTimetimer;
#pragma mark pad
@property(nonatomic,retain)TKDocumentListView *iUsertListView;
//白板
@property (nonatomic, assign) BOOL iShowBefore;//yes 出现过 no 没出现过
@property (nonatomic, assign) BOOL iShow;//yes 出现过 no 没出现过

//视频
@property (nonatomic, weak)  id<TKEduRoomDelegate> iRoomDelegate;


@property (nonatomic, strong) UILabel *replyText;
@property (nonatomic,assign) CGFloat knownKeyboardHeight;
@property (nonatomic,strong ) NSArray  *iMessageList;

// 回放
@property (nonatomic, strong) TKPlaybackMaskView *playbackMaskView;

#pragma mark 上传图片
@property (nonatomic, assign) float progress;
@property (nonatomic, strong) TKUploadImageView * uploadImageView;

@end


@implementation TKOneToOneRoomController

//iOS8.0以上手机横屏后会自动隐藏电池栏,需要设置一下方法不进行隐藏
-(void)setNeedsStatusBarAppearanceUpdate {
    TKLog(@"---self setNeedsStatusBarAppearanceUpdate---");
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
#pragma mark - 状态栏
//设置样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (instancetype)initWithDelegate:(id<TKEduRoomDelegate>)aRoomDelegate
                       aParamDic:(NSDictionary *)aParamDic
                       aRoomName:(NSString *)aRoomName
                   aRoomProperty:(TKEduRoomProperty *)aRoomProperty{
    if (self = [self init]) {
        _iRoomDelegate      = aRoomDelegate;
        _iRoomProperty      = aRoomProperty;
        _iRoomName          = aRoomName;
        _iParamDic          = aParamDic;
        _currentServer      = [aParamDic objectForKey:@"server"];
        _networkRecovered   = YES;
        _iSessionHandle = [TKEduSessionHandle shareInstance];
        _iSessionHandle.isPlayback = NO;
        _iSessionHandle.isSendLogMessage = YES;
        
        // 下课定时器
        _iClassTimetimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                            target:self
                                                          selector:@selector(onClassTimer)
                                                          userInfo:nil
                                                           repeats:YES];
        [_iClassTimetimer setFireDate:[NSDate distantFuture]];
        
        // 上课定时器
        _iClassReadyTimetimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                                 target:self
                                                               selector:@selector(onClassReady)
                                                               userInfo:nil
                                                                repeats:YES];
        [_iClassReadyTimetimer setFireDate:[NSDate distantFuture]];
        
        
        [_iSessionHandle setSessionDelegate:self aBoardDelegate:self aRoomProperties:aRoomProperty];
        
    }
    return self;
}

// 回放初始化接口
- (instancetype)initPlaybackWithDelegate:(id<TKEduRoomDelegate>)aRoomDelegate
                               aParamDic:(NSDictionary *)aParamDic
                               aRoomName:(NSString *)aRoomName
                           aRoomProperty:(TKEduRoomProperty *)aRoomProperty {
    if (self = [self init]) {
        _iRoomDelegate      = aRoomDelegate;
        _iRoomProperty      = aRoomProperty;
        _iRoomName          = aRoomName;
        _iParamDic          = aParamDic;
        _currentServer      = [aParamDic objectForKey:@"server"];
        _networkRecovered   = YES;
        
        _iSessionHandle = [TKEduSessionHandle shareInstance];
        _iSessionHandle.isPlayback = YES;
        
        // 下课定时器
        _iClassTimetimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                            target:self
                                                          selector:@selector(onClassTimer)
                                                          userInfo:nil
                                                           repeats:YES];
        [_iClassTimetimer setFireDate:[NSDate distantFuture]];
        
        // 上课定时器
        _iClassReadyTimetimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                                 target:self
                                                               selector:@selector(onClassReady)
                                                               userInfo:nil
                                                                repeats:YES];
        [_iClassReadyTimetimer setFireDate:[NSDate distantFuture]];
        
        
        [_iSessionHandle configurePlaybackSession:aParamDic aRoomDelegate:aRoomDelegate aSessionDelegate:self aBoardDelegate:self aRoomProperties:aRoomProperty];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _iUserType = _iRoomProperty.iUserType;
    _iShow     = false;
    _iRoomType = _iRoomProperty.iRoomType;
    
    self.backgroundImageView.contentMode =  UIViewContentModeScaleToFill;
    self.backgroundImageView.sakura.image(@"ClassRoom.backgroundImage");
    
    
    CGFloat screenWidth = [TKUtil isiPhoneX]?ScreenW-60:ScreenW;
    //课堂中的视频分辨率
    CGFloat dpi = [TKHelperUtil returnClassRoomDpi];
    [TKHelperUtil setVedioProfile];
    
    CGFloat sW =(screenWidth-sViewCap*(7+1))/7;
    CGFloat sH =sW/4.0*3.0+sW/4*3/7;
    
    self.tabbarHeight = [TKUtil isiPhoneX]?(sH) * 0.4+17:sH * 0.4;
    
    self.navbarHeight = sH * 0.4;
    
    _maxVideo = 7;
    //重新计算sBottomViewHeigh高度
    _sStudentVideoViewWidth =((screenWidth-sViewCap*(_maxVideo+1))/_maxVideo)*1.6;
    
    _sStudentVideoViewHeigh =_sStudentVideoViewWidth*dpi;
    
    [TKEduSessionHandle shareInstance].bottomHeight = self.tabbarHeight;
    
    //初始化导航栏
    [self initNavigation];
    //初始化tabbar
    [self initTabbar];
    //初始化视频视图
    [self initVideoView];
    //初始化白板
    [self initWhiteBoardView];
    
    [self initTapGesTureRecognizer];
    
    [self createTimer];
    
    [self.backgroundImageView bringSubviewToFront:_iTKEduWhiteBoardView];
    
    [[TKEduSessionHandle shareInstance]configureHUD:MTLocalized(@"HUD.EnteringClass") aIsShow:YES];
    
    [self initAudioSession];
    
    // 如果是回放，那么放上遮罩页
    if (_iSessionHandle.isPlayback == YES) {
        [self initPlaybackMaskView];
    }
    
    // 1v1 显示对方, 1vM 显示老师, 巡课显示 老师
    moveView = _iUserType == UserType_Teacher ? _iOurVideoView : _iTeacherVideoView;
    // 缓存需要移动小视频尺寸
    videoOriginFrame = moveView.frame;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    
    [self addNotification];
    if (!_iCheckPlayVideotimer) {
        [self createTimer];
    }

}
- (void)viewDidAppear:(BOOL)animated
{
    [TKEduSessionHandle shareInstance].UIDidAppear = YES;
    NSArray *array = [[TKEduSessionHandle shareInstance].cacheMsgPool copy];
    
    for (NSDictionary *dic in array) {
        
        NSString *func = [TKUtil optString:dic Key:kTKMethodNameKey];
        
        SEL funcSel = NSSelectorFromString(func);
        
        
        NSMutableArray *params = [NSMutableArray array];
        if([[dic allKeys] containsObject:kTKParameterKey])
        {
            params = dic[kTKParameterKey];
        }
        
        if ([func isEqualToString:NSStringFromSelector(@selector(sessionManagerRoomJoined))]
            ||
            [func isEqualToString:NSStringFromSelector(@selector(sessionManagerRoomLeft))]
            ||
            [func isEqualToString:NSStringFromSelector(@selector(networkTrouble))]
            ||
            [func isEqualToString:NSStringFromSelector(@selector(networkChanged))]
            ||
            [func isEqualToString:NSStringFromSelector(@selector(sessionManagerMediaLoaded))]
            ||
            [func isEqualToString: NSStringFromSelector(@selector(sessionManagerPlaybackClearAll))]
            ||
            [func isEqualToString:NSStringFromSelector(@selector(sessionManagerPlaybackEnd))]) {
            
            ((void(*)(id,SEL))objc_msgSend)(self, funcSel);
            
        }else if([func isEqualToString:NSStringFromSelector(@selector(sessionManagerDidOccuredWaring:))]){
            
            TKRoomWarningCode code = (TKRoomWarningCode)[params.firstObject intValue];
            ((void(*)(id,SEL,TKRoomWarningCode))objc_msgSend)(self, funcSel,code);
            
        }else if([func isEqualToString:NSStringFromSelector(@selector(sessionManagerSelfEvicted:))]){
            
            NSDictionary *dict = params.firstObject;
            ((void(*)(id,SEL,NSDictionary *))objc_msgSend)(self, funcSel,dict);
            
        }else if([func isEqualToString:NSStringFromSelector(@selector(sessionManagerPublishStateWithUserID:publishState:))]){
            
            NSString *str = params.firstObject;
            TKPublishState state =(TKPublishState)[params.lastObject intValue];
            ((void(*)(id,SEL,NSString *,TKPublishState))objc_msgSend)(self, funcSel , str,state);
            
        }else if([func isEqualToString:NSStringFromSelector(@selector(sessionManagerUserJoined:InList:))]){
            
            NSString *str = params.firstObject;
            BOOL inList =[params.lastObject boolValue];
            ((void(*)(id,SEL,NSString *,TKPublishState))objc_msgSend)(self, funcSel , str,inList);
            
        }else if ([func isEqualToString:NSStringFromSelector(@selector(sessionManagerUserLeft:))]){
            
            NSString *str = params.firstObject;
            ((void(*)(id,SEL,NSString *))objc_msgSend)(self, funcSel,str);
            
        }else if ([func isEqualToString:NSStringFromSelector(@selector(sessionManagerUserChanged:Properties:fromId:))]){
            
            NSString * peerID=params[0];
            NSDictionary * properties=params[1];
            NSString * fromId= params[2];
            
            ((void(*)(id,SEL,NSString *,NSDictionary *,NSString *))objc_msgSend)(self, funcSel,peerID,properties,fromId);
            
        }else if([func isEqualToString:NSStringFromSelector(@selector(sessionManagerMessageReceived:fromID:extension:))]){
            NSString * message=params[0];
            NSString * peerID=params[1];
            NSDictionary * fromId= params[2];
            
            ((void(*)(id,SEL,NSString *,NSString *,NSDictionary *))objc_msgSend)(self, funcSel,message,peerID,fromId);
            
        }else if([func isEqualToString:NSStringFromSelector(@selector(sessionManagerRoomManagerPlaybackMessageReceived:fromID:ts:extension:))]){
            
            NSString * message=params[0];
            TKRoomUser * user=params[1];
            NSTimeInterval  ts= [params[2] doubleValue];
            NSDictionary *dict = params[3];
            ((void(*)(id,SEL,NSString *,TKRoomUser *,NSTimeInterval,NSDictionary *))objc_msgSend)(self, funcSel,message,user,ts,dict);
            
        }else if([func isEqualToString:NSStringFromSelector(@selector(sessionManagerDidFailWithError:))]){
            
            NSError * error = params[0];
            
            ((void(*)(id,SEL,NSError *))objc_msgSend)(self, funcSel,error);
            
        }else if([func isEqualToString:NSStringFromSelector(@selector(sessionManagerOnRemoteMsg:ID:Name:TS:Data:InList:))]){
            BOOL add = [params[0] boolValue];
            NSString*msgID = params[1];
            NSString*msgName = params[2];
            unsigned long ts = [params[3] unsignedIntValue];
            NSObject*data = params[4];
            BOOL inlist = [params[5] boolValue];
            
            ((void(*)(id,SEL,BOOL,NSString *,NSString *,unsigned long,NSObject *,BOOL))objc_msgSend)(self, funcSel,add,msgID,msgName,ts,data,inlist);
        }else if([func isEqualToString:NSStringFromSelector(@selector(sessionManagerGetGiftNumber:))]){
            dispatch_block_t completion = params[0];
            
            ((void(*)(id,SEL,dispatch_block_t))objc_msgSend)(self, funcSel,completion);
        }else if([func isEqualToString:NSStringFromSelector(@selector(sessionManagerOnShareMediaState:state:extensionMessage:))]){
            NSString *peerId = params[0];
            TKMediaState state = (TKMediaState)[params[1] intValue];
            NSDictionary *message = params[2];
            ((void(*)(id,SEL,NSString *,TKMediaState,NSDictionary*))objc_msgSend)(self, funcSel,peerId,state,message);
        }else if([func isEqualToString:NSStringFromSelector(@selector(sessionManagerUpdateMediaStream:pos:isPlay:))]){
            NSTimeInterval duration =[params[0] doubleValue];
            NSTimeInterval pos = [params[1] doubleValue];
            BOOL isPlay = [params[2] boolValue];
            
            ((void(*)(id,SEL,NSTimeInterval,NSTimeInterval,BOOL))objc_msgSend)(self, funcSel,duration,pos,isPlay);
        }else if([func isEqualToString:NSStringFromSelector(@selector(roomManagerOnShareScreenState:state:extensionMessage:))]
                 ||
                 [func isEqualToString:NSStringFromSelector(@selector(sessionManagerOnShareFileState:state:extensionMessage:))]){
            
            NSString *peerId = params[0];
            TKMediaState state = (TKMediaState)[params[1] intValue];
            NSDictionary *message = params[3];
            
            
            ((void(*)(id,SEL,NSString *,TKMediaState,NSDictionary *))objc_msgSend)(self, funcSel,peerId,state,message);
        }else if ([func isEqualToString: NSStringFromSelector(@selector(sessionManagerReceivePlaybackDuration:))]
                  ||
                  [func isEqualToString:NSStringFromSelector(@selector(sessionManagerPlaybackUpdateTime:))]){
            NSTimeInterval duration = [params[0] doubleValue];
            
            ((void(*)(id,SEL,NSTimeInterval))objc_msgSend)(self, funcSel,duration);
        }
    }
    
    [TKEduSessionHandle shareInstance].cacheMsgPool = nil;
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    if (!_iPickerController) {
        [self invalidateTimer];
    }
    
    [self removeNotificaton];
    
}

-(void)addNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(whiteBoardFullScreen:) name:sChangeWebPageFullScreen object:nil];
    /** 1.先设置为外放 */
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    //    });
    /** 2.判断当前的输出源 */
    // [self routeChange:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(routeChange:)
                                                name:AVAudioSessionRouteChangeNotification
                                              object:[AVAudioSession sharedInstance]];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tapTable:)
                                                name:sTapTableNotification
                                              object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleAudioSessionInterruption:)
                                                 name:AVAudioSessionInterruptionNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMediaServicesReset:)
                                                 name:AVAudioSessionMediaServicesWereResetNotification object:nil];
    [[UIApplication sharedApplication] addObserver:self forKeyPath:@"idleTimerDisabled" options:NSKeyValueObservingOptionNew context:nil];
    
    //拍摄照片、选择照片上传
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadPhotos:)
                                                 name:sTakePhotosUploadNotification
                                               object:sTakePhotosUploadNotification];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadPhotos:)
                                                 name:sChoosePhotosUploadNotification
                                               object:sChoosePhotosUploadNotification];
}
-(void)removeNotificaton{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[UIApplication sharedApplication]removeObserver:self forKeyPath:@"idleTimerDisabled"];
    
}

#pragma mark - fullScreen 白板全屏
-(void)whiteBoardFullScreen:(NSNotification*)aNotification{
    
    
    bool isFull = [aNotification.object boolValue];
    
    [TKEduSessionHandle shareInstance].iIsFullState = isFull;
    
    if (isFull) {
        self.iOurVideoView.hidden = YES;
        self.iTeacherVideoView.hidden = YES;
        CGRect tFrame = CGRectMake([TKUtil isiPhoneX] ? 30:0, 0,[TKUtil isiPhoneX] ?ScreenW-60:ScreenW, ScreenH - CGRectGetMaxY(_navbarView.frame));
        
        self.iTKEduWhiteBoardView.frame = tFrame;
        [self.backgroundImageView bringSubviewToFront:self.iTKEduWhiteBoardView];
        [self.iSessionHandle.whiteBoardManager refreshWhiteBoard];
        
        
    }else{
        self.iOurVideoView.hidden = NO;
        self.iTeacherVideoView.hidden = NO;
        [self.backgroundImageView sendSubviewToBack:self.iTKEduWhiteBoardView];
        [self refreshUI];
    }
    
    
}

#pragma mark Pad 初始化

-(void)initAudioSession{
    
    AVAudioSession* session = [AVAudioSession sharedInstance];
    //    NSError* error;
    //    [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionMixWithOthers | AVAudioSessionCategoryOptionAllowBluetooth  error:&error];
    //    [session setMode:AVAudioSessionModeVoiceChat error:nil];
    //    [session setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    //    [session overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:&error];
    AVAudioSessionRouteDescription*route = [[AVAudioSession sharedInstance]currentRoute];
    for (AVAudioSessionPortDescription * desc in [route outputs]) {
        
        if ([[desc portType]isEqualToString:AVAudioSessionPortBuiltInReceiver]) {
            [TKEduSessionHandle shareInstance].isHeadphones = NO;
            [TKEduSessionHandle shareInstance].iVolume = 1;
            //            [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error];
        }else{
            [TKEduSessionHandle shareInstance].isHeadphones = YES;
            [TKEduSessionHandle shareInstance].iVolume = 0.5;
        }
        
        
    }
    
}
-(void)initNavigation
{
    self.navigationController.navigationBar.hidden = YES;
    
    self.navbarView = [[TKNavView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, self.navbarHeight) aParamDic:_iParamDic];
    [self.backgroundImageView addSubview:self.navbarView];
    __weak TKOneToOneRoomController * roomVC = self;
    
    self.navbarView.leaveButtonBlock = ^{//离开课堂 （返回)
        
        [roomVC leftButtonPress];
        
    };
    self.navbarView.classBeginBlock = ^{
        [roomVC hiddenNavAlertView];
    };
    self.navbarView.classoverBlock = ^{//下课
        TKLog(@"下课");
        [roomVC hiddenNavAlertView];
        [[TKEduSessionHandle shareInstance]configureHUD:@"" aIsShow:YES];
        [roomVC.iClassTimetimer invalidate];      // 下课后计时器销毁
        
        // 下课关闭MP3和MP4
        if ([TKEduSessionHandle shareInstance].isPlayMedia == YES) {
            [TKEduSessionHandle shareInstance].isPlayMedia          = NO;
            [[TKEduSessionHandle shareInstance]sessionHandleUnpublishMedia:nil];
        }
        
        if(![[TKEduSessionHandle shareInstance].roomMgr getRoomConfigration].forbidLeaveClassFlag){
            
            // 下课清理聊天日志
            [[TKEduSessionHandle shareInstance] clearMessageList];
            
            // 下课文档复位
            [[TKEduSessionHandle shareInstance] fileListResetToDefault];
            // 下课后showpage
            //            [[TKEduSessionHandle shareInstance] docmentDefault:[[TKEduSessionHandle shareInstance] getClassOverDocument]];
            
            [[TKEduSessionHandle shareInstance].whiteBoardManager changeDocumentWithFileID:[[TKEduSessionHandle shareInstance] getClassOverDocument].fileid isBeginClass:roomVC.iSessionHandle.isClassBegin isPubMsg:YES];
        }
        
        [TKEduNetManager classBeginEnd:[TKEduSessionHandle shareInstance].iRoomProperties.iRoomId companyid:[TKEduSessionHandle shareInstance].iRoomProperties.iCompanyID aHost:[TKEduSessionHandle shareInstance].iRoomProperties.sWebIp aPort:[TKEduSessionHandle shareInstance].iRoomProperties.sWebPort aComplete:^int(id  _Nullable response) {
            
            [[TKEduSessionHandle shareInstance] sessionHandleDelMsg:sClassBegin ID:sClassBegin To:sTellAll Data:@{} completion:nil];
            
            
            [[TKEduSessionHandle shareInstance]configureHUD:@"" aIsShow:NO];
            
            return 0;
        }aNetError:^int(id  _Nullable response) {
            
            [[TKEduSessionHandle shareInstance]configureHUD:@"" aIsShow:NO];
            
            return 0;
        }];
    };
    
}
- (void)hiddenNavAlertView{
    if (self.listView) {
        [self.listView hidden];
        self.tabbarView.coursewareButton.selected = NO;
        self.listView = nil;
    }
    
    if (self.userListView) {
        [self.userListView hidden];
        self.tabbarView.memberButton.selected = NO;
        self.userListView = nil;
    }
    
    if (self.controlView) {
        [self.controlView hidden];
        self.tabbarView.controlButton.selected = NO;
        self.controlView = nil;
    }
    
    // 隐藏工具箱
    [[TKEduSessionHandle shareInstance].whiteBoardManager showToolbox:NO];
    self.tabbarView.toolsButton.selected = NO;
}

- (void)initTabbar{
    
    self.tabbarView = [[TKTabbarView alloc]initWithFrame:CGRectMake([TKUtil isiPhoneX]?30:0, ScreenH-self.tabbarHeight, [TKUtil isiPhoneX]?ScreenW-60:ScreenW, self.tabbarHeight) roomType:_iRoomType];
    [self.view addSubview:self.tabbarView];
    if ([_iParamDic[@"playback"] boolValue]) {
        self.tabbarView.hidden = YES;
    }else{
        self.tabbarView.hidden = NO;
    }
    __weak TKOneToOneRoomController * roomVC = self;
    
    self.tabbarView.showCoursewareViewBlock = ^(BOOL isSelected) {//课件库按钮
        
        if (isSelected) {
            
            if (!roomVC.listView) {
                
                if (roomVC.controlView) {
                    [roomVC.controlView hidden];
                    roomVC.tabbarView.controlButton.selected = NO;
                    roomVC.controlView = nil;
                }
                
                if (roomVC.chatView) {
                    [roomVC.chatView hidden];
                    roomVC.tabbarView.messageButton.selected = NO;
                    roomVC.chatView = nil;
                }
                
                if (roomVC.userListView) {
                    [roomVC.userListView hidden];
                    roomVC.tabbarView.memberButton.selected = NO;
                    roomVC.userListView = nil;
                }
                
                //文件列表：            宽 7/10  高 9/10
                CGFloat showHeight = roomVC.iTKEduWhiteBoardView.height*(8/10.0);
                CGFloat showWidth = roomVC.iTKEduWhiteBoardView.width * (8/10.0);
                CGFloat x = (roomVC.iTKEduWhiteBoardView.width-showWidth)/2.0;
                CGFloat y = (roomVC.iTKEduWhiteBoardView.height-showHeight)/2.0;
                
                
                roomVC.listView = [[TKListView alloc]initWithFrame:CGRectMake(x,y, showWidth, showHeight) andTitle:@"dd" from:@"TKOneToOneRoomController"];
                
                roomVC.listView.dismissBlock = ^{
                    roomVC.tabbarView.coursewareButton.selected = NO;
                    roomVC.listView = nil;
                };
                
                [roomVC.listView show:roomVC.iTKEduWhiteBoardView];
            }
        }else{
            if (roomVC.listView) {
                [roomVC.listView hidden];
                roomVC.listView = nil;
            }
        }
        
        
    };
    
    
    self.tabbarView.showMemberViewBlock = ^(BOOL isSelected) {//成员
        if (isSelected) {
            if (!roomVC.userListView) {
                
                if (roomVC.listView) {
                    [roomVC.listView hidden];
                    roomVC.tabbarView.coursewareButton.selected = NO;
                    roomVC.listView = nil;
                }
                
                if (roomVC.chatView) {
                    [roomVC.chatView hidden];
                    roomVC.tabbarView.messageButton.selected = NO;
                    roomVC.chatView = nil;
                }
                
                if (roomVC.controlView) {
                    [roomVC.controlView hidden];
                    roomVC.tabbarView.controlButton.selected = NO;
                    roomVC.controlView = nil;
                }
                
                // 隐藏工具箱
                [[TKEduSessionHandle shareInstance].whiteBoardManager showToolbox:NO];
                roomVC.tabbarView.toolsButton.selected = NO;
                
                //花名册：宽 8/10  高 8/10
                CGFloat showHeight = roomVC.iTKEduWhiteBoardView.height*(8/10.0);
                CGFloat showWidth = roomVC.iTKEduWhiteBoardView.width * (8/10.0);
                CGFloat x = (roomVC.iTKEduWhiteBoardView.width-showWidth)/2.0;
                CGFloat y = (roomVC.iTKEduWhiteBoardView.height-showHeight)/2.0;
                
                roomVC.userListView = [[TKUserListView alloc]initWithFrame:CGRectMake(x,y,showWidth,showHeight) userList:@"TKOneToMoreRoomController"];
                
                roomVC.userListView.dismissBlock = ^{
                    roomVC.tabbarView.memberButton.selected = NO;
                    roomVC.userListView = nil;
                };
                
                [roomVC.userListView show:roomVC.iTKEduWhiteBoardView];
                
            }
            
        }else{
            if (roomVC.userListView) {
                [roomVC.userListView hidden];
                roomVC.userListView = nil;
            }
        }
    };
    
    
    
    self.tabbarView.showChatViewBlock = ^(BOOL isSelected) {//聊天视图
        if (isSelected) {
            if (!roomVC.chatView) {
                if (roomVC.listView) {
                    [roomVC.listView hidden];
                    roomVC.tabbarView.coursewareButton.selected = NO;
                    roomVC.listView = nil;
                }
                
                if (roomVC.controlView) {
                    [roomVC.controlView hidden];
                    roomVC.tabbarView.controlButton.selected = NO;
                    roomVC.controlView = nil;
                }
                
                if (roomVC.userListView) {
                    [roomVC.userListView hidden];
                    roomVC.tabbarView.memberButton.selected = NO;
                    roomVC.userListView = nil;
                }
                
                //聊天弹框：           宽 8/10  高 10/10
                CGFloat showHeight = roomVC.iTKEduWhiteBoardView.height * (8/10.0);
                CGFloat showWidth = roomVC.iTKEduWhiteBoardView.width * (8/10.0);
                CGFloat x = (roomVC.iTKEduWhiteBoardView.width-showWidth)/2.0;
                CGFloat y = (roomVC.iTKEduWhiteBoardView.height- showHeight)/2.0;
                
                
                roomVC.chatView = [[TKChatView alloc]initWithFrame:CGRectMake(x,y,showWidth,showHeight)
                                                    chatController:@"TKOneToOneRoomController"];
                roomVC.chatView.dismissBlock = ^{
                    
                    roomVC.tabbarView.messageButton.selected = NO;
                    roomVC.chatView = nil;
                };
                //                [roomVC.chatView show];
                roomVC.chatView.titleText = MTLocalized(@"Label.messageBoard");
                [roomVC.chatView show:roomVC.iTKEduWhiteBoardView];
                if ([TKEduSessionHandle shareInstance].unReadMessagesArray.count>0) {
                    
                    [[TKEduSessionHandle shareInstance].unReadMessagesArray removeAllObjects];
                }
                [roomVC.tabbarView refreshUI];
                
            }
        }else{
            if (roomVC.chatView) {
                [roomVC.chatView hidden];
                roomVC.chatView = nil;
            }
        }
    };
    
    
    self.tabbarView.showControlViewBlock = ^(BOOL isSelected) {//控制视图
        if (isSelected) {
            
            if (!roomVC.controlView) {
                
                if (roomVC.listView) {
                    [roomVC.listView hidden];
                    roomVC.tabbarView.coursewareButton.selected = NO;
                    roomVC.listView = nil;
                }
                
                if (roomVC.chatView) {
                    [roomVC.chatView hidden];
                    roomVC.tabbarView.messageButton.selected = NO;
                    roomVC.chatView = nil;
                }
                
                if (roomVC.userListView) {
                    [roomVC.userListView hidden];
                    roomVC.tabbarView.memberButton.selected = NO;
                    roomVC.userListView = nil;
                }
                
                //所有操作弹框：宽 5/10  高 8/10
                CGFloat showHeight = roomVC.iTKEduWhiteBoardView.height*(9/10.0);
                CGFloat showWidth = roomVC.iTKEduWhiteBoardView.width * (7/10.0);
                CGFloat x = (roomVC.iTKEduWhiteBoardView.width-showWidth)/2.0;
                CGFloat y = (roomVC.iTKEduWhiteBoardView.height-showHeight)/2.0;
                
                roomVC.controlView = [[TKControlView alloc]initWithFrame:CGRectMake(x,y,showWidth,showHeight)
                                                       controlController:@"TKOneToOneRoomController"];
                roomVC.controlView.dismissBlock = ^{
                    roomVC.tabbarView.controlButton.selected = NO;
                    roomVC.controlView = nil;
                };
                [roomVC.controlView show:roomVC.iTKEduWhiteBoardView];
            }
            
        }else{
            if (roomVC.controlView) {
                [roomVC.controlView hidden];
                roomVC.controlView = nil;
            }
        }
    };
    
    
    
    // 工具
    self.tabbarView.showToolsViewBlock = ^(BOOL isSelected) {
        
        if (roomVC.listView) {
            [roomVC.listView hidden];
            roomVC.tabbarView.coursewareButton.selected = NO;
            roomVC.listView = nil;
        }
        
        if (roomVC.chatView) {
            [roomVC.chatView hidden];
            roomVC.tabbarView.messageButton.selected = NO;
            roomVC.chatView = nil;
        }
        
        
        if (roomVC.controlView) {
            [roomVC.controlView hidden];
            roomVC.tabbarView.controlButton.selected = NO;
            roomVC.controlView = nil;
        }
        
        if (roomVC.userListView) {
            [roomVC.userListView hidden];
            roomVC.tabbarView.memberButton.selected = NO;
            roomVC.userListView = nil;
        }
        
        
    };
    
    
    
}


-(void)refreshUI{
    
    if (self.iPickerController) {
        return;
    }
    
    
    [self refreshWhiteBoard:YES];
    
    
}

-(void)initVideoView{
    
    
    CGFloat tVideoX = ScreenW - _sStudentVideoViewWidth-10;
    CGFloat tVideoY = CGRectGetMaxY(_navbarView.frame)+10;
    
    //老师
    {
        
        {
            self.iTeacherVideoView= ({
                
                TKVideoSmallView *tTeacherVideoView = [[TKVideoSmallView alloc]initWithFrame:CGRectMake(tVideoX, tVideoY, _sStudentVideoViewWidth, _sStudentVideoViewHeigh) aVideoRole:EVideoRoleTeacher];
                tTeacherVideoView.iPeerId = @"";
                tTeacherVideoView.isDrag = NO;
                tTeacherVideoView.isSplit = NO;
                tTeacherVideoView.iVideoViewTag = -1;
                tTeacherVideoView.isNeedFunctionButton = (self.iUserType==UserType_Teacher);
                tTeacherVideoView.iEduClassRoomSessionHandle = self.iSessionHandle;
                tTeacherVideoView;
                
                
            });
           
        }
        
    }
    
    [self.view addSubview:self.iTeacherVideoView];
    //学生
    {
        
        self.iOurVideoView= ({
            
            TKVideoSmallView *tOurVideoView = [[TKVideoSmallView alloc]initWithFrame:CGRectMake(tVideoX,CGRectGetMaxY(self.iTeacherVideoView.frame)+10, _sStudentVideoViewWidth, _sStudentVideoViewHeigh) aVideoRole:EVideoRoleOur];
            tOurVideoView.iPeerId = @"";
            tOurVideoView.iEduClassRoomSessionHandle = self.iSessionHandle;
            tOurVideoView.iVideoViewTag = -2;
            tOurVideoView.isNeedFunctionButton = (self.iUserType==UserType_Teacher);
            tOurVideoView;
            
        });
        [self.view addSubview:self.iOurVideoView];
    }
    

}

-(void)initWhiteBoardView{
    
    CGFloat x = [TKUtil isiPhoneX]?30:0;
    CGFloat width = [TKUtil isiPhoneX]?ScreenW - _sStudentVideoViewWidth -80:ScreenW - _sStudentVideoViewWidth -20;
    
    CGRect tFrame = CGRectMake(x, CGRectGetMaxY(_navbarView.frame),width, CGRectGetMinY(self.tabbarView.frame) - CGRectGetMaxY(_navbarView.frame) );
    
    
    _iTKEduWhiteBoardView = [_iSessionHandle.whiteBoardManager createWhiteBoardWithFrame:tFrame loadComponentName:TKWBMainContentComponent  loadFinishedBlock:^{
        {
            [[TKEduSessionHandle shareInstance].whiteBoardManager sendCacheInformation:[TKEduSessionHandle shareInstance].msgList];
            
        }
        
    }];
    _iTKEduWhiteBoardView.backgroundColor = [UIColor blackColor];
    [TKEduSessionHandle shareInstance].whiteboardView = _iTKEduWhiteBoardView;
    
    [self.backgroundImageView addSubview:_iTKEduWhiteBoardView];
    
    
    [self refreshWhiteBoard:NO];
    
}


-(void)refreshWhiteBoard:(BOOL)hasAnimate{
    
    
    CGFloat x = [TKUtil isiPhoneX]?30:0;
    CGFloat w = [TKUtil isiPhoneX]?ScreenW-60:ScreenW;
    
    CGRect tFrame = CGRectMake(x, CGRectGetMaxY(_navbarView.frame),w - _sStudentVideoViewWidth -20, CGRectGetMinY(self.tabbarView.frame) - CGRectGetMaxY(_navbarView.frame) );
    
    // 去掉了判断1对1
    [self.backgroundImageView bringSubviewToFront:self.iTKEduWhiteBoardView];
    
    
    
    if (hasAnimate) {
        [UIView animateWithDuration:0.1 animations:^{
            self.iTKEduWhiteBoardView.frame = tFrame;
            
            // MP3图标位置变化,但是MP4的位置不需要变化
            if (!self.iMediaView.hasVideo) {
                self.iMediaView.frame = CGRectMake(0, CGRectGetMaxY(self.iTKEduWhiteBoardView.frame)-57, CGRectGetWidth(self.iTKEduWhiteBoardView.frame), 57);
            }
            [[TKEduSessionHandle shareInstance].whiteBoardManager refreshWhiteBoard];
            
            
            
        }];
    }else{
        
        self.iTKEduWhiteBoardView.frame = tFrame;
        
        
        [[TKEduSessionHandle shareInstance].whiteBoardManager refreshWhiteBoard];
        
        
    }
}
- (void)initPlaybackMaskView {
    
    //    self.playbackMaskView = [[TKPlaybackMaskView alloc] initWithFrame:CGRectMake(0, ScreenH-self.tabbarHeight, ScreenW, self.tabbarHeight)];
    
    self.playbackMaskView = [[TKPlaybackMaskView alloc] initWithFrame:CGRectMake(0, self.navbarHeight, ScreenW, ScreenH- self.navbarHeight)];
    
    [self.view addSubview:self.playbackMaskView];
    //    UITapGestureRecognizer* tapMaskViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPlaybackMaskTool:)];
    //    tapMaskViewGesture.delegate = self;
    //    [self.playbackMaskView addGestureRecognizer:tapMaskViewGesture];
}

//- (void)showPlaybackMaskTool:(UIGestureRecognizer *)gesture {
//    
//    [self.playbackMaskView showTool];
//}
- (void)createTimer {
    
    if (!_iCheckPlayVideotimer) {
        __weak typeof(self)weekSelf = self;
        _iCheckPlayVideotimer = [[TKTimer alloc]initWithTimeout:0.5 repeat:YES completion:^{
            __strong typeof(self)strongSelf = weekSelf;
            
            [strongSelf checkPlayVideo];
            
            
        } queue:dispatch_get_main_queue()];
        
        [_iCheckPlayVideotimer start];
        
        
    }
    
}
- (void)invalidateTimer {
    if (_iCheckPlayVideotimer) {
        [_iCheckPlayVideotimer invalidate];
        _iCheckPlayVideotimer = nil;
    }
    [self invalidateClassReadyTime];
    [self invalidateClassBeginTime];
    [self invalidateClassCurrentTime];
}

#pragma mark play video
-(void)checkPlayVideo{
    
    /*
     usr->_properties:
     candraw = 0;
     hasaudio = 1;
     hasvideo = 1;
     nickname = test;
     publishstate = 3;
     role = 0;
     */
    
    BOOL tHaveRaiseHand = NO;
    BOOL tIsMuteAudioState = YES;
    for (TKRoomUser *usr in [_iSessionHandle userStdntAndTchrArray]) {
        BOOL tBool = [[usr.properties objectForKey:@"raisehand"]boolValue];
        if (tBool && !tHaveRaiseHand) {
            tHaveRaiseHand = YES;
        }
        if ((usr.publishState == PublishState_AUDIOONLY || usr.publishState == PublishState_BOTH) &&usr.role != UserType_Teacher && tIsMuteAudioState) {
            
            tIsMuteAudioState = NO;
        }
        
    }
    
    if (_iUserType == UserType_Teacher) {
        
        if (tIsMuteAudioState) {
            [TKEduSessionHandle shareInstance].isMuteAudio = YES;
            
            
            [TKEduSessionHandle shareInstance].isunMuteAudio = NO;
            
            
            
        }else{
            [TKEduSessionHandle shareInstance].isMuteAudio = NO;
            
            
            
            [TKEduSessionHandle shareInstance].isunMuteAudio = YES;
            
        }
        
        
        
    }
    
    
    //TKLog(@"1------checkPlayVideo:%@,%@",tHaveRaiseHand?@"举手":@"取消举手",tIsMuteAudioState?@"静音":@"非静音");
}
#pragma mark - 播放
-(void)playVideo:(TKRoomUser*)user {
    
    [self.iSessionHandle delUserPlayAudioArray:user];
    
    TKVideoSmallView* viewToSee = nil;
    if (user.role == UserType_Teacher)
        viewToSee = self.iTeacherVideoView;
    
    else if ((_iRoomType == RoomType_OneToOne && user.role == UserType_Student) ||(_iRoomType == RoomType_OneToOne && user.role == UserType_Patrol)) {
        viewToSee = _iOurVideoView;
    }
    
    
    if (viewToSee && viewToSee.iRoomUser == nil) {
        
        [self myPlayVideo:user aVideoView:viewToSee completion:^(NSError *error) {
            
            if (!error) {
                [self.iPlayVideoViewDic setObject:viewToSee forKey:user.peerID];
                if (self.iSessionHandle.iIsFullState) {//如果文档处于全屏模式下则不进行刷新界面
                    return;
                }
                [self refreshUI];
            }
        }];
    }
}

-(void)unPlayVideo:(TKRoomUser *)user {
    
    TKVideoSmallView* viewToSee = nil;
    if (user.role == UserType_Teacher)
        viewToSee = self.iTeacherVideoView;
    
    else if (_iRoomType == RoomType_OneToOne && user.role == UserType_Student) {
        viewToSee = _iOurVideoView;
    }
    
    
    
    if (viewToSee && viewToSee.iRoomUser != nil && [viewToSee.iRoomUser.peerID isEqualToString:user.peerID]) {
        
        __weak typeof(self)weekSelf = self;
        NSMutableDictionary *tPlayVideoViewDic = self.iPlayVideoViewDic;
        
        
        
        
        [self myUnPlayVideo:user aVideoView:viewToSee completion:^(NSError *error) {
            
            [tPlayVideoViewDic removeObjectForKey:user.peerID];
            
            __strong typeof(weekSelf) strongSelf =  weekSelf;
            
            
            if (!self.iSessionHandle.iIsFullState) {
                [strongSelf refreshUI];
            }
            
        }];
    }
    [self.iSessionHandle delePendingUser:user.peerID];
}

-(void)myUnPlayVideo:(TKRoomUser *)aRoomUser aVideoView:(TKVideoSmallView*)aVideoView completion:(void (^)(NSError *error))completion{
    [self.iSessionHandle sessionHandleUnPlayVideo:aRoomUser.peerID completion:^(NSError *error) {
        
        //更新uiview
        [aVideoView clearVideoData];
        completion(error);
        
    }];
}
-(void)myPlayVideo:(TKRoomUser *)aRoomUser aVideoView:(TKVideoSmallView*)aVideoView completion:(void (^)(NSError *error))completion{
    
    
    [_iSessionHandle sessionHandlePlayVideo:aRoomUser.peerID renderType:(TKRenderMode_adaptive) window:aVideoView completion:^(NSError *error) {
        
        aVideoView.iPeerId        = aRoomUser.peerID;
        aVideoView.iRoomUser      = aRoomUser;
        //            [aVideoView changeAudioDisabledState]; // 当用户初始播放时，没有发送属性改变的通知，需要手动设置
        //            [aVideoView changeVideoDisabledState]; // 当用户初始播放时，没有发送属性改变的通知，需要手动设置
        //        if ([aRoomUser.peerID isEqualToString:_iSessionHandle.localUser.peerID]) {
        //            [aVideoView changeName:[NSString stringWithFormat:@"%@(%@)",aRoomUser.nickName,MTLocalized(@"Role.Me")]];
        //        }else if (aRoomUser.role == UserType_Teacher){
        //            [aVideoView changeName:[NSString stringWithFormat:@"%@(%@)",aRoomUser.nickName,MTLocalized(@"Role.Teacher")]];
        //        }else{
        [aVideoView changeName:aRoomUser.nickName];
        //        }
        //进入后台的提示
        BOOL isInBackGround = [aRoomUser.properties[sIsInBackGround] boolValue];
        
        [aVideoView endInBackGround:isInBackGround];
        
        
        TKLog(@"----play:%@  playerID:%@ ",aRoomUser.nickName, aVideoView.iPeerId);
        completion(error);
    }];
    
    
}

-(void)initTapGesTureRecognizer{
    UITapGestureRecognizer* tapTableGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTable:)];
    tapTableGesture.delegate = self;
    [self.backgroundImageView addGestureRecognizer:tapTableGesture];
}


-(void)leftButtonPress{
    if (_isQuiting) {return;}
    [self tapTable:nil];
    
    
    TKAlertView *alert = [[TKAlertView alloc]initWithTitle:MTLocalized(@"Prompt.prompt") contentText:MTLocalized(@"Prompt.Quite") leftTitle:MTLocalized(@"Prompt.Cancel") rightTitle:MTLocalized(@"Prompt.OK")];
    [alert show];
    alert.rightBlock = ^{
        _isQuiting = YES;
        [self prepareForLeave:YES];
    };
    alert.lelftBlock = ^{
        _isQuiting = NO;
    };
    
}

//如果是自己退出，则先掉leftroom。否则，直接退出。
-(void)prepareForLeave:(BOOL)aQuityourself
{
    
    [self tapTable:nil];
    
    [self.tabbarView destoy];
    
    [self.chatView dismissAlert];
    
    [self.controlView dismissAlert];
    
    [self.listView dismissAlert];
    
    [[TKEduSessionHandle shareInstance]configureHUD:@"" aIsShow:NO];
    
    [self invalidateTimer];
    
    [[UIDevice currentDevice] setProximityMonitoringEnabled: NO]; //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    
    if ([UIApplication sharedApplication].statusBarHidden) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[UIApplication sharedApplication]
         setStatusBarHidden:NO
         withAnimation:UIStatusBarAnimationNone];
        
#pragma clang diagnostic pop
        
    }
    
    
    if (aQuityourself) {
        [self unPlayVideo:_iSessionHandle.localUser];         // 进入教室不点击上课就退出，需要关闭自己视频
        //         [_iSessionHandle.whiteBoardManager resetWhiteBoardAllData];
        
        [_iSessionHandle sessionHandleLeaveRoom:nil];
        
    }else{
        // 清理数据
        [self quitClearData];
        
        
        [_iSessionHandle.whiteBoardManager resetWhiteBoardAllData];
        
        [_iSessionHandle.whiteBoardManager clearAllData];
        
        [_iSessionHandle.whiteBoardManager clearAllData];
        
        [_iSessionHandle clearAllClassData];
        
        _iSessionHandle = nil;
        [TKEduSessionHandle destory];
        _iSessionHandle.roomMgr = nil;
        
        dispatch_block_t blk = ^
        {
            [self dismissViewControllerAnimated:YES completion:^{
                // change openurl
                if (self.networkRecovered == NO) {
                    [TKUtil showMessage:MTLocalized(@"Error.WaitingForNetwork")];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:sTKRoomViewControllerDisappear object:nil];
            }];
        };
        blk();
    }
    
    _iSessionHandle.iIsClassEnd = NO;
    
}

#pragma mark - TKWhiteBoardDelegate 白板回调
- (void)boardOnViewStateUpdate:(NSDictionary *)message{
    
    [self.tabbarView updateView:message];
}
#pragma mark - TKEduSessionDelegate 课堂内容回调
- (void)sessionManagerDidOccuredWaring:(TKRoomWarningCode)code{
    switch (code) {
        case TKRoomWarning_RequestAccessForVideo_Failed:
        {
            TKAlertView *alert = [[TKAlertView alloc]initWithTitle:@"" contentText:MTLocalized(@"Prompt.NeedCamera") confirmTitle:MTLocalized(@"Prompt.Sure")];
            [alert show];
        }
            
            break;
        case TKRoomWarning_RequestAccessForAudio_Failed:
            
            break;
            
        default:
            break;
    }
}
// 获取礼物数
- (void)sessionManagerGetGiftNumber:(void(^)())completion {
    
    // 老师断线重连不需要获取礼物
    if (_iSessionHandle.localUser.role == UserType_Teacher || _iSessionHandle.localUser.role == UserType_Assistant ||
        _iSessionHandle.isPlayback == YES) {
        if (completion) {
            completion();
        }
        return;
    }
    
    // 学生断线重连需要获取礼物
    [TKEduNetManager getGiftinfo:_iRoomProperty.iRoomId aParticipantId: _iRoomProperty.iUserId  aHost:_iRoomProperty.sWebIp aPort:_iRoomProperty.sWebPort aGetGifInfoComplete:^(id  _Nullable response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            int result = 0;
            result = [[response objectForKey:@"result"]intValue];
            if (!result || result == -1) {
                
                NSArray *tGiftInfoArray = [response objectForKey:@"giftinfo"];
                int giftnumber = 0;
                for(int  i = 0; i < [tGiftInfoArray count]; i++) {
                    if (![_iRoomProperty.iUserId isEqualToString:@"0"] && _iRoomProperty.iUserId) {
                        NSDictionary *tDicInfo = [tGiftInfoArray objectAtIndex: i];
                        if ([[tDicInfo objectForKey:@"receiveid"] isEqualToString:_iRoomProperty.iUserId]) {
                            giftnumber = [tDicInfo objectForKey:@"giftnumber"] ? [[tDicInfo objectForKey:@"giftnumber"] intValue] : 0;
                            break;
                        }
                    }
                }
                
                self.iSessionHandle.localUser.properties[sGiftNumber] = @(giftnumber);
                
                if (completion) {
                    completion();
                }
                
                //[[TKEduSessionHandle shareInstance] joinEduClassRoomWithParam:_iParamDic aProperties:@{sGiftNumber:@(giftnumber)}];
            }
        });
        
    } aGetGifInfoError:^int(NSError * _Nullable aError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (completion) {
                completion();
            }
            
            //[[TKEduSessionHandle shareInstance] joinEduClassRoomWithParam:_iParamDic aProperties:nil];
        });
        return 1;
    }];
    
}

//自己进入课堂
- (void)sessionManagerRoomJoined{
    
    //移动端本机时间不对的话，能进入教室但是看不见课件,需退出课堂
    //    [self judgeDeviceTime];
    
    [[TKEduSessionHandle shareInstance] sessionHandleSetDeviceOrientation:(UIDeviceOrientationLandscapeLeft)];
    
    if (_iUserType == UserType_Teacher) {
        [[TKEduSessionHandle shareInstance].msgList removeAllObjects];
    }
    
    [TKEduNetManager getDefaultAreaWithComplete:^int(id  _Nullable response) {
        if (response) {
            NSString *serverName = [response objectForKey:@"name"];
            if (serverName != nil && [TKUtil isDomain:sHost] == YES) {
                NSArray *array = [sHost componentsSeparatedByString:@"."];
                NSString *defaultServer = [NSString stringWithFormat:@"%@", array[0]];
                if ([self.currentServer isEqualToString:defaultServer]) {
                    self.currentServer = serverName;
                }
            }
            
            [[TKRoomManager instance] changeCurrentServer:self.currentServer];
        }
        return 0;
    } aNetError:^int(id  _Nullable response) {
        [[TKRoomManager instance] changeCurrentServer:self.currentServer];
        return -1;
    }];
    
    // 主动获取奖杯数目
    [self getTrophyNumber];
    
    
    self.networkRecovered = YES;
    
    bool isConform = [TKUtil  deviceisConform];
    if (_iSessionHandle.localUser.role == UserType_Teacher) {
        if (!isConform) {
            NSString *str = [TKUtil dictionaryToJSONString:@{@"lowconsume":@YES, @"maxvideo":@(2)}];
            [_iSessionHandle sessionHandlePubMsg:sLowConsume ID:sLowConsume To:sTellAll Data:str Save:true AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
        } else {
            NSString *str = [TKUtil dictionaryToJSONString:@{@"lowconsume":@NO, @"maxvideo":@(_iRoomProperty.iMaxVideo.intValue)}];
            [_iSessionHandle sessionHandlePubMsg:sLowConsume ID:sLowConsume To:sTellAll Data:str Save:true AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
        }
    }
    
    
    // 低能耗老师进入一对多房间，进行提示
    if (!isConform && _iSessionHandle.localUser.role == UserType_Teacher && _iRoomType != RoomType_OneToOne) {
        NSString *message = [NSString stringWithFormat:@"%@", MTLocalized(@"Prompt.devicetPrompt")];
        TKChatMessageModel *chatMessageModel = [[TKChatMessageModel alloc] initWithFromid:_iSessionHandle.localUser.peerID aTouid:_iSessionHandle.localUser.peerID iMessageType:MessageType_Message aMessage:message aUserName:_iSessionHandle.localUser.nickName aTime:[TKUtil currentTimeToSeconds]];
        [[TKEduSessionHandle shareInstance] addOrReplaceMessage:chatMessageModel];
    }
    
    // 低能耗学生进入一对多房间，进行提示
    if (!isConform && _iSessionHandle.localUser.role != UserType_Teacher && _iRoomType != RoomType_OneToOne) {
        NSString *message = [NSString stringWithFormat:@"%@", MTLocalized(@"Prompt.devicetPrompt")];
        TKChatMessageModel *chatMessageModel = [[TKChatMessageModel alloc] initWithFromid:_iSessionHandle.localUser.peerID aTouid:_iSessionHandle.localUser.peerID iMessageType:MessageType_Message aMessage:message aUserName:_iSessionHandle.localUser.nickName aTime:[TKUtil currentTimeToSeconds]];
        [[TKEduSessionHandle shareInstance] addOrReplaceMessage:chatMessageModel];
    }
    
    // 如果断网之前在后台，回到前台时的时候需要发送回到前台的信令
    if ([_iSessionHandle.localUser.properties objectForKey:@"isInBackGround"] &&
        [[_iSessionHandle.localUser.properties objectForKey:@"isInBackGround"] boolValue] == YES &&
        _iSessionHandle.localUser.role == UserType_Student &&
        _iSessionHandle.roomMgr.inBackground == NO) {
        
        [[TKEduSessionHandle shareInstance] sessionHandleChangeUserProperty:[TKEduSessionHandle shareInstance].localUser.peerID TellWhom:sTellAll Key:sIsInBackGround Value:@(NO) completion:nil];
    }
    
    [TKEduSessionHandle shareInstance].iIsJoined = YES;
    //设置画笔等权限
    //    [[TKEduSessionHandle shareInstance]configureDrawAndPageWithControl:[_iSessionHandle.roomMgr getRoomProperty].chairmancontrol];
    
    BOOL isStdAndRoomOne = ([[TKEduSessionHandle shareInstance].roomMgr getRoomProperty].roomtype == RoomType_OneToOne && [TKEduSessionHandle shareInstance].localUser.role == UserType_Student);
    bool tIsTeacherOrAssis  = ([TKEduSessionHandle shareInstance].localUser.role ==UserType_Teacher || [TKEduSessionHandle shareInstance].localUser.role ==UserType_Assistant);
    //巡课不能翻页
    if ([TKEduSessionHandle shareInstance].localUser.role == UserType_Patrol || [TKEduSessionHandle shareInstance].isPlayback) {
        [[TKEduSessionHandle shareInstance]configurePage:false isSend:NO to:sTellAll peerID:[TKEduSessionHandle shareInstance].localUser.peerID];
        
        //        [TKEduSessionHandle shareInstance].iIsCanPage = false;
        //        [[TKEduSessionHandle shareInstance].iBoardHandle setPagePermission:[TKEduSessionHandle shareInstance].iIsCanPage];
    }else {
        
        // 翻页权限根据配置项设置
        [[TKEduSessionHandle shareInstance]configurePage:tIsTeacherOrAssis?true:[TKEduSessionHandle shareInstance].iIsCanPageInit isSend:NO to:sTellAll peerID:[TKEduSessionHandle shareInstance].localUser.peerID];
        
        // 涂鸦权限:1.1v1学生根据配置项设置 2.其他情况，没有涂鸦权限 3 非老师断线重连不可涂鸦。 发送:1 1v1 学生发送 2 学生发送，老师不发送
        //[[TKEduSessionHandle shareInstance]configureDraw:isStdAndRoomOne?[TKEduSessionHandle shareInstance].iIsCanDrawInit:false isSend:isStdAndRoomOne?YES:!tIsTeacher to:sTellAll peerID:[TKEduSessionHandle shareInstance].localUser.peerID];
        
        
        /*
         if (isStdAndRoomOne) {
         
         [TKEduSessionHandle shareInstance].iIsCanPage =  [TKEduSessionHandle shareInstance].iIsCanPageInit;
         [[TKEduSessionHandle shareInstance].iBoardHandle setPagePermission:[TKEduSessionHandle shareInstance].iIsCanPage];
         
         
         [TKEduSessionHandle shareInstance].iIsCanDraw =  [TKEduSessionHandle shareInstance].iIsCanDrawInit;
         [_iSessionHandle sessionHandleChangeUserProperty:_iSessionHandle.localUser.peerID TellWhom:sTellAll Key:sCandraw Value:@((bool)([TKEduSessionHandle shareInstance].iIsCanDraw)) completion:nil];
         }else{
         
         // 非老师断线重连不可涂鸦
         if (_iUserType != UserType_Teacher) {
         [TKEduSessionHandle shareInstance].iIsCanDraw = NO;
         [_iSessionHandle sessionHandleChangeUserProperty:_iSessionHandle.localUser.peerID TellWhom:sTellAll Key:sCandraw Value:@((bool)([TKEduSessionHandle shareInstance].iIsCanDraw)) completion:nil];
         }
         
         [TKEduSessionHandle shareInstance].iIsCanPage = true;
         [[TKEduSessionHandle shareInstance].iBoardHandle setPagePermission: [TKEduSessionHandle shareInstance].iIsCanPage];
         }*/
        
    }
    TKLog(@"tlm-----myjoined 时间: %@", [TKUtil currentTimeToSeconds]);
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO]; //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
    //  [[NSNotificationCenter defaultCenter] addObserver:self
    //  selector:@selector(proximityStateDidChange:)
    //  name:UIDeviceProximityStateDidChangeNotification object:nil];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    _iTKEduWhiteBoardView.hidden = NO;
    
    _iUserType       = (UserType)[TKEduSessionHandle shareInstance].localUser.role;
    _iRoomType       = (RoomType)[[_iSessionHandle.roomMgr getRoomProperty].roomtype intValue];
    _iRoomProperty.iUserType = _iUserType;
    _isQuiting        = NO;
    _iRoomProperty.iRoomType = _iRoomType;
    _iRoomProperty.iRoomName =[_iSessionHandle.roomMgr getRoomProperty].roomname;
    _iRoomProperty.iRoomId   = [_iSessionHandle.roomMgr getRoomProperty].roomid;
    _iRoomProperty.iUserId   = _iSessionHandle.localUser.peerID;
    
    NSString* endtime = [_iSessionHandle.roomMgr getRoomProperty].newendtime;
    
    if (endtime && [endtime isKindOfClass:[NSString class]] && endtime.length > 0)
    {
        static NSDateFormatter *dateFormatter = nil;
        static dispatch_once_t onceTokendefaultFormatter;
        dispatch_once(&onceTokendefaultFormatter, ^{
            dateFormatter = [[NSDateFormatter alloc]init];
        });
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [dateFormatter dateFromString:endtime];
        _iRoomProperty.iEndTime = [date timeIntervalSince1970];
    }
    else{
        _iRoomProperty.iEndTime  = 0;
    }
    NSString* starttime = [_iSessionHandle.roomMgr getRoomProperty].newstarttime;
    if (starttime && [starttime isKindOfClass:[NSString class]] && starttime.length > 0)
    {
        static NSDateFormatter *dateFormatter = nil;
        static dispatch_once_t onceTokendefaultFormatter;
        dispatch_once(&onceTokendefaultFormatter, ^{
            dateFormatter = [[NSDateFormatter alloc]init];
        });
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [dateFormatter dateFromString:starttime];
        _iRoomProperty.iStartTime = [date timeIntervalSince1970];
    }
    else{
        _iRoomProperty.iStartTime  = 0;
    }
    _iRoomProperty.iCurrentTime = [[NSDate date]timeIntervalSince1970];
    
    
    //    NSAttributedString * attrStr =  [[NSAttributedString alloc]initWithData:[_iSessionHandle.roomMgr getRoomProperty].roomname dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
    
    NSString *roomname = [_iSessionHandle.roomMgr getRoomProperty].roomname;
    
    [_navbarView setTitle:roomname];
    
    //    _titleLable.text =  attrStr.string;
    
    // _iGiftCount = [[_iSessionHandle.localUser.properties objectForKey:sGiftNumber]integerValue];
    BOOL meHasVideo = _iSessionHandle.localUser.hasVideo;
    BOOL meHasAudio = _iSessionHandle.localUser.hasAudio;
    //    [_iSessionHandle sessionHandleUseLoudSpeaker:NO];
    
    //    if (_connectHUD) {
    //        [_connectHUD hide:YES];
    //        _connectHUD = nil;
    //    }
    [[TKEduSessionHandle shareInstance]configureHUD:@"" aIsShow:NO];
    if(!meHasVideo){
        //        RoomClient.getInstance().warning(1);
        TKLog(@"没有视频");
    }
    if(!meHasAudio){
        //        RoomClient.getInstance().warning(2);
        TKLog(@"没有音频");
    }
    
    
    [_iSessionHandle addUserStdntAndTchr:_iSessionHandle.localUser];
    [[TKEduSessionHandle shareInstance]addUser:_iSessionHandle.localUser];
    
    [[TKEduSessionHandle shareInstance]configureHUD:@"" aIsShow:NO];
    
    TKLog(@"tlm----- 课堂加载完成时间: %@", [TKUtil currentTimeToSeconds]);
    
    //liyanyan
    //    [_iSessionHandle.iBoardHandle setPageParameterForPhoneForRole:_iUserType];
    
    // 非自动上课房间需要上课定时器
    if ([[_iSessionHandle.roomMgr getRoomProperty].companyid isEqualToString:YLB_COMPANYID]) {
        [self startClassReadyTimer];
    }
    
    //[_iSessionHandle sessionHandlePubMsg:sUpdateTime ID:sUpdateTime To:_iSessionHandle.localUser.peerID Data:@"" Save:NO completion:nil];
    [_iSessionHandle sessionHandlePubMsg:sUpdateTime ID:sUpdateTime To:_iSessionHandle.localUser.peerID Data:@"" Save:NO AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
    
    // 判断上下课按钮是否需要隐藏
    if ( (([_iSessionHandle.roomMgr getRoomConfigration].hideClassBeginEndButton == YES && _iSessionHandle.roomMgr.localUser.role != UserType_Student) || _iSessionHandle.isPlayback == YES)) {
        
    }
    
    
    //是否是自动上课
    if ([_iSessionHandle.roomMgr getRoomConfigration].autoStartClassFlag == YES && _iSessionHandle.isClassBegin == NO && _iSessionHandle.localUser.role == UserType_Teacher && ![[_iSessionHandle.roomMgr getRoomProperty].companyid isEqualToString:YLB_COMPANYID]) {
        
        [TKEduNetManager classBeginStar:[TKEduSessionHandle shareInstance].iRoomProperties.iRoomId companyid:[TKEduSessionHandle shareInstance].iRoomProperties.iCompanyID aHost:[TKEduSessionHandle shareInstance].iRoomProperties.sWebIp aPort:[TKEduSessionHandle shareInstance].iRoomProperties.sWebPort aComplete:^int(id  _Nullable response) {
            
            
            
            NSString *str = [TKUtil dictionaryToJSONString:@{@"recordchat":@YES}];
            //[_iSessionHandle sessionHandlePubMsg:sClassBegin ID:sClassBegin To:sTellAll Data:str Save:true completion:nil];
            [_iSessionHandle sessionHandlePubMsg:sClassBegin ID:sClassBegin To:sTellAll Data:str Save:true AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
            [[TKEduSessionHandle shareInstance]configureHUD:@"" aIsShow:NO];
            
            return 0;
        }aNetError:^int(id  _Nullable response) {
            
            [[TKEduSessionHandle shareInstance]configureHUD:@"" aIsShow:NO];
            
            return 0;
        }];
    }
    //如果是上课的状态则不进行推流的任何操作
    if([TKEduSessionHandle shareInstance].isClassBegin && _iUserType != UserType_Teacher){
        return;
    }
    // 进入房间就可以播放自己的视频
    if (_iUserType != UserType_Patrol && _iSessionHandle.isPlayback == NO) {
        _isLocalPublish = false;
        if ([_iSessionHandle.roomMgr getRoomConfigration].beforeClassPubVideoFlag) {//发布视频
            [_iSessionHandle sessionHandleChangeUserPublish:_iSessionHandle.localUser.peerID Publish:(PublishState_BOTH) completion:^(NSError *error) {
                
            }];
        }else{//显示本地视频不发布
            _isLocalPublish = true;
            _iSessionHandle.localUser.publishState = PublishState_Local_NONE;
            [[TKEduSessionHandle shareInstance] addPublishUser:_iSessionHandle.localUser];
            [[TKEduSessionHandle shareInstance] delePendingUser:_iSessionHandle.localUser.peerID];
//            [_iSessionHandle.roomMgr enableAudio:YES];
//            [_iSessionHandle.roomMgr enableVideo:YES];
            [[TKEduSessionHandle shareInstance] configurePlayerRoute:NO isCancle:NO];
            [self playVideo:_iSessionHandle.localUser];
            
            //            [self sessionManagerUserPublished:_iSessionHandle.localUser];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:tkUserListNotification
                                                        object:nil];
}

//自己离开课堂
- (void)sessionManagerRoomLeft {
    TKLog(@"-----roomManagerRoomLeft");
    _isQuiting = NO;
    [TKEduSessionHandle shareInstance].iIsJoined = NO;
    [_iSessionHandle configurePlayerRoute:NO isCancle:YES];
    [_iSessionHandle delUserStdntAndTchr:_iSessionHandle.localUser];
    [[TKEduSessionHandle shareInstance]delUser:_iSessionHandle.localUser];
    [self prepareForLeave:NO];
    
}
#pragma mark - 被踢
-(void) sessionManagerSelfEvicted:(NSDictionary *)reason{
    int rea;
    reason = [TKUtil processDictionaryIsNSNull:reason];
    
    if([[reason allKeys] containsObject:@"reason"]){
        rea = [reason[@"reason"] intValue];
    }else{
        rea = 0;
    }
    
    if (_iPickerController) {
        [_iPickerController dismissViewControllerAnimated:YES completion:^{
            
            [self showMessage:rea==1?MTLocalized(@"KickOut.SentOutClassroom"):MTLocalized(@"KickOut.Repeat")];
            _iPickerController = nil;
//            [self prepareForLeave:NO];
            [self sessionManagerRoomLeft];
        }];
    }else{
        [self showMessage:rea==1?MTLocalized(@"KickOut.SentOutClassroom"):MTLocalized(@"KickOut.Repeat")];
//        [self prepareForLeave:NO];
        
        [self sessionManagerRoomLeft];
        TKLog(@"---------SelfEvicted");
    }
}
- (void)sessionManagerOnAudioVolumeWithPeerID:(NSString *)peeID volume:(int)volume{
    NSDictionary *dict = @{@"volume":@(volume)};
    [[NSNotificationCenter defaultCenter]postNotificationName:[NSString stringWithFormat:@"%@%@",sVolume,peeID] object:dict];
}
//观看视频

- (void)sessionManagerPublishStateWithUserID:(NSString *)peerID publishState:(TKPublishState)state{
    TKRoomUser *user = [[TKEduSessionHandle shareInstance].roomMgr getRoomUserWithUId:peerID];
    if (!user) {
        return;
    }
    if (state) {
        
        [[TKEduSessionHandle shareInstance] addPublishUser:user];
        [[TKEduSessionHandle shareInstance] delePendingUser:user.peerID];
        
        if (user.publishState >0) {
            [self playVideo:user];
        }
        
        if (user.publishState == 1) {
            [self.iSessionHandle addOrReplaceUserPlayAudioArray:user];
        }
        
    }else{
        TKLog(@"1------unpublish:%@",user.nickName);
        [_iSessionHandle delUserPlayAudioArray:user];
        [[TKEduSessionHandle shareInstance]delePublishUser:user];
        [[TKEduSessionHandle shareInstance] delePendingUser:user.peerID];
        if (_iSessionHandle.localUser.role == UserType_Teacher && _iSessionHandle.iIsClassEnd == YES && user.role == UserType_Teacher) {
            // 老师发布的视频下课不取消播放
        } else {
            [self unPlayVideo:user];
        }
        
        
        
        
        if (_iSessionHandle.iHasPublishStd == NO && !_iSessionHandle.iIsFullState) {
            [self refreshUI];
        }
    }
    
}



//用户进入
- (void)sessionManagerUserJoined:(TKRoomUser *)user InList:(BOOL)inList {
    
    TKLog(@"1------otherJoined:%@ peerID:%@",user.nickName,user.peerID);
    
    UserType tMyRole =(UserType) [TKEduSessionHandle shareInstance].localUser.role;
    RoomType tRoomType =(RoomType) [[[TKEduSessionHandle shareInstance].roomMgr getRoomProperty].roomtype intValue];
    if (inList) {
        //1 大班课 //0 小班课
        if ((user.role == UserType_Teacher && tMyRole == UserType_Teacher) || (tRoomType == RoomType_OneToOne && (UserType)user.role == tMyRole && tMyRole == UserType_Student)) {
            
            [_iSessionHandle sessionHandleEvictUser:user.peerID evictReason:nil completion:nil];
            
        }
        
    }
    
    if (tMyRole == UserType_Teacher) {
        NSString* tChairmancontrol = [_iSessionHandle.roomMgr getRoomProperty].chairmancontrol;
        NSRange range5 = NSMakeRange(23, 1);
        NSString *str = [tChairmancontrol substringWithRange:range5];
        if ([str integerValue]) {
            
        }
    }
    [[TKEduSessionHandle shareInstance]addUser:user];
    //巡课不提示
    NSString *userRole;
    switch (user.role) {
        case UserType_Teacher:
            userRole = MTLocalized(@"Role.Teacher");
            break;
        case UserType_Student:
            userRole = MTLocalized(@"Role.Student");
            break;
        case UserType_Assistant:
            userRole = MTLocalized(@"Role.Assistant");
            break;
        default:
            break;
    }
    if (user.role !=UserType_Patrol) {
        TKChatMessageModel *tModel = [[TKChatMessageModel alloc]initWithFromid:0 aTouid:0 iMessageType:MessageType_Message aMessage:[NSString stringWithFormat:@"%@(%@)%@",user.nickName,userRole, MTLocalized(@"Action.EnterRoom")] aUserName:nil aTime:[TKUtil currentTime]];
        [_iSessionHandle addOrReplaceMessage:tModel];
    }
    BOOL tISpclUser = (user.role !=UserType_Student && user.role !=UserType_Teacher);
    if (tISpclUser) {
        [[TKEduSessionHandle shareInstance]addSecialUser:user];
        
    }else{
        [_iSessionHandle addUserStdntAndTchr:user];
        
    }
    
    // 提示在后台的学生
    if (_iUserType == UserType_Teacher || _iUserType == UserType_Assistant || _iUserType == UserType_Patrol) {
        if ([user.properties objectForKey:sIsInBackGround] != nil &&
            [[user.properties objectForKey:sIsInBackGround] boolValue] == YES) {
            NSString *deviceType = [user.properties objectForKey:@"devicetype"];
            NSString *message = [NSString stringWithFormat:@"%@ (%@) %@", user.nickName, deviceType, MTLocalized(@"Prompt.HaveEnterBackground")];
            TKChatMessageModel *chatMessageModel = [[TKChatMessageModel alloc] initWithFromid:user.peerID aTouid:_iSessionHandle.localUser.peerID iMessageType:MessageType_Message aMessage:message aUserName:user.nickName aTime:[TKUtil currentTimeToSeconds]];
            [[TKEduSessionHandle shareInstance] addOrReplaceMessage:chatMessageModel];
            
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:tkUserListNotification
                                                        object:nil];
}
//用户离开
- (void)sessionManagerUserLeft:(NSString *)peerId {
    
    TKRoomUser *user = [[TKEduSessionHandle shareInstance].roomMgr getRoomUserWithUId:peerId];
    
    [self unPlayVideo:user];
    
    BOOL tIsMe = [[NSString stringWithFormat:@"%@",user.peerID] isEqualToString:[NSString stringWithFormat:@"%@",[TKEduSessionHandle shareInstance].localUser.peerID]];
    
    NSString *userRole;
    switch (user.role) {
        case UserType_Teacher:
            userRole = MTLocalized(@"Role.Teacher");
            break;
        case UserType_Student:
            userRole = MTLocalized(@"Role.Student");
            break;
        case UserType_Assistant:
            userRole = MTLocalized(@"Role.Assistant");
            break;
        default:
            break;
    }
    
    if (user.role != UserType_Patrol && !tIsMe) {
        TKChatMessageModel *tModel = [[TKChatMessageModel alloc]initWithFromid:0 aTouid:0 iMessageType:MessageType_Message aMessage:[NSString stringWithFormat:@"%@(%@)%@",user.nickName,userRole, MTLocalized(@"Action.ExitRoom")] aUserName:nil aTime:[TKUtil currentTime]];
        [_iSessionHandle addOrReplaceMessage:tModel];
    }
    
    //去掉助教等特殊身份
    BOOL tISpclUser = (user.role !=UserType_Student && user.role !=UserType_Teacher);
    if (tISpclUser)
    {[[TKEduSessionHandle shareInstance]delSecialUser:user];}
    else
    {[_iSessionHandle delUserStdntAndTchr:user];}
    [[TKEduSessionHandle shareInstance] delUser:user];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:tkUserListNotification
                                                        object:nil];
    
}

//用户信息变化 
- (void)sessionManagerUserChanged:(TKRoomUser *)user Properties:(NSDictionary*)properties fromId:(NSString *)fromId
{
    NSInteger tGiftNumber = 0;
    if ([properties objectForKey:sGiftNumber]) {
        tGiftNumber = [[properties objectForKey:sGiftNumber]integerValue];
        
    }
    
    if ([properties objectForKey:sCandraw] && [_iSessionHandle.localUser.peerID isEqualToString:user.peerID] && [TKEduSessionHandle shareInstance].localUser.role == UserType_Student) {
        bool tCanDraw = [[properties objectForKey:sCandraw]boolValue];
        
        if ([TKEduSessionHandle shareInstance].iIsCanDraw != tCanDraw) {
            [[TKEduSessionHandle shareInstance]configureDraw:tCanDraw isSend:NO to:sTellAll peerID:user.peerID];
            // 翻页权限：1.有画笔权限，则可以翻页 2.无画笔权限根据配置项
            [[TKEduSessionHandle shareInstance]configurePage:tCanDraw?true:[TKEduSessionHandle shareInstance].iIsCanPageInit isSend:NO to:sTellAll peerID:user.peerID];
            
        }
        
    }
    BOOL isRaiseHand = NO;
    if ([properties objectForKey:sRaisehand]) {
        //如果没做改变的话，就不变化
        
        isRaiseHand  = [[properties objectForKey:sRaisehand]boolValue];
        
        // 当用户状态发生变化，用户列表状态也要发生变化
        for (TKRoomUser *u in [[TKEduSessionHandle shareInstance] userListExpecPtrlAndTchr]) {
            if ([u.peerID isEqualToString:user.peerID]) {
                [u.properties setValue:@(isRaiseHand) forKey:sRaisehand];
                
                break;
            }
        }
        // 如果是上课 并且花名册显示中 更新
        if ([[TKEduSessionHandle shareInstance] isClassBegin] && _userListView) {
            [[NSNotificationCenter defaultCenter] postNotificationName:tkUserListNotification object:nil];
        }
    }
    
    if ([properties objectForKey:sPublishstate]) {
        PublishState tPublishState = (PublishState)[[properties objectForKey:sPublishstate]integerValue];
        if([_iSessionHandle.localUser.peerID isEqualToString:user.peerID] ) {
            
            
            
            if (!_iSessionHandle.iIsFullState) {
                
                [self refreshUI];
            }
        }
        
        if ((tPublishState == PublishState_VIDEOONLY || tPublishState == PublishState_BOTH) &&
            [[_iSessionHandle userPlayAudioArray] containsObject:user.peerID]) {
            [self playVideo:user];
        }
        
        // 当用户状态发生变化，用户列表状态也要发生变化
        for (TKRoomUser *u in [[TKEduSessionHandle shareInstance] userListExpecPtrlAndTchr]) {
            if ([u.peerID isEqualToString:user.peerID]) {
                u.publishState = (TKPublishState)tPublishState;
                
                break;
            }
        }
        
        
        
    }
    
    //更改上台后的举手按钮样式
    if (_iUserType == UserType_Student && [_iSessionHandle.localUser.peerID isEqualToString:user.peerID]) {
        
        if (isRaiseHand) {
            if (_iSessionHandle.localUser.publishState > 0) {
                [self.navbarView setHandButtonState:YES];
            }
        } else {
            [self.navbarView setHandButtonState:NO];
        }
        
        
    }
    
    if ([properties objectForKey:sDisableAudio]) {
        // 修改TKEduSessionHandle中iUserList中用户的属性
        for (TKRoomUser *u in [[TKEduSessionHandle shareInstance] userListExpecPtrlAndTchr]) {
            if ([u.peerID isEqualToString:user.peerID]) {
                u.disableAudio = [[properties objectForKey:sDisableAudio] boolValue];
                
                
                break;
            }
        }
    }
    
    if ([properties objectForKey:sDisableVideo]) {
        for (TKRoomUser *u in [[TKEduSessionHandle shareInstance] userListExpecPtrlAndTchr]) {
            if ([u.peerID isEqualToString:user.peerID]) {
                u.disableVideo = [[properties objectForKey:sDisableVideo] boolValue];
                
                
                break;
            }
        }
    }
    
    if ([properties objectForKey:sUdpState]) {
        NSInteger updState = [[properties objectForKey:sUdpState] integerValue];
        // 用户列表的属性进行变更
        for (TKRoomUser *u in [[TKEduSessionHandle shareInstance] userListExpecPtrlAndTchr]) {
            if ([u.peerID isEqualToString:user.peerID]) {
                [u.properties setObject:@(updState) forKey:sUdpState];
                
                break;
            }
        }
    }
    
    if ([properties objectForKey:sServerName]) {
        
        if ([user.peerID isEqualToString:_iSessionHandle.localUser.peerID] &&
            ![fromId isEqualToString:_iSessionHandle.localUser.peerID]) {
            
            // 其他用户修改自己的服务器
            NSString *serverName = [NSString stringWithFormat:@"%@", [properties objectForKey:sServerName]];
            if (serverName != nil) {
                TKLog(@"助教协助修改了服务器地址:%@", serverName);
                [self changeServer:serverName];
                
                
                NSError *error = [NSError errorWithDomain:@"" code:TKRoomWarning_ReConnectSocket_ServerChanged userInfo:nil];
                
                [self sessionManagerDidFailWithError:error];
            }
            
        }
        
    }
    if ([properties objectForKey:sPrimaryColor]) {//画笔颜色
        
        // 当用户状态发生变化，用户列表状态也要发生变化
        for (TKRoomUser *u in [[TKEduSessionHandle shareInstance] userListExpecPtrlAndTchr]) {
            if ([u.peerID isEqualToString:user.peerID]) {
                [u.properties setValue:[properties objectForKey:sPrimaryColor] forKey:sPrimaryColor];
                
                break;
            }
        }
    }
    if ([properties objectForKey:sDisablechat] && [_iSessionHandle.localUser.peerID isEqualToString:user.peerID]) {
        BOOL disableChat = [properties[sDisablechat] boolValue];
        NSDictionary *dict = @{@"isBanSpeak":@(disableChat)};
        [[NSNotificationCenter defaultCenter]postNotificationName:sEveryoneBanChat object:dict];
    }
    
    NSDictionary *dict = @{sRaisehand:[properties objectForKey:sRaisehand]?[properties objectForKey:sRaisehand]:@(isRaiseHand),
                           sPublishstate:[properties objectForKey:sPublishstate]?[properties objectForKey:sPublishstate]:@(user.publishState),
                           sCandraw:[properties objectForKey:sCandraw]?[properties objectForKey:sCandraw]:@(user.canDraw),
                           sGiftNumber:@(tGiftNumber),
                           sDisableAudio:[properties objectForKey:sDisableAudio]?@([[properties objectForKey:sDisableAudio] boolValue]):@(user.disableAudio),
                           sDisableVideo:[properties objectForKey:sDisableVideo]?@([[properties objectForKey:sDisableVideo] boolValue]):@(user.disableVideo),
                           sPrimaryColor:[properties objectForKey:sPrimaryColor]?[properties objectForKey:sPrimaryColor]:[UIColor blackColor],
                           sFromId:fromId,
                           sUser:user
                           };
    NSMutableDictionary *tDic = [NSMutableDictionary dictionaryWithDictionary:dict];
    [tDic setValue:[properties objectForKey:sPrimaryColor] forKey:sPrimaryColor];
    [self.tabbarView refreshUI];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:[NSString stringWithFormat:@"%@%@",sRaisehand,user.peerID] object:tDic];
    [[NSNotificationCenter defaultCenter]postNotificationName:sDocListViewNotification object:nil];
    
    if ([properties objectForKey:sIsInBackGround]) {
        BOOL isInBackground = [[properties objectForKey:sIsInBackGround] boolValue];
        
        // 发送通知告诉视频控件后台状态
        NSDictionary *dict = @{sIsInBackGround:[properties objectForKey:sIsInBackGround]};
        [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@%@",sIsInBackGround,user.peerID] object:nil userInfo:dict];
        
        
        
        // 当用户发生前后台切换，用户列表状态也要发生变化
        for (TKRoomUser *u in [[TKEduSessionHandle shareInstance] userListExpecPtrlAndTchr]) {
            if ([u.peerID isEqualToString:user.peerID]) {
                [u.properties setObject:[properties objectForKey:sIsInBackGround] forKey:sIsInBackGround];
                
                break;
            }
        }
        
        if (_iUserType == UserType_Teacher || _iUserType == UserType_Assistant || _iUserType == UserType_Patrol) {
            NSString *deviceType = [user.properties objectForKey:@"devicetype"];
            NSString *content;
            if (isInBackground) {
                content = MTLocalized(@"Prompt.HaveEnterBackground");
            } else {
                content = MTLocalized(@"Prompt.HaveBackForground");
            }
            NSString *message = [NSString stringWithFormat:@"%@ (%@) %@", user.nickName, deviceType, content];
            TKChatMessageModel *chatMessageModel = [[TKChatMessageModel alloc] initWithFromid:user.peerID aTouid:_iSessionHandle.localUser.peerID iMessageType:MessageType_Message aMessage:message aUserName:user.nickName aTime:[TKUtil currentTimeToSeconds]];
            [[TKEduSessionHandle shareInstance] addOrReplaceMessage:chatMessageModel];
            
        }
        
    }
    
}


- (void)sessionManagerMessageReceived:(NSString *)message
                               fromID:(NSString *)peerID
                            extension:(NSDictionary *)extension{
    //当聊天视图存在的时候，显示聊天内容。否则存储在未读列表中
    if (_chatView) {
        [_chatView messageReceived:message fromID:peerID extension:extension];
        
    }else{
        
        /*
         
         {
         msg = "\U963f\U9053\U592b";
         type = 0;
         }
         
         */
        
        NSString *tDataString = [NSString stringWithFormat:@"%@",message];
        NSData *tJsData = [tDataString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * tDataDic = [NSJSONSerialization JSONObjectWithData:tJsData options:NSJSONReadingMutableContainers error:nil];
        
        NSNumber *type = [tDataDic objectForKey:@"type"];
        
        NSString *time = [tDataDic objectForKey:@"time"];
        NSString *msgtype = @"";
        if([[tDataDic allKeys]  containsObject: @"msgtype"]){
            msgtype = [tDataDic objectForKey:@"msgtype"];
        }
        // 问题信息不显示 0 聊天， 1 提问
        if ([type integerValue] != 0) {
            return;
        }
        //接收到pc端发送的图片不进行显示
        if ([msgtype isEqualToString:@"onlyimg"]) {
            return;
        }
        NSString *msg = [tDataDic objectForKey:@"msg"];
        
        NSString *tMyPeerId = [TKEduSessionHandle shareInstance].localUser.peerID;
        //自己发送的收不到
        if (!peerID) {
            peerID = [TKEduSessionHandle shareInstance].localUser.peerID;
        }
        BOOL isMe = [peerID isEqualToString:tMyPeerId];
        BOOL isTeacher = [extension[@"role"] intValue] == UserType_Teacher?YES:NO;
        
        MessageType tMessageType = (isMe)?MessageType_Me:(isTeacher?MessageType_Teacher:MessageType_OtherUer);
        
        TKChatMessageModel *tChatMessageModel = [[TKChatMessageModel alloc]initWithFromid:peerID aTouid:tMyPeerId iMessageType:tMessageType aMessage:msg aUserName:extension[@"nickname"] aTime:time];
        
        [[TKEduSessionHandle shareInstance].unReadMessagesArray addObject:tChatMessageModel];
        
        
        [[TKEduSessionHandle shareInstance] addOrReplaceMessage:tChatMessageModel];
        
        
    }
    
    [self.tabbarView refreshUI];
    
}

//- (void)sessionManagerPlaybackMessageReceived:(NSString *)message ofUser:(TKRoomUser *)user ts:(NSTimeInterval)ts {

- (void)sessionManagerRoomManagerPlaybackMessageReceived:(NSString *)message
                                                  fromID:(NSString *)peerID
                                                      ts:(NSTimeInterval)ts
                                               extension:(NSDictionary *)extension{
    
    NSString *tDataString = [NSString stringWithFormat:@"%@",message];
    NSData *tJsData = [tDataString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * tDataDic = [NSJSONSerialization JSONObjectWithData:tJsData options:NSJSONReadingMutableContainers error:nil];
    NSNumber *type = [tDataDic objectForKey:@"type"];
    
    // 问题信息不显示
    if ([type integerValue] != 0) {
        return;
    }
    NSString *msgtype = @"";
    
    if([[tDataDic allKeys]  containsObject: @"msgtype"]){
        msgtype = [tDataDic objectForKey:@"msgtype"];
    }
    // 问题信息不显示 0 聊天， 1 提问
    if ([type integerValue] != 0) {
        return;
    }
    //接收到pc端发送的图片不进行显示
    if ([msgtype isEqualToString:@"onlyimg"]) {
        return;
    }
    
    NSString *msg = [tDataDic objectForKey:@"msg"];
    NSString *tMyPeerId = _iSessionHandle.localUser.peerID;
    //自己发送的收不到
    if (!peerID) {
        peerID = _iSessionHandle.localUser.peerID;
    }
    BOOL isMe = [peerID isEqualToString:tMyPeerId];
    BOOL isTeacher =  [extension[@"role"] intValue] == UserType_Teacher?YES:NO;
    MessageType tMessageType = (isMe)?MessageType_Me:(isTeacher?MessageType_Teacher:MessageType_OtherUer);
    TKChatMessageModel *tChatMessageModel = [[TKChatMessageModel alloc]initWithFromid:peerID aTouid:tMyPeerId iMessageType:tMessageType aMessage:msg aUserName:extension[@"nickname"] aTime:[TKUtil timestampToFormatString:ts]];
    
    [_iSessionHandle addOrReplaceMessage:tChatMessageModel];
    
}

//进入会议失败,重连
- (void)sessionManagerDidFailWithError:(NSError *)error {
    
    if (!(error.code == TKErrorCode_ConnectSocketError || error.code == TKRoomWarning_ReConnectSocket_ServerChanged || error.code == TKErrorCode_Subscribe_RoomNotExist)) {
        return;
    }
    
    self.networkRecovered = NO;
    self.currentServer = nil;
    
    [[TKEduSessionHandle shareInstance]configureHUD:MTLocalized(@"State.Reconnecting") aIsShow:YES];
    [[TKEduSessionHandle shareInstance]configureDraw:false isSend:NO to:sTellAll peerID:[TKEduSessionHandle shareInstance].localUser.peerID];
    [[TKEduSessionHandle shareInstance].whiteBoardManager roomWhiteBoardOnDisconnect:nil];
    [self.iSessionHandle clearAllClassData];
    [self.iSessionHandle.whiteBoardManager resetWhiteBoardAllData];
    
    
    
    
    [self.iPlayVideoViewDic removeAllObjects];
    
    
    // 播放的MP4前，先移除掉上一个MP4窗口
    [[TKEduSessionHandle shareInstance].msgList removeAllObjects];
    if (self.iMediaView) {
        [self.iMediaView deleteWhiteBoard];
        [self.iMediaView removeFromSuperview];
        self.iMediaView = nil;
    }
    
    if (self.iScreenView) {
        [self.iScreenView removeFromSuperview];
        self.iScreenView = nil;
    }
    
    
    
}

- (void)clearVideoViewData:(TKVideoSmallView *)videoView {
    videoView.isDrag = NO;
    if (videoView.iRoomUser != nil) {
        [self myUnPlayVideo:videoView.iRoomUser aVideoView:videoView completion:^(NSError *error) {
            TKLog(@"清理视频窗口完成!");
        }];
    } else {
        [videoView clearVideoData];
    }
}


//相关信令 pub
- (void)sessionManagerOnRemoteMsg:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(unsigned long)ts Data:(NSObject*)data InList:(BOOL)inlist{
    
    
    TKLog(@"jin------remoteMsg:%@ msgID:%@",msgName,msgID);
    
    //添加
    if ([msgName isEqualToString:sClassBegin]) {
        
        NSString *tPeerId = _iSessionHandle.localUser.peerID;
        _iSessionHandle.isClassBegin = add;
        
        
        [[TKEduSessionHandle shareInstance].whiteBoardManager setClassBegin:add];
        [self.navbarView refreshUI:add];
        
        //上课
        if (add) {
            [self invalidateClassCurrentTime];
            
            
            [TKEduSessionHandle shareInstance].iIsClassEnd = NO;
            [TKEduSessionHandle shareInstance].isClassBegin = YES;
            
            // 上课之前将自己的音视频关掉
            if (![_iSessionHandle.roomMgr getRoomConfigration].autoOpenAudioAndVideoFlag && _isLocalPublish) {
                _iSessionHandle.localUser.publishState = PublishState_NONE;
                [self sessionManagerPublishStateWithUserID:_iSessionHandle.localUser.peerID publishState:(TKUser_PublishState_NONE)];
            }
            
            if (_iUserType == UserType_Student && [_iSessionHandle.roomMgr getRoomConfigration].beforeClassPubVideoFlag &&![_iSessionHandle.roomMgr getRoomConfigration].autoOpenAudioAndVideoFlag) {
                
                if (_iSessionHandle.localUser.publishState != PublishState_NONE) {
                    _isLocalPublish = false;
                    [[TKEduSessionHandle shareInstance] sessionHandleChangeUserPublish:_iSessionHandle.localUser.peerID Publish:(PublishState_NONE) completion:nil];
                }
            }else if(_iUserType == UserType_Student && !_isLocalPublish &&![_iSessionHandle.roomMgr getRoomConfigration].autoOpenAudioAndVideoFlag){
                if (_iSessionHandle.localUser.publishState != PublishState_NONE) {
                    _isLocalPublish = false;
                    [[TKEduSessionHandle shareInstance] sessionHandleChangeUserPublish:_iSessionHandle.localUser.peerID Publish:(PublishState_NONE) completion:nil];
                }
            }
            
            if ([TKEduSessionHandle shareInstance].isPlayMedia) {
                
                [[TKEduSessionHandle shareInstance]sessionHandleUnpublishMedia:nil];
                
            }
            
            if (_iUserType == UserType_Teacher && _iSessionHandle.isPlayback == NO) {
                
                if (_iSessionHandle.localUser.publishState != PublishState_BOTH) {
                    _isLocalPublish = false;
                    [[TKEduSessionHandle shareInstance] sessionHandleChangeUserPublish:_iSessionHandle.localUser.peerID Publish:(PublishState_BOTH) completion:nil];
                }
//                if ([TKEduSessionHandle shareInstance].iCurrentDocmentModel && !inlist) {
//                    [[TKEduSessionHandle shareInstance] publishtDocMentDocModel:[TKEduSessionHandle shareInstance].iCurrentDocmentModel To:sTellAllExpectSender aTellLocal:NO];
//                }
                
            }
            
            if ((self.playbackMaskView.iProgressSlider.value < 0.01 && _iSessionHandle.isPlayback == YES && self.playbackMaskView.playButton.isSelected == YES) ||
                _iSessionHandle.isPlayback == NO) {
                [self showMessage:MTLocalized(@"Class.Begin")];
            }
            
            if (!_iSessionHandle.isPlayback && ![_iSessionHandle.roomMgr getRoomConfigration].beforeClassPubVideoFlag && _iSessionHandle.isPlayback == NO) {
                if (_iUserType==UserType_Teacher || (_iUserType==UserType_Student && [_iSessionHandle.roomMgr getRoomConfigration].autoOpenAudioAndVideoFlag)) {
                    
                    if (_iSessionHandle.localUser.publishState != PublishState_BOTH) {
                        _isLocalPublish = false;
                        [_iSessionHandle sessionHandleChangeUserPublish:tPeerId Publish:(PublishState_BOTH) completion:^(NSError *error) {
                            
                        }];
                    }
                    
                }
            }else if(_iUserType==UserType_Teacher && [_iSessionHandle.roomMgr getRoomConfigration].autoOpenAudioAndVideoFlag && _iSessionHandle.isPlayback == NO){
                if (_iSessionHandle.localUser.publishState != PublishState_BOTH) {
                    _isLocalPublish = false;
                    [_iSessionHandle sessionHandleChangeUserPublish:tPeerId Publish:(PublishState_BOTH) completion:^(NSError *error) {
                        
                    }];
                }
            }else if(_iUserType == UserType_Student && [_iSessionHandle.roomMgr getRoomConfigration].autoOpenAudioAndVideoFlag  && _iSessionHandle.isPlayback == NO){
                if (_iSessionHandle.localUser.publishState != PublishState_BOTH) {
                    _isLocalPublish = false;
                    [_iSessionHandle sessionHandleChangeUserPublish:tPeerId Publish:(PublishState_BOTH) completion:^(NSError *error) {
                        
                    }];
                }
            }
            
            
            _iClassStartTime = ts;
            bool tIsTeacherOrAssis  = (_iUserType==UserType_Teacher || _iUserType == UserType_Assistant);
            //liyanyan
            //            [_iSessionHandle.iBoardHandle setAddPagePermission:tIsTeacherOrAssis];
            BOOL isStdAndRoomOne = ([[[TKEduSessionHandle shareInstance].roomMgr getRoomProperty].roomtype intValue] == RoomType_OneToOne && ([TKEduSessionHandle shareInstance].localUser.role == UserType_Student || [TKEduSessionHandle shareInstance].localUser.role == UserType_Teacher));
            // 涂鸦权限:1.1v1学生根据配置项设置2.其他情况，没有涂鸦权限 3 非老师断线重连不可涂鸦。 发送:1 1v1 学生发送 2 学生发送，老师不发送
            [[TKEduSessionHandle shareInstance] configureDraw:isStdAndRoomOne?[TKEduSessionHandle shareInstance].iIsCanDrawInit:tIsTeacherOrAssis isSend:isStdAndRoomOne?YES:!tIsTeacherOrAssis to:sTellAll peerID:tPeerId];
            
            //如果是学生需要重新设置翻页
            [[TKEduSessionHandle shareInstance]configurePage:[TKEduSessionHandle shareInstance].iIsCanDrawInit?true:[TKEduSessionHandle shareInstance].iIsCanPageInit isSend:NO to:sTellAll peerID:isStdAndRoomOne?tPeerId:@""];
            
            
            /*
             if (isStdAndRoomOne) {
             [[TKEduSessionHandle shareInstance]configureDraw:TKEduSessionHandle shareInstance].iIsCanDrawInit isSend:NO to:sTellAll peerID:tPeerId];
             
             }else{
             [[TKEduSessionHandle shareInstance]configureDraw:tIsTeacher isSend:NO to:sTellAll peerID:tPeerId];
             [TKEduSessionHandle shareInstance].iIsCanDraw = tIsTeacher;
             if (tIsTeacher) {
             [_iSessionHandle.iBoardHandle setDrawable:tIsTeacher];
             
             }
             }*/
            
            //            [_iSessionHandle sessionHandlePubMsg:sUpdateTime ID:sUpdateTime To:tPeerId  Data:@"" Save:false completion:^(NSError *error) {
            //
            //            }];
            [_iSessionHandle sessionHandlePubMsg:sUpdateTime ID:sUpdateTime To:tPeerId Data:@"" Save:false AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:^(NSError *error) {
                
            }];
            
            [self startClassBeginTimer];
            
            
            [self refreshUI];
            
            
        }else{ // 下课
            
            // 下课后老师的视频还可以继续播放
            //            if (_iSessionHandle.localUser.role == UserType_Teacher && _iSessionHandle.roomMgr.forbidLeaveClassFlag) {
            //                _iSessionHandle.localUser.publishState = PublishState_BOTH;
            //                [_iSessionHandle.roomMgr enableAudio:YES];
            //                [_iSessionHandle.roomMgr enableVideo:YES];
            //            }
            
            
            //未到下课时间： 老师点下课 —> 下课后不离开教室 _iSessionHandle.roomMgr.forbidLeaveClassFlag->下课时间到，课程结束，一律离开
            if ([_iSessionHandle.roomMgr getRoomConfigration].forbidLeaveClassFlag && [_iSessionHandle.roomMgr getRoomConfigration].endClassTimeFlag) {
                _iClassCurrentTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                                       target:self
                                                                     selector:@selector(onClassCurrentTimer)
                                                                     userInfo:nil
                                                                      repeats:YES];
                [_iClassCurrentTimer setFireDate:[NSDate date]];
            }
            
            //下课
            [TKEduSessionHandle shareInstance].iIsClassEnd = YES;
            [TKEduSessionHandle shareInstance].isClassBegin = NO;
            [self showMessage:MTLocalized(@"Class.Over")];
            
            // 隐藏授权 画笔 相机按钮
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TKTabbarViewHideICON" object:@{sCandraw: @(NO)}];
            
            BOOL isStdAndRoomOne = ([[TKEduSessionHandle shareInstance].roomMgr getRoomProperty].roomtype == RoomType_OneToOne && [TKEduSessionHandle shareInstance].localUser.role == UserType_Student);
            //liyanyan
            //             [_iSessionHandle.iBoardHandle setAddPagePermission:false];
            bool tIsTeacherOrAssis  = ([TKEduSessionHandle shareInstance].localUser.role ==UserType_Teacher || [TKEduSessionHandle shareInstance].localUser.role == UserType_Assistant);
            [[TKEduSessionHandle shareInstance]configureDraw:isStdAndRoomOne?[TKEduSessionHandle shareInstance].iIsCanDrawInit:false isSend:isStdAndRoomOne?YES:!tIsTeacherOrAssis to:sTellAll peerID:tPeerId];
            //BOOL isStd = ([TKEduSessionHandle shareInstance].localUser.role == UserType_Student);
            //如果是1v1学生需要重新设置翻页
            [[TKEduSessionHandle shareInstance]configurePage:[TKEduSessionHandle shareInstance].iIsCanPageInit isSend:NO to:sTellAll peerID:isStdAndRoomOne?tPeerId:@""];
            
            
            [self refreshUI];
            [self invalidateClassBeginTime];
            
            [self tapTable:nil];
            if ([TKEduSessionHandle shareInstance].localUser.role ==UserType_Teacher) {
                /*删除所有信令的消息，从服务器上*/
                if(![_iSessionHandle.roomMgr getRoomConfigration].forbidLeaveClassFlag){
                    [[TKEduSessionHandle shareInstance]sessionHandleDelMsg:sAllAll ID:sAllAll To:sTellNone Data:@{} completion:nil];
                }
                
            }
            if (![[_iSessionHandle.roomMgr getRoomProperty].companyid isEqualToString:YLB_COMPANYID]) {
                //                [self showMessage:MTLocalized(@"Prompt.ClassEnd")];
                
                
                // 非老师身份下课后退出教室
                if (_iUserType != UserType_Teacher && ![_iSessionHandle.roomMgr getRoomConfigration].forbidLeaveClassFlag) {//下课是否允许离开教室
                    
                    [self prepareForLeave:YES];
                    
                }else if(_iUserType == UserType_Teacher && ![_iSessionHandle.roomMgr getRoomConfigration].forbidLeaveClassFlag){
                    if(![_iSessionHandle.roomMgr getRoomConfigration].beforeClassPubVideoFlag){
                        _isLocalPublish = false;
                        [_iSessionHandle sessionHandleChangeUserPublish:tPeerId  Publish:PublishState_NONE completion:^(NSError *error) {
                        }];
                    }
                    
                }
                
            }
        }
        [self.tabbarView refreshUI];
        
    } else if ([msgName isEqualToString:sUpdateTime]) {
        
        if (add) {
            _iServiceTime = ts;
            _iLocalTime   = _iServiceTime - _iClassStartTime;
            _iRoomProperty.iHowMuchTimeServerFasterThenMe = ts - [[NSDate date] timeIntervalSince1970];
            
            if ([TKEduSessionHandle shareInstance].isClassBegin) {
                if ([_iClassTimetimer isValid]) {
                    //[_iClassTimetimer setFireDate:[NSDate date]];
                } else {
                    _iClassTimetimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                                        target:self
                                                                      selector:@selector(onClassTimer)
                                                                      userInfo:nil
                                                                       repeats:YES];
                    [_iClassTimetimer setFireDate:[NSDate date]];
                }
            }
        }
        
    }else if ([msgName isEqualToString:sMuteAudio]){
        
        int tPublishState = _iSessionHandle.localUser.publishState;
        NSString *tPeerId = _iSessionHandle.localUser.peerID;
        [TKEduSessionHandle shareInstance].isMuteAudio = add ?true:false;
        _isLocalPublish = false;
        if (tPublishState != PublishState_VIDEOONLY) {
            [_iSessionHandle sessionHandleChangeUserPublish:tPeerId  Publish:(tPublishState)+([TKEduSessionHandle shareInstance].isMuteAudio ?(-PublishState_AUDIOONLY):(PublishState_AUDIOONLY)) completion:^(NSError *error) {
                
            }];
        }else{
            [_iSessionHandle sessionHandleChangeUserPublish:tPeerId  Publish:([TKEduSessionHandle shareInstance].isMuteAudio ?(PublishState_NONE):(PublishState_AUDIOONLY)) completion:^(NSError *error) {
                
            }];
        }
        
        
    }else if ([msgName isEqualToString:sStreamFailure]){
        
        // 收到用户发布失败的消息
        NSDictionary *tDataDic = @{};
        if ([data isKindOfClass:[NSString class]]) {
            NSString *tDataString = [NSString stringWithFormat:@"%@",data];
            NSData *tJsData = [tDataString dataUsingEncoding:NSUTF8StringEncoding];
            tDataDic = [NSJSONSerialization JSONObjectWithData:tJsData options:NSJSONReadingMutableContainers error:nil];
        }
        if ([data isKindOfClass:[NSDictionary class]]) {
            tDataDic = (NSDictionary *)data;
        }
        
        NSString *tPeerId = [tDataDic objectForKey:@"studentId"];
        NSInteger failureType = [tDataDic objectForKey:@"failuretype"]?[[tDataDic objectForKey:@"failuretype"] integerValue] : 0;
        
        // 如果这个发布失败的用户是自己点击上台的，需要对自己进行上台失败错误原因进行提示。
        if ([[[_iSessionHandle pendingUserDic] allKeys] containsObject:tPeerId]) {
            switch (failureType) {
                case 1:
                    [TKUtil showMessage:MTLocalized(@"Prompt.StudentUdpOnStageError")];
                    break;
                    
                case 2:
                    [TKUtil showMessage:MTLocalized(@"Prompt.StudentTcpError")];
                    break;
                    
                case 3:
                    [TKUtil showMessage:MTLocalized(@"Prompt.exceeds")];
                    break;
                    
                case 4:
                {
                    
                    [TKUtil showMessage:[NSString stringWithFormat:@"%@%@",[[TKEduSessionHandle shareInstance] localUser].nickName,MTLocalized(@"Prompt.BackgroundCouldNotOnStage")]];//拼接上用户名
                    break;
                }
                case 5:
                    [TKUtil showMessage:MTLocalized(@"Prompt.StudentUdpError")];
                    break;
                    
                default:
                    break;
            }
        }
        
        [[TKEduSessionHandle shareInstance] delePendingUser:tPeerId];
        
    } else if ([msgName isEqualToString:sChangeServerArea]){//更改服务器
        
        
    } else if ([msgName isEqualToString:sVideoWhiteboard]){//视频标注回调
        
        _addVideoBoard = add;
        
        if (add) {
            if (_iMediaView) {//媒体
                
                [_iMediaView loadWhiteBoard];
                
            }
            if (_iFileView) {//电影
                
                [_iFileView loadWhiteBoard];
            }
        }else{
            if (_iMediaView){//媒体
                [[TKEduSessionHandle shareInstance].msgList removeAllObjects];
                
                [_iMediaView hiddenVideoWhiteBoard];
            }
            if (_iFileView){
                [[TKEduSessionHandle shareInstance].msgList removeAllObjects];
                [_iFileView hiddenVideoWhiteBoard];
            }
        }
    }else if([msgName isEqualToString:sEveryoneBanChat]){//全体禁言
        [TKEduSessionHandle shareInstance].isAllShutUp = add;
        if (add && inlist && _iSessionHandle.localUser.role == UserType_Student) {//如果是全体禁言并且后进入课堂
            
            [_iSessionHandle sessionHandleChangeUserProperty:_iSessionHandle.localUser.peerID TellWhom:sTellAll Key:sDisablechat Value:@(true) completion:nil];
            
        }
        
        NSMutableDictionary *tDic = [NSMutableDictionary dictionary];
        [tDic setValue:@(add) forKey:@"isBanSpeak"];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:sEveryoneBanChat object:tDic];
        
        TKChatMessageModel *chatMessageModel = [[TKChatMessageModel alloc] initWithFromid:nil aTouid:nil iMessageType:MessageType_Message aMessage:add?MTLocalized(@"Prompt.BanChatInView"):MTLocalized(@"Prompt.CancelBanChatInView") aUserName:_iSessionHandle.localUser.nickName aTime:[TKUtil currentTime]];
        
        [[TKEduSessionHandle shareInstance] addOrReplaceMessage:chatMessageModel];
        
        if (_chatView) {
            [_chatView reloadData];
        }
    }
    // 白板全屏(同步)
    else if ([msgName isEqualToString: sWBFullScreen]
             &&
             [[TKEduSessionHandle shareInstance].roomMgr getRoomConfigration].coursewareFullSynchronize// 配置项
             ) {
        
        
        // if () {
        NSDictionary *dic = nil;
        if ([data isKindOfClass:[NSString class]]) {
            NSString *tDataString = [NSString stringWithFormat:@"%@",data];
            NSData *tJsData = [tDataString dataUsingEncoding:NSUTF8StringEncoding];
            dic = [NSJSONSerialization JSONObjectWithData:tJsData options:NSJSONReadingMutableContainers error:nil];
        }
        else if ([data isKindOfClass:[NSDictionary class]]) {
            dic = (NSDictionary *)data;
        }
        
        
        BOOL isFull = [dic[sneedPictureInPictureSmall] boolValue];
        [[NSNotificationCenter defaultCenter] postNotificationName:sChangeWebPageFullScreen object:@(isFull)];
        
        [self changeVideoFrame:isFull];

    }
    
    
}

- (void)sessionManagerIceStatusChanged:(NSString*)state ofUser:(TKRoomUser *)user {
    TKLog(@"------IceStatusChanged:%@ nickName:%@",state,user.nickName);
}
// 画中画
- (void)changeVideoFrame:(BOOL)isFull {

    if(!moveView) return;
    
    if (isFull) {
        
        moveView.hidden = NO;
        moveView.x = ScreenW - moveView.width - 5.;
        moveView.y = ScreenH - self.tabbarHeight - moveView.height - 5.;
        
        [[UIApplication sharedApplication].keyWindow addSubview: moveView];
        
        // 隐藏按钮
        [_tabbarView hideAllButton];
        
    }
    else{
        
        moveView.frame = videoOriginFrame;
        
        // 播放中 隐藏画中画
        moveView.hidden = [TKEduSessionHandle shareInstance].isPlayMedia;
        
        [self.view addSubview: moveView];
        // 显示按钮
        [_tabbarView refreshUI];
    }
    
    // 隐藏小视频上的按钮 屏蔽操作
    [moveView showMaskView: isFull];
    
  
}

#pragma mark - media

- (void)sessionManagerOnShareMediaState:(NSString *)peerId state:(TKMediaState)state extensionMessage:(NSDictionary *)message{
    
    if (state) {
        [[TKEduSessionHandle shareInstance] configurePlayerRoute:NO isCancle:NO];
        [[TKEduSessionHandle shareInstance] configureHUD:@"" aIsShow:NO];
        [[TKEduSessionHandle shareInstance].whiteBoardManager unpublishNetworkMedia:nil];
        //[[TKEduSessionHandle shareInstance].iBoardHandle setPagePermission:false];
        //peerid设置为空，不设置本地的page变量
        [[TKEduSessionHandle shareInstance]configurePage:false isSend:NO to:sTellAll peerID:@""];
        [TKEduSessionHandle shareInstance].isPlayMedia = YES;
        //巡课不能翻页
        /*
         if (_iUserType == UserType_Patrol || [TKEduSessionHandle shareInstance].isPlayback) {
         [[TKEduSessionHandle shareInstance].iBoardHandle setPagePermission:false];
         }else {
         [[TKEduSessionHandle shareInstance].iBoardHandle setPagePermission:true];;
         }*/
        CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        BOOL hasVideo = false;
        if([message objectForKey:@"video"]){
            hasVideo = [message[@"video"] boolValue];
        }
        
        if (!hasVideo) {
            frame =CGRectMake(10, CGRectGetHeight(self.iTKEduWhiteBoardView.frame)-57+CGRectGetMinY(self.iTKEduWhiteBoardView.frame), CGRectGetWidth(self.iTKEduWhiteBoardView.frame)-20, 57);
        }
        
        // 播放的MP4前，先移除掉上一个MP4窗口
        if (self.iMediaView) {
            [self.iMediaView removeFromSuperview];
            self.iMediaView = nil;
        }
        
        TKBaseMediaView *tMediaView = [[TKBaseMediaView alloc] initWithMediaPeerID:peerId extensionMessage:message frame:frame];
        _iMediaView = tMediaView;
        
        
        // 如果是回放，需要将播放视频窗口放在回放遮罩页下
        if (_iSessionHandle.isPlayback == YES) {
            [self.view insertSubview:_iMediaView belowSubview:self.playbackMaskView];
        } else {
            [self.view addSubview:_iMediaView];
        }
        
        
        [[TKEduSessionHandle shareInstance] sessionHandlePlayMediaFile:peerId renderType:0 window:tMediaView completion:^(NSError *error) {
            
            [_iMediaView setVideoViewToBack];
            if (hasVideo) {
                
                [_iMediaView loadLoadingView];
                //                if(_iSessionHandle.localUser.role != UserType_Teacher){
                //                    [_iMediaView loadWhiteBoard];
                //                }
            }
            
        }];
        
        
        
        //        [[TKEduSessionHandle shareInstance] sessionHandlePlayMedia:peerId completion:^(NSError *error, NSObject *view) {
        //
        //        }];
        
    }else{
        
        //媒体流停止后需要删除sVideoWhiteboard
        [[TKEduSessionHandle shareInstance] sessionHandleDelMsg:sVideoWhiteboard ID:sVideoWhiteboard To:sTellAll Data:@{} completion:nil];
        [[TKEduSessionHandle shareInstance]configurePage:[TKEduSessionHandle shareInstance].iIsCanPage isSend:NO to:sTellAll peerID:@""];
        
        [TKEduSessionHandle shareInstance].isPlayMedia = NO;
        [[TKEduSessionHandle shareInstance] configureHUD:@"" aIsShow:NO];
        
        
        [[TKEduSessionHandle shareInstance] sessionHandleUnPlayMediaFile:peerId completion:nil];
        [_iMediaView deleteWhiteBoard];
        
        [_iMediaView removeFromSuperview];
        _iMediaView = nil;
        [[TKEduSessionHandle shareInstance].msgList removeAllObjects];
        if ( [TKEduSessionHandle shareInstance].isChangeMedia) {
            
            [TKEduSessionHandle shareInstance].isChangeMedia = NO;
            TKMediaDocModel *tMediaDocModel =  [TKEduSessionHandle shareInstance].iCurrentMediaDocModel;
            NSString *tNewURLString2 = [TKUtil absolutefileUrl:tMediaDocModel.swfpath webIp:[TKEduSessionHandle shareInstance].iRoomProperties.sWebIp webPort:[TKEduSessionHandle shareInstance].iRoomProperties.sWebPort];
            
            BOOL tIsVideo = [TKUtil isVideo:tMediaDocModel.filetype];
            
            NSString * toID = [TKEduSessionHandle shareInstance].isClassBegin?sTellAll:[TKEduSessionHandle shareInstance].localUser.peerID;
            
            [[TKEduSessionHandle shareInstance]sessionHandlePublishMedia:tNewURLString2 hasVideo:tIsVideo fileid:[NSString stringWithFormat:@"%@",tMediaDocModel.fileid] filename:tMediaDocModel.filename toID:toID block:nil];
            
        }
        [TKEduSessionHandle shareInstance].iCurrentMediaDocModel = nil;
        
        // 画中画
        if ([_iSessionHandle.roomMgr getRoomConfigration].coursewareFullSynchronize
            &&
            _iSessionHandle.iIsFullState == NO) {
            [moveView removeFromSuperview];
            [self changeVideoFrame: NO];
            
        }
    }
}



- (void)sessionManagerUpdateMediaStream:(NSTimeInterval)duration pos:(NSTimeInterval)pos isPlay:(BOOL)isPlay{
    
    [_iMediaView updatePlayUI:isPlay];
    if (isPlay) {
        [_iMediaView update:pos total:duration];
    }
    //TKLog(@"jin postion:%@ play:%@",@(pos),@(isPlay));
}
//收到流视频第一帧
- (void)sessionManagerMediaLoaded
{
    if (_iMediaView) {
        [_iMediaView hiddenLoadingView];
    }
    if (_iFileView) {
        [_iFileView hiddenLoadingView];
    }
}
#pragma mark Screen

- (void)sessionManagerOnShareScreenState:(NSString *)peerId state:(TKMediaState)state extensionMessage:(NSDictionary *)message{
    
    if (state) {
        if (self.iScreenView) {
            [self.iScreenView removeFromSuperview];
            self.iScreenView = nil;
        }
        
        CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        TKBaseMediaView *tScreenView = [[TKBaseMediaView alloc] initScreenShare:frame];
        _iScreenView = tScreenView;
        
        if (_iSessionHandle.isPlayback == YES) {
            [self.view insertSubview:_iScreenView belowSubview:self.playbackMaskView];
        } else {
            [self.view addSubview:_iScreenView];
        }
        
        [[TKEduSessionHandle shareInstance] sessionHandlePlayScreen:peerId renderType:0 window:_iScreenView completion:nil];
        
    }else{
        __weak typeof(self) wself = self;
        [[TKEduSessionHandle shareInstance] sessionHandleUnPlayScreen:peerId completion:^(NSError *error) {
            
            [wself.iScreenView removeFromSuperview];
            wself.iScreenView = nil;
        }];
    }
    
}

#pragma mark file

- (void)sessionManagerOnShareFileState:(NSString *)peerId state:(TKMediaState)state extensionMessage:(NSDictionary *)message{
    if (state) {
        if (self.iFileView) {
            [self.iFileView removeFromSuperview];
            self.iFileView = nil;
        }
        CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        TKBaseMediaView *tFilmView = [[TKBaseMediaView alloc] initFileShare:frame];
        _iFileView = tFilmView;
        [_iFileView loadLoadingView];
        
        if (_iSessionHandle.isPlayback == YES) {
            [self.view insertSubview:_iFileView belowSubview:self.playbackMaskView];
        } else {
            [self.view addSubview:_iFileView];
        }
        [[TKEduSessionHandle shareInstance] sessionHandlePlayFile:peerId renderType:0 window:_iFileView completion:^(NSError *error) {
            if( _iSessionHandle.localUser.role != UserType_Teacher){
                [_iFileView loadWhiteBoard];
            }
        }];
        
    }else{
        //媒体流停止后需要删除sVideoWhiteboard
        [[TKEduSessionHandle shareInstance] sessionHandleDelMsg:sVideoWhiteboard ID:sVideoWhiteboard To:sTellAll Data:@{} completion:nil];
        
        __weak typeof(self) wself = self;
        
        [[TKEduSessionHandle shareInstance] sessionHandleUnPlayFile:peerId completion:^(NSError *error) {
            
            [wself.iFileView deleteWhiteBoard];
            [[TKEduSessionHandle shareInstance].msgList removeAllObjects];
            [wself.iFileView removeFromSuperview];
            wself.iFileView = nil;
            
        }];
    }
}
#pragma mark Playback

- (void)sessionManagerReceivePlaybackDuration:(NSTimeInterval)duration {
    //self.playbackMaskView.model.duration = duration;
    [self.playbackMaskView getPlayDuration:duration];
}

- (void)sessionManagerPlaybackUpdateTime:(NSTimeInterval)time {
    
    [self.playbackMaskView update:time];
}

- (void)sessionManagerPlaybackClearAll {
    
    //liyanyan
    //    [_iSessionHandle.whiteBoardManager playbackSeekCleanup];
    //[_iSessionHandle clearAllClassData];
    [_iSessionHandle clearMessageList];
    [_iSessionHandle.whiteBoardManager resetWhiteBoardAllData];
}

- (void)sessionManagerPlaybackEnd {
    [self.playbackMaskView playbackEnd];
}

#pragma mark 设备检测
- (void)noCamera {
    
    TKAlertView *alert = [[TKAlertView alloc]initWithTitle:@"" contentText:MTLocalized(@"Prompt.NeedCamera") confirmTitle:MTLocalized(@"Prompt.Sure")];
    [alert show];
    
    
    
}

- (void)noMicrophone {
    TKAlertView *alert = [[TKAlertView alloc]initWithTitle:MTLocalized(@"Prompt.NeedMicrophone.Title") contentText:MTLocalized(@"Prompt.NeedMicrophone") confirmTitle:MTLocalized(@"Prompt.Sure")];
    [alert show];
    
    
}

- (void)noCameraAndNoMicrophone {
    
    TKAlertView *alert = [[TKAlertView alloc]initWithTitle:@"" contentText:MTLocalized(@"Prompt.NeedCameraNeedMicrophone") confirmTitle:MTLocalized(@"Prompt.Sure")];
    [alert show];
    
}

#pragma mark 首次发布或订阅失败3次
- (void)networkTrouble {
    
    TKAlertView *alert = [[TKAlertView alloc]initWithTitle:@"" contentText:MTLocalized(@"Prompt.NetworkException") confirmTitle:MTLocalized(@"Prompt.OK")];
    [alert show];
    
}

- (void)networkChanged {
    TKAlertView *alert = [[TKAlertView alloc]initWithTitle:@"" contentText:MTLocalized(@"Prompt.NetworkChanged") confirmTitle:MTLocalized(@"Prompt.OK")];
    [alert show];
    
}

#pragma mark TKEduBoardDelegate

- (void)boardOnFileList:(NSArray*)fileList{
    TKLog(@"------OnFileList:%@ ",fileList);
}
- (BOOL)boardOnRemoteMsg:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(long)ts Data:(NSObject*)data InList:(BOOL)inlist{
    TKLog(@"------WhiteBoardOnRemoteMsg:%@ msgID:%@ ",msgName,msgID);
    return NO;
    
}
- (void)boardOnRemoteMsgList:(NSArray*)list{
    
}
#pragma mark scrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    
    
#pragma clang diagnostic pop
    
    
}


-(void)reSetTitleView:(BOOL)aIsHide aInputContainerIsHide:(BOOL)aInputContainerIsHide aStatusIsHide:(BOOL)aStatusIsHide{
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[UIApplication sharedApplication] setStatusBarHidden:aStatusIsHide animated:YES];
    
#pragma clang diagnostic pop
    
    // _inputContainer.hidden = aInputContainerIsHide;
    
}

#pragma mark UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"] || [NSStringFromClass([touch.view class]) isEqualToString:@"TKTextViewInternal"] ||  [NSStringFromClass([touch.view class]) isEqualToString:@"UIButton"] )
    {
        return NO;
    }
    else
    {
        
        [self tapTable:nil];
        return ![TKEduSessionHandle shareInstance].iIsCanDraw;
    }
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return true;
}

- (void)tapTable:(UIGestureRecognizer *)gesture
{
    [[NSNotificationCenter defaultCenter]postNotificationName:stouchMainPageNotification object:nil];
    //[self resetTimer];
    //[self moveNaviBar];
    [_iTeacherVideoView hidePopMenu];
    [_iOurVideoView hidePopMenu];
}

#pragma mark 横竖屏
- (BOOL)shouldAutorotate
{
    return false;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeRight;
}



//设置隐藏动画
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}


#pragma mark 其他
- (void)showMessage:(NSString *)message {
    NSArray *array = [UIApplication sharedApplication].windows;
    int count = (int)array.count;
    [TKRCGlobalConfig HUDShowMessage:message addedToView:[array objectAtIndex:(count >= 2 ? (count - 2) : 0)] showTime:2];
}
#pragma mark 声音
- (void)handleAudioSessionInterruption:(NSNotification*)notification {
    
    NSNumber *interruptionType = [[notification userInfo] objectForKey:AVAudioSessionInterruptionTypeKey];
    NSNumber *interruptionOption = [[notification userInfo] objectForKey:AVAudioSessionInterruptionOptionKey];
    
    switch (interruptionType.unsignedIntegerValue) {
        case AVAudioSessionInterruptionTypeBegan:{
            // • Audio has stopped, already inactive
            // • Change state of UI, etc., to reflect non-playing state
        } break;
        case AVAudioSessionInterruptionTypeEnded:{
            // • Make session active
            // • Update user interface
            // • AVAudioSessionInterruptionOptionShouldResume option
            if (interruptionOption.unsignedIntegerValue == AVAudioSessionInterruptionOptionShouldResume) {
                // Here you should continue playback.
                //[player play];
            }
        } break;
        default:
            break;
    }
    AVAudioSessionInterruptionType type = (AVAudioSessionInterruptionType)[notification.userInfo[AVAudioSessionInterruptionTypeKey] intValue];
    TKLog(@"---jin 当前category: 打断 %@",@(type));
}


-(void)handleMediaServicesReset:(NSNotification *)aNotification{
    
    
    
    AVAudioSessionInterruptionType type = (AVAudioSessionInterruptionType)[aNotification.userInfo[AVAudioSessionInterruptionTypeKey] intValue];
    TKLog(@"---jin 当前AVAudioSessionMediaServicesWereResetNotification: 打断 %@",@(type));
    
    
    
}
- (void)routeChange:(NSNotification*)notify{
    if(notify){
        
        if (([AVAudioSession sharedInstance].categoryOptions !=AVAudioSessionCategoryOptionMixWithOthers )||([AVAudioSession sharedInstance].category !=AVAudioSessionCategoryPlayAndRecord) ) {
            //[[TKEduSessionHandle shareInstance]configurePlayerRoute:[TKEduSessionHandle shareInstance].isPlayMedia isCancle:NO];
        }
        
        [self pluggInOrOutMicrophone:notify.userInfo];
        [self printAudioCurrentCategory];
        [self printAudioCurrentMode];
        [self printAudioCategoryOption];
        
    }
    
}
// 插拔耳机
-(void)pluggInOrOutMicrophone:(NSDictionary *)userInfo{
    NSDictionary *interuptionDict = userInfo;
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            
            TKLog(@"---jin 耳机插入");
            [TKEduSessionHandle shareInstance].isHeadphones = YES;
            [TKEduSessionHandle shareInstance].iVolume = 0.5;
            // [[TKEduSessionHandle shareInstance]configurePlayerRoute:[TKEduSessionHandle shareInstance].isPlayMedia isCancle:NO];
            [[TKEduSessionHandle shareInstance]configurePlayerRoute: NO isCancle:NO];
            if ([TKEduSessionHandle shareInstance].isPlayMedia){
                
                [[NSNotificationCenter defaultCenter] postNotificationName:
                 sPluggInMicrophoneNotification
                                                                    object:nil];
            }
            
            break;
        case AVAudioSessionRouteChangeReasonNoSuitableRouteForCategory:
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
            
            [TKEduSessionHandle shareInstance].isHeadphones = NO;
            [TKEduSessionHandle shareInstance].iVolume = 1;
            [[TKEduSessionHandle shareInstance]configurePlayerRoute: NO isCancle:NO];
            //[[TKEduSessionHandle shareInstance]configurePlayerRoute:[TKEduSessionHandle shareInstance].isPlayMedia isCancle:NO];
            if ([TKEduSessionHandle shareInstance].isPlayMedia) {
                [[NSNotificationCenter defaultCenter] postNotificationName:sUnunpluggingHeadsetNotification
                                                                    object:nil];
            }
            
            TKLog(@"---jin 耳机拔出，停止播放操作");
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            TKLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
    
}
//打印日志
- (void)printAudioCurrentCategory{
    
    NSString *audioCategory =  [AVAudioSession sharedInstance].category;
    if ( audioCategory == AVAudioSessionCategoryAmbient ){
        NSLog(@"---jin current category is : AVAudioSessionCategoryAmbient");
    } else if ( audioCategory == AVAudioSessionCategorySoloAmbient ){
        NSLog(@"---jin current category is : AVAudioSessionCategorySoloAmbient");
    } else if ( audioCategory == AVAudioSessionCategoryPlayback ){
        NSLog(@"---jin current category is : AVAudioSessionCategoryPlayback");
    }  else if ( audioCategory == AVAudioSessionCategoryRecord ){
        NSLog(@"---jin current category is : AVAudioSessionCategoryRecord");
    } else if ( audioCategory == AVAudioSessionCategoryPlayAndRecord ){
        NSLog(@"---jin current category is : AVAudioSessionCategoryPlayAndRecord");
    } else if ( audioCategory == AVAudioSessionCategoryAudioProcessing ){
        NSLog(@"---jin current category is : AVAudioSessionCategoryAudioProcessing");
    } else if ( audioCategory == AVAudioSessionCategoryMultiRoute ){
        NSLog(@"---jin current category is : AVAudioSessionCategoryMultiRoute");
    }  else {
        NSLog(@"---jin current category is : unknow");
    }
    
}

- (void)printAudioCurrentMode{
    
    
    NSString *audioMode =  [AVAudioSession sharedInstance].mode;
    if ( audioMode == AVAudioSessionModeDefault ){
        NSLog(@"---jin current mode is : AVAudioSessionModeDefault");
    } else if ( audioMode == AVAudioSessionModeVoiceChat ){
        NSLog(@"---jin current mode is : AVAudioSessionModeVoiceChat");
    } else if ( audioMode == AVAudioSessionModeGameChat ){
        NSLog(@"---jin current mode is : AVAudioSessionModeGameChat");
    }  else if ( audioMode == AVAudioSessionModeVideoRecording ){
        NSLog(@"---jin current mode is : AVAudioSessionModeVideoRecording");
    } else if ( audioMode == AVAudioSessionModeMeasurement ){
        NSLog(@"---jin current mode is : AVAudioSessionModeMeasurement");
    } else if ( audioMode == AVAudioSessionModeMoviePlayback ){
        NSLog(@"---jin current mode is : AVAudioSessionModeMoviePlayback");
    } else if ( audioMode == AVAudioSessionModeVideoChat ){
        NSLog(@"---jin current mode is : AVAudioSessionModeVideoChat");
    }else if ( audioMode == AVAudioSessionModeSpokenAudio ){
        NSLog(@"---jin current mode is : AVAudioSessionModeSpokenAudio");
    } else {
        NSLog(@"---jin current mode is : unknow");
    }
    
}

-(void)printAudioCategoryOption{
    NSString *tSString = @"AVAudioSessionCategoryOptionMixWithOthers";
    switch ([AVAudioSession sharedInstance].categoryOptions) {
        case AVAudioSessionCategoryOptionDuckOthers:
            tSString = @"AVAudioSessionCategoryOptionDuckOthers";
            break;
        case AVAudioSessionCategoryOptionAllowBluetooth:
            tSString = @"AVAudioSessionCategoryOptionAllowBluetooth";
            if (![TKEduSessionHandle shareInstance].isPlayMedia) {
                NSLog(@"---jin sessionManagerUserPublished");
                [[TKEduSessionHandle shareInstance] configurePlayerRoute:NO isCancle:NO];
                
            }
            break;
        case AVAudioSessionCategoryOptionDefaultToSpeaker:
            tSString = @"AVAudioSessionCategoryOptionDefaultToSpeaker";
            break;
        case AVAudioSessionCategoryOptionInterruptSpokenAudioAndMixWithOthers:
            tSString = @"AVAudioSessionCategoryOptionInterruptSpokenAudioAndMixWithOthers";
            break;
        case AVAudioSessionCategoryOptionAllowBluetoothA2DP:
            tSString = @"AVAudioSessionCategoryOptionAllowBluetoothA2DP";
            break;
        case AVAudioSessionCategoryOptionAllowAirPlay:
            tSString = @"AVAudioSessionCategoryOptionAllowAirPlay";
            break;
        default:
            break;
    }
    
    TKLog(@"---jin current categoryOptions is :%@",tSString);
}

#pragma mark 开始
-(void)onClassReady{
    
    if(!_iRoomProperty.iHowMuchTimeServerFasterThenMe)
        return;
    
    if (![TKEduSessionHandle shareInstance].isClassBegin && _iUserType == UserType_Teacher) {
        _iRoomProperty.iCurrentTime = [[NSDate date]timeIntervalSince1970] + _iRoomProperty.iHowMuchTimeServerFasterThenMe;
        //1498569290.216449
        BOOL tEnabled = _iRoomProperty.iStartTime != 0 &&((int)((_iRoomProperty.iStartTime*1000 -_iRoomProperty.iCurrentTime*1000)/1000) < 60);
        
        
        
        if ((int)((_iRoomProperty.iCurrentTime*1000 -_iRoomProperty.iStartTime*1000)/1000)>=-60 &&((int)((_iRoomProperty.iCurrentTime*1000 -_iRoomProperty.iStartTime*1000)/1000)< 0 && !_iShowBefore)) {
            
            _iShowBefore = YES;
            
            //            [_iClassTimeView showPromte:PromptTypeStartReady1Minute aPassEndTime: ((_iRoomProperty.iCurrentTime*1000 -_iRoomProperty.iStartTime*1000)/1000) aPromptTime:5];
            
        }else if(((int)(_iRoomProperty.iCurrentTime*1000 -_iRoomProperty.iStartTime*1000)/1000)/60>=1 && !_iShow &&(_iRoomProperty.iCurrentTime-_iRoomProperty.iStartTime)>0 ){
            
            //            [_iClassTimeView showPromte:PromptTypeStartPass1Minute aPassEndTime: (int)((_iRoomProperty.iCurrentTime*1000 -_iRoomProperty.iStartTime*1000)/1000) aPromptTime:5];
            _iShow = YES;
            
            
        }
        
    }
    
}

-(void)invalidateClassReadyTime{
    if (_iClassReadyTimetimer) {
        [_iClassReadyTimetimer invalidate];
        _iClassReadyTimetimer = nil;
        //        [_iClassTimeView hidePromptView];
    }
    
}
-(void)startClassReadyTimer{
    
    
    _iRoomProperty.iCurrentTime = [[NSDate date]timeIntervalSince1970];
    [_iClassReadyTimetimer setFireDate:[NSDate date]];
}

- (void)onClassCurrentTimer{
    
    if(!_iRoomProperty.iHowMuchTimeServerFasterThenMe)
        return;
    
    _iRoomProperty.iCurrentTime = [[NSDate date]timeIntervalSince1970] + _iRoomProperty.iHowMuchTimeServerFasterThenMe;
    
    NSTimeInterval interval = _iRoomProperty.iEndTime -_iRoomProperty.iCurrentTime;
    NSInteger time = interval;
    //（1）未到下课时间： 老师点下课 —> 下课后不离开教室forbidLeaveClassFlag—>提前5分钟给出提示语（老师、助教）—>下课时间到，课程结束，一律离开
    if(_iSessionHandle.iIsClassEnd && [_iSessionHandle.roomMgr getRoomConfigration].forbidLeaveClassFlag){
        
        if (time==300 && _iSessionHandle.localUser.role == UserType_Teacher) {
            [TKUtil showMessage:[NSString stringWithFormat:@"5%@",MTLocalized(@"Prompt.ClassEndTime")]];
        }
        if (time<=0) {
            [self showMessage:MTLocalized(@"Prompt.ClassEnd")];
            [self prepareForLeave:YES];
        }
    }
}
-(void)onClassTimer {
    
    //此处主要用于检测上课过程中进入后台后无法返回前台的状况
    BOOL isBackground = [_iSessionHandle.roomMgr.localUser.properties[sIsInBackGround] boolValue];
    if(([UIApplication sharedApplication].applicationState == UIApplicationStateActive) && isBackground){
        [[TKEduSessionHandle shareInstance] sessionHandleChangeUserProperty:[TKEduSessionHandle shareInstance].localUser.peerID TellWhom:sTellAll Key:sIsInBackGround Value:@(NO) completion:nil];
        [TKEduSessionHandle shareInstance].roomMgr.inBackground = NO;
    }
    
    if(!_iRoomProperty.iHowMuchTimeServerFasterThenMe)
        return;
    
    _iRoomProperty.iCurrentTime = [[NSDate date]timeIntervalSince1970] + _iRoomProperty.iHowMuchTimeServerFasterThenMe;
    
    if ([self.iSessionHandle.roomMgr getRoomConfigration].endClassTimeFlag) {
        NSTimeInterval interval = _iRoomProperty.iEndTime -_iRoomProperty.iCurrentTime;
        NSInteger time = interval;
        //(2)未到下课时间： 老师未点下课->下课时间到->课程结束，一律离开
        //(3)到下课时间->提前5分钟给出提示语（老师，助教）->课程结束，一律离开
        if (time==300 && _iSessionHandle.localUser.role == UserType_Teacher) {
            [TKUtil showMessage:[NSString stringWithFormat:@"5%@",MTLocalized(@"Prompt.ClassEndTime")]];
        }
        if (time<=0) {
            [self showMessage:MTLocalized(@"Prompt.ClassEnd")];
            [self prepareForLeave:YES];
        }
    }
    
    //_iLocalTime = _iTKEduClassRoomProperty.iCurrentTime - _iTKEduClassRoomProperty.iStartTime;
    
    //设置当前时间
    if(!_iSessionHandle.isPlayback){
        [self.navbarView setTime:_iLocalTime];
    }
    
    [self invalidateClassReadyTime];
    if ([TKEduSessionHandle shareInstance].isClassBegin && _iUserType == UserType_Teacher) {
        
        int tDele = (int)(_iRoomProperty.iCurrentTime*1000 - _iRoomProperty.iEndTime*1000)/1000;
        //距离下课3分钟
        BOOL tEnabled;
        if ([[_iSessionHandle.roomMgr getRoomProperty].companyid isEqualToString:YLB_COMPANYID]) {
            tEnabled = _iRoomProperty.iEndTime != 0 && tDele+60 >= 0;
        } else {
            tEnabled = YES;    // 下课总是可以点击的
        }
        
        
        
        // 只有YLB显示下课提示
        if ([[_iSessionHandle.roomMgr  getRoomProperty].companyid isEqualToString:YLB_COMPANYID]) {
            //            if ((tDele >= -60) && (tDele <= -59)) {
            //
            //                tPromptType = PromptTypeEndWill1Minute;
            //                [_iClassTimeView showPromte:tPromptType aPassEndTime:1 aPromptTime:5];
            //            }else if (tDele>=180 && tDele<=181){
            //
            //                tPromptType = PromptTypeEndPass3Minute;
            //                [_iClassTimeView showPromte:tPromptType aPassEndTime:3 aPromptTime:5];
            //            }else if(tDele >=290 &&tDele<=291){
            //
            //                tPromptType = PromptTypeEndPass5Minute;
            //                [_iClassTimeView showPromte:tPromptType aPassEndTime:0 aPromptTime:10];
            //            }
            //
            //            if((tDele >60) ){
            //                tPromptType = PromptTypeEndPass;
            //                [_iClassTimeView showPromte:tPromptType aPassEndTime:0 aPromptTime:0];
            //            }
            //            //设置黄色
            //            BOOL tEnd1Minute = !(tDele>=-60 && tDele <-55) && (tDele>-55)&& (tDele<0);
            //            if ((tEnd1Minute)) {
            //
            //                tPromptType = PromptTypeEndWill1Minute;
            //                [_iClassTimeView showPromte:tPromptType aPassEndTime:0 aPromptTime:0];
            //            }
        }
        
        // 下课时间到，下课（只有英联邦下课时间到才下课）
        if (tDele>300 && [[_iSessionHandle.roomMgr  getRoomProperty].companyid isEqualToString:YLB_COMPANYID]) {
            
            [[TKEduSessionHandle shareInstance]configureHUD:@"" aIsShow:YES];
            
            
            [TKEduNetManager classBeginEnd:[TKEduSessionHandle shareInstance].iRoomProperties.iRoomId companyid:[TKEduSessionHandle shareInstance].iRoomProperties.iCompanyID aHost:[TKEduSessionHandle shareInstance].iRoomProperties.sWebIp aPort:[TKEduSessionHandle shareInstance].iRoomProperties.sWebPort aComplete:^int(id  _Nullable response) {
                
                
                [[TKEduSessionHandle shareInstance] sessionHandleDelMsg:sClassBegin ID:sClassBegin To:sTellAll Data:@{} completion:nil];
                
                
                [[TKEduSessionHandle shareInstance]configureHUD:@"" aIsShow:NO];
                
                return 0;
            } aNetError:^int(id  _Nullable response) {
                
                [[TKEduSessionHandle shareInstance]configureHUD:@"" aIsShow:NO];
                
                return 0;
            }];
            
        }
    }
    _iLocalTime ++;
    
}
-(void)invalidateClassBeginTime{
    
    if (_iClassTimetimer) {
        [_iClassTimetimer invalidate];
        _iLocalTime = 0;
        _iClassTimetimer = nil;
    }
    
}
- (void)invalidateClassCurrentTime{
    if (_iClassCurrentTimer) {
        [_iClassCurrentTimer invalidate];
        _iClassCurrentTimer = nil;
    }
}

-(void)startClassBeginTimer{
    _iLocalTime = 0;
    [_iClassTimetimer setFireDate:[NSDate date]];
    [self invalidateClassReadyTime];
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"roomController----dealloc");
}


#pragma mark 上传图片
// 老师端。文档列表页上传图片
- (void)uploadPhotos:(NSNotification *)notify
{
    
    if ([notify.object isEqualToString:sTakePhotosUploadNotification]) {
        //拍照上传
        [self chooseAction:1 delay:NO];
    }else if ([notify.object isEqualToString:sChoosePhotosUploadNotification])
    {
        //从图库上传
        [self chooseAction:0 delay:YES];
    }
}

-(void)chooseAction:(int)buttonIndex delay:(BOOL)delay
{ 
    if (buttonIndex == 0) {
        // 打开相册
        //资源类型为图片库
        _iPickerController = [[TKImagePickerController alloc] init];
        [_iPickerController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        _iPickerController.navigationBar.tintColor = RGBCOLOR(255, 255, 255);
        _iPickerController.navigationBar.barTintColor = RGBCOLOR(42, 180, 242);
        
        _iPickerController.navigationBar.alpha = 1;
        _iPickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //设置选择后的图片可被编辑
        _iPickerController.allowsEditing = false;
        
        _iPickerController.delegate = self;
        if (delay) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self presentViewController:_iPickerController
                                   animated:true
                                 completion:nil];
            });
        } else {
            [self presentViewController:_iPickerController
                               animated:true
                             completion:nil];
        }
        
    } else if (buttonIndex == 1) {
        //拍照
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        //判断是否有相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (authStatus == AVAuthorizationStatusAuthorized) {
                _iPickerController = [[UIImagePickerController alloc] init];
                //设置拍照后的图片可被编辑
                //资源类型为照相机
                _iPickerController.sourceType = sourceType;
                [[TKEduSessionHandle shareInstance] sessionHandleEnableVideo:NO];
                
                _iPickerController.delegate = self;
                [self presentViewController:_iPickerController
                                   animated:true
                                 completion:nil];
                
            } else {
                TKLog(@"该设备无摄像头");
                
                TKAlertView *alert = [[TKAlertView alloc]initWithTitle:@"" contentText:MTLocalized(@"Prompt.NeedCamera") confirmTitle:MTLocalized(@"Prompt.Sure")];
                [alert show];
                
            }
        } else {
            TKLog(@"该设备无摄像头");
            TKAlertView *alert = [[TKAlertView alloc]initWithTitle:@"" contentText:MTLocalized(@"Prompt.NeedCamera") confirmTitle:MTLocalized(@"Prompt.Sure")];
            [alert show];
        }
    }
    
}




- (void)cancelUpload
{
    [self removProgressView];
    
}
- (void)removProgressView {
    if (_uploadImageView) {
        [_uploadImageView removeFromSuperview];
        _uploadImageView = nil;
        _iPickerController = nil;
    }
}



#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [[TKEduSessionHandle shareInstance]sessionHandleEnableVideo:YES];
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    UIImage *img;
    if (picker.allowsEditing)
        img = [info objectForKey:UIImagePickerControllerEditedImage];
    else
        img = [info objectForKey:UIImagePickerControllerOriginalImage];
    img = [UIImage fixOrientation:img];
    _progress = 0;
    dispatch_async(dispatch_get_main_queue(), ^{
        [picker dismissViewControllerAnimated:YES completion:nil];
        _iPickerController = nil;
        
        //[HUD hide:YES];
        //HUD = nil;
        if (!_uploadImageView) {
            _uploadImageView = [[TKUploadImageView alloc]
                                initWithImage:img];
            
            _uploadImageView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
            _uploadImageView.layer.masksToBounds = YES;
            _uploadImageView.layer.cornerRadius = 4;
            _uploadImageView.layer.borderWidth = 2.f;
            _uploadImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
            _uploadImageView.userInteractionEnabled = YES;
            //[self.view addSubview:_uploadImageView];
            _uploadImageView.target = self;
            _uploadImageView.action = @selector(cancelUpload);
            [_uploadImageView setProgress:0];
            
        }
    });
    
    tk_weakify(self);
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset) {
        
        //       昵称_入口_年-月-日_时_分_秒
        NSString *fileName  = [NSString stringWithFormat:@"%@_%@_%@.JPG",[TKEduSessionHandle shareInstance].localUser.nickName,sMobile, [TKUtil getCurrentDateTime]];
        
        NSData *imgData = UIImageJPEGRepresentation(img, 0.5);
        tk_strongify(weakSelf);
        
        [TKEduNetManager uploadWithaHost:[TKEduSessionHandle shareInstance].iRoomProperties.sWebIp aPort:[TKEduSessionHandle shareInstance].iRoomProperties.sWebPort roomID:[TKEduSessionHandle shareInstance].iRoomProperties.iRoomId fileData:imgData fileName:fileName fileType:@"JPG" userName:[TKEduSessionHandle shareInstance].localUser.nickName userID:[TKEduSessionHandle shareInstance].localUser.peerID delegate:strongSelf];
        
    };
    
    ALAssetsLibrary *assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:imageURL
                   resultBlock:resultblock
                  failureBlock:^(NSError *error) {
                      TKLog(@"获取图片失败");
                      
                  }];
    
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [[TKEduSessionHandle shareInstance]sessionHandleEnableVideo:YES];
        _iPickerController = nil;
        [self refreshUI];
        //[_session resumeLocalCamera];
    }];
    
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}

- (void)uploadProgress:(int)req totalBytesSent:(int64_t)totalBytesSent bytesTotal:(int64_t)bytesTotal{
    float progress = totalBytesSent/bytesTotal;
    [_uploadImageView setProgress:progress];
}

- (void)uploadFileResponse:(id _Nullable )Response req:(int)req{
    if (Response == nil && req == -1) {
        [self showMessage:MTLocalized(@"UploadPhoto.Error")];
    }
    if (!req && [Response isKindOfClass:[NSDictionary class]]) {
        NSDictionary *tFileDic = (NSDictionary *)Response;
        TKDocmentDocModel *tDocmentDocModel = [[TKDocmentDocModel alloc]init];
        [tDocmentDocModel setValuesForKeysWithDictionary:tFileDic];
        [tDocmentDocModel dynamicpptUpdate];
        tDocmentDocModel.filetype = @"jpeg";
        [[TKEduSessionHandle shareInstance] addOrReplaceDocmentArray:tDocmentDocModel];
        [[TKEduSessionHandle shareInstance].whiteBoardManager addDocumentWithFile:[TKModelToJson getObjectData:tDocmentDocModel]];
        [[TKEduSessionHandle shareInstance] addDocMentDocModel:tDocmentDocModel To:sTellAllExpectSender];
        [[TKEduSessionHandle shareInstance] publishtDocMentDocModel:tDocmentDocModel To:sTellAllExpectSender aTellLocal:YES];
        [self removProgressView];
        [[TKEduSessionHandle shareInstance] sessionHandleEnableVideo:YES];
        
    }
}
- (void)getMeetingFileResponse:(id _Nullable )Response{
    
}



-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([@"idleTimerDisabled" isEqualToString:keyPath] && [TKEduSessionHandle shareInstance].iIsJoined && ![[change objectForKey:@"new"]boolValue]) {
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    }
    
}

- (void)changeServer:(NSString *)server {
    if ([server isEqualToString:self.currentServer]) {
        return;
    }
    self.currentServer = server;
    [[NSUserDefaults standardUserDefaults] setObject:self.currentServer forKey:@"server"];
}


#pragma mark Private
//判断设备时间
- (void)judgeDeviceTime  {
    NSTimeInterval time = [TKUtil getNowTimeTimestamp];
    TKRoomProperty *property = [_iSessionHandle.roomMgr getRoomProperty];
    [TKEduNetManager systemtime:self.iParamDic Complete:^int(id  _Nullable response) {
        double timeDiff = [property.endtime doubleValue]-time;
        
        NSString *systemtime = [TKUtil getData:response[@"time"]];
        NSString *devicetime = [TKUtil getData:[NSString stringWithFormat:@"%f",time]];
        
        if (timeDiff < 0 && ![systemtime isEqualToString:devicetime]) {
            [self showMessage:MTLocalized(@"Prompt.TimeError")];
            [self prepareForLeave:YES];
        }
        return 0;
    } aNetError:^int(id  _Nullable response) {
        
        return 0;
    }];
}
// 获取礼物数
- (void)getTrophyNumber {
    // 老师不需要获取礼物
    if (_iSessionHandle.localUser.role != UserType_Student || _iSessionHandle.isPlayback == YES) {
        return;
    }
    
    // 学生断线重连需要获取礼物
    [TKEduNetManager getGiftinfo:_iRoomProperty.iRoomId aParticipantId: _iRoomProperty.iUserId  aHost:_iRoomProperty.sWebIp aPort:_iRoomProperty.sWebPort aGetGifInfoComplete:^(id  _Nullable response) {
        dispatch_async(dispatch_get_main_queue(), ^{
            int result = 0;
            result = [[response objectForKey:@"result"]intValue];
            if (!result || result == -1) {
                
                NSArray *tGiftInfoArray = [response objectForKey:@"giftinfo"];
                int giftnumber = 0;
                for(int  i = 0; i < [tGiftInfoArray count]; i++) {
                    if (![_iRoomProperty.iUserId isEqualToString:@"0"] && _iRoomProperty.iUserId) {
                        NSDictionary *tDicInfo = [tGiftInfoArray objectAtIndex: i];
                        if ([[tDicInfo objectForKey:@"receiveid"] isEqualToString:_iRoomProperty.iUserId]) {
                            giftnumber = [tDicInfo objectForKey:@"giftnumber"] ? [[tDicInfo objectForKey:@"giftnumber"] intValue] : 0;
                            break;
                        }
                    }
                }
                
                self.iSessionHandle.localUser.properties[sGiftNumber] = @(giftnumber);
                [_iSessionHandle sessionHandleChangeUserProperty:self.iSessionHandle.localUser.peerID TellWhom:sTellAll Key:sGiftNumber Value:@(giftnumber) completion:nil];
            }
        });
        
    } aGetGifInfoError:^int(NSError * _Nullable aError) {
        TKLog(@"获取奖杯数量失败");
        return -1;
    }];
    
}

- (void)quitClearData {
    [[TKEduSessionHandle shareInstance]configureDraw:false isSend:NO to:sTellAll peerID:[TKEduSessionHandle shareInstance].localUser.peerID];
    [[TKEduSessionHandle shareInstance].whiteBoardManager roomWhiteBoardOnDisconnect:nil];
    [_iSessionHandle clearAllClassData];
    [_iSessionHandle.whiteBoardManager resetWhiteBoardAllData];
    [self clearVideoViewData:_iTeacherVideoView];
    [self clearVideoViewData:_iOurVideoView];
    [_iPlayVideoViewDic removeAllObjects];
    
    // 播放的MP4前，先移除掉上一个MP4窗口
    if (self.iMediaView) {
        [self.iMediaView removeFromSuperview];
        self.iMediaView = nil;
    }
    
    if (self.iScreenView) {
        [self.iScreenView removeFromSuperview];
        self.iScreenView = nil;
    }
    
}
@end
