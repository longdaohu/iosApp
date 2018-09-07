//
//  TKChatListView.m
//  EduClass
//
//  Created by admin on 2018/6/6.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import "TKOldChatListView.h"

#import "TKOldChatToolView.h"
#import "TKOldChatListTableViewCell.h"
#import "TKEduSessionHandle.h"

#import "TKMessageTableViewCell.h"//
#import "TKChatSendView.h"
#import "TKOldChatListTitleView.h"

#define ThemeKP(args) [@"ClassRoom.TKChatViews." stringByAppendingString:args]

static NSString *const sMessageCellIdentifier           = @"messageCellIdentifier";
static NSString *const sStudentCellIdentifier           = @"studentCellIdentifier";
static NSString *const sDefaultCellIdentifier           = @"defaultCellIdentifier";

#define chatToolHeight 44
#define margin 5

@interface TKOldChatListView ()<UITableViewDelegate,UITableViewDataSource,TKOldChatToolViewDelegate>

@property (nonatomic, strong) NSTimer *chatTimer;
@property (nonatomic, assign) BOOL chatTimerFlag;
@property (nonatomic, strong) NSString *lastSendChatTime;
@property (nonatomic, assign) CGFloat keyboardHeight;

@property (nonatomic, strong) UITableView *iChatTableView; // 聊天tableView
@property (nonatomic, strong) TKOldChatListTitleView *tableTitleView;
@property (nonatomic, strong) NSArray  *iMessageList;//聊天列表
@property (nonatomic, strong) TKOldChatToolView *toolView;//聊天输入工具条
@property (nonatomic, strong) TKChatSendView *keyboardView;//聊天输入工具条
@property (nonatomic, strong) UIButton *xButton; // 全体禁言
// 父类属性
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIView *contentView;

@end
@implementation TKOldChatListView

- (instancetype)initWithFrame:(CGRect)frame userRole:(UserType)role{
    if (self = [super initWithFrame:frame]) {
        
        // =======
        //背景图片
        if (!self.backImageView) {
            self.backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            self.backImageView.sakura.image(ThemeKP(@"chatBackgroundColor"));
            self.backImageView.userInteractionEnabled = YES;
        }
        
        [self addSubview:self.backImageView];
        
        
        
        _contentView = [[UIView alloc]init];
//        _contentView.frame = CGRectMake(CGRectGetWidth(_backImageView.frame)*0.06,
//                                        self.height*0.14,
//                                        CGRectGetWidth(_backImageView.frame)*0.88,
//                                        CGRectGetHeight(_backImageView.frame)*0.8);
        
        _contentView.frame = CGRectMake(5,
                                        5,
                                        _backImageView.width  - 10,
                                        _backImageView.height - 10);
        [self.backImageView addSubview:_contentView];
        // =======
        
        _iMessageList = [[TKEduSessionHandle shareInstance] messageList];
        self.keyboardHeight = 0;
        
        //巡课不允许发送聊天消息
        if (role != UserType_Patrol) {
            [self loadChatTool:(UserType)role];
        }
        
        [self loadChatView];
        [self loadNotification];
        [self reloadData];
        
        [self judgeBan];
    }
    return self;
}
- (void)judgeBan{
    
    if ([TKUtil getBOOValueFromDic:[TKEduSessionHandle shareInstance].localUser.properties Key:sDisablechat]) {
        self.toolView.userInteractionEnabled = NO;
        self.toolView.inputField.placehoder = MTLocalized(@"Prompt.BanChat");
    }else{
        
        self.toolView.userInteractionEnabled = YES;
        self.toolView.inputField.placehoder = MTLocalized(@"Say.say");
    }
    
}
- (void)banChat:(NSNotification *)notification{
    
    NSDictionary *message = notification.object;
    BOOL isBanSpeak = [TKUtil getBOOValueFromDic:message Key:@"isBanSpeak"];
    
    if ([TKEduSessionHandle shareInstance].localUser.role == UserType_Teacher) {
        //如果是老师需要设置全体禁言按钮
        if ([TKEduSessionHandle shareInstance].isAllShutUp) {
            _xButton.selected = YES;
        }
        
    }else{
    
        if (isBanSpeak) {
            self.toolView.userInteractionEnabled = NO;
            self.toolView.inputField.placehoder = MTLocalized(@"Prompt.BanChat");
        }else{
            
            self.toolView.userInteractionEnabled = YES;
            self.toolView.inputField.placehoder = MTLocalized(@"Say.say");
        }
    }
}

- (void)loadChatTool:(UserType)role{
    // 右下方 - 全员禁言
    CGFloat x = 0;
    CGFloat y = self.contentView.height-chatToolHeight;
    CGFloat w = self.contentView.width;
    
    if (role == UserType_Teacher) {
        
        _xButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _xButton.sakura.image(ThemeKP(@"shutup_default"),UIControlStateNormal);
        _xButton.sakura.image(ThemeKP(@"shutup_press"),  UIControlStateSelected);

        _xButton.frame = CGRectMake(x,
                                    y + 10,
                                    chatToolHeight - 10 ,
                                    chatToolHeight - 10 );
        
        //        _xButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.backImageView addSubview:_xButton];
        [_xButton addTarget:self action:@selector(shutUpAction:) forControlEvents:UIControlEventTouchUpInside];
        
        x = _xButton.rightX;
        w = w - _xButton.width;
        
        [self.contentView addSubview:_toolView];
    }
    // 输入框
    _toolView = ({
        
        
        TKOldChatToolView *toolView = [[TKOldChatToolView alloc] initWithFrame:CGRectMake(x,
                                                                                          y,
                                                                                          w,
                                                                                          chatToolHeight)
                                                                    isDistance:false];
        toolView.delegate = self;

        toolView;
    });
    
    
    //巡课不允许发送聊天消息
    if ([TKEduSessionHandle shareInstance].localUser.role != UserType_Patrol) {
        [self.contentView addSubview:_toolView];
    }

}
- (void)loadChatView {
    // 房间号
    {
        _tableTitleView = [[TKOldChatListTitleView alloc] initWithFrame: CGRectMake(0,
                                                                                    0,
                                                                                    self.contentView.width,
                                                                                    32 * Proportion)];
        [self.contentView addSubview:_tableTitleView];
    }
    //聊天
    {
        _iChatTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,
                                                                       32 * Proportion ,
                                                                       self.contentView.width,
                                                                       self.contentView.height-chatToolHeight-margin*2- _tableTitleView.height)
                                                      style:UITableViewStylePlain];
        _iChatTableView.backgroundColor = [UIColor clearColor];
        _iChatTableView.separatorColor  = [UIColor clearColor];
        _iChatTableView.showsHorizontalScrollIndicator = NO;
        

        
        _iChatTableView.delegate   = self;
        _iChatTableView.dataSource = self;
        _iChatTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
        [_iChatTableView registerClass:[TKMessageTableViewCell class] forCellReuseIdentifier:sMessageCellIdentifier];
        [_iChatTableView registerClass:[TKOldChatListTableViewCell class] forCellReuseIdentifier:sStudentCellIdentifier];
        [self.contentView addSubview:_iChatTableView];
        
        
        //初始化点击手势
        UITapGestureRecognizer *tagGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureTranslation:)];
        tagGesture.numberOfTapsRequired = 1;
        [_iChatTableView addGestureRecognizer:tagGesture];
        
    }
    
}
#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _iMessageList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat tHeight = 0;
    TKChatMessageModel *tMessageModel = [_iMessageList objectAtIndex:indexPath.row];
    
    switch (tMessageModel.iMessageType) {
        case MessageType_Message:
        {
            
            tHeight = 30;
            
        }
            break;
            
        case MessageType_OtherUer:
        case MessageType_Teacher:
        case MessageType_Me:
            
        {
            
//            CGFloat tViewCap             = 10 *Proportion;
            CGFloat tContentWidth        = CGRectGetWidth(_iChatTableView.frame);
            CGFloat tTimeLabelHeigh      = 20 * Proportion;
            CGFloat tTranslateLabelHeigh = 25 * Proportion;
            CGFloat messageMAXWidth      = tContentWidth - 10. - tTranslateLabelHeigh - 10.;
            
            CGSize messageSize = [TKOldChatListTableViewCell sizeFromAttributedString:tMessageModel.iMessage withLimitWidth:messageMAXWidth + 22 Font:TKFont(15)];
            messageSize = CGSizeMake(messageSize.width , messageSize.height + 10);
            
            CGSize transSize = CGSizeZero;
            if (tMessageModel.iTranslationMessage.length > 0) {
                CGFloat transTextMAXWidth    = tContentWidth - 10;

                transSize = [TKOldChatListTableViewCell sizeFromText:tMessageModel.iTranslationMessage withLimitWidth:transTextMAXWidth Font:TKFont(15)];
                transSize = CGSizeMake(transSize.width , transSize.height + 20);
            }
            
            tHeight = messageSize.height + transSize.height + tTimeLabelHeigh ;
            
            
        }
            break;
        default:
            break;
    }
    
    if (iPad) {
        return tHeight + 20;
    }
    return tHeight + 10; // +10 Nick 上下边距。
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TKChatMessageModel *tMessageModel = [_iMessageList objectAtIndex:indexPath.row];
    
    switch (tMessageModel.iMessageType) {
            
            // 消息
        case MessageType_Message:
        {
            TKMessageTableViewCell *tCell = [tableView dequeueReusableCellWithIdentifier:sMessageCellIdentifier forIndexPath:indexPath];
            tCell.selectionStyle = UITableViewCellSelectionStyleNone;
//            tCell.iMessageText = tMessageModel.iMessage;
            
            tCell.iMessageText = [NSString stringWithFormat:@"%@ %@",tMessageModel.iTime,tMessageModel.iMessage];
            [tCell resetView];
            
            [tCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return tCell;
        }
            break;
        case MessageType_OtherUer:
            
        case MessageType_Teacher:
        case MessageType_Me:
        {
            TKOldChatListTableViewCell* tCell =[tableView dequeueReusableCellWithIdentifier:sStudentCellIdentifier forIndexPath:indexPath];
            
            tCell.chatModel = tMessageModel;
//            tCell.backgroundColor = UIColor.redColor;
//           tCell.sakura.backgroundColor(ThemeKP(@"chatCellBackgoundColor"));
            tCell.layer.masksToBounds = YES;
            tCell.layer.cornerRadius = 5;
            [tCell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            return tCell;
            
        }
            break;
            
        default:
            
            break;
    }
    
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sDefaultCellIdentifier];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
    
}
#pragma mark - 全员禁言
- (void)shutUpAction:(UIButton *)btn {
    
    BOOL abool = !btn.selected;
    NSDictionary *dict = @{sDisablechat: @(abool)};
    [[TKEduSessionHandle shareInstance] sessionHandleChangeUserPropertyByRole:@[@(UserType_Student)]
                                                                     tellWhom:sTellAll
                                                                     property:dict
                                                                   completion:nil];
    // 信令
    if (abool) {
        [[TKEduSessionHandle shareInstance] sessionHandlePubMsg:sEveryoneBanChat ID:sEveryoneBanChat To:sTellAll Data:@{} Save:true AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
        
    }
    else {
        [[TKEduSessionHandle shareInstance] sessionHandleDelMsg:sEveryoneBanChat ID:sEveryoneBanChat To:sTellAll Data:@{} completion:nil ];
    }
    
    
    
    
    btn.selected = abool;
    
}
#pragma mark - 翻译
- (void)tapGestureTranslation:(UITapGestureRecognizer *)gesture {
    
    //获得当前手势触发的在UITableView中的坐标
    CGPoint location = [gesture locationInView:_iChatTableView];
    
    //获得当前坐标对应的indexPath
    NSIndexPath *indexPath = [_iChatTableView indexPathForRowAtPoint:location];
    
    // 改变cell 按钮状态
    TKOldChatListTableViewCell *tCell = [_iChatTableView cellForRowAtIndexPath:indexPath];
   
    
    if (_iMessageList.count <= indexPath.row) {
        return;
    }
   
    TKChatMessageModel *tMessageModel = [_iMessageList objectAtIndex:indexPath.row];
    if (tMessageModel.iMessageType == MessageType_Message) {
        return;
    }
    [tCell.iTranslationButton setSelected:YES];
    
    
    switch (tMessageModel.iMessageType) {
        case MessageType_Message:
        {
            
        }
            break;
        case MessageType_OtherUer:
        case MessageType_Teacher:
        case MessageType_Me:
        {
            
            __weak typeof(self)weakSelf = self;
            [TKEduNetManager translation:tMessageModel.iMessage aTranslationComplete:^int(id  _Nullable response, NSString * _Nullable aTranslationString) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                tMessageModel.iTranslationMessage = aTranslationString;
                [[TKEduSessionHandle shareInstance] addTranslationMessage:tMessageModel];
                [strongSelf reloadData];
                return 0;
            }];
            
        }
            break;
            
        default:
            
            break;
    }
    
}


- (void)messageReceived:(NSString *)message
                 fromID:(NSString *)peerID
              extension:(NSDictionary *)extension{
    /*
     
     {
     msg = "\U963f\U9053\U592b";
     type = 0;
     }
     
     */
    
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
    TKRoomUser *user = [[TKEduSessionHandle shareInstance].roomMgr getRoomUserWithUId:peerID];
    NSString *msg = [tDataDic objectForKey:@"msg"];
    TKLog(@"------ type:%@ MessageReceived:%@ userName:(%@)",type,msg,user.nickName);
    NSString *tMyPeerId = [TKEduSessionHandle shareInstance].localUser.peerID;
    
    //自己发送的收不到
    if (!user) {
        user = [TKEduSessionHandle shareInstance].localUser;
    }
    
    BOOL isMe = [user.peerID isEqualToString:tMyPeerId];
    BOOL isTeacher = user.role == UserType_Teacher?YES:NO;
    
    MessageType tMessageType = (isMe)?MessageType_Me:(isTeacher?MessageType_Teacher:MessageType_OtherUer);
    
    TKChatMessageModel *tChatMessageModel = [[TKChatMessageModel alloc]initWithFromid:user.peerID aTouid:tMyPeerId iMessageType:tMessageType aMessage:msg aUserName:user.nickName aTime:time];
    
    [[TKEduSessionHandle shareInstance] addOrReplaceMessage:tChatMessageModel];
    
    [self reloadData];
}

- (void)reloadData{
    
    _iMessageList = [[TKEduSessionHandle shareInstance] messageList];
    [_iChatTableView reloadData];
    
    if (_iMessageList.count>0) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_iMessageList.count-1  inSection:0];
        
        
        //            [_iChatTableView setContentOffset:CGPointMake(0, self.iChatTableView.bounds.size.height) animated:YES];
        
        
        [_iChatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
        
    }
    
    _xButton.selected = [TKEduSessionHandle shareInstance].isAllShutUp;
}

- (void)loadNotification{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(banChat:) name:sEveryoneBanChat object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}


#pragma mark - keyboard Notification
//- (void)keyboardWillShow:(NSNotification*)notification
//{
//    // 1.键盘弹出需要的时间
//    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    // 2.动画
//    [UIView animateWithDuration:duration animations:^{
//        // 取出键盘高度
//        CGRect keyboardF = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//
//        self.keyboardHeight = keyboardF.size.height;
//
//        [self.keyboardView show];
//
//    }];
//
//
//}
//- (void)keyboardWillHide:(NSNotification *)notification
//{
//    // 1.键盘弹出需要的时间
//    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    // 2.动画
//    [UIView animateWithDuration:duration animations:^{
//        self.keyboardHeight = 0;
//        [_keyboardView removeFromSuperview];
//        _keyboardView = nil;
//    }];
//
//
//
//}

//重写touchOutSide方法
- (void)touchOutSide{
    //    if (self.keyboardHeight == 0) {
    //        [self dismissAlert];
    //    }else{
    //        [self.keyboardView.inputField resignFirstResponder];
    //    }
    //
}


- (TKChatSendView *)keyboardView{
    if (!_keyboardView) {
    
        CGFloat screenw;
        CGFloat screenh;
        if (ScreenW<ScreenH) {

            screenw = ScreenH;
            screenh = ScreenW;
        }else{

            screenw = ScreenW;
            screenh = ScreenH;
        }
        
//        _keyboardView = [[TKChatSendView alloc] initWithFrame:CGRectMake(0, 0, screenw, screenh)];
         _keyboardView = [[TKChatSendView alloc] initWithFrame:CGRectMake(0, 0, screenw, screenh)];
//        _keyboardView.sakura.backgroundColor(ThemeKP(@"chatToolBackColor"));
     
//        self.keyboardView.delegate = self;
        [TKMainWindow addSubview:_keyboardView];
        
    }
    return _keyboardView;
}


#pragma mark - TKOldChatToolView Delegate

- (void)chatToolViewDidBeginEditing:(UITextView *)textView{
    if (textView == _toolView.inputField) {
        [_toolView.inputField resignFirstResponder];
//        [_keyboardView.inputField becomeFirstResponder];
        
        [self.keyboardView show];
    }
}

- (void)creatTimer{
    if (!self.chatTimer) {
        self.lastSendChatTime = [NSString stringWithFormat:@"%f", [TKUtil getNowTimeTimestamp]];
        self.chatTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerFire) userInfo:nil repeats:YES];
    }
}
- (void)timerFire{
    
    self.chatTimerFlag = false;
    [self.chatTimer invalidate];
    self.chatTimer = nil;
    self.lastSendChatTime = nil;
    
}
- (void)contentSizeToFit
{
    //先判断一下有没有文字（没文字就没必要设置居中了）
    if([self.toolView.inputField.text length]>0)
    {
        //textView的contentSize属性
        CGSize contentSize = self.toolView.inputField.contentSize;
        //textView的内边距属性
        UIEdgeInsets offset;
        CGSize newSize = contentSize;
        
        //如果文字内容高度没有超过textView的高度
        if(contentSize.height <= self.toolView.inputField.frame.size.height)
        {
            //textView的高度减去文字高度除以2就是Y方向的偏移量，也就是textView的上内边距
            CGFloat offsetY = (self.toolView.inputField.frame.size.height - contentSize.height)/2;
            offset = UIEdgeInsetsMake(offsetY, 0, 0, 0);
        }
        else          //如果文字高度超出textView的高度
        {
            newSize = self.toolView.inputField.frame.size;
            offset = UIEdgeInsetsZero;
            CGFloat fontSize = 18;
            
            //通过一个while循环，设置textView的文字大小，使内容不超过整个textView的高度（这个根据需要可以自己设置）
            while (contentSize.height > self.toolView.inputField.frame.size.height)
            {
                [self.toolView.inputField setFont:[UIFont fontWithName:@"Helvetica Neue" size:fontSize--]];
                contentSize = self.toolView.inputField.contentSize;
            }
            newSize = contentSize;
        }
        
        //根据前面计算设置textView的ContentSize和Y方向偏移量
        [self.toolView.inputField setContentSize:newSize];
        [self.toolView.inputField setContentInset:offset];
        
    }
}

- (void)hideKeyBorand {
    if (_keyboardView) {
        [_keyboardView hide];
    }
}
- (void)dealloc {
    
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
