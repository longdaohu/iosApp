
//
//  TKEduSessionHandle.h
//  EduClassPad
//
//  Created by ifeng on 2017/5/10.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKEduClassRoom.h"
#import "TKMacro.h"
NS_ASSUME_NONNULL_BEGIN
@class TKChatMessageModel,TKEduRoomProperty,TKMediaDocModel,TKDocmentDocModel,RoomUser,RoomManager,TKDocumentListView,TKProgressHUD;

@protocol TKEduSessionClassRoomDelegate<NSObject>
-(void)sessionClassRoomDidOccuredError:(NSError *_Nullable)error;
- (void)sessionRoomManagerDidOccuredWaring:(TKRoomWarningCode)code;
@end

#pragma mark 1 TKEduSessionDelegate

@protocol TKEduSessionDelegate <NSObject>
//自己进入课堂
- (void)sessionManagerRoomJoined;
//自己离开课堂
- (void)sessionManagerRoomLeft ;
//自己被踢
-(void) sessionManagerSelfEvicted:(NSDictionary *)reason;
//观看视频/取消视频
- (void)sessionManagerPublishStateWithUserID:(NSString *)peerID publishState:(TKPublishState)state;

- (void)sessionManagerOnAudioVolumeWithPeerID:(NSString *)peeID volume:(int)volume;
//用户进入
- (void)sessionManagerUserJoined:(TKRoomUser *)user InList:(BOOL)inList ;
//用户离开
- (void)sessionManagerUserLeft:(NSString *)peerID;
//用户信息变化 sGiftNumber sCandraw sRaisehand sPublishstate
- (void)sessionManagerUserChanged:(TKRoomUser *)user Properties:(NSDictionary*)properties fromId:(NSString *)fromId;
//聊天信息
- (void)sessionManagerMessageReceived:(NSString *)message
                               fromID:(NSString *)peerID
                            extension:(NSDictionary *)extension;
//回放的聊天信息
//- (void)sessionManagerPlaybackMessageReceived:(NSString *)message ofUser:(TKRoomUser *)user ts:(NSTimeInterval)ts;

- (void)sessionManagerRoomManagerPlaybackMessageReceived:(NSString *)message
                                    fromID:(NSString *)peerID
                                        ts:(NSTimeInterval)ts
                                 extension:(NSDictionary *)extension;
//进入会议失败
- (void)sessionManagerDidFailWithError:(NSError *)error;
- (void)sessionManagerDidOccuredWaring:(TKRoomWarningCode)code;
//白板等相关信令
- (void)sessionManagerOnRemoteMsg:(BOOL)add ID:(NSString*)msgID Name:(NSString*)msgName TS:(unsigned long)ts Data:(NSObject*)data InList:(BOOL)inlist;

//获取礼物数
- (void)sessionManagerGetGiftNumber:(void(^)())completion;
#pragma mark media

/**
 用户媒体流发布状态 变化回调
 @param peerId 用户id
 @param state 0:取消  非0：发布
 @param message 扩展消息
 */
- (void)sessionManagerOnShareMediaState:(NSString *)peerId
                                  state:(TKMediaState)state
                       extensionMessage:(NSDictionary *)message;

/**
 更新媒体流的信息回调
 @param duration 媒体流当前播放的时间点
 @param pos 媒体流当前的进度
 @param isPlay 播放（YES）暂停（NO）
 */
- (void)sessionManagerUpdateMediaStream:(NSTimeInterval)duration
                                    pos:(NSTimeInterval)pos
                                 isPlay:(BOOL)isPlay;

- (void)sessionManagerMediaLoaded;

#pragma mark Screen
- (void)sessionManagerOnShareScreenState:(NSString *)peerId state:(TKMediaState)state extensionMessage:(NSDictionary *)message;
#pragma mark file
- (void)sessionManagerOnShareFileState:(NSString *)peerId state:(TKMediaState)state extensionMessage:(NSDictionary *)message;
#pragma mark Playback
- (void)sessionManagerReceivePlaybackDuration:(NSTimeInterval)duration;
- (void)sessionManagerPlaybackUpdateTime:(NSTimeInterval)time;
- (void)sessionManagerPlaybackClearAll;
- (void)sessionManagerPlaybackEnd;
#pragma mark 设备检测
- (void)noCamera;
- (void)noMicrophone;
- (void)noCameraAndNoMicrophone;

#pragma mark 首次发布或订阅失败3次
- (void)networkTrouble;
- (void)networkChanged;
@end

@protocol TKEduBoardDelegate <NSObject>
@optional

- (void)boardOnViewStateUpdate:(NSDictionary *_Nullable)message;

- (void)boardOnFullScreen:(BOOL)isFull;
@end

#pragma mark 2 TKEduSessionHandle

@interface TKEduSessionHandle : NSObject

@property (nonatomic, assign) BOOL bigRoom;//大规模教室
@property (strong, nonatomic) NSMutableArray *cacheMsgPool;//缓存数据
@property (nonatomic, weak) id<TKEduRoomDelegate>    iRoomDelegate;
@property (nonatomic, weak) id<TKEduSessionDelegate> iSessionDelegate;
@property (nonatomic, weak) id<TKEduBoardDelegate>   iWhiteBoardDelegate;
@property (nonatomic, weak) id<TKEduSessionClassRoomDelegate> iClassRoomDelegate;
@property (nonatomic, strong) TKRoomManager *roomMgr;

@property (nonatomic, strong) UIView *whiteboardView;//记录白板
@property (nonatomic, assign) CGFloat bottomHeight;//记录bottom的高度

@property (nonatomic, strong, readonly) TKRoomUser *localUser;


@property (nonatomic, copy) NSDictionary *iParamDic;
@property (nonatomic,strong) NSMutableDictionary *iPublishDic;
@property (nonatomic,strong) NSMutableArray *iUserList;

#pragma mark 自定义
@property (nonatomic, strong) TKEduRoomProperty *iRoomProperties;
@property (nonatomic, strong) TKRoomUser *iTeacherUser;
@property (nonatomic, assign) BOOL isClassBegin;
@property (nonatomic, assign) BOOL isMuteAudio;//全体静音
@property (nonatomic, assign) BOOL isunMuteAudio;//全体发言状态
@property (nonatomic, assign) BOOL isAllShutUp;// 全体禁言
@property (nonatomic, assign) BOOL iIsCanOffertoDraw;//yes 可以 no 不可以
@property (nonatomic, assign) BOOL isHeadphones;//是否是耳机
@property (nonatomic, assign) BOOL iIsClassEnd;
@property (nonatomic, assign) BOOL iHasPublishStd;//是否有发布的学生
@property (nonatomic, assign) BOOL iStdOutBottom;//是否有拖出去的视频
@property (nonatomic, assign) BOOL iIsFullState;//是否全屏状态
@property (nonatomic, assign) BOOL iIsSplitScreen;//是否分屏状态
@property (nonatomic, strong) NSNumber * videoRatio;//mp4视频比例
#pragma mark 白板

@property (nonatomic, strong) TKWhiteBoardManager *whiteBoardManager;//文档

@property (nonatomic,strong) TKMediaDocModel    *iCurrentMediaDocModel;
@property (nonatomic,strong) TKMediaDocModel    *iPreMediaDocModel;
@property (nonatomic,strong) TKDocmentDocModel  *iCurrentDocmentModel;
@property (nonatomic,strong) TKDocmentDocModel  *iPreDocmentModel;
@property(nonatomic,strong)  UIView *iDocumentListView;
@property(nonatomic,strong)  UIView *iMediaListView;
@property (nonatomic,strong) TKDocmentDocModel  *iDefaultDocment;
@property (nonatomic,strong) NSMutableArray     *iDocmentMutableArray;
@property (nonatomic,strong) NSMutableDictionary*iDocmentMutableDic;
@property (nonatomic,strong) NSMutableArray     *iMediaMutableArray;
@property (nonatomic,strong) NSMutableDictionary*iMediaMutableDic;
@property (nonatomic,strong) NSMutableArray     *msgList;

@property (nonatomic,assign)BOOL iIsPlaying;//是否播放中
@property (nonatomic,assign)BOOL isPlayMedia;//是否有音频
@property (nonatomic,assign)BOOL isChangeMedia;//是否是切换
@property (nonatomic, assign) CGFloat iVolume;//音量 默认最大，耳机一半
@property (nonatomic,assign)BOOL isLocal;
@property (nonatomic,assign)BOOL isPlayback;  // 是否是回放
@property (nonatomic,assign)BOOL iIsJoined;//是否加入了房间
@property (nonatomic, assign) BOOL isSendLogMessage;//2017-11-10是否打印h5日志

//配置项
@property (assign,nonatomic)BOOL iIsCanDraw;
@property (assign,nonatomic)BOOL iIsCanPage;
@property (assign,nonatomic)BOOL iIsCanDrawInit;
@property (assign,nonatomic)BOOL iIsCanPageInit;
@property (assign,nonatomic)BOOL iIsAssitOpenVInit;
//未读聊天消息
@property (strong,nonatomic)NSMutableArray *unReadMessagesArray;

@property (assign, nonatomic) BOOL UIDidAppear;


+(instancetype)shareInstance;
+(void)destory;

- (void)configureSession:(NSDictionary*)paramDic
       aClassRoomDelgate:(id<TKEduSessionClassRoomDelegate>)aClassRoomDelgate
            aRoomDelegate:(id<TKEduRoomDelegate>) aRoomDelegate
         aRoomProperties:(TKEduRoomProperty*)aRoomProperties;

- (void)setSessionDelegate:(id<TKEduSessionDelegate>) aSessionDelegate
            aBoardDelegate:(id<TKEduBoardDelegate>)aBoardDelegate
           aRoomProperties:(TKEduRoomProperty*)aRoomProperties;


// 回放进入接口
- (void)configurePlaybackSession:(NSDictionary*)paramDic
                   aRoomDelegate:(id<TKEduRoomDelegate>) aRoomDelegate
                aSessionDelegate:(id<TKEduSessionDelegate>) aSessionDelegate
                  aBoardDelegate:(id<TKEduBoardDelegate>)aBoardDelegate
                 aRoomProperties:(TKEduRoomProperty*)aRoomProperties;


-(void)joinEduClassRoomWithParam:(NSDictionary *)aParamDic aProperties:(NSDictionary *)aProperties;

- (int)sessionHandleSetDeviceOrientation:(UIDeviceOrientation)orientation;

- (void)sessionHandleLeaveRoom:(void (^)(NSError *error))block;

-(void) sessionHandleLeaveRoom:(BOOL)force Completion:(void (^)(NSError *))block;

-(void)sessionHandleVideoProfile:(TKVideoProfile *)videoProfile;

- (int)sessionHandlePlayVideo:(NSString *)peerID
                   renderType:(TKRenderMode)renderType
                       window:(UIView *)window
                   completion:(completion_block)completion;


- (void)sessionHandleUnPlayVideo:(NSString*)peerID completion:(void (^)(NSError *error))block;

- (void)sessionHandleChangeUserProperty:(NSString*)peerID TellWhom:(NSString*)tellWhom Key:(NSString*)key Value:(NSObject*)value completion:(void (^)(NSError *error))block;
- (void)sessionHandleChangeUserProperty:(NSString*)peerID TellWhom:(NSString*)tellWhom data:(NSDictionary*)data completion:(void (^)(NSError *error))block;

- (void)sessionHandleChangeUserPropertyByRole:(NSArray *)roles
                                     tellWhom:(NSString *)tellWhom
                                     property:(NSDictionary *)properties
                                   completion:(completion_block _Nullable)completion;

/**
  进入前台
 */
- (void)sessionHandleApplicationWillEnterForeground;

- (void)sessionHandleChangeUserPublish:(NSString*)peerID Publish:(int)publish completion:(void (^)(NSError *error))block;

- (void)sessionHandleSendMessage:(NSObject *)message toID:(NSString *)toID extensionJson:(NSObject *)extension;

- (int)sessionHandleGetRoomUserNumberWithRole:(NSArray * _Nullable)role callback:(void (^)(NSInteger num, NSError *error))callback;


- (int)sessionHandleGetRoomUsersWithRole:(NSArray * _Nullable)role startIndex:(NSInteger)start maxNumber:(NSInteger)max callback:(void (^)(NSArray <TKRoomUser *>* _Nonnull users , NSError *error) )callback;

- (void)sessionHandlePubMsg:(NSString*)msgName ID:(NSString*)msgID To:(NSString*)toID Data:(NSObject*)data Save:(BOOL)save completion:(void (^)(NSError *error))block;
- (void)sessionHandlePubMsg:(NSString *)msgName ID:(NSString *)msgID To:(NSString *)toID Data:(NSObject *)data Save:(BOOL)save AssociatedMsgID:(NSString *)associatedMsgID AssociatedUserID:(NSString *)associatedUserID
                    expires:(NSTimeInterval)expires completion:(void (^)(NSError *))block;

- (void)sessionHandleDelMsg:(NSString*)msgName ID:(NSString*)msgID To:(NSString*)toID Data:(NSObject*)data completion:(void (^)(NSError *error))block;

- (void)sessionHandleEvictUser:(NSString *)peerID  evictReason:(NSNumber *)reason completion:(completion_block)completion;

-(void)publishVideoDragWithDic:(NSDictionary * )aVideoDic To:(NSString *)to;
//WebRTC & Media

- (void)sessionHandleSelectCameraPosition:(BOOL)isFront;

- (BOOL)sessionHandleIsVideoEnabled;

- (void)sessionHandleEnableVideo:(BOOL)enable;

- (BOOL)sessionHandleIsAudioEnabled;

- (void)sessionHandleEnableAllAudio:(BOOL)enable;

- (void)sessionHandleEnableAudio:(BOOL)enable;

- (void)sessionHandleEnableOtherAudio:(BOOL)enable;

- (void)sessionHandleUseLoudSpeaker:(BOOL)use;
#pragma mark media
//发布媒体流
- (void)sessionHandlePublishMedia:(NSString *)fileurl hasVideo:(BOOL)hasVideo fileid:(NSString *)fileid  filename:(NSString *)filename toID:(NSString*)toID block:(void (^)(NSError *))block;
//关闭媒体流
- (void)sessionHandleUnpublishMedia:(void (^)(NSError *))block;
//播放媒体流
- (int)sessionHandlePlayMediaFile:(NSString *)peerId renderType:(TKRenderMode)renderType window:(UIView *)window completion:(completion_block)completion;
- (int)sessionHandleUnPlayMediaFile:(NSString *)peerId completion:(completion_block)completion;
//媒体流暂停
-(void)sessionHandleMediaPause:(BOOL)pause;
//媒体流进度
-(void)sessionHandleMediaSeektoPos:(NSTimeInterval)pos;
//媒体流音量
//-(void)sessionHandleMediaVolum:(CGFloat)volum;
- (int)sessionHandleSetRemoteAudioVolume:(CGFloat)volume peerId:(NSString *)peerId type:(TKMediaType)type;

#pragma mark Screen

- (int)sessionHandlePlayScreen:(NSString *)peerID renderType:(TKRenderMode)renderType window:(UIView *)window completion:(completion_block)completion;
- (int)sessionHandleUnPlayScreen:(NSString *)peerID completion:(completion_block)completion;


#pragma mark file
- (int)sessionHandlePlayFile:(NSString *)peerID renderType:(TKRenderMode)renderType window:(UIView *)window completion:(completion_block)completion;
- (int)sessionHandleUnPlayFile:(NSString *)peerID completion:(completion_block)completion;

#pragma 其他
-(void)clearAllClassData;
-(void)clearMessageList;
//message
- (NSArray *)messageList;
- (void)addOrReplaceMessage:(TKChatMessageModel *)aMessageModel;
- (void)addTranslationMessage:(TKChatMessageModel *)aMessageModel;
- (BOOL)judgmentOfTheSameMessage:(NSString *)message lastSendTime:(NSString *)time;
//audio
- (NSSet *)userPlayAudioArray;
- (void)addOrReplaceUserPlayAudioArray:(TKRoomUser *)aRoomUser ;
- (void)delUserPlayAudioArray:(TKRoomUser *)aRoomUser ;
//user
- (NSArray *)userArray;
- (TKRoomUser *)getUserWithPeerId:(NSString *)peerId;
- (void)addUser:(TKRoomUser *)aRoomUser;
- (void)delUser:(TKRoomUser *)aRoomUser;
//user 老师和学生
- (NSArray *)userStdntAndTchrArray;
- (void)addUserStdntAndTchr:(TKRoomUser *)aRoomUser;
- (void)delUserStdntAndTchr:(TKRoomUser *)aRoomUser;
-(TKRoomUser *)userInUserList:(NSString*)peerId ;
//除了老师teacher和巡课Patrol
- (NSArray *)userListExpecPtrlAndTchr;
//特殊身份 助教等
-(void)addSecialUser:(TKRoomUser *)aRoomUser;
-(void)delSecialUser:(TKRoomUser *)aRoomUser;
-(NSDictionary *)secialUserDic;
//pending
-(NSDictionary *)pendingUserDic;
-(void)delePendingUser:(NSString *)peerID;
-(bool)addPendingUser:(TKRoomUser *)aRoomUser;
//publish
-(void)addPublishUser:(TKRoomUser *)aRoomUser;
-(void)delePublishUser:(TKRoomUser *)aRoomUser;
-(NSDictionary *)publishUserDic;
//unpublish
-(void)addUnPublishUser:(TKRoomUser *)aRoomUser;
-(void)deleUnPublishUser:(TKRoomUser *)aRoomUser;
-(NSDictionary *)unpublishUserDic;
#pragma mark 影音
-(void)deleteaMediaDocModel:(TKMediaDocModel*)aMediaDocModel To:(NSString *)to;
#pragma mark 文档
-(void)publishtDocMentDocModel:(TKDocmentDocModel*)tDocmentDocModel To:(NSString *)to aTellLocal:(BOOL)aTellLocal;
//删除文档
-(void)deleteDocMentDocModel:(TKDocmentDocModel*)aDocmentDocModel To:(NSString *)to;
//添加文档
-(void)addDocMentDocModel:(TKDocmentDocModel*)aDocmentDocModel To:(NSString *)to;
//老师点击下课时获取文档
- (TKDocmentDocModel *)getClassOverDocument;
#pragma mark 白板
//文档
-(NSDictionary *)docmentDic;
-(TKDocmentDocModel*)getDocmentFromFiledId:(NSString *)aFiledId;
//白板
- (TKDocmentDocModel *)whiteBoard;
//文档数组
- (NSArray *)docmentArray;
//教室文档文件
- (NSArray *)classDocmentArray;
//公用文档文件
- (NSArray *)systemDocmentArray;

- (bool)addOrReplaceDocmentArray:(TKDocmentDocModel *)aDocmentDocModel;
- (void)delDocmentArray:(TKDocmentDocModel *)aDocmentDocModel;
-(TKDocmentDocModel *)getNextDocment:(TKDocmentDocModel *)aCurrentDocmentModel;
- (void)fileListResetToDefault;         // 使文档列表中的文档复位
//音视频
-(NSDictionary *)meidaDic;
-(TKMediaDocModel*)getMediaFromFiledId:(NSString *)aFiledId;

//媒体文件
- (NSArray *)mediaArray;
//教室媒体文件
- (NSArray *)classMediaArray;
//公用媒体文件
- (NSArray *)systemMediaArray;


- (void)addOrReplaceMediaArray:(TKMediaDocModel *)aMediaDocModel;
- (void)delMediaArray:(TKMediaDocModel *)aMediaDocModel;
-(TKMediaDocModel*)getNextMedia:(TKMediaDocModel *)aCurrentMediaDocModel;


-(BOOL)isEqualFileId:(id)aModel  aSecondModel:(id)aSecondModel;
#pragma mark 设置声道
-(void)configurePlayerRoute:(BOOL)aIsPlay isCancle:(BOOL)isCancle;
#pragma mark 用户自己打开关闭音视频
- (void)disableMyVideo:(BOOL)disable;
- (void)disableMyAudio:(BOOL)disable;
#pragma mark 设置HUD
-(void)configureHUD:(NSString *)aString  aIsShow:(BOOL)aIsShow;

#pragma mark 回放相关
- (void)playback;
- (void)pausePlayback;
- (void)seekPlayback:(NSTimeInterval)positionTime;

#pragma mark 设置权限
//画笔权限以及翻页权限初始化
-(void)configureDrawAndPageWithControl:(NSString *)aChairmancontrol;
- (void)configureDraw:(BOOL)isDraw isSend:(BOOL)isSend to:(NSString *)to peerID:(NSString*)peerID;
- (void)configurePage:(BOOL)isPage isSend:(BOOL)isSend to:(NSString *)to peerID:(NSString*)peerID;

#pragma mark - 播放声音
- (void)startPlayAudioFile:(NSString *)filePath loop:(BOOL)loop;
NS_ASSUME_NONNULL_END
@end
