//
//  TKEduSessionHandle.m
//  EduClassPad
//
//  Created by ifeng on 2017/5/10.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKEduSessionHandle.h"
#import "TKMacro.h"
#import "TKDocmentDocModel.h"
#import "TKMediaDocModel.h"
#import "TKChatMessageModel.h"
#import "TKEduRoomProperty.h"
#import "TKUtil.h"
#import "TKDocumentListView.h"
#import "sys/utsname.h"
#import "TKHUD.h"

//@import AVFoundation;
#import <AVFoundation/AVFoundation.h>

@interface TKRoomManager(test)
- (void)setTestServer:(NSString*)ip Port:(NSString*)port;
@end
@interface TKEduSessionHandle ()<TKRoomManagerDelegate, TKWhiteBoardManagerDelegate>

@property (nonatomic,strong) NSMutableArray *iMessageList;
@property (nonatomic,strong) NSMutableArray *iUserStdAndTchrList;
@property (nonatomic,strong) NSMutableDictionary *iSpecialUserDic;

@property (nonatomic,strong) NSMutableSet   *iUserPlayAudioArray;
@property (nonatomic,strong) NSMutableDictionary *iPendingButtonDic;

@property (nonatomic,strong) NSMutableDictionary *iUnPublisDic;
@property (strong, nonatomic)  UISlider *iAudioslider2;

@property (nonatomic,assign) BOOL getCameraFail;
@property (nonatomic,assign) BOOL getMicrophoneFail;

@end

@implementation TKEduSessionHandle

static TKEduSessionHandle *singleton = nil;

+ (instancetype )shareInstance {
    @synchronized(self) {
        if (!singleton) {
            singleton = [[TKEduSessionHandle alloc] init];
        }
    }
    return singleton;
}

- (instancetype)init{
    if ([super init]) {
        _roomMgr = [TKRoomManager instance];
        self.cacheMsgPool = [NSMutableArray array];
        self.UIDidAppear = NO;
        self.bigRoom = NO;
    }
    return self;
}
+ (void)destory
{
    if (singleton) {
        [TKRoomManager destory];
        [TKWhiteBoardManager destory];
        singleton = nil;
    }
}
- (void)initPlaybackRoomManager:(BOOL)aRoomWhiteBoardDelegate {
    
//    [[TKRoomManager instance] registerRoomWhiteBoardDelegate:self andWB:aRoomWhiteBoardDelegate];
    [[TKRoomManager instance] registerRoomManagerPlaybackDelegate:self andWB:aRoomWhiteBoardDelegate];
}

- (void)initClassRoomManager {
    [[TKRoomManager instance] registerRoomManagerDelegate:self];
}
- (void)initClassRoomManager:(BOOL)aRoomWhiteBoardDelegate {
    [[TKRoomManager instance] registerRoomWhiteBoardDelegate:self andWB:aRoomWhiteBoardDelegate];
}


- (void)configureSession:(NSDictionary*)paramDic
       aClassRoomDelgate:(id<TKEduSessionClassRoomDelegate>)aClassRoomDelgate
           aRoomDelegate:(id<TKEduRoomDelegate>) aRoomDelegate
         aRoomProperties:(TKEduRoomProperty*)aRoomProperties
{

#if TARGET_OS_IPHONE
    _iRoomDelegate     = aRoomDelegate;
    _iParamDic         = paramDic;
    _iClassRoomDelegate = aClassRoomDelgate;
    
    NSDictionary *config = @{TKWhiteBoardWebProtocolKey:sHttp,
                             TKWhiteBoardWebHostKey:sHost,
                             TKWhiteBoardWebPortKey:sPort,
                             TKWhiteBoardPlayBackKey:@(NO),
                             };
    _whiteBoardManager = [TKWhiteBoardManager shareInstance];
    [_whiteBoardManager registerDelegate:self configration:config];
    
    [self initClassRoomManager:true];

#endif
    _iMessageList                = [[NSMutableArray alloc] init];
    _unReadMessagesArray         = [[NSMutableArray alloc] init];
    _iUserList                   = [[NSMutableArray alloc] init];
    _iUserStdAndTchrList         = [[NSMutableArray alloc] init];
    _iSpecialUserDic             = [[NSMutableDictionary alloc]initWithCapacity:10];
    _iUserPlayAudioArray         = [[NSMutableSet alloc] init];
    _msgList                     = [NSMutableArray array];
    _iRoomProperties             = aRoomProperties;
    _iPendingButtonDic = [[NSMutableDictionary alloc]initWithCapacity:10];
    _iPublishDic = [[NSMutableDictionary alloc]initWithCapacity:10];
    _iUnPublisDic = [[NSMutableDictionary alloc]initWithCapacity:10];
    _iMediaMutableDic = [[NSMutableDictionary alloc]initWithCapacity:10];
    _iDocmentMutableDic = [[NSMutableDictionary alloc]initWithCapacity:10];
    _iDocmentMutableArray =[[NSMutableArray alloc] init];
    _iMediaMutableArray = [[NSMutableArray alloc]init];
 
    _iIsJoined = NO;
    _isClassBegin = NO;
    _iIsClassEnd = YES;
    _getCameraFail = NO;
    _getMicrophoneFail = NO;
    _isPlayMedia = NO;
    _iIsPlaying = NO;
    _isLocal = NO;
    _isChangeMedia = NO;
    _iHasPublishStd = NO;
    _iStdOutBottom = NO;
    _iIsFullState = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
        //FIXME:todo
    [self joinEduClassRoomWithParam:paramDic aProperties:nil];
    
}

- (void)setSessionDelegate:(id<TKEduSessionDelegate>) aSessionDelegate
            aBoardDelegate:(id<TKEduBoardDelegate>)aBoardDelegate
           aRoomProperties:(TKEduRoomProperty*)aRoomProperties{
    
    _iSessionDelegate  = aSessionDelegate;
    _iWhiteBoardDelegate = aBoardDelegate;
    _iRoomProperties = aRoomProperties;
    
}
- (void)configurePlaybackSession:(NSDictionary*)paramDic
                   aRoomDelegate:(id<TKEduRoomDelegate>) aRoomDelegate
                aSessionDelegate:(id<TKEduSessionDelegate>) aSessionDelegate
                  aBoardDelegate:(id<TKEduBoardDelegate>)aBoardDelegate
                 aRoomProperties:(TKEduRoomProperty*)aRoomProperties
{
    
#if TARGET_OS_IPHONE
    _iRoomDelegate     = aRoomDelegate;
    _iSessionDelegate  = aSessionDelegate;
    _iWhiteBoardDelegate = aBoardDelegate;
    _iParamDic         = paramDic;
    
    NSDictionary *config = @{TKWhiteBoardWebProtocolKey:sHttp,
                             TKWhiteBoardWebHostKey:sHost,
                             TKWhiteBoardWebPortKey:sPort,
                             TKWhiteBoardPlayBackKey:@(YES),
                             };
    _whiteBoardManager = [TKWhiteBoardManager shareInstance];
    [_whiteBoardManager registerDelegate:self configration:config];
    [self initPlaybackRoomManager:true];
    
#endif
    
    _iMessageList                = [[NSMutableArray alloc] init];
    _unReadMessagesArray         = [[NSMutableArray alloc] init];
    _iUserList                   = [[NSMutableArray alloc] init];
    _iUserStdAndTchrList         = [[NSMutableArray alloc] init];
    _iSpecialUserDic             = [[NSMutableDictionary alloc]initWithCapacity:10];
    _iUserPlayAudioArray         = [[NSMutableSet alloc] init];
    _msgList                     = [NSMutableArray array];
    _iRoomProperties             = aRoomProperties;
    _iPendingButtonDic = [[NSMutableDictionary alloc]initWithCapacity:10];
    _iPublishDic = [[NSMutableDictionary alloc]initWithCapacity:10];
    _iUnPublisDic = [[NSMutableDictionary alloc]initWithCapacity:10];
    _iMediaMutableDic = [[NSMutableDictionary alloc]initWithCapacity:10];
    _iDocmentMutableDic = [[NSMutableDictionary alloc]initWithCapacity:10];
    _iDocmentMutableArray =[[NSMutableArray alloc] init];
    _iMediaMutableArray = [[NSMutableArray alloc]init];
    
    _iIsJoined = NO;
    _isPlayMedia = NO;
    _iIsPlaying = NO;
    _isLocal = NO;
    _isChangeMedia = NO;
    _iHasPublishStd = NO;
    _iStdOutBottom = NO;
    _iIsFullState = NO;
   
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    //FIXME:todo
    [self joinEduClassRoomWithParam:paramDic aProperties:nil];
}

- (void)joinEduClassRoomWithParam:(NSDictionary *)aParamDic aProperties:(NSDictionary *)aProperties{
    
    
    if (_roomMgr) {
#ifdef Debug
        //8889 8891
//        [_roomMgr setTestServer:@"192.168.1.25" Port:@"8889"];
#endif
        NSString *tHost = [_iParamDic objectForKey:@"host"]?[_iParamDic objectForKey:@"host"]:sHost;
        NSString *tPort = [_iParamDic objectForKey:@"port"]?[_iParamDic objectForKey:@"port"]:sPort;
        NSString *tNickName = [_iParamDic objectForKey:@"nickname"]?[_iParamDic objectForKey:@"nickname"]:@"test";
        bool isConform = [TKUtil  deviceisConform];
        //isConform      = true;    // 注释掉后开启低功耗
        
        
        if (self.isPlayback) {
            [_roomMgr joinPlaybackRoomWithHost:tHost port:(int)[tPort integerValue] nickName:tNickName roomParams:(NSDictionary *)aParamDic userParams:(NSDictionary *)aProperties lowConsume:!isConform];
        } else {
            [_roomMgr joinRoomWithHost:sHost port:(int)[tPort integerValue] nickName:tNickName roomParams:aParamDic userParams:aProperties lowConsume:!isConform];
            
        }
        // 设备缺失提示
        [self checkDevice];
    }
}

#pragma mark session方法

- (int)sessionHandleSetDeviceOrientation:(UIDeviceOrientation)orientation{
   return [_roomMgr setVideoOrientation:orientation];
}
- (void)sessionHandleLeaveRoom:(void (^)(NSError *error))block
{
     [_roomMgr leaveRoom:block];
}

- (void)sessionHandleLeaveRoom:(BOOL)force Completion:(void (^)(NSError *))block
{
    [_roomMgr leaveRoom:force Completion:block];
}
-(void)sessionHandleVideoProfile:(TKVideoProfile *)videoProfile{
    [_roomMgr setVideoProfile:videoProfile];
}
//看视频 
- (int)sessionHandlePlayVideo:(NSString *)peerID
                   renderType:(TKRenderMode)renderType
                       window:(UIView *)window
                   completion:(completion_block)completion
{
    [_roomMgr playAudio:peerID completion:nil];
    
    return [_roomMgr playVideo:peerID renderType:renderType window:window completion:completion];
    
}
//不看
- (void)sessionHandleUnPlayVideo:(NSString*)peerID completion:(void (^)(NSError *error))block
{
    [_roomMgr unPlayAudio:peerID completion:nil];
    [_roomMgr unPlayVideo:peerID completion:block];
}
//状态变化
- (void)sessionHandleChangeUserProperty:(NSString*)peerID TellWhom:(NSString*)tellWhom Key:(NSString*)key Value:(NSObject*)value completion:(void (^)(NSError *error))block
{
     [_roomMgr changeUserProperty:peerID tellWhom:tellWhom key:key value:value completion:block];
}

- (void)sessionHandleChangeUserPropertyByRole:(NSArray *)roles
                                     tellWhom:(NSString *)tellWhom
                                     property:(NSDictionary *)properties
                                   completion:(completion_block _Nullable)completion {
    
    [_roomMgr changeUserPropertyByRole:roles tellWhom:tellWhom property:properties completion:completion];
}
- (void)sessionHandleChangeUserProperty:(NSString*)peerID TellWhom:(NSString*)tellWhom data:(NSDictionary*)data completion:(void (^)(NSError *error))block{
    
    [_roomMgr changeUserProperty:peerID tellWhom:tellWhom data:data completion:block];
}

- (void)sessionHandleApplicationWillEnterForeground
{
    [_roomMgr pubMsg:sUpdateTime msgID:sUpdateTime toID:self.localUser.peerID data:@"" save:NO completion:nil];
}

- (void)sessionHandleChangeUserPublish:(NSString*)peerID Publish:(int)publish completion:(void (^)(NSError *error))block
{
    
    
//    PublishState_NONE           = 0,            //没有
//    PublishState_AUDIOONLY      = 1,            //只有音频
//    PublishState_VIDEOONLY      = 2,            //只有视频
//    PublishState_BOTH           = 3,            //都有
//    PublishState_NONE_ONSTAGE   = 4,            //音视频都没有但还在台上
//    PublishState_Local_NONE     = 5             //本地显示流
//    switch (publish) {
//        case 0:
//            [_roomMgr unPublishAudio:nil];
//            [_roomMgr unPublishVideo:nil];
//            break;
//        case 1:
//
//            [_roomMgr unPublishVideo:nil];
//            [_roomMgr publishAudio:nil];
//
//            break;
//        case 2:
//            [_roomMgr publishAudio:nil];
//
//            break;
//        case 3:
//
//            break;
//        case 4:
//
//            break;
//        default:
//            break;
//    }
    [_roomMgr changeUserPublish:peerID publishState:publish completion:nil];
}

- (void)sessionHandleSendMessage:(NSObject *)message toID:(NSString *)toID extensionJson:(NSObject *)extension
{
    [_roomMgr sendMessage:message toID:toID extensionJson:extension];
}

- (int)sessionHandleGetRoomUserNumberWithRole:(NSArray * _Nullable)role callback:(void (^)(NSInteger num, NSError *error))callback{
    
//    return [_roomMgr getRoomUserNumberWithRole:role callback:callback];
    return [_roomMgr getRoomUserNumberWithRole:role search:@"" callback:callback];
}
- (int)sessionHandleGetRoomUsersWithRole:(NSArray * _Nullable)role startIndex:(NSInteger)start maxNumber:(NSInteger)max callback:(void (^)(NSArray <TKRoomUser *>* _Nonnull users , NSError *error) )callback{
//    return [_roomMgr getRoomUsersWithRole:role startIndex:start maxNumber:max callback:callback];
    
    return [_roomMgr getRoomUsersWithRole:role startIndex:start maxNumber:max search:@"" order:@{@"ts":@"asc"} callback:callback];
}
- (void)sessionHandlePubMsg:(NSString*)msgName ID:(NSString*)msgID To:(NSString*)toID Data:(NSObject*)data Save:(BOOL)save completion:(void (^)(NSError *error))block{
//   return [_roomMgr pubMsg:msgName ID:msgID To:toID Data:data Save:save completion:block];
    
      [_roomMgr pubMsg:msgName msgID:msgID toID:toID data:data save:save completion:block];
}

- (void)sessionHandlePubMsg:(NSString *)msgName ID:(NSString *)msgID To:(NSString *)toID Data:(NSObject *)data Save:(BOOL)save AssociatedMsgID:(NSString *)associatedMsgID AssociatedUserID:(NSString *)associatedUserID
                    expires:(NSTimeInterval)expires completion:(void (^)(NSError *))block
{
    if(associatedMsgID == nil && ( ![msgName isEqualToString:sClassBegin] && ![msgName isEqualToString:sUpdateTime] && ![msgName isEqualToString:sDocumentChange] && ![msgName isEqualToString:sShowPage] && ![msgName isEqualToString:sSharpsChange] && ![msgName isEqualToString:sWBPageCount]) ){
        associatedMsgID = sClassBegin;
    }
    [_roomMgr pubMsg:msgName msgID:msgID toID:toID data:data save:save associatedMsgID:associatedMsgID associatedUserID:associatedUserID expires:expires completion:block];
}

- (void)sessionHandleDelMsg:(NSString*)msgName ID:(NSString*)msgID To:(NSString*)toID Data:(NSObject*)data completion:(void (^)(NSError *error))block
{
    [_roomMgr delMsg:msgName msgID:msgID toID:toID data:data completion:block];
}

- (void)sessionHandleEvictUser:(NSString *)peerID  evictReason:(NSNumber *)reason completion:(completion_block)completion
{
     [_roomMgr evictUser:peerID evictReason:reason completion:completion];
}


//WebRTC & Media

- (void)sessionHandleSelectCameraPosition:(BOOL)isFront
{
      [_roomMgr selectCameraPosition:isFront];
}

- (BOOL)sessionHandleIsVideoEnabled
{
    return  [_roomMgr isVideoEnabled];
}

- (void)sessionHandleEnableVideo:(BOOL)enable
{
      [_roomMgr enableVideo:enable];
}

- (BOOL)sessionHandleIsAudioEnabled
{
   return  [_roomMgr isAudioEnabled];
}
- (void)sessionHandleEnableAllAudio:(BOOL)enable
{
    
    [self sessionHandleEnableOtherAudio:enable];
    [self sessionHandleEnableAudio:enable];
}
- (void)sessionHandleEnableAudio:(BOOL)enable
{
      [_roomMgr enableAudio:enable];
}
- (void)sessionHandleEnableOtherAudio:(BOOL)enable
{
//     [_roomMgr enableOtherAudio:enable];
}

- (void)sessionHandleUseLoudSpeaker:(BOOL)use
{
    
//     [self sessionUseLoudSpeaker:use];
}
- (void)sessionUseLoudSpeaker:(BOOL)use
{
    AVAudioSession* session = [AVAudioSession sharedInstance];
    NSError* error;
    if (_isHeadphones) {
        [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionMixWithOthers | AVAudioSessionCategoryOptionAllowBluetooth  error:nil];
        [session overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:&error];
        return;
    }
    
    [session overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:&error];
    if (!use) {
        
        [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker|AVAudioSessionCategoryOptionMixWithOthers | AVAudioSessionCategoryOptionAllowBluetooth error:&error];
        [session setMode:AVAudioSessionModeVoiceChat error:nil];
        
    }else{
        
        [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker|AVAudioSessionCategoryOptionMixWithOthers | AVAudioSessionCategoryOptionAllowBluetooth  error:&error];
        [session setMode:AVAudioSessionModeDefault  error:nil];
        
    }
    [session setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error];
    //[_session sessionUseLoudSpeaker:use];
}
#pragma mark -  room manager delegate

//1自己进入课堂
- (void)roomManagerRoomJoined
{
    
    if (!self.UIDidAppear) {
        
        NSString *methodName = NSStringFromSelector(@selector(sessionManagerRoomJoined));
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:methodName forKey:kTKMethodNameKey];
        [self.cacheMsgPool addObject:dic];
        
        return;
    }
    
    if (_iSessionDelegate && [_iSessionDelegate respondsToSelector:@selector(sessionManagerRoomJoined)]) {
        [(id<TKEduSessionDelegate>)_iSessionDelegate sessionManagerRoomJoined];
        
    }
    if (_iRoomDelegate && [_iRoomDelegate respondsToSelector:@selector(joinRoomComplete)]) {
        [(id<TKEduRoomDelegate>)_iRoomDelegate  joinRoomComplete];
        
    }
}
//2自己离开课堂
- (void)roomManagerRoomLeft
{
    if (!self.UIDidAppear) {
        NSString *methodName = NSStringFromSelector(@selector(sessionManagerRoomLeft));
        NSDictionary *dic = @{
                              kTKMethodNameKey : methodName,
                              };
        [self.cacheMsgPool addObject:dic];
        return;
    }
    
    if (_iSessionDelegate && [_iSessionDelegate respondsToSelector:@selector(sessionManagerRoomLeft)]) {
        [(id<TKEduSessionDelegate>)_iSessionDelegate sessionManagerRoomLeft];
        
    }
    if (_iRoomDelegate && [_iRoomDelegate respondsToSelector:@selector(leftRoomComplete)]) {
        [(id<TKEduRoomDelegate>)_iRoomDelegate  leftRoomComplete];
    }
}

// 发生警告 回调
- (void)roomManagerDidOccuredWaring:(TKRoomWarningCode)code
{
    if ( self.iClassRoomDelegate && [self.iClassRoomDelegate respondsToSelector:@selector(sessionRoomManagerDidOccuredWaring:)]) {
//        NSError *error = [NSError errorWithDomain:@"com.talkcloud" code:code userInfo:nil];
        [self.iClassRoomDelegate sessionRoomManagerDidOccuredWaring:code];
    }
    
    if (!self.UIDidAppear) {
        NSString *methodName = NSStringFromSelector(@selector(sessionManagerDidOccuredWaring:));
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:methodName forKey:kTKMethodNameKey];
        [dic setValue:@[@(code)] forKey:kTKParameterKey];
        [self.cacheMsgPool addObject:dic];
         return;
    }
    
    if (self.iSessionDelegate && [self.iSessionDelegate respondsToSelector:@selector(sessionManagerDidOccuredWaring:)]) {
        [self.iSessionDelegate sessionManagerDidOccuredWaring:code];
    }
    
    
    TKLog(@"TKRoomWarningCode:%ld",(long)code);  
}
/**
 自己被踢出房间
 @param reason 被踢原因
 */
- (void)roomManagerKickedOut:(NSDictionary *)reason
{
    // 记录被T 时间
    if ([reason[@"reason"] integerValue] == 1) {
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:TKKickTime];
        NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:TKKickTime]);
    }
    if (!self.UIDidAppear) {
        NSString *methodName = NSStringFromSelector(@selector(sessionManagerSelfEvicted:));
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:methodName forKey:kTKMethodNameKey];
        [dic setValue:@[reason] forKey:kTKParameterKey];
        
        [self.cacheMsgPool addObject:dic];
         return;
    }
    
    
    //classbegin
    if (_iSessionDelegate && [_iSessionDelegate respondsToSelector:@selector(sessionManagerSelfEvicted:)]) {
       
        [(id<TKEduSessionDelegate>)_iSessionDelegate sessionManagerSelfEvicted:reason];
        
    }
    
    if (_iRoomDelegate && [_iRoomDelegate respondsToSelector:@selector(onKitout:)]) {
        
        [(id<TKEduRoomDelegate>)_iRoomDelegate onKitout:EKickOutReason_Repeat];
        
    }
     TKLog(@"jin roomManagerSelfEvicted");
}

//3观看视频取消视频
- (void)roomManagerPublishStateWithUserID:(NSString *)peerID publishState:(TKPublishState)state
{
    if (!self.UIDidAppear) {
        NSString *methodName = NSStringFromSelector(@selector(sessionManagerPublishStateWithUserID:publishState:));
    
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:methodName forKey:kTKMethodNameKey];
        [dic setValue:@[peerID,@(state)] forKey:kTKParameterKey];
        
        
        [self.cacheMsgPool addObject:dic];
         return;
    }
    
    
    if (_iSessionDelegate && [_iSessionDelegate respondsToSelector:@selector(sessionManagerPublishStateWithUserID:publishState:)]) {
        [(id<TKEduSessionDelegate>)_iSessionDelegate sessionManagerPublishStateWithUserID:peerID publishState:state];
        
    }
     TKLog(@"jin roomManagerUserPublished");
}


- (void)roomManagerOnAudioVolumeWithPeerID:(NSString *)peeID volume:(int)volume{
//    NSLog(@"%@,%d",peeID,volume);
    if (_iSessionDelegate && [_iSessionDelegate respondsToSelector:@selector(sessionManagerOnAudioVolumeWithPeerID:volume:)]) {
        [(id<TKEduSessionDelegate>)_iSessionDelegate sessionManagerOnAudioVolumeWithPeerID:peeID volume:volume];
    }
    
    
}
//5用户进入
- (void)roomManagerUserJoined:(NSString *)peerID inList:(BOOL)inList
{
    
    TKRoomUser *roomUser = [[TKEduSessionHandle shareInstance].roomMgr getRoomUserWithUId:peerID];
    
    if (!self.UIDidAppear) {
        NSString *methodName = NSStringFromSelector(@selector(sessionManagerUserJoined:InList:));
    
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:methodName forKey:kTKMethodNameKey];
        [dic setValue:@[roomUser,@(inList)] forKey:kTKParameterKey];
        
        [self.cacheMsgPool addObject:dic];
        return;
    }
    
    if (_iSessionDelegate && [_iSessionDelegate respondsToSelector:@selector(sessionManagerUserJoined:InList:)]) {
        [(id<TKEduSessionDelegate>)_iSessionDelegate sessionManagerUserJoined:roomUser InList:inList];
        
    }
     TKLog(@"jin roomManagerUserJoined");
}

//6用户离开
- (void)roomManagerUserLeft:(NSString *)peerID
{
    if (!self.UIDidAppear) {
        NSString *methodName = NSStringFromSelector(@selector(sessionManagerUserLeft:));
      
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:methodName forKey:kTKMethodNameKey];
        [dic setValue:@[peerID] forKey:kTKParameterKey];
        
        [self.cacheMsgPool addObject:dic];
        return;
    }
    
    if (_iSessionDelegate && [_iSessionDelegate respondsToSelector:@selector(sessionManagerUserLeft:)]) {
        
        [(id<TKEduSessionDelegate>)_iSessionDelegate sessionManagerUserLeft:peerID];
        
    }
   
     TKLog(@"jin roomManagerUserLeft");
}
//7用户信息变化

- (void)roomManagerUserPropertyChanged:(NSString *)peerID
                            properties:(NSDictionary*)properties
                                fromId:(NSString *)fromId
{
  
    
    TKRoomUser *user = [[TKEduSessionHandle shareInstance].roomMgr getRoomUserWithUId:peerID];
    
    if (!self.UIDidAppear) {
        NSString *methodName = NSStringFromSelector(@selector(sessionManagerUserChanged:Properties:fromId:));
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:methodName forKey:kTKMethodNameKey];
        [dic setValue:@[user,properties,fromId] forKey:kTKParameterKey];
        
        [self.cacheMsgPool addObject:dic];
        return;
    }
    if (_iSessionDelegate && [_iSessionDelegate respondsToSelector:@selector(sessionManagerUserChanged:Properties:fromId:)]) {
        [(id<TKEduSessionDelegate>)_iSessionDelegate sessionManagerUserChanged:user Properties:properties fromId:fromId];
        
    }
}

//8聊天信息
- (void)roomManagerMessageReceived:(NSString *)message
                            fromID:(NSString *)peerID
                         extension:(NSDictionary *)extension
{
    if (!self.UIDidAppear) {
        NSString *methodName = NSStringFromSelector(@selector(sessionManagerMessageReceived:fromID:extension:));
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:methodName forKey:kTKMethodNameKey];
        [dic setValue: @[message,peerID,extension] forKey:kTKParameterKey];
        
        
        [self.cacheMsgPool addObject:dic];
    }
    
    if (_iSessionDelegate && [_iSessionDelegate respondsToSelector:@selector(sessionManagerMessageReceived:fromID:extension:)]) {
        [(id<TKEduSessionDelegate>)_iSessionDelegate sessionManagerMessageReceived:message fromID:peerID extension:extension];
    }
}

// 回放聊天信息带有时间戳

- (void)roomManagerPlaybackMessageReceived:(NSString *)message
                                    fromID:(NSString *)peerID
                                        ts:(NSTimeInterval)ts
                                 extension:(NSDictionary *)extension
//- (void)roomManagerPlaybackMessageReceived:(NSString *)message ofUser:(TKRoomUser *)user ts:(NSTimeInterval)ts
{
    if (!self.UIDidAppear) {
        NSString *methodName = NSStringFromSelector(@selector(sessionManagerRoomManagerPlaybackMessageReceived:fromID:ts:extension:));
     
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:methodName forKey:kTKMethodNameKey];
        [dic setValue:@[message,peerID,@(ts),extension] forKey:kTKParameterKey];
        
        [self.cacheMsgPool addObject:dic];
        return;
    }
    
    if (_iSessionDelegate && [_iSessionDelegate respondsToSelector:@selector(sessionManagerRoomManagerPlaybackMessageReceived:fromID:ts:extension:)]) {
        [(id<TKEduSessionDelegate>)_iSessionDelegate sessionManagerRoomManagerPlaybackMessageReceived:message fromID:peerID ts:ts extension:extension];
    }
}


#pragma mark - 进入会议失败


- (void)roomManagerDidOccuredError:(NSError *)error
{
//    if (error.code == TKErrorCode_CheckRoom_Success) {
        //checkroom 成功
    if (self.iClassRoomDelegate && [self.iClassRoomDelegate respondsToSelector:@selector(sessionClassRoomDidOccuredError:)]) {
       
        [self.iClassRoomDelegate sessionClassRoomDidOccuredError:error];
    }
//        return;
    
//    }
   
    
    if (!self.UIDidAppear) {
        NSString *methodName = NSStringFromSelector(@selector(sessionManagerDidFailWithError:));
      
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:methodName forKey:kTKMethodNameKey];
        [dic setValue:@[error] forKey:kTKParameterKey];
        
        
        [self.cacheMsgPool addObject:dic];
        return;
    }
    
   
    
    if (_iSessionDelegate && [_iSessionDelegate respondsToSelector:@selector(sessionManagerDidFailWithError:)]) {
        [(id<TKEduSessionDelegate>)_iSessionDelegate sessionManagerDidFailWithError:error];
        
    }
    if (_iRoomDelegate && [_iRoomDelegate respondsToSelector:@selector(onEnterRoomFailed:Description:)]) {

        [(id<TKEduRoomDelegate>)_iRoomDelegate onEnterRoomFailed:(int)error.code Description:error.description];
    }
    
    TKLog(@"jin roomManagerDidFailWithError %@", error);
}



- (void)roomManagerOnRemotePubMsgWithMsgID:(NSString *)msgID
                                   msgName:(NSString *)msgName
                                      data:(NSObject *)data
                                    fromID:(NSString *)fromID
                                    inList:(BOOL)inlist
                                        ts:(long)ts
{
    [self roomManagerOnRemoteMsg:YES ID:msgID Name:msgName TS:ts Data:data InList:inlist];
    
}
- (void)roomManagerOnRemoteDelMsgWithMsgID:(NSString *)msgID
                                   msgName:(NSString *)msgName
                                      data:(NSObject *)data
                                    fromID:(NSString *)fromID
                                    inList:(BOOL)inlist
                                        ts:(long)ts
{
    
    [self roomManagerOnRemoteMsg:NO ID:msgID Name:msgName TS:ts Data:data InList:inlist];
    
}
- (void)roomManagerOnRemoteMsg:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(unsigned long)ts Data:(NSObject*)data InList:(BOOL)inlist
{
    
    if (!self.UIDidAppear) {
        NSString *methodName = NSStringFromSelector(@selector(sessionManagerOnRemoteMsg:ID:Name:TS:Data:InList:));
       
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:methodName forKey:kTKMethodNameKey];
        [dic setValue:@[@(add),msgID,msgName,@(ts),data,@(inlist)] forKey:kTKParameterKey];
        
        
        [self.cacheMsgPool addObject:dic];
        return;
    }
    
    
    //classbegin
    if (_iSessionDelegate && [_iSessionDelegate respondsToSelector:@selector(sessionManagerOnRemoteMsg:ID:Name:TS:Data:InList:)]) {
        [(id<TKEduSessionDelegate>) _iSessionDelegate sessionManagerOnRemoteMsg:add ID:msgID Name:msgName TS:ts Data:data InList:inlist];
        
    }
    //会议开始或者结束
    if ([msgName isEqualToString:sClassBegin]) {
        if (add) {
            
            if (_iRoomDelegate && [_iRoomDelegate respondsToSelector:@selector(onClassBegin)]) {
                
                [(id<TKEduRoomDelegate>)_iRoomDelegate onClassBegin];
                
            }
        }else{
            
            if (_iRoomDelegate && [_iRoomDelegate respondsToSelector:@selector(onClassDismiss)]) {
                [(id<TKEduRoomDelegate>)_iRoomDelegate onClassDismiss];
                
            }
        }
    }
     TKLog(@"jin roomManagerOnRemoteMsg");
}

// 首次发布或订阅失败3次通知
- (void)roomManagerReportNetworkProblem
{
    if (!self.UIDidAppear) {
        NSString *methodName = NSStringFromSelector(@selector(networkTrouble));
        NSDictionary *dic = @{
                              kTKMethodNameKey : methodName,
                              };
        
        [self.cacheMsgPool addObject:dic];
    }
    
    if (_iSessionDelegate && [_iSessionDelegate respondsToSelector:@selector(networkTrouble)]) {
        [(id<TKEduSessionDelegate>) _iSessionDelegate networkTrouble];
    }
}

- (void)roomManagerReportNetworkChanged
{
    if (!self.UIDidAppear) {
        NSString *methodName = NSStringFromSelector(@selector(networkChanged));
        NSDictionary *dic = @{
                              kTKMethodNameKey : methodName,
                              };
        
        [self.cacheMsgPool addObject:dic];
    }
    
    if (_iSessionDelegate && [_iSessionDelegate respondsToSelector:@selector(networkChanged)]) {
        [(id<TKEduSessionDelegate>) _iSessionDelegate networkChanged];
    }
}

// 连接服务器成功
- (void)roomManagerConnected:(dispatch_block_t)completion
{
    if (!self.UIDidAppear) {
        NSString *methodName = NSStringFromSelector(@selector(sessionManagerGetGiftNumber:));
      
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:methodName forKey:kTKMethodNameKey];
        [dic setValue:@[completion] forKey:kTKParameterKey];
        
        [self.cacheMsgPool addObject:dic];
        return;
    }
    
    if (_iSessionDelegate && [_iSessionDelegate respondsToSelector:@selector(sessionManagerGetGiftNumber:)]) {
        [(id<TKEduSessionDelegate>)_iSessionDelegate sessionManagerGetGiftNumber:completion];
    }
}

#pragma mark media
- (void)roomManagerOnShareMediaState:(NSString *)peerId state:(TKMediaState)state extensionMessage:(NSDictionary *)message
{
    if (!self.UIDidAppear) {
        NSString *methodName = NSStringFromSelector(@selector(sessionManagerOnShareMediaState:state:extensionMessage:));
      
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:methodName forKey:kTKMethodNameKey];
        [dic setValue:@[peerId,@(state),message] forKey:kTKParameterKey];
        
        [self.cacheMsgPool addObject:dic];
        return;
    }
    
    
    if (_iSessionDelegate && [_iSessionDelegate respondsToSelector:@selector(sessionManagerOnShareMediaState:state:extensionMessage:)]) {
        [(id<TKEduSessionDelegate>) _iSessionDelegate sessionManagerOnShareMediaState:peerId state:state extensionMessage:message];
    }
}

- (void)roomManagerUpdateMediaStream:(NSTimeInterval)duration
                                 pos:(NSTimeInterval)pos
                              isPlay:(BOOL)isPlay
{
    if (!self.UIDidAppear) {
        NSString *methodName = NSStringFromSelector(@selector(sessionManagerUpdateMediaStream:pos:isPlay:));
      
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:methodName forKey:kTKMethodNameKey];
        [dic setValue:@[@(duration),@(pos),@(isPlay)] forKey:kTKParameterKey];
        
        
        [self.cacheMsgPool addObject:dic];
        return;
    }
    
    if (_iSessionDelegate && [_iSessionDelegate respondsToSelector:@selector(sessionManagerUpdateMediaStream:pos:isPlay:)]) {
        [(id<TKEduSessionDelegate>) _iSessionDelegate sessionManagerUpdateMediaStream:duration pos:pos isPlay:isPlay];
    }
}

- (void)roomManagerMediaLoaded
{
    if (!self.UIDidAppear) {
        NSString *methodName = NSStringFromSelector(@selector(sessionManagerMediaLoaded));
        NSDictionary *dic = @{
                              kTKMethodNameKey : methodName,
                              };
        
        [self.cacheMsgPool addObject:dic];
    }
    
    if (_iSessionDelegate && [_iSessionDelegate respondsToSelector:@selector(sessionManagerMediaLoaded)]) {
        [(id<TKEduSessionDelegate>) _iSessionDelegate sessionManagerMediaLoaded];
    }
}
#pragma mark screen

- (void)roomManagerOnShareScreenState:(NSString *)peerId state:(TKMediaState)state extensionMessage:(NSDictionary *)message{
    
    if (!self.UIDidAppear) {
        NSString *methodName = NSStringFromSelector(@selector(roomManagerOnShareScreenState:state:extensionMessage:));
      
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:methodName forKey:kTKMethodNameKey];
        [dic setValue:@[peerId,@(state),message] forKey:kTKParameterKey];
        
        [self.cacheMsgPool addObject:dic];
        return;
    }
    
    
    if (_iSessionDelegate && [_iSessionDelegate respondsToSelector:@selector(sessionManagerOnShareScreenState:state:extensionMessage:)]) {
        
        [(id<TKEduSessionDelegate>) _iSessionDelegate sessionManagerOnShareScreenState:peerId state:state extensionMessage:message];
    }
}

#pragma mark file
- (void)roomManagerOnShareFileState:(NSString *)peerId state:(TKMediaState)state extensionMessage:(NSDictionary *)message{
    
    if (!self.UIDidAppear) {
        NSString *methodName = NSStringFromSelector(@selector(sessionManagerOnShareFileState:state:extensionMessage:));
       
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:methodName forKey:kTKMethodNameKey];
        [dic setValue:@[peerId,@(state),message] forKey:kTKParameterKey];
        
        [self.cacheMsgPool addObject:dic];
        return;
    }
    
    if (_iSessionDelegate && [_iSessionDelegate respondsToSelector:@selector(sessionManagerOnShareFileState:state:extensionMessage:)]) {
        [(id<TKEduSessionDelegate>) _iSessionDelegate sessionManagerOnShareFileState:peerId state:state extensionMessage:message];
    }
    
}


#pragma mark Playback

- (void)roomManagerPlaybackClearAll
{
    
    if (!self.UIDidAppear) {
        NSString *methodName = NSStringFromSelector(@selector(sessionManagerPlaybackClearAll));
        NSDictionary *dic = @{
                              kTKMethodNameKey : methodName,
                              };
        
        [self.cacheMsgPool addObject:dic];
    }
    
    if (_iSessionDelegate && [_iSessionDelegate respondsToSelector:@selector(sessionManagerPlaybackClearAll)]) {
        [(id<TKEduSessionDelegate>) _iSessionDelegate sessionManagerPlaybackClearAll];
    }
}

- (void)roomManagerReceivePlaybackDuration:(NSTimeInterval)duration
{
    if (!self.UIDidAppear) {
        NSString *methodName = NSStringFromSelector(@selector(sessionManagerReceivePlaybackDuration:));
      
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:methodName forKey:kTKMethodNameKey];
        [dic setValue:@[@(duration)] forKey:kTKParameterKey];
        
        
        [self.cacheMsgPool addObject:dic];
        return;
    }
    
    if (_iSessionDelegate && [_iSessionDelegate respondsToSelector:@selector(sessionManagerReceivePlaybackDuration:)]) {
        [(id<TKEduSessionDelegate>) _iSessionDelegate sessionManagerReceivePlaybackDuration:duration];
    }
}

- (void)roomManagerPlaybackUpdateTime:(NSTimeInterval)time
{
    if (!self.UIDidAppear) {
        NSString *methodName = NSStringFromSelector(@selector(sessionManagerPlaybackUpdateTime:));
       
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:methodName forKey:kTKMethodNameKey];
        [dic setValue:@[@(time)] forKey:kTKParameterKey];
        
        [self.cacheMsgPool addObject:dic];
        return;
    }
    
    if (_iSessionDelegate && [_iSessionDelegate respondsToSelector:@selector(sessionManagerPlaybackUpdateTime:)]) {
        [(id<TKEduSessionDelegate>) _iSessionDelegate sessionManagerPlaybackUpdateTime:time];
    }
}

- (void)roomManagerPlaybackEnd
{
    if (!self.UIDidAppear) {
        NSString *methodName = NSStringFromSelector(@selector(sessionManagerPlaybackEnd));
        NSDictionary *dic = @{
                              kTKMethodNameKey : methodName,
                              };
        
        [self.cacheMsgPool addObject:dic];
    }
    
    if (_iSessionDelegate && [_iSessionDelegate respondsToSelector:@selector(sessionManagerPlaybackEnd)]) {
        [(id<TKEduSessionDelegate>) _iSessionDelegate sessionManagerPlaybackEnd];
    }
}

#pragma mark - roomWhiteBoard Delegate
- (void)onWhiteBoardOnRoomConnectedMsglist:(NSDictionary *)msgList
{
    
    NSSortDescriptor *desc = [[NSSortDescriptor alloc] initWithKey:@"seq" ascending:YES];
    NSArray *sorted = [[msgList allValues] sortedArrayUsingDescriptors:@[desc]];
    
    //    注释代码为之前内容
    NSMutableDictionary *tParamDic = [[NSMutableDictionary alloc] initWithCapacity:10];
    BOOL tIsHavePageList = NO;
    BOOL tIsCanPage      = NO;
    for (NSDictionary *tParamDictemp in sorted) {
        NSString *tID = [tParamDictemp objectForKey:@"id"];
        [tParamDic setObject:tParamDictemp forKey:tID];
        
        if ([[tParamDictemp objectForKey:@"name"] isEqualToString:sShowPage]) {
            tIsHavePageList = YES;
            NSString *dataJson = [tParamDictemp objectForKey:@"data"];
            NSDictionary *tDataDic = @{};
            
            //TKLog(@"-----%@", [NSString stringWithFormat:@"msgName:%@,msgID:%@",msgName,msgID]);
            if ([dataJson isKindOfClass:[NSString class]]) {
                NSString *tDataString = [NSString stringWithFormat:@"%@",dataJson];
                NSData *tJsData = [tDataString dataUsingEncoding:NSUTF8StringEncoding];
                tDataDic = [NSJSONSerialization JSONObjectWithData:tJsData options:NSJSONReadingMutableContainers error:nil];
            }
            if ([dataJson isKindOfClass:[NSDictionary class]]) {
                tDataDic = (NSDictionary *)dataJson;
            }
            
            NSDictionary *filedata = [tDataDic objectForKey:@"filedata"];
            NSNumber *fileid = [filedata objectForKey:@"fileid"]?[filedata objectForKey:@"fileid"]:@(0);
            
            _iPreDocmentModel = _iCurrentDocmentModel;
            _iCurrentDocmentModel = [_iDocmentMutableDic objectForKey:[NSString stringWithFormat:@"%@", fileid]];
            
        }
        if ([[tParamDictemp objectForKey:@"name"] isEqualToString:sClassBegin]) {
            tIsCanPage = YES;
        }
    }
    
    [self.whiteBoardManager changeDocumentWithFileID:_iCurrentDocmentModel.fileid isBeginClass:self.isClassBegin isPubMsg:NO];
}

- (void)onWhiteBroadFileList:(NSArray *)fileList
{
    TKLog(@"jin onFileList");
    //添加一个白板
    NSNumber * companyid = @([self.iRoomProperties.iCompanyID integerValue]);
    
    NSDictionary *tDic = [_whiteBoardManager createWhiteBoard:companyid];
    NSMutableArray *tMutableFileList = [NSMutableArray arrayWithArray:fileList];
    [tMutableFileList insertObject:tDic atIndex:0];
    
//    int i = 0;
    
    for (NSDictionary *tFileDic in tMutableFileList) {
        //如果是媒体文档，则跳过
        if ([TKUtil getIsMedia:[tFileDic objectForKey:@"filetype"]]) {
            TKMediaDocModel *tMediaDocModel = [[TKMediaDocModel alloc]init];
            [tMediaDocModel setValuesForKeysWithDictionary:tFileDic];
            tMediaDocModel.isPlay = @(NO);
            [self addOrReplaceMediaArray:tMediaDocModel];
            
        }else{
            
            TKDocmentDocModel *tDocmentDocModel = [[TKDocmentDocModel alloc]init];
            [tDocmentDocModel setValuesForKeysWithDictionary:tFileDic];
            [tDocmentDocModel dynamicpptUpdate];
            [self addOrReplaceDocmentArray:tDocmentDocModel];
            if ([tDocmentDocModel.dynamicppt integerValue] == 1) {
                continue;
            }
            
            
//            if (i == 0 || i == 1 || [[NSString stringWithFormat:@"%@",tDocmentDocModel.type] isEqualToString:@"1"]) {
//                _iCurrentDocmentModel = _iDefaultDocment = tDocmentDocModel;
//            }
//
//            i++;
        }
    }
    
    // 文档排序
    [_iDocmentMutableArray sortUsingComparator:^NSComparisonResult(TKDocmentDocModel *  _Nonnull obj1, TKDocmentDocModel *  _Nonnull obj2) {
        
        if (obj1.fileid.integerValue > obj2.fileid.integerValue) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if (obj1.fileid.integerValue < obj2.fileid.integerValue) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    //设置默认文档 （规则）
    /* 1.先看是否有后台关联或接口设置过的默认文档，如果有，显示如果没有，
       2.显示课堂文件夹里第一个上传的课件，如果再没有，
       3.显示系统文件夹里第一个上传的课件；
       4.都没有，则选择白板
     */
    TKDocmentDocModel*defaultModel = nil;
    for (TKDocmentDocModel *model in self.docmentArray) {
        if ([model.type intValue]) {
            defaultModel = model;
        }
    }
    if (!defaultModel && self.classDocmentArray.count>1) {
        defaultModel = self.classDocmentArray[1];
    }
    if (!defaultModel && self.systemDocmentArray.count>1) {
        defaultModel = self.systemDocmentArray[1];
    }
    if (!defaultModel) {
        defaultModel = self.docmentArray.firstObject;
    }
    _iCurrentDocmentModel = _iDefaultDocment = defaultModel;

    //设置默认文档
    [[TKWhiteBoardManager shareInstance]setTheCurrentDocumentFileID:_iCurrentDocmentModel.fileid];
    
    // 媒体排序
    [_iMediaMutableArray sortUsingComparator:^NSComparisonResult(TKMediaDocModel *  _Nonnull obj1, TKMediaDocModel *  _Nonnull obj2) {
        
        if (obj1.fileid.integerValue > obj2.fileid.integerValue) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if (obj1.fileid.integerValue < obj2.fileid.integerValue) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    // 测试
    for (TKDocmentDocModel *model in _iDocmentMutableArray) {
        TKLog(@"文档 %ld", (long)model.fileid.integerValue);
    }
    
    for (TKMediaDocModel *model in _iMediaMutableArray) {
        TKLog(@"媒体 %ld", (long)model.fileid.integerValue);
    }
    
    
}
- (void)onWhiteBroadPubMsgWithMsgID:(NSString *)msgID msgName:(NSString *)msgName data:(NSObject *)data fromID:(NSString *)fromID inList:(BOOL)inlist ts:(long)ts
{
    
    BOOL tIsWhiteBoardDealWith = false;
    NSDictionary *tDataDic = @{};
    if ([data isKindOfClass:[NSString class]]) {
        NSString *tDataString = [NSString stringWithFormat:@"%@",data];
        NSData *tJsData = [tDataString dataUsingEncoding:NSUTF8StringEncoding];
        tDataDic = [NSJSONSerialization JSONObjectWithData:tJsData options:NSJSONReadingMutableContainers error:nil];
    }
    if ([data isKindOfClass:[NSDictionary class]]) {
        tDataDic = (NSDictionary *)data;
    }
    if ([msgName isEqualToString:sDocumentChange])
    {
        BOOL tIsDelete = [[tDataDic objectForKey:@"isDel"]boolValue];
        
        if (tIsDelete && [tDataDic objectForKey:@"isDel"]) {
            bool tIsMedia = [[tDataDic objectForKey:@"isMedia"]boolValue];
            if (tIsMedia) {
                
                TKMediaDocModel *tMediaDocModel = [self resolveMediaModelFromDic:tDataDic];
                UserType role = (UserType)self.localUser.role;
                BOOL isCurrntDM = [self isEqualFileId:tMediaDocModel aSecondModel:_iCurrentMediaDocModel];
                
                //老师-当前文档
                if (role == UserType_Teacher && isCurrntDM && self.isPlayMedia) {
                    [self sessionHandleUnpublishMedia:nil];
                }
                [self delMediaArray:tMediaDocModel];
                
            } else {
                
                
                TKDocmentDocModel *tDocmentDocModel = [self resolveDocumentModelFromDic:tDataDic];
                UserType role = (UserType)self.localUser.role;
                
                BOOL isCurrntDM = [self isEqualFileId:tDocmentDocModel aSecondModel:_iCurrentDocmentModel];
                
                //(学生-当前文档-未上课，删除时显示白板
                if ((role == UserType_Student) && isCurrntDM &&!_isClassBegin) {
                    
//                    [self docmentDefault:self.docmentArray.firstObject];
                    TKDocmentDocModel *model = (TKDocmentDocModel *)self.docmentArray.firstObject;
                    [self.whiteBoardManager changeDocumentWithFileID:model.fileid isBeginClass:self.isClassBegin isPubMsg:YES];
                    
                }
                //老师，巡课-当前文档
                if ((role == UserType_Teacher||role == UserType_Patrol)&& isCurrntDM) {
                    if (!_isClassBegin) {
                        [self.whiteBoardManager changeDocumentWithFileID:[self getNextDocment:tDocmentDocModel].fileid isBeginClass:self.isClassBegin isPubMsg:YES];
                        
                        if (self.isPlayMedia) {
                            // 如果PPT里面有视频，要取消
                            [self sessionHandleUnpublishMedia:nil];
                        }
                    }
                    /*
                     if (_isClassBegin) {
                     [self publishtDocMentDocModel:[self getNextDocment:tDocmentDocModel] To:sTellAllExpectSender aTellLocal:YES];
                     
                     // 老师的当前文档被删除，在上课时也只是显示下一个文档，不发showpage
                     [self docmentDefault:[self getNextDocment:tDocmentDocModel]];
                     if (self.isPlayMedia) {
                     // 如果PPT里面有视频，要取消
                     [self sessionHandleUnpublishMedia:nil];
                     }
                     }else{
                     
                     [self docmentDefault:[self getNextDocment:tDocmentDocModel]];
                     if (self.isPlayMedia) {
                     // 如果PPT里面有视频，要取消
                     [self sessionHandleUnpublishMedia:nil];
                     }
                     }*/
                    
                }
                //先设置后删除
                [self delDocmentArray:tDocmentDocModel];
            }
            //删除的通知
            [[NSNotificationCenter defaultCenter] postNotificationName:sDocListViewNotification object:nil userInfo:nil];
            
        }else{
            bool tIsMedia = [[tDataDic objectForKey:@"isMedia"]boolValue];
            
            NSDictionary *dict;
            if (tIsMedia) {
                
                TKMediaDocModel *tMediaDocModel = [self resolveMediaModelFromDic:tDataDic];
                if (!tMediaDocModel.swfpath) {
                    tMediaDocModel.swfpath =tMediaDocModel.fileurl;
                }
                if (!tMediaDocModel.filetype) {
                    tMediaDocModel.filetype = [tMediaDocModel.filename pathExtension];
                }
                [self addOrReplaceMediaArray:tMediaDocModel];
                
                if (tMediaDocModel.filecategory) {
                    dict = @{@"filecategory":tMediaDocModel.filecategory};
                }else{
                    dict = nil;
                }
                
            }else{
                
                TKDocmentDocModel *tDocmentDocModel = [self resolveDocumentModelFromDic:tDataDic];
                if (!tDocmentDocModel.swfpath) {
                    tDocmentDocModel.swfpath =  tDocmentDocModel.fileurl;
                }
                if (!tDocmentDocModel.filetype) {
                    tDocmentDocModel.filetype = [tDocmentDocModel.filename pathExtension];
                }
                [self addOrReplaceDocmentArray:tDocmentDocModel];
                
                if (tDocmentDocModel.filecategory) {
                    dict = @{@"filecategory":tDocmentDocModel.filecategory};
                }else{
                    dict = nil;
                }
                //                if ([[NSString stringWithFormat:@"%@",tDocmentDocModel.type] isEqualToString:@"1"] && !_isClassBegin) {
                //                    _iDefaultDocment = tDocmentDocModel;
                //                    _iCurrentDocmentModel= _iDefaultDocment;
                //                }
            }
            
            [[NSNotificationCenter defaultCenter]postNotificationName:sDocListViewNotification object:nil userInfo:dict];
            
        }
    }
    
    
    if([msgName isEqualToString:sWBPageCount]|| [msgName isEqualToString:sShowPage] ||[msgName isEqualToString:sSharpsChange] )
    {
        
        if ([msgID isEqualToString:sDocumentFilePage_ShowPage]) {
            
            TKDocmentDocModel *tDocmentDocModel = [self resolveDocumentModelFromDic:tDataDic];
            if (!tDocmentDocModel.swfpath) {
                tDocmentDocModel.swfpath =  tDocmentDocModel.fileurl;
            }
            if (!tDocmentDocModel.filetype) {
                tDocmentDocModel.filetype = [tDocmentDocModel.filename pathExtension];
            }
            [self addOrReplaceDocmentArray:tDocmentDocModel];
            _iCurrentDocmentModel = tDocmentDocModel;
            [[NSNotificationCenter defaultCenter]postNotificationName:sDocListViewNotification object:nil];
        }
        if ([msgID isEqualToString:sWBPageCount]) {
            
            NSNumber*  tTotalPage = [tDataDic objectForKey:@"totalPage"]?[tDataDic objectForKey:@"totalPage"]:@(1);
            NSNumber*  fileid = [tDataDic objectForKey:@"fileid"]?[tDataDic objectForKey:@"fileid"]:@(0);
            TKDocmentDocModel *tDocmentDocModel = [self.iDocmentMutableDic objectForKey:[NSString stringWithFormat:@"%@",fileid]];
            tDocmentDocModel.pagenum  = tTotalPage?tTotalPage:tDocmentDocModel.pagenum;
            tDocmentDocModel.currpage = tTotalPage?tTotalPage:tDocmentDocModel.pagenum;
            [self addOrReplaceDocmentArray:tDocmentDocModel];
        }
        tIsWhiteBoardDealWith = true;
    }
}

- (void)onWhiteBoardExitAnnotation{
    
    [[TKEduSessionHandle shareInstance] sessionHandleMediaPause:false];
    
}
- (void)onWhiteBoardViewStateUpdate:(NSDictionary *)message
{
    if (self.iWhiteBoardDelegate && [self.iWhiteBoardDelegate respondsToSelector:@selector(boardOnViewStateUpdate:)]) {
        [self.iWhiteBoardDelegate boardOnViewStateUpdate:message];
    }
}
- (void)onWhiteBroadCloseDocumentRemark
{
   
}
- (void)onWhiteBoardFullScreen:(BOOL)isFull{
    if (self.iWhiteBoardDelegate && [self.iWhiteBoardDelegate respondsToSelector:@selector(boardOnFullScreen:)]) {
        [self.iWhiteBoardDelegate boardOnFullScreen:isFull];
    }

    // 上课 发布信令 (经典)
    if ([TKEduSessionHandle shareInstance].isClassBegin
        &&
        [[TKEduSessionHandle shareInstance].roomMgr getRoomConfigration].coursewareFullSynchronize
        &&
        [TKEduSessionHandle shareInstance].roomMgr.localUser.role == TKUserType_Teacher
        ) {
    
    //    fullScreenType:'stream_media' , //courseware_file:表示课件全屏，stream_media：表示MP4全屏
    //    needPictureInPictureSmall:是否需要启用视频在右下角，现在都设置为true
    if (isFull) {
        
        [[TKEduSessionHandle shareInstance] sessionHandlePubMsg:sWBFullScreen
                                                             ID:sWBFullScreen
                                                             To:sTellAll
                                                           Data:@{
                                                                  @"fullScreenType" :@"courseware_file",
                                                                  sneedPictureInPictureSmall: @(isFull)
                                                                  }
                                                           Save:true
                                                AssociatedMsgID:nil
                                               AssociatedUserID:nil
                                                        expires:0
                                                     completion:nil];
    }
    else {
        
        
        [[TKEduSessionHandle shareInstance] sessionHandleDelMsg:sWBFullScreen
                                                             ID:sWBFullScreen
                                                             To:sTellAll
                                                           Data:@{} completion:^(NSError *error) {
                                                               
                                                           }];
    }
    
    
    
    }
}

- (TKDocmentDocModel *)resolveDocumentModelFromDic:(NSDictionary *)dic
{
    /*
     isDynamicPPT = 0;
     isGeneralFile = 1;
     isH5Document = 0;
     */
    TKDocmentDocModel *tDocmentDocModel = [[TKDocmentDocModel alloc] init];
    [tDocmentDocModel setValuesForKeysWithDictionary:[dic valueForKey:@"filedata"]];
    tDocmentDocModel.dynamicppt = [dic objectForKey:@"isDynamicPPT"];
    tDocmentDocModel.action = [dic objectForKey:@"action"];
    tDocmentDocModel.type = [dic objectForKey:@"mediaType"];
    BOOL isDynamicPPT = [[dic objectForKey:@"isDynamicPPT"]boolValue];
    BOOL isGeneralFile = [[dic objectForKey:@"isGeneralFile"]boolValue];
    BOOL isH5Document = [[dic objectForKey:@"isH5Document"]boolValue];
    tDocmentDocModel.fileprop = @(0);
    if (isDynamicPPT) {
        tDocmentDocModel.fileprop = @(2);
    }
    if (isH5Document) {
        tDocmentDocModel.fileprop = @(3);
    }
    
    
    //0:表示普通文档　１－２动态ppt(1: 第一版动态ppt 2: 新版动态ppt ）  3:h5文档
    // @property (nonatomic, strong) NSNumber *fileprop;
    
    //    tDocmentDocModel.dynamicppt = [dic objectForKey:@"isDynamicPPT"];
    //    tDocmentDocModel.action = [dic objectForKey:@"action"];
    //    tDocmentDocModel.type = [dic objectForKey:@"mediaType"];
    
    return tDocmentDocModel;
}
- (TKMediaDocModel *)resolveMediaModelFromDic:(NSDictionary *)dic
{
    TKMediaDocModel *tMediaDocModel = [[TKMediaDocModel alloc] init];
    [tMediaDocModel setValuesForKeysWithDictionary:[dic valueForKey:@"filedata"]];
    tMediaDocModel.dynamicppt = [dic objectForKey:@"isDynamicPPT"];
    tMediaDocModel.action = [dic objectForKey:@"action"];
    tMediaDocModel.type = [dic objectForKey:@"mediaType"];
    BOOL isDynamicPPT = [[dic objectForKey:@"isDynamicPPT"]boolValue];
    BOOL isGeneralFile = [[dic objectForKey:@"isGeneralFile"]boolValue];
    BOOL isH5Document = [[dic objectForKey:@"isH5Document"]boolValue];
    tMediaDocModel.fileprop = @(0);
    if (isDynamicPPT) {
        tMediaDocModel.fileprop = @(2);
    }
    if (isH5Document) {
        tMediaDocModel.fileprop = @(3);
    }
//    tMediaDocModel.action = [dic objectForKey:@"action"];
//    tMediaDocModel.type = [dic objectForKey:@"mediaType"];
    
    return tMediaDocModel;
}

#pragma mark 其他 private 

//聊天信息
- (NSArray *)messageList
{
    return [_iMessageList copy];
}
- (void)addOrReplaceMessage:(TKChatMessageModel *)aMessageModel
{
    [_iMessageList addObject:aMessageModel];
}
- (void)addTranslationMessage:(TKChatMessageModel *)aMessageModel
{
    NSArray *tArray  = [_iMessageList copy];
    
    BOOL tIsHave = NO;
    NSInteger tIndex = 0;
    for (TKChatMessageModel *tChatMessageModel in tArray) {
        if ([tChatMessageModel.iMessage isEqualToString:aMessageModel.iMessage]&&[tChatMessageModel.iTime isEqualToString:aMessageModel.iTime]) {
            tIsHave = YES;
            [_iMessageList replaceObjectAtIndex:tIndex withObject:aMessageModel];
            
        }
        tIndex ++;
    }
    if (!tIsHave) {
        [_iMessageList addObject:aMessageModel];
    }
}
- (BOOL)judgmentOfTheSameMessage:(NSString *)message lastSendTime:(NSString *)time
{
    NSArray *tArray  = [_iMessageList copy];
    BOOL tIsHave = NO;
    for (TKChatMessageModel *tChatMessageModel in tArray) {
        double poor = [tChatMessageModel.iTime doubleValue]- [time doubleValue];
        if(fabs(poor)<=3){//取三秒内的消息
            if ([tChatMessageModel.iMessage isEqualToString:message] && [tChatMessageModel.iFromid isEqualToString:_roomMgr.localUser.peerID]) {
                
                
                tIsHave = YES;
                
                return tIsHave;
            }
        }
        
    }
    return tIsHave;
}

//user
- (NSArray *)userArray
{
    return [_iUserList copy];
}
- (void)addUser:(TKRoomUser *)aRoomUser
{
    [_iUserList addObject:aRoomUser];
}
- (TKRoomUser *)getUserWithPeerId:(NSString *)peerId
{
    for (TKRoomUser *user in _iUserList) {
        if ([user.peerID isEqualToString:peerId]) {
            return user;
        }
    }
    return nil;
}
- (void)delUser:(TKRoomUser *)aRoomUser
{
    [_iUserList removeObject:aRoomUser];
}
//用户
- (NSArray *)userStdntAndTchrArray
{
     return [_iUserStdAndTchrList copy];
}
- (void)addUserStdntAndTchr:(TKRoomUser *)aRoomUser {
    NSArray *tArray  = [_iUserStdAndTchrList copy];
    
    BOOL tIsHave                              = NO;
    BOOL tIsHaveTeacher                       = NO;
    NSInteger tRoomUserIndex = 0;
  
    for (TKRoomUser *tRoomUser in tArray) {
        if (tRoomUser.role == UserType_Teacher) {
            tIsHaveTeacher = YES;
            break;
            
        }
    }

    for (TKRoomUser *tRoomUser in tArray) {
        
        if ([tRoomUser.peerID isEqualToString:aRoomUser.peerID]) {
            
            tIsHave = YES;
            break;
            
        }
        tRoomUserIndex++;
        
    }
    
    if (!tIsHave) {
        
        if (aRoomUser.role == UserType_Teacher) {
            _iTeacherUser = aRoomUser;
            [_iUserStdAndTchrList insertObject:aRoomUser atIndex:0];
        }else if ([aRoomUser.peerID isEqualToString: self.localUser.peerID] && aRoomUser.role != UserType_Patrol){
            
             [_iUserStdAndTchrList insertObject:aRoomUser atIndex:tIsHaveTeacher];
           
        }else if(aRoomUser.role == UserType_Student){
            
            [_iUserStdAndTchrList addObject:aRoomUser];
        }
        
    }else{
        
        [_iUserStdAndTchrList replaceObjectAtIndex:tRoomUserIndex withObject:aRoomUser];
        
    }
}
- (void)delUserStdntAndTchr:(TKRoomUser *)aRoomUser
{
    NSArray *tArrayAll = [_iUserStdAndTchrList copy];
    NSInteger tRoomUserIndex = 0;
    
    for (TKRoomUser *tRoomUser in tArrayAll) {
     
        if ([tRoomUser.peerID isEqualToString:aRoomUser.peerID]) {
            [_iUserStdAndTchrList removeObjectAtIndex:tRoomUserIndex];
            break;
        }
        tRoomUserIndex ++;
    }
}
- (TKRoomUser *)userInUserList:(NSString*)peerId
{
    NSArray *tArrayAll = [_iUserStdAndTchrList copy];
    for (TKRoomUser *tRoomUser in tArrayAll) {
        
        if ([tRoomUser.peerID isEqualToString:peerId]) {return tRoomUser;}
        
    }
    return nil;
}
//除了老师和巡课
- (NSArray *)userListExpecPtrlAndTchr
{
    NSMutableArray *tUserArray = [[self userStdntAndTchrArray]mutableCopy];
    for (TKRoomUser *tUser in [self userStdntAndTchrArray]) {
        if (tUser.role == UserType_Teacher) {
            [tUserArray removeObject:tUser];
            break;
        }
    }
    NSDictionary *tDic =  [[TKEduSessionHandle shareInstance]secialUserDic];
    for (NSString *tPeer in tDic) {
        TKRoomUser *tUser  = [tDic objectForKey:tPeer];
        if (tUser.role != UserType_Patrol) {
            [tUserArray insertObject:tUser atIndex:0];
        }

    }
    return tUserArray;

}
//特殊用户，助教 寻课
- (void)addSecialUser:(TKRoomUser *)aRoomUser
{
    [_iSpecialUserDic setObject:aRoomUser forKey:aRoomUser.peerID];
}

- (void)delSecialUser:(TKRoomUser*)aRoomUser
{
    [_iSpecialUserDic removeObjectForKey:aRoomUser.peerID];
}

- (NSDictionary *)secialUserDic
{
    return [_iSpecialUserDic copy];
}

//音频用户
- (NSSet *)userPlayAudioArray
{
    return [_iUserPlayAudioArray copy];
}
- (void)addOrReplaceUserPlayAudioArray:(TKRoomUser *)aRoomUser
{
    [_iUserPlayAudioArray addObject:aRoomUser.peerID];
}
- (void)delUserPlayAudioArray:(TKRoomUser *)aRoomUser
{
    [_iUserPlayAudioArray removeObject:aRoomUser.peerID];
}

- (NSDictionary *)docmentDic
{
    return [_iMediaMutableDic copy];
}
- (TKDocmentDocModel*)getDocmentFromFiledId:(NSString *)aFiledId
{
    return [_iMediaMutableDic objectForKey:aFiledId];
}
- (NSArray *)docmentArray
{
    return [_iDocmentMutableArray copy];
}
- (TKDocmentDocModel *)whiteBoard
{
    if (_iDocmentMutableArray.count>0) {
        
        return _iDocmentMutableArray.firstObject;
    }else{
        return nil;
    }
}
- (NSArray *)classDocmentArray
{
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *docArray = [NSMutableArray arrayWithArray:_iDocmentMutableArray];
    if (docArray.firstObject) {
        [array addObject:docArray.firstObject];
    }else{
        return nil;
    }
    [docArray removeObjectAtIndex:0];
    for (TKDocmentDocModel *model in docArray) {
        if (![model.filecategory intValue]) {
            [array addObject:model];
        }
    }
    return array;
}
- (NSArray *)systemDocmentArray
{
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *docArray = [NSMutableArray arrayWithArray:_iDocmentMutableArray];
    if (docArray.firstObject) {
        
        [array addObject:docArray.firstObject];
    }else{
        return nil;
    }
    [docArray removeObjectAtIndex:0];
    for (TKDocmentDocModel *model in docArray) {
        if ([model.filecategory intValue]) {
            [array addObject:model];
        }
    }
    return array;
}

- (bool)addOrReplaceDocmentArray:(TKDocmentDocModel *)aDocmentDocModel
{
    if (!aDocmentDocModel) {
        return false;
    }
    
    if ([aDocmentDocModel.dynamicppt integerValue]==1)
        return false;
    
    NSArray *tArray  = [_iDocmentMutableArray copy];
    BOOL tIsHave     = NO;
    NSInteger tIndex = 0;
    for (TKDocmentDocModel *tDocmentDocModel in tArray) {
         BOOL isCurrntDM = [self isEqualFileId:tDocmentDocModel aSecondModel:aDocmentDocModel];
        if (isCurrntDM) {
            
            //active
            if ([aDocmentDocModel.active intValue]!= [tDocmentDocModel.active intValue] && aDocmentDocModel.active) {
                tDocmentDocModel.active = aDocmentDocModel.active;
            }
            //animation
            if ([aDocmentDocModel.animation intValue]!= [tDocmentDocModel.animation intValue] && aDocmentDocModel.animation) {
                tDocmentDocModel.animation = aDocmentDocModel.animation;
            }
            //companyid
            if ([aDocmentDocModel.companyid intValue]!= [tDocmentDocModel.companyid intValue] && aDocmentDocModel.companyid) {
                tDocmentDocModel.companyid = aDocmentDocModel.companyid;
            }
            
            //downloadpath
            if (![aDocmentDocModel.downloadpath isEqualToString:tDocmentDocModel.downloadpath] && aDocmentDocModel.downloadpath) {
                tDocmentDocModel.downloadpath = aDocmentDocModel.downloadpath;
            }
            //filename
            if (![aDocmentDocModel.filename isEqualToString:tDocmentDocModel.filename] && aDocmentDocModel.filename) {
                // 白板的名字不要修改 MTLocalized(@"Title.whiteBoard")
                if (![tDocmentDocModel.filetype isEqualToString:@"whiteboard"]) {
                    tDocmentDocModel.filename = aDocmentDocModel.filename;
                }
            }
            //fileid
            //filepath
            if (![aDocmentDocModel.filepath isEqualToString:tDocmentDocModel.filepath] && aDocmentDocModel.filepath) {
                tDocmentDocModel.filepath = aDocmentDocModel.filepath;
            }
            //fileserverid
            if ([aDocmentDocModel.fileserverid intValue]!= [tDocmentDocModel.fileserverid intValue] && aDocmentDocModel.fileserverid) {
                tDocmentDocModel.fileserverid = aDocmentDocModel.fileserverid;
            }
            //filetype
            if (aDocmentDocModel.filetype && (![aDocmentDocModel.filetype isEqualToString:tDocmentDocModel.filetype])) {
                tDocmentDocModel.filetype = aDocmentDocModel.filetype;
            }
            //isconvert
            if ([aDocmentDocModel.isconvert intValue]!= [tDocmentDocModel.isconvert intValue] && aDocmentDocModel.isconvert) {
                tDocmentDocModel.isconvert = aDocmentDocModel.isconvert;
            }
            
            
            //newfilename
            if (![aDocmentDocModel.newfilename isEqualToString:tDocmentDocModel.newfilename] && aDocmentDocModel.newfilename) {
                tDocmentDocModel.newfilename = aDocmentDocModel.newfilename;
            }
            
            //pagenum
            if ([aDocmentDocModel.pagenum intValue]!= [tDocmentDocModel.pagenum intValue] && aDocmentDocModel.pagenum) {
                tDocmentDocModel.pagenum = aDocmentDocModel.pagenum;
            }
            //pdfpath
            if (![aDocmentDocModel.pdfpath isEqualToString:tDocmentDocModel.pdfpath] && aDocmentDocModel.pdfpath) {
                tDocmentDocModel.pdfpath = aDocmentDocModel.pdfpath;
            }
            
            //size
            if ([aDocmentDocModel.size intValue]!= [tDocmentDocModel.size intValue] && aDocmentDocModel.size) {
                tDocmentDocModel.size = aDocmentDocModel.size;
            }
            //status
            if ([aDocmentDocModel.status intValue]!= [tDocmentDocModel.status intValue] && aDocmentDocModel.status) {
                tDocmentDocModel.status = aDocmentDocModel.status;
            }
            //swfpath
            if (![aDocmentDocModel.swfpath isEqualToString:tDocmentDocModel.swfpath] && aDocmentDocModel.swfpath) {
                tDocmentDocModel.swfpath = aDocmentDocModel.swfpath;
            }
            //type
            if (![aDocmentDocModel.type isEqualToString:tDocmentDocModel.type] && aDocmentDocModel.type) {
                tDocmentDocModel.type = aDocmentDocModel.type;
            }
            //uploadtime
            if (![aDocmentDocModel.uploadtime isEqualToString:tDocmentDocModel.uploadtime] && aDocmentDocModel.uploadtime) {
                tDocmentDocModel.uploadtime = aDocmentDocModel.uploadtime;
            }
            
            //status
            if ([aDocmentDocModel.uploaduserid intValue]!= [tDocmentDocModel.uploaduserid intValue] && aDocmentDocModel.uploaduserid) {
                tDocmentDocModel.uploaduserid = aDocmentDocModel.uploaduserid;
            }
            //uploadtime
            if (![aDocmentDocModel.uploadusername isEqualToString:tDocmentDocModel.uploadusername] && aDocmentDocModel.uploadusername) {
                tDocmentDocModel.uploadusername = aDocmentDocModel.uploadusername;
            }
            //currpage
            if ([aDocmentDocModel.currpage intValue]!= [tDocmentDocModel.currpage intValue] && aDocmentDocModel.currpage) {
                tDocmentDocModel.currpage = aDocmentDocModel.currpage;
            }
            
            //dynamicppt
            if ([aDocmentDocModel.dynamicppt intValue]!= [tDocmentDocModel.dynamicppt intValue] && aDocmentDocModel.dynamicppt) {
                tDocmentDocModel.dynamicppt = aDocmentDocModel.dynamicppt;
            }
            
            //pptslide
            if ([aDocmentDocModel.pptslide intValue]!= [tDocmentDocModel.pptslide intValue] && aDocmentDocModel.pptslide) {
                tDocmentDocModel.pptslide = aDocmentDocModel.pptslide;
            }
            
            //pptstep
            if ([aDocmentDocModel.pptstep intValue]!= [tDocmentDocModel.pptstep intValue] && aDocmentDocModel.pptstep) {
                tDocmentDocModel.pptstep = aDocmentDocModel.pptstep;
            }
            
            //action
            if (![aDocmentDocModel.action isEqualToString:tDocmentDocModel.action] && aDocmentDocModel.action) {
                tDocmentDocModel.action = aDocmentDocModel.action;
            }
            //isShow
            if ([aDocmentDocModel.isShow intValue]!= [tDocmentDocModel.isShow intValue] && aDocmentDocModel.isShow) {
                tDocmentDocModel.isShow = aDocmentDocModel.isShow;
            }
            aDocmentDocModel = tDocmentDocModel;
            tIsHave = YES;
            
            break;
        }
        tIndex++;
        
        
    }
    
    if (!tIsHave) {
    
        [_iDocmentMutableArray addObject:aDocmentDocModel];
        
    }else{
        [_iDocmentMutableArray replaceObjectAtIndex:tIndex withObject:aDocmentDocModel];
    }
    [_iDocmentMutableDic setObject:aDocmentDocModel forKey:[NSString stringWithFormat:@"%@",aDocmentDocModel.fileid]];
    return YES;
}
- (void)delDocmentArray:(TKDocmentDocModel *)aDocmentDocModel
{
    if (!aDocmentDocModel) {
        return;
    }
    TKLog(@"---------del:%@",aDocmentDocModel.filename);
    
    NSArray *tArrayAll = [_iDocmentMutableArray copy];
    NSInteger tIndex = 0;
    for (TKDocmentDocModel *tDocmentDocModel in tArrayAll) {
        BOOL isCurrentDocment = [self isEqualFileId:tDocmentDocModel aSecondModel:aDocmentDocModel];
        if (isCurrentDocment) {
            [_iDocmentMutableArray removeObjectAtIndex:tIndex];
            
            break;
        }
        tIndex++;
        
    }
    [_iDocmentMutableDic removeObjectForKey:[NSString stringWithFormat:@"%@",aDocmentDocModel.fileid]];
}
//音视频
- (NSDictionary *)meidaDic
{
    return [_iMediaMutableDic copy];
}
- (TKMediaDocModel*)getMediaFromFiledId:(NSString *)aFiledId
{
    return [_iMediaMutableDic objectForKey:aFiledId];
}

- (NSArray *)mediaArray
{
    return [_iMediaMutableArray copy];
}

- (NSArray *)classMediaArray
{
    NSMutableArray *array = [NSMutableArray array];
    for (TKMediaDocModel *model in _iMediaMutableArray) {
        if (![model.filecategory intValue]) {
            [array addObject:model];
        }
    }
    return array;
}
- (NSArray *)systemMediaArray
{
    NSMutableArray *array = [NSMutableArray array];
    for (TKMediaDocModel *model in _iMediaMutableArray) {
        if ([model.filecategory intValue]) {
            [array addObject:model];
        }
    }
    return array;
}
- (void)addOrReplaceMediaArray:(TKMediaDocModel *)aMediaDocModel
{
    if (!aMediaDocModel) {
        return ;
    }
    
    NSArray *tArray  = [_iMediaMutableArray copy];
    
    BOOL tIsHave                              = NO;
    NSInteger tIndex = 0;
    for (TKMediaDocModel *tMediaDocModel in tArray) {
         BOOL isCurrentDocment = [self isEqualFileId:tMediaDocModel aSecondModel:aMediaDocModel];
        if (isCurrentDocment) {
            //page
            if ([aMediaDocModel.page intValue]!= [tMediaDocModel.page intValue] && aMediaDocModel.page) {
                tMediaDocModel .page = aMediaDocModel.page ;
            }
            //ismedia
            if ([aMediaDocModel.ismedia intValue]!= [tMediaDocModel.ismedia intValue] && aMediaDocModel.ismedia) {
                tMediaDocModel .ismedia = aMediaDocModel.ismedia ;
            }
            //isconvert
            if ([aMediaDocModel.isconvert intValue]!= [tMediaDocModel.isconvert intValue] && aMediaDocModel.isconvert) {
                tMediaDocModel .isconvert = aMediaDocModel.isconvert ;
            }
            
            //pagenum
            if ([aMediaDocModel.pagenum intValue]!= [tMediaDocModel.pagenum intValue] && aMediaDocModel.pagenum) {
                tMediaDocModel .pagenum = aMediaDocModel.pagenum ;
            }
            //filetype
            if ( aMediaDocModel.filetype && (![aMediaDocModel.filetype isEqualToString:tMediaDocModel.filetype])) {
                
                tMediaDocModel.filetype = aMediaDocModel.filetype;
                
            }
            
            //filename
            if (![aMediaDocModel.filename isEqualToString:tMediaDocModel.filename] && aMediaDocModel.filename) {
                
                tMediaDocModel.filename = aMediaDocModel.filename;
                
            }
            //filename
            if (![aMediaDocModel.swfpath isEqualToString:tMediaDocModel.swfpath] && aMediaDocModel.swfpath) {
                
                tMediaDocModel.swfpath = aMediaDocModel.swfpath;
                
            }
            //currentTime
            if ([aMediaDocModel.currentTime intValue]!= [tMediaDocModel.currentTime intValue] && aMediaDocModel.currentTime) {
                tMediaDocModel.currentTime = aMediaDocModel.currentTime ;
            }
            //isPlay
            if ([aMediaDocModel.isPlay intValue]!= [tMediaDocModel.isPlay intValue] && aMediaDocModel.isPlay) {
                tMediaDocModel.isPlay = aMediaDocModel.isPlay ;
            }
            
            aMediaDocModel = tMediaDocModel;
            tIsHave = YES;
            
            break;
        }
        tIndex++;
        
        
    }
    if (!tIsHave) {
        [_iMediaMutableArray addObject:aMediaDocModel];
        
    }else{
        [_iMediaMutableArray replaceObjectAtIndex:tIndex withObject:aMediaDocModel];
    }
    [_iMediaMutableDic setObject:aMediaDocModel forKey:[NSString stringWithFormat:@"%@",aMediaDocModel.fileid]];
}
- (void)delMediaArray:(TKMediaDocModel *)aMediaDocModel
{
    if (!aMediaDocModel) {
        return ;
    }
    TKLog(@"---------del:%@",aMediaDocModel.filename);
    [_iMediaMutableDic setObject:aMediaDocModel forKey:[NSString stringWithFormat:@"%@",aMediaDocModel.fileid]];
    //删除所有
    NSArray *tArrayAll = [_iMediaMutableArray copy];
    NSInteger tIndex = 0;
    for (TKMediaDocModel *tMediaDocModel in tArrayAll) {
        BOOL isCurrentDocment = [self isEqualFileId:tMediaDocModel aSecondModel:aMediaDocModel];
        if (isCurrentDocment) {
            [_iMediaMutableArray removeObjectAtIndex:tIndex];
            break;
        }
        tIndex++;
    }
}
- (TKDocmentDocModel *)getNextDocment:(TKDocmentDocModel *)aCurrentDocmentModel
{
    NSArray *tArray = [self docmentArray];
    int i = 0;
    for (TKDocmentDocModel *tDoc in tArray)
    {
         BOOL isCurrentDocment = [self isEqualFileId:tDoc aSecondModel:aCurrentDocmentModel];
        if(isCurrentDocment)
        {
            NSInteger tIndex = (i == [tArray count]-1)?i-1:i+1;
            if (tIndex<0) {tIndex = 0;}
            return [tArray objectAtIndex:tIndex];
            
        }
        i++;
    }
    return [tArray objectAtIndex:0];
    
}
- (TKMediaDocModel*)getNextMedia:(TKMediaDocModel *)aCurrentMediaDocModel
{
    NSArray *tArray = [self mediaArray];
    int i = 0;
    for (TKMediaDocModel *tDoc in tArray)
    {
        BOOL isCurrentDocment = [self isEqualFileId:tDoc aSecondModel:aCurrentMediaDocModel];
        if(isCurrentDocment)
            
        {
            NSInteger tIndex = (i == [tArray count]-1)?i-1:i+1;
            if (tIndex<0) {tIndex = 0;}
            return [tArray objectAtIndex:tIndex];
            
        }
        i++;
    }
    return [tArray objectAtIndex:0];
}

- (BOOL)isEqualFileId:(id)aModel  aSecondModel:(id)aSecondModel
{
    BOOL isEqual = NO;
   
    if ([aModel isKindOfClass:[TKDocmentDocModel class]] && [aSecondModel isKindOfClass:[TKDocmentDocModel class]]) {
        TKDocmentDocModel *tDoc = (TKDocmentDocModel*)aModel;
        TKDocmentDocModel *tDoc2 = (TKDocmentDocModel*)aSecondModel;
        NSString *tFileid = [NSString stringWithFormat:@"%@",tDoc.fileid];
        NSString *tCurrentFileid = [NSString stringWithFormat:@"%@",tDoc2.fileid];
        isEqual = [tFileid isEqualToString:tCurrentFileid];
    }
    
    if ([aModel isKindOfClass:[TKMediaDocModel class]] && [aSecondModel isKindOfClass:[TKMediaDocModel class]]) {
        TKMediaDocModel *tDoc = (TKMediaDocModel*)aModel;
        TKMediaDocModel *tDoc2 = (TKMediaDocModel*)aSecondModel;
        NSString *tFileid = [NSString stringWithFormat:@"%@",tDoc.fileid];
        NSString *tCurrentFileid = [NSString stringWithFormat:@"%@",tDoc2.fileid];
        isEqual = [tFileid isEqualToString:tCurrentFileid];
    }
    return  isEqual;
}
#pragma mark 加按钮

- (BOOL)addPendingUser:(TKRoomUser *)aRoomUser
{
    int tMaxVideo = [self.iRoomProperties.iMaxVideo intValue];
    // (tMaxVideo-1)，因为老师也需要占一路流
    NSLog(@"-----pend before:pengding dic count: %ld", _iPendingButtonDic.count);
    NSLog(@"-----pend before:rest count: %ld", tMaxVideo - [TKEduSessionHandle shareInstance].iPublishDic.count);
    if ((tMaxVideo-[TKEduSessionHandle shareInstance].iPublishDic.count) > [_iPendingButtonDic count]) {
        [_iPendingButtonDic setObject:aRoomUser forKey:aRoomUser.peerID];
        //TKLog(@"pending--- add pending user: %@, %@", aRoomUser.nickName, aRoomUser.peerID);
        
        NSLog(@"-----pend after:pengding dic count: %ld", _iPendingButtonDic.count);
        NSLog(@"-----pend after:rest count: %ld", tMaxVideo - [TKEduSessionHandle shareInstance].iPublishDic.count);
        return  true;
    }

    NSLog(@"-----pend after:pengding dic count: %ld", _iPendingButtonDic.count);
    NSLog(@"-----pend after:rest count: %ld", tMaxVideo - [TKEduSessionHandle shareInstance].iPublishDic.count);
    return false;
}
- (void)delePendingUser:(NSString *)peerID
{
    if (peerID) {
        [_iPendingButtonDic removeObjectForKey:peerID];
        
    }
}

- (NSDictionary *)pendingUserDic
{
    return [_iPendingButtonDic copy];
}
#pragma mark 发布
- (void)addPublishUser:(TKRoomUser *)aRoomUser
{
    [_iPublishDic setObject:aRoomUser forKey:aRoomUser.peerID];
    // 当助教发布音视频时，也要将_iHasPublishStd设置为YES
    if (aRoomUser.role == UserType_Student || aRoomUser.role == UserType_Assistant) {
        _iHasPublishStd = YES;
    }
}
- (void)delePublishUser:(TKRoomUser *)aRoomUser
{
    [_iPublishDic removeObjectForKey:aRoomUser.peerID];
    if (_iPublishDic.count == 0) {
        _iHasPublishStd = NO;
    }
    if (_iPublishDic.count == 1) {
        [_iPublishDic enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, TKRoomUser *  _Nonnull obj, BOOL * _Nonnull stop) {
            if (obj.role == UserType_Student || obj.role == UserType_Assistant) {
                // 当助教发布音视频时，也要将_iHasPublishStd设置为YES
                _iHasPublishStd = YES;
                *stop = YES;
            }else{
                _iHasPublishStd = NO;
            }
        }];
    }
}

- (NSDictionary *)publishUserDic
{
    return [_iPublishDic copy];
}


#pragma mark 未发布
- (void)addUnPublishUser:(TKRoomUser *)aRoomUser
{
    [_iUnPublisDic setObject:aRoomUser forKey:aRoomUser.peerID];
    
}

- (void)deleUnPublishUser:(TKRoomUser *)aRoomUser
{
    [_iUnPublisDic removeObjectForKey:aRoomUser.peerID];
}

- (NSDictionary *)unpublishUserDic
{
    return [_iUnPublisDic copy];
}

- (void)clearMessageList
{
    [_iMessageList removeAllObjects];
}

- (void)clearAllClassData
{
     //修复重连时，会有问题！
    [_iMessageList removeAllObjects];
    [_iUserList removeAllObjects];
    [_iUserStdAndTchrList removeAllObjects];
    [_iUserPlayAudioArray removeAllObjects];
    [_iPublishDic removeAllObjects];
    [_msgList removeAllObjects];
    [_cacheMsgPool removeAllObjects];
    
    _isClassBegin = NO;
    _isMuteAudio  = NO;
    _iTeacherUser = nil;
    //_iRoomProperties = nil;     // 断线重连阶段没有获取checkroom的过程，所以清理掉iRoomProperties会有影响
    [_iPendingButtonDic removeAllObjects];

    _iIsPlaying = NO;
    _isPlayMedia = NO;
    _isLocal = NO;
    _isChangeMedia = NO;
    _iHasPublishStd = NO;
    _iStdOutBottom = NO;
    _iIsFullState = NO;
//    [_whiteBoardManager destory];
//    _whiteBoardManager = nil;
    
    // 现在断线重连会重新获取file，所以需要清理文件
    [_iDocmentMutableArray removeAllObjects];
    [_iDocmentMutableDic removeAllObjects];
    [_iMediaMutableArray removeAllObjects];
    [_iMediaMutableDic removeAllObjects];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}
- (void)clearView
{
    _iMediaListView = nil;
    _iDocumentListView = nil;
}
#pragma mark set and get

- (TKRoomUser*)localUser
{
    return [_roomMgr localUser];
}


#pragma mark 发布影音
- (void)publishtMediaDocModel:(TKMediaDocModel*)aMediaDocModel add:(BOOL)add To:(NSString *)to
{
  //mediaType\":\"video\"
    BOOL tIsVideo = [TKUtil isVideo:aMediaDocModel.filetype];
    NSString *tIdString = tIsVideo?sVideo_MediaFilePage_ShowPage:sAudio_MediaFilePage_ShowPage ;
    NSDictionary *tMediaDocModelDic = [self fileDataDic:aMediaDocModel ismedia:YES];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tMediaDocModelDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    to = sTellAll;//sShowPage  更改为发给所有人
    if (add) {
        
        [self sessionHandlePubMsg:sShowPage ID:tIdString To:to Data:jsonString Save:true AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
    }else{
        [self sessionHandleDelMsg:sShowPage ID:tIdString To:to Data:jsonString completion:nil];
    }
}

- (void)publishVideoDragWithDic:(NSDictionary * )aVideoDic To:(NSString *)to
{
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:aVideoDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    [self sessionHandlePubMsg:sVideoDraghandle ID:sVideoDraghandle To:to Data:jsonString Save:true AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
}

#pragma mark 发布文档
- (void)publishtDocMentDocModel:(TKDocmentDocModel*)tDocmentDocModel To:(NSString *)to aTellLocal:(BOOL)aTellLocal
{
    if (aTellLocal) {
        [self.whiteBoardManager changeDocumentWithFileID:tDocmentDocModel.fileid isBeginClass:self.isClassBegin isPubMsg:NO];
        
    }
    
    NSDictionary *tDocmentDocModelDic  =  [self fileDataDic:tDocmentDocModel ismedia:NO];

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tDocmentDocModelDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    //[self sessionHandlePubMsg:sShowPage ID:sDocumentFilePage_ShowPage To:to Data:jsonString Save:true completion:nil];

    to = sTellAll;//自己调用sShowPage全部更改成发给所有人
    //发布文档（上课）
    [self sessionHandlePubMsg:sShowPage ID:sDocumentFilePage_ShowPage To:to Data:jsonString Save:true AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
//
   

//    if ([TKEduSessionHandle shareInstance].isClassBegin) {
//
//        [self sessionHandlePubMsg:sShowPage ID:sDocumentFilePage_ShowPage To:to Data:jsonString Save:true AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
//    }
}
#pragma mark 删除文档

- (NSDictionary *)fileDataChangeDic:(id)aDefaultDocment isDel:(BOOL)isDel ismedia:(BOOL)ismedia
{
    NSDictionary *tDic = ismedia?[self fileDataMediaChangeDic:(TKMediaDocModel *)aDefaultDocment isDel:isDel]:[self fileDataDocChangeDic:(TKDocmentDocModel *)aDefaultDocment isDel:isDel];
    return tDic;
}

- (NSDictionary *)fileDataDocChangeDic:(TKDocmentDocModel *)aDefaultDocment isDel:(BOOL)isDel
{
    //0:表示普通文档　１－２动态ppt(1: 第一版动态ppt 2: 新版动态ppt ）  3:h5文档
    NSString *tFileProp = [NSString stringWithFormat:@"%@",aDefaultDocment.fileprop];
    NSNumber* isGeneralFile = [tFileProp isEqualToString:@"0"]?@(true):@(false);
    NSNumber* isDynamicPPT  = ([tFileProp isEqualToString:@"1"] ||[tFileProp isEqualToString:@"2"] )?@(true):@(false);
    NSNumber* isH5Document   = [tFileProp isEqualToString:@"3"]?@(true):@(false);
    NSString *action        =  isDynamicPPT?sActionShow:@"";
    NSString *mediaType     =  @"";
    NSDictionary *tDataDic = @{
                               @"isDel":@(isDel),
                               @"isGeneralFile":isGeneralFile,
                               @"isDynamicPPT":isDynamicPPT,
                               @"isH5Document":isH5Document,
                               @"action":action,
                               @"mediaType":mediaType,
                               @"isMedia":@(false),
                               @"filedata":@{
                                       @"fileid":aDefaultDocment.fileid?aDefaultDocment.fileid:@(0),
                                       @"filename":aDefaultDocment.filename?aDefaultDocment.filename:@"",
                                       @"filetype": aDefaultDocment.filetype?aDefaultDocment.filetype:@"",
                                       @"currpage": aDefaultDocment.currpage?aDefaultDocment.currpage:@(1),
                                       @"pagenum"  : aDefaultDocment.pagenum?aDefaultDocment.pagenum:@"",
                                       @"pptslide": aDefaultDocment.pptslide?aDefaultDocment.pptslide:@(1),
                                       @"pptstep":aDefaultDocment.pptstep?aDefaultDocment.pptstep:@(0),
                                       @"steptotal":aDefaultDocment.steptotal?aDefaultDocment.steptotal:@(0),
                                       @"swfpath"  :  aDefaultDocment.swfpath?aDefaultDocment.swfpath:@""
                                       }
                               };
    return tDataDic;
    
}
- (NSDictionary *)fileDataMediaChangeDic:(TKMediaDocModel *)aDefaultDocment isDel:(BOOL)isDel
{
    //0:表示普通文档　１－２动态ppt(1: 第一版动态ppt 2: 新版动态ppt ）  3:h5文档
    NSString *tFileProp = [NSString stringWithFormat:@"%@",aDefaultDocment.fileprop];
    NSNumber* isGeneralFile = [tFileProp isEqualToString:@"0"]?@(true):@(false);
    NSNumber* isDynamicPPT  = ([tFileProp isEqualToString:@"1"] ||[tFileProp isEqualToString:@"2"] )?@(true):@(false);
    NSNumber* isH5Document   = [tFileProp isEqualToString:@"3"]?@(true):@(false);
    NSString *action        =  isDynamicPPT?sActionShow:@"";
    BOOL tIsVideo = [TKUtil isVideo:aDefaultDocment.filetype];
    NSString *mediaType = tIsVideo?@"video":@"audio" ;
    NSDictionary *tDataDic = @{
                               @"isDel":@(isDel),
                               @"isGeneralFile":isGeneralFile,
                               @"isDynamicPPT":isDynamicPPT,
                               @"isH5Document":isH5Document,
                               @"action":action,
                               @"mediaType":mediaType,
                               @"isMedia":@(true),
                               @"filedata":@{
                                       @"fileid":aDefaultDocment.fileid?aDefaultDocment.fileid:@(0),
                                       @"filename":aDefaultDocment.filename?aDefaultDocment.filename:@"",
                                       @"filetype": aDefaultDocment.filetype?aDefaultDocment.filetype:@"",
                                       @"currpage": aDefaultDocment.currpage?aDefaultDocment.currpage:@(1),
                                       @"pagenum"  : aDefaultDocment.pagenum?aDefaultDocment.pagenum:@"",
                                       @"pptslide": aDefaultDocment.pptslide?aDefaultDocment.pptslide:@(1),
                                       @"pptstep":aDefaultDocment.pptstep?aDefaultDocment.pptstep:@(0),
                                       @"steptotal":aDefaultDocment.steptotal?aDefaultDocment.steptotal:@(0),
                                       @"swfpath"  :  aDefaultDocment.swfpath?aDefaultDocment.swfpath:@""
                                       }
                               };
    return tDataDic;
    
}
- (void)addDocMentDocModel:(TKDocmentDocModel*)aDocmentDocModel To:(NSString *)to
{
    NSDictionary *tDocmentDocModelDic = [self fileDataChangeDic:aDocmentDocModel isDel:false ismedia:false];
    //改成字符串
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tDocmentDocModelDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    //[self sessionHandlePubMsg:sDocumentChange ID:sDocumentChange To:to Data:jsonString Save:true completion:nil];
    [self sessionHandlePubMsg:sDocumentChange ID:sDocumentChange To:to Data:jsonString Save:true AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
}
//todo
- (void)deleteDocMentDocModel:(TKDocmentDocModel*)aDocmentDocModel To:(NSString *)to
{
    NSDictionary *tDocmentDocModelDic = [self fileDataChangeDic:aDocmentDocModel isDel:true ismedia:false];
    //改成字符串
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tDocmentDocModelDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    //[self sessionHandlePubMsg:sDocumentChange ID:sDocumentChange To:to Data:jsonString Save:true completion:nil];
    [self sessionHandlePubMsg:sDocumentChange ID:sDocumentChange To:to Data:jsonString Save:true AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
}
- (void)deleteaMediaDocModel:(TKMediaDocModel*)aMediaDocModel To:(NSString *)to
{
     NSDictionary *tMediaDocModelDic = [self fileDataChangeDic:aMediaDocModel isDel:true ismedia:true];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tMediaDocModelDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    //[self sessionHandlePubMsg:sDocumentChange ID:sDocumentChange To:to Data:jsonString Save:true completion:nil];
    [self sessionHandlePubMsg:sDocumentChange ID:sDocumentChange To:to Data:jsonString Save:true AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
    
}

#pragma mark 设置白板

- (void)fileListResetToDefault
{
    for (TKDocmentDocModel *model in _iDocmentMutableArray) {
        [model resetToDefault];
    }
}

- (NSDictionary *)fileDataDic:(id )aDefaultDocment ismedia:(BOOL)ismedia
{
    NSDictionary *tDic = ismedia?[self fileDataMediaDic:(TKMediaDocModel *)aDefaultDocment ]:[self fileDataDocDic:(TKDocmentDocModel *)aDefaultDocment ];
    return tDic;
}


- (NSDictionary *)fileDataDocDic:(TKDocmentDocModel *)aDefaultDocment
{
    if (!aDefaultDocment) {
        //白板
        NSDictionary *tDataDic = @{
                                   @"isGeneralFile":@(true),
                                   @"isDynamicPPT":@(false),
                                   @"isH5Document":@(false),
                                   @"action":@"",
                                   @"fileid":@(0),
                                   @"mediaType":@"",
                                   @"isMedia":@(0),
                                   @"filedata":@{
                                           @"fileid"   :@(0),
                                           @"filename" :@"白板",
                                           //                                           @"filetype" :MTLocalized(@"Title.whiteBoard"),
                                           @"filetype" :@"whiteboard",
                                           @"currpage" :@(1),
                                           @"pagenum"  :@(1),
                                           @"pptslide" :@(1),
                                           @"pptstep"  :@(0),
                                           @"steptotal":@(0),
                                           @"isContentDocument":@(0),
                                           @"swfpath"  :@""
                                           }
                                   };
        return tDataDic;
    }
    //isH5Document isH5Docment
    //0:表示普通文档　１－２动态ppt(1: 第一版动态ppt 2: 新版动态ppt ）  3:h5文档
    NSString *tFileProp = [NSString stringWithFormat:@"%@",aDefaultDocment.fileprop];
    NSNumber* isGeneralFile = [tFileProp isEqualToString:@"0"]?@(true):@(false);
    NSNumber* isDynamicPPT  = ([tFileProp isEqualToString:@"1"] ||[tFileProp isEqualToString:@"2"] )?@(true):@(false);
    NSNumber* isH5Document   = [tFileProp isEqualToString:@"3"]?@(true):@(false);
    NSString *action        =  isDynamicPPT?sActionShow:@"";
    action        =  isH5Document?sActionShow:@"";
    NSString *downloadpath = aDefaultDocment.downloadpath?aDefaultDocment.downloadpath:@"";
    
    NSString *mediaType     =  @"";
    NSDictionary *tDataDic = @{
                               @"isGeneralFile":isGeneralFile,
                               @"isDynamicPPT":isDynamicPPT,
                               @"isH5Document":isH5Document,
                               @"action":action,
                               @"downloadpath":downloadpath,
                               @"fileid":aDefaultDocment.fileid?aDefaultDocment.fileid:@(0),
                               @"mediaType":mediaType,
                               @"isMedia":@(0),
                               @"filedata":@{
                                       @"fileid":aDefaultDocment.fileid?aDefaultDocment.fileid:@(0),
                                       @"filename":aDefaultDocment.filename?aDefaultDocment.filename:@"",
                                       @"filetype": aDefaultDocment.filetype?aDefaultDocment.filetype:@"",
                                       
                                       @"currpage": aDefaultDocment.currpage?aDefaultDocment.currpage:@(1),
                                       @"pagenum"  : aDefaultDocment.pagenum?aDefaultDocment.pagenum:@"",
                                       @"pptslide": aDefaultDocment.pptslide?aDefaultDocment.pptslide:@(1),
                                       @"pptstep":aDefaultDocment.pptstep?aDefaultDocment.pptstep:@(0),
                                       @"steptotal":aDefaultDocment.steptotal?aDefaultDocment.steptotal:@(0),
                                       @"isContentDocument":aDefaultDocment.isContentDocument?aDefaultDocment.isContentDocument:@(0),
                                       @"swfpath"  :  aDefaultDocment.swfpath?aDefaultDocment.swfpath:@""
                                       }
                               };
    return tDataDic;

}
- (NSDictionary *)fileDataMediaDic:(TKMediaDocModel *)aDefaultDocment
{
    //0:表示普通文档　１－２动态ppt(1: 第一版动态ppt 2: 新版动态ppt ）  3:h5文档
    NSString *tFileProp = [NSString stringWithFormat:@"%@",aDefaultDocment.fileprop];
    NSNumber* isGeneralFile = [tFileProp isEqualToString:@"0"]?@(true):@(false);
    NSNumber* isDynamicPPT  = ([tFileProp isEqualToString:@"1"] ||[tFileProp isEqualToString:@"2"] )?@(true):@(false);
    NSNumber* isH5Document   = [tFileProp isEqualToString:@"3"]?@(true):@(false);
    NSString *action        =  isDynamicPPT?sActionShow:@"";
    BOOL tIsVideo = [TKUtil isVideo:aDefaultDocment.filetype];
    NSString *mediaType = tIsVideo?@"video":@"audio" ;
   
    NSDictionary *tDataDic = @{
                               @"isGeneralFile":isGeneralFile,
                               @"isDynamicPPT":isDynamicPPT,
                               @"isH5Document":isH5Document,
                               @"action":action,
                               @"fileid":aDefaultDocment.fileid?aDefaultDocment.fileid:@(0),
                               @"mediaType":mediaType,
                               @"isMedia":@(1),
                               @"filedata":@{
                                       @"fileid":aDefaultDocment.fileid?aDefaultDocment.fileid:@(0),
                                       @"filename":aDefaultDocment.filename?aDefaultDocment.filename:@"",
                                       @"filetype": aDefaultDocment.filetype?aDefaultDocment.filetype:@"",
                                       
                                       @"currpage": aDefaultDocment.currpage?aDefaultDocment.currpage:@(1),
                                       @"pagenum"  : aDefaultDocment.pagenum?aDefaultDocment.pagenum:@"",
                                       @"pptslide": aDefaultDocment.pptslide?aDefaultDocment.pptslide:@(1),
                                       @"pptstep":aDefaultDocment.pptstep?aDefaultDocment.pptstep:@(0),
                                       @"steptotal":aDefaultDocment.steptotal?aDefaultDocment.steptotal:@(0),
                                       @"swfpath"  :  aDefaultDocment.swfpath?aDefaultDocment.swfpath:@""
                                       }
                               };
    return tDataDic;
}

- (TKDocmentDocModel *)getClassOverDocument
{
    TKDocmentDocModel *rtDocument;
    for (NSInteger i = 0; i < self.iDocmentMutableArray.count; i++) {
        TKDocmentDocModel *tDocmentDocModel = self.iDocmentMutableArray[i];
        if (i == 1 || i == 0 || [[NSString stringWithFormat:@"%@",tDocmentDocModel.type] isEqualToString:@"1"]) {
            rtDocument = tDocmentDocModel;
        }
    }
    return rtDocument;
}

- (void)clearAllWhiteBoardData
{
    [_iDocmentMutableArray removeAllObjects];
    [_iMediaMutableArray removeAllObjects];       
    [_iMediaMutableDic removeAllObjects];
    [_iDocmentMutableDic removeAllObjects];
    _iDefaultDocment         = nil;
    _iIsPlaying              = NO;
    _isPlayMedia             = NO;
    _iHasPublishStd          = NO;
    _iStdOutBottom           = NO;
    _iIsFullState            = NO;
    _isLocal                 = NO;
    _iCurrentDocmentModel    = nil;
    _iPreDocmentModel        = nil;
    _iPreMediaDocModel       = nil;
    _iCurrentMediaDocModel   = nil;
}

- (void)configurePlayerRoute:(BOOL)aIsPlay isCancle:(BOOL)isCancle
{
//    if ([TKEduSessionHandle shareInstance].isHeadphones) {
//        [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
//        return;
//    }
    
    if (isCancle) {
        [[AVAudioSession sharedInstance]setActive:NO error:nil];
        return;
    }
    
     [self sessionHandleUseLoudSpeaker:aIsPlay];
     [self sessionHandleEnableOtherAudio:!aIsPlay];
    BOOL isHaveAudio = ((self.localUser.publishState == 1) || (self.localUser.publishState == 3));
    if (isHaveAudio) { [self sessionHandleEnableAudio:!aIsPlay];}
   
}
//Selecting audio inputs
- (void)selectingAudioInputs
{
    //private var inputs = [AVAudioSessionPortDescription]()
    AVAudioSession *tSession = [AVAudioSession sharedInstance];

    //Built-in microphone-内置麦克风
    //Microphone on a wired headset-耳机上麦克风
    //Headphone or headset - 耳机
    //The speaker - 扬声器
    //Built-in speaker - 内置扬声器
   //InReceiver - 听筒
    NSMutableArray<AVAudioSessionPortDescription *> * inputs = [NSMutableArray arrayWithCapacity:10];
    
    NSArray<AVAudioSessionPortDescription *> *availableInputs=   tSession.availableInputs;
    for (AVAudioSessionPortDescription* input in availableInputs) {
        if (input.portType == AVAudioSessionPortBuiltInMic || input.portType == AVAudioSessionPortHeadsetMic) {
            [inputs addObject:input];
        }
    }
    [tSession setPreferredInput:[inputs firstObject]  error:nil];
}

#pragma mark 检测摄像头和麦克风
- (void)checkDevice
{
    if (self.getMicrophoneFail == YES && self.getCameraFail == YES) {
        if (_iSessionDelegate && [_iSessionDelegate respondsToSelector:@selector(noCameraAndNoMicrophone)]) {
            [(id<TKEduSessionDelegate>) _iSessionDelegate noCameraAndNoMicrophone];
        }
    } else {
        if (self.getMicrophoneFail == YES) {
            if (_iSessionDelegate && [_iSessionDelegate respondsToSelector:@selector(noMicrophone)]) {
                [(id<TKEduSessionDelegate>) _iSessionDelegate noMicrophone];
            }
        }
        
        if (self.getCameraFail == YES) {
            if (_iSessionDelegate && [_iSessionDelegate respondsToSelector:@selector(noCamera)]) {
                [(id<TKEduSessionDelegate>) _iSessionDelegate noCamera];
            }
        }
    }
}

#pragma mark 获取摄像头失败
- (void)callCameroError
{
    if (_iRoomDelegate && [_iRoomDelegate respondsToSelector:@selector(onCameraDidOpenError)]) {
        
        [(id<TKEduRoomDelegate>) _iRoomDelegate onCameraDidOpenError];
        
    }
}
#pragma mark 进入前后台

- (void)enterForeground:(NSNotification *)aNotification
{
    TKLog(@"----sessionHandle2  %@",@(_iIsPlaying));

    if (_iCurrentMediaDocModel &&  _iIsPlaying && (self.localUser.role == UserType_Student)) {
       
    }
    
    if (self.localUser.role == UserType_Student) {
//        NSString *tMsgID = [NSString stringWithFormat:@"%@_%@",sUserEnterBackGround,self.localUser.peerID];
//        [self sessionHandleDelMsg:sUserEnterBackGround ID:tMsgID To:sSuperUsers Data:nil completion:nil];
//        [self sessionHandleChangeUserProperty:self.localUser.peerID TellWhom:sTellAll Key:sIsInBackGround Value:@(NO) completion:nil];
    }
}
- (void)enterBackground:(NSNotification *)aNotification
{
     //TKLog(@"----sessionHandle");
 
     TKLog(@"----sessionHandle  %@",@(_iIsPlaying));
    if (_iCurrentMediaDocModel&&_iIsPlaying && (self.localUser.role == UserType_Student)) {
       
    }
    
    if (self.localUser.role == UserType_Student) {
//        NSString *tMsgID = [NSString stringWithFormat:@"%@_%@",sUserEnterBackGround,self.localUser.peerID];
//        [self sessionHandlePubMsg:sUserEnterBackGround ID:tMsgID To:sSuperUsers Data:nil Save:true AssociatedMsgID:sUserEnterBackGround AssociatedUserID:self.localUser.peerID completion:nil];
//        [self sessionHandleChangeUserProperty:self.localUser.peerID TellWhom:sTellAll Key:sIsInBackGround Value:@(YES) completion:nil];
    }
}
#pragma mark 用户自己打开关闭音视频
- (void)disableMyVideo:(BOOL)disable
{
    [_roomMgr disableMyVideo:disable];
}

- (void)disableMyAudio:(BOOL)disable
{
    [_roomMgr disableMyAudio:disable];
}
#pragma mark media

- (void)sessionHandlePublishMedia:(NSString *)fileurl hasVideo:(BOOL)hasVideo fileid:(NSString *)fileid  filename:(NSString *)filename toID:(NSString*)toID block:(void (^)(NSError *))block
{
    if (!toID || [toID isEqualToString:@""]) {
        
        [_roomMgr startShareMediaFile:fileurl isVideo:hasVideo toID:sTellAll attributes:@{@"fileid":fileid,@"filename":filename} block:block];
        
    }else{
        
        [_roomMgr startShareMediaFile:fileurl isVideo:hasVideo toID:toID attributes:@{@"fileid":fileid,@"filename":filename} block:block];
    }
}

- (void)sessionHandleUnpublishMedia:(void (^)(NSError *))block
{
  
    [_roomMgr stopShareMediaFile:block];
}

- (int)sessionHandlePlayMediaFile:(NSString *)peerId renderType:(TKRenderMode)renderType window:(UIView *)window completion:(completion_block)completion
{
    return [_roomMgr playMediaFile:peerId renderType:renderType window:window completion:completion];
}

- (int)sessionHandleUnPlayMediaFile:(NSString *)peerId completion:(completion_block)completion
{
    return [_roomMgr unPlayMediaFile:peerId completion:completion];
}

- (void)sessionHandleMediaPause:(BOOL)pause
{
    [_roomMgr pauseMediaFile:pause];
}
- (void)sessionHandleMediaSeektoPos:(NSTimeInterval)pos
{
    [_roomMgr seekMediaFile:pos];
}
- (int)sessionHandleSetRemoteAudioVolume:(CGFloat)volume peerId:(NSString *)peerId type:(TKMediaType)type
{
   return [_roomMgr setRemoteAudioVolume:volume peerId:peerId type:type];
}
- (void)configureHUD:(NSString *)aString  aIsShow:(BOOL)aIsShow
{
    if ([NSThread isMainThread]) {
        [self showHudOnMainThreadWithString:aString show:aIsShow];
    } else
    {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self showHudOnMainThreadWithString:aString show:aIsShow];
        });
    }
}

// 需要在UI线程 显示 todo
- (void)showHudOnMainThreadWithString:(NSString *)aString show:(BOOL)aIsShow
{
    if (aIsShow) {
        
        [TKHUD showAtView:TKMainWindow message:aString hudType:(TKHUDLoadingTypeCustomAnimations)];
    }else{
        
        [TKHUD hideForView:TKMainWindow];
    }
}

#pragma mark screen

- (int)sessionHandlePlayScreen:(NSString *)peerID renderType:(TKRenderMode)renderType window:(UIView *)window completion:(completion_block)completion{
    
   return [_roomMgr playScreen:peerID renderType:renderType window:window completion:completion];
}

- (int)sessionHandleUnPlayScreen:(NSString *)peerID completion:(completion_block)completion;
{
   return [_roomMgr unPlayScreen:peerID completion:completion];
}


#pragma mark file
- (int)sessionHandlePlayFile:(NSString *)peerId renderType:(TKRenderMode)renderType window:(UIView *)window completion:(completion_block)completion{
   return [_roomMgr playFile:peerId renderType:renderType window:window completion:completion];
}
- (int)sessionHandleUnPlayFile:(NSString *)peerId completion:(void (^)(NSError *))block{

   return [_roomMgr unPlayFile:peerId completion:block];
}


#pragma mark - 回放
- (void)playback
{
    [_roomMgr playback];
    //给白板发送回放开始消息
    [self playbackPlayAndPauseController:true];
}

- (void)pausePlayback
{
    [_roomMgr pausePlayback];
    //给白板发送回放停止消息
    [self playbackPlayAndPauseController:false];
}
//play:布尔值，代表回放是否播放
- (void)playbackPlayAndPauseController:(BOOL)play
{
    
}
- (void)seekPlayback:(NSTimeInterval)positionTime
{
    TKLog(@"TK------------seek%f!",positionTime);
    [self sessionHandleDelMsg:sVideoWhiteboard ID:sVideoWhiteboard To:sTellAll Data:@{} completion:nil];
    [_roomMgr seekPlayback:positionTime];
}
#pragma mark - 设置权限
// 从1 开始 36:支持h5课件  37:助教是否开启音视频  38:画笔权限  39:允许操作ppt翻页
- (void)configureDrawAndPageWithControl:(NSString *)aChairmancontrol
{
    
    NSRange tAssitOpenVInitRange = NSMakeRange(36, 1);
    NSRange tDrawRange           = NSMakeRange(37, 1);
    NSRange tPageRange           = NSMakeRange(38, 1);
    NSString *tAssistStr  = [aChairmancontrol substringWithRange:tAssitOpenVInitRange];
    
    NSString *tDrawStr     = [aChairmancontrol substringWithRange:tDrawRange];
    NSString *tPageStr     = [aChairmancontrol substringWithRange:tPageRange];
    self.iIsCanDrawInit    = [tDrawStr integerValue];
    self.iIsCanPageInit    = [tPageStr integerValue];
    self.iIsAssitOpenVInit = [tAssistStr integerValue];
    
}

//sTellAll
- (void)configureDraw:(BOOL)isDraw isSend:(BOOL)isSend to:(NSString *)to peerID:(NSString*)peerID
{
    BOOL isMe = [peerID isEqualToString:self.localUser.peerID];
    self.iIsCanDraw = isMe ?isDraw:self.iIsCanDraw;
    if (isSend) {
        [self sessionHandleChangeUserProperty: peerID TellWhom:to Key:sCandraw Value:@((bool)(isDraw)) completion:nil];
    }
}
- (void)configurePage:(BOOL)isPage isSend:(BOOL)isSend to:(NSString *)to peerID:(NSString*)peerID
{
    BOOL isMe = [peerID isEqualToString:self.localUser.peerID];
    self.iIsCanPage = isMe ?isPage:self.iIsCanPage;
    if (isSend) {}
    
}


- (void)dealloc
{
    TKLog(@"----sessionHandle");
}

- (NSString *)getDefaultArea
{
    return nil;
}

- (void)startPlayAudioFile:(NSString *)filePath loop:(BOOL)loop {
    [[TKRoomManager instance] startPlayAudioFile:filePath loop:loop];
}
@end
