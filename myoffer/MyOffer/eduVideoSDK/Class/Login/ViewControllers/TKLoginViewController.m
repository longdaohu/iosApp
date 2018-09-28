//
//  TKLoginViewController.m
//  EduClass
//
//  Created by lyy on 2018/4/17.
//  Copyright © 2018年 beijing. All rights reserved.
//

#import "TKLoginViewController.h"
#import "TKLoginInputView.h"
#import "TKEduClassRoom.h"
#import "TKIPhoneTypeString.h"
#import <AVFoundation/AVFoundation.h>
#import "TKTextFieldLimitManager.h"

#define inputHeigt 42//输入框的高度
#define inputMarginTop 21//输入框之间的间距
#define loginButtonHeight 51

#define Class_NickName @"test"// 用户昵称
#ifdef Debug
#define SERVER_ClassID @"1794543629"//1v多
#else
#define SERVER_ClassID @"1794543629" //1vmore
#endif


@interface TKLoginViewController ()<TKLoginChoiceRoleDelegate,TKLoginInputViewDelegate,TKEduRoomDelegate>

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) TKLoginInputView *roomidView;//课堂号
@property (nonatomic, strong) TKLoginInputView *nicknameView;//昵称
@property (nonatomic, strong) TKLoginInputView *roleView;//角色选择器
@property (nonatomic, strong) UIButton *loginBtn;//登录按钮
@property (nonatomic, strong) UILabel *versionLabel;//版本号

@property (assign, nonatomic) NSInteger role;
@property (strong, nonatomic) NSString *defaultServer;//默认服务
@property (nonatomic, assign) NSInteger inputWidth;//输入框的宽度
@property (nonatomic, assign) NSInteger loginWidth;//输入框的宽度
@property (nonatomic, assign) NSInteger loginHeight;//输入框的宽度


@property (nonatomic, strong) UIButton *whiteBtn;


@end

@implementation TKLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.inputWidth = ScreenW/5.0*2.0;
   
    self.loginWidth = ScreenW;
    self.loginHeight = ScreenH;
    
    //此处主要处理设备横屏模式下进入app需更换宽高
    if (ScreenH<ScreenW) {
        self.loginHeight = ScreenW;
        self.loginWidth = ScreenH;
    }
    self.inputWidth = 323;
    
    if ([[TKIPhoneTypeString checkIPhoneType] isEqualToString:@"iPhone 5"]||
        [[TKIPhoneTypeString checkIPhoneType] isEqualToString:@"iPhone 5"]||
        [[TKIPhoneTypeString checkIPhoneType] isEqualToString:@"iPhone 5C"]||
        [[TKIPhoneTypeString checkIPhoneType] isEqualToString:@"iPhone 5C"]||
        [[TKIPhoneTypeString checkIPhoneType] isEqualToString:@"iPhone 5S"]||
        [[TKIPhoneTypeString checkIPhoneType] isEqualToString:@"iPhone 5S"]) {
        
        self.inputWidth = 323 * ScreenFitWidth;
        if (ScreenH<ScreenW) {
            self.inputWidth = 323 * ScreenFitHeight;
        }
    }
   
    
//    [self checkDevice];
    //初始化控件
    [self initBackGroundImageView];
    [self initLoginInputView];
    [self initLoginButton];
    //设置默认显示的内容
    [self setDefaultConfig];
    //通知
//    [self initNotification];

    [self loadLayout];
    
//    版本号
    self.versionLabel = ({
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, [TKUtil isiPhoneX]?self.loginHeight -40-17:self.loginHeight -40, self.loginWidth, 40)];
        label.textAlignment = NSTextAlignmentCenter;
        label.sakura.textColor(@"Login.versionLabelTextColor");
        label.text =  [NSString stringWithFormat:@"v%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
        [self.backgroundView addSubview:label];
        label.font = [UIFont systemFontOfSize:13];
        label;
    });
//    self.whiteBtn = ({
//        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
//        button.frame = CGRectMake(0, [TKUtil isiPhoneX]?self.loginHeight -40-17-40:self.loginHeight -40-40, self.loginWidth, 40);
//        [button addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
//        [button setTitle:@"换肤" forState:(UIControlStateNormal)];
//        button.sakura.titleColor(@"Login.versionLabelTextColor",UIControlStateNormal);
//        button.selected = NO;
//        [self.backgroundView addSubview:button];
//        button;
//    });
}
- (void)checkDevice{
    // 先检测麦克风
    AVAuthorizationStatus authAudioStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (authAudioStatus == AVAuthorizationStatusRestricted|| authAudioStatus == AVAuthorizationStatusDenied) {
        // 获取麦克风失败
//        self.getMicrophoneFail = YES;
    } else if (authAudioStatus == AVAuthorizationStatusNotDetermined || authAudioStatus == AVAuthorizationStatusAuthorized) {
        
        // 麦克风
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            if (granted) {
                // 获取麦克风成功
            } else {
                //[self callMicrophoneError];
            }
        }];
        
    }
    
    // 摄像头
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted|| authStatus == AVAuthorizationStatusDenied) {
        // 获取摄像头失败
        //[self callCameroError];
//        self.getCameraFail = YES;
        
        
    } else if(authStatus == AVAuthorizationStatusNotDetermined || authStatus == AVAuthorizationStatusAuthorized) {
        // 摄像头
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            //                if (granted) {
            //                    // 获取摄像头成功
            //                } else {
            //                    // 获取摄像头失败
            //
            //                }
        }];
        
        
    }
}
- (void)buttonClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        
        [TXSakuraManager shiftSakuraWithName:TKBlackSkin type:TXSakuraTypeMainBundle];
        
    }else{
        
        [TXSakuraManager shiftSakuraWithName:TKDefaultSkin type:TXSakuraTypeMainBundle];
        
    }
    [self setDefaultConfig];
    
}
- (void)loadLayout{
    
    //此处主要适配5/5s的显示
    if((self.inputWidth-self.loginWidth)>0 && (self.inputWidth-self.loginWidth) <= 40 ){
        self.inputWidth = self.loginWidth-40;
    }
    
    self.backgroundView.frame = CGRectMake(0, 0, self.loginWidth, self.loginHeight);;
    self.backgroundImageView.frame = CGRectMake(0, 0, self.loginWidth, self.loginHeight);
    self.logoImageView.frame = CGRectMake(0, (self.loginHeight-453)*0.4, self.loginWidth, 103);
    self.roomidView.frame = CGRectMake((self.loginWidth-self.inputWidth)/2, CGRectGetMaxY(self.logoImageView.frame)+inputHeigt*2, self.inputWidth, inputHeigt);
    self.nicknameView.frame = CGRectMake(CGRectGetMinX(self.roomidView.frame),CGRectGetMaxY(self.roomidView.frame)+20 , CGRectGetWidth(self.roomidView.frame), inputHeigt);
    self.roleView.frame = CGRectMake(CGRectGetMinX(self.nicknameView.frame),CGRectGetMaxY(self.nicknameView.frame)+20 , CGRectGetWidth(self.nicknameView.frame), inputHeigt);
    self.loginBtn.frame = CGRectMake(CGRectGetMinX(self.roleView.frame),CGRectGetMaxY(self.roleView.frame)+inputHeigt , CGRectGetWidth(self.roleView.frame), loginButtonHeight);
    
    
}
- (void)initNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];//键盘弹起的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];//键盘收回的通知
}


- (void)initBackGroundImageView{
    
    
    //创建背景view，主要为了做键盘弹起使用
    self.backgroundView = [[UIView alloc]init];
    self.backgroundView.frame = CGRectMake(0, 0, self.loginWidth, self.loginHeight);
    self.backgroundView.backgroundColor = [UIColor clearColor];
    [self.backgroundImageView addSubview:self.backgroundView];
    
    self.logoImageView = [[UIImageView alloc]init];
    
    self.logoImageView.sakura.image(@"Login.logoImage");
    
    self.logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.backgroundView addSubview:self.logoImageView];
    
    self.logoImageView.frame = CGRectMake(0, (self.loginHeight-453)*0.4, self.loginWidth, 103);
    
   
    
}

- (void)initLoginInputView{
    
    self.roomidView = [[TKLoginInputView alloc]initWithFrame:CGRectMake((self.loginWidth-self.inputWidth)/2, CGRectGetMaxY(self.logoImageView.frame)+inputHeigt*2, self.inputWidth, inputHeigt) showText:nil placeholderText:MTLocalized(@"Label.roomPlaceholder") isShow:NO setImageName:@"Login.roomNumberImage"];
    self.roomidView.inputDelegate = self;
    self.roomidView.inputView.keyboardType = UIKeyboardTypeNumberPad;
    [self.backgroundView addSubview:self.roomidView];
    
    
    self.nicknameView = [[TKLoginInputView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.roomidView.frame),CGRectGetMaxY(self.roomidView.frame)+20 , CGRectGetWidth(self.roomidView.frame), inputHeigt) showText:nil placeholderText:MTLocalized(@"Label.nicknamePlaceholder") isShow:NO setImageName:@"Login.nickNameImage"];
    //限制昵称为24个字符
    [[TKTextFieldLimitManager sharedManager] limitTextField:self.nicknameView.inputView bytesLength:24 handler:nil];
    
    [self.backgroundView addSubview:self.nicknameView];
    
    
    self.roleView = [[TKLoginInputView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.nicknameView.frame),CGRectGetMaxY(self.nicknameView.frame)+20 , CGRectGetWidth(self.nicknameView.frame), inputHeigt) showText:@"学生" placeholderText:nil isShow:YES setImageName:@"Login.loginRightRrrowImage"];
    self.roleView.choiceRoleDelegate = self;
    [self.backgroundView addSubview:self.roleView];
    
}

- (void)initLoginButton{
    self.loginBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.loginBtn.frame = CGRectMake(CGRectGetMinX(self.roleView.frame),CGRectGetMaxY(self.roleView.frame)+inputHeigt , CGRectGetWidth(self.roleView.frame), loginButtonHeight);
    [self.backgroundView addSubview:self.loginBtn];
    self.loginBtn.sakura.backgroundImage(@"Login.joinRoomNomalImage",UIControlStateNormal);
    self.loginBtn.sakura.backgroundImage(@"Login.joinRoomSelectedImage",UIControlStateSelected);
    [self.loginBtn setTitle:MTLocalized(@"Login.EnterRoom") forState:UIControlStateNormal];
    self.loginBtn.sakura.titleColor(@"Login.loginButtonTitleColor",UIControlStateNormal);
    [self.loginBtn addTarget:self action:@selector(joinRoom:) forControlEvents:(UIControlEventTouchUpInside)];
}

//执行此方法主要为了适配ipad竖屏模式
-(void)viewDidLayoutSubviews{
    
   
    
}
#pragma mark -  角色选择
-(void)choiceRole:(int)role{
    _role = role;
    TKLog(@"角色选择");
    
    

    
}

- (void)setDefaultConfig{
    
    NSString *meetignID =[[NSUserDefaults standardUserDefaults] objectForKey:@"meetingID"];
    if (meetignID != nil && [meetignID isKindOfClass:[NSString class]])
    {
        _roomidView.inputView.text = meetignID;
    }
    else
    {
        
        
#ifdef Realese
        
#else
        _roomidView.inputView.text = SERVER_ClassID;
#endif
        
    }
    NSString *nickName =[[NSUserDefaults standardUserDefaults] objectForKey:@"nickName"];
    if (nickName != nil && [nickName isKindOfClass:[NSString class]])
    {
        _nicknameView.inputView.text = nickName;
    }
    else
    {
#ifdef Realese
        
#else
        _nicknameView.text = Class_NickName;
#endif
        
    }
    NSNumber  *role = [[NSUserDefaults standardUserDefaults] objectForKey:@"userrole"];
    //0-老师 ,1-助教，2-学生 4-寻课A
    if (role != nil && [role isKindOfClass:[NSNumber class]])
    {
        _role = [role intValue];
        switch ([role intValue]) {
            case 0:
                _roleView.text = MTLocalized(@"Role.Teacher");
                break;
            case 2:
                _roleView.text = MTLocalized(@"Role.Student");
                break;
            case 4:
                _roleView.text = MTLocalized(@"Role.Patrol");
                break;
            default:
                break;
        }
       
        
    }
    else
    {
        _role = 2;
        _roleView.text = MTLocalized(@"Role.Student");
    }
    
    
}

- (BOOL)loginTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
     bool tIsChange = [TKUtil validateNumber:string];

        if ([string isEqualToString:@"\n"]) {
            [self.view endEditing:YES];
            return  NO;
        }
        if (!tIsChange) {
            [TKUtil showMessage:MTLocalized(@"Prompt.onlyNumber")];
            
        }

   
    return tIsChange;
}


- (void)joinRoom:(id)sender {
  
    [self.view endEditing:YES];
    
    NSString *tString = @"";
    if (_nicknameView.inputView.text == nil || (_nicknameView.inputView.text.length == 0) || [TKUtil isEmpty:_nicknameView.inputView.text] ) {
        tString =  MTLocalized(@"Prompt.nicknameNotNull");//@"昵称不能为空";
    }
    
    if (_roomidView.inputView.text == nil || _roomidView.inputView.text.length == 0) {
        tString = MTLocalized(@"Prompt.RoomIDNotNull");
        
    }
    
    // 学生被T 3分钟内不能登录判断
    if (_role == UserType_Student) {
        
        id idTime = [[NSUserDefaults standardUserDefaults] objectForKey:TKKickTime];
        if (idTime && [idTime isKindOfClass:NSDate.class]) {
            NSDate *time = (NSDate *)idTime;
            NSDate *curTime = [NSDate date];
            NSTimeInterval delta = [curTime timeIntervalSinceDate:time]; // 计算出相差多少秒
            
            if (delta < 60 * 3) {
                tString = MTLocalized(@"Prompt.kick");
                
            }
            else {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey: TKKickTime];
            }
        }
    }
    if ( ![tString isEqualToString:@""] ) {
        
        TKAlertView *alert = [[TKAlertView alloc]initWithTitle:MTLocalized(@"Prompt.prompt") contentText:tString confirmTitle:MTLocalized(@"Prompt.Know")];
        [alert show];

        return;
    }
    
    NSString *tRoomIDString = [_roomidView.inputView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[NSUserDefaults standardUserDefaults] setObject:tRoomIDString forKey:@"meetingID"];
    [[NSUserDefaults standardUserDefaults] setObject:_nicknameView.inputView.text forKey:@"nickName"];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:@(_role) forKey:@"userrole"];
    
    NSString *storedServer = [[NSUserDefaults standardUserDefaults] objectForKey:@"server"];
    if (storedServer != nil) {
        self.defaultServer = storedServer;
    } else {
        if ([TKUtil isDomain:sHost] == YES) {
            NSArray *array = [sHost componentsSeparatedByString:@"."];
            self.defaultServer = [NSString stringWithFormat:@"%@", array[0]];
        } else {
            self.defaultServer = @"global";
        }
    }
    
    NSDictionary *tDict = @{
                            @"serial"   :tRoomIDString,
                            @"host"    :sHost,
                            @"port"    :sPort,
                            @"nickname":_nicknameView.inputView.text,
//                            @"userid"  : @"1111",
                            //@"domain"   :sDomain,
                            @"userrole":@(_role),
                            @"server":self.defaultServer,
                            @"clientType":@(3)
                            };
    
    [TKEduClassRoom joinRoomWithParamDic:tDict ViewController:self Delegate:self isFromWeb:NO];
    
    
}

- (void)keyboardWillShow:(NSNotification*)notification {
//
//    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]; //获得键盘的rect
//    double duration = ([[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]);
//    //响应弹起
//    CGFloat moveY = keyboardFrame.origin.y - self.view.frame.size.height+100;
//
//    [UIView animateWithDuration:duration animations:^{
//        self.backgroundView.transform = CGAffineTransformMakeTranslation(0, moveY);
//    }];
   
}
- (void)keyboardWillHide:(NSNotification*)notification {
//    double duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    [UIView animateWithDuration:duration animations:^{
//
//         self.backgroundView.transform = CGAffineTransformIdentity;
//     }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}




#pragma mark - 通过链接进入课堂或者回放

-(void)openUrl:(NSString*)aString{
    
    //        aString = @"http://global.talk-cloud.net:80/static/h5/index.html#/replay?host=global.talk-cloud.net&domain=test&serial=2105172330&type=0&path=global.talk-cloud.net:8081/r3/2017-12-15/2105172330/1513309368/";
    //    aString = @"http://demo.talk-cloud.net:80/static/h5/index.html#/replay?host=demo.talk-cloud.net&domain=newtest&serial=1370449456&type=0&path=demo.talk-cloud.net:8081/demor1/2018-01-07/1370449456/1515319072/";
    //        aString = @"http://demo.talk-cloud.net:80/static/h5/index.html#/replay?host=demo.talk-cloud.net&domain=newtest&serial=1227506405&type=3&path=demo.talk-cloud.net:8081/demor1/2018-01-08/1227506405/1515383539/";
    
    
//    aString = @"https://demo.talk-cloud.net/WebAPI/entry/domain/szbdjy/serial/1990694487/username/student/usertype/2/pid/64/ts/1532144665/auth/268597f9d0743f0b5895d76c02fadd17/userpassword/72eddd8f548f4ea3ab35aa9d93ae8610/jumpurl/https%3A%2F%2Fwww.bedakid.com%2F";
    
    aString = [aString stringByRemovingPercentEncoding];

    BOOL isPlayback;
    NSString *storedServer;
    NSString *defaultServer;
    NSArray *tParamArray = [aString componentsSeparatedByString:@"?"];
    if ([tParamArray count]>1) {
        
        if ([tParamArray[0] containsString:@"replay"]) {
//         if ([tParamArray[1] containsString:@"path"]) {
            isPlayback = YES;
            // 该链接是回放连接
            NSArray *tParamArray2 = [[tParamArray objectAtIndex:1] componentsSeparatedByString:@"&"];
            NSMutableDictionary *tDic = @{}.mutableCopy;
            
            for (int i = 0; i<[tParamArray2 count]; i++) {
                NSArray *tArray= [[tParamArray2 objectAtIndex:i] componentsSeparatedByString:@"="];
                NSString *tKey = [tArray objectAtIndex:0];
                NSString *tValue = [tArray objectAtIndex:1];
                [tDic setValue:tValue forKey:tKey];
            }
            
#ifdef Debug
            // 截取host的服务器地址段
            NSString *server = [NSString stringWithFormat:@"%@", [[[tDic objectForKey:@"host"] componentsSeparatedByString:@"."] firstObject]];
            if (server) {
                [tDic setValue:server forKey:@"server"];
                self.defaultServer = server;
            }
            
            // 如果本地保存了默认服务器，则从选择本地的服务器
            storedServer = [[NSUserDefaults standardUserDefaults] objectForKey:@"server"];
            if (storedServer != nil) {
                defaultServer = storedServer;
            }
#else
            // 截取host的服务器地址段
            NSString *server = [NSString stringWithFormat:@"%@", [[[tDic objectForKey:@"host"] componentsSeparatedByString:@"."] firstObject]];
            if (server) {
                [tDic setValue:server forKey:@"server"];
                self.defaultServer = server;
            }
            
            // 如果本地保存了默认服务器，则从选择本地的服务器
            storedServer = [[NSUserDefaults standardUserDefaults] objectForKey:@"server"];
            if (storedServer != nil) {
                defaultServer = storedServer;
            }
#endif
            
            [tDic setObject:@(isPlayback) forKey:@"playback"];
            NSString *type = tDic[@"type"];
            if (!type || type.length==0) {
                [tDic setObject:@"3" forKey:@"type"];
            }
            [TKEduClassRoom joinPlaybackRoomWithParamDic:tDic ViewController:self Delegate:self isFromWeb:YES];
        } else {
            isPlayback = NO;
            NSArray *tParamArray2 = [[tParamArray objectAtIndex:1] componentsSeparatedByString:@"&"];
            NSMutableDictionary *tDic = @{}.mutableCopy;
            
            for (int i = 0; i<[tParamArray2 count]; i++) {
                NSArray *tArray= [[tParamArray2 objectAtIndex:i] componentsSeparatedByString:@"="];
                
                NSString *tKey = [tArray objectAtIndex:0];
                NSString *tValue = [tArray objectAtIndex:1];
                [tDic setValue:tValue forKey:tKey];
                
            }
            
#ifdef Debug
            // 截取host的服务器地址段
            NSString *server = [NSString stringWithFormat:@"%@", [[[tDic objectForKey:@"host"] componentsSeparatedByString:@"."] firstObject]];
            if (server) {
                [tDic setValue:server forKey:@"server"];
                self.defaultServer = server;
            }
            
            // 如果本地保存了默认服务器，则从选择本地的服务器
            storedServer = [[NSUserDefaults standardUserDefaults] objectForKey:@"server"];
            if (storedServer != nil) {
                defaultServer = storedServer;
            }
#else
            // 截取host的服务器地址段
            NSString *server = [NSString stringWithFormat:@"%@", [[[tDic objectForKey:@"host"] componentsSeparatedByString:@"."] firstObject]];
            if (server) {
                [tDic setValue:server forKey:@"server"];
                self.defaultServer = server;
            }
            
            // 如果本地保存了默认服务器，则从选择本地的服务器
            storedServer = [[NSUserDefaults standardUserDefaults] objectForKey:@"server"];
            if (storedServer) {
                defaultServer = storedServer;
            }
#endif
            
            [tDic setObject:@(isPlayback) forKey:@"playback"];
            
            [tDic setObject:@(3) forKey:@"clientType"];
            
            [TKEduClassRoom joinRoomWithParamDic:tDic ViewController:self Delegate:self isFromWeb:YES];
        }
        
    }else{
        
        TKAlertView *alert = [[TKAlertView alloc]initWithTitle:MTLocalized(@"Prompt.prompt") contentText:MTLocalized(@"Prompt.prompt") confirmTitle:MTLocalized(@"Prompt.Know")];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [alert show];
        });
        
        
    }
}




#pragma mark TKEduEnterClassRoomDelegate
//error.code  Description:error.description
- (void) onEnterRoomFailed:(int)result Description:(NSString*)desc{
    TKLog(@"-----onEnterRoomFailed");
}
- (void) onKitout:(EKickOutReason)reason{
    TKLog(@"-----onKitout");
}
- (void) joinRoomComplete{
    TKLog(@"-----joinRoomComplete");
}
- (void) leftRoomComplete{
    TKLog(@"-----leftRoomComplete");
}
- (void) onClassBegin{
    TKLog(@"-----onClassBegin");
}
- (void) onClassDismiss{
    TKLog(@"-----onClassDismiss");
}
- (void) onCameraDidOpenError{
    TKLog(@"-----onCameraDidOpenError");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
