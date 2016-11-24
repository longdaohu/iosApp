//
//  NewLoginRegisterViewController.m
//  myOffer
//
//  Created by xuewuguojie on 15/10/27.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "NewLoginRegisterViewController.h"
#import "FXBlurView.h"
#import "NewForgetPasswdViewController.h"
#import "UMSocial.h"
#import "APService.h"
#import "LoginSelectViewController.h"
#import "BangViewController.h"

@interface NewLoginRegisterViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
//蒙版
@property (weak, nonatomic) IBOutlet FXBlurView *LoginBlurView;
//后退按钮
@property (weak, nonatomic) IBOutlet KDEasyTouchButton *backButton;
//XX按钮
@property (weak, nonatomic) IBOutlet KDEasyTouchButton *DismissButton;
//验证码Timer
@property(nonatomic,strong)NSTimer *verifyCodeColdDownTimer;
//验证码倒计时
@property(nonatomic,assign)int verifyCodeColdDownCount;

@property (weak, nonatomic) IBOutlet UITextField *LoginPhoneNumberTextF;

@property (weak, nonatomic) IBOutlet UITextField *LoginPasswdTextF;
//注册地区编号
@property (weak, nonatomic) IBOutlet UITextField *RegisterAreaTextF;
//注册手机号
@property (weak, nonatomic) IBOutlet UITextField *RegisterPhoneTextF;
//注册验证码
@property (weak, nonatomic) IBOutlet UITextField *RegisterVerTextF;
//注册密码
@property (weak, nonatomic) IBOutlet UITextField *RegisterPasswdTextF;
//发送验证码按钮
@property (weak, nonatomic) IBOutlet UIButton *VertifButton;
//地区编号选项
@property(nonatomic,strong)UIPickerView *AreaPicker;
@property(nonatomic,strong)UIPickerView *NextAreaPicker;
//地区编号数组
@property(nonatomic,strong)NSArray *Areas;
//登录——忘记密码
@property (weak, nonatomic) IBOutlet UIButton *ForgetButton;
//登录——或者Lab
@property (weak, nonatomic) IBOutlet UILabel *ORlabel;
//登录——提交登录按钮
@property (weak, nonatomic) IBOutlet UIButton *commitLoginButton;
//切换登录选项
@property (weak, nonatomic) IBOutlet UIButton *LoginSelectButton;
//切换注册选项
@property (weak, nonatomic) IBOutlet UIButton *SignUpselectButton;
//注册提交按钮
@property (weak, nonatomic) IBOutlet UIButton *RegisterCommitButton;
//弹出注册页面
@property (weak, nonatomic) IBOutlet KDEasyTouchButton *LoginAButton;
//弹出登录页面
@property (weak, nonatomic) IBOutlet KDEasyTouchButton *RegisterAButton;
//查看服务条款
@property (weak, nonatomic) IBOutlet UIButton *ServiceButton;
@property (weak, nonatomic) IBOutlet UIView *ButtonView;
//欢迎图片
@property (weak, nonatomic) IBOutlet UIImageView *welcomeMV;
//切换注册登录的三角图标
@property(nonatomic,strong)UIImageView *FocusMV;
//Logo图片
@property (weak, nonatomic) IBOutlet UIImageView *logoMV;

//收集用户资料
//蒙版背景
@property(nonatomic,strong)UIView *coverView;
//蒙版
@property(nonatomic,strong)UIButton *cover;

@property (weak, nonatomic) IBOutlet UIImageView *arrow_right;
@property (weak, nonatomic) IBOutlet UIButton *showPasswdBtn;



@end

@implementation NewLoginRegisterViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    [MobClick beginLogPageView:@"page登录页面"];

//    if ([[AppDelegate sharedDelegate] isLogin]) {
//        //用于判断用户第三方登录第一次登录时，按返回键返回时是否已登录成功，如果已登录成功则进入首页
//        [self dismiss];
//    }
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page登录页面"];
    
}

-(void)RegisterAreaTextfieldArrow
{
    
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
         self.arrow_right.transform = self.RegisterAreaTextF.isEditing? CGAffineTransformRotate(self.arrow_right.transform, M_PI):CGAffineTransformIdentity;
    }];
    
}



//用于添加控件、设置控件相关属性
-(void)makeLoginRegiterView
{
    
     self.xLoginRegistView.frame  = CGRectMake(0,XScreenHeight, XScreenWidth, XScreenHeight*2/3);
    [self.view addSubview:self.xLoginRegistView];
     self.xLoginView.frame =CGRectMake(0, 40, XScreenWidth, XScreenHeight*2/3 - 40);
    [self.xLoginRegistView addSubview:self.xLoginView];
     self.RegisterAreaTextF.inputView = self.AreaPicker;
    [self.RegisterAreaTextF addTarget:self action:@selector(RegisterAreaTextfieldArrow) forControlEvents:UIControlEventEditingDidBegin];
    [self.RegisterAreaTextF addTarget:self action:@selector(RegisterAreaTextfieldArrow) forControlEvents:UIControlEventEditingDidEnd];
    _LoginBlurView.dynamic = NO;
    [_LoginBlurView setFrame:self.view.bounds];
    [_LoginBlurView setTintColor:nil];
    [_LoginBlurView setIterations:3];
    [_LoginBlurView setBlurRadius:10];
    [_LoginBlurView updateAsynchronously:YES completion:^{}];
    self.LoginAButton.layer.cornerRadius = 2;
    self.RegisterAButton.layer.cornerRadius = 2;
    self.commitLoginButton.layer.cornerRadius = 2;
    self.RegisterCommitButton.layer.cornerRadius = 2;

    self.RegisterAButton.adjustAllRectWhenHighlighted = YES;
    self.RegisterAButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.RegisterAButton.layer.borderWidth = 2;
    self.commitLoginButton.backgroundColor = XCOLOR_RED;
    self.RegisterCommitButton.backgroundColor = XCOLOR_RED;
    self.ServiceButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.VertifButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    self.FocusMV =[[UIImageView alloc] initWithFrame:CGRectMake(0,30, 30, 10)];
    self.FocusMV.contentMode =  UIViewContentModeScaleAspectFit;
    self.FocusMV.image =[UIImage imageNamed:@"Triangle"];
    [self.ButtonView addSubview:self.FocusMV];
    self.FocusMV.center = CGPointMake(self.LoginSelectButton.center.x, 38);
    
    self.LoginPhoneNumberTextF.returnKeyType = UIReturnKeyNext;
    self.RegisterPasswdTextF.returnKeyType = UIReturnKeyNext;
    self.LoginPhoneNumberTextF.delegate = self;
    self.LoginPasswdTextF.delegate = self;
    self.RegisterPasswdTextF.delegate = self;
    [self.LoginPasswdTextF addTarget:self action:@selector(loginPasswordValueChange:) forControlEvents:UIControlEventEditingChanged];
}



-(NSArray *)Areas
{
    if (!_Areas) {
        
        _Areas = @[@"中国(+86)",@"英国(+44)",@"马来西亚(+60)"];
     }
    return _Areas;
}


-(UIPickerView *)AreaPicker
{
    if (!_AreaPicker) {
      
        _AreaPicker =[[UIPickerView alloc] init];
        _AreaPicker.delegate =self;
        _AreaPicker.dataSource =self;
         NSUInteger row = USER_EN ? 1 : 0;
        [_AreaPicker selectRow:row inComponent:0 animated:YES];
        
    }
    return _AreaPicker;
}

-(UIPickerView *)NextAreaPicker
{
    if (!_NextAreaPicker) {
        _NextAreaPicker =[[UIPickerView alloc] init];
        _NextAreaPicker.delegate =self;
        _NextAreaPicker.dataSource =self;
        
        NSUInteger row = USER_EN ? 1 : 0;
        
        [_NextAreaPicker selectRow:row inComponent:0 animated:YES];
        
    }
    return _NextAreaPicker;
}

//设置控件中英文
-(void)ChangLanguageView
{
//    self.logoMV.image = [UIImage imageNamed:GDLocalizedString(@"LoginVC-icon")];
    self.LoginPhoneNumberTextF.placeholder = @"请输入手机号码/邮箱";
    self.LoginPasswdTextF.placeholder = @"请输入6-16位密码";
    [self.ForgetButton setTitle:GDLocalizedString(@ "LoginVC-003")  forState:UIControlStateNormal];
    [self.commitLoginButton setTitle:GDLocalizedString(@"LoginVC-001") forState:UIControlStateNormal];
    self.ORlabel.text =GDLocalizedString(@"LoginVC-OR");
    [self.LoginSelectButton setTitle:GDLocalizedString(@"LoginVC-001") forState:UIControlStateNormal];
    [self.SignUpselectButton setTitle:GDLocalizedString(@"LoginVC-002") forState:UIControlStateNormal];
    self.RegisterAreaTextF.text =  USER_EN ? GDLocalizedString(@"LoginVC-english"):GDLocalizedString(@"LoginVC-china");
    self.RegisterPhoneTextF.placeholder = @"请输入新手机号码";
    self.RegisterVerTextF.placeholder = GDLocalizedString(@"LoginVC-007");
    [self.RegisterCommitButton setTitle:GDLocalizedString(@"LoginVC-002") forState:UIControlStateNormal];
    [self.VertifButton setTitle:GDLocalizedString(@"LoginVC-008") forState:UIControlStateNormal];
    [self.RegisterAButton setTitle:GDLocalizedString(@"LoginVC-001") forState:UIControlStateNormal];
    [self.LoginAButton setTitle:GDLocalizedString(@"LoginVC-002") forState:UIControlStateNormal];
    [self.welcomeMV setImage:[UIImage imageNamed:GDLocalizedString(@"LoginVC-welImage")]];
     NSString *serviceString = GDLocalizedString(@ "LoginVC-0010");
     NSRange NotiRangne =[serviceString rangeOfString:GDLocalizedString(@ "LoginVC-keyWord")];
     NSMutableAttributedString *AtributeStr = [[NSMutableAttributedString alloc] initWithString:serviceString ];
     [AtributeStr addAttribute:NSForegroundColorAttributeName value:XCOLOR_RED range: NotiRangne];
     [AtributeStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NotiRangne];
     [self.ServiceButton setAttributedTitle: AtributeStr forState:UIControlStateNormal];
 }


- (void)makeNotificationCenter
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self makeLoginRegiterView];
    [self ChangLanguageView];
    [self makeNotificationCenter];

}

#pragma mark ——————- 键盘处理
- (void)keyboardWillShow:(NSNotification *)aNotification {
    self.backButton.hidden = YES;
    self.DismissButton.hidden = YES;
    [self moveTextViewForKeyboard:aNotification up:YES];
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    self.backButton.hidden = NO;
    self.DismissButton.hidden = NO;
    [self moveTextViewForKeyboard:aNotification up:NO];
}

- (void) moveTextViewForKeyboard:(NSNotification*)aNotification up: (BOOL) up {
    NSDictionary* userInfo = [aNotification userInfo];
      NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [userInfo[UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [userInfo[UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [userInfo[UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    // Animate up or down
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    UIView  *moveView  =  self.xLoginRegistView;
    
    if (up) {
        moveView.center = CGPointMake(self.view.frame.size.width / 2.0f, (self.view.frame.size.height - keyboardEndFrame.size.height) / 2.0f + 40.0);
        
     } else {
         
       moveView.center = CGPointMake(self.view.frame.size.width / 2.0f, XScreenHeight*2/3);
    }
    
    [self.view layoutSubviews];
    
    [UIView commitAnimations];
}


- (IBAction)changeLoginView:(UIButton *)sender {
  
     [self LoginView:NO withSender:sender];

 }
- (IBAction)changeRegisterView:(UIButton *)sender {
   
    [self LoginView:YES withSender:sender];
}

//注册登录页面显示、隐藏
-(void)LoginView:(BOOL)hiden withSender:(UIButton *)sender
{
    
   [self.view endEditing:YES];
    
    self.xRegisterView.hidden = !hiden;
    self.xLoginView.hidden = hiden;
    
    [UIView animateWithDuration:0.01 animations:^{
    
        self.FocusMV.center = CGPointMake(sender.center.x, 38);
        
    }];
    
    
    if ([sender.currentTitle isEqualToString:@"登录"] || self.RegisterPasswdTextF.secureTextEntry == NO) {
        
        [self showPassword:self.showPasswdBtn];
    }
    

}

-(void)LoginViewShow:(BOOL)show sender:(UIButton *)sender
{
   
    CGRect NewRect = self.xLoginRegistView.frame;
    NewRect.origin.y = show ? XScreenHeight / 3 : XScreenHeight;
    NewRect.size.width = XScreenWidth;
    NewRect.size.height = 2 * XScreenHeight/3;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.LoginBlurView.alpha = show ? 1 : 0;
        self.backButton.alpha = show ? 1 : 0;
        self.xLoginRegistView.frame = NewRect;
        
    }];
    
  
    if ([sender.currentTitle isEqualToString:GDLocalizedString(@"LoginVC-002")]) {
        
        
        self.xLoginView.hidden = YES;
        self.FocusMV.center = CGPointMake(XScreenWidth*0.75,38);
        
    }else if([sender.currentTitle isEqualToString:GDLocalizedString(@"LoginVC-001")]){
        

        
        
        self.xRegisterView.hidden = YES;
        self.FocusMV.center = CGPointMake(XScreenWidth*0.25,38);
        
    }else{
        
        
        self.LoginPasswdTextF.text = @"";
        self.LoginPhoneNumberTextF.text = @"";

        
        self.RegisterPhoneTextF.text = @"";
        self.RegisterVerTextF.text = @"";
        self.RegisterPasswdTextF.text = @"";
        self.VertifButton.enabled = YES;
        [self.VertifButton setTitle:@"获取验证码"  forState:UIControlStateNormal];
        [self.verifyCodeColdDownTimer invalidate];
        _verifyCodeColdDownTimer = nil;
        
        self.xLoginView.hidden = NO;
        self.xRegisterView.hidden = NO;
        
    }
 
}

//跳转登录页面按钮   //跳转注册页面按钮
- (IBAction)LoginButtonPressed:(UIButton *)sender {
    
      [self LoginViewShow:YES sender:sender];
  
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
   
    if ([[AppDelegate sharedDelegate] isLogin]) {
        
        return;
    }
    
    [self.view  endEditing:YES];
}


#pragma mark ————————正常（非第三方）登录
- (IBAction)LoginButtonCommit:(id)sender {
    
 
    if (![self checkNetworkState]) {
        
        return;
    }
    
    
    if (self.LoginPhoneNumberTextF.text.length == 0) {
        
         AlerMessage(@"手机号码不能为空");
        
        return;
    }
    if (self.LoginPasswdTextF.text.length == 0) {
        
        AlerMessage(@"密码不能为空");
        
        return;
    }
    
    [self
     startAPIRequestWithSelector:kAPISelectorLogin
     parameters:@{@"username":self.LoginPhoneNumberTextF.text , @"password": self.LoginPasswdTextF.text}
     success:^(NSInteger statusCode, NSDictionary *response) {
  
         [self LoginSuccessWithResponse:response];
  
     }];
  
}


//正常（非第三方）登录成功相关处理
-(void)LoginSuccessWithResponse:(NSDictionary *)response
{
    [APService setAlias:response[@"jpush_alias"] callbackSelector:nil object:nil];//Jpush设置登录用户别名
    [[AppDelegate sharedDelegate] loginWithAccessToken:response[@"access_token"]];
    [MobClick profileSignInWithPUID:response[@"access_token"]];/*友盟统计记录用户账号*/
    [MobClick event:@"myofferUserLogin"];
    
    //当用户没有电话时发出通知，让用户填写手机号
    NSString *phone =response[@"phonenumber"];
    

    
    if (phone.length == 0) {
        
        [self.view endEditing:YES];
        
    }else{
        
        KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
        [hud applySuccessStyle];
        [hud hideAnimated:YES afterDelay:2];
        [hud setHiddenBlock:^(KDProgressHUD *hud) {
            
            [self dismiss];
            
        }];
        
    }
    
}



#pragma mark ———————— 第三方登录
- (IBAction)otherLogin:(UIButton *)sender
{
    
    NSString *shareplatform;
    NSString *platformName;
    if ( 999 == sender.tag) {
     
        shareplatform = UMShareToSina;
        platformName = @"weibo";
        
    }else if ( 998 == sender.tag) {
        
        shareplatform = UMShareToQzone;
        platformName = @"qq";

    }else {

        shareplatform = UMShareToWechatSession;
        platformName = @"wechat";

    }
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:shareplatform];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:shareplatform];
            NSMutableDictionary *weixinInfo =[NSMutableDictionary dictionary];
            [weixinInfo setValue:snsAccount.usid forKey:@"user_id"];
            [weixinInfo setValue:platformName forKey:@"provider"];
            [weixinInfo setValue:snsAccount.accessToken forKey:@"token"];
            [self  loginWithParameters:weixinInfo];
        }
    });
    
 
}


#pragma mark ———————— 第三方登录传参并登录
-(void)loginWithParameters:(NSMutableDictionary *)userInfo
{

    //存储第三方登录平台信息
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setValue:userInfo[@"provider"]  forKey:@"provider"];
    [ud synchronize];
    
    [self  startAPIRequestWithSelector:kAPISelectorLogin  parameters:userInfo success:^(NSInteger statusCode, NSDictionary *response) {
        
         if (response[@"new"]) {
             
            LoginSelectViewController *selectVC =[[LoginSelectViewController alloc] initWithNibName:@"LoginSelectViewController" bundle:[NSBundle mainBundle]];
            selectVC.parameter = userInfo;
            [self.navigationController pushViewController:selectVC animated:YES];
             
        }
        else if([response[@"role"] isEqualToString:@"user"])
        {
            
            [self OtherLoginSuccessWithResponse:response andUserInfo:userInfo];
            
        }
        
    }];
    
}

//登录前判断用户资料是否包含手机号码
-(void)OtherLoginSuccessWithResponse:(NSDictionary *)response andUserInfo:(NSDictionary *)userInfo
{
    [APService setAlias:response[@"jpush_alias"] callbackSelector:nil object:nil];//Jpush设置登录用户别名
    
    [[AppDelegate sharedDelegate] loginWithAccessToken:response[@"access_token"]];
    
    [MobClick profileSignInWithPUID:response[@"access_token"] provider:[userInfo valueForKey:@"provider"]];/*友盟统计记录用户账号*/
    
    [MobClick event:@"otherUserLogin"];
    
    //当用户没有电话时发出通知，让用户填写手机号
    !response[@"phonenumber"]? [self caseBangding] :  [self dismiss];
    

}

//发送验证码
- (IBAction)SendVertificationCode:(id)sender {
    
    NSString *nomalError = @"手机号码格式错误";

    
     if (self.RegisterPhoneTextF.text.length == 0) {
         
         AlerMessage(@"手机号码不能为空");
         
         return ;
    }
    
    
    if ([self.RegisterAreaTextF.text containsString:@"86"]) {
        
        NSString *firstChar = [self.RegisterPhoneTextF.text substringWithRange:NSMakeRange(0, 1)];
        NSString *errorStr;
        if (![firstChar isEqualToString:@"1"] || self.RegisterPhoneTextF.text.length != 11) {
            
            errorStr = @"请输入“1”开头的11位数字";
            
            AlerMessage(errorStr);

            return;
            
        }
        
    }

    
    
    if ([self.RegisterAreaTextF.text containsString:@"44"]) {
        
        NSString *firstChar = [self.RegisterPhoneTextF.text substringWithRange:NSMakeRange(0, 1)];
        NSString *errorStr;
        
        if (![firstChar isEqualToString:@"7"] || self.RegisterPhoneTextF.text.length != 10) {
            
            errorStr = @"请输入“7”开头的10位数字";
            
            AlerMessage(errorStr);
            
            return;
            
        }
        
    }

    
    if ([self.RegisterAreaTextF.text containsString:@"60"] && (self.RegisterPhoneTextF.text.length > 9 || self.RegisterPhoneTextF.text.length < 7) ) {
       
        AlerMessage(nomalError);
        
        return;
        
    }
    
 
    NSString *areaCode;
    
    if ([self.RegisterAreaTextF.text containsString:@"44"]) {
        
        areaCode = @"44";
        
    }else if( [self.RegisterAreaTextF.text containsString:@"60"]){
        
        areaCode = @"60";
        
    }else{
        
        areaCode = @"86";
    }

    
    NSString *phoneNumber = self.RegisterPhoneTextF.text;
    
     self.VertifButton.enabled = NO;
    
    [self startAPIRequestWithSelector:kAPISelectorSendVerifyCode  parameters:@{@"code_type":@"register", @"phonenumber":  phoneNumber, @"target": phoneNumber, @"mobile_code": areaCode}  expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        self.verifyCodeColdDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runVerifyCodeColdDownTimer) userInfo:nil repeats:YES];
        self.verifyCodeColdDownCount= 60;
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        self.VertifButton.enabled = YES;
    }];
    
    
    
}
//@"验证码倒计时"
- (void)runVerifyCodeColdDownTimer {

    self.verifyCodeColdDownCount--;
      if (self.verifyCodeColdDownCount > 0) {
 
        [self.VertifButton setTitle:[NSString stringWithFormat:@"%@%d%@",GDLocalizedString(@"LoginVC-0013"), self.verifyCodeColdDownCount,GDLocalizedString(@"LoginVC-0014")] forState:UIControlStateNormal];
          
    } else {
        self.VertifButton.enabled = YES;
        [self.VertifButton setTitle:@"重新发送"  forState:UIControlStateNormal];
        [self.verifyCodeColdDownTimer invalidate];
        _verifyCodeColdDownTimer = nil;
    }
}

#pragma mark ———————— 提交注册信息
- (IBAction)RegisterButtonCommitPressed:(id)sender {
    
    
    if (![self checkNetworkState]) {
        
        
        return;
    }
    
    
    if (![self verifyRegisterFields]) {
        
        return;
    }
    
     NSString *AreaNumber =[self.RegisterAreaTextF.text containsString:@"44"]?@"44": @"86";
    
    [self
     startAPIRequestWithSelector:kAPISelectorRegister
     parameters:@{@"mobile_code":AreaNumber,@"username":self.RegisterPhoneTextF.text, @"password":self.RegisterPasswdTextF.text, @"vcode": @{@"code":self.RegisterVerTextF.text}}
     success:^(NSInteger statusCode, NSDictionary *response) {
       
         KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
         
         [[AppDelegate sharedDelegate] loginWithAccessToken:response[@"access_token"]];
         
         [MobClick event:@"myoffer_Register"];
         [MobClick profileSignInWithPUID:response[@"access_token"]];/*友盟统计记录用户账号*/

         
         [hud applySuccessStyle];
         [hud hideAnimated:YES afterDelay:2];
         [hud setHiddenBlock:^(KDProgressHUD *hud) {
             [self dismiss];
         }]; 
     }];

}
//注册相关字段验证
- (BOOL)verifyRegisterFields {
    
    
    NSString *nomalError = @"手机号码格式错误";
    
 
    if (self.RegisterPhoneTextF.text.length == 0) {
        
        AlerMessage(@"手机号码不能为空");
        
        return NO;
    }
    
    
    if ([self.RegisterAreaTextF.text containsString:@"86"]) {
        
        NSString *firstChar = [self.RegisterPhoneTextF.text substringWithRange:NSMakeRange(0, 1)];
        NSString *errorStr;
        if (![firstChar isEqualToString:@"1"] || self.RegisterPhoneTextF.text.length != 11) {
            
            errorStr = @"请输入“1”开头的11位数字";
            
            AlerMessage(errorStr);
            
            return NO;
            
        }
        
    }
    
    
    
    if ([self.RegisterAreaTextF.text containsString:@"44"]) {
        
        NSString *firstChar = [self.RegisterPhoneTextF.text substringWithRange:NSMakeRange(0, 1)];
        NSString *errorStr;
        
        if (![firstChar isEqualToString:@"7"] || self.RegisterPhoneTextF.text.length != 10) {
            
            errorStr = @"请输入“7”开头的10位数字";
            
            AlerMessage(errorStr);
            
            return NO;
            
        }
        
    }
    
    
    
    if ([self.RegisterAreaTextF.text containsString:@"60"] && (self.RegisterPhoneTextF.text.length > 9 || self.RegisterPhoneTextF.text.length < 7) ) {
        
        AlerMessage(nomalError);
        
        return NO;
        
    }
 
 
    if (self.RegisterVerTextF.text.length == 0) {
        AlerMessage(@"验证码不能为空");
        return NO;
    }
    
    
    if (self.RegisterPasswdTextF.text.length == 0) {
        
        AlerMessage(self.RegisterPasswdTextF.placeholder);
        
        return NO;
    }
    
    
    if(self.RegisterPasswdTextF.text.length < 6 || self.RegisterPasswdTextF.text.length >16)
    {   //@"密码长度不小于6个字符"
         AlerMessage(GDLocalizedString(@"Person-passwd"));
         return NO;
    }
   
    return YES;
}


//返回注册登录第一页
- (IBAction)backButtonPressed:(KDEasyTouchButton *)sender {
  
    [self LoginViewShow:NO sender:sender];
    
}
//退出登录页面
- (IBAction)popButtonPressed:(KDEasyTouchButton *)sender {
    
    [self dismiss];
}

#pragma mark ———————— 点击进入服务条款页面
- (IBAction)ServiceButtonPressed:(id)sender {
  
      WebViewController  *service =[[WebViewController alloc] init];
      service.path =  [NSString stringWithFormat:@"http://www.myoffer.cn/docs/%@/web-agreement.html",GDLocalizedString(@"ch_Language")];
      [self.navigationController pushViewController:service animated:YES];
    
}

#pragma  Mark  —————————— UIPickerViewDataSource, UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.Areas.count;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return self.Areas[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
      self.RegisterAreaTextF.text = self.Areas[row];
    
}

#pragma mark ——— UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    return YES;
}

 - (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.LoginPhoneNumberTextF) {
        
        [self.LoginPasswdTextF becomeFirstResponder];
        
    }else if (textField == self.LoginPasswdTextF)
    {
        [self LoginButtonCommit:nil];
        
    }else if (textField == self.RegisterPasswdTextF)
    {
        [self RegisterButtonCommitPressed:nil];

    }
 
    
    return YES;
}


 
- (void)caseBangding{
    
    [self.navigationController pushViewController:[[BangViewController alloc] init] animated:YES];
}



// 点击忘记密码
- (IBAction)ForgetPasswdButtonPressed:(id)sender {
    
    [self.navigationController pushViewController:[[NewForgetPasswdViewController alloc] initWithNibName:@"NewForgetPasswdViewController" bundle:nil] animated:YES];
    
}

- (IBAction)showPassword:(UIButton *)sender {

     // 切换按钮的状态   密码输入框是否显示明文
    sender.selected = !sender.selected;
    
    self.RegisterPasswdTextF.secureTextEntry = !self.RegisterPasswdTextF.secureTextEntry;
    NSString *imageName = sender.selected ? @"showpassword" : @"hidepassword";
    [sender setImage:XImage(imageName) forState:UIControlStateNormal];
    
}


//监听登录密码输入位数
- (void)loginPasswordValueChange:(UITextField *)textField{

    if (textField.text.length > 16) {
        textField.text = [textField.text substringWithRange:NSMakeRange(0, 16)];
    }
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

KDUtilRemoveNotificationCenterObserverDealloc



@end


