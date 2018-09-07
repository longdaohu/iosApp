//
//  TKMaskView.m
//  EduClass
//
//  Created by lyy on 2018/4/24.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import "TKOldMaskView.h"
#import "TKTurnOffCameraView.h"
#import "TKBackGroundView.h"
#import "TKEduSessionHandle.h"
#import "TKEduRoomProperty.h"

#define ThemeKP(args) [@"ClassRoom.TKVideoView." stringByAppendingString:args]

@interface TKOldMaskView()
@property (nonatomic, assign) EVideoRole videoRole;
@property (nonatomic, strong) UIView *toolView;

@property (nonatomic, strong) TKTurnOffCameraView *turnOffCameraView;//关闭视频时的覆盖图像

@property (nonatomic, strong) TKBackGroundView *sIsInBackGroundView;//进入后台覆盖视图

@property (nonatomic, strong) UIImageView *backgroundImageView;//视频边框

@property (nonatomic, strong) UIImageView *drawDotView;//画笔颜色展示

@property (nonatomic, strong) UIView *trophyView;//奖杯

@end

@implementation TKOldMaskView

- (instancetype)initWithFrame:(CGRect)frame aVideoRole:(EVideoRole)aVideoRole{
    if (self = [super initWithFrame:frame]) {
        _videoRole = aVideoRole;
        _toolView = [[UIView alloc]init];
        [self addSubview:_toolView];
        _toolView.sakura.backgroundColor(ThemeKP(@"videoToolColor"));
        _toolView.sakura.alpha(ThemeKP(@"videoToolAlpha"));
        
        //关闭视频背景层
        _turnOffCameraView = ({
            TKTurnOffCameraView *view = [[TKTurnOffCameraView alloc]init];
            [self addSubview:view];
            view;
        });
        
        
        //视频边框
        _backgroundImageView = ({
            UIImageView *imageView = [[UIImageView alloc]init];
            [self addSubview:imageView];
            imageView.image = [UIImage resizedImageWithName:ThemeKP(@"videoBoardImage")];
            imageView;
        });
        
        //用户名
        _nameLabel = ({
            UILabel *label = [[UILabel alloc]init];
            [_toolView addSubview:label];
            label.sakura.textColor(ThemeKP(@"videoToolTextColor"));
            label.font = [UIFont systemFontOfSize:9];
            label;
            
        });
        
        
        //奖杯数量
        _trophyView = ({
            UIView *trophyView = [[UIView alloc]init];
            UIColor *color = [TKTheme colorWithPath:@"ClassRoom.Trophy.trophyBackgroundColor"];
            trophyView.backgroundColor = [color colorWithAlphaComponent:0.8];
            [_backgroundImageView addSubview:trophyView];
            trophyView.layer.masksToBounds = YES;
            trophyView.layer.cornerRadius = 8;
            trophyView.hidden = YES;
            trophyView;
        });
        _trophyButton = ({
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [_trophyView addSubview:button];
            button.sakura.titleColor(ThemeKP(@"trophyColor"),UIControlStateNormal);
            button.sakura.image(ThemeKP(@"trophyImage"),UIControlStateNormal);
            button.imageView.contentMode = UIViewContentModeScaleAspectFit;
            button.titleLabel.textAlignment = NSTextAlignmentRight;
            button.titleLabel.font = [UIFont systemFontOfSize:8];
            button;
            
        });
        
        //举手按钮
        _handImageView = ({
            UIImageView *view = [[UIImageView alloc]init];
            view.sakura.image(ThemeKP(@"icon_handup_black"));
            view.contentMode = UIViewContentModeCenter;
            [_backgroundImageView addSubview:view];
            view.hidden = YES;
            view;
        });
        
        //声音标识按钮
        _muteButton = ({
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            //            button.sakura.image(ThemeKP(@"videoAudioNomalImage"),UIControlStateNormal);
            //            button.sakura.image(ThemeKP(@"videoAudioSelectedImage"),UIControlStateSelected);
            
            button.sakura.image(ThemeKP(@"icon_yinliang_black"),UIControlStateNormal);
            button.sakura.image(ThemeKP(@"icon_yinliang_default_black"),UIControlStateSelected);
            [_toolView addSubview:button];
            button;
        });
        
        //画笔标识按钮
        _drawDotView = ({
            UIImageView *view = [[UIImageView alloc]init];
            //            view.layer.masksToBounds = YES;
            //            view.layer.cornerRadius = 5;
            //            view.layer.borderColor = [UIColor whiteColor].CGColor;
            //            view.layer.borderWidth = 1;
            view.backgroundColor = [UIColor clearColor];
            view.hidden = YES;
            [_backgroundImageView addSubview:view];
            view;
            
        });
        [self refreshUI];
        
    }
    return self;
}

- (void)layoutSubviews{
    
    CGFloat toolHeight = self.height*0.14;
    if (toolHeight>30) {
        toolHeight = 30;
    }
    CGFloat toolMinY = self.height - toolHeight;
    
    
    _toolView.frame = CGRectMake(0, toolMinY, self.width, toolHeight);
    
    _turnOffCameraView.frame = CGRectMake(0, 0, self.width, self.height);
    
    _sIsInBackGroundView.frame = CGRectMake(0, 0, self.width, self.height);
    
    _backgroundImageView.frame = CGRectMake(0, 0, self.width, self.height);
    
    _handImageView.frame = CGRectMake(self.width-16-5, 5, 16, 16);
    
    //    _muteButton.frame = CGRectMake(5, 5, 16, 16);
    
    _muteButton.frame = CGRectMake(self.width*0.6, 0, self.width*0.4, self.toolView.height);
    
    
    _nameLabel.frame = CGRectMake(5, 0, self.width*0.8/2.0, toolHeight);
    
    _drawDotView.frame = CGRectMake(self.width-15, self.toolView.y-15, 10, 10);
    
    _trophyView.frame = CGRectMake(5, self.toolView.y-16-5, 38, 16);
    
}

- (void)changeName:(NSString *)name{
    self.nameLabel.text = name;
    
}

- (void)closeVideo{
    _trophyView.hidden = YES;
    _turnOffCameraView.hidden = NO;
}
- (void)openVideo{
    _trophyView.hidden = NO;
    _turnOffCameraView.hidden = YES;
}
- (void)setIVideoViewTag:(NSInteger)iVideoViewTag{
    if (iVideoViewTag == -1) {
        _backgroundImageView.image = [UIImage resizedImageWithName:ThemeKP(@"videoBoardTeacherImage")];
        _turnOffCameraView.iconImageView.sakura.image(ThemeKP(@"videoBackTeacherImage"));
    }
}

-(void)setIRoomUser:(TKRoomUser *)iRoomUser{
    _iRoomUser = iRoomUser;
    if(!_iRoomUser.hasVideo){
        
        _turnOffCameraView.iconImageView.sakura.image(ThemeKP(@"videoNoCameraImage"));
    }else{
        
        _turnOffCameraView.iconImageView.sakura.image(ThemeKP(@"videoCloseCameraImage"));
    }
    [self refreshUI];
    
}

- (void)refreshUI{
    if (_iRoomUser) {
        _toolView.hidden = NO;
        //设置奖杯数量
        int currentGift = 0;
        _muteButton.hidden = NO;
        if(_iRoomUser.properties && [_iRoomUser.properties objectForKey:sGiftNumber]){
            
            id gift = [_iRoomUser.properties objectForKey:sGiftNumber];
            
            if ([gift isKindOfClass:[NSNumber class]]) {
                
                currentGift = [[_iRoomUser.properties objectForKey:sGiftNumber] intValue];
                
            }else if([gift isKindOfClass:[NSDictionary class]]){
                
                currentGift = [[_iRoomUser.properties objectForKey:sGiftNumber] intValue];
            }
            
        }
        
        //        if (currentGift == 0) {
        
        //            _trophyView.hidden = YES;
        //
        //            _trophyButton.hidden = YES;
        
        //        }else{
        
        // 默认也显示奖杯   格式🏆*0
        // 教师  助教隐藏
        if (_iRoomUser.role == UserType_Teacher || _iRoomUser.role == UserType_Assistant) {
            _trophyButton.hidden = YES;
            _trophyView.hidden = YES;
        }
        else{
            CGFloat toolHeight = self.height*0.14;
            if (toolHeight>30) {
                toolHeight = 30;
            }
            _trophyView.frame = CGRectMake(5, self.toolView.y-16-5, 38, 16);
            
            _trophyView.hidden = NO;
            _trophyButton.hidden = NO;
            
            NSString *numStr = [NSString stringWithFormat:@"X%@",@(currentGift)];
            
            [_trophyButton setTitle:numStr forState:(UIControlStateNormal)];
            
            NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:8]};
            CGSize titleSize = [numStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
            
            CGFloat trophyW = titleSize.width+10;
            if (titleSize.width>(self.width-20)/2.0) {
                trophyW = (self.width-20)/2.0;
            }
            
            _trophyButton.frame = CGRectMake(5, 0, _trophyView.width-10, _trophyView.height);
            
            if(_trophyButton.titleLabel.text){
                int currentFontSize = [TKUtil getCurrentFontSize:CGSizeMake(_trophyButton.frame.size.width, _trophyButton.frame.size.height) withString:_trophyButton.titleLabel.text];
                if (currentFontSize>8) {
                    currentFontSize = 8;
                }
                _trophyButton.titleLabel.font = TKFont(currentFontSize);
            }
        }
        
        //声音显示
        
        PublishState tPublishState = (PublishState)_iRoomUser.publishState;
        BOOL tAudioImageShow = !(tPublishState  == PublishState_BOTH || tPublishState == PublishState_AUDIOONLY );
        //todo
        _muteButton.selected = tAudioImageShow;
        
        //视频是否显示
        BOOL turnOffCameraShow = (tPublishState == PublishState_BOTH || tPublishState == PublishState_VIDEOONLY || tPublishState == PublishState_Local_NONE);
        
        _turnOffCameraView.hidden = turnOffCameraShow;
        
        //举手图标是否显示
        BOOL tHandsUpImageShow = (![[_iRoomUser.properties objectForKey:sRaisehand]boolValue]);
        _handImageView.hidden = tHandsUpImageShow;
        
        //画笔颜色值是否显示
        BOOL tDrawImageShow = [[_iRoomUser.properties objectForKey:sCandraw]boolValue];
        
        
        if([[_iRoomUser.properties allKeys] containsObject:sPrimaryColor])
        {
#pragma mark  视频画笔设置1
            NSString *color = [TKUtil optString:_iRoomUser.properties Key:sPrimaryColor];
            
            
            _drawDotView.image = [UIImage imageNamed:[TKHelperUtil imageNameWithPrimaryColor:color]];
        }
        
        if ((_iRoomUser.role == UserType_Teacher || _iRoomUser.role == UserType_Assistant) && [TKEduSessionHandle shareInstance].isClassBegin) {
            
            _drawDotView.hidden = NO;
        }else{
            
            _drawDotView.hidden = !tDrawImageShow;
        }
        
        [self bringSubviewToFront:_toolView];
        [self bringSubviewToFront:_backgroundImageView];
        
        
        
    }else{
        
        _toolView.hidden = YES;
        
        if (_iVideoViewTag == -1) {//老师
            
            _turnOffCameraView.iconImageView.sakura.image(ThemeKP(@"videoBackTeacherImage"));
        }else{//学生
            
            _turnOffCameraView.iconImageView.sakura.image(ThemeKP(@"videoBackStuImage"));
        }
        _handImageView.hidden = YES;
        _drawDotView.hidden = YES;
        _muteButton.hidden = YES;
    }
}
-(void)refreshVolume:(NSDictionary *)dict{
    
    if(!(_iRoomUser.publishState == PublishState_AUDIOONLY || _iRoomUser.publishState == PublishState_BOTH)){
        return;
    }
    
    // 音量大于0 显示
    if ([dict[sVolume] intValue] > 0) {
        _muteButton.hidden = NO;
        _muteButton.selected = NO;
    }
    // 音量 等于 0  隐藏
    else{
        _muteButton.hidden = YES;
    }
}
- (void)refreshRaiseHandUI:(NSDictionary *)dict{
    
    PublishState tPublishState = (PublishState)[[dict objectForKey:sPublishstate]integerValue];
    
    BOOL tAudioImageShow = !(tPublishState  == PublishState_BOTH || tPublishState == PublishState_AUDIOONLY );
    //todo
    _muteButton.selected = tAudioImageShow;
    
    BOOL turnOffCameraShow = (tPublishState == PublishState_BOTH || tPublishState == PublishState_VIDEOONLY ||tPublishState == PublishState_Local_NONE);
    if (_iRoomUser && ![TKEduSessionHandle shareInstance].isClassBegin && ![[TKEduSessionHandle shareInstance].roomMgr getRoomConfigration].beforeClassPubVideoFlag) {
        if (tPublishState == PublishState_AUDIOONLY) {
            
            turnOffCameraShow = NO;
        }else{
            
            turnOffCameraShow = YES;
        }
    }
    _turnOffCameraView.hidden = turnOffCameraShow;
    
    BOOL tHandsUpImageShow = (![[dict objectForKey:sRaisehand]boolValue]);
    _handImageView.hidden = tHandsUpImageShow;
    
    BOOL tDrawImageShow = [[dict objectForKey:sCandraw]boolValue];
    
    
    if([[dict allKeys] containsObject:sPrimaryColor])
    {
        
        NSString *color = [TKUtil optString:dict Key:sPrimaryColor];
        
        
        _drawDotView.image = [UIImage imageNamed:[TKHelperUtil imageNameWithPrimaryColor:color]];
    }
    
    if ((_iRoomUser.role == UserType_Teacher || _iRoomUser.role == UserType_Assistant) && [TKEduSessionHandle shareInstance].isClassBegin) {
        
        _drawDotView.hidden = NO;
    }else{
        
        _drawDotView.hidden = !tDrawImageShow;
    }
    
    
    
    
    [self bringSubviewToFront:_toolView];
    
    [self bringSubviewToFront:_backgroundImageView];
    
}






#pragma mark private

- (void)endInBackGround:(BOOL)isInBackground{
    
    if (isInBackground) {//进入后台需将视频顶层覆盖视图
        [self addSubview:self.sIsInBackGroundView];
        [self bringSubviewToFront:self.sIsInBackGroundView];
        
        [self bringSubviewToFront:_toolView];
        [self bringSubviewToFront:_backgroundImageView];
        
    }else{//取消覆盖
        [self.sIsInBackGroundView removeFromSuperview];
    }
    
}

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
    if (_videoRole == UserType_Student) {
        [_sIsInBackGroundView setContent:MTLocalized(@"State.isInBackGround")];
    }
    if (_videoRole == UserType_Teacher) {
        [_sIsInBackGroundView setContent:MTLocalized(@"State.teacherInBackGround")];
    }
}
- (void)setIsSplit:(BOOL)isSplit{
    _isSplit = isSplit;
    
    _drawDotView.hidden = isSplit;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
