//
//  TKNewNavView.m
//  EduClass
//
//  Created by talkqa on 2018/6/4.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import "TKNewNavView.h"
#import "TKEduSessionHandle.h"
#import "TKEduRoomProperty.h"
#import "TKUploadView.h"
#import "TKDocmentDocModel.h"
#import "TKIPhoneTypeString.h"


#define ThemeKP(args) [@"ClassRoom.TKNavView." stringByAppendingString:args]
#define ThemeKPNA(args) [@"ClassRoom.TKTabbarView." stringByAppendingString:args]
#define ButtonSpace 10
#define FrameX(target) CGRectGetMinX(target.frame) - brushHeight - (ButtonSpace)
@interface TKNewNavView ()
{
    CGFloat topY;
    CGFloat beginBtnY;
    CGFloat brushHeight;
    
}
@property (nonatomic, assign) RoomType roomType;

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

 // 前后摄像头切换
@property (nonatomic, strong) UIButton *cameraSwitchBtn;
@property (nonatomic)BOOL isFrontCamera;
@property (nonatomic)BOOL isNeedCameraBtn;

@property (nonatomic, strong) TKUploadView *uploadView;//文档上传视图（拍摄上传、相册上传）

@property (nonatomic, strong) TKClassTimeView *timeView;


@end

@implementation TKNewNavView




- (instancetype)initWithFrame:(CGRect)frame aParamDic:(NSDictionary *)aParamDic roomType:(RoomType)roomType {
    
    if (self = [super initWithFrame:frame]) {
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(publishStatesUpdate:) name:[NSString stringWithFormat:@"%@%@",sRaisehand,[TKEduSessionHandle shareInstance].localUser.peerID] object:nil];
        
        
        _roomType = roomType;
        brushHeight = self.frame.size.height;
        _aParamDic = aParamDic;
        topY = 0;
        beginBtnY = 5;
        _isNeedCameraBtn = [TKEduSessionHandle shareInstance].iRoomProperties.iUserType == UserType_Student || [TKEduSessionHandle shareInstance].iRoomProperties.iUserType == UserType_Teacher;
        self.sakura.backgroundColor(ThemeKP(@"navgationColor"));
        
        //返回视图
        _returnImageView = ({
            UIImageView *view = [[UIImageView alloc]init];
            view.frame = CGRectMake([TKUtil isiPhoneX]?30:0, topY, self.bounds.size.height, self.bounds.size.height-topY);
            view.contentMode = UIViewContentModeCenter;
            view.sakura.image(ThemeKP(@"common_icon_return"));
            view;
        });
        [self addSubview:_returnImageView];
       
        
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
        if ([TKEduSessionHandle shareInstance].iRoomProperties.iUserType == UserType_Student || ([[TKEduSessionHandle shareInstance].roomMgr getRoomConfigration].hideClassEndBtn && [TKEduSessionHandle shareInstance].iRoomProperties.iUserType == UserType_Patrol)) {
            _beginAndEndClassButton.hidden = YES;
            
        }else{
            
            [self addSubview:_beginAndEndClassButton];
        }
        
        // 摄像头切换
        if (_isNeedCameraBtn) {
            
            _cameraSwitchBtn = ({
                UIButton *btn = [UIButton buttonWithType: UIButtonTypeCustom];
                btn.frame = CGRectMake(self.beginAndEndClassButton.leftX - brushHeight - 10,
                                       0,
                                       brushHeight,
                                       brushHeight);
                btn.sakura.backgroundImage(ThemeKP(@"camera_btn"), UIControlStateNormal);
                btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
                [btn addTarget:self action:@selector(swapFrontAndBackCameras) forControlEvents:UIControlEventTouchUpInside];
                btn;
            });
            
            [self addSubview:_cameraSwitchBtn];
        }
        
        CGFloat frameX = _isNeedCameraBtn ? _cameraSwitchBtn.leftX : _beginAndEndClassButton.leftX;
        //相机
        _camareButton = ({
            UIButton *button = [self returnButtonWithFrame:CGRectMake(frameX - brushHeight - 10, 0, brushHeight, brushHeight)
                                                 imageName:ThemeKP(@"common_camare_regular")
                                           selectImageName:ThemeKP(@"common_camare_selected")
                                                    action:@selector(camareButtonClick:)
                                                  selected:NO];
            button.hidden = YES;
            button;
        });
        
        //相册
        _picButton = ({
            UIButton *button = [self returnButtonWithFrame:CGRectMake(CGRectGetMinX(self.camareButton.frame) - brushHeight - 10, 0, brushHeight, brushHeight) imageName:ThemeKP(@"-s-common_pic_regular") selectImageName:ThemeKP(@"-s-common_pic_regular") action:@selector(picButtonClick:) selected:NO];
            button;
        });
        
        
        
        //教师端 1v1模式下没有控制按钮
        if (roomType) {
            // 控制
            _controlButton = ({
                UIButton *button = [self returnButtonWithFrame:CGRectMake(frameX - brushHeight - 10, 0, brushHeight, brushHeight) imageName:ThemeKPNA(@"button_control_default") selectImageName:ThemeKPNA(@"button_contro_selected") action:@selector(controlButtonClick:) selected:NO];
                button;
            });
            
            
        }
        
        // 课件库
        if ([TKEduSessionHandle shareInstance].iRoomProperties.iUserType == UserType_Patrol) {
            _coursewareButton = ({
                UIButton *button = [self returnButtonWithFrame:CGRectMake(ScreenW - brushHeight - 10, 0, brushHeight, brushHeight) imageName:ThemeKPNA(@"button_courseware_default") selectImageName:ThemeKPNA(@"button_courseware_selected") action:@selector(coursewareButtonClick:) selected:NO];
                button;
            });
        }else {
            _coursewareButton = ({
                UIButton *button = [self returnButtonWithFrame:CGRectMake(frameX - brushHeight - 10, 0, brushHeight, brushHeight) imageName:ThemeKPNA(@"button_courseware_default") selectImageName:ThemeKPNA(@"button_courseware_selected") action:@selector(coursewareButtonClick:) selected:NO];
                button;
            });
        }
        
        NSString *iphoneTypeString = [TKIPhoneTypeString checkIPhoneType];
        // 花名册
        _memberButton = ({
            UIButton *button = [self returnButtonWithFrame:CGRectMake(CGRectGetMinX(self.coursewareButton.frame) - brushHeight - 10, 0, brushHeight, brushHeight) imageName:ThemeKPNA(@"button_name_default") selectImageName:ThemeKPNA(@"button_name_selected") action:@selector(memberButtonClick:) selected:NO];
            button.showRedDot = NO;
            if ([iphoneTypeString containsString:@"iPhone 5"]) {
                button.redDotRadius = button.redDotRadius * 0.8;
                button.redDotOffset = CGPointMake(-5, 5);
            }else if ([iphoneTypeString containsString:@"iPad"]) {
                button.redDotRadius = button.redDotRadius * 1.2;
                button.redDotOffset = CGPointMake(-10, 12);
            }else {
                button.redDotOffset = CGPointMake(-6, 6);
            }
            button;
        });
        
        //工具
        _toolsButton = ({
            UIButton *button = [self returnButtonWithFrame:CGRectMake(CGRectGetMinX(self.memberButton.frame) - brushHeight - 10, 0, brushHeight, brushHeight) imageName:ThemeKP(@"button_tools_default") selectImageName:ThemeKP(@"button_tools_selected") action:nil selected:NO];
            [button addTarget:self action:@selector(toolsButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
            button;
        });
        // 时间
        if ([TKEduSessionHandle shareInstance].iRoomProperties.iUserType == UserType_Student) {
            _timeView = [[TKClassTimeView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.handButton.frame)-100-40, topY, 100, CGRectGetHeight(self.returnImageView.frame))];
        }else {
            _timeView = [[TKClassTimeView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.beginAndEndClassButton.frame)-100-40, topY, 100, CGRectGetHeight(self.returnImageView.frame))];
        }
        
        
        
        [self addSubview:_timeView];

        
        [self setTime:0];// 显示时间为00:00:00
        
        if ([TKEduSessionHandle shareInstance].iRoomProperties.iUserType == UserType_Student) {// 学生
            
            _coursewareButton.hidden = YES;
            _controlButton.hidden = YES;
            _memberButton.hidden = YES;
            _toolsButton.hidden = YES;
            
        }

        //当前时间
        _classTimerLabel = [[UILabel alloc]init];
//        [self addSubview:_classTimerLabel];
        _classTimerLabel.hidden = YES;

        _classTimerLabel.frame = CGRectMake(self.coursewareButton.x -100-40, topY, 100, self.returnImageView.height);
        _classTimerLabel.sakura.textColor(ThemeKP(@"titleColor"));
        _classTimerLabel.textAlignment = NSTextAlignmentLeft;
        
        
        //时间图片
        _classTimerImageView = [[UIImageView alloc]init];
//        [self addSubview:_classTimerImageView];
        _classTimerImageView.hidden = YES;
        
        _classTimerImageView.frame = CGRectMake(CGRectGetMinX(self.classTimerLabel.frame)-20, topY, 20, CGRectGetHeight(self.returnImageView.frame));
        _classTimerImageView.contentMode = UIViewContentModeCenter;
        _classTimerImageView.sakura.image(ThemeKP(@"common_icon_clock"));
        
        //标题
        _titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(_returnImageView.rightX,
                                                                 topY,
                                                                 CGRectGetMinX(_classTimerImageView.frame)-CGRectGetMaxX(self.returnImageView.frame),
                                                                 CGRectGetHeight(self.returnImageView.frame))];
        
        _titleLabel.sakura.textColor(ThemeKP(@"titleColor"));
        [self addSubview:_titleLabel];
        
        //返回按钮
        _leaveClass = [[UIButton alloc]init];
        _leaveClass.frame = CGRectMake(0, 0, 50., CGRectGetHeight(self.returnImageView.frame));
        _leaveClass.backgroundColor = [UIColor clearColor];
        [_leaveClass addTarget:self action:@selector(leaveClass:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:_leaveClass];
        if([TKEduSessionHandle shareInstance].isPlayback){
            _classTimerImageView.hidden = YES;
            _classTimerLabel.hidden = YES;
             _timeView.hidden = YES;
            _beginAndEndClassButton.hidden = YES;
            _handButton.hidden = YES;
            _handHasVideoButton.hidden = YES;
            _coursewareButton.hidden = YES;//课件库
            _memberButton.hidden = YES;//成员列表
        }

        [self refreshUI];
        
        
    }
    
    return self;
}

- (void)setShowRedDot:(BOOL)showRedDot {
    _memberButton.showRedDot = showRedDot;
}

#pragma mark - 课件库按钮的点击事件
- (void)coursewareButtonClick:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    if (self.showCoursewareViewBlock) {
        self.showCoursewareViewBlock(sender.selected);
    }
}
#pragma mark - 摄像头切换
- (void)swapFrontAndBackCameras {

    [[TKEduSessionHandle shareInstance] sessionHandleSelectCameraPosition: _isFrontCamera];
    _isFrontCamera = !_isFrontCamera;
}

#pragma mark - 成员按钮的点击事件
- (void)memberButtonClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    
    if(self.showMemberViewBlock){
        self.showMemberViewBlock(sender.selected);
    }
}

#pragma mark - 信息按钮的点击事件
- (void)messageButtonClick:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    if (self.showChatViewBlock) {
        self.showChatViewBlock(sender.selected);
    }
}


#pragma mark - 控制按钮的点击事件
- (void)controlButtonClick:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    if (self.showControlViewBlock) {
        self.showControlViewBlock(sender.selected);
    }
}

#pragma mark - 图片选择按钮的点击事件
- (void)picButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.showPictureViewBlock) {
        self.showPictureViewBlock(sender.selected);
    }
}

#pragma mark - 工具按钮的点击事件
- (void)toolsButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.showToolsViewBlock) {
        self.showToolsViewBlock(sender.selected);
    }
    [[TKEduSessionHandle shareInstance].whiteBoardManager showToolbox:sender.selected];
}


#pragma mark - 工具按钮的更新
- (void)updateView:(NSDictionary *)message{
    
    BOOL toolbox = [TKUtil getBOOValueFromDic:message Key:@"toolbox"];
    self.toolsButton.selected = toolbox;
    
}


#pragma mark - 相机按钮的点击事件
- (void)camareButtonClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    
    //    if (sender.selected) {
    //
    //        [self.uploadView showOnView:sender];
    //
    //    }else{
    //
    //        [self.uploadView dissMissView];
    //
    //    }
    
    if (self.showCamareViewBlock) {
        self.showCamareViewBlock(sender.selected);
    }
    
}


- (TKUploadView *)uploadView{
    if (!_uploadView) {
        self.uploadView = [[TKUploadView alloc]init];
        __weak TKNewNavView *nav = self;
        
        self.uploadView.dismiss = ^{
            nav.camareButton.selected = NO;
        };
    }
    return _uploadView;
}







- (UIButton *)returnButtonWithFrame:(CGRect)frame imageName:(NSString *)imageName selectImageName:(NSString *)selectImageName action:(SEL)action selected:(BOOL)selected{
    
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:button];
    button.frame = frame;
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    if (imageName) {
        
        button.sakura.image(imageName,UIControlStateNormal);
    }
    if (selectImageName) {
        
        button.sakura.image(selectImageName,UIControlStateSelected);
    }
    if (action) {
        [button addTarget:self action:action forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return button;
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
    
    
}

#pragma mark - 上下课逻辑
- (void)beginAndEndClassButtonClick:(UIButton *)sender{
    
    if ([TKEduSessionHandle shareInstance].localUser.role == UserType_Teacher || [TKEduSessionHandle shareInstance].localUser.role == UserType_Patrol) {
        
        
        sender.selected = [TKEduSessionHandle shareInstance].isClassBegin;
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:tkClassBeginNotification
                                                            object:@{@"classBegin":@(!sender.selected)}];
        
        if (!sender.selected) {//
            
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
            }else{
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
            tk_weakify(self);
            alert.rightBlock = ^{
                
                
                weakSelf.beginAndEndClassButton.selected = NO;
//                _classTimerLabel.text = @"";
//                _classTimerImageView.hidden = YES;
                [weakSelf setTime:0];
                
                if (weakSelf.classoverBlock) {
                    weakSelf.classoverBlock();
                }
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
}
#pragma mark - 举手中
- (void)handTouchDown:(UIButton *)sender{
    
    if ([TKEduSessionHandle shareInstance].iRoomProperties.iUserType != UserType_Student || [TKEduSessionHandle shareInstance].localUser.publishState == 0) {
        return;
    }
    
    [[TKEduSessionHandle shareInstance] sessionHandleChangeUserProperty:[TKEduSessionHandle shareInstance].localUser.peerID TellWhom:sTellAll Key:sRaisehand Value:@(YES) completion:nil];
    
}
#pragma mark - 取消举手
- (void)handTouchUp:(UIButton *)sender{
    
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
    
    
//    _classTimerImageView.hidden = NO;
//    _classTimerLabel.hidden = NO;
//
//    _classTimerLabel.text = [NSString stringWithFormat:@" %@:%@:%@",H,M,S];
    
    _timeView.hidden = NO;
    [_timeView setClassTime:time];
    
}

#pragma mark - UI界面的刷新
- (void)refreshUI{
    
    {//按钮显示状态
        if ([TKEduSessionHandle shareInstance].localUser.role == UserType_Patrol) {//巡课没有画笔权，资源库，课件，控制；
            
            _camareButton.hidden = YES;
            _picButton.hidden = YES;
            _toolsButton.hidden = YES;
            
            _coursewareButton.frame = CGRectMake(FrameX(_beginAndEndClassButton), 0, brushHeight, brushHeight);
            _memberButton.frame =CGRectMake(FrameX(_coursewareButton), 0, brushHeight, brushHeight);
            
        }
        
        if (![TKEduSessionHandle shareInstance].isClassBegin) {//未开始上课
            //  不显示画笔、工具、控制按钮
            _camareButton.hidden = YES;
            _picButton.hidden = YES;
            _toolsButton.hidden = YES;
            _controlButton.hidden = YES;
            _handButton.hidden = YES;
            
            _cameraSwitchBtn.frame = CGRectMake(FrameX(_beginAndEndClassButton), 0, brushHeight, brushHeight);
            _coursewareButton.frame = CGRectMake(FrameX(_cameraSwitchBtn), 0, brushHeight, brushHeight);
            _memberButton.frame = CGRectMake(FrameX(_coursewareButton), 0, brushHeight, brushHeight);
            _toolsButton.frame = CGRectMake(FrameX(_memberButton), 0, brushHeight, brushHeight);
            _timeView.frame = CGRectMake(FrameX(_toolsButton) - 100 - 40, 0, brushHeight, brushHeight);
            
        }else{//已经上课
            //  一对多 角色是学生
            if([TKRoomManager instance].localUser.role == UserType_Student){
                _handButton.hidden = NO;
                NSDictionary *dic = [TKRoomManager instance].localUser.properties;
                BOOL candrawDisable = ![TKUtil getBOOValueFromDic:dic Key:@"candraw"];
                _picButton.hidden = candrawDisable;
                _camareButton.hidden = candrawDisable;
                
            }
            
            //  一对多 角色是老师
            if ([TKEduSessionHandle shareInstance].localUser.role == UserType_Teacher) {
                
                _controlButton.hidden = NO;
                _toolsButton.hidden = NO;
                _coursewareButton.frame = CGRectMake(FrameX(_controlButton), 0, brushHeight, brushHeight);
                _memberButton.frame = CGRectMake(FrameX(_coursewareButton), 0, brushHeight, brushHeight);
                _toolsButton.frame = CGRectMake(FrameX(_memberButton), 0, brushHeight, brushHeight);
                _timeView.frame = CGRectMake(FrameX(_toolsButton) - 100 - 40, 0, brushHeight, brushHeight);
                
            }
          
        }
    }
    // home键 更改状态
    if([TKEduSessionHandle shareInstance].roomMgr.inBackground) {
        _picButton.selected = NO;
        [[TKEduSessionHandle shareInstance].whiteBoardManager choosePen:_picButton.selected];
        
    }
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
    
}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)destoy{
    
    [self.uploadView dissMissView];
    
}
@end
