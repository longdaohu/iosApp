//
//  RoomController.m
//  classdemo
//
//  Created by mac on 2017/4/28.
//  Copyright © 2017年 talkcloud. All rights reserved.
//
// change openurl

#import <objc/message.h>

#import "TKOneToMoreRoomController.h"
#import "TKEduSessionHandle.h"
#import "TKImagePickerController.h"
#import "TKNavView.h"
#import "TKTabbarView.h"

#import "TKListView.h" //文档、媒体
#import "TKChatView.h" //聊天视图
#import "TKControlView.h"//控制按钮视图
#import "TKUserListView.h"//用户列表视图

//reconnection
#import "TKTimer.h"
#import "TKHUD.h"
#import "TKRCGlobalConfig.h"

#import "TKUtil.h"
#import "TKEduSessionHandle.h"
#import "TKVideoSmallView.h"
#import "TKSplitScreenView.h"

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

static const CGFloat sRightWidth          = 236;
static const CGFloat sViewCap             = 10;

static const CGFloat sStudentVideoViewHeigh     = 112;
static const CGFloat sStudentVideoViewWidth     = 120;

@interface TKOneToMoreRoomController() <TKEduBoardDelegate,TKEduSessionDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate,CAAnimationDelegate,UIImagePickerControllerDelegate,TKEduNetWorkDelegate,UINavigationControllerDelegate>
{
    CGFloat _maxVideo;
    CGFloat _sBottomViewHeigh;
    CGFloat _sStudentVideoViewHeigh;
    CGFloat _sStudentVideoViewWidth;
    
    CGRect videoOriginFrame;      // 画中画视频初始frame
    UIView *videoOriginSuperView; // 画中画视频初始父视图
    BOOL isFullPIP;               // 是否全屏同步
}

@property (nonatomic, assign) BOOL isConnect;

//视频的宽高属性
@property (nonatomic, strong) NSTimer *iClassCurrentTimer;
@property (nonatomic, strong) NSTimer *iClassTimetimer;

@property (nonatomic, assign) NSInteger tabbarHeight;//tabbar高度
@property (nonatomic, assign) NSInteger navbarHeight;//navbar高度
@property (nonatomic, strong) TKNavView *navbarView;//导航
@property (nonatomic, strong) TKTabbarView *tabbarView;
@property (nonatomic, strong) TKListView *listView;//课件库
@property (nonatomic, strong) TKUserListView *userListView;//控制按钮视图
@property (nonatomic, strong) TKChatView *chatView;//聊天视图
@property (nonatomic, strong) TKControlView *controlView;//控制按钮视图

//移动
@property(nonatomic,assign)CGPoint iStrtCrtVideoViewP;


@property (nonatomic, strong) TKWhiteBoardView *iTKEduWhiteBoardView;//白板视图

@property (nonatomic, assign) RoomType iRoomType;//当前会议室
@property (nonatomic, assign) UserType iUserType;//当前身份
@property (nonatomic, assign) NSDictionary* iParamDic;//加入会议paraDic

@property(nonatomic,retain)UIView   *iBottomView;//视频视图
@property (nonatomic, strong) TKBaseMediaView *iScreenView;//共享桌面
@property (nonatomic, strong) TKBaseMediaView *iFileView;//共享电影
@property (nonatomic, strong) TKEduSessionHandle *iSessionHandle;
@property (nonatomic, strong) TKEduRoomProperty *iRoomProperty;//课堂数进行
@property (nonatomic, strong) NSMutableDictionary    *iPlayVideoViewDic;//播放的视频view的字典

//视频相关
@property (nonatomic, strong) TKVideoSmallView *iTeacherVideoView;//老师视频
@property (nonatomic, strong) NSMutableArray  *iStudentVideoViewArray;//存放学生视频数组
@property (nonatomic, strong) TKSplitScreenView *splitScreenView;//分屏视图
@property (nonatomic, strong) NSMutableArray  *iStudentSplitViewArray;//存放学生视频数组
@property (nonatomic, strong) NSMutableArray  *iStudentSplitScreenArray;//存放学生分屏视频数组
@property (nonatomic, strong) NSDictionary    *iScaleVideoDict;//记录缩放的视频
@property (nonatomic, assign) BOOL            addVideoBoard;
@property (nonatomic, assign) BOOL            isLocalPublish;

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
//@property (nonatomic, strong) TKEduNetManager * requestManager;
@end


@implementation TKOneToMoreRoomController

//iOS8.0以上手机横屏后会自动隐藏电池栏,需要设置一下方法不进行隐藏
//-(void)setNeedsStatusBarAppearanceUpdate {
//    TKLog(@"---self setNeedsStatusBarAppearanceUpdate---");
//}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
#pragma mark 状态栏
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
        
        //FIXME:todo
        
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isConnect = NO;
    
    [[TKEduSessionHandle shareInstance] sessionHandleSetDeviceOrientation:(UIDeviceOrientationLandscapeLeft)];
    [TKHelperUtil phontLibraryAction];
    
    _iShow     = false;
    _iUserType = _iRoomProperty.iUserType;
    _iRoomType = _iRoomProperty.iRoomType;
    
    self.backgroundImageView.contentMode =  UIViewContentModeScaleToFill;
    self.backgroundImageView.sakura.image(@"ClassRoom.backgroundImage");
    
    //课堂中的视频分辨率
    CGFloat dpi = [TKHelperUtil returnClassRoomDpi];
    [TKHelperUtil setVedioProfile];
    
    CGFloat screenWidth = [TKUtil isiPhoneX]?ScreenW-60:ScreenW;
    
    //重新计算sBottomViewHeigh高度
    _sStudentVideoViewWidth =(screenWidth-sViewCap*(7+1))/7;
    _sStudentVideoViewHeigh =_sStudentVideoViewWidth/4.0*3.0+_sStudentVideoViewWidth/4*3/7;
    //    _sBottomViewHeigh = _sStudentVideoViewHeigh+2*sViewCap;
    
    self.tabbarHeight = [TKUtil isiPhoneX]?(_sStudentVideoViewHeigh) * 0.4+17:_sStudentVideoViewHeigh * 0.4;
    self.navbarHeight = IS_IPHONE?34:_sStudentVideoViewHeigh * 0.4;
    //    self.navbarHeight = _sStudentVideoViewHeigh * 0.4;
    
    // 最大视频数量
    _maxVideo = _iRoomProperty.iMaxVideo.intValue > 7 ? 13 : 7;
    
    _sStudentVideoViewWidth =(screenWidth-sViewCap*(_maxVideo+1))/_maxVideo;
    _sStudentVideoViewHeigh =_sStudentVideoViewWidth*dpi+_sStudentVideoViewWidth*dpi/7;
    _sBottomViewHeigh = _sStudentVideoViewHeigh+2*sViewCap;
    
    
    NSLog(@"%f,%f",_sStudentVideoViewHeigh,_sStudentVideoViewWidth);
    
    //初始化导航栏
    [self initNavigation];
    //初始化tabbar
    [self initTabbar];
    
    //初始化
    _iStudentVideoViewArray = [NSMutableArray arrayWithCapacity:_iRoomProperty.iMaxVideo.intValue];
    _iStudentSplitScreenArray = [NSMutableArray arrayWithCapacity:_iRoomProperty.iMaxVideo.intValue];
    _iStudentSplitViewArray =[NSMutableArray arrayWithCapacity:_iRoomProperty.iMaxVideo.intValue];
    _iPlayVideoViewDic = [[NSMutableDictionary alloc]initWithCapacity:10];
    _iScaleVideoDict = [NSDictionary dictionary];
    
    
    [self initVideoView];
    
    [self initBottomView];
    
    [self initWhiteBoardView];//初始化白板
    [self initSplitScreenView];//初始化分屏视图
    [self initTapGesTureRecognizer];
    
    [self createTimer];
    [self.backgroundImageView bringSubviewToFront:_iTKEduWhiteBoardView];
    
    
    [[TKEduSessionHandle shareInstance] configureHUD:MTLocalized(@"HUD.EnteringClass") aIsShow:YES];
    [self initAudioSession];
    
    // 如果是回放，那么放上遮罩页
    if (_iSessionHandle.isPlayback == YES) {
        [self initPlaybackMaskView];
    }
    
    // 默认老师视频尺寸
    videoOriginFrame = _iTeacherVideoView.frame;
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear: animated];
    
    [self addNotification];
    
    if (!_iCheckPlayVideotimer) {
        [self createTimer];
    }
    [self setNeedsStatusBarAppearanceUpdate];
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
            ((void(*)(id,SEL,NSString *,BOOL))objc_msgSend)(self, funcSel , str,inList);
            
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
    //白板全屏的通知
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
    
    //不自动锁屏
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
#pragma mark - fullScreen白板全屏
-(void)whiteBoardFullScreen:(NSNotification*)aNotification{
    
    if (self.listView) {
        [self.listView hidden];
        self.tabbarView.coursewareButton.selected = NO;
        self.listView = nil;
    }
    
    if (self.controlView) {
        [self.controlView hidden];
        self.tabbarView.controlButton.selected = NO;
        self.controlView = nil;
    }
    
    if (self.userListView) {
        [self.userListView hidden];
        self.tabbarView.memberButton.selected = NO;
        self.userListView = nil;
    }
    
    if (self.chatView) {
        [self.chatView hidden];
        self.tabbarView.messageButton.selected = NO;
        self.chatView = nil;
    }
    
    bool isFull = [aNotification.object boolValue];
    
    [TKEduSessionHandle shareInstance].iIsFullState = isFull;
    
    if (isFull) {
        self.splitScreenView.hidden = YES;
        CGRect tFrame = CGRectMake([TKUtil isiPhoneX]?30:0, 0,[TKUtil isiPhoneX]?ScreenW-60:ScreenW, ScreenH - CGRectGetMaxY(_navbarView.frame) );
        
        self.iTKEduWhiteBoardView.frame = tFrame;
        
        [self.backgroundImageView bringSubviewToFront:self.iTKEduWhiteBoardView];
        [self.iSessionHandle.whiteBoardManager refreshWhiteBoard];
    }else{
        if (_iStudentSplitScreenArray.count>0) {
            
            self.splitScreenView.hidden = NO;
        }else{
            
            self.splitScreenView.hidden = YES;
        }
        
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
    __weak TKOneToMoreRoomController * roomVC = self;
    
    self.navbarView.leaveButtonBlock = ^{//离开课堂 （返回)
        //        [roomVC.iSessionHandle.whiteBoardManager webViewreload];
        //        return;
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
            [[TKEduSessionHandle shareInstance].whiteBoardManager changeDocumentWithFileID:[[TKEduSessionHandle shareInstance] getClassOverDocument].fileid isBeginClass:[TKEduSessionHandle shareInstance].isClassBegin isPubMsg:YES];
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
    if(_iSessionHandle.isPlayback){
        self.tabbarView.hidden = YES;
    }else{
        
    }
    __weak TKOneToMoreRoomController * roomVC = self;
    
    self.tabbarView.showCoursewareViewBlock = ^(BOOL isSelected) {//课件库按钮
        
        if (isSelected) {
            if (!roomVC.listView) {
                
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
                
                if (roomVC.chatView) {
                    [roomVC.chatView hidden];
                    roomVC.tabbarView.messageButton.selected = NO;
                    roomVC.chatView = nil;
                }
                // 隐藏工具箱
                [[TKEduSessionHandle shareInstance].whiteBoardManager showToolbox:NO];
                roomVC.tabbarView.toolsButton.selected = NO;
                
                //文件列表：            宽 7/10  高 9/10
                CGFloat showHeight = roomVC.iTKEduWhiteBoardView.height*(9/10.0);
                CGFloat showWidth = roomVC.iTKEduWhiteBoardView.width * (7/10.0);
                CGFloat x = (roomVC.iTKEduWhiteBoardView.width-showWidth)/2.0;
                CGFloat y = (roomVC.iTKEduWhiteBoardView.height-showHeight)/2.0;
                
                roomVC.listView = [[TKListView alloc]initWithFrame:CGRectMake(x,y, showWidth, showHeight) andTitle:@"dd" from:@"TKOneToMoreRoomController"];
                
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
            roomVC.tabbarView.showRedDot = NO;
            
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
                
                //花名册：宽 7/10  高 9/10
                CGFloat showHeight = roomVC.iTKEduWhiteBoardView.height*(9/10.0);
                CGFloat showWidth = roomVC.iTKEduWhiteBoardView.width * (7/10.0);
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
                
                if (roomVC.userListView) {
                    [roomVC.userListView hidden];
                    roomVC.tabbarView.memberButton.selected = NO;
                    roomVC.userListView = nil;
                }
                
                if (roomVC.controlView) {
                    [roomVC.controlView hidden];
                    roomVC.tabbarView.controlButton.selected = NO;
                    roomVC.controlView = nil;
                }
                
                // 隐藏工具箱
                [[TKEduSessionHandle shareInstance].whiteBoardManager showToolbox:NO];
                roomVC.tabbarView.toolsButton.selected = NO;
                
                //聊天弹框：           宽 8/10  高 10/10
                CGFloat showHeight = roomVC.iTKEduWhiteBoardView.height * (9/10.0);
                CGFloat showWidth = roomVC.iTKEduWhiteBoardView.width * (6/10.0);
                CGFloat x = (roomVC.iTKEduWhiteBoardView.width-showWidth)/2.0;
                CGFloat y = (roomVC.iTKEduWhiteBoardView.height-showHeight)/2.0;
                
                roomVC.chatView = [[TKChatView alloc]initWithFrame:CGRectMake(x,y,showWidth,showHeight) chatController:@"TKOneToMoreRoomController"];
                roomVC.chatView.titleText = MTLocalized(@"Label.messageBoard");
                roomVC.chatView.dismissBlock = ^{
                    
                    roomVC.tabbarView.messageButton.selected = NO;
                    roomVC.chatView = nil;
                };
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
                
                if (roomVC.userListView) {
                    [roomVC.userListView hidden];
                    roomVC.tabbarView.memberButton.selected = NO;
                    roomVC.userListView = nil;
                }
                
                if (roomVC.chatView) {
                    [roomVC.chatView hidden];
                    roomVC.tabbarView.messageButton.selected = NO;
                    roomVC.chatView = nil;
                }
                // 隐藏工具箱
                [[TKEduSessionHandle shareInstance].whiteBoardManager showToolbox:NO];
                roomVC.tabbarView.toolsButton.selected = NO;
                
                //所有操作弹框：宽 5/10  高 8/10
                CGFloat showHeight = roomVC.iTKEduWhiteBoardView.height*(9/10.0);
                //                CGFloat showWidth = roomVC.iTKEduWhiteBoardView.width * (7/10.0);
                CGFloat showWidth = showHeight*1.4;
                CGFloat x = (roomVC.iTKEduWhiteBoardView.width-showWidth)/2.0;
                CGFloat y = (roomVC.iTKEduWhiteBoardView.height-showHeight)/2.0;
                roomVC.controlView = [[TKControlView alloc] initWithFrame:CGRectMake(x,y,showWidth,showHeight) controlController:@"TKOneToMoreRoomController"];
                
                roomVC.controlView.resetBlock = ^{//全部恢复
                    [[TKEduSessionHandle shareInstance] sessionHandleDelMsg:sVideoSplitScreen ID:sVideoSplitScreen To:sTellAllExpectSender Data:@{} completion:nil];
                    
                    NSArray *sArray = [NSArray arrayWithArray:roomVC.iStudentSplitViewArray];
                    for (TKVideoSmallView *view in sArray) {
                        
                        view.isSplit = YES;
                        [roomVC beginTKSplitScreenView:view];
                        
                        
                    }
                    
                    //将拖拽的视频还原
                    for (TKVideoSmallView *view  in roomVC.iStudentVideoViewArray) {
                        
                        [roomVC updateMvVideoForPeerID:view.iPeerId];
                        view.isDrag = NO;
                    }
                    
                    [roomVC sendMoveVideo:roomVC.iPlayVideoViewDic aSuperFrame:roomVC.iTKEduWhiteBoardView.frame allowStudentSendDrag:NO];
                    
                    [roomVC refreshBottom];
                };
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
        if (isSelected) {
            if (roomVC.listView) {
                [roomVC.listView hidden];
                roomVC.tabbarView.coursewareButton.selected = NO;
                roomVC.listView = nil;
            }
            
            if (roomVC.userListView) {
                [roomVC.userListView hidden];
                roomVC.tabbarView.memberButton.selected = NO;
                roomVC.userListView = nil;
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
        }else {
            
        }
        
        
        
    };
    
    
    
}


-(void)refreshUI{
    
    if (self.iPickerController) {
        return;
    }
    
    if ([TKEduSessionHandle shareInstance].iStdOutBottom) {
        
        [self refreshBottom];
        
    }
    //多人时 bottom和whiteview
    {
        
        [self refreshWhiteBoard:YES];
        [self refreshBottom];
        [self sScaleVideo:self.iScaleVideoDict];
        [self moveVideo:self.iMvVideoDic];
        [self sVideoSplitScreen:self.iStudentSplitScreenArray];
        
    }
    
}

-(void)initVideoView{
    CGFloat tVideoWidth = _sStudentVideoViewWidth *1.6;
    CGFloat tVideoX = ScreenW - tVideoWidth-10;
    CGFloat tVideoY = CGRectGetMaxY(_navbarView.frame)+15;
    
    
    //老师
    {
        CGFloat tTeacherVideoViewWidth = _sStudentVideoViewWidth;
        
        CGFloat tTeacherVideoViewHeight = _sStudentVideoViewHeigh;
        
        {
            self.iTeacherVideoView= ({
                
                TKVideoSmallView *tTeacherVideoView = [[TKVideoSmallView alloc]initWithFrame:CGRectMake(tVideoX, tVideoY, tTeacherVideoViewWidth, tTeacherVideoViewHeight) aVideoRole:EVideoRoleTeacher];
                tTeacherVideoView.iPeerId = @"";
                tTeacherVideoView.isDrag = NO;
                tTeacherVideoView.isSplit = NO;
                tTeacherVideoView.iVideoViewTag = -1;
                tTeacherVideoView.isNeedFunctionButton = (self.iUserType==UserType_Teacher);
                tTeacherVideoView.iEduClassRoomSessionHandle = self.iSessionHandle;
                tTeacherVideoView;
                
                
            });
            
            __weak typeof(self) weakSelf = self;
            
            self.iTeacherVideoView.isWhiteboardContainsSelfBlock = ^BOOL{
                return CGRectContainsRect(weakSelf.iTKEduWhiteBoardView.frame, weakSelf.iTeacherVideoView.frame);
            };
            // 接收到调整大小的信令
            self.iTeacherVideoView.onRemoteMsgResizeVideoViewBlock = ^CGRect(CGFloat scale) {
                
                CGRect wbRect = weakSelf.iTKEduWhiteBoardView.frame;
                CGRect videoRect = weakSelf.iTeacherVideoView.frame;
                CGFloat height = weakSelf.iTeacherVideoView.originalHeight * scale;
                CGFloat width = weakSelf.iTeacherVideoView.originalWidth *scale;
                CGPoint oldCenter = weakSelf.iTeacherVideoView.center;
                
                
                // top 1, right 2, bottom 3, left 4
                NSInteger vcrossEdge = 0;
                NSInteger hcrossEdge = 0;
                if (videoRect.origin.x <= wbRect.origin.x) {
                    // 垂直边左相交
                    vcrossEdge = 4;
                }
                if (videoRect.origin.x + videoRect.size.width >= wbRect.origin.x + wbRect.size.width) {
                    // 垂直边右相交
                    vcrossEdge = 2;
                }
                if (videoRect.origin.y <= wbRect.origin.y) {
                    // 水平便顶相交
                    hcrossEdge = 1;
                }
                if (videoRect.origin.y + videoRect.size.height >= wbRect.origin.y + wbRect.size.height) {
                    // 水平便底相交
                    hcrossEdge = 3;
                }
                
                if (vcrossEdge == 0 && hcrossEdge == 0) {
                    CGRectMake(oldCenter.x - width/2.0, oldCenter.y - height/2.0, width, height);
                }
                
                if (vcrossEdge == 0 && hcrossEdge == 1) {
                    CGFloat x = oldCenter.x - width / 2.0;
                    CGFloat y = wbRect.origin.y;
                    return CGRectMake(x, y, width, height);
                }
                
                if (vcrossEdge == 0 && hcrossEdge == 3) {
                    CGFloat x = oldCenter.x - width / 2.0;
                    CGFloat y = wbRect.origin.y + wbRect.size.height - height;
                    return CGRectMake(x, y, width, height);
                }
                
                if (vcrossEdge == 2 && hcrossEdge == 0) {
                    CGFloat x = wbRect.origin.x + wbRect.size.width - width;
                    CGFloat y = oldCenter.y - height / 2.0;
                    return CGRectMake(x, y, width, height);
                }
                
                if (vcrossEdge == 4 && hcrossEdge == 0) {
                    CGFloat x = wbRect.origin.x;
                    CGFloat y = oldCenter.y - height / 2.0;
                    return CGRectMake(x, y, width, height);
                }
                
                if (vcrossEdge == 4 && hcrossEdge == 1) {
                    CGFloat x = wbRect.origin.x;
                    CGFloat y = wbRect.origin.y;
                    return CGRectMake(x, y, width, height);
                }
                
                if (vcrossEdge == 4 && hcrossEdge == 3) {
                    CGFloat x = wbRect.origin.x;
                    CGFloat y = wbRect.origin.y + wbRect.size.height - height;
                    return CGRectMake(x, y, width, height);
                }
                
                if (vcrossEdge == 2 && hcrossEdge == 1) {
                    CGFloat x = wbRect.origin.x + wbRect.size.width - width;
                    CGFloat y = wbRect.origin.y;
                    return CGRectMake(x, y, width, height);
                }
                
                if (vcrossEdge == 2 && hcrossEdge == 3) {
                    CGFloat x = wbRect.origin.x + wbRect.size.width - width;
                    CGFloat y = wbRect.origin.y + wbRect.size.height - height;
                    return CGRectMake(x, y, width, height);
                }
                
                return CGRectMake(oldCenter.x - width/2.0, oldCenter.y - height/2.0, width, height);
            };
            
            // 当缩放的视频窗口超出白板区域，调整视频窗口大小
            self.iTeacherVideoView.resizeVideoViewBlock = ^CGRect{
                CGRect wbRect = weakSelf.iTKEduWhiteBoardView.frame;
                CGRect videoRect = weakSelf.iTeacherVideoView.frame;
                CGFloat height = 0;
                CGFloat width = 0;
                
                // 如果横边和竖边都相交
                if ((videoRect.origin.x + videoRect.size.width > wbRect.origin.x + wbRect.size.width || videoRect.origin.x < wbRect.origin.x) &&
                    (videoRect.origin.y + videoRect.size.height > wbRect.origin.y + wbRect.size.height || videoRect.origin.y < wbRect.origin.y)) {
                    width = (weakSelf.iTeacherVideoView.center.x - wbRect.origin.x) <= (wbRect.origin.x + wbRect.size.width - weakSelf.iTeacherVideoView.center.x) ? (weakSelf.iTeacherVideoView.center.x - wbRect.origin.x) * 2 : (wbRect.origin.x + wbRect.size.width - weakSelf.iTeacherVideoView.center.x) * 2;
                    height = (weakSelf.iTeacherVideoView.center.y - wbRect.origin.y) <= (wbRect.origin.y + wbRect.size.height - weakSelf.iTeacherVideoView.center.y) ? (weakSelf.iTeacherVideoView.center.y - wbRect.origin.y) * 2 : (wbRect.origin.y + wbRect.size.height - weakSelf.iTeacherVideoView.center.y) * 2;
                    if (width <= height * sStudentVideoViewWidth / sStudentVideoViewHeigh) {
                        height = width * sStudentVideoViewHeigh / sStudentVideoViewWidth;
                        return CGRectMake(weakSelf.iTeacherVideoView.center.x - width / 2.0, weakSelf.iTeacherVideoView.center.y - height / 2.0, width, height);
                    }
                    
                    if (height <= width * sStudentVideoViewHeigh / sStudentVideoViewWidth) {
                        width = height * sStudentVideoViewWidth / sStudentVideoViewHeigh;
                        return CGRectMake(weakSelf.iTeacherVideoView.center.x - width / 2.0, weakSelf.iTeacherVideoView.center.y - height / 2.0, width, height);
                    }
                    
                    return CGRectMake(weakSelf.iTeacherVideoView.center.x - width / 2.0, weakSelf.iTeacherVideoView.center.y - height / 2.0, width, height);
                }
                
                // 如果是竖边界相交
                if (videoRect.origin.x + videoRect.size.width > wbRect.origin.x + wbRect.size.width ||
                    videoRect.origin.x < wbRect.origin.x) {
                    width = (weakSelf.iTeacherVideoView.center.x - wbRect.origin.x) <= (wbRect.origin.x + wbRect.size.width - weakSelf.iTeacherVideoView.center.x) ? (weakSelf.iTeacherVideoView.center.x - wbRect.origin.x) * 2 : (wbRect.origin.x + wbRect.size.width - weakSelf.iTeacherVideoView.center.x) * 2;
                    height = width * sStudentVideoViewHeigh / sStudentVideoViewWidth;
                    return CGRectMake(weakSelf.iTeacherVideoView.center.x - width / 2.0, weakSelf.iTeacherVideoView.center.y - height / 2.0, width, height);
                }
                
                // 如果是横边相交
                if (videoRect.origin.y + videoRect.size.height > wbRect.origin.y + wbRect.size.height ||
                    videoRect.origin.y < wbRect.origin.y) {
                    height = (weakSelf.iTeacherVideoView.center.y - wbRect.origin.y) <= (wbRect.origin.y + wbRect.size.height - weakSelf.iTeacherVideoView.center.y) ? (weakSelf.iTeacherVideoView.center.y - wbRect.origin.y) * 2 : (wbRect.origin.y + wbRect.size.height - weakSelf.iTeacherVideoView.center.y) * 2;
                    width = height * sStudentVideoViewWidth / sStudentVideoViewHeigh;
                    return CGRectMake(weakSelf.iTeacherVideoView.center.x - width / 2.0, weakSelf.iTeacherVideoView.center.y - height / 2.0, width, height);
                }
                
                return CGRectMake(weakSelf.iTeacherVideoView.center.x - width / 2.0, weakSelf.iTeacherVideoView.center.y - height / 2.0, width, height);
            };
            
            self.iTeacherVideoView.finishScaleBlock = ^{
                //缩放之后发布一下位移
                if (weakSelf.iUserType == UserType_Teacher) {
                    [weakSelf sendMoveVideo:weakSelf.iPlayVideoViewDic aSuperFrame:weakSelf.iTKEduWhiteBoardView.frame  allowStudentSendDrag:NO];
                }
                
            };
            self.iTeacherVideoView.splitScreenClickBlock = ^(EVideoRole aVideoRole) {
                //学生分屏开始
                [weakSelf beginTKSplitScreenView:weakSelf.iTeacherVideoView];
                
                NSArray *videoArray = [NSArray arrayWithArray:weakSelf.iStudentVideoViewArray];
                NSArray *array = [NSArray arrayWithArray:weakSelf.iStudentSplitScreenArray];
                for (TKVideoSmallView *view in videoArray) {
                    BOOL isbool = [weakSelf.iStudentSplitScreenArray containsObject: view.iRoomUser.peerID];
                    if (view.isDrag && !view.isSplit && !isbool && array.count>0) {
                        [weakSelf.iStudentSplitScreenArray addObject:view.iRoomUser.peerID];
                        [weakSelf beginTKSplitScreenView:view];
                    }
                }
            };
            self.iTeacherVideoView.oneKeyResetBlock = ^{//全部恢复
                
                
            };
            
            // 添加长按手势
            UILongPressGestureRecognizer * longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressClick:)];
            longGes.minimumPressDuration = 0.2;
            [self.iTeacherVideoView addGestureRecognizer:longGes];
            
            
            
        }
        
    }
    
    
}
#pragma mark - 分屏/取消分屏
- (void)beginTKSplitScreenView:(TKVideoSmallView*)videoView{
    
    if (!videoView.isSplit) {
        
        //在_iStudentVideoViewArray 中删除视图
        NSArray *videoArray = [NSArray arrayWithArray:_iStudentVideoViewArray];
        
        for (TKVideoSmallView *view in videoArray) {
            
            if (view.iVideoViewTag == videoView.iVideoViewTag) {
                
                [_iStudentVideoViewArray removeObject:view];
                
            }
        }
        
        [_iStudentSplitViewArray addObject:videoView];
        _splitScreenView.hidden = NO;
        videoView.isSplit = YES;
        [_splitScreenView addVideoSmallView:videoView];
        BOOL isbool = [_iStudentSplitScreenArray containsObject: videoView.iRoomUser.peerID];
        if (!isbool) {
            [_iStudentSplitScreenArray addObject:videoView.iRoomUser.peerID];
            
        }
        
    }else{//取消分屏
        
        
        [_iStudentVideoViewArray addObject:videoView];
        
        [_iStudentSplitScreenArray removeObject:videoView.iRoomUser.peerID];
        
        [_splitScreenView deleteVideoSmallView:videoView];
        
        [_iStudentSplitViewArray removeObject:videoView];
        
        if (_iStudentSplitScreenArray.count<=0) {
            _splitScreenView.hidden = YES;
        }
        [self sendMoveVideo:_iPlayVideoViewDic aSuperFrame:_iTKEduWhiteBoardView.frame  allowStudentSendDrag:NO];
        
        videoView.isSplit = NO;
    }
    
    videoView.isDrag = NO;
    videoView.isDragWhiteBoard = NO;
    
    if (_iUserType == UserType_Teacher) {
        NSString *str = [TKUtil dictionaryToJSONString:@{@"userIDArry":_iStudentSplitScreenArray}];
        [_iSessionHandle sessionHandlePubMsg:sVideoSplitScreen ID:sVideoSplitScreen To:sTellAllExpectSender Data:str Save:true AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
        
    }
    
    [self refreshBottom];
    
}

- (void)initWhiteBoardView
{
    
    CGFloat tWidth =  [TKUtil isiPhoneX] ? ScreenW-60:ScreenW;
    CGFloat tHeight = ScreenH - CGRectGetMaxY(self.navbarView.frame) - CGRectGetHeight(self.tabbarView.frame);
    
    CGFloat x = [TKUtil isiPhoneX]?30:0;
    
    CGRect tFrame = CGRectMake(x, CGRectGetMaxY(_navbarView.frame),tWidth, tHeight);
    
    _iTKEduWhiteBoardView = [_iSessionHandle.whiteBoardManager createWhiteBoardWithFrame:tFrame loadComponentName:TKWBMainContentComponent loadFinishedBlock:^{
        
        [[TKEduSessionHandle shareInstance].whiteBoardManager sendCacheInformation:[TKEduSessionHandle shareInstance].msgList];
        
        
    }];
    
    _iTKEduWhiteBoardView.backgroundColor = [UIColor blackColor];
    [TKEduSessionHandle shareInstance].whiteboardView = _iTKEduWhiteBoardView;
    
    [self.backgroundImageView addSubview:_iTKEduWhiteBoardView];
    
    [self refreshWhiteBoard:NO];
    
}

- (void)initSplitScreenView{
    
    CGFloat tWidth =  ScreenW-sRightWidth*Proportion;
    CGFloat tMidHeight = CGRectGetHeight(_navbarView.frame);
    CGRect tFrame = CGRectMake(0, 0, tWidth, (CGRectGetHeight(self.iTKEduWhiteBoardView.frame) - tMidHeight*2));
    self.splitScreenView = [[TKSplitScreenView alloc]initWithFrame:tFrame];
    [self.iTKEduWhiteBoardView addSubview:self.splitScreenView];
    self.splitScreenView.hidden = YES;
}

-(void)refreshWhiteBoard:(BOOL)hasAnimate{
    
    CGFloat tWidth =  [TKUtil isiPhoneX]?ScreenW-60:ScreenW;
    CGFloat tHeight = ScreenH - CGRectGetMaxY(self.navbarView.frame) - CGRectGetHeight(self.tabbarView.frame);
    
    CGFloat x = [TKUtil isiPhoneX]?30:0;
    
    CGRect tFrame = CGRectMake(x, CGRectGetMaxY(self.navbarView.frame), tWidth, tHeight);
    
    
    tFrame = CGRectMake(x, CGRectGetMaxY(self.iBottomView.frame), tWidth,ScreenH-CGRectGetMaxY(self.iBottomView.frame)- CGRectGetHeight(self.tabbarView.frame));
    
    
    // 去掉了判断1对1
    self.iBottomView.hidden = NO;
    
    [self.backgroundImageView bringSubviewToFront:self.iTKEduWhiteBoardView];
    
    if (hasAnimate) {
        [UIView animateWithDuration:0.1 animations:^{
            self.iTKEduWhiteBoardView.frame = tFrame;
            self.splitScreenView.frame = CGRectMake(0, 0, CGRectGetWidth(tFrame), CGRectGetHeight(tFrame));
            // MP3图标位置变化,但是MP4的位置不需要变化
            if (!self.iMediaView.hasVideo) {
                self.iMediaView.frame = CGRectMake(0, CGRectGetMaxY(self.iTKEduWhiteBoardView.frame)-57, CGRectGetWidth(self.iTKEduWhiteBoardView.frame), 57);
            }
            [[TKEduSessionHandle shareInstance].whiteBoardManager refreshWhiteBoard];
            
            [self refreshBottom];
            if (self.iMvVideoDic && self.iStudentSplitViewArray.count<=0) {
                [self moveVideo:self.iMvVideoDic];//视频位置会乱掉所以注释掉了
                
            }
            
        }];
    }else{
        
        self.iTKEduWhiteBoardView.frame = tFrame;
        self.splitScreenView.frame = CGRectMake(0, 0, CGRectGetWidth(tFrame), CGRectGetHeight(tFrame));
        
        [[TKEduSessionHandle shareInstance].whiteBoardManager refreshWhiteBoard];
        [self refreshBottom];
        if (self.iMvVideoDic) {
            
            [self moveVideo:self.iMvVideoDic];
            
        }
    }
}
-(void)initBottomView{
    
    
    self.iBottomView = ({
        
        UIView *tBottomView = [[UIView alloc]initWithFrame:CGRectMake([TKUtil isiPhoneX]?30:0, CGRectGetMaxY(self.navbarView.frame), [TKUtil isiPhoneX]?ScreenW-30:ScreenW, _sBottomViewHeigh)];
        tBottomView;
        
    });
    
    [self.backgroundImageView addSubview:self.iBottomView];
    
    CGFloat tWidth = _sStudentVideoViewWidth;
    CGFloat tHeight = _sStudentVideoViewHeigh;
    CGFloat tCap = sViewCap *Proportion;
    CGFloat w = ((ScreenW-7*sViewCap)/ 7);
    [self.iStudentVideoViewArray addObject:self.iTeacherVideoView];//先插入老师的视图
    self.iTeacherVideoView.originalWidth = w;
    self.iTeacherVideoView.originalHeight = (w /4.0 * 3.0)+(w /4.0 * 3.0)/7;
    
    for (NSInteger i = 0; i < self.iRoomProperty.iMaxVideo.intValue-1; ++i) {
        TKVideoSmallView *tOurVideoBottomView = [[TKVideoSmallView alloc]initWithFrame:CGRectMake(tCap*2 + tWidth,tCap + CGRectGetMinY(self.iBottomView.frame), tWidth, tHeight) aVideoRole:EVideoRoleOther];
        tOurVideoBottomView.originalWidth = w;
        tOurVideoBottomView.originalHeight = (w /4.0 * 3.0)+(w /4.0 * 3.0)/7;
        tOurVideoBottomView.iPeerId         = @"";
        tOurVideoBottomView.iVideoViewTag   = i;
        tOurVideoBottomView.isDrag          = NO;
        tOurVideoBottomView.isSplit         = NO;
        tOurVideoBottomView.isNeedFunctionButton = (self.iUserType==UserType_Teacher);
        tOurVideoBottomView.iEduClassRoomSessionHandle = self.iSessionHandle;
        tOurVideoBottomView.hidden = NO;
        [tOurVideoBottomView changeName:[NSString stringWithFormat:@"%@",@(i)]];
        
        // 判断当前视频窗口是否与白板相交
        __weak typeof(TKVideoSmallView *) wtOurVideoBottomView = tOurVideoBottomView;
        tOurVideoBottomView.isWhiteboardContainsSelfBlock = ^BOOL{
            return CGRectContainsRect(self.iTKEduWhiteBoardView.frame, wtOurVideoBottomView.frame);
        };
        
        // 接收到调整大小的信令
        tOurVideoBottomView.onRemoteMsgResizeVideoViewBlock = ^CGRect(CGFloat scale) {
            CGRect wbRect = self.iTKEduWhiteBoardView.frame;
            CGRect videoRect = wtOurVideoBottomView.frame;
            CGFloat height = wtOurVideoBottomView.originalHeight * scale;
            CGFloat width = wtOurVideoBottomView.originalWidth *scale;
            CGPoint oldCenter = wtOurVideoBottomView.center;
            
            
            // top 1, right 2, bottom 3, left 4
            NSInteger vcrossEdge = 0;
            NSInteger hcrossEdge = 0;
            if (videoRect.origin.x <= wbRect.origin.x) {
                // 垂直边左相交
                vcrossEdge = 4;
            }
            if (videoRect.origin.x + videoRect.size.width >= wbRect.origin.x + wbRect.size.width) {
                // 垂直边右相交
                vcrossEdge = 2;
            }
            if (videoRect.origin.y <= wbRect.origin.y) {
                // 水平便顶相交
                hcrossEdge = 1;
            }
            if (videoRect.origin.y + videoRect.size.height >= wbRect.origin.y + wbRect.size.height) {
                // 水平便底相交
                hcrossEdge = 3;
            }
            
            if (vcrossEdge == 0 && hcrossEdge == 0) {
                CGRectMake(oldCenter.x - width/2.0, oldCenter.y - height/2.0, width, height);
            }
            
            if (vcrossEdge == 0 && hcrossEdge == 1) {
                CGFloat x = oldCenter.x - width / 2.0;
                CGFloat y = wbRect.origin.y;
                return CGRectMake(x, y, width, height);
            }
            
            if (vcrossEdge == 0 && hcrossEdge == 3) {
                CGFloat x = oldCenter.x - width / 2.0;
                CGFloat y = wbRect.origin.y + wbRect.size.height - height;
                return CGRectMake(x, y, width, height);
            }
            
            if (vcrossEdge == 2 && hcrossEdge == 0) {
                CGFloat x = wbRect.origin.x + wbRect.size.width - width;
                CGFloat y = oldCenter.y - height / 2.0;
                return CGRectMake(x, y, width, height);
            }
            
            if (vcrossEdge == 4 && hcrossEdge == 0) {
                CGFloat x = wbRect.origin.x;
                CGFloat y = oldCenter.y - height / 2.0;
                return CGRectMake(x, y, width, height);
            }
            
            if (vcrossEdge == 4 && hcrossEdge == 1) {
                CGFloat x = wbRect.origin.x;
                CGFloat y = wbRect.origin.y;
                return CGRectMake(x, y, width, height);
            }
            
            if (vcrossEdge == 4 && hcrossEdge == 3) {
                CGFloat x = wbRect.origin.x;
                CGFloat y = wbRect.origin.y + wbRect.size.height - height;
                return CGRectMake(x, y, width, height);
            }
            
            if (vcrossEdge == 2 && hcrossEdge == 1) {
                CGFloat x = wbRect.origin.x + wbRect.size.width - width;
                CGFloat y = wbRect.origin.y;
                return CGRectMake(x, y, width, height);
            }
            
            if (vcrossEdge == 2 && hcrossEdge == 3) {
                CGFloat x = wbRect.origin.x + wbRect.size.width - width;
                CGFloat y = wbRect.origin.y + wbRect.size.height - height;
                return CGRectMake(x, y, width, height);
            }
            
            return CGRectMake(oldCenter.x - width/2.0, oldCenter.y - height/2.0, width, height);
        };
        
        // 当缩放的视频窗口超出白板区域，调整视频窗口大小
        tOurVideoBottomView.resizeVideoViewBlock = ^CGRect{
            CGRect wbRect = self.iTKEduWhiteBoardView.frame;
            CGRect videoRect = wtOurVideoBottomView.frame;
            CGFloat height = 0;
            CGFloat width = 0;
            
            // 如果横边和竖边都相交
            if ((videoRect.origin.x + videoRect.size.width > wbRect.origin.x + wbRect.size.width || videoRect.origin.x < wbRect.origin.x) &&
                (videoRect.origin.y + videoRect.size.height > wbRect.origin.y + wbRect.size.height || videoRect.origin.y < wbRect.origin.y)) {
                width = (wtOurVideoBottomView.center.x - wbRect.origin.x) <= (wbRect.origin.x + wbRect.size.width - wtOurVideoBottomView.center.x) ? (wtOurVideoBottomView.center.x - wbRect.origin.x) * 2 : (wbRect.origin.x + wbRect.size.width - wtOurVideoBottomView.center.x) * 2;
                height = (wtOurVideoBottomView.center.y - wbRect.origin.y) <= (wbRect.origin.y + wbRect.size.height - wtOurVideoBottomView.center.y) ? (wtOurVideoBottomView.center.y - wbRect.origin.y) * 2 : (wbRect.origin.y + wbRect.size.height - wtOurVideoBottomView.center.y) * 2;
                if (width <= height * sStudentVideoViewWidth / sStudentVideoViewHeigh) {
                    height = width * sStudentVideoViewHeigh / sStudentVideoViewWidth;
                    return CGRectMake(wtOurVideoBottomView.center.x - width / 2.0, wtOurVideoBottomView.center.y - height / 2.0, width, height);
                }
                
                if (height <= width * sStudentVideoViewHeigh / sStudentVideoViewWidth) {
                    width = height * sStudentVideoViewWidth / sStudentVideoViewHeigh;
                    return CGRectMake(wtOurVideoBottomView.center.x - width / 2.0, wtOurVideoBottomView.center.y - height / 2.0, width, height);
                }
                
                return CGRectMake(wtOurVideoBottomView.center.x - width / 2.0, wtOurVideoBottomView.center.y - height / 2.0, width, height);
            }
            
            // 如果是竖边界相交
            if (videoRect.origin.x + videoRect.size.width > wbRect.origin.x + wbRect.size.width ||
                videoRect.origin.x < wbRect.origin.x) {
                width = (wtOurVideoBottomView.center.x - wbRect.origin.x) <= (wbRect.origin.x + wbRect.size.width - wtOurVideoBottomView.center.x) ? (wtOurVideoBottomView.center.x - wbRect.origin.x) * 2 : (wbRect.origin.x + wbRect.size.width - wtOurVideoBottomView.center.x) * 2;
                height = width * sStudentVideoViewHeigh / sStudentVideoViewWidth;
                return CGRectMake(wtOurVideoBottomView.center.x - width / 2.0, wtOurVideoBottomView.center.y - height / 2.0, width, height);
            }
            
            // 如果是横边相交
            if (videoRect.origin.y + videoRect.size.height > wbRect.origin.y + wbRect.size.height ||
                videoRect.origin.y < wbRect.origin.y) {
                height = (wtOurVideoBottomView.center.y - wbRect.origin.y) <= (wbRect.origin.y + wbRect.size.height - wtOurVideoBottomView.center.y) ? (wtOurVideoBottomView.center.y - wbRect.origin.y) * 2 : (wbRect.origin.y + wbRect.size.height - wtOurVideoBottomView.center.y) * 2;
                width = height * sStudentVideoViewWidth / sStudentVideoViewHeigh;
                return CGRectMake(wtOurVideoBottomView.center.x - width / 2.0, wtOurVideoBottomView.center.y - height / 2.0, width, height);
            }
            
            return CGRectMake(wtOurVideoBottomView.center.x - width / 2.0, wtOurVideoBottomView.center.y - height / 2.0, width, height);
        };
        
        __weak typeof(self) weakSelf = self;
        tOurVideoBottomView.finishScaleBlock = ^{
            //缩放之后发布一下位移
            if (weakSelf.iUserType == UserType_Teacher) {
                [weakSelf sendMoveVideo:weakSelf.iPlayVideoViewDic aSuperFrame:weakSelf.iTKEduWhiteBoardView.frame  allowStudentSendDrag:NO];
            }
            
        };
        //分屏按钮回调
        tOurVideoBottomView.splitScreenClickBlock = ^(EVideoRole aVideoRole) {
            //学生分屏开始
            [weakSelf beginTKSplitScreenView:wtOurVideoBottomView];
            
            NSArray *videoArray = [NSArray arrayWithArray:weakSelf.iStudentVideoViewArray];
            NSArray *array = [NSArray arrayWithArray:weakSelf.iStudentSplitScreenArray];
            for (TKVideoSmallView *view in videoArray) {
                BOOL isbool = [self.iStudentSplitScreenArray containsObject: view.iRoomUser.peerID];
                if (view.isDrag && !view.isSplit && !isbool && array.count>0) {
                    [self.iStudentSplitScreenArray addObject:view.iRoomUser.peerID];
                    [self beginTKSplitScreenView:view];
                }
            }
        };
        // 添加长按手势
        UILongPressGestureRecognizer * longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressClick:)];
        longGes.minimumPressDuration = 0.2;
        [tOurVideoBottomView addGestureRecognizer:longGes];
        [self.iStudentVideoViewArray addObject:tOurVideoBottomView];
        
        
    }
}

-(void)refreshBottom{
    
    //记录正在播放的个数来固定位置
    int playingCount = 0;
    for (TKVideoSmallView *view in self.iStudentVideoViewArray) {
        if (view.iRoomUser && !view.isDrag) {
            playingCount = playingCount+1 ;
        }
    }
    CGFloat tWidth  = _sStudentVideoViewWidth;
    CGFloat tHeight = _sStudentVideoViewHeigh;
    
    CGFloat tCap    = CGRectGetMinY(self.iBottomView.frame)+(CGRectGetHeight(self.iBottomView.frame)-tHeight)/2;
    CGFloat tleft = sViewCap *Proportion;
    CGFloat left    = tleft;
    BOOL tStdOutBottom = NO;
    
    //根据视频个数将视频平分在工具栏（始终居中平分）
    if((playingCount%2)==1)//奇数
    {
        left = ScreenW/2-tWidth/2-tleft*(playingCount/2)-tWidth*(playingCount/2);
    }
    else//偶数
    {
        left = ScreenW/2- tleft/2- tWidth*(playingCount/2)-tleft*(playingCount/2-1);
    }
    
    if(self.iStudentVideoViewArray.count !=0){
        TKVideoSmallView *iview = (TKVideoSmallView *)self.iStudentVideoViewArray[0];
        
        for (int i=0; i<self.iStudentVideoViewArray.count; i++) {
            TKVideoSmallView *view = (TKVideoSmallView *)self.iStudentVideoViewArray[i];
            if (view.iRoomUser && iview.iVideoViewTag !=-1) {
                [self.iStudentVideoViewArray exchangeObjectAtIndex:i withObjectAtIndex:0];
            }
        }
    }
    
    for (TKVideoSmallView *view in self.iStudentVideoViewArray) {
        
        if (view.iRoomUser) {
            
            if (!view.isSplit && view.isDrag == NO) {//判断是否分屏
                [self.backgroundImageView addSubview:view];
                view.alpha  = 1;
                view.frame = CGRectMake(left, tCap, tWidth, tHeight);
                left += tleft + tWidth;
                
            }else{
                BOOL isEndMvToScrv = ((CGRectGetMaxY(view.frame) > CGRectGetMinY(self.iBottomView.frame)));
                if (!view.superview) {
                    [self.backgroundImageView addSubview:view];
                }
                if (isEndMvToScrv) {
                    
                    view.isDrag = YES;
                    tStdOutBottom = YES;
                    continue;
                }
                view.isDrag = NO;
                view.alpha  = 1;
                view.frame = CGRectMake(left, tCap, tWidth, tHeight);
                left += tleft + tWidth;
                
            }
            
        }
        else {
            
            if (view.superview) {
                [view removeFromSuperview];
            }
        }
        
        if(view.iRoomUser.peerID){
            
            [self.iPlayVideoViewDic setObject:view forKey:view.iRoomUser.peerID];
        }
        
    }
    
    [TKEduSessionHandle shareInstance].iStdOutBottom = tStdOutBottom;
    if ([TKEduSessionHandle shareInstance].iIsFullState) {
        [self.backgroundImageView bringSubviewToFront:self.iTKEduWhiteBoardView];
    }else{
        [self.backgroundImageView sendSubviewToBack:self.iTKEduWhiteBoardView];
    }
    videoOriginFrame = _iTeacherVideoView.frame;
}

- (void)initPlaybackMaskView {
    self.playbackMaskView = [[TKPlaybackMaskView alloc] initWithFrame:CGRectMake(0, self.navbarHeight, ScreenW, ScreenH- self.navbarHeight)];
    [self.view addSubview:self.playbackMaskView];
    //    UITapGestureRecognizer* tapMaskViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPlaybackMaskTool:)];
    //    tapMaskViewGesture.delegate = self;
    //    [self.playbackMaskView addGestureRecognizer:tapMaskViewGesture];
}


//- (void)showPlaybackMaskTool:(UIGestureRecognizer *)gesture {
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
        [self.controlView refreshUI];
    }
}

#pragma mark - 播放
-(void)playVideo:(TKRoomUser*)user {
    
    [self.iSessionHandle delUserPlayAudioArray:user];
    
    TKVideoSmallView* viewToSee = nil;
    if (user.role == UserType_Teacher)
        viewToSee = self.iTeacherVideoView;
    
    else
        
        for (int i =0; i< self.iStudentVideoViewArray.count; i++) {
            
            TKVideoSmallView *view = (TKVideoSmallView *)self.iStudentVideoViewArray[i];
            if(view.iVideoViewTag ==-1){
                continue;
            }
            if(view.iRoomUser != nil && [view.iRoomUser.peerID isEqualToString:user.peerID]) {
                viewToSee = nil;
                break;
            }
            else if(view.iRoomUser == nil && !viewToSee) {
                viewToSee = view;
            }
        }
    
    if (viewToSee && viewToSee.iRoomUser == nil) {
        
        [self myPlayVideo:user aVideoView:viewToSee completion:^(NSError *error) {
            
            //            if (!error) {
            [self.iPlayVideoViewDic setObject:viewToSee forKey:user.peerID];
            if (self.iSessionHandle.iIsFullState) {//如果文档处于全屏模式下则不进行刷新界面
                return;
            }
            [self refreshUI];
            //            }
        }];
    }
}

-(void)unPlayVideo:(NSString *)peerID {
    
    TKVideoSmallView* viewToSee = nil;
    if ([peerID isEqualToString:self.iTeacherVideoView.iPeerId])
        viewToSee = self.iTeacherVideoView;
    
    
    else
    {
        for (TKVideoSmallView* view in self.iStudentVideoViewArray) {
            if(view.iRoomUser != nil && [view.iRoomUser.peerID isEqualToString:peerID]) {
                viewToSee = view;
                break;
            }
        }
        NSArray *splitA = [NSArray arrayWithArray:self.splitScreenView.videoSmallViewArray];
        for (TKVideoSmallView* view in splitA) {
            if(view.iRoomUser != nil && [view.iRoomUser.peerID isEqualToString:peerID]) {
                //                [self.iStudentVideoViewArray addObject:view];
                //                [self.splitScreenView.videoSmallViewArray removeObject:view];
                viewToSee = view;
                break;
            }
        }
    }
    
    if (viewToSee && viewToSee.iRoomUser != nil && [viewToSee.iRoomUser.peerID isEqualToString:peerID]) {
        
        __weak typeof(self)weekSelf = self;
        NSMutableDictionary *tPlayVideoViewDic = self.iPlayVideoViewDic;
        
        NSArray *array = [NSArray arrayWithArray:self.iStudentSplitScreenArray];
        for (NSString *peer in array) {
            if([peerID isEqualToString:peer]) {
                //                viewToSee.isSplit = YES;
                //                [self beginTKSplitScreenView:viewToSee];
                [self.iStudentVideoViewArray addObject:viewToSee];
                [self.iStudentSplitViewArray removeObject:viewToSee];
            }
        }
        
        [self myUnPlayVideo:peerID aVideoView:viewToSee completion:^(NSError *error) {
            
            [tPlayVideoViewDic removeObjectForKey:peerID];
            
            __strong typeof(weekSelf) strongSelf =  weekSelf;
            
            //            viewToSee.frame = CGRectMake(0, CGRectGetMinY(_iBottomView.frame), CGRectGetWidth(viewToSee.frame), CGRectGetHeight(viewToSee.frame));
            
            [strongSelf updateMvVideoForPeerID:peerID];
            if (!self.iSessionHandle.iIsFullState) {
                [strongSelf refreshUI];
            }
            
        }];
    }
    [self.iSessionHandle delePendingUser:peerID];
}


-(void)updateMvVideoForPeerID:(NSString *)aPeerId {
    
    NSDictionary *tVideoViewDic = (NSDictionary*) [_iMvVideoDic objectForKey:aPeerId];
    NSMutableDictionary *tVideoViewDicNew = [NSMutableDictionary dictionaryWithDictionary:tVideoViewDic];
    [tVideoViewDicNew setObject:@(NO) forKey:@"isDrag"];
    [tVideoViewDicNew setObject:@(0) forKey:@"percentTop"];
    [tVideoViewDicNew setObject:@(0) forKey:@"percentLeft"];
    [_iMvVideoDic setObject:tVideoViewDicNew forKey:aPeerId];
    
    
}
-(void)myUnPlayVideo:(NSString *)peerID aVideoView:(TKVideoSmallView*)aVideoView completion:(void (^)(NSError *error))completion{
    [self.iSessionHandle sessionHandleUnPlayVideo:peerID completion:^(NSError *error) {
        
        //更新uiview
        [aVideoView clearVideoData];
        
        completion(error);
        
    }];
}
-(void)myPlayVideo:(TKRoomUser *)aRoomUser aVideoView:(TKVideoSmallView*)aVideoView completion:(void (^)(NSError *error))completion{
    
    [_iSessionHandle sessionHandlePlayVideo:aRoomUser.peerID renderType:(TKRenderMode_adaptive) window:aVideoView completion:^(NSError *error) {
        
        aVideoView.iPeerId        = aRoomUser.peerID;
        aVideoView.iRoomUser      = aRoomUser;
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
    tk_weakify(self);
    alert.rightBlock = ^{
        weakSelf.isQuiting = YES;
        [weakSelf prepareForLeave:YES];
    };
    alert.lelftBlock = ^{
        weakSelf.isQuiting = NO;
    };
    
}

//如果是自己退出，则先掉leftroom。否则，直接退出。
-(void)prepareForLeave:(BOOL)aQuityourself
{
    [self tapTable:nil];
    self.navbarView = nil;
    [self.tabbarView destoy];
    [_chatView dismissAlert];
    [_controlView dismissAlert];
    [_listView dismissAlert];
    
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
        [self unPlayVideo:_iSessionHandle.localUser.peerID];         // 进入教室不点击上课就退出，需要关闭自己视频
        //         [_iSessionHandle.whiteBoardManager resetWhiteBoardAllData];
        //         [_iSessionHandle.whiteBoardManager destory];
        [_iSessionHandle sessionHandleLeaveRoom:nil];
        
    }else{
        // 清理数据
        [self quitClearData];
        
        [_iSessionHandle.whiteBoardManager resetWhiteBoardAllData];
        [_iSessionHandle.whiteBoardManager clearAllData];
        _iSessionHandle.whiteBoardManager = nil;
        [_iSessionHandle clearAllClassData];
        _iSessionHandle.roomMgr = nil;
        
        
        [TKEduSessionHandle destory];
        _iSessionHandle = nil;
        
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


#pragma mark TKEduSessionDelegate
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
        case TKRoomWarning_ReConnectSocket_ServerChanged:
            
            
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
    
    self.isConnect = NO;
    
    if (_iUserType == UserType_Teacher) {
        [[TKEduSessionHandle shareInstance].msgList removeAllObjects];
    }
    
    
    tk_weakify(self);
    
    
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
    
    bool tIsTeacherOrAssis  = ([TKEduSessionHandle shareInstance].localUser.role ==UserType_Teacher || [TKEduSessionHandle shareInstance].localUser.role ==UserType_Assistant);
    //巡课不能翻页
    if ([TKEduSessionHandle shareInstance].localUser.role == UserType_Patrol || [TKEduSessionHandle shareInstance].isPlayback) {
        [[TKEduSessionHandle shareInstance]configurePage:false isSend:NO to:sTellAll peerID:[TKEduSessionHandle shareInstance].localUser.peerID];
    }else {
        
        // 翻页权限根据配置项设置
        [[TKEduSessionHandle shareInstance]configurePage:tIsTeacherOrAssis?true:[TKEduSessionHandle shareInstance].iIsCanPageInit isSend:NO to:sTellAll peerID:[TKEduSessionHandle shareInstance].localUser.peerID];
        
        
    }
    TKLog(@"tlm-----myjoined 时间: %@", [TKUtil currentTimeToSeconds]);
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO]; //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
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
    
    NSString *roomname = [_iSessionHandle.roomMgr getRoomProperty].roomname;
    
    [_navbarView setTitle:roomname];
    
    BOOL meHasVideo = _iSessionHandle.localUser.hasVideo;
    BOOL meHasAudio = _iSessionHandle.localUser.hasAudio;
    
    [[TKEduSessionHandle shareInstance]configureHUD:@"" aIsShow:NO];
    
    [_iSessionHandle addUserStdntAndTchr:_iSessionHandle.localUser];
    [[TKEduSessionHandle shareInstance]addUser:_iSessionHandle.localUser];
    
    [[TKEduSessionHandle shareInstance]configureHUD:@"" aIsShow:NO];
    
    // 非自动上课房间需要上课定时器
    if ([[_iSessionHandle.roomMgr getRoomProperty].companyid isEqualToString:YLB_COMPANYID]) {
        [self startClassReadyTimer];
    }
    
    
    [_iSessionHandle sessionHandlePubMsg:sUpdateTime ID:sUpdateTime To:_iSessionHandle.localUser.peerID Data:@"" Save:NO AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
    
    // 判断上下课按钮是否需要隐藏
    if ( (([_iSessionHandle.roomMgr getRoomConfigration].hideClassBeginEndButton == YES && _iSessionHandle.roomMgr.localUser.role != UserType_Student) || _iSessionHandle.isPlayback == YES)) {
        
    }
    
    
    //是否是自动上课
    if ([_iSessionHandle.roomMgr getRoomConfigration].autoStartClassFlag == YES && _iSessionHandle.isClassBegin == NO && _iSessionHandle.localUser.role == UserType_Teacher && ![[_iSessionHandle.roomMgr getRoomProperty].companyid isEqualToString:YLB_COMPANYID]) {
        
        [TKEduNetManager classBeginStar:[TKEduSessionHandle shareInstance].iRoomProperties.iRoomId companyid:[TKEduSessionHandle shareInstance].iRoomProperties.iCompanyID aHost:[TKEduSessionHandle shareInstance].iRoomProperties.sWebIp aPort:[TKEduSessionHandle shareInstance].iRoomProperties.sWebPort aComplete:^int(id  _Nullable response) {
            
            
            NSString *str = [TKUtil dictionaryToJSONString:@{@"recordchat":@YES}];
            [[TKEduSessionHandle shareInstance] sessionHandlePubMsg:sClassBegin ID:sClassBegin To:sTellAll Data:str Save:true AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
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
            _iSessionHandle.localUser.publishState =(TKPublishState) PublishState_Local_NONE;
            [[TKEduSessionHandle shareInstance] addPublishUser:_iSessionHandle.localUser];
            [[TKEduSessionHandle shareInstance] delePendingUser:_iSessionHandle.localUser.peerID];
            //            [_iSessionHandle.roomMgr enableAudio:YES];
            //            [_iSessionHandle.roomMgr enableVideo:YES];
            [[TKEduSessionHandle shareInstance] configurePlayerRoute:NO isCancle:NO];
            [self playVideo:_iSessionHandle.localUser];
        }
    }
    
}

//自己离开课堂
- (void)sessionManagerRoomLeft {
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
            [self sessionManagerRoomLeft];
        }];
    }else{
        [self showMessage:rea==1?MTLocalized(@"KickOut.SentOutClassroom"):MTLocalized(@"KickOut.Repeat")];
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
    if (state == TKUser_PublishState_NONE){
        [_iSessionHandle delUserPlayAudioArray:user];
        [[TKEduSessionHandle shareInstance]delePublishUser:user];
        [[TKEduSessionHandle shareInstance] delePendingUser:peerID];
        if (_iSessionHandle.localUser.role == UserType_Teacher && _iSessionHandle.iIsClassEnd == YES && user.role == UserType_Teacher) {
            // 老师发布的视频下课不取消播放
        } else {
            [self unPlayVideo:peerID];
        }
        
        if (([TKEduSessionHandle shareInstance].localUser.role == UserType_Teacher) && _iMvVideoDic) {
            NSDictionary *tMvVideoDic = @{@"otherVideoStyle":_iMvVideoDic};
            [[TKEduSessionHandle shareInstance]publishVideoDragWithDic:tMvVideoDic To:sTellAllExpectSender];
        }
        
        if (_iSessionHandle.iHasPublishStd == NO && !_iSessionHandle.iIsFullState) {
            [self refreshUI];
        }
    }
    else
    {
        
        [[TKEduSessionHandle shareInstance] addPublishUser:user];
        [[TKEduSessionHandle shareInstance] delePendingUser:peerID];
        
        
        if (user.publishState >0) {
            
            [self playVideo:user];
        }
        
        if (user.publishState == 1) {
            [self.iSessionHandle addOrReplaceUserPlayAudioArray:user];
        }
        
    }
    
}

//用户进入
- (void)sessionManagerUserJoined:(TKRoomUser *)user InList:(BOOL)inList {
    
    UserType tMyRole =(UserType) [TKEduSessionHandle shareInstance].localUser.role;
    
    RoomType tRoomType = (RoomType)[[[TKEduSessionHandle shareInstance].roomMgr getRoomProperty].roomtype intValue];
    if (inList) {
        //1 大班课 //0 小班课
        if ((user.role == UserType_Teacher && tMyRole == UserType_Teacher) || (tRoomType == RoomType_OneToOne && user.role == (int)tMyRole && tMyRole == UserType_Student)) {
            
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
- (void)sessionManagerUserLeft:(NSString *)peerID {
    
    
    TKRoomUser *user = [[TKEduSessionHandle shareInstance] getUserWithPeerId:peerID];
    
    
    [self unPlayVideo:peerID];
    
    BOOL tIsMe = [[NSString stringWithFormat:@"%@",peerID] isEqualToString:[NSString stringWithFormat:@"%@",[TKEduSessionHandle shareInstance].localUser.peerID]];
    
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
- (void)sessionManagerUserChanged:(TKRoomUser *)user Properties:(NSDictionary*)properties fromId:(NSString *)fromId {
    
    NSInteger tGiftNumber = 0;
    
    if ([properties objectForKey:sGiftNumber]) {
        
        tGiftNumber = [[properties objectForKey:sGiftNumber]integerValue];
        
    }
    // 举手
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
        self.tabbarView.showRedDot = isRaiseHand;
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
            //            _iSessionHandle.localUser.publishState = tPublishState;
            
            
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
                //                u.publishState = tPublishState;
                
                break;
            }
        }
        //当为老师时
        
        NSArray *array = [NSArray arrayWithArray:_iStudentSplitViewArray];
        
        if (tPublishState == PublishState_NONE && [TKEduSessionHandle shareInstance].localUser.role == UserType_Teacher && [array containsObject:user.peerID]) {
            [_iStudentSplitViewArray removeObject:user.peerID];
            
            NSString *str = [TKUtil dictionaryToJSONString:@{@"userIDArry":_iStudentSplitScreenArray}];
            
            [_iSessionHandle sessionHandlePubMsg:sVideoSplitScreen ID:sVideoSplitScreen To:sTellAll Data:str Save:true AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
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
    
    if ([properties objectForKey:sServerName]) {//服务
        
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
    
    
    if ([properties objectForKey:sPrimaryColor]) {//画笔颜色值
        
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
        
        //        TKChatMessageModel *tChatMessageModel = [[TKChatMessageModel alloc]initWithFromid:user.peerID aTouid:tMyPeerId iMessageType:tMessageType aMessage:msg aUserName:user.nickName aTime:[NSString stringWithFormat:@"%f",[TKUtil getNowTimeTimestamp]]];
        
        TKChatMessageModel *tChatMessageModel = [[TKChatMessageModel alloc]initWithFromid:peerID aTouid:tMyPeerId iMessageType:tMessageType aMessage:msg aUserName:extension[@"nickname"] aTime:time];
        
        [[TKEduSessionHandle shareInstance].unReadMessagesArray addObject:tChatMessageModel];
        
        [[TKEduSessionHandle shareInstance] addOrReplaceMessage:tChatMessageModel];
        
        
    }
    
    [self.tabbarView refreshUI];
    
}

- (void)sessionManagerRoomManagerPlaybackMessageReceived:(NSString *)message
                                                  fromID:(NSString *)peerID
                                                      ts:(NSTimeInterval)ts
                                               extension:(NSDictionary *)extension{
    //- (void)sessionManagerPlaybackMessageReceived:(NSString *)message ofUser:(TKRoomUser *)user ts:(NSTimeInterval)ts {
    //当聊天视图存在的时候，显示聊天内容。否则存储在未读列表中
    //    if (_chatView) {
    //        [_chatView messageReceived:message fromID:peerID extension:extension];
    //
    //    }else{
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
    
    //    }
    
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
    
    [self.iSessionHandle clearAllClassData];
    
    [self clearAll];
    
}

- (void)clearAll{
    
    if (self.isConnect) {
        return;
    }
    
    self.isConnect = YES;
    
    [self.iSessionHandle.whiteBoardManager changeDocumentWithFileID:[TKEduSessionHandle shareInstance].whiteBoard.fileid isBeginClass:[TKEduSessionHandle shareInstance].isClassBegin isPubMsg:YES];
    
    [self.iSessionHandle.whiteBoardManager disconnect:nil];
    
    [self.iSessionHandle.whiteBoardManager resetWhiteBoardAllData];
    
    //将分屏的数据删除
    for (TKVideoSmallView *view in self.iStudentSplitViewArray) {
        view.isDrag = NO;
        [self.iStudentVideoViewArray addObject:view];
    }
    
    [self.iStudentSplitViewArray removeAllObjects];
    
    for (TKVideoSmallView *view in self.iStudentVideoViewArray) {
        [self clearVideoViewData:view];
    }
    
    if(self.iStudentVideoViewArray.count !=0){
        
        TKVideoSmallView *iview = (TKVideoSmallView *)self.iStudentVideoViewArray[0];
        
        for (int i=0; i<self.iStudentVideoViewArray.count; i++) {
            
            TKVideoSmallView *view = (TKVideoSmallView *)self.iStudentVideoViewArray[i];
            if (view.iRoomUser && iview.iVideoViewTag !=-1) {
                
                [self.iStudentVideoViewArray exchangeObjectAtIndex:i withObjectAtIndex:0];
                
            }
        }
    }
    
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
    [self.splitScreenView deleteAllVideoSmallView];
    
    [self.iStudentSplitScreenArray removeAllObjects];
    
    self.splitScreenView.hidden = YES;
}
- (void)clearVideoViewData:(TKVideoSmallView *)videoView {
    videoView.isDrag = NO;
    if (videoView.iRoomUser != nil) {
        [self myUnPlayVideo:videoView.iRoomUser.peerID aVideoView:videoView completion:^(NSError *error) {
            TKLog(@"清理视频窗口完成!");
        }];
    } else {
        [videoView clearVideoData];
    }
}

//相关信令 pub
- (void)sessionManagerOnRemoteMsg:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(unsigned long)ts Data:(NSObject*)data InList:(BOOL)inlist{
    add = (BOOL)add;
    //添加
    if ([msgName isEqualToString:sClassBegin]) {
        
        NSString *tPeerId = _iSessionHandle.localUser.peerID;
        _iSessionHandle.isClassBegin = add;
        
        
        [self.navbarView refreshUI:add];
        [[TKEduSessionHandle shareInstance].whiteBoardManager setClassBegin:add];
        //上课
        if (add) {
            [self invalidateClassCurrentTime];
            
            [TKEduSessionHandle shareInstance].iIsClassEnd = NO;
            [TKEduSessionHandle shareInstance].isClassBegin = YES;
            
            // 上课之前将自己的音视频关掉
            if (![_iSessionHandle.roomMgr getRoomConfigration].autoOpenAudioAndVideoFlag && _isLocalPublish) {
                _iSessionHandle.localUser.publishState = TKUser_PublishState_NONE;
                
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

            //如果是1v1并且是学生角色
            BOOL isStdAndRoomOne = ([[[TKEduSessionHandle shareInstance].roomMgr getRoomProperty].roomtype intValue] == RoomType_OneToOne && ([TKEduSessionHandle shareInstance].localUser.role == UserType_Student));
            
            // 涂鸦权限:1.1v1学生根据配置项设置 2.其他情况，没有涂鸦权限 3 非老师断线重连不可涂鸦。 发送:1 1v1 学生发送 2 学生发送，老师不发送
            [[TKEduSessionHandle shareInstance]configureDraw:isStdAndRoomOne?[TKEduSessionHandle shareInstance].iIsCanDrawInit:tIsTeacherOrAssis isSend:isStdAndRoomOne?YES:!tIsTeacherOrAssis to:sTellAll peerID:tPeerId];
            
            //如果是学生需要重新设置翻页
            [[TKEduSessionHandle shareInstance]configurePage:[TKEduSessionHandle shareInstance].iIsCanDrawInit?true:[TKEduSessionHandle shareInstance].iIsCanPageInit isSend:NO to:sTellAll peerID:isStdAndRoomOne?tPeerId:@""];
            
            [_iSessionHandle sessionHandlePubMsg:sUpdateTime ID:sUpdateTime To:tPeerId Data:@"" Save:false AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:^(NSError *error) {
                
            }];
            
            [self startClassBeginTimer];
            
            // 刷新tabbar
            [_tabbarView refreshUI];
            [self refreshUI];
            
            
        }
        else{// 下课
            
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
            
            //将所有全屏的视频还原
            [self cancelSplitScreen:nil];
            //将所有拖拽的视频还原
            for (TKVideoSmallView *view  in self.iStudentVideoViewArray) {
                [self updateMvVideoForPeerID:view.iPeerId];
                view.isDrag = NO;
                view.isDragWhiteBoard = NO;
            }
            [self sendMoveVideo:self.iPlayVideoViewDic aSuperFrame:self.iTKEduWhiteBoardView.frame  allowStudentSendDrag:NO];
            
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
        
    }else if ([msgName isEqualToString:sVideoDraghandle]){//拖拽回调
        
        [self tapTable:nil];
        if(_iStudentSplitScreenArray.count>0 || isFullPIP){
            return;
        }
        
        // 可能意外收到录制的拖拽信令，1对1回放不响应拖拽。
        if (_iRoomType == RoomType_OneToOne && _iSessionHandle.isPlayback == YES) {
            return;
        }
        
        NSDictionary *tDataDic = @{};
        if ([data isKindOfClass:[NSString class]]) {
            NSString *tDataString = [NSString stringWithFormat:@"%@",data];
            NSData *tJsData = [tDataString dataUsingEncoding:NSUTF8StringEncoding];
            tDataDic = [NSJSONSerialization JSONObjectWithData:tJsData options:NSJSONReadingMutableContainers error:nil];
        }
        if ([data isKindOfClass:[NSDictionary class]]) {
            tDataDic = (NSDictionary *)data;
        }
        
        NSDictionary *tMvVideoDic = [tDataDic objectForKey:@"otherVideoStyle"];
        _iMvVideoDic = [NSMutableDictionary dictionaryWithDictionary:tMvVideoDic];
        
        if(_iUserType == UserType_Student && inlist){
            
            [self updateMvVideoForPeerID:[TKEduSessionHandle shareInstance].localUser.peerID];
            
        }
        
        [self moveVideo:tMvVideoDic];
        
        
        
    } else if ([msgName isEqualToString:sChangeServerArea]){//更改服务器
        
        
    } else if ([msgName isEqualToString:sVideoSplitScreen]){//分屏回调
        
        [self tapTable:nil];
        NSDictionary *tDataDic = @{};
        if ([data isKindOfClass:[NSString class]]) {
            NSString *tDataString = [NSString stringWithFormat:@"%@",data];
            NSData *tJsData = [tDataString dataUsingEncoding:NSUTF8StringEncoding];
            tDataDic = [NSJSONSerialization JSONObjectWithData:tJsData options:NSJSONReadingMutableContainers error:nil];
        }
        if ([data isKindOfClass:[NSDictionary class]]) {
            tDataDic = (NSDictionary *)data;
        }
        
        NSMutableArray *array = [NSMutableArray arrayWithArray:tDataDic[@"userIDArry"]];
        
        //取消全屏的操作
        [self cancelSplitScreen:array];
        
        _iStudentSplitScreenArray = array;
        //白板全屏状态下不执行分屏回调
        if ([TKEduSessionHandle shareInstance].iIsFullState) {
            return;
        }
        [self sVideoSplitScreen:_iStudentSplitScreenArray];
        [_splitScreenView refreshSplitScreenView];
        
    } else if ([msgName isEqualToString:sVideoZoom]) {//缩放回调
        
        // 视频缩放
        NSDictionary *tDataDic = @{};
        if ([data isKindOfClass:[NSString class]]) {
            NSString *tDataString = [NSString stringWithFormat:@"%@", data];
            NSData *tJsData = [tDataString dataUsingEncoding:NSUTF8StringEncoding];
            tDataDic = [NSJSONSerialization JSONObjectWithData:tJsData options:NSJSONReadingMutableContainers error:nil];
        }
        
        // 数据格式：{"ScaleVideoData":{"ffefbe63-50ae-4959-a872-3dd38397988d":{"scale":1.7285714285714286}}}
        NSDictionary *peerIdToScaleDic = [tDataDic objectForKey:@"ScaleVideoData"];
        _iScaleVideoDict = peerIdToScaleDic;
        
        //白板全屏状态下不执行缩放回调
        if ([TKEduSessionHandle shareInstance].iIsFullState) {
            return;
        }
        [self sScaleVideo:peerIdToScaleDic];
        
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
    }else if ([msgName isEqualToString:sBigRoom]) {//大并发教室
        
        [TKEduSessionHandle shareInstance].bigRoom = YES;
        
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
             ) {//白板全屏
        
        // 配置项
        if ([[TKEduSessionHandle shareInstance].roomMgr getRoomConfigration].coursewareFullSynchronize) {
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
    
}

- (void)sessionManagerIceStatusChanged:(NSString*)state ofUser:(TKRoomUser *)user {
    TKLog(@"------IceStatusChanged:%@ nickName:%@",state,user.nickName);
}

- (void)cancelSplitScreen:(NSMutableArray *)array{
    if (_iStudentSplitScreenArray.count>array.count) {
        
        __block NSMutableArray *difObject = [NSMutableArray arrayWithCapacity:10];
        //找到arr2中有,arr1中没有的数据
        [_iStudentSplitScreenArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSNumber *number1 = obj;//[obj objectAtIndex:idx];
            __block BOOL isHave = NO;
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([number1 isEqual:obj]) {
                    isHave = YES;
                    *stop = YES;
                }
            }];
            if (!isHave) {
                [difObject addObject:obj];
            }
        }];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSNumber *number1 = obj;//[obj objectAtIndex:idx];
            __block BOOL isHave = NO;
            [_iStudentSplitScreenArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([number1 isEqual:obj]) {
                    isHave = YES;
                    *stop = YES;
                }
            }];
            if (!isHave) {
                [difObject addObject:obj];
            }
        }];
        
        for (NSString *peerID in difObject) {
            
            NSArray *sArray = [NSArray arrayWithArray:_iStudentSplitViewArray];
            for (TKVideoSmallView *view in sArray) {
                
                if([view.iRoomUser.peerID isEqualToString:peerID]){
                    view.isSplit = YES;
                    [self beginTKSplitScreenView:view];
                }
            }
        }
    }
}

// 画中画
- (void)changeVideoFrame:(BOOL)isFull {
    
    isFullPIP = isFull;
    if (isFullPIP) {
        
        _iTeacherVideoView.hidden = NO;
        videoOriginSuperView = _iTeacherVideoView.superview;
        _iTeacherVideoView.x = ScreenW - _iTeacherVideoView.width - 5.;
        _iTeacherVideoView.y = ScreenH - self.tabbarHeight - _iTeacherVideoView.height - 5.;
        
        [[UIApplication sharedApplication].keyWindow addSubview: _iTeacherVideoView];
        // 隐藏按钮
        [_tabbarView hideAllButton:YES];
    }
    else{
        
        [_iTeacherVideoView removeFromSuperview];
        _iTeacherVideoView.frame = videoOriginFrame;
        
        videoOriginSuperView = videoOriginSuperView ? videoOriginSuperView : self.backgroundImageView;
        [videoOriginSuperView addSubview: _iTeacherVideoView];
        
        // 播放中 隐藏画中画
        _iTeacherVideoView.hidden = [TKEduSessionHandle shareInstance].isPlayMedia;
        
        // 显示按钮
        [_tabbarView hideAllButton:NO];
    }
    
    // 隐藏小视频上的按钮 屏蔽操作
    [_iTeacherVideoView showMaskView:isFullPIP];
    
    
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
            [self.view bringSubviewToFront: _iMediaView];
        }
        
        
        [[TKEduSessionHandle shareInstance] sessionHandlePlayMediaFile:peerId renderType:0 window:tMediaView completion:^(NSError *error) {
            
            [_iMediaView setVideoViewToBack];
            if (hasVideo) {
                
                [_iMediaView loadLoadingView];
            }
            
        }];
        
        
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
            _iSessionHandle.iIsFullState == NO
            ) {
            
            [self changeVideoFrame:NO];
            
        }
    }
}



- (void)sessionManagerUpdateMediaStream:(NSTimeInterval)duration pos:(NSTimeInterval)pos isPlay:(BOOL)isPlay{
    
    [_iMediaView updatePlayUI:isPlay];
    if (isPlay) {
        [_iMediaView update:pos total:duration];
    }
    
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
    
    
    for (TKVideoSmallView * view in _iStudentVideoViewArray) {
        [view hidePopMenu];
    }
    //分屏模式下取消functionView的显示
    for (TKVideoSmallView * view in _iStudentSplitViewArray) {
        [view hidePopMenu];
    }
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
#pragma mark 拖动视频
- (void)longPressClick:(UIGestureRecognizer *)longGes
{
    
    TKVideoSmallView * currentBtn = (TKVideoSmallView *)longGes.view;
    
    //未开始上课禁止拖动视频
    if (![TKEduSessionHandle shareInstance].isClassBegin) {
        return;
    }
    
    // 巡课不能拖视频
    if (self.iUserType == UserType_Patrol) {
        return;
    }
    
    // 学生只能在授权下拖拽自己的视频
    if (self.iUserType == UserType_Student) {
        if (![TKEduSessionHandle shareInstance].iIsCanDraw) {
            return;
        }
    }
    
    //判断视图是否处于分屏状态，如果是分屏状态则不可以拖动
    for (NSString *peerID in self.iStudentSplitScreenArray) {
        if ([peerID isEqualToString:currentBtn.iRoomUser.peerID] ) {
            return;
        }
    }
    
    if (([TKEduSessionHandle shareInstance].localUser.role == UserType_Patrol)) {
        return;
    }
    
    //把白板放到最下边
    [self.backgroundImageView sendSubviewToBack:self.iTKEduWhiteBoardView];
    
    if (UIGestureRecognizerStateBegan == longGes.state) {
        [UIView animateWithDuration:0.2 animations:^{
            self.iStrtCrtVideoViewP  = [longGes locationInView:currentBtn];
        }];
    }
    if (UIGestureRecognizerStateChanged == longGes.state) {
        //移动距离
        CGPoint newP = [longGes locationInView:currentBtn];
        CGFloat movedX = newP.x - self.iStrtCrtVideoViewP.x;
        CGFloat movedY = newP.y - self.iStrtCrtVideoViewP.y;
        CGFloat tCurBtnCenterX = currentBtn.center.x+ movedX;
        CGFloat tCurBtnCenterY = currentBtn.center.y + movedY;
        //边界
        CGFloat tEdgLeft = CGRectGetWidth(currentBtn.frame)/2.0;
        CGFloat tEdgRight = CGRectGetMaxX(self.iTKEduWhiteBoardView.frame) - CGRectGetWidth(currentBtn.frame)/2.0;
        CGFloat tEdgBtm = ScreenH - CGRectGetHeight(currentBtn.frame)/2.0-sViewCap;
        CGFloat tEdgTp = CGRectGetMinY(self.iTKEduWhiteBoardView.frame) - CGRectGetHeight(currentBtn.frame)/2.0;
        
        
        BOOL isOverEdgLR = (tCurBtnCenterX <= tEdgLeft) || (tCurBtnCenterX >= tEdgRight) || (tCurBtnCenterY <= tEdgTp) || (tCurBtnCenterY >= tEdgBtm);
        BOOL isOverEdgTD = (tCurBtnCenterY <= tEdgTp) || (tCurBtnCenterY >= tEdgBtm);
        if (isOverEdgLR) {
            tCurBtnCenterX =  tCurBtnCenterX - movedX;
        }
        if (isOverEdgTD) {
            tCurBtnCenterY = tCurBtnCenterY - movedY;
        }
        currentBtn.center = CGPointMake(tCurBtnCenterX, tCurBtnCenterY);
    }
    // 手指松开之后 进行的处理
    if (UIGestureRecognizerStateEnded == longGes.state) {
        
        BOOL isEndEdgMvToScrv = ((currentBtn.center.y> CGRectGetMinY(self.iBottomView.frame)) &&(CGRectGetMaxY(currentBtn.frame) < CGRectGetMinY(self.iBottomView.frame)));
        BOOL isEndMvToScrv = ((CGRectGetMinY(currentBtn.frame) > CGRectGetMaxY(self.iBottomView.frame)));
        
        currentBtn.isDrag = YES;
        [UIView animateWithDuration:0.2 animations:^{
            currentBtn.alpha     = 1.0f;
            currentBtn.transform = CGAffineTransformIdentity;
            if (isEndEdgMvToScrv ) {
                
                currentBtn.frame= CGRectMake(CGRectGetMinX(currentBtn.frame), CGRectGetMinY(self.iBottomView.frame)-CGRectGetHeight(currentBtn.frame), CGRectGetWidth(currentBtn.frame), CGRectGetHeight(currentBtn.frame));
                
            }else if(isEndMvToScrv) {
                TKLog(@"isEndMvToScrv 拖动");
            }else {
                currentBtn.isDrag = NO;
            }
            
            //拖拽视频后如果未放大需要初始化到7个均分的大小
            CGFloat w =((ScreenW-7*sViewCap)/ 7);
            CGFloat h = (w /4.0 * 3.0)+(w /4.0 * 3.0)/7;
            
            if (!currentBtn.isSplit && currentBtn.currentWidth<currentBtn.originalWidth) {
                currentBtn.frame= CGRectMake(CGRectGetMinX(currentBtn.frame), CGRectGetMinY(currentBtn.frame), w, h);
            }
            
            //拖动视频的时候判断下视频是否有分屏状态的
            if(self.iStudentSplitScreenArray.count>0){
                
                [self beginTKSplitScreenView:currentBtn];
                return;
            }
            
            [self refreshBottom];
            [self sendMoveVideo:self.iPlayVideoViewDic aSuperFrame:self.iTKEduWhiteBoardView.frame  allowStudentSendDrag:NO];
            
        }];
    }
}

/**
 发送视频的位置
 
 @param aPlayVideoViewDic 位置存储字典
 @param aSuperFrame 父视图
 */
-(void)sendMoveVideo:(NSDictionary *)aPlayVideoViewDic aSuperFrame:(CGRect)aSuperFrame allowStudentSendDrag:(BOOL)isSendDrag{
    
    NSMutableDictionary *tVideosDic = @{}.mutableCopy;
    for (NSString *tKey in aPlayVideoViewDic) {
        
        TKVideoSmallView *tVideoView = [aPlayVideoViewDic objectForKey:tKey];
        CGFloat tX = CGRectGetWidth(aSuperFrame) - CGRectGetWidth(tVideoView.frame);
        CGFloat tY = CGRectGetHeight(aSuperFrame)-CGRectGetHeight(tVideoView.frame);
        CGFloat tLeft = CGRectGetMinX(tVideoView.frame)/tX;
        CGFloat tTop= (CGRectGetMinY(tVideoView.frame)-CGRectGetMinY(aSuperFrame))/tY;
        if(tVideoView.isSplit){
            tLeft = 0;
            tTop = 0;
        }
        
        NSDictionary *tDic = @{@"percentTop":@(tTop),@"percentLeft":@(tLeft),@"isDrag":@(tVideoView.isDrag)};
        if ((tVideoView.iRoomUser.role == UserType_Student) || (tVideoView.iRoomUser.role == UserType_Assistant) || (tVideoView.iRoomUser.role == UserType_Teacher) ) {
            [tVideosDic setObject:tDic forKey:tVideoView.iPeerId?tVideoView.iPeerId:@""];
        }
        
    }
    NSDictionary *tDic =   @{@"otherVideoStyle":tVideosDic};
    
    self.iMvVideoDic = [NSMutableDictionary dictionaryWithDictionary:tVideosDic];
    if ([TKEduSessionHandle shareInstance].localUser.role == UserType_Teacher || isSendDrag) {
        [[TKEduSessionHandle shareInstance]publishVideoDragWithDic:tDic To:sTellAllExpectSender];
    }
    
}


-(void)moveVideo:(NSDictionary *)aMvVideoDic{
    
    for (NSString *peerId in aMvVideoDic) {
        NSDictionary *obj = [aMvVideoDic objectForKey:peerId];
        BOOL isDrag = [[obj objectForKey:@"isDrag"]boolValue];
        //对返回的数据做NSNull值判断
        if([[obj objectForKey:@"percentTop"] isKindOfClass:[NSNull class]]){
            return;
        }
        if([[obj objectForKey:@"percentLeft"] isKindOfClass:[NSNull class]]){
            return;
        }
        CGFloat top = [[obj objectForKey:@"percentTop"]floatValue];
        CGFloat left = [[obj objectForKey:@"percentLeft"]floatValue];
        TKVideoSmallView *tVideoView = [self.iPlayVideoViewDic objectForKey:peerId];
        
        if (tVideoView) {
            
            tVideoView.isDrag = isDrag;
            if (isDrag) {
                
                CGFloat tX = CGRectGetWidth(self.iTKEduWhiteBoardView.frame) - CGRectGetWidth(tVideoView.frame);
                CGFloat tY = CGRectGetHeight(self.iTKEduWhiteBoardView.frame)-CGRectGetHeight(tVideoView.frame);
                tVideoView.frame = CGRectMake(tX*left, CGRectGetMinY(self.iTKEduWhiteBoardView.frame)+ tY*top, CGRectGetWidth(tVideoView.frame), CGRectGetHeight(tVideoView.frame));
                
                CGFloat w =((ScreenW-7*sViewCap)/ 7);
                CGFloat h = (w /4.0 * 3.0)+(w /4.0 * 3.0)/7;
                
                if (!tVideoView.isSplit && tVideoView.currentWidth<tVideoView.originalWidth) {
                    
                    tVideoView.frame = CGRectMake(tX*left, CGRectGetMinY(self.iTKEduWhiteBoardView.frame)+ tY*top, w, h);
                }
                
                
            }else{
                
                // 当老师拖拽后，网页助教再拖拽，收到的拖拽信令中有老师的peerID，因为从网页收到了老师view变化的错误信令
                if (tVideoView.iRoomUser.role != UserType_Teacher) {
                    //                    tVideoView.frame = CGRectMake(CGRectGetMinX(tVideoView.frame), CGRectGetMinY(_iBottomView.frame)+1, CGRectGetWidth(tVideoView.frame), CGRectGetHeight(tVideoView.frame));
                }
                
            }
            
        }
    }
    [self refreshBottom];
    
}
- (void)sScaleVideo:(NSDictionary *)peerIdToScaleDic{
    
    NSArray *peerIdArray = peerIdToScaleDic.allKeys;
    
    for (NSString *peerId in peerIdArray) {
        NSDictionary *scaleDict = [peerIdToScaleDic objectForKey:peerId];
        
        CGFloat scale = [scaleDict[@"scale"] floatValue];
        
        TKVideoSmallView *videoView = [self videoViewForPeerId:peerId];
        
        if (videoView && videoView.isDrag == YES) {
            [videoView changeVideoSize:scale];
        }
    }
}
- (void)sVideoSplitScreen:(NSMutableArray *)array{
    
    
    //在_iStudentVideoViewArray 中删除视图
    
    NSArray *vArray = [NSArray arrayWithArray:_iStudentVideoViewArray];
    
    for (TKVideoSmallView *videoView in vArray) {
        
        for (int i=0;i<array.count;i++) {
            
            NSString *peerId = array[i];
            
            if ([peerId isEqualToString:videoView.iRoomUser.peerID]) {
                
                [self beginTKSplitScreenView:videoView];
                
            }
        }
    }
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


//-(void)handleMediaServicesReset:(NSNotification *)aNotification{
//
//
//
//    AVAudioSessionInterruptionType type = (AVAudioSessionInterruptionType)[aNotification.userInfo[AVAudioSessionInterruptionTypeKey] intValue];
//    TKLog(@"---jin 当前AVAudioSessionMediaServicesWereResetNotification: 打断 %@",@(type));
//
//
//
//}
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
        [self.navbarView showDeviceInfo];
    }
    
    //移动端本机时间不对的话，能进入教室但是看不见课件,需退出课堂
    //    [self judgeDeviceTime];
    
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
        //        if (delay) {
        //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //                [self presentViewController:_iPickerController
        //                                   animated:true
        //                                 completion:nil];
        //            });
        //        } else {
        [self presentViewController:_iPickerController
                           animated:true
                         completion:nil];
        //        }
        
    } else if (buttonIndex == 1) {
        //拍照
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        //判断是否有相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (authStatus == AVAuthorizationStatusAuthorized) {
                _iPickerController = [[TKImagePickerController alloc] init];
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



#pragma mark UIImagePickerControllerDelegate
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
        [picker dismissViewControllerAnimated:YES completion:^{
            
            _iPickerController = nil;
        }];
        
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
    else if (!req && [Response isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *tFileDic = (NSDictionary *)Response;
        TKDocmentDocModel *tDocmentDocModel = [[TKDocmentDocModel alloc]init];
        [tDocmentDocModel setValuesForKeysWithDictionary:tFileDic];
        [tDocmentDocModel dynamicpptUpdate];
        tDocmentDocModel.filetype = @"jpeg";
        [[TKEduSessionHandle shareInstance] addOrReplaceDocmentArray:tDocmentDocModel];
        
        [[TKEduSessionHandle shareInstance].whiteBoardManager addDocumentWithFile:[TKModelToJson getObjectData:tDocmentDocModel]];
        
        [[TKEduSessionHandle shareInstance]addDocMentDocModel:tDocmentDocModel To:sTellAllExpectSender];
        
        [[TKEduSessionHandle shareInstance] publishtDocMentDocModel:tDocmentDocModel To:sTellAllExpectSender aTellLocal:YES];
        [self removProgressView];
        [[TKEduSessionHandle shareInstance]sessionHandleEnableVideo:YES];
        
    }
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


#pragma mark Public
- (TKVideoSmallView *)videoViewForPeerId:(NSString *)peerId {
    if (peerId == nil) {
        return nil;
    }
    
    for (TKVideoSmallView *view in self.iStudentVideoViewArray) {
        if ([view.iRoomUser.peerID isEqualToString:peerId]) {
            //        if([view.iPeerId isEqualToString:peerId]){
            return view;
        }
    }
    
    return nil;
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
    
    for (TKVideoSmallView *view in _iStudentVideoViewArray) {
        [self clearVideoViewData:view];
    }
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
    
    //将分屏的数据删除
    for (TKVideoSmallView *view in _iStudentSplitViewArray) {
        //[view clearVideoData];
        [self clearVideoViewData:view];
    }
    [_splitScreenView deleteAllVideoSmallView];
    [_iStudentSplitScreenArray removeAllObjects];
    
    [_iStudentVideoViewArray removeAllObjects];
    _iStudentVideoViewArray = nil;
    
    
}
@end
