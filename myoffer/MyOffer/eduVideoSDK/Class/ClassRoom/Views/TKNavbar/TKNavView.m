//
//  TKNavView.m
//  EduClass
//
//  Created by lyy on 2018/4/19.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import "TKNavView.h"
#import "TKEduSessionHandle.h"
#import "TKEduRoomProperty.h"
#import "TKDocmentDocModel.h"
#define ThemeKP(args) [@"ClassRoom.TKNavView." stringByAppendingString:args]
@interface TKNavView()
{
    CGFloat topY;
    CGFloat beginBtnY;
    
}
@property (nonatomic, strong) NSDictionary *aParamDic;

@property (nonatomic, strong) UIImageView *returnImageView;//返回视图

@property (nonatomic, strong) UIButton *beginAndEndClassButton;//上课按钮

@property (nonatomic, strong) UIButton *handButton;//举手按钮（未开启视频状态）
@property (nonatomic, strong) UIButton *handHasVideoButton;//举手按钮（开启视频状态）

@property (nonatomic, strong) UILabel *titleLabel;//文档标题

@property (nonatomic, strong) UIButton *leaveClass;//离开课堂

@property (nonatomic, assign) BOOL isCanRaiseHandUp;//是否可以举手

@property (nonatomic, strong) UIImageView *classTimerImageView;//timer图标

@property (nonatomic, strong) UILabel *classTimerLabel;//时间显示
@property (nonatomic, strong) UIButton *cameraSwitchBtn; // 前后摄像头切换
@property (nonatomic)BOOL isFrontCamera;
@property (nonatomic)BOOL isNeedCameraBtn;
@property (nonatomic, assign) CGFloat whiteBoardDocCurPage;


@property (nonatomic, strong) UILabel *cpuLable;
@property (nonatomic, strong) UILabel *memoryLable;

@end

@implementation TKNavView


- (instancetype)initWithFrame:(CGRect)frame aParamDic:(NSDictionary *)aParamDic{
    
    if (self = [super initWithFrame:frame]) {
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(publishStatesUpdate:) name:[NSString stringWithFormat:@"%@%@",sRaisehand,[TKEduSessionHandle shareInstance].localUser.peerID] object:nil];
        
        _isFrontCamera = YES;
        _aParamDic = aParamDic;
        topY = 0;
        beginBtnY = 5;
        _isNeedCameraBtn = [TKEduSessionHandle shareInstance].iRoomProperties.iUserType == UserType_Student || [TKEduSessionHandle shareInstance].iRoomProperties.iUserType == UserType_Teacher;
        self.sakura.backgroundColor(ThemeKP(@"navgationColor"));

        //返回视图
        _returnImageView = ({
            UIImageView *view = [[UIImageView alloc]init];
            [self addSubview:view];
            view.frame = CGRectMake([TKUtil isiPhoneX]?30:0, topY, self.bounds.size.height, self.bounds.size.height-topY);
            view.contentMode = UIViewContentModeCenter;
            view.sakura.image(ThemeKP(@"common_icon_return"));
            view;
        });
       
        CGFloat beginAndEndButtonHight = CGRectGetHeight(self.returnImageView.frame)-beginBtnY*2;
        CGFloat beginAndEndButtonWidth = beginAndEndButtonHight * 3;
        
        //上课按钮
        _beginAndEndClassButton = ({
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            button.backgroundColor = [UIColor clearColor];
            [self addSubview:button];
            
            button.frame = CGRectMake([TKUtil isiPhoneX]?self.frame.size.width-beginAndEndButtonWidth-50:self.frame.size.width-beginAndEndButtonWidth-20, CGRectGetMinY(self.returnImageView.frame)+beginBtnY, beginAndEndButtonWidth, beginAndEndButtonHight);
            button.sakura.titleColor(ThemeKP(@"commom_btn_xiake_titleColor"),UIControlStateNormal);
            ////0-老师 ,1-助教，2-学生 4-寻课
            [button addTarget:self action:@selector(beginAndEndClassButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.sakura.backgroundImage(ThemeKP(@"click_btn_xiakeImage"),UIControlStateNormal);
            
            [button setTitle:MTLocalized(@"Button.ClassBegin") forState:UIControlStateNormal];
            [button setTitle:MTLocalized(@"Button.ClassIsOver") forState:UIControlStateSelected];
            
            if (button.titleLabel.text) {
                int currentFontSize = [TKUtil getCurrentFontSize:CGSizeMake(button.frame.size.width, button.frame.size.height) withString:button.titleLabel.text];
                if (currentFontSize>12) {
                    currentFontSize = 12;
                }
                button.titleLabel.font = TKFont(currentFontSize);
            }
            
            button;
        });
        
        //未开启视频状态下的举手按钮
        _handButton = ({
            UIButton * handButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
            handButton.frame = CGRectMake(self.frame.size.width-beginAndEndButtonWidth-20, CGRectGetMinY(self.returnImageView.frame)+beginBtnY, beginAndEndButtonWidth, beginAndEndButtonHight);
            handButton.sakura.titleColor(ThemeKP(@"commom_btn_xiake_titleColor"),UIControlStateNormal);
            [handButton setTitle:MTLocalized(@"Button.RaiseHand") forState:(UIControlStateNormal)];
            handButton.sakura.backgroundImage(ThemeKP(@"click_btn_xiakeImage"),UIControlStateNormal);
            
            [handButton setTitle:MTLocalized(@"Button.CancleHandsup") forState:(UIControlStateSelected)];
            if (handButton.titleLabel.text) {
                int currentFontSize = [TKUtil getCurrentFontSize:CGSizeMake(handButton.frame.size.width, handButton.frame.size.height) withString:handButton.titleLabel.text];
                if (currentFontSize>12) {
                    currentFontSize = 12;
                }
                handButton.titleLabel.font = TKFont(currentFontSize);
            }
            handButton.selected = NO;
            [handButton addTarget:self action:@selector(handButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
            
            [self addSubview:handButton];
            
            handButton;
        });
        
        //开启视频状态下的举手按钮
        _handHasVideoButton = ({
            UIButton * handButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
            handButton.frame = CGRectMake(self.frame.size.width-beginAndEndButtonWidth-20, CGRectGetMinY(self.returnImageView.frame)+beginBtnY, beginAndEndButtonWidth, beginAndEndButtonHight);
            handButton.sakura.titleColor(ThemeKP(@"commom_btn_xiake_titleColor"),UIControlStateNormal);
            [handButton setTitle:MTLocalized(@"Button.RaiseHand") forState:(UIControlStateNormal)];
            handButton.sakura.backgroundImage(ThemeKP(@"click_btn_xiakeImage"),UIControlStateNormal);
            handButton.layer.masksToBounds = YES;
            handButton.layer.cornerRadius = 5;
            if (handButton.titleLabel.text) {
                int currentFontSize = [TKUtil getCurrentFontSize:CGSizeMake(handButton.frame.size.width, handButton.frame.size.height) withString:handButton.titleLabel.text];
                if (currentFontSize>12) {
                    currentFontSize = 12;
                }
                handButton.titleLabel.font = TKFont(currentFontSize);
            }
            handButton.selected = NO;
            handButton.adjustsImageWhenHighlighted = NO;
            //处理按钮点击事件
            [handButton addTarget:self action:@selector(handTouchDown:)forControlEvents: UIControlEventTouchDown];
            //处理按钮松开状态
            [handButton addTarget:self action:@selector(handTouchUp:)forControlEvents: UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel];
            
            [self addSubview:handButton];
            handButton;
        });
        
        //如果是学生状态则进行显示 或者 配置项(巡课隐藏上下课按钮)
        if ([TKEduSessionHandle shareInstance].iRoomProperties.iUserType == UserType_Student ||
            ([[TKEduSessionHandle shareInstance].roomMgr getRoomConfigration].hideClassEndBtn && [TKEduSessionHandle shareInstance].iRoomProperties.iUserType == UserType_Patrol)) {
            
            _beginAndEndClassButton.hidden = YES;
            
            if ([TKEduSessionHandle shareInstance].isClassBegin) {
                _handButton.hidden = NO;
            }else {
                _handButton.hidden = YES;
            }
            
            
        }else{
            
            [self addSubview:_beginAndEndClassButton];
        }
        
        // 摄像头切换
        if (_isNeedCameraBtn) {
            
            _cameraSwitchBtn = ({
                UIButton *btn = [UIButton buttonWithType: UIButtonTypeCustom];
                btn.frame = CGRectMake(self.beginAndEndClassButton.leftX - 33 - _returnImageView.width,
                                       topY,
                                       _returnImageView.width,
                                       _returnImageView.height);
                btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
                btn.sakura.backgroundImage(ThemeKP(@"camera_btn"), UIControlStateNormal);
                [btn addTarget:self action:@selector(swapFrontAndBackCameras) forControlEvents:UIControlEventTouchUpInside];
                btn;
            });
            
            [self addSubview:_cameraSwitchBtn];
        }
        CGFloat frameX = _isNeedCameraBtn ? _cameraSwitchBtn.leftX : _beginAndEndClassButton.leftX;
        //当前时间
        _classTimerLabel = [[UILabel alloc]init];
        [self addSubview:_classTimerLabel];
//        _classTimerLabel.hidden = YES;
        
        _classTimerLabel.frame = CGRectMake(frameX -100 - 37, topY, 100, CGRectGetHeight(self.returnImageView.frame));
        _classTimerLabel.sakura.textColor(ThemeKP(@"titleColor"));
        _classTimerLabel.textAlignment = NSTextAlignmentLeft;
        
        //时间图片
        _classTimerImageView = [[UIImageView alloc]init];
        [self addSubview:_classTimerImageView];
//        _classTimerImageView.hidden = YES;
        
        _classTimerImageView.frame = CGRectMake(self.classTimerLabel.leftX-20, topY, 20, CGRectGetHeight(self.returnImageView.frame));
        _classTimerImageView.contentMode = UIViewContentModeCenter;
        _classTimerImageView.sakura.image(ThemeKP(@"common_icon_clock"));
        
        [self setTime:0];// 显示时间为00:00:00
        
//         _cpuLable = ({
//             UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_classTimerImageView.frame)-150, 0, 150, self.height)];
//             [self addSubview:label];
//             label;
//         });
//
//        _memoryLable = ({
//            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_cpuLable.frame)-150, 0, 150, self.height)];
//            [self addSubview:label];
//            label;
//        });
        
        
        //标题
        _titleLabel = [[UILabel alloc]init];
        [self addSubview:_titleLabel];
        _titleLabel.frame = CGRectMake(CGRectGetMaxX(self.returnImageView.frame), topY, CGRectGetMinX(_classTimerImageView.frame)-CGRectGetMaxX(self.returnImageView.frame), CGRectGetHeight(self.returnImageView.frame));
        _titleLabel.font = TKFont(18);
        _titleLabel.sakura.textColor(ThemeKP(@"titleColor"));
        
        //返回按钮
        _leaveClass = [[UIButton alloc]init];
        _leaveClass.frame = CGRectMake(0, 0, 50., CGRectGetHeight(self.returnImageView.frame));
        _leaveClass.backgroundColor = [UIColor clearColor];
        [_leaveClass addTarget:self action:@selector(leaveClass:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:_leaveClass];
        
        if([TKEduSessionHandle shareInstance].isPlayback){
            _classTimerImageView.hidden = YES;
            _classTimerLabel.hidden = YES;
            _beginAndEndClassButton.hidden = YES;
        }
        
        // 导航栏下部背景色
        if([[[TKEduSessionHandle shareInstance].roomMgr getRoomProperty].skinId isEqualToString: TKDefaultSkin]) {
            UIView *view = [[UIView alloc] initWithFrame:frame];
            view.height = 3.;
            view.y = self.height - view.height;
            view.sakura.backgroundColor(ThemeKP(@"navgationBottomColor"));
            
            [self addSubview:view];
        }
        
    }
    
    // 是否显示 举手按钮
    [self isShowHandUpButton];
    return self;
}


- (void)refreshUI:(BOOL)add{
    //设置上课或者举手按钮的背景图
    
    switch ([TKEduSessionHandle shareInstance].localUser.role) {
        case UserType_Teacher:
            
            if (add) {
                
                [_beginAndEndClassButton setTitle:MTLocalized(@"Button.ClassIsOver") forState:(UIControlStateNormal)];
            }else{
                
                [_beginAndEndClassButton setTitle:MTLocalized(@"Button.ClassBegin") forState:(UIControlStateNormal)];
            }
            
            break;
        case UserType_Student:
            
           // [_beginAndEndClassButton setTitle:MTLocalized(@"Button.RaiseHand") forState:(UIControlStateNormal)];
            
            if ([TKEduSessionHandle shareInstance].isClassBegin) {
                
                 _handButton.hidden = NO;
                
                
            }else {
                _handButton.hidden = YES;
            }
            
            break;
        case UserType_Patrol:
            
            if (add && ![[TKEduSessionHandle shareInstance].roomMgr getRoomConfigration].hideClassEndBtn) {
                _beginAndEndClassButton.hidden = NO;
                [_beginAndEndClassButton setTitle:MTLocalized(@"Button.ClassIsOver") forState:(UIControlStateNormal)];
            }else{
                
                _beginAndEndClassButton.hidden = YES;
            }
            _handButton.hidden = YES;
            _handHasVideoButton.hidden = YES;
            
            break;
            
        default:
            break;
    }
    
     [self isShowHandUpButton];
}

#pragma mark - 上下课逻辑
- (void)beginAndEndClassButtonClick:(UIButton *)sender{
    
    if ([TKEduSessionHandle shareInstance].localUser.role == UserType_Teacher || [TKEduSessionHandle shareInstance].localUser.role == UserType_Patrol) {
        
        
        sender.selected = [TKEduSessionHandle shareInstance].isClassBegin;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:tkClassBeginNotification
                                                            object:@{@"classBegin":@(!sender.selected)}];
        if (!sender.selected) {//上课
        
            if([[TKEduSessionHandle shareInstance].roomMgr getRoomConfigration].endClassTimeFlag){
                
                [TKEduNetManager systemtime:self.aParamDic Complete:^int(id  _Nullable response) {
                    
                    if (response) {
                        int time =  [TKEduSessionHandle shareInstance].iRoomProperties.iEndTime - [response[@"time"] intValue];
                        //(2)未到下课时间： 老师未点下课->下课时间到->课程结束，一律离开
                        //(3)到下课时间->提前5分钟给出提示语（老师，助教）->课程结束，一律离开
                        if ((time >0 && time<=300) &&[TKEduSessionHandle shareInstance].localUser.role == UserType_Teacher) {
                            int ratio = time/60;
                            int remainder = time % 60;
                            
                            if (ratio == 0 && remainder>0) {
                                
                                [TKUtil showClassEndMessage:[NSString stringWithFormat:@"%d%@",remainder,MTLocalized(@"Prompt.ClassEndTimeseconds")]];
                            }else if(ratio>0){
                                
                                [TKUtil showClassEndMessage:[NSString stringWithFormat:@"%d%@",ratio,MTLocalized(@"Prompt.ClassEndTime")]];
                            }
                        }
                        if (time<=0) {
                            [TKUtil showClassEndMessage:MTLocalized(@"Error.RoomDeletedOrExpired")];
                            
                            //离开课堂回调
//                            [self prepareForLeave:YES];
                            
                        }else{
                            if([[TKEduSessionHandle shareInstance].roomMgr getRoomConfigration].forbidLeaveClassFlag && [TKEduSessionHandle shareInstance].localUser.role == UserType_Teacher){
                                [[TKEduSessionHandle shareInstance]sessionHandleDelMsg:sAllAll ID:sAllAll To:sTellNone Data:@{} completion:nil];
                            }
                            TKLog(@"开始上课");
                            UIButton *tButton = _beginAndEndClassButton;
                            [[TKEduSessionHandle shareInstance]configureHUD:@"" aIsShow:YES];
                            
                            [TKEduNetManager classBeginStar:[[TKRoomManager instance] getRoomProperty].roomid companyid:[[TKRoomManager instance] getRoomProperty].companyid aHost:[TKEduSessionHandle shareInstance].iRoomProperties.sWebIp aPort:[TKEduSessionHandle shareInstance].iRoomProperties.sWebPort aComplete:^int(id  _Nullable response) {
                                
                                [tButton setTitle:MTLocalized(@"Button.ClassIsOver") forState:UIControlStateNormal];
                                //  {"recordchat" : true};
                                NSString *str = [TKUtil dictionaryToJSONString:@{@"recordchat":@YES}];
                                //[_iSessionHandle sessionHandlePubMsg:sClassBegin ID:sClassBegin To:sTellAll Data:str Save:true completion:nil];
                                [[TKEduSessionHandle shareInstance] sessionHandlePubMsg:sClassBegin ID:sClassBegin To:sTellAll Data:str Save:true AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
                                [[TKEduSessionHandle shareInstance]configureHUD:@"" aIsShow:NO];
                                
                                TKDocmentDocModel *docModel = [TKEduSessionHandle shareInstance].iCurrentDocmentModel;
                                [[TKEduSessionHandle shareInstance].whiteBoardManager changeDocumentWithFileID:docModel.fileid isBeginClass:YES isPubMsg:YES];
                                return 0;
                            } aNetError:^int(id  _Nullable response) {
                                
                                [[TKEduSessionHandle shareInstance]configureHUD:@"" aIsShow:NO];
                                return 0;
                            }];
                        }
                    }
                    
                    
                    
                    return 0;
                } aNetError:^int(id  _Nullable response) {
                    
                    return 0;
                }];
            }
            
            else{
                if([[TKEduSessionHandle shareInstance].roomMgr getRoomConfigration].forbidLeaveClassFlag && [TKEduSessionHandle shareInstance].localUser.role == UserType_Teacher){
                    [[TKEduSessionHandle shareInstance]sessionHandleDelMsg:sAllAll ID:sAllAll To:sTellNone Data:@{} completion:nil];
                }
                TKLog(@"开始上课");
                UIButton *tButton = _beginAndEndClassButton;
                [[TKEduSessionHandle shareInstance]configureHUD:@"" aIsShow:YES];
                
                [TKEduNetManager classBeginStar:[TKEduSessionHandle shareInstance].iRoomProperties.iRoomId companyid:[TKEduSessionHandle shareInstance].iRoomProperties.iCompanyID aHost:[TKEduSessionHandle shareInstance].iRoomProperties.sWebIp aPort:[TKEduSessionHandle shareInstance].iRoomProperties.sWebPort aComplete:^int(id  _Nullable response) {
             
                    
                    [tButton setTitle:MTLocalized(@"Button.ClassIsOver") forState:UIControlStateNormal];
                    //  {"recordchat" : true};
                    NSString *str = [TKUtil dictionaryToJSONString:@{@"recordchat":@YES}];
                    //[_iSessionHandle sessionHandlePubMsg:sClassBegin ID:sClassBegin To:sTellAll Data:str Save:true completion:nil];
                    [[TKEduSessionHandle shareInstance] sessionHandlePubMsg:sClassBegin ID:sClassBegin To:sTellAll Data:str Save:true AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
                    [[TKEduSessionHandle shareInstance]configureHUD:@"" aIsShow:NO];
                    
                    
                    
                    TKDocmentDocModel *docModel = [TKEduSessionHandle shareInstance].iCurrentDocmentModel;
                    
                    [[TKEduSessionHandle shareInstance].whiteBoardManager changeDocumentWithFileID:docModel.fileid isBeginClass:YES isPubMsg:YES];
                    
                    return 0;
                } aNetError:^int(id  _Nullable response) {
                    
                    [[TKEduSessionHandle shareInstance]configureHUD:@"" aIsShow:NO];
                    return 0;
                }];
                
            }
            if (self.classBeginBlock) {
                self.classBeginBlock();
            }
            
        } else {
            
            
            TKAlertView *alert = [[TKAlertView alloc]initWithTitle:MTLocalized(@"Prompt.prompt") contentText:MTLocalized(@"Prompt.FinishClass") leftTitle:MTLocalized(@"Prompt.Cancel") rightTitle:MTLocalized(@"Prompt.OK")];
            [alert show];
            alert.rightBlock = ^{
                
                
                _beginAndEndClassButton.selected = NO;
//                _classTimerLabel.text = @"";
//                _classTimerImageView.hidden = YES;
                [self setTime:0];
                
                if (self.classoverBlock) {
                    self.classoverBlock();
                }
            };
            alert.lelftBlock = ^{
                
            };
           
        }
        
        
    }
}


#pragma mark - 举手
- (void)handButtonClick:(UIButton *)sender{
    TKLog(@"---举手1");
    
    // 在台上点击举手按钮无效，只响应长按
    if ([TKEduSessionHandle shareInstance].localUser.publishState > 0) {
        return;
    }
    
    sender.selected = ![[[TKEduSessionHandle shareInstance].localUser.properties objectForKey:sRaisehand] boolValue];
    [[TKEduSessionHandle shareInstance] sessionHandleChangeUserProperty:[TKEduSessionHandle shareInstance].localUser.peerID TellWhom:sTellAll Key:sRaisehand Value:@(sender.selected) completion:nil];
    
    
}
#pragma mark - 设置上台状态举手按钮的样式
- (void)setHandButtonState:(BOOL)isHandup{
    if (isHandup) {
        _handHasVideoButton.sakura.backgroundImage(ThemeKP(@"handing_up_bg"),UIControlStateNormal);
        _handHasVideoButton.sakura.titleColor(ThemeKP(@"titleColor"),UIControlStateNormal);
        [_handHasVideoButton setTitle:MTLocalized(@"Button.RaiseHandCancle") forState:(UIControlStateNormal)];
    }else{
        _handHasVideoButton.sakura.titleColor(ThemeKP(@"commom_btn_xiake_titleColor"),UIControlStateNormal);
        [_handHasVideoButton setTitle:MTLocalized(@"Button.RaiseHand") forState:(UIControlStateNormal)];
        _handHasVideoButton.sakura.backgroundImage(ThemeKP(@"click_btn_xiakeImage"),UIControlStateNormal);
        
    }
     [self isShowHandUpButton];
}
#pragma mark - 举手中
- (void)handTouchDown:(UIButton *)sender{
    if ([TKEduSessionHandle shareInstance].iRoomProperties.iUserType != UserType_Student || [TKEduSessionHandle shareInstance].localUser.publishState == 0) {
        return;
    }
    [[TKEduSessionHandle shareInstance] sessionHandleChangeUserProperty:[TKEduSessionHandle shareInstance].localUser.peerID TellWhom:sTellAll Key:sRaisehand Value:@(YES) completion:nil];

}
#pragma mark - 摄像头切换
- (void)swapFrontAndBackCameras {
    
    _isFrontCamera = !_isFrontCamera;
    [[TKEduSessionHandle shareInstance] sessionHandleSelectCameraPosition: _isFrontCamera];
}

#pragma mark - 取消举手
- (void)handTouchUp:(UIButton *)sender{
  
//    sender.backgroundColor = [UIColor redColor];
//
//
    if ([TKEduSessionHandle shareInstance].iRoomProperties.iUserType != UserType_Student || [TKEduSessionHandle shareInstance].localUser.publishState == 0) {
        return;
    }
    [[TKEduSessionHandle shareInstance] sessionHandleChangeUserProperty:[TKEduSessionHandle shareInstance].localUser.peerID TellWhom:sTellAll Key:sRaisehand Value:@(NO) completion:nil];

}
#pragma mark - 离开课堂
- (void)leaveClass:(UIButton *)sender{
    if (self.leaveButtonBlock) {
        
        self.leaveButtonBlock();
    }
}

- (void)setTitle:(NSString *)title{
    _titleLabel.text = title;
}



- (void)setTime:(NSTimeInterval)time{
    
    NSString * H = @"0";
    NSString * M = @"0";
    NSString * S = @"0";
    long temps = time;
    //long temps = 1;
    long tempm = temps / 60;
    long temph = tempm / 60;
    long sec = temps - tempm * 60;
    tempm = tempm - temph * 60;
    H = temph == 0 ? @"00" : temph >= 10 ? [NSString stringWithFormat:@"%@",@(temph)] : [NSString stringWithFormat:@"0%@",@(temph)];
    M = tempm == 0 ? @"00" : tempm >= 10 ? [NSString stringWithFormat:@"%@",@(tempm)] : [NSString stringWithFormat:@"0%@",@(tempm)];
    S = sec == 0 ? @"00" : sec >= 10 ? [NSString stringWithFormat:@"%@",@(sec)] : [NSString stringWithFormat:@"0%@",@(sec)];
    
  
    _classTimerImageView.hidden = NO;
    _classTimerLabel.hidden = NO;
    
    _classTimerLabel.text = [NSString stringWithFormat:@" %@:%@:%@",H,M,S];

}

- (void)showDeviceInfo{
//   CGFloat cpu = [TKHelperUtil GetCpuUsage];
//   CGFloat memory =  [TKHelperUtil GetCurrentTaskUsedMemory];
//    
//    _cpuLable.text = [NSString stringWithFormat:@"cpu:%.2f",cpu];
//    _memoryLable.text = [NSString stringWithFormat:@"memory%.2f",memory];
    
}
- (void)layoutSubviews{
    
}
#pragma mark - 接收视频状态通知
- (void)publishStatesUpdate:(NSNotification *)notification{
    
    if (![TKEduSessionHandle shareInstance].isClassBegin || [TKEduSessionHandle shareInstance].localUser.role != UserType_Student) {
        _handHasVideoButton.hidden = YES;
        _handButton.hidden = YES;
        return;
    }
    
    NSDictionary *tDic = (NSDictionary *)notification.object;
    
    PublishState tPublishState = (PublishState)[[tDic objectForKey:sPublishstate]integerValue];
    
   
    if (tPublishState==PublishState_NONE) {
        
        _handHasVideoButton.selected = NO;
        _handHasVideoButton.hidden = YES;
        _handButton.hidden = NO;
    }else{
        
        _handHasVideoButton.hidden = NO;
        
        _handButton.selected = NO;
        _handButton.hidden = YES;
    }
    
    [self isShowHandUpButton];
}
/*
 卡通模板（一对一）：不允许助教上台的教室，iPad学生进入教室 不应该有举手；
 如果是允许助教上台的一对一课堂，应该有举手；
 */
- (void)isShowHandUpButton {
    
    if(![[TKRoomManager instance] getRoomConfigration].assistantCanPublish && [[[TKEduSessionHandle shareInstance].roomMgr getRoomProperty].roomtype intValue] == RoomType_OneToOne ){

        _handButton.hidden = YES;
        _handHasVideoButton.hidden = YES;

    }
    // 回放
    if([TKEduSessionHandle shareInstance].isPlayback){
        _handButton.hidden = YES;
        _handHasVideoButton.hidden = YES;
    }
    
   
}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
