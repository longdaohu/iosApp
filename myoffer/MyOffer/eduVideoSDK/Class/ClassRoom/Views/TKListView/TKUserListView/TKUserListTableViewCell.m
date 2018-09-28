//
//  TKUserListTableViewCell.m
//  EduClass
//
//  Created by lyy on 2018/4/26.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import "TKUserListTableViewCell.h"
#import "TKEduSessionHandle.h"
#define ThemeKP(args) [@"TKUserListTableView." stringByAppendingString:args]
@interface TKUserListTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UIButton *removeBtn;//移除按钮
@property (weak, nonatomic) IBOutlet UIButton *bannedBtn;//禁言按钮
@property (weak, nonatomic) IBOutlet UIButton *handupBtn;//举手按钮

@property (weak, nonatomic) IBOutlet UIButton *audioBtn;//麦克风按钮
@property (weak, nonatomic) IBOutlet UIButton *videoBtn;//摄像头按钮
@property (weak, nonatomic) IBOutlet UIButton *underPlatformBtn;//上下台按钮

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;//头像

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//用户名

@end

@implementation TKUserListTableViewCell

- (void)awakeFromNib {
   
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.cornerRadius = 5;
    
    self.backView.sakura.backgroundColor(ThemeKP(@"listBackColor"));

    self.removeBtn.sakura.image(ThemeKP(@"button_remove"),UIControlStateNormal);
    
    self.bannedBtn.sakura.image(ThemeKP(@"button_close_speak"),UIControlStateNormal);
    self.bannedBtn.sakura.image(ThemeKP(@"button_speak"),UIControlStateSelected);
    self.bannedBtn.sakura.image(ThemeKP(@"button_close_speak_unclickable"),UIControlStateDisabled);
    
    self.handupBtn.sakura.image(ThemeKP(@"icon_handup"),UIControlStateNormal);
    

    self.editBtn.sakura.image(ThemeKP(@"button_editor"),UIControlStateNormal);
    self.editBtn.sakura.image(ThemeKP(@"button_close_editor"),UIControlStateSelected);
    self.editBtn.sakura.image(ThemeKP(@"button_close_disabled"),UIControlStateDisabled);
    
    self.audioBtn.sakura.image(ThemeKP(@"button_audio"),UIControlStateNormal);
    self.audioBtn.sakura.image(ThemeKP(@"button_close_audio"),UIControlStateSelected);
    self.audioBtn.sakura.image(ThemeKP(@"button_audio_disable"),UIControlStateDisabled);
    
    self.videoBtn.sakura.image(ThemeKP(@"button_video"),UIControlStateNormal);
    self.videoBtn.sakura.image(ThemeKP(@"button_close_video"),UIControlStateSelected);
    self.videoBtn.sakura.image(ThemeKP(@"icon_video_disable"),UIControlStateDisabled);
    
    self.underPlatformBtn.sakura.image(ThemeKP(@"button_shangjiangtai"),UIControlStateNormal);
    self.underPlatformBtn.sakura.image(ThemeKP(@"button_xiajiangtai"),UIControlStateSelected);
    self.underPlatformBtn.sakura.image(ThemeKP(@"button_shangjiangtai_unclickable"),UIControlStateDisabled);
    
    
    self.underPlatformBtn.imageView.contentMode =
    self.removeBtn.imageView.contentMode =
    self.videoBtn.imageView.contentMode =
    self.audioBtn.imageView.contentMode =
    self.editBtn.imageView.contentMode =
    self.bannedBtn.imageView.contentMode =
    self.handupBtn.imageView.contentMode =
    
    UIViewContentModeCenter;
    // Initialization code
}
- (void)setRoomUser:(TKRoomUser *)roomUser{
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserListUI:) name:[NSString stringWithFormat:@"%@%@",sRaisehand,roomUser.peerID] object:nil];
    
    _roomUser = roomUser;

    // 禁言
    BOOL disablechat = [TKUtil getBOOValueFromDic:roomUser.properties Key:sDisablechat];
    NSLog(@"%d", disablechat);
    self.bannedBtn.selected = disablechat;
    
    
    // 发布状态，0：未发布，1：发布音频；2：发布视频；3：发布音视频
    switch (roomUser.publishState) {
        case PublishState_NONE:
        {
            _underPlatformBtn.selected = NO;
            _videoBtn.selected = NO;
            _audioBtn.selected = NO;
            break;
        }
        case PublishState_AUDIOONLY:
        {
            
            _underPlatformBtn.selected = YES;
            _videoBtn.selected = NO ;
            _audioBtn.selected = YES;
            break;
        }
        case PublishState_VIDEOONLY:
        {
            
            _underPlatformBtn.selected = YES;
            _videoBtn.selected = YES;
            _audioBtn.selected = NO;
            break;
        }
        case PublishState_BOTH:
        {
            
            _underPlatformBtn.selected = YES;
            _videoBtn.selected = YES;
            _audioBtn.selected = YES;
        }
            break;
        case PublishState_NONE_ONSTAGE:
        {
            
            _underPlatformBtn.selected = YES;
            _videoBtn.selected = NO;
            _audioBtn.selected = NO;
        }
            break;
            
        default:
        {
            
            _underPlatformBtn.selected = NO;
            _videoBtn.selected = NO;
            _audioBtn.selected = NO;
            
        }
            break;
    }
    
//    // 未上课 || （不是学生&& 不是助教） || （是助教&&不允许助教上台）
//    if (![TKEduSessionHandle shareInstance].isClassBegin ||
//        ((roomUser.role != UserType_Student) && (roomUser.role != UserType_Assistant) )||
//        ((roomUser.role == UserType_Assistant) && [[TKEduSessionHandle shareInstance].roomMgr getRoomConfigration].assistantCanPublish == 0)) {
//        _handupBtn.hidden = YES;
//        _handupBtn.enabled = YES;
//        _videoBtn.hidden = YES;
//        _underPlatformBtn.hidden = YES;
//        _audioBtn.hidden = YES;
//        _underPlatformBtn.enabled = YES;
//        _audioBtn.enabled = YES;
//        _underPlatformBtn.enabled = YES;
//        if (roomUser.role == UserType_Assistant) {
//            _editBtn.enabled = NO;
//        }else{
//            _editBtn.enabled = YES;
//        }
//    }else{
//        _handupBtn.hidden = ![[roomUser.properties objectForKey:sRaisehand]boolValue];
//        _underPlatformBtn.hidden = NO;
//        _audioBtn.hidden = NO;
//        _editBtn.hidden = NO;
//        if (roomUser.role == UserType_Assistant) {
//            _editBtn.enabled = NO;
//        }else{
//            _editBtn.enabled = YES;
//            _editBtn.selected = roomUser.canDraw;
//        }
//        _underPlatformBtn.enabled = YES;
//        _audioBtn.enabled = YES;
//        _videoBtn.enabled = YES;
//    }
    
    
    // 未上课 || （不是学生&& 不是助教） || （是助教&&不允许助教上台）
    if (![TKEduSessionHandle shareInstance].isClassBegin ||
        ((roomUser.role != UserType_Student) && (roomUser.role != UserType_Assistant) )||
        ((roomUser.role == UserType_Assistant) && [[TKEduSessionHandle shareInstance].roomMgr getRoomConfigration].assistantCanPublish == 0)) {
        
        _underPlatformBtn.enabled = NO;
        _videoBtn.enabled = NO;
        _audioBtn.enabled = NO;
        _editBtn.enabled = NO;
        _handupBtn.hidden = YES;
      
        
    }else{
        
        _underPlatformBtn.enabled = YES;
        _videoBtn.enabled = YES;
        _audioBtn.enabled = YES;
        
        if (roomUser.role == UserType_Assistant) {
            _editBtn.enabled = NO;
        }else{
            _editBtn.enabled = YES;
            _editBtn.selected = roomUser.canDraw;
        }
        
        
        _handupBtn.hidden = ![[roomUser.properties objectForKey:sRaisehand]boolValue];
    }
    
    
    
    //用设备图标替换用户头像
    NSMutableDictionary *properties = roomUser.properties;
    NSString *devicetype = properties[@"devicetype"];
    
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    _iconImageView.sakura.image([TKHelperUtil returnDeviceImageName:devicetype]);
    
    // 当用被墙了，图标变化
        if ([roomUser.properties objectForKey:sUdpState]) {
            
            NSInteger udpState = [[roomUser.properties objectForKey:sUdpState] integerValue];
            if (udpState == 2) {
                
                
                _iconImageView.sakura.image([TKHelperUtil returnUDPDeviceImageName:devicetype]);
                
            } else {
                _iconImageView.sakura.image([TKHelperUtil returnDeviceImageName:devicetype]);
                
                
            }
        }
    
    //昵称 （身份）f
    NSAttributedString * attrStr =  [[NSAttributedString alloc]initWithData:[roomUser.nickName dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
    
    NSString *nickAndRole = [NSString stringWithFormat:@"%@",attrStr.string];
    _nameLabel.text = nickAndRole ;
    _nameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    _nameLabel.sakura.textColor(ThemeKP(@"coursewareButtonDefaultColor"));
    

    //如果是助教身份需要将禁言，移除隐藏掉, 授权为🈲
    if (roomUser.role == UserType_Assistant) {
        _removeBtn.hidden = YES;
        _bannedBtn.hidden = YES;
    }else{
        _removeBtn.hidden = NO;
        _bannedBtn.hidden = NO;
    }
    
  
    
}

-(void)configaration:(id)aModel withFileListType:(FileListType)aFileListType isClassBegin:(BOOL)isClassBegin{
    
    TKRoomUser *tRoomUser =(TKRoomUser *) aModel;

    // 发布状态，0：未发布，1：发布音频；2：发布视频；3：发布音视频
    switch (tRoomUser.publishState) {
        case PublishState_NONE:
        {
            _videoBtn.selected = NO;
            _videoBtn.selected = NO;
            break;
        }
        case PublishState_AUDIOONLY:
        {
            _videoBtn.selected = NO ;
            _audioBtn.selected = YES;
            break;
        }
        case PublishState_VIDEOONLY:
        {
            _videoBtn.selected = YES;
            _audioBtn.selected = NO;
            break;
        }
        case PublishState_BOTH:
        {
            _videoBtn.selected = YES;
            _audioBtn.selected = YES;
        }
            break;
            
        default:
            break;
    }
    
    
    if (!isClassBegin || ((tRoomUser.role != UserType_Student) && (tRoomUser.role != UserType_Assistant) ) || ((tRoomUser.role == UserType_Assistant) && [[TKEduSessionHandle shareInstance].roomMgr getRoomConfigration].assistantCanPublish ==0)) {
        
        _handupBtn.hidden = YES;
        _videoBtn.hidden = YES;
        _underPlatformBtn.hidden = YES;
        _audioBtn.hidden = YES;
//        _removeBtn.hidden = YES;
        
        _handupBtn.enabled = YES;
        _underPlatformBtn.enabled = YES;
        _audioBtn.enabled = YES;
        _underPlatformBtn.enabled = YES;
        
    }else{
        
        _handupBtn.hidden = ![[tRoomUser.properties objectForKey:sRaisehand]boolValue];
        _underPlatformBtn.hidden = NO;
        _audioBtn.hidden = NO;
        _editBtn.hidden = NO;
        
//        _editBtn.selected = tRoomUser.canDraw;
        if (tRoomUser.role == UserType_Assistant) {
            _editBtn.enabled = NO;
        }else{
            _editBtn.enabled = YES;
            _editBtn.selected = tRoomUser.canDraw;
        }
        
        _underPlatformBtn.enabled = YES;
        _audioBtn.enabled = YES;
        _videoBtn.enabled = YES;
        
    }
    
    //用设备图标替换用户头像
    NSMutableDictionary *properties = tRoomUser.properties;
    NSString *devicetype = properties[@"devicetype"];
    
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    _iconImageView.sakura.image([TKHelperUtil returnDeviceImageName:devicetype]);
    
    // 当用被墙了，图标变化

    
    if ([tRoomUser.properties objectForKey:sUdpState]) {
        
        NSInteger udpState = [[tRoomUser.properties objectForKey:sUdpState] integerValue];
        if (udpState == 2) {
            
            
            _iconImageView.sakura.image([TKHelperUtil returnUDPDeviceImageName:devicetype]);
            
        } else {
            _iconImageView.sakura.image([TKHelperUtil returnDeviceImageName:devicetype]);
            
            
        }
    }
    
    //昵称 （身份）f
    NSAttributedString * attrStr =  [[NSAttributedString alloc]initWithData:[tRoomUser.nickName dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)} documentAttributes:nil error:nil];
    
    NSString *nickAndRole = [NSString stringWithFormat:@"%@",attrStr.string];
    _nameLabel.text = nickAndRole ;
    _nameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    _nameLabel.sakura.textColor(ThemeKP(@"coursewareButtonDefaultColor"));
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - 事件
//人员移除
- (IBAction)removeClick:(UIButton *)sender {
    if ([TKEduSessionHandle shareInstance].localUser.role == UserType_Patrol) {
        return;
    }
    sender.selected = !sender.selected;
    
    [[TKEduSessionHandle shareInstance] sessionHandleEvictUser:_roomUser.peerID evictReason:@(1) completion:^(NSError *error) {
        
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(removeblock)]) {
        [self.delegate removeblock];
    }
    
    
    
}
//禁言功能
- (IBAction)bannedClick:(UIButton *)sender {
    if ([TKEduSessionHandle shareInstance].localUser.role == UserType_Patrol) {
        return;
    }
    sender.selected = !sender.selected;
    
    [[TKEduSessionHandle shareInstance] sessionHandleChangeUserProperty:_roomUser.peerID TellWhom:sTellAll Key:sDisablechat Value:@(sender.selected) completion:nil];
    
    
}
//授权功能
- (IBAction)editClick:(UIButton *)sender {
    if ([TKEduSessionHandle shareInstance].localUser.role == UserType_Patrol) {
        return;
    }
    sender.selected = _roomUser.canDraw;
    
//    if (_roomUser.publishState>1) {
    
    
    [[TKEduSessionHandle shareInstance]configureDraw:!_roomUser.canDraw isSend:YES to:sTellAll peerID:_roomUser.peerID];
    
    if (_roomUser.publishState==TKUser_PublishState_NONE && !_roomUser.canDraw) {
        
        [[TKEduSessionHandle shareInstance] sessionHandleChangeUserPublish:_roomUser.peerID Publish:PublishState_NONE_ONSTAGE completion:nil];
    }
    
    if (!sender.selected) {
        _underPlatformBtn.selected = YES;
    }
//    }
    
}
//音频控制
- (IBAction)audioClick:(UIButton *)sender {
    if ([TKEduSessionHandle shareInstance].localUser.role == UserType_Patrol) {
        return;
    }
//    sender.selected = !sender.selected;
    
    if (![_roomUser.peerID isEqualToString:@""]) {
        
        BOOL isShowAudioImage = ( _roomUser.publishState == PublishState_AUDIOONLY || _roomUser.publishState== PublishState_BOTH);
        if (_roomUser.role == UserType_Teacher) {
            [[TKEduSessionHandle shareInstance] sessionHandleEnableAudio:!isShowAudioImage];
            
            sender.selected = isShowAudioImage;
            //todo
            //            _iAudioImageView.hidden = (_videoRole == EVideoRoleTeacher)?YES:!aButton.selected;
            //            _iAudioImageView.hidden = aButton.selected;
        }else{
            
            if (_roomUser.publishState == PublishState_NONE || _roomUser.publishState == PublishState_NONE_ONSTAGE) {
                [[TKEduSessionHandle shareInstance] sessionHandleChangeUserPublish:_roomUser.peerID Publish:PublishState_AUDIOONLY completion:nil];
                sender.selected = NO;
                //                _iAudioImageView.hidden = (_videoRole == EVideoRoleTeacher)?YES:!aButton.selected;
                [[TKEduSessionHandle shareInstance] sessionHandleChangeUserProperty:_roomUser.peerID TellWhom:sTellAll Key:sRaisehand Value:@(false) completion:nil];
            }else if (_roomUser.publishState == PublishState_AUDIOONLY){
                // 该状态下，音视频都关闭但在台上
                [[TKEduSessionHandle shareInstance] sessionHandleChangeUserPublish:_roomUser.peerID Publish:PublishState_NONE_ONSTAGE completion:nil];
                sender.selected = YES;
                //                _iAudioImageView.hidden = (_videoRole == EVideoRoleTeacher)?YES:!aButton.selected;
                
            }else if (_roomUser.publishState == PublishState_BOTH){
                [[TKEduSessionHandle shareInstance] sessionHandleChangeUserPublish:_roomUser.peerID Publish:PublishState_VIDEOONLY completion:nil];
                sender.selected = YES;
                //                _iAudioImageView.hidden = (_videoRole == EVideoRoleTeacher)?YES:!aButton.selected;
            }else if(_roomUser.publishState == PublishState_VIDEOONLY){
                [[TKEduSessionHandle shareInstance] sessionHandleChangeUserPublish:_roomUser.peerID Publish:PublishState_BOTH completion:nil];
                sender.selected = NO;
                //                _iAudioImageView.hidden = (_videoRole == EVideoRoleTeacher)?YES:!aButton.selected;
                [[TKEduSessionHandle shareInstance] sessionHandleChangeUserProperty:_roomUser.peerID TellWhom:sTellAll Key:sRaisehand Value:@(false) completion:nil];
            }
            
        }
        
        if (!sender.selected) {
            _underPlatformBtn.selected = YES;
        }
    }
}
//视频控制
- (IBAction)videoClick:(UIButton *)sender {
    if ([TKEduSessionHandle shareInstance].localUser.role == UserType_Patrol) {
        return;
    }
//    sender.selected = !sender.selected;
    
    if (![_roomUser.peerID isEqualToString:@""]) {
        
        //_iCurrentPeerId = _iPeerId;
        BOOL isShowVideoImage = ( _roomUser.publishState == PublishState_VIDEOONLY || _roomUser.publishState== PublishState_BOTH);
        if (_roomUser.role == UserType_Teacher) {
            [[TKEduSessionHandle shareInstance] sessionHandleEnableAudio:!isShowVideoImage];
            sender.selected = isShowVideoImage;
            
        }else{
            
            if (_roomUser.publishState == PublishState_NONE || _roomUser.publishState == PublishState_NONE_ONSTAGE) {
                [[TKEduSessionHandle shareInstance] sessionHandleChangeUserPublish:_roomUser.peerID Publish:PublishState_VIDEOONLY completion:nil];
                sender.selected = NO;
                
                [[TKEduSessionHandle shareInstance] sessionHandleChangeUserProperty:_roomUser.peerID TellWhom:sTellAll Key:sRaisehand Value:@(false) completion:nil];
            }else if (_roomUser.publishState == PublishState_VIDEOONLY){
                // 这种情况下音视频都关闭，但还在台上
                [[TKEduSessionHandle shareInstance] sessionHandleChangeUserPublish:_roomUser.peerID Publish:PublishState_NONE_ONSTAGE completion:nil];
                sender.selected = YES;
                
            }else if (_roomUser.publishState == PublishState_BOTH){
                [[TKEduSessionHandle shareInstance] sessionHandleChangeUserPublish:_roomUser.peerID Publish:PublishState_AUDIOONLY completion:nil];
                sender.selected = YES;
            }else if(_roomUser.publishState == PublishState_AUDIOONLY){
                [[TKEduSessionHandle shareInstance] sessionHandleChangeUserPublish:_roomUser.peerID Publish:PublishState_BOTH completion:nil];
                sender.selected = YES;
                
                [[TKEduSessionHandle shareInstance] sessionHandleChangeUserProperty:_roomUser.peerID TellWhom:sTellAll Key:sRaisehand Value:@(false) completion:nil];
            }
            
        }
        
        
        if (!sender.selected) {
            _underPlatformBtn.selected = YES;
        }
    }
}
//上下台
- (IBAction)underPlatform:(UIButton *)sender {
    if ([TKEduSessionHandle shareInstance].localUser.role == UserType_Patrol) {
        return;
    }
    TKLog(@"下讲台");
    PublishState tPublishState = (PublishState)_roomUser.publishState;
    BOOL isShowVideo = (tPublishState != PublishState_NONE);
    if (isShowVideo) {
        [[TKEduSessionHandle shareInstance] sessionHandleChangeUserPublish:_roomUser.peerID Publish:PublishState_NONE completion:nil];
        // 助教始终有画笔权限
        if (_roomUser.role != UserType_Assistant) {
            [[TKEduSessionHandle shareInstance]configureDraw:false isSend:true to:sTellAll peerID:_roomUser.peerID];
        }
        sender.selected = NO;
        
    } else {
        
        [[TKEduSessionHandle shareInstance] sessionHandleChangeUserPublish:_roomUser.peerID Publish:PublishState_BOTH completion:nil];
        sender.selected = YES;
        
    }
    
    
}
- (void)refreshUserListUI:(NSNotification *)aNotification{
    
    //打开视频关闭视频开关
    NSDictionary *dict = (NSDictionary *)aNotification.object;
    TKRoomUser *user = (TKRoomUser*)[dict objectForKey:sUser];
    
    if (![user.peerID isEqualToString:_roomUser.peerID]) {
        return;
    }
    
    if ([dict objectForKey:sPublishstate]) {
        PublishState tPublishState = (PublishState)[[dict objectForKey:sPublishstate]integerValue];
        BOOL tAudioImageShow = (tPublishState  == PublishState_BOTH || tPublishState == PublishState_AUDIOONLY );
        //todo
        _audioBtn.selected = tAudioImageShow;
        BOOL turnOffCameraShow = (tPublishState == PublishState_BOTH || tPublishState == PublishState_VIDEOONLY ||tPublishState == PublishState_Local_NONE);
        
        _videoBtn.selected = turnOffCameraShow;
        
        BOOL tunder = (tPublishState == PublishState_NONE);
        
        _underPlatformBtn.selected = !tunder;
    }
    
    if ([dict objectForKey:sRaisehand]) {
        BOOL tHandsUpImageShow = (![[dict objectForKey:sRaisehand]boolValue]);
        _handupBtn.hidden = tHandsUpImageShow;
        
    }
   
    if ([dict objectForKey:sCandraw]) {
        
        BOOL tDrawImageShow = [[dict objectForKey:sCandraw]boolValue];
        if (user.role == UserType_Assistant) {
            return;
        }
        _editBtn.selected = tDrawImageShow;
    }

}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
@end

