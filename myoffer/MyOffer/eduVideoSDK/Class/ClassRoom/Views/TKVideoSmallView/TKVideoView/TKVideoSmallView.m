//
//  TKVideoSmallView.m
//  whiteBoardDemo
//
//  Created by ifeng on 2017/2/23.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKVideoSmallView.h"
#import "TKUtil.h"

#import "TKEduSessionHandle.h"
#import "TKEduNetManager.h"
#import "TKEduRoomProperty.h"
#import "TKBackGroundView.h"
#import "TKVideoPopupMenu.h"
#import "TKVideoVerticalFunctionView.h"
#import "TKMaskView.h"
#import "TKTrophyView.h"//自定义奖杯
#import "TKImageLoadBit.h"
#import <UIImage+GIF.h>

#define ThemeKP(args) [@"ClassRoom.TKVideoView." stringByAppendingString:args]
@interface TKVideoSmallView ()<CAAnimationDelegate,TKVideoPopupMenuDelegate>
{
    NSString *_giftWav;//记录声音地址
}
@property (nonatomic, strong) TKBackGroundView *sIsInBackGroundView;//进入后台覆盖视图

@property (nonatomic, strong) TKMaskView *maskView;//上层背景贴图

@property (nonatomic, strong) TKVideoPopupMenu *videoPopupMenu;
@property (nonatomic, strong) TKVideoVerticalFunctionView *videoVerticalPopupMenu;
//gift
@property (nonatomic, strong) UIImageView *iGiftAnimationView;

@property (nonatomic, assign) NSInteger iGiftCount;
@property (nonatomic, assign) EVideoRole videoRole;

@property (nonatomic, strong) UIImageView *gifView;
@property (nonatomic, strong) TKTrophyView *trophyView;

@end


@implementation TKVideoSmallView

//super override
- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame aVideoRole:EVideoRoleTeacher];
}

-(instancetype)initWithFrame:(CGRect)frame aVideoRole:(EVideoRole)aVideoRole{
    
    if (self = [super initWithFrame:frame]) {
        
//        self.sakura.backgroundColor(ThemeKP(@"videoBackColor"));
        self.backgroundColor = [UIColor blackColor];
        
        _originalWidth = frame.size.width;
        _originalHeight = frame.size.height;
        _videoRole = aVideoRole;
        _maskView = [[TKMaskView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) aVideoRole:aVideoRole];
        [self addSubview:_maskView];
        
         _iFunctionButton = ({
             
            UIButton *tButton = [UIButton buttonWithType:UIButtonTypeCustom];
             tButton.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
             [tButton addTarget:self action:@selector(functionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
             tButton.backgroundColor = [UIColor clearColor];

            tButton;
            
        });
         [self addSubview:_iFunctionButton];

        // 缩放手势
        UIPinchGestureRecognizer *pinchGR = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchSelf:)];
        [self addGestureRecognizer:pinchGR];
    }
    return self;
}

-(void)layoutSubviews{
    
    [self bringSubviewToFront:_iFunctionButton];
    
    _maskView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    // 分屏下布局
    CGFloat videoSmallWidth  = CGRectGetWidth(self.frame);
    
    CGFloat videoSmallHeight = CGRectGetHeight(self.frame);
    
    self.currentWidth = videoSmallWidth;
    self.currentHeight = videoSmallHeight;
    
    
    _sIsInBackGroundView.frame = CGRectMake(0, 0, videoSmallWidth, videoSmallHeight);
    
    
   
    _iFunctionButton.frame = CGRectMake(0, 0, videoSmallWidth, videoSmallHeight);
    
    
    if (self.finishScaleBlock) {
        self.finishScaleBlock();
    }
}

-(void)setIsNeedFunctionButton:(BOOL)isNeedFunctionButton{
    _iFunctionButton.enabled = isNeedFunctionButton;
}
-(void)setIRoomUser:(TKRoomUser *)iRoomUser{
    
    _maskView.iRoomUser = iRoomUser;
    
    if (iRoomUser) {
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshRaiseHandUI:) name:[NSString stringWithFormat:@"%@%@",sRaisehand,iRoomUser.peerID] object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshVolume:) name:[NSString stringWithFormat:@"%@%@",sVolume,iRoomUser.peerID] object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(inBackground:) name:[NSString stringWithFormat:@"%@%@",sIsInBackGround,iRoomUser.peerID] object:nil];
        
    }else{
        
        //删除前一个
        [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%@%@",sRaisehand,_iRoomUser.peerID] object:nil];
        
        [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%@%@",sIsInBackGround,_iRoomUser.peerID] object:nil];
        
    }
    
    // 学生自己可以在自己的SmallView上弹出操作视图
    if ([iRoomUser.peerID isEqualToString:[TKEduSessionHandle shareInstance].localUser.peerID] && iRoomUser.role == EVideoRoleOther) {
        _iFunctionButton.enabled = YES;
    }
   
    _iRoomUser = iRoomUser;
    int currentGift = 0;
    if(iRoomUser && iRoomUser.properties && [iRoomUser.properties objectForKey:sGiftNumber])
    {
        
        currentGift = [[_iRoomUser.properties objectForKey:sGiftNumber] intValue];

    }
   
    // 助教视频不显示奖杯
    if (iRoomUser.role == UserType_Assistant) {
        
    }
//todo
  
    // 根据用户disableAudio和disableVideo去设置图片
  
    [self bringSubviewToFront:_maskView];
//    [_maskView openVideo];
    
}
- (void)inBackground:(NSNotification *)aNotification{
    BOOL isInBackground =[aNotification.userInfo[sIsInBackGround] boolValue];
    
    [self endInBackGround:isInBackground];
}
- (void)endInBackGround:(BOOL)isInBackground{
    
    
    [self.maskView endInBackGround:isInBackground];
}

#pragma mark - 状态改变 接收到的通知
-(void)refreshRaiseHandUI:(NSNotification *)aNotification{
    //打开视频关闭视频开关
    NSDictionary *tDic = (NSDictionary *)aNotification.object;
   
    [self.maskView refreshRaiseHandUI:tDic];
    if([[tDic objectForKey:sGiftNumber]integerValue] && _iRoomUser.role != UserType_Teacher){
        
        NSString *fromId = [tDic objectForKey:sFromId];
        
        NSDictionary *giftInfo = [NSDictionary dictionaryWithDictionary:[TKUtil getDictionaryFromDic:_iRoomUser.properties Key:sGiftinfo]];
        if ([fromId isEqualToString:_iRoomUser.peerID] == NO) {
            [self potStartAnimationForView:self giftinfo:giftInfo];
        }
    }
}

#pragma mark - 声音检测
- (void)refreshVolume:(NSNotification *)aNotification{
    //打开音频关闭音频开关
    NSDictionary *tDic = (NSDictionary *)aNotification.object;
    [self.maskView refreshVolume:tDic];
   
}
#pragma mark - 视频触摸事件
-(void)functionButtonClicked:(UIButton *)aButton{
    //如果是文档全屏状态不显示控制视图
    if ([TKEduSessionHandle shareInstance].iIsFullState) {
        return;
    }
    
    if ([[TKEduSessionHandle shareInstance] localUser].publishState == PublishState_NONE ||[[TKEduSessionHandle shareInstance] localUser].publishState ==  PublishState_Local_NONE) {
        return;
    }
    
    if (![[TKEduSessionHandle shareInstance].roomMgr getRoomConfigration].allowStudentCloseAV && [TKEduSessionHandle shareInstance].localUser.role == UserType_Student) {
        return;
    }
    if (![TKEduSessionHandle shareInstance].isClassBegin && [TKEduSessionHandle shareInstance].localUser.role == UserType_Teacher && ![_iPeerId isEqualToString:[TKEduSessionHandle shareInstance].localUser.peerID]) {
        return;
    }
    
    if (!_iPeerId || [_iPeerId isEqualToString:@""] || ([TKEduSessionHandle shareInstance].localUser.role == UserType_Student && [[TKEduSessionHandle shareInstance].roomMgr getRoomConfigration].allowStudentCloseAV == NO) || ([TKEduSessionHandle shareInstance].localUser.role != UserType_Teacher && ![_iPeerId isEqualToString:[TKEduSessionHandle shareInstance].localUser.peerID]))
        return;
    
  
    [[NSNotificationCenter defaultCenter]postNotificationName:sTapTableNotification object:nil];

    _videoPopupMenu = [TKVideoPopupMenu showRelyOnView:aButton aVideoRole:_videoRole aRoomUer:_iRoomUser isSplit:self.isSplit delegate:self];


}
- (void)hidePopMenu{
    [_videoPopupMenu dismiss];
}


- (void)setIsSplit:(BOOL)isSplit{
    _isSplit = isSplit;
    _maskView.isSplit = isSplit;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}

-(void)changeName:(NSString *)aName{
  
    if (!aName||aName.length==0) {
        return;
    }
    [self bringSubviewToFront:_iFunctionButton];
   
    if (_maskView) {
        [_maskView changeName:aName];
    }
}

-(void)clearVideoData{
    _iPeerId = @"";
    self.iRoomUser = nil;
    _isDrag = NO;
    _isSplit = NO;
    [_videoPopupMenu dismiss];
    [self changeName:@""];
}



- (void)changeVideoSize:(CGFloat)scale {
    CGFloat width = self.originalWidth * scale;
    if (width < self.originalWidth) {
        // 无法缩小至比初始化大小还小
        return;
    }
    
    
    if (self.onRemoteMsgResizeVideoViewBlock) {
//        self.onRemoteMsgResizeVideoViewBlock(scale);
        self.frame = self.onRemoteMsgResizeVideoViewBlock(scale);
        [self setNeedsLayout];
    }
}

#pragma mark Action
- (void)pinchSelf:(UIPinchGestureRecognizer *)gestureRecognizer {
    // 巡课不允许缩放
    if ([TKEduSessionHandle shareInstance].localUser.role == UserType_Patrol) {
        return;
    }
    
    if (![TKEduSessionHandle shareInstance].iIsCanDraw ) {
        
            return;
        
    }
    
    // 没有拖出去不允许缩放
    if (self.isDrag == NO) {
        return;
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan || gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint center = self.center;
        CGRect newframe = self.frame;
        CGFloat height = newframe.size.height * gestureRecognizer.scale;
        CGFloat width = newframe.size.width * gestureRecognizer.scale;
        if (width < self.originalWidth) {
            // 无法缩小至比初始化大小还小
            return;
        }
        
        // 保证不超出白板
        if (self.isWhiteboardContainsSelfBlock) {
            if(self.isWhiteboardContainsSelfBlock() == NO) {
                if (gestureRecognizer.scale >= 1.0) {
                    return;
                }
            }
        }
        
        self.frame = CGRectMake(center.x - width/2.0, center.y - height/2.0, width, height);
        [self setNeedsLayout];
        gestureRecognizer.scale = 1;
        
        // 只有老师发送缩放信令
        if ([TKEduSessionHandle shareInstance].localUser.role == UserType_Teacher) {
            NSDictionary *tDict = @{@"ScaleVideoData":
                                        @{self.iRoomUser.peerID:
                                              @{@"scale":@(width/self.originalWidth)}
                                          }
                                    };
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tDict options:NSJSONWritingPrettyPrinted error:nil];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [[TKEduSessionHandle shareInstance] sessionHandlePubMsg:sVideoZoom ID:sVideoZoom To:sTellAllExpectSender Data:jsonString Save:true AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
        }
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (self.isWhiteboardContainsSelfBlock) {
            if(self.isWhiteboardContainsSelfBlock() == NO) {
                if (self.resizeVideoViewBlock) {
                    self.frame = self.resizeVideoViewBlock();
                    [self setNeedsLayout];
                    
                    // 只有老师发送缩放信令
                    if ([TKEduSessionHandle shareInstance].localUser.role == UserType_Teacher) {
                        NSDictionary *tDict = @{@"ScaleVideoData":
                                                    @{self.iRoomUser.peerID:
                                                          @{@"scale":@(self.frame.size.width/self.originalWidth)}
                                                      }
                                                };
                        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tDict options:NSJSONWritingPrettyPrinted error:nil];
                        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                        [[TKEduSessionHandle shareInstance] sessionHandlePubMsg:sVideoZoom ID:sVideoZoom To:sTellAllExpectSender Data:jsonString Save:true AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
                    }
                }
            }
        }
    }
}

#pragma mark - 动画
//view 视频窗口  giftinfo 奖杯信息
- (void)potStartAnimationForView:(UIView *)view giftinfo:(NSDictionary *)giftinfo
{
    NSString *wavpathDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"trophy/trophyname%@/trophyvoice.wav",giftinfo[@"trophyname"]]];
    
    NSString *imgpathDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"trophy/trophyname%@/trophyimg",giftinfo[@"trophyname"]]];
    
    CGRect frame = [view convertRect:view.bounds toView:nil];

    //如果设置了自定义奖杯，需要显示自定义奖杯画面
    if (giftinfo.count>0) {
        
        NSData *imgData = [NSData dataWithContentsOfFile:imgpathDir];
        
        _giftWav = wavpathDir;
        
        // 缓存了自定义图片
        if (imgData) {
            
            UIImage *trophy = [UIImage sd_animatedGIFWithData: imgData];
            self.gifView.image = trophy;

            [[UIApplication sharedApplication].keyWindow  addSubview:_gifView];
            
            [self transformForView:_gifView
                      fromOldPoint:_gifView.layer.position
                        toNewPoint:CGPointMake(frame.origin.x + frame.size.width / 2, frame.origin.y + frame.size.height / 2)];
            
            // trophy.dure
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
//                                         (int64_t)((_gifView.image.duration+0.5) * NSEC_PER_SEC)),
//                           dispatch_get_main_queue(), ^{
//
//                               [_gifView removeFromSuperview];
//                           });
        }
        else {
            
            
            NSString *trophyimg = [TKUtil optString:giftinfo Key:@"trophyimg"];
            
            NSString *imageName = [NSString stringWithFormat:@"%@://%@:%@/%@",sHttp,sHost,sPort,trophyimg];
            
            [[TKImageLoadBit alloc] initWithUrl:imageName
                                       withType:gifImages
                                      withBlock:^(UIImage *image) {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              
                                              _iGiftAnimationView.image = image;
                                              
                                              [self transformForView:_iGiftAnimationView fromOldPoint:_iGiftAnimationView.layer.position toNewPoint:CGPointMake(frame.origin.x + frame.size.width / 2,
                                                                                                                                                                frame.origin.y + frame.size.height / 2)];
                                          });
                                      }
                               withCatheOptions:CacheOneDay];
        }

    }
    //未设置自定义奖杯使用默认设置的奖杯
    else{
        
        
        _giftWav = LOADWAV(@"trophy_tones.wav");
        
        if (!_iGiftAnimationView) {
            _iGiftAnimationView = [[UIImageView alloc] init];
            _iGiftAnimationView.frame = CGRectMake(0, 0, 100, 125);
            
            _iGiftAnimationView.center = CGPointMake(ScreenW/2, ScreenH/2);
            [[UIApplication sharedApplication].keyWindow addSubview:_iGiftAnimationView];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
//        _iGiftAnimationView.sakura.image(ThemeKP(@"giftImage"));
            _iGiftAnimationView.image = [UIImage imageNamed:@"icon_gift"];
            

        [self transformForView:_iGiftAnimationView fromOldPoint:_iGiftAnimationView.layer.position toNewPoint:CGPointMake(frame.origin.x + frame.size.width / 2, frame.origin.y + frame.size.height / 2)];
        });
    }
    
    
}

- (void)transformForView:(UIImageView *)d fromOldPoint:(CGPoint)oldPoint toNewPoint:(CGPoint)newPoint
{

    NSTimeInterval imageDuration = d.image.duration;
    if (imageDuration < 0.6) {//如果动画时间为0代表只有一个画面需要延长显示时间
        imageDuration = 0.6;
    }
    //上下移动
//    CABasicAnimation*upDownAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
//    upDownAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(oldPoint.x, oldPoint.y+20)]; // 起始点
//    upDownAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(oldPoint.x, oldPoint.y-20)]; // 终了点
//    upDownAnimation.autoreverses = YES;
//    upDownAnimation.fillMode = kCAFillModeBackwards;
//    upDownAnimation.repeatCount = 1;  //重复次数       from到to
//    upDownAnimation.duration = 0.6;    //一次时间
//    [upDownAnimation setBeginTime:0.0];
    
//    upDownAnimation.beginTime = CACurrentMediaTime() + 5;
    
    //滑动动画
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"position";
    animation.fromValue = [NSValue valueWithCGPoint:oldPoint];
    animation.toValue = [NSValue valueWithCGPoint:newPoint];
    animation.duration = 0.3;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [animation setBeginTime:imageDuration];

    // 缩放动画
    CABasicAnimation *animationScale2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    // 动画选项设定
    animationScale2.duration = 0.3; // 动画持续时间
    animationScale2.repeatCount = 1; // 重复次数
   // animationScale2.autoreverses = YES; // 动画结束时执行逆动画
    animationScale2.removedOnCompletion = NO;
    animationScale2.fillMode = kCAFillModeForwards;
    // 缩放倍数
    animationScale2.fromValue = [NSNumber numberWithFloat:2.0]; // 开始时的倍率
    animationScale2.toValue = [NSNumber numberWithFloat:0.1]; // 结束时的倍率
    [animationScale2 setBeginTime:imageDuration];
    
    // 缩放动画
    CABasicAnimation *animationScale3 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    // 动画选项设定
    animationScale3.duration = imageDuration/2.0; // 动画持续时间
    animationScale3.repeatCount = 1; // 重复次数
    // animationScale2.autoreverses = YES; // 动画结束时执行逆动画
    animationScale3.removedOnCompletion = NO;
    animationScale3.fillMode = kCAFillModeForwards;
    // 缩放倍数
    animationScale3.fromValue = [NSNumber numberWithFloat:0.1]; // 开始时的倍率
    animationScale3.toValue = [NSNumber numberWithFloat:2.0]; // 结束时的倍率
    [animationScale3 setBeginTime:0.0];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.delegate = self;
    group.duration = imageDuration+0.6;
    //group.repeatCount = 1;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    
    group.animations = [NSArray arrayWithObjects:animation,animationScale3,animationScale2, nil];
    [d.layer addAnimation:group forKey:@"move-scale-layer"];
    
    
    
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim
{
    //奖杯声音播放
    [[TKEduSessionHandle shareInstance] startPlayAudioFile:_giftWav loop:NO];
    
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    [_iGiftAnimationView removeFromSuperview];
    _iGiftAnimationView = nil;
    
    [_gifView removeFromSuperview];
    _gifView = nil;
    
    
    int currentGift = 0;
    if(_iRoomUser && _iRoomUser.properties && [_iRoomUser.properties objectForKey:sGiftNumber]){
       
        currentGift = [[_iRoomUser.properties objectForKey:sGiftNumber] intValue];
//        _iRoomUser.properties[sGiftNumber] = @(_iGiftCount);
    }
  
    [self.maskView refreshUI];
    
}


#pragma mark - TKVideoPopupMenu Delegate 实现
-(void)videoPopupMenuControlVideoOrCanDraw:(UIButton *)aButton aVideoRole:(EVideoRole)aVideoRole{
   
    [_videoPopupMenu dismiss];
    
    if ( ![_iPeerId isEqualToString:@""]) {
        // _iCurrentPeerId = _iPeerId;
        if (aVideoRole == EVideoRoleTeacher) {
            TKLog(@"关闭视频");
            PublishState tPublishState = (PublishState)_iRoomUser.publishState;
            switch (tPublishState) {
                case PublishState_VIDEOONLY:
                    tPublishState = PublishState_NONE_ONSTAGE;
                    
                    
                    break;
                case PublishState_AUDIOONLY:
                    tPublishState = PublishState_BOTH;
                    
                    break;
                case PublishState_BOTH:
                    tPublishState = PublishState_AUDIOONLY;
                    
                    break;
                case PublishState_NONE_ONSTAGE:
                    tPublishState = PublishState_VIDEOONLY;
                    
                    break;
                default:
                    break;
            }
            // iPad端老师不通过VideoEnable来开关视频，直接发publish状态改变信令
            [[TKEduSessionHandle shareInstance] sessionHandleChangeUserPublish:_iPeerId Publish:tPublishState completion:nil];
          
            aButton.selected = (tPublishState == PublishState_BOTH || tPublishState == PublishState_VIDEOONLY);
            
//            _iVideoImageView.hidden = !aButton.selected;

            
        }else{
            
            TKLog(@"授权涂鸦");
            if (_iRoomUser.publishState>1) {
                [[TKEduSessionHandle shareInstance]configureDraw:!_iRoomUser.canDraw isSend:YES to:sTellAll peerID:_iRoomUser.peerID];
                
                aButton.selected =  !_iRoomUser.canDraw;
//                _iDrawImageView.hidden = _iRoomUser.canDraw;
            }
        }
        
    }
    
    
}

-(void)videoPopupMenuControlAudioOrUnderPlatform:(UIButton *)aButton aVideoRole:(EVideoRole)aVideoRole{

    [_videoPopupMenu dismiss];
    if ( ![_iPeerId isEqualToString:@""]) {
        if (aVideoRole == EVideoRoleTeacher) {
            TKLog(@"关闭音频");
            PublishState tPublishState = (PublishState)_iRoomUser.publishState;
            switch (tPublishState) {
                case PublishState_VIDEOONLY:
                    tPublishState = PublishState_BOTH;
                    break;
                case PublishState_AUDIOONLY:
                    tPublishState = PublishState_NONE_ONSTAGE;
                    break;
                case PublishState_BOTH:
                    tPublishState = PublishState_VIDEOONLY;
                    break;
                case PublishState_NONE_ONSTAGE:
                    tPublishState = PublishState_AUDIOONLY;
                    break;
                default:
                    break;
            }
            
            // iPad端老师不通过AudioEnable来开关视频，直接发publish状态改变信令
            [_iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iPeerId Publish:tPublishState completion:nil];
            aButton.selected = !(tPublishState == PublishState_AUDIOONLY || tPublishState == PublishState_BOTH);
            //todo
//            _iAudioImageView.hidden = (_videoRole == EVideoRoleTeacher)?YES:aButton.selected;
//            _iAudioImageView.hidden = aButton.selected;
            
        }else{
            
            TKLog(@"下讲台");
            PublishState tPublishState = (PublishState)_iRoomUser.publishState;
            //BOOL isShowVideo = (tPublishState == PublishState_BOTH || tPublishState == PublishState_VIDEOONLY);
            BOOL isShowVideo = (tPublishState != PublishState_NONE);
            if (isShowVideo) {
                [_iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iPeerId Publish:PublishState_NONE completion:nil];
                // 助教始终有画笔权限
                if (_iRoomUser.role != UserType_Assistant) {
                    [[TKEduSessionHandle shareInstance]configureDraw:false isSend:true to:sTellAll peerID:_iRoomUser.peerID];
                }
                
            } else {
                [_iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iPeerId Publish:PublishState_BOTH completion:nil];
            }
            
            aButton.selected = !isShowVideo;
        }
    }
    
}
-(void)videoPopupMenuControlAudio:(UIButton *)aButton aVideoRole:(EVideoRole)aVideoRole{
    TKLog(@"关闭音频");
    
    [_videoPopupMenu dismiss];
    if (![_iPeerId isEqualToString:@""]) {
        
        BOOL isShowAudioImage = ( _iRoomUser.publishState == PublishState_AUDIOONLY || _iRoomUser.publishState== PublishState_BOTH);
        if (aVideoRole == UserType_Teacher) {
            [_iEduClassRoomSessionHandle sessionHandleEnableAudio:!isShowAudioImage];
            aButton.selected = isShowAudioImage;
            //todo
//            _iAudioImageView.hidden = (_videoRole == EVideoRoleTeacher)?YES:!aButton.selected;
//            _iAudioImageView.hidden = aButton.selected;
        }else{
            
            if (_iRoomUser.publishState == PublishState_NONE || _iRoomUser.publishState == PublishState_NONE_ONSTAGE) {
                [_iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iPeerId Publish:PublishState_AUDIOONLY completion:nil];
                aButton.selected = YES;
//                _iAudioImageView.hidden = (_videoRole == EVideoRoleTeacher)?YES:!aButton.selected;
                [_iEduClassRoomSessionHandle sessionHandleChangeUserProperty:_iRoomUser.peerID TellWhom:sTellAll Key:sRaisehand Value:@(false) completion:nil];
            }else if (_iRoomUser.publishState == PublishState_AUDIOONLY){
                // 该状态下，音视频都关闭但在台上
                [_iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iPeerId Publish:PublishState_NONE_ONSTAGE completion:nil];
                aButton.selected = NO;
//                _iAudioImageView.hidden = (_videoRole == EVideoRoleTeacher)?YES:!aButton.selected;
                
            }else if (_iRoomUser.publishState == PublishState_BOTH){
                [_iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iPeerId Publish:PublishState_VIDEOONLY completion:nil];
                aButton.selected = NO;
//                _iAudioImageView.hidden = (_videoRole == EVideoRoleTeacher)?YES:!aButton.selected;
            }else if(_iRoomUser.publishState == PublishState_VIDEOONLY){
                [_iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iPeerId Publish:PublishState_BOTH completion:nil];
                aButton.selected = YES;
//                _iAudioImageView.hidden = (_videoRole == EVideoRoleTeacher)?YES:!aButton.selected;
                [_iEduClassRoomSessionHandle sessionHandleChangeUserProperty:_iRoomUser.peerID TellWhom:sTellAll Key:sRaisehand Value:@(false) completion:nil];
            }
            
        }
        
    }
    
}

#pragma mark - 发送奖杯
-(void)videoPopupMenuSendGif:(UIButton *)aButton aVideoRole:(EVideoRole)aVideoRole{

    [_videoPopupMenu dismiss];
    
    NSArray *arr = [[[TKEduSessionHandle shareInstance].roomMgr getRoomProperty].trophy copy];
    BOOL customTrophyFlag = [[TKEduSessionHandle shareInstance].roomMgr getRoomConfigration].customTrophyFlag;
    
    TKEduSessionHandle *tSessionHandle = [TKEduSessionHandle shareInstance];
    TKEduRoomProperty *tRoomProperty = tSessionHandle.iRoomProperties;
    
    TKRoomUser *tRoomUser = _iRoomUser;
    
    // 存在自定义奖杯
    if (arr.count>1 && customTrophyFlag) {
        
        UIView *whiteBoardView = [TKEduSessionHandle shareInstance].whiteboardView;
        
        // 白板尺寸
        CGRect wbRect = [whiteBoardView convertRect:whiteBoardView.bounds toView:[UIApplication sharedApplication].keyWindow];
        
        CGFloat wbHeight = wbRect.size.height;
        CGFloat wbWidth  = wbRect.size.width;
        
        // 白板 中心点
        CGPoint relyPoint = CGPointMake(wbRect.origin.x + wbWidth / 2, wbRect.origin.y + wbHeight/2);
        
        // 自定义奖杯弹框： 宽 5/10
        CGFloat trophyW = wbWidth * 0.45;
//        CGFloat trophyH = wbHeight * (9/10.0);
        // 高 9/10(改： 根据按钮数量给高度)
        CGFloat trophyH = trophyW / 3 ;
        trophyH = (arr.count / 5 + 1) * trophyH + 20;
        
        CGFloat trophyX = relyPoint.x - trophyW/2;
        CGFloat trophyY = relyPoint.y - trophyH/2;
        
        _trophyView =[[TKTrophyView alloc]initWithFrame:CGRectMake(trophyX, trophyY, trophyW, trophyH) chatController:@"TKOneToMoreRoomController"];
        
        [_trophyView showOnView:self trophyMessage:arr];
        
        __weak typeof(self)weakSelf = self;
        _trophyView.sendTrophy = ^(NSDictionary *message) {


            [TKEduNetManager sendGifForRoomUser:@[tRoomUser] roomID:tRoomProperty.iRoomId  aMySelf:tSessionHandle.roomMgr.localUser aHost:tRoomProperty.sWebIp aPort:tRoomProperty.sWebPort aSendComplete:^(id  _Nullable response) {
                __strong typeof(self)strongSelf = weakSelf;

                int currentGift = 0;

                if(tRoomUser && tRoomUser.properties && [tRoomUser.properties objectForKey:sGiftNumber]){

                    currentGift = [[_iRoomUser.properties objectForKey:sGiftNumber] intValue];


                }


                NSDictionary *dict = @{
                                       @"giftnumber":@(currentGift + 1),
                                       @"giftinfo":message,
                                       };


                [strongSelf->_iEduClassRoomSessionHandle sessionHandleChangeUserProperty:strongSelf->_iRoomUser.peerID
                                                                                TellWhom:sTellAll
                                                                                    data:dict
                                                                              completion:nil];



//                [strongSelf potStartAnimationForView:strongSelf giftinfo:message];

            }aNetError:nil];

        };

        return;
    }
    
    if (![_iPeerId isEqualToString:@""]) {
        
        [TKEduNetManager sendGifForRoomUser:@[tRoomUser] roomID:tRoomProperty.iRoomId  aMySelf:tSessionHandle.roomMgr.localUser aHost:tRoomProperty.sWebIp aPort:tRoomProperty.sWebPort aSendComplete:^(id  _Nullable response) {
            int currentGift = 0;
            NSDictionary *giftInfo;
            if(tRoomUser && tRoomUser.properties && [tRoomUser.properties objectForKey:sGiftNumber])
            {
                
                
                currentGift = [[_iRoomUser.properties objectForKey:sGiftNumber] intValue];
                giftInfo = [NSDictionary dictionaryWithDictionary:[TKUtil getDictionaryFromDic:_iRoomUser.properties Key:sGiftinfo]];
               
            }
            
            [_iEduClassRoomSessionHandle sessionHandleChangeUserProperty:_iRoomUser.peerID TellWhom:sTellAll Key:sGiftNumber Value:@(currentGift + 1) completion:nil];
//            [strongSelf potStartAnimationForView:strongSelf giftinfo:giftInfo];


        }aNetError:nil];
        TKLog(@"发奖励");
    }
    
}
-(void)videoPopupMenuControlVideo:(UIButton *)aButton aVideoRole:(EVideoRole)aVideoRole{
    TKLog(@"关闭视频");
    
    [_videoPopupMenu dismiss];
    if (![_iPeerId isEqualToString:@""]) {
        
        //_iCurrentPeerId = _iPeerId;
        BOOL isShowVideoImage = ( _iRoomUser.publishState == PublishState_VIDEOONLY || _iRoomUser.publishState== PublishState_BOTH);
        if (aVideoRole == UserType_Teacher) {
            [_iEduClassRoomSessionHandle sessionHandleEnableAudio:!isShowVideoImage];
            aButton.selected = isShowVideoImage;
//            _iVideoImageView.hidden = !aButton.selected;
        }else{
            
            if (_iRoomUser.publishState == PublishState_NONE || _iRoomUser.publishState == PublishState_NONE_ONSTAGE) {
                [_iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iPeerId Publish:PublishState_VIDEOONLY completion:nil];
                aButton.selected = YES;
//                _iVideoImageView.hidden = !aButton.selected;
                [_iEduClassRoomSessionHandle sessionHandleChangeUserProperty:_iRoomUser.peerID TellWhom:sTellAll Key:sRaisehand Value:@(false) completion:nil];
            }else if (_iRoomUser.publishState == PublishState_VIDEOONLY){
                // 这种情况下音视频都关闭，但还在台上
                [_iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iPeerId Publish:PublishState_NONE_ONSTAGE completion:nil];
                aButton.selected = NO;
//                _iVideoImageView.hidden = !aButton.selected;
                
            }else if (_iRoomUser.publishState == PublishState_BOTH){
                [_iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iPeerId Publish:PublishState_AUDIOONLY completion:nil];
                aButton.selected = NO;
//                _iVideoImageView.hidden = !aButton.selected;
            }else if(_iRoomUser.publishState == PublishState_AUDIOONLY){
                [_iEduClassRoomSessionHandle sessionHandleChangeUserPublish:_iPeerId Publish:PublishState_BOTH completion:nil];
                aButton.selected = YES;
//                _iVideoImageView.hidden = !aButton.selected;
                [_iEduClassRoomSessionHandle sessionHandleChangeUserProperty:_iRoomUser.peerID TellWhom:sTellAll Key:sRaisehand Value:@(false) completion:nil];
            }
            
        }
        
      
        
    }
}
-(void)videoSplitScreenVideo:(UIButton *)aButton aVideoRole:(EVideoRole)aVideoRole{//分屏显示

    [_videoPopupMenu dismiss];
    if (self.splitScreenClickBlock) {
        
        self.splitScreenClickBlock(aVideoRole);
        
    }
}


#pragma mark private


- (UIView *)sIsInBackGroundView{
    if (!_sIsInBackGroundView) {
//        self.sIsInBackGroundView = [[[NSBundle mainBundle]loadNibNamed:@"TKBackGroundView" owner:nil options:nil] lastObject];
        
        self.sIsInBackGroundView = [[TKBackGroundView alloc]init];
        self.sIsInBackGroundView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self setBackgroundLabelContent];
    }
    [self setBackgroundLabelContent];
    return _sIsInBackGroundView;
}

- (void)setBackgroundLabelContent {
    if (_iRoomUser.role == UserType_Student) {
        [_sIsInBackGroundView setContent:MTLocalized(@"State.isInBackGround")];
    }
    if (_iRoomUser.role == UserType_Teacher) {
        [_sIsInBackGroundView setContent:MTLocalized(@"State.teacherInBackGround")];
    }
}



- (void)setIVideoViewTag:(NSInteger)iVideoViewTag{
    _iVideoViewTag = iVideoViewTag;
    _maskView.iVideoViewTag = iVideoViewTag;
}

- (void)showMaskView : (BOOL)isShow {
    
    _maskView.hidden = isShow;

}
#pragma mark - 懒加载
- (UIImageView *)gifView {
    if (!_gifView) {
        
        _gifView = [[UIImageView alloc] init];
        _gifView.width = 100;
        _gifView.height = 125;
        _gifView.center = CGPointMake(ScreenW/2, ScreenH/2);
    }
    
    return _gifView;
}
@end
