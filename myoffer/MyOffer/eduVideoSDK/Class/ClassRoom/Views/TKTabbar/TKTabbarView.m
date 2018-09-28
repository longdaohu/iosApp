 //
//  TKTabbarView.m
//  EduClass
//
//  Created by lyy on 2018/4/19.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import "TKTabbarView.h"
#import "TKEduSessionHandle.h"
#import "TKEduRoomProperty.h"
#import "TKDocumentControlView.h"
#import "TKUploadView.h"
#import "TKIPhoneTypeString.h"

#define ThemeKP(args) [@"ClassRoom.TKTabbarView." stringByAppendingString:args]
#define ButtonSpace 10
#define FrameX(target) CGRectGetMinX(target.frame) - brushHeight - (ButtonSpace)

@interface TKTabbarView()
{
    CGFloat brushHeight;
}
@property (nonatomic, assign) RoomType roomType;

@property (nonatomic, strong) TKUploadView *uploadView;//文档上传视图（拍摄上传、相册上传）
@end

@implementation TKTabbarView

- (instancetype)initWithFrame:(CGRect)frame roomType:(RoomType)roomType{
    
    if (self = [super initWithFrame:frame]) {
        
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshCanDraw:) name:[NSString stringWithFormat:@"%@%@",sRaisehand,[TKEduSessionHandle shareInstance].localUser.peerID] object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCanDraw:) name:@"TKTabbarViewHideICON" object:nil];
        
        _roomType = roomType;
        
        brushHeight = [TKUtil isiPhoneX]?self.frame.size.height-17:self.frame.size.height;
        
        // 左侧
        //画笔
        _brushButton = ({
            
            UIButton *button = [self returnButtonWithFrame:CGRectMake(20, 0, brushHeight, brushHeight) imageName:nil selectImageName:nil action:@selector(brushButtonClick:) selected:NO];
            button;
            
        });
        
        //相机
        _camareButton = ({
            UIButton *button = [self returnButtonWithFrame:CGRectMake(brushHeight+30, 0, brushHeight, brushHeight) imageName:ThemeKP(@"common_camare_regular") selectImageName:ThemeKP(@"common_camare_selected") action:@selector(camareButtonClick:) selected:NO];
            button.hidden = YES;
            button;
        });
        
        // 右侧按钮
        //消息
        _messageButton = ({
            UIButton *button = [self returnButtonWithFrame:CGRectMake(self.frame.size.width-brushHeight-20, 0, brushHeight, brushHeight) imageName:ThemeKP(@"button_messagel_default") selectImageName:ThemeKP(@"button_message_selected") action:@selector(messageButtonClick:) selected:NO];
            button.badgeOffset = CGPointMake(-3, 5);
            button.showRedDot = NO;
            
            button;
        });
  
        
        //教师端 1v1模式下没有控制按钮
        if (roomType) {
            //控制 CGRectGetMinX(_messageButton.frame)-brushHeight-10
            _controlButton = ({
                UIButton *button = [self returnButtonWithFrame:CGRectMake(FrameX(_messageButton), 0, brushHeight, brushHeight) imageName:ThemeKP(@"button_control_default") selectImageName:ThemeKP(@"button_contro_selected") action:@selector(controlButtonClick:) selected:NO];
                button;
            });
            
        }
        
        CGFloat toolsX;
        if (_controlButton) {
            toolsX = FrameX(_controlButton);
        }else{
            toolsX = FrameX(_messageButton);
        }
        
        //工具
        _toolsButton = ({
            UIButton *button = [self returnButtonWithFrame:CGRectMake(toolsX, 0, brushHeight, brushHeight) imageName:ThemeKP(@"button_tools_default") selectImageName:ThemeKP(@"button_tools_selected") action:nil selected:NO];
            [button addTarget:self action:@selector(toolsButtonClick:) forControlEvents:(UIControlEventTouchUpInside)];
            button;
        });
        
      
        //课件库
        _coursewareButton = ({
            UIButton *button = [self returnButtonWithFrame:CGRectMake(FrameX(_toolsButton), 0, brushHeight, brushHeight) imageName:ThemeKP(@"button_courseware_default") selectImageName:ThemeKP(@"button_courseware_selected") action:@selector(coursewareButtonClick:) selected:NO];
            button;
        });
        
        // 成员
        if ([TKEduSessionHandle shareInstance].iRoomProperties.iRoomType != RoomType_OneToOne) {
            
        }
        
        NSString *iphoneTypeString = [TKIPhoneTypeString checkIPhoneType];
        
        _memberButton = ({
            UIButton *button = [self returnButtonWithFrame:CGRectMake(FrameX(_coursewareButton), 0, brushHeight, brushHeight) imageName:ThemeKP(@"button_name_default") selectImageName:ThemeKP(@"button_name_selected") action:@selector(memberButtonClick:) selected:NO];
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

        //文档控制按钮
        _pageControlView = ({
            TKDocumentControlView *view= [[TKDocumentControlView alloc]init];
            [self addSubview:view];
            view.frame = CGRectMake(CGRectGetMaxX(_camareButton.frame)+brushHeight, 0,CGRectGetMinX(_coursewareButton.frame)-CGRectGetMaxX(_camareButton.frame)-brushHeight*3,brushHeight);
            view;
        });
        
        [self refreshUI];
    }
    return self;
}

- (void)setShowRedDot:(BOOL)showRedDot {
    _memberButton.showRedDot = showRedDot;
}

//- (void)setIRoomUser:(TKRoomUser *)iRoomUser {
//    _iRoomUser = iRoomUser;
//    if (iRoomUser) {
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshRaiseHandUI:) name:[NSString stringWithFormat:@"%@%@",sRaisehand,iRoomUser.peerID] object:nil];
//    }else {
//        //删除前一个
//        [[NSNotificationCenter defaultCenter]removeObserver:self name:[NSString stringWithFormat:@"%@%@",sRaisehand,_iRoomUser.peerID] object:nil];
//    }
//}


//#pragma mark - 状态改变 接收到的通知
//-(void)refreshRaiseHandUI:(NSNotification *)aNotification {
//
//    NSDictionary *dict = (NSDictionary *)aNotification.object;
//    BOOL tHandsUpImageShow = ([[dict objectForKey:sRaisehand]boolValue]);
//    _memberButton.showRedDot = tHandsUpImageShow;
//}

- (void)brushButtonClick:(UIButton *)sender{
    
    sender.selected = !sender.selected;
   
    [[TKEduSessionHandle shareInstance].whiteBoardManager choosePen:sender.selected];
    
}
- (void)camareButtonClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        
        [self.uploadView showOnView:sender];
        
    }else{
        
        [self.uploadView dissMissView];
        
    }
    
}
- (void)coursewareButtonClick:(UIButton *)sender{
    
   sender.selected = !sender.selected;
    
    if (self.showCoursewareViewBlock) {
        self.showCoursewareViewBlock(sender.selected);
    }
}
- (void)memberButtonClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    
    if(self.showMemberViewBlock){
        self.showMemberViewBlock(sender.selected);
    }
}
- (void)messageButtonClick:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    if (self.showChatViewBlock) {
        self.showChatViewBlock(sender.selected);
    }
}
- (void)controlButtonClick:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    if (self.showControlViewBlock) {
        self.showControlViewBlock(sender.selected);
    }
}

//工具箱
- (void)toolsButtonClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (self.showToolsViewBlock) {
        self.showToolsViewBlock(sender.selected);
    }
    [[TKEduSessionHandle shareInstance].whiteBoardManager showToolbox:sender.selected];
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

- (TKUploadView *)uploadView{
    if (!_uploadView) {
        self.uploadView = [[TKUploadView alloc]init];
        __weak TKTabbarView * tab = self;
        
        self.uploadView.dismiss = ^{
            tab.camareButton.selected = NO;
        };
    }
    return _uploadView;
}

- (void)refreshUI{
   
    //显示未读消息
    NSInteger unReadNum = [TKEduSessionHandle shareInstance].unReadMessagesArray.count;
    if (unReadNum>0) {
        
        NSString *unread;
        if (unReadNum>99) {
            unread = @"99+";
        }else{
            unread = [NSString stringWithFormat:@"%ld",(long)unReadNum];
        }
        
        self.messageButton.badgeValue = unread;
        
    }else{
        self.messageButton.badgeValue = nil;
    }
    
    
    {//按钮显示状态
        //巡课没有画笔权，资源库，课件，控制；
        if ([TKEduSessionHandle shareInstance].localUser.role == UserType_Patrol) {
            _brushButton.hidden = YES;
            _toolsButton.hidden = YES;
            _controlButton.hidden = YES;
            _memberButton.hidden = NO;
            _coursewareButton.hidden = NO;
            _messageButton.hidden = NO;
            
        }
        //如果角色是学生需隐藏一下按钮
        if([TKEduSessionHandle shareInstance].localUser.role == UserType_Student){
            _coursewareButton.hidden = YES;
            _toolsButton.hidden = YES;
            _controlButton.hidden = YES;
            _memberButton.hidden = YES;
            _messageButton.hidden = NO;
        }
        //如果角色是老师
        if([TKEduSessionHandle shareInstance].localUser.role == UserType_Teacher){
            _memberButton.hidden = NO;
            _coursewareButton.hidden = NO;
            _toolsButton.hidden = NO;
            _controlButton.hidden = NO;
            _messageButton.hidden = NO;
        }
        
        
        if (![TKEduSessionHandle shareInstance].isClassBegin) {
            //未开始上课  不显示画笔、工具、控制按钮
            _brushButton.hidden = YES;
            _toolsButton.hidden = YES;
            _controlButton.hidden = YES;
            
            _coursewareButton.frame = CGRectMake(FrameX(_messageButton), 0, brushHeight, brushHeight);
            _memberButton.frame =CGRectMake(FrameX(_coursewareButton), 0, brushHeight, brushHeight);
            
        }else{
            
            if ([TKEduSessionHandle shareInstance].localUser.role == UserType_Teacher) {//如果已经开始上课角色是老师需要显示画笔
                _brushButton.hidden = NO;
                _toolsButton.hidden = NO;
                
            }else if([TKRoomManager instance].localUser.role == UserType_Student){
                
                _toolsButton.hidden = YES;
                NSDictionary *dic = [TKRoomManager instance].localUser.properties;
                BOOL candrawDisable = ![TKUtil getBOOValueFromDic:dic Key:@"candraw"];
                
                if (candrawDisable) {
                    _brushButton.selected = NO;
                    if ( _uploadView) {
                        
                        [_uploadView dissMissView];
                        
                        _camareButton.selected = NO;
                    }
                }
                _brushButton.hidden = candrawDisable;
                _camareButton.hidden = candrawDisable;
                
            }
            //  一对多 角色是老师
            if (_roomType && [TKEduSessionHandle shareInstance].localUser.role == UserType_Teacher) {
               
                _controlButton.hidden = NO;
                
                _controlButton.frame = CGRectMake(FrameX(_messageButton), 0, brushHeight, brushHeight);

                _toolsButton.frame = CGRectMake(FrameX(_controlButton), 0, brushHeight, brushHeight);
                
            }else{
                _toolsButton.frame = CGRectMake(FrameX(_messageButton), 0, brushHeight, brushHeight);
                
            }
            
            
            if ([TKEduSessionHandle shareInstance].localUser.role == UserType_Patrol) {
                _coursewareButton.frame = CGRectMake(FrameX(_messageButton), 0, brushHeight, brushHeight);
                _memberButton.frame =CGRectMake(FrameX(_coursewareButton), 0, brushHeight, brushHeight);
            }else {
                _coursewareButton.frame = CGRectMake(FrameX(_toolsButton), 0, brushHeight, brushHeight);
                _memberButton.frame =CGRectMake(FrameX(_coursewareButton), 0, brushHeight, brushHeight);
            }

        }
    }
    
    // home键 更改状态
    if([TKEduSessionHandle shareInstance].roomMgr.inBackground) {
        _brushButton.selected = NO;
        [[TKEduSessionHandle shareInstance].whiteBoardManager choosePen:_brushButton.selected];

    }
}

- (void)updateView:(NSDictionary *)message{
  
    BOOL toolbox = [TKUtil getBOOValueFromDic:message Key:@"toolbox"];
    self.toolsButton.selected = toolbox;
    
    //画笔状态在按钮中直观体现
    if ([message objectForKey:@"chooseType"]) {

        NSString *chooseType = message[@"chooseType"];
        
        NSString *imageName = [TKHelperUtil returnChooseTypeImageName:chooseType isSelect:NO];
        NSString *selectImageName = [TKHelperUtil returnChooseTypeImageName:chooseType isSelect:YES];
        
        self.brushButton.sakura.image(imageName,UIControlStateNormal);
        self.brushButton.sakura.image(selectImageName,UIControlStateSelected);
       
    }
    
    [self.pageControlView updateView:message];
}

- (void)refreshCanDraw:(NSNotification *)aNotification{
    
    NSDictionary *tDic = (NSDictionary *)aNotification.object;
    
    BOOL tDrawImageShow = [[tDic objectForKey:sCandraw]boolValue];
    
   
    _brushButton.hidden = !tDrawImageShow;
    
    _camareButton.hidden = !tDrawImageShow;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)hideAllButton:(BOOL)hide {
    
    if ([TKEduSessionHandle shareInstance].localUser.role == UserType_Teacher) {
        
        _toolsButton.hidden      =
        _controlButton.hidden    =
        _messageButton.hidden    =
        _coursewareButton.hidden =
        _memberButton.hidden     = hide;
    }
    
    self.pageControlView.wbControlView.fullScreenButton.selected = hide;
    //如果是学生需要隐藏掉全屏按钮
    if([TKEduSessionHandle shareInstance].localUser.role != UserType_Teacher && [TKEduSessionHandle shareInstance].isClassBegin && [[TKEduSessionHandle shareInstance].roomMgr getRoomConfigration].coursewareFullSynchronize) {
        self.pageControlView.wbControlView.fullScreenButton.hidden = [TKEduSessionHandle shareInstance].iIsFullState;
       
    }
    
}

- (void)destoy{
    
    [self.uploadView dissMissView];
    [self.pageControlView destoy];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
