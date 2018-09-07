//
//  TKBaseMediaView.m
//  EduClassPad
//
//  Created by ifeng on 2017/8/29.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "TKBaseMediaView.h"
#import "TKProgressSlider.h"
#import "TKEduSessionHandle.h"
#import "TKUtil.h"
#import <UIImage+GIF.h>

#define ThemePBKP(args) [@"ClassRoom.PlayBack." stringByAppendingString:args]
#define ThemeKP(args) [@"ClassRoom.TKMediaView." stringByAppendingString:args]
@interface TKBaseMediaView () <UIScrollViewDelegate>

@property (nonatomic, strong) NSString *peerId;//用户id
@property (nonatomic, strong) UIView *bview;//背景视图
@property (nonatomic, strong) UIView *bottmView;//底部视图
@property (nonatomic, strong) UIButton *backButton;//关闭按钮
@property (nonatomic, strong) UIButton *playButton;//播放按钮
@property (nonatomic, strong) UILabel *titleLabel;//标题名称
@property (nonatomic, strong) UILabel *timeLabel;//时间
@property (nonatomic, strong) TKProgressSlider *iProgressSlider;//播放进度条
@property (nonatomic, strong) UIButton         *iAudioButton;//声音图标
@property (nonatomic, strong) TKProgressSlider *iAudioslider;//音量进度条


@property (nonatomic, strong) UIImageView *GIFImageView;//动画视图

@property (nonatomic, strong) UIView *iVideoBoardView;//视频标注视图
@property (nonatomic, strong) UIImageView *loadingView;//loading加载页面
@property (nonatomic, strong) UIView *loadBackgroundView;//loading加载背景
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) NSTimeInterval lastTime;
@property (nonatomic, assign) NSTimeInterval lastSyncTime;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) BOOL iIsPlay;
@property (nonatomic, assign) BOOL isPlayEnd;

@property (nonatomic, assign) BOOL isFileShare;//是否是电影共享
@property (nonatomic, assign) BOOL isPlay;//是否播放状态
@property (nonatomic, assign) NSInteger width;//视频显示的原始宽度
@property (nonatomic, assign) NSInteger height;//视频显示的原始高度
@property (nonatomic, strong) NSString *filename;


@property (nonatomic, strong) NSTimer *timer;//定时器
@property (nonatomic, assign) int timerCount;
@property (nonatomic) BOOL isSliding; // 是否在拖拽
@end

@implementation TKBaseMediaView

//创建timer
- (void)creatTimer{
    _timerCount = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(timerFire) userInfo:nil repeats:true];
    [_timer setFireDate:[NSDate date]];
}
-(void)timerFire{
    _timerCount++;
    if (_timerCount>8) {
        //隐藏控件
//        self.backButton.hidden = YES;
        self.bottmView.hidden = YES;
        self.bview.hidden = YES;
        [_timer setFireDate:[NSDate distantFuture]];
    }
    
}
- (void)resetTimer{
    //显示控件
//    self.backButton.hidden = NO;
    self.bottmView.hidden = NO;
    self.bview.hidden = NO;
    _timerCount = 0;
    [_timer setFireDate:[NSDate date]];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_timer) {
        [self resetTimer];
    }
}


- (instancetype)initWithMediaPeerID:(NSString *)peerId
                   extensionMessage:(NSDictionary *)extensionMessage
                              frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _peerId = peerId;
        _isFileShare = false;
        
        _isPlayEnd      = NO;
        self.isSliding = NO;
        self.width = [TKUtil getIntegerValueFromDic:extensionMessage Key:@"width"];
        self.height = [TKUtil getIntegerValueFromDic:extensionMessage Key:@"height"];
        self.isPlay = ![TKUtil getBOOValueFromDic:extensionMessage Key:@"pause"];
        self.hasVideo = [TKUtil getBOOValueFromDic:extensionMessage Key:@"video"];
        self.filename = [TKUtil optString:extensionMessage Key:@"filename"];
        _duration       = [TKUtil getIntegerValueFromDic:extensionMessage Key:@"duration"];
        [TKEduSessionHandle shareInstance].isPlayMedia = YES;
        
        
        [[NSNotificationCenter defaultCenter]postNotificationName:sTapTableNotification object:nil];
        if (self.hasVideo) {
            [self ac_initVideoSubviews:frame];
            
            [self creatTimer];
            
            //开启视频标注配置项后允许加载白板
            if ([[TKEduSessionHandle shareInstance].roomMgr getRoomConfigration].videoWhiteboardFlag) {
                
                [self ac_initWhiteBoard:TKWBVideoDrawWhiteboardComponent];
            }
            
        }else{
            [self ac_initAudioSubviews:frame];
        }
        
        [[NSNotificationCenter defaultCenter]removeObserver:self];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(unPluggingHeadSet:) name:sUnunpluggingHeadsetNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pluggInMicrophone:) name:sPluggInMicrophoneNotification object:nil];
        
    }
    return self;
}
- (void)ac_initWhiteBoard:(NSString *)type{
    
//    return;
    
    UIView *tVideoBoardView = [[TKEduSessionHandle shareInstance].whiteBoardManager createVideoBoardWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) loadComponentName:type loadFinishedBlock:^{
        
        
        [[TKEduSessionHandle shareInstance].whiteBoardManager updateWebAddressInfo];
        
        [[TKEduSessionHandle shareInstance].whiteBoardManager sendCacheInformation:[TKEduSessionHandle shareInstance].msgList];
        
        if ([TKEduSessionHandle shareInstance].localUser.role == UserType_Teacher && [TKEduSessionHandle shareInstance].videoRatio) {
            
            [TKEduSessionHandle shareInstance].videoRatio = @(self.width*1.0/self.height);
           
        }
        
    }];
    
    self.iVideoBoardView = tVideoBoardView;
    self.iVideoBoardView.backgroundColor = [UIColor clearColor];
    self.iVideoBoardView.hidden = YES;
    [self addSubview:self.iVideoBoardView];
    
}

- (instancetype)initScreenShare:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _isFileShare = false;
        self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
        self.scrollView.delegate = self;
        self.scrollView.backgroundColor = [UIColor blackColor];
        self.scrollView.maximumZoomScale = 4.0;
        
        [self addSubview:self.scrollView];
        //开启视频标注配置项后允许加载白板
        if ([[TKEduSessionHandle shareInstance].roomMgr getRoomConfigration].videoWhiteboardFlag) {
            
            [self ac_initWhiteBoard:TKWBVideoDrawWhiteboardComponent];
        }
        
        [[NSNotificationCenter defaultCenter]postNotificationName:sTapTableNotification object:nil];
        //[self ac_initVideoSubviews];
        [[NSNotificationCenter defaultCenter]removeObserver:self];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(unPluggingHeadSet:) name:sUnunpluggingHeadsetNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pluggInMicrophone:) name:sPluggInMicrophoneNotification object:nil];
    }
    return self;
}

- (instancetype)initFileShare:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _isFileShare = true;
        [self ac_initVideoSubviews:frame];
        //开启视频标注配置项后允许加载白板
        if ([[TKEduSessionHandle shareInstance].roomMgr getRoomConfigration].videoWhiteboardFlag) {
            
            [self ac_initWhiteBoard:TKWBLocalFileVideoDrawWhiteboardComponent];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:sTapTableNotification object:nil];
        [[NSNotificationCenter defaultCenter]removeObserver:self];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(unPluggingHeadSet:) name:sUnunpluggingHeadsetNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pluggInMicrophone:) name:sPluggInMicrophoneNotification object:nil];
    }
    return self;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return scrollView.subviews.firstObject;
}

- (void)insertViewToScrollView:(UIView *)view {
    [self.scrollView insertSubview:view atIndex:0];
}

-(void)unPluggingHeadSet:(NSNotification *)notifi{
    
    [self audioVolum: [TKEduSessionHandle shareInstance].iVolume];
}

-(void)pluggInMicrophone:(NSNotification *)notifi{
    [self audioVolum: [TKEduSessionHandle shareInstance].iVolume];
}

-(void)dealloc{
    if (_loadingView && _loadingView.isAnimating) {
        [_loadingView stopAnimating];
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

// 添加view，子类实现
- (void)ac_initAudioSubviews:(CGRect)frame {
    
    //播放动画
    self.GIFImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.height)];
    [self addSubview:self.GIFImageView];
    [self bringSubviewToFront:self.GIFImageView];
    self.GIFImageView.sakura.image(ThemeKP(@"mp3playerDefaultImage"));

    if (self.isPlay) {
        [self.GIFImageView playGifAnim:[TKHelperUtil mp3PlayGif]];
    }
    
    //播放按钮 更改状态用
//    self.playButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 0, 1, 1)];
//    self.playButton.sakura.image(ThemePBKP(@"playBtnPauseImage"),UIControlStateSelected);
//    self.playButton.sakura.image(ThemePBKP(@"playBtnPlayImage"),UIControlStateNormal);
//
//    [self.playButton addTarget:self action:@selector(audioPlayOrPauseAction:) forControlEvents:UIControlEventTouchUpInside];
//
//    self.playButton.selected = self.isPlay;
    
    
    if ([TKEduSessionHandle shareInstance].localUser.role== UserType_Patrol || [TKEduSessionHandle shareInstance].localUser.role== UserType_Student || ([TKEduSessionHandle shareInstance].localUser.role==UserType_Playback)) {
        
        return;
    }
    
    //bottomBar
    self.bview = ({
        UIView *bview = [[UIView alloc] initWithFrame:CGRectMake(30, 8, frame.size.width-40, frame.size.height-16)];
        bview.layer.masksToBounds = YES;
        bview.layer.cornerRadius = (frame.size.height-16)/2.0;
        bview.sakura.backgroundColor(ThemePBKP(@"sliderBackGoundColor"));
        bview.sakura.alpha(ThemePBKP(@"sliderAlpha"));
        [self addSubview:bview];
        [self sendSubviewToBack:bview];
        bview;
    });
    

    //返回按钮
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-40, (frame.size.height-30)/2, 30, 30)];
    self.backButton.sakura.image(ThemeKP(@"mp3player_close"),UIControlStateNormal);
    [self.backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.backButton];

    //播放按钮
    self.playButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.height+20, (frame.size.height-30)/2.0, 30, 30)];
    self.playButton.sakura.image(ThemePBKP(@"playBtnPauseImage"),UIControlStateSelected);
    self.playButton.sakura.image(ThemePBKP(@"playBtnPlayImage"),UIControlStateNormal);
    [self.playButton addTarget:self action:@selector(audioPlayOrPauseAction:) forControlEvents:UIControlEventTouchDown];
    self.playButton.selected = self.isPlay;;
    [self addSubview:self.playButton];

    //名称
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.playButton.frame)+20, 5, 315, 25)];
    self.titleLabel.text = self.filename;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.titleLabel];

    
    //声道滑块
    self.iAudioslider = [[TKProgressSlider alloc] initWithFrame:CGRectMake(self.backButton.x - frame.size.width*0.12-15,
                                                                           8,
                                                                           frame.size.width*0.12,
                                                                           frame.size.height-16)];
//    [[TKProgressSlider alloc] initWithFrame:CGRectMake(CGRectGetMinX(backButton.frame)-frame.size.width*0.12-15, 25, frame.size.width*0.12, 25)];
    self.iAudioslider.sakura.minimumTrackTintColor(ThemePBKP(@"sliderMinimumTrackTintColor"));
    self.iAudioslider.sakura.maximumTrackTintColor(ThemePBKP(@"sliderMaximumTrackTintColor"));
    [self.iAudioslider setThumbImage:[TKTheme imageWithPath:ThemePBKP(@"sliderControlImage")] forState:UIControlStateNormal];

    self.iAudioslider.enabled = YES;
    self.iAudioslider.value = 1;
    [self.iAudioslider addTarget:self action:@selector(audioVolumChange:) forControlEvents:UIControlEventValueChanged];
    //    [self addSubview:selflignment = NSTextAlignmentLeft;
    [self addSubview:self.iAudioslider];
    
    // 声音开关按钮
    self.iAudioButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.iAudioslider.frame)-40, (frame.size.height-40)/2.0, 40, 40)];
    self.iAudioButton.sakura.image(ThemePBKP(@"voiceBtnSelectedImage"),UIControlStateSelected);
    self.iAudioButton.sakura.image(ThemePBKP(@"voiceBtnNormalImage"),UIControlStateNormal);
    self.iAudioButton.imageView.contentMode = UIViewContentModeCenter;
    [self.iAudioButton addTarget:self action:@selector(audioButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.iAudioButton];
    
    // 进度拖拽滑块
    self.iProgressSlider = [[TKProgressSlider alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.playButton.frame)+20, 30, CGRectGetMinX(self.iAudioButton.frame)-(CGRectGetMaxX(self.playButton.frame)+20)-10, 25)];
    self.iProgressSlider.sakura.minimumTrackTintColor(ThemePBKP(@"sliderMinimumTrackTintColor"));
    self.iProgressSlider.sakura.maximumTrackTintColor(ThemePBKP(@"sliderMaximumTrackTintColor"));
    self.iProgressSlider.continuous = NO;
    [self.iProgressSlider setThumbImage:[TKTheme imageWithPath:ThemePBKP(@"sliderControlImage")]  forState:UIControlStateNormal];
    
    [self addSubview:self.iProgressSlider];
    
    [self.iProgressSlider addTarget:self action:@selector(progressValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.iProgressSlider addTarget:self action:@selector(progressTouchDown:) forControlEvents:UIControlEventTouchDown];

    //时间
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iProgressSlider.frame)-110, 5, 110, 25)];
    self.timeLabel.text = @"00:00/00:00";
    self.titleLabel.font = self.timeLabel.font = TKFont(12);
    self.titleLabel.textColor = self.timeLabel.textColor = [UIColor whiteColor];
    //    self.timeLabel.textA.timeLabel];
    CGSize size = CGSizeMake(1000,10000);
    //计算实际frame大小，并将label的frame变成实际大小
    NSDictionary *attribute = @{NSFontAttributeName:self.timeLabel.font};
    CGSize labelsize = [self.timeLabel.text boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.iProgressSlider.frame)-110, 5, labelsize.width+10, 25);
    [self addSubview:self.timeLabel];
    
}
- (void)loadLoadingView{
    
    UIImage *img = [TKTheme imageWithPath:ThemeKP(@"loading_00011")];
    
    CGFloat scale = img.size.width / img.size.height;
    
    CGFloat loadWidth = scale * ScreenH;
    if (loadWidth>ScreenW) {
        loadWidth = ScreenW;
    }
    CGFloat loadHeight = loadWidth /scale;
    
    _loadBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    _loadBackgroundView.sakura.backgroundColor(ThemeKP(@"mp4loadingBackgroundColor"));
    [self addSubview:_loadBackgroundView];
    
    _loadingView = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenW-loadWidth)/2.0,(ScreenH-loadHeight)/2.0, loadWidth, loadHeight)];
    [self addSubview:_loadingView];
    [self bringSubviewToFront:_loadingView];
    [_loadingView playGifAnim:[TKHelperUtil mp4PlayGif]];

    [_loadBackgroundView addSubview:_loadingView];
    
    [self bringSubviewToFront:_backButton];
    
}


- (void)ac_initVideoSubviews:(CGRect)frame
{
    
    if ([TKEduSessionHandle shareInstance].localUser.role== UserType_Patrol || [TKEduSessionHandle shareInstance].localUser.role== UserType_Student || ([TKEduSessionHandle shareInstance].localUser.role==UserType_Playback)) {
        //播放按钮
        self.playButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 0, 1, 1)];
        [self.playButton setImage:LOADIMAGE(@"playBtn") forState:UIControlStateNormal];
        [self.playButton setImage:LOADIMAGE(@"pauseBtn") forState:UIControlStateSelected];
        [self.playButton addTarget:self action:@selector(playOrPauseAction:) forControlEvents:UIControlEventTouchUpInside];
        self.playButton.selected = self.isPlay;
        
        return;
    }
    
    //返回按钮
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW-60, 10, 50, 50)];
    self.backButton.sakura.image(ThemeKP(@"btn_closed_normal"),UIControlStateNormal);
    [self.backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.backButton];
    
    CGFloat tBottmViewWH = 70;
    CGFloat tViewCap = 8;
    //bottonBar
    self.bview = ({
        UIView *bview = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH-tBottmViewWH+(tBottmViewWH-44)/2, ScreenW, 44)];
        bview.layer.masksToBounds = YES;
        bview.layer.cornerRadius = 22;
        bview.sakura.backgroundColor(ThemePBKP(@"sliderBackGoundColor"));
        bview.sakura.alpha(ThemePBKP(@"sliderAlpha"));
        [self addSubview:bview];
        bview;
        
    });
    
    self.bottmView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH-tBottmViewWH, ScreenW, tBottmViewWH)];
    self.bottmView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bottmView];
    
    //播放按钮
    self.playButton = [[UIButton alloc] initWithFrame:CGRectMake(tViewCap, 0, tBottmViewWH, tBottmViewWH)];
    self.playButton.sakura.image(ThemePBKP(@"playBtnPauseImage"),UIControlStateSelected);
    self.playButton.sakura.image(ThemePBKP(@"playBtnPlayImage"),UIControlStateNormal);
    
    [self.playButton addTarget:self action:@selector(playOrPauseAction:) forControlEvents:UIControlEventTouchUpInside];
    self.playButton.selected = self.isPlay;;
    [self.bottmView addSubview:self.playButton];
    
    //声道滑块
    CGFloat tAudiosliderWidth = 107;
//    self.iAudioslider = [[TKProgressSlider alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bottmView.frame)-tAudiosliderWidth-tViewCap,(CGRectGetHeight(self.bottmView.frame)-5)/2 , tAudiosliderWidth, CGRectGetHeight(self.bottmView.frame))];
    self.iAudioslider = [[TKProgressSlider alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.bottmView.frame)-
                                                                           tAudiosliderWidth-tViewCap,
                                                                           0,
                                                                           tAudiosliderWidth,
                                                                           tBottmViewWH)];
    self.iAudioslider.sakura.minimumTrackTintColor(ThemePBKP(@"sliderMinimumTrackTintColor"));
    self.iAudioslider.sakura.maximumTrackTintColor(ThemePBKP(@"sliderMaximumTrackTintColor"));
    [self.iAudioslider setThumbImage:[TKTheme imageWithPath:ThemePBKP(@"sliderControlImage")] forState:UIControlStateNormal];

    self.iAudioslider.enabled = YES;
    self.iAudioslider.value = 1;
    [self.iAudioslider addTarget:self action:@selector(audioVolumChange:) forControlEvents:UIControlEventValueChanged];
    [self.bottmView addSubview:self.iAudioslider];
    
    //声音按钮
    self.iAudioButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.iAudioslider.frame)-40,(self.bottmView.height-40)/2, 40, 40)];
    self.iAudioButton.sakura.image(ThemePBKP(@"voiceBtnNormalImage"),UIControlStateNormal);
    self.iAudioButton.sakura.image(ThemePBKP(@"voiceBtnSelectedImage"),UIControlStateSelected);
    self.iAudioButton.imageView.contentMode = UIViewContentModeCenter;
    [self.iAudioButton addTarget:self action:@selector(audioButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottmView addSubview:self.iAudioButton];
    
    CGFloat tProgressSliderW = CGRectGetWidth(self.bottmView.frame) - CGRectGetMaxX(self.playButton.frame)-(CGRectGetWidth(self.bottmView.frame)-CGRectGetMinX(self.iAudioButton.frame))-tViewCap-70*Proportion;
    //进度滑块
    self.iProgressSlider = [[TKProgressSlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.playButton.frame), 35, tProgressSliderW, 25)];
    self.iProgressSlider.continuous = NO;
//     [[TKProgressSlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.playButton.frame)+tViewCap, 40, tProgressSliderW, 25)];
    self.iProgressSlider.sakura.minimumTrackTintColor(ThemePBKP(@"sliderMinimumTrackTintColor"));
    self.iProgressSlider.sakura.maximumTrackTintColor(ThemePBKP(@"sliderMaximumTrackTintColor"));

    [self.iProgressSlider setThumbImage:[TKTheme imageWithPath:ThemePBKP(@"sliderControlImage")] forState:UIControlStateNormal];
   
    [self.iProgressSlider addTarget:self action:@selector(progressValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.iProgressSlider addTarget:self action:@selector(progressTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.bottmView addSubview:self.iProgressSlider];
    //时间
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 100, 25)];
    self.timeLabel.text = @"00:00/00:00";
    self.titleLabel.font = TKFont(12);
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    [self.bottmView addSubview:self.timeLabel];
    
    CGSize size = CGSizeMake(1000,10000);
    //计算实际frame大小，并将label的frame变成实际大小
    NSDictionary *attribute = @{NSFontAttributeName:self.timeLabel.font};
    CGSize labelsize = [self.timeLabel.text boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.iProgressSlider.frame)- labelsize.width-10, 15, labelsize.width+10, labelsize.height);
    //名称
    self.titleLabel      = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.playButton.frame)+tViewCap, 15, tProgressSliderW- labelsize.width-10, 25)];
    self.titleLabel.text = self.filename;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.bottmView addSubview:self.titleLabel];
   
    self.titleLabel.font = self.timeLabel.font = TKFont(12);
    
    self.titleLabel.textColor = self.timeLabel.textColor = [UIColor whiteColor];
}
#pragma mark - 响应事件
// 点击退出
- (void)backAction:(UIButton *)button {
    
    [TKEduSessionHandle shareInstance].isPlayMedia          = NO;
    [[TKEduSessionHandle shareInstance]sessionHandleUnpublishMedia:nil];
    
}
#pragma mark - 播放 & 暂停
- (void)audioPlayOrPauseAction:(UIButton *)sender{
    
    BOOL start = !sender.selected;
    [self playAction:start hasVideo:false];
}

- (void)playOrPauseAction:(UIButton *)sender {
    
    [self playAction:!sender.selected hasVideo:true];
}

- (void)playAction:(BOOL)start hasVideo:(BOOL)hasVideo{
    
    if (self.playButton.selected == start) {
        return;
    }
    if (start) {
        [TKEduSessionHandle shareInstance].msgList = nil;
    }else{
        if ([TKEduSessionHandle shareInstance].localUser.role == UserType_Teacher && self.hasVideo &&[TKEduSessionHandle shareInstance].isClassBegin) {
            
            
            NSString *str = [TKUtil dictionaryToJSONString:@{@"videoRatio":@(self.width*1.0/self.height)}];
            
            [[TKEduSessionHandle shareInstance] sessionHandlePubMsg:sVideoWhiteboard ID:sVideoWhiteboard To:sTellAll Data:str Save:true AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
            
        }
    }
    if (!hasVideo) {
        if (start) {
            [self.GIFImageView playGifAnim:[TKHelperUtil mp3PlayGif]];
        }else{
            [self.GIFImageView stopGifAnim];
        }
    }
    [[TKEduSessionHandle shareInstance] sessionHandleMediaPause:!start];
    [[TKEduSessionHandle shareInstance] configurePlayerRoute:NO isCancle:NO];
    
    
    if ([[TKEduSessionHandle shareInstance].roomMgr getRoomConfigration].videoWhiteboardFlag && [TKEduSessionHandle shareInstance].isClassBegin) {
        
        [self refreshVideoWhiteBoard:start];
    }
    
}
- (void)refreshVideoWhiteBoard:(BOOL)start{
    if (start) {//加载白板
        if ([TKEduSessionHandle shareInstance].localUser.role == UserType_Teacher) {
            [[TKEduSessionHandle shareInstance] sessionHandleDelMsg:sVideoWhiteboard ID:sVideoWhiteboard To:sTellAll Data:@{} completion:nil];
        }
    }
}


- (void)loadWhiteBoard{
    
//    return;
    
    self.iVideoBoardView.hidden = NO;
    
    NSString *videoType;
    //判断是播放的媒体还是电影
    if (self.isFileShare) {
        videoType = @"fileVideo";
    }else{
        videoType = @"mediaVideo";
    }
    
    [self bringSubviewToFront:self.iVideoBoardView];
}

- (void)hiddenVideoWhiteBoard{
    
    self.iVideoBoardView.hidden = YES;
    
    
}

- (void)deleteWhiteBoard{
    
    if (self.iVideoBoardView) {
        
        [[TKEduSessionHandle shareInstance].whiteBoardManager deleteView:TKWBVideoDrawWhiteboardComponent];
        [self.iVideoBoardView removeFromSuperview];
        self.iVideoBoardView = nil;
        
    }
}

#pragma mark - 播放进度滑块
- (void)progressValueChange:(TKProgressSlider *)slider {
    self.isSliding = NO;
    NSTimeInterval pos = self.iProgressSlider.value * self.duration;
    [self seekProgressToPos:pos];
    
}
// 播放进度滑块
- (void)progressTouchDown:(TKProgressSlider *)slider {
    
    self.isSliding = YES;
    
}
-(void)seekProgressToPos:(NSTimeInterval)value{
    [[TKEduSessionHandle shareInstance] sessionHandleMediaSeektoPos:value];
}

// 声音开关
-(void)audioButtonClicked:(UIButton *)aButton{
    
    BOOL tBtnSlct                   = self.iAudioslider.value ?NO:YES;
    aButton.selected                = !tBtnSlct;
    CGFloat tVolume                 = aButton.selected ? 0 : 1;
    
    [TKEduSessionHandle shareInstance].iVolume  = tVolume;
    self.iAudioslider.value = tVolume;
    [[TKEduSessionHandle shareInstance] sessionHandleSetRemoteAudioVolume:tVolume peerId:_peerId type:(TKMediaSourceType_media)];
    
}


// 音量大小滑块
- (void)audioVolumChange:(TKProgressSlider *)slider {
    
    [self audioVolum:slider.value];
    
}

-(void)audioVolum:(CGFloat)volum{
    
    _iAudioButton.selected = (volum==0);
    [TKEduSessionHandle shareInstance].iVolume = volum;
    [[TKEduSessionHandle shareInstance]sessionHandleSetRemoteAudioVolume:volum*10 peerId:_peerId type:(TKMediaSourceType_media)];
    self.iAudioslider.value = volum;
}

#pragma mark - 更新页面
-(void)updatePlayUI:(BOOL)start{
    
    if (self.playButton.selected == start && [TKEduSessionHandle shareInstance].localUser.role==UserType_Teacher) {
        return;
    }
    //学生 巡课 的时候
    if (([TKEduSessionHandle shareInstance].localUser.role==UserType_Student) ||([TKEduSessionHandle shareInstance].localUser.role==UserType_Patrol)) {
        if (start ) {
            
            [self.GIFImageView playGifAnim:[TKHelperUtil mp3PlayGif]];
        }else{
            [self.GIFImageView stopGifAnim];
            
        }
        
        
    }
    self.playButton.selected = start;
    self.iIsPlay = start;
    
    //    if ([[TKEduSessionHandle shareInstance].roomMgr getRoomConfigration].videoWhiteboardFlag) {
    //        if (start) {
    //            self.backButton.hidden = NO;
    //        }else{
    //            self.backButton.hidden = YES;
    //        }
    //    }
    [self bringSubviewToFront:self.backButton];
}
- (void)update:(NSTimeInterval)current total:(NSTimeInterval)total
{
    if ((current == 0 && self.hasVideo == NO) || self.isSliding == YES) {
        return;
    }
    //如果用户在手动滑动滑块，则不对滑块的进度进行设置重绘
//    if (!self.iProgressSlider.isSliding) {
        self.iProgressSlider.value = current/total;
//    }
    
    if (current!=self.lastTime) {
        self.timeLabel.text = [NSString stringWithFormat:@"%@/%@", [self formatPlayTime:current/1000], isnan(total)?@"00:00":[self formatPlayTime:total/1000]];
    }
    
    self.lastTime = current;
    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
    if(now - self.lastSyncTime > 1) {
        self.lastSyncTime = now;
    }
}

- (NSString *)formatPlayTime:(NSTimeInterval)duration {
    int minute = 0, hour = 0, secend = duration;
    minute = (secend % 3600)/60;
    hour = secend / 3600;
    secend = secend % 60;
//    return [NSString stringWithFormat:@"%02d:%02d", minute, secend];
    if (hour > 0) {
        return [NSString stringWithFormat:@"%02d:%02d:%02d",hour, minute, secend];
    }
    return [NSString stringWithFormat:@"%02d:%02d", minute, secend];
}

- (void)hiddenLoadingView
{
    if (_loadingView) {
        [_loadingView stopGifAnim];
        
        [_loadBackgroundView removeFromSuperview];
        [_loadingView removeFromSuperview];
        _loadingView = nil;
        
        _loadBackgroundView  = nil;
    }
}
- (void)setVideoViewToBack
{
    if (self.hasVideo) {
        if (self.bview) {
            [self bringSubviewToFront:self.bview];
        }
        if (self.backButton) {
            [self bringSubviewToFront:self.backButton];
        }
        if (self.bottmView) {
            [self bringSubviewToFront:self.bottmView];
        }
    } else {
        if (self.backButton) {
            [self bringSubviewToFront:self.backButton];
        }
        if (self.playButton) {
            [self bringSubviewToFront:self.playButton];
        }
        if (self.titleLabel) {
            [self bringSubviewToFront:self.titleLabel];
        }
        if (self.timeLabel) {
            [self bringSubviewToFront:self.timeLabel];
        }
        if (self.iProgressSlider) {
            [self bringSubviewToFront:self.iProgressSlider];
        }
        if (self.iAudioButton) {
            [self bringSubviewToFront:self.iAudioButton];
        }
        if (self.iAudioslider) {
            [self bringSubviewToFront:self.iAudioslider];
        }
        
    }
}


@end
