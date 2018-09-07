//
//  TKControlView.m
//  EduClass
//
//  Created by lyy on 2018/4/28.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import "TKControlView.h"
#import "TKEduSessionHandle.h"
#import "TKControlButton.h"
#import "TKEduNetManager.h"
#import "TKEduRoomProperty.h"
#import "TKTrophyView.h"

#define ThemeKP(args) [@"ClassRoom.TKControlView." stringByAppendingString:args]

@interface TKControlView()
{
    CGFloat btnWidth;
    CGFloat btnHeight;
    CGFloat marginX;
    CGFloat marginY;
}
@property (nonatomic, strong) TKControlButton *allMuteBtn;//全体静音
@property (nonatomic, strong) TKControlButton *allSpeechesBtn;//全体发言
@property (nonatomic, strong) TKControlButton *allRewardBtn;//全体奖励
@property (nonatomic, strong) TKControlButton *allResetBtn;//全体复位
@end

@implementation TKControlView

- (id)initWithFrame:(CGRect)frame controlController:(NSString *)controlController {
    
    if (self = [super initWithFrame:frame from:controlController]) {

        btnHeight = self.contentView.frame.size.height/10.0*3.0;
        if (btnHeight<60) {
            btnHeight = 60;
        }
        btnWidth = btnHeight/10.0*6.0;
        marginY = (self.contentView.frame.size.height-btnHeight*2)/3;
        marginX = (self.contentView.frame.size.width-btnWidth*2)/3;

        // 标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height*0.12)];
        titleLabel.font = [UIFont systemFontOfSize:14.0f];
        titleLabel.sakura.textColor(ThemeKP(@"titleColor"));
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = MTLocalized(@"Title.ControlList");
        [self addSubview:titleLabel];
        
        [self loadAllBtn];
    }
    return self;
}
- (void)loadAllBtn{
    self.allMuteBtn = ({
        
        TKControlButton *button = [[TKControlButton alloc]initWithFrame:CGRectMake(marginX, marginY, btnWidth, btnHeight) imageName:ThemeKP(@"btn_jingyin") disableImageName:ThemeKP(@"btn_jingyin_unclickable") title:MTLocalized(@"Button.MuteAudio")];
        button.selected = NO;
        [self.contentView addSubview:button];
        [button controlAddTarget:self action:@selector(MuteButtonClick:)];
        button;
        
    });
    
    self.allSpeechesBtn = ({
        TKControlButton *button = [[TKControlButton alloc]initWithFrame:CGRectMake(self.allMuteBtn.rightX+ marginX, marginY, btnWidth, btnHeight) imageName:ThemeKP(@"btn_talk_all") disableImageName:ThemeKP(@"btn_talk_all_unclickable") title:MTLocalized(@"Button.MuteAll")];
        button.selected = NO;
        [self.contentView addSubview:button];
        [button controlAddTarget:self action:@selector(speecheButtonClick:)];
        button;
    });
    
    
    self.allRewardBtn = ({
        
        TKControlButton *button = [[TKControlButton alloc]initWithFrame:CGRectMake(self.allMuteBtn.leftX, CGRectGetMaxY(self.allMuteBtn.frame) + marginY, btnWidth, btnHeight) imageName:ThemeKP(@"btn_reward") disableImageName:ThemeKP(@"btn_reward_unclickable") title:MTLocalized(@"Button.Reward")];
        button.selected = NO;
        [self.contentView addSubview:button];
        [button controlAddTarget:self action:@selector(rewardButtonClick:)];
        button;
    });
    
    
    self.allResetBtn = ({
        
        TKControlButton *button = [[TKControlButton alloc]initWithFrame:CGRectMake(self.allSpeechesBtn.leftX, CGRectGetMaxY(self.allMuteBtn.frame) + marginY, btnWidth, btnHeight) imageName:ThemeKP(@"button_restore") disableImageName:ThemeKP(@"button_restore_unclickable") title:MTLocalized(@"Button.Reset")];
        button.selected = NO;
        [self.contentView addSubview:button];
        [button controlAddTarget:self action:@selector(resetButtonClick:)];
        button;
    });
    
    if ([TKEduSessionHandle shareInstance].bigRoom) {
        self.allRewardBtn.enable = NO;
    }else{
        self.allRewardBtn.enable = YES;
    }
    
}

- (void)MuteButtonClick:(TKControlButton *)button{
    
    
    TKLog(@"全体静音");
    if ([TKEduSessionHandle shareInstance].iRoomProperties.iUserType == UserType_Student) {
        // 如果当前用户是学生
        [[TKEduSessionHandle shareInstance] disableMyAudio:!button.selected];
        
        // 如果禁用音视频，已经举手，举起的手要放下
        BOOL handState = [[[TKEduSessionHandle shareInstance].localUser.properties objectForKey:sRaisehand] boolValue];
        if (handState == YES) {
            [[TKEduSessionHandle shareInstance] sessionHandleChangeUserProperty:[TKEduSessionHandle shareInstance].localUser.peerID TellWhom:sTellAll Key:sRaisehand Value:@(!handState) completion:nil];
        }
        
        button.selected = !button.selected;
        
    } else {
        // 如果当前用户是老师
        if (![TKEduSessionHandle shareInstance].isMuteAudio) {
            button.enable = NO;
            _allSpeechesBtn.enable = YES;
            for (TKRoomUser *tUser in [[TKEduSessionHandle shareInstance] userStdntAndTchrArray]) {
                
                if ((tUser.role != UserType_Student))
                    continue;
                
                // [_iSessionHandle sessionHandleChangeUserProperty:tUser.peerID TellWhom:tUser.peerID Key:sGiftNumber Value:@(currentGift+1) completion:nil];
                PublishState tState = (PublishState)tUser.publishState;
                if (tState == PublishState_BOTH) {
                    tState = PublishState_VIDEOONLY;
                }else if(tState == PublishState_AUDIOONLY){
                    tState = PublishState_NONE;
                }
                
                [[TKEduSessionHandle shareInstance] sessionHandleChangeUserPublish:tUser.peerID Publish:tState completion:nil];
            }
            [TKEduSessionHandle shareInstance].isMuteAudio = YES;
        }
        
    }
    [self dismissAlert];
}

- (void)speecheButtonClick:(TKControlButton *)button{
    //全体发言
    if ([TKEduSessionHandle shareInstance].localUser.role == UserType_Student) {
        // 如果当前用户是学生
        [[TKEduSessionHandle shareInstance] disableMyAudio:button.selected];
        
        // 如果禁用音视频，已经举手，举起的手要放下
        BOOL handState = [[[TKEduSessionHandle shareInstance].localUser.properties objectForKey:sRaisehand] boolValue];
        if (handState == YES) {
            [[TKEduSessionHandle shareInstance] sessionHandleChangeUserProperty:[TKEduSessionHandle shareInstance].localUser.peerID TellWhom:sTellAll Key:sRaisehand Value:@(!handState) completion:nil];
            if (!handState) {
                if ([TKEduSessionHandle shareInstance].localUser.publishState > 0) {
//                    [_iClassBeginAndRaiseHandButton setTitle:MTLocalized(@"Button.RaiseHandCancle") forState:UIControlStateNormal];
                } else {
//                    [_iClassBeginAndRaiseHandButton setTitle:MTLocalized(@"Button.CancleHandsup") forState:UIControlStateNormal];
                }
            } else {
//                [_iClassBeginAndRaiseHandButton setTitle:MTLocalized(@"Button.RaiseHand") forState:UIControlStateNormal];
            }
        }
        
        button.selected = !button.selected;
//        [self refreshUI];
        
    } else {
        // 如果当前用户是老师
        if (![TKEduSessionHandle shareInstance].isunMuteAudio) {
            
            button.enable = NO;
            _allMuteBtn.enable = YES;
            
            for (TKRoomUser *tUser in [[TKEduSessionHandle shareInstance] userStdntAndTchrArray]) {
                
                if ((tUser.role != UserType_Student))
                    continue;
                
                PublishState tState = (PublishState)tUser.publishState;
                //                if (tState == PublishState_BOTH) {
                //                    tState = PublishState_VIDEOONLY;
                //                }else if(tState == PublishState_AUDIOONLY){
                //                    tState = PublishState_NONE;
                //                }
                if(tState == PublishState_VIDEOONLY){
                    tState = PublishState_BOTH;
                }
//                _isLocalPublish = false;
                [[TKEduSessionHandle shareInstance] sessionHandleChangeUserPublish:tUser.peerID Publish:tState completion:nil];
            }
            [TKEduSessionHandle shareInstance].isunMuteAudio = YES;
            
            
        }
        
    }
    [self dismissAlert];
}
#pragma mark - 全员奖励
- (void)rewardButtonClick:(TKControlButton *)button{
    if ([TKEduSessionHandle shareInstance].bigRoom) {
        return;
    }
    
    [self dismissAlert];
    
    NSArray *arr = [[[TKEduSessionHandle shareInstance].roomMgr getRoomProperty].trophy copy];
    BOOL customTrophyFlag = [[TKEduSessionHandle shareInstance].roomMgr getRoomConfigration].customTrophyFlag;
    
    if (arr.count>1 && customTrophyFlag) {
        
        UIView *whiteBoardView = [TKEduSessionHandle shareInstance].whiteboardView;
        
        CGRect wbRect = [whiteBoardView convertRect:whiteBoardView.bounds toView:[UIApplication sharedApplication].keyWindow];
        
        CGFloat wbHeight = wbRect.size.height;
        CGFloat wbWidth = wbRect.size.width;
        
        CGPoint relyPoint = CGPointMake(wbRect.origin.x + wbRect.size.width / 2, wbRect.origin.y + wbRect.size.height/2);
        
        //自定义奖杯弹框： 宽 5/10 
//        CGFloat trophyH = wbHeight * (9/10.0);
        CGFloat trophyW = wbWidth * (4.5/10.0);
        
        // 高 9/10(改： 根据按钮数量给高度)
        CGFloat trophyH = trophyW / 3 ;
        trophyH = (arr.count / 5 + 1) * trophyH + 20;
        CGFloat trophyX = relyPoint.x - trophyW/2;
        CGFloat trophyY = relyPoint.y - trophyH/2;
        
        TKTrophyView *trophyView =[[TKTrophyView alloc]initWithFrame:CGRectMake(trophyX, trophyY, trophyW, trophyH) chatController:@"TKOneToMoreRoomController"];
        
        [trophyView showOnView:self trophyMessage:arr];
        

        trophyView.sendTrophy = ^(NSDictionary *message) {
            
            // 如果当前用户是老师
            [TKEduNetManager sendGifForRoomUser:[[TKEduSessionHandle shareInstance] userStdntAndTchrArray] roomID:[TKEduSessionHandle shareInstance].iRoomProperties.iRoomId  aMySelf:[TKEduSessionHandle shareInstance].localUser aHost:[TKEduSessionHandle shareInstance].iRoomProperties.sWebIp aPort:[TKEduSessionHandle shareInstance].iRoomProperties.sWebPort aSendComplete:^(id  _Nullable response) {
                
                for (TKRoomUser *tUser in [[TKEduSessionHandle shareInstance] userStdntAndTchrArray]) {
                   
                    
                    int currentGift = 0;
                    
                    if(tUser && tUser.properties && [tUser.properties objectForKey:sGiftNumber]){
                        
                        currentGift = [[tUser.properties objectForKey:sGiftNumber] intValue];
                        
                        
                    }
                    
                    
                    NSDictionary *dict = @{
                                           @"giftnumber":@(currentGift+1),
                                           @"giftinfo":message,
                                           };
                    
                    
                    [[TKEduSessionHandle shareInstance] sessionHandleChangeUserProperty:tUser.peerID TellWhom:sTellAll data:dict completion:nil];
                    
                    
                    NSString *pathDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"companyid%@/trophyid%@/trophyvoice.wav", message[@"companyid"],message[@"trophyid"]]];
                    
                    // 尽量保持 动画声音同步
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                                 (int64_t)(0.3 * NSEC_PER_SEC)),
                                   dispatch_get_global_queue(0, 0),
                                   ^{
                                       
                                       [[TKEduSessionHandle shareInstance] startPlayAudioFile:pathDir loop:NO];
                                   });
                }
                
            }aNetError:nil];
           
            
        };
        
        return;
    }else{
        
        // 如果当前用户是老师
        [TKEduNetManager sendGifForRoomUser:[[TKEduSessionHandle shareInstance] userStdntAndTchrArray] roomID:[TKEduSessionHandle shareInstance].iRoomProperties.iRoomId  aMySelf:[TKEduSessionHandle shareInstance].localUser aHost:[TKEduSessionHandle shareInstance].iRoomProperties.sWebIp aPort:[TKEduSessionHandle shareInstance].iRoomProperties.sWebPort aSendComplete:^(id  _Nullable response) {
            
            for (TKRoomUser *tUser in [[TKEduSessionHandle shareInstance] userStdntAndTchrArray]) {
                int currentGift = 0;
                if ((tUser.role != UserType_Student))
                    continue;
                
                if(tUser && tUser.properties && [tUser.properties objectForKey:sGiftNumber])
                    currentGift = [[tUser.properties objectForKey:sGiftNumber] intValue];
                [[TKEduSessionHandle shareInstance] sessionHandleChangeUserProperty:tUser.peerID TellWhom:sTellAll Key:sGiftNumber Value:@(currentGift+1) completion:nil];
            }
            
        }aNetError:nil];
        
    }
    
   
    
}


- (void)resetButtonClick:(TKControlButton *)button{
    if (self.resetBlock) {
        self.resetBlock();
    }
    
    [self dismissAlert];
}


- (void)refreshUI{
    
    if([TKEduSessionHandle shareInstance].isMuteAudio){
        _allMuteBtn.enable = NO;
        _allSpeechesBtn.enable = YES;
    }else{
        _allMuteBtn.enable = YES;
        _allSpeechesBtn.enable = NO;
    }
   
}
@end
