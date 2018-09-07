//
//  TKChatView.m
//  EduClass
//
//  Created by lyy on 2018/4/27.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import "TKChatView.h"
#import "TKMessageTableViewCell.h"
#import "TKChatMessageTableViewCell.h"
//#import "TKTeacherMessageTableViewCell.h"
#import "TKEduSessionHandle.h"
#import "TKChatToolView.h"

#define ThemeKP(args) [@"ClassRoom.TKChatViews." stringByAppendingString:args]
static NSString *const sMessageCellIdentifier           = @"messageCellIdentifier";
static NSString *const sStudentCellIdentifier           = @"studentCellIdentifier";
static NSString *const sDefaultCellIdentifier           = @"defaultCellIdentifier";

#define chatToolHeight 44
#define margin 5

@interface TKChatView()<UITableViewDelegate,UITableViewDataSource,TKChatToolViewDelegate,UITextViewDelegate> {
    CGFloat tViewCap             ;
    CGFloat tMessageLabelWidth   ;
    CGFloat tTranslateLabelWidth ;
    CGFloat tContentWidth        ;
    CGFloat tTimeLabelHeigh      ;
    CGFloat tTranslateButtonWidth;
    
}

@property (nonatomic, strong) NSTimer *chatTimer;
@property (nonatomic, assign) BOOL chatTimerFlag;
@property (nonatomic, strong) NSString *lastSendChatTime;
@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, strong) UITableView *iChatTableView; // 聊天tableView
@property (nonatomic, strong) NSArray<TKChatMessageModel *>  *iMessageList;//聊天列表
@property (nonatomic, strong) TKChatToolView *toolView; // 聊天输入工具条
@property (nonatomic, strong) TKChatToolView *keyboardView;// 实际 聊天输入工具条
@property (nonatomic, assign) CGFloat keyboardViewHeight;
@property (nonatomic, strong) UIButton *xButton; // 全体禁言

@end


@implementation TKChatView

- (instancetype)initWithFrame:(CGRect)frame chatController:(NSString *)chatController{
    
    if (self = [super initWithFrame:frame from:chatController]) {
        
        _iMessageList = [[TKEduSessionHandle shareInstance] messageList];
        
        self.keyboardHeight = 0;
        
        //巡课不允许发送聊天消息
        if ([TKEduSessionHandle shareInstance].localUser.role != UserType_Patrol) {

            [self.contentView addSubview: self.toolView];
        }
        
        // 全体禁言(教师)
        if ([TKEduSessionHandle shareInstance].roomMgr.localUser.role == TKUserType_Teacher) {
            
            _xButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            _xButton.sakura.image(ThemeKP(@"shutup_default"),UIControlStateNormal);
            _xButton.sakura.image(ThemeKP(@"shutup_press"),  UIControlStateSelected);
            _xButton.sakura.titleColor(ThemeKP(@"shutup_default_textColor"), UIControlStateNormal);
            _xButton.sakura.titleColor(ThemeKP(@"shutup_press_textColor"), UIControlStateSelected);
            
            [_xButton setTitle:MTLocalized(@"Button.ShutUpAll") forState:UIControlStateNormal];
            [_xButton setTitle:MTLocalized(@"Button.CancelShutUpAll") forState:UIControlStateSelected];
            _xButton.titleLabel.font = [UIFont systemFontOfSize:13.];
            
            CGFloat height = CGRectGetMinY(self.contentView.frame)/2.0;
            _xButton.frame = CGRectMake(self.backImageView.x + 5 ,
                                        height/4.0,
                                        height + 100,
                                        25.);
            _xButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
            _xButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [self.backImageView addSubview:_xButton];
            [_xButton addTarget:self action:@selector(shutUpAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
        
        [self.contentView addSubview: self.iChatTableView];
        [self loadNotification];
        [self reloadData];
        [self judgeBan];
    }

    return self;
}
- (void)judgeBan{
    
    
    if ([TKEduSessionHandle shareInstance].localUser.role == UserType_Teacher) {
        //如果是老师需要设置全体禁言按钮
        if ([TKEduSessionHandle shareInstance].isAllShutUp) {
            _xButton.selected = YES;
        }
        
    }else{
        
        if ([TKUtil getBOOValueFromDic:[TKEduSessionHandle shareInstance].localUser.properties Key:sDisablechat]) {
            self.toolView.userInteractionEnabled = NO;
            self.toolView.inputField.placehoder = MTLocalized(@"Prompt.BanChat");
        }else{
            
            self.toolView.userInteractionEnabled = YES;
            self.toolView.inputField.placehoder = MTLocalized(@"Say.say");
        }
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
            
            if (self.keyboardHeight != 0)
                [self.keyboardView.inputField resignFirstResponder];

            self.toolView.inputField.placehoder = MTLocalized(@"Prompt.BanChat");
        }else{
            
            self.toolView.userInteractionEnabled = YES;
            self.toolView.inputField.placehoder = MTLocalized(@"Say.say");
        }
    }
   
}

#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _iMessageList.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 系统消息
    if (_iMessageList[indexPath.section].iMessageType == MessageType_Message) {
        return 30.;
        
    }
    NSLog(@"%f",_iMessageList[indexPath.section].height);
    return _iMessageList[indexPath.section].height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TKChatMessageModel *tMessageModel = [_iMessageList objectAtIndex:indexPath.section];
    
    switch (tMessageModel.iMessageType) {
        case MessageType_Message:
        {
            TKMessageTableViewCell *tCell = [tableView dequeueReusableCellWithIdentifier:sMessageCellIdentifier forIndexPath:indexPath];
            tCell.selectionStyle = UITableViewCellSelectionStyleNone;
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
            TKChatMessageTableViewCell* tCell =[tableView dequeueReusableCellWithIdentifier:sStudentCellIdentifier forIndexPath:indexPath];
            tCell.chatModel = tMessageModel;
            tCell.sakura.backgroundColor(ThemeKP(@"chatCellBackgoundColor"));
            tCell.layer.masksToBounds = YES;
            tCell.layer.cornerRadius = 5;
         
            // 设置cell 不可用（存在翻译内容）
//            tCell.userInteractionEnabled = !(tMessageModel.iTranslationMessage.length > 0);
            tCell.userInteractionEnabled = YES;
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

#pragma mark - 翻译
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (_iMessageList.count <= indexPath.section) {
        return;
    }
    
    TKChatMessageModel *tMessageModel = [_iMessageList objectAtIndex:indexPath.section];
    
    if(tMessageModel.iTranslationMessage.length > 0){
        return;
    }
    // 内容为消息 直接返回
    if (tMessageModel.iMessageType == MessageType_Message) {
        return;
    }

    __weak typeof(self)weakSelf = self;
    [TKEduNetManager translation:tMessageModel.iMessage aTranslationComplete:^int(id  _Nullable response, NSString * _Nullable aTranslationString) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        tMessageModel.iTranslationMessage = aTranslationString;
        [[TKEduSessionHandle shareInstance] addTranslationMessage:tMessageModel];
        [strongSelf reloadDataWithIndexPath: indexPath];
        
        return 0;
    }];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }
    else {
        return 8.;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
//- (void)tapGestureTranslation:(UITapGestureRecognizer *)gesture {
//
//    //获得当前手势触发的在UITableView中的坐标
//    CGPoint location = [gesture locationInView:_iChatTableView];
//    //获得当前坐标对应的indexPath
//    NSIndexPath *indexPath = [_iChatTableView indexPathForRowAtPoint:location];
//    __weak typeof(self)weakSelf = self;
//    if (_iMessageList.count <= indexPath.row) {
//        return;
//    }
//    TKChatMessageModel *tMessageModel = [_iMessageList objectAtIndex:indexPath.section];
//
//    TKChatMessageTableViewCell *cell = [_iChatTableView cellForRowAtIndexPath:indexPath];
//    cell.iTranslationButton.sakura.image(ThemeKP(@"translation_selected"),UIControlStateDisabled);
//
//    switch (tMessageModel.iMessageType) {
//        case MessageType_Message:
//        {
//
//        }
//            break;
//        case MessageType_OtherUer:
//        case MessageType_Teacher:
//        case MessageType_Me:
//        {
//
//            [TKEduNetManager translation:tMessageModel.iMessage aTranslationComplete:^int(id  _Nullable response, NSString * _Nullable aTranslationString) {
//                __strong typeof(weakSelf) strongSelf = weakSelf;
//                tMessageModel.iTranslationMessage = aTranslationString;
//                [[TKEduSessionHandle shareInstance] addTranslationMessage:tMessageModel];
//                [strongSelf reloadData];
//                return 0;
//            }];
//
//        }
//            break;
//
//        default:
//
//            break;
//    }
//
//}


- (void)messageReceived:(NSString *)message
                 fromID:(NSString *)peerID
              extension:(NSDictionary *)extension{

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
    
    NSString *msg = [tDataDic objectForKey:@"msg"];
    
    NSString *tMyPeerId = [TKEduSessionHandle shareInstance].localUser.peerID;

    
    BOOL isMe = [peerID isEqualToString:tMyPeerId];
    BOOL isTeacher = [extension[@"role"] intValue] == UserType_Teacher?YES:NO;
    
    MessageType tMessageType = (isMe)?MessageType_Me:(isTeacher?MessageType_Teacher:MessageType_OtherUer);
    
    TKChatMessageModel *tChatMessageModel = [[TKChatMessageModel alloc]initWithFromid:peerID aTouid:tMyPeerId iMessageType:tMessageType aMessage:msg aUserName:extension[@"nickname"] aTime:time];
    
    [[TKEduSessionHandle shareInstance] addOrReplaceMessage:tChatMessageModel];
    
    [self reloadData];
}
#pragma mark - 刷新
// 发送、接收、初始化 会执行此方法
- (void)reloadData{
    
    _iMessageList = [[TKEduSessionHandle shareInstance] messageList];
    
    [self calculateCellHeight];
    
    [_iChatTableView reloadData];
    
    if (_iMessageList.count>0) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0  inSection:_iMessageList.count - 1];
        [_iChatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];

        
    }
}
// 翻译
- (void)reloadDataWithIndexPath: (NSIndexPath *)indexPath {
    
//    _iMessageList = [[TKEduSessionHandle shareInstance] messageList];
    
    // 单独计算翻译文本
    [self calculateTranslationHeight:_iMessageList[indexPath.section]];
    // 刷新单行（组）
    [_iChatTableView reloadSections:[NSIndexSet indexSetWithIndex: indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    
    if (_iMessageList.count > 0) {
        // 滚动到屏幕中央
        [_iChatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
 
    }
}
- (void)loadNotification{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(banChat:) name:sEveryoneBanChat object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}


#pragma mark - keyboard Notification
- (void)keyboardWillShow:(NSNotification*)notification
{
    
    
    // 1.键盘弹出需要的时间
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        // 取出键盘高度
        CGRect keyboardF = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        
        self.keyboardHeight = keyboardF.size.height;
        
        _keyboardViewHeight = _keyboardViewHeight ? _keyboardViewHeight : chatToolHeight;
        self.keyboardView.y = ScreenH - self.keyboardHeight - _keyboardViewHeight;
        
        self.keyboardView.hidden = NO;
        
    }];
    
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    _toolView.inputField.text = _keyboardView.inputField.realText;
    
    // 1.键盘弹出需要的时间
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        self.keyboardHeight = 0;
        self.keyboardView.y = ScreenH+chatToolHeight;
        self.keyboardView.hidden = YES;
    }];
    
    _toolView.isCustomInputView = NO;
    
}
//重写touchOutSide方法
- (void)touchOutSide{
    if (self.keyboardHeight == 0) {
        [self dismissAlert];
    }else{
        [self.keyboardView.inputField resignFirstResponder];
    }
    
}
- (void)dismissAlert {
    [self.keyboardView.inputField resignFirstResponder];
    [self.toolView.inputField resignFirstResponder];
    
    [self.toolView removeFromSuperview];
    [self.keyboardView removeFromSuperview];
    
    [super dismissAlert];
}

#pragma mark - TKChatToolView Delegate
- (void)chatToolViewDidBeginEditing:(UITextView *)textView {
    if (textView == _toolView.inputField) {
//        [_toolView.inputField resignFirstResponder];
        self.keyboardView.isCustomInputView = _toolView.isCustomInputView;
        [self.keyboardView.inputField becomeFirstResponder];
    }

}

- (void)chatToolViewChangeHeight:(CGFloat)height {
    
    _keyboardViewHeight = height;
    _keyboardView.y = ScreenH - self.keyboardHeight - _keyboardViewHeight;
    
}


- (void)sendMessage:(NSString *)message{
   
    //判断是否自己被禁言
    BOOL disablechat = [TKUtil getBOOValueFromDic:[TKEduSessionHandle shareInstance].localUser.properties Key:sDisablechat];
    if (disablechat) {
        return;
    }
    NSString *time = [TKUtil currentTime];
    NSDictionary *messageDic = @{@"type":@0,@"time":time};
    
    BOOL isSame = [[TKEduSessionHandle shareInstance] judgmentOfTheSameMessage:message lastSendTime:self.lastSendChatTime];
    
    if (isSame && _chatTimerFlag) {
        [TKUtil showMessage: MTLocalized(@"Prompt.NotRepeatChat")];
    }else{
        [[TKEduSessionHandle shareInstance] sessionHandleSendMessage:message toID:sTellAll extensionJson:messageDic];
        [self creatTimer];
    }
    self.chatTimerFlag = true;
    
    _keyboardView.inputField.text = @"";
    _toolView.inputField.text = @"";

    [self reloadData];
    
    [_keyboardView.inputField resignFirstResponder];
   
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

#pragma mark - 懒加载
- (TKChatToolView *)toolView {
    if (!_toolView) {
        
        _toolView = [[TKChatToolView alloc]initWithFrame:CGRectMake(0, self.contentView.height-chatToolHeight, self.contentView.width, chatToolHeight) isDistance:false];
        _toolView.delegate = self;
        
    }
    return _toolView;

}

- (TKChatToolView *)keyboardView{
    if (!_keyboardView) {
        
        
        CGFloat x = IS_IPHONE_X ?  44 : 0;
        
        self.keyboardView = [[TKChatToolView alloc] initWithFrame:CGRectMake(x,
                                                                             ScreenH+chatToolHeight,
                                                                             ScreenW - x,
                                                                             chatToolHeight) isDistance:true];
        self.keyboardView.sakura.backgroundColor(ThemeKP(@"chatToolBackColor"));
        self.keyboardView.delegate = self;

        [TKMainWindow addSubview:self.keyboardView];
    }
    return _keyboardView;
}


- (UITableView *)iChatTableView {
    if (!_iChatTableView) {
        
        _iChatTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.width, self.contentView.height-chatToolHeight-margin*2) style: UITableViewStyleGrouped];
        _iChatTableView.backgroundColor = [UIColor clearColor];
        _iChatTableView.separatorColor  = [UIColor clearColor];
        _iChatTableView.showsHorizontalScrollIndicator = NO;
        
        _iChatTableView.delegate   = self;
        _iChatTableView.dataSource = self;
        _iChatTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
        _iChatTableView.estimatedRowHeight = 0;
        _iChatTableView.estimatedSectionHeaderHeight = 0;
        _iChatTableView.estimatedSectionFooterHeight = 0;
        
        [_iChatTableView registerClass:[TKMessageTableViewCell class] forCellReuseIdentifier:sMessageCellIdentifier];
        [_iChatTableView registerClass:[TKChatMessageTableViewCell class] forCellReuseIdentifier:sStudentCellIdentifier];
        

        // 初始化 变量
        tViewCap             = 10 * Proportion;
        tTranslateButtonWidth= 25 * Proportion;
        tTimeLabelHeigh      = 25;
        tContentWidth        = _iChatTableView.width - tTranslateButtonWidth - tViewCap *2;
        tMessageLabelWidth   = tContentWidth + 60;
        tTranslateLabelWidth = tContentWidth;
//        tTranslateLabelWidth = tContentWidth + tTranslateButtonWidth;
       
    }
    
    return _iChatTableView;
}



#pragma mark - 计算缓存 cell 高度
- (void)calculateCellHeight {

    [_iMessageList enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(TKChatMessageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        // 系统消息不计算
        if (obj.iMessageType == MessageType_Message) {
            *stop = YES;
        }
        
        // 文字高度
        if (!(obj.messageHeight > 0)) {// 如果未计算过
            
            obj.messageHeight = [TKChatMessageTableViewCell sizeFromAttributedString:obj.iMessage
                                                                      withLimitWidth:tMessageLabelWidth
                                                                                Font:TKFont(15)].height;
            obj.height = 16 * Proportion +// 消息内容上边距
                         obj.messageHeight +
                         tTimeLabelHeigh;  // 时间高度
        }
        
        
        // 翻译高度
        if (obj.iTranslationMessage.length > 0 && !(obj.translationHeight > 0)) {// 如果未计算过
            
            [self calculateTranslationHeight:obj];
            
        }

    }];
}

// 计算翻译高度
- (void)calculateTranslationHeight:(TKChatMessageModel *)obj {

    obj.translationHeight = [TKChatMessageTableViewCell sizeFromAttributedString:obj.iTranslationMessage
                                                                  withLimitWidth:tTranslateLabelWidth
                                                                            Font:TKFont(15)].height;
    
    obj.height += tViewCap * 2 + // 分割线上下边距
                  obj.translationHeight +
                  tViewCap;
    
}

// 全体禁言
- (void)shutUpAction:(UIButton *)btn {
    
    BOOL abool = !btn.selected;
    // 信令
    if (abool) {
        [[TKEduSessionHandle shareInstance] sessionHandlePubMsg:sEveryoneBanChat ID:sEveryoneBanChat To:sTellAll Data:@{} Save:true AssociatedMsgID:nil AssociatedUserID:nil expires:0 completion:nil];
        
    }
    else {
        [[TKEduSessionHandle shareInstance] sessionHandleDelMsg:sEveryoneBanChat ID:sEveryoneBanChat To:sTellAll Data:@{} completion:nil ];
    }
    
    
    NSDictionary *dict = @{sDisablechat: @(abool)};
    [[TKEduSessionHandle shareInstance] sessionHandleChangeUserPropertyByRole:@[@(UserType_Student)]
                                                                     tellWhom:sTellAll
                                                                     property:dict
                                                                   completion:nil];
    
    
    btn.selected = abool;
    
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
