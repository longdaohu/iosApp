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
#import "DetailWebViewController.h"
#import "UMSocial.h"
#import "APService.h"
#import "YourPhoneView.h"
#import "LoginSelectViewController.h"

@interface NewLoginRegisterViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,YourPhoneViewDelegate>
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
//注册密码验证
@property (weak, nonatomic) IBOutlet UITextField *RegisterRepwdTextF;
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
//手机号码编辑框
@property(nonatomic,strong)YourPhoneView *PhoneView;
@property (weak, nonatomic) IBOutlet UIImageView *arrow_right;

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
    
    [UIView animateWithDuration:0.25 animations:^{
         self.arrow_right.transform = self.RegisterAreaTextF.isEditing? CGAffineTransformRotate(self.arrow_right.transform, M_PI):CGAffineTransformIdentity;
    }];
    
}



//用于添加控件、设置控件相关属性
-(void)makeLoginRegiterView
{
     self.xLoginRegistView.frame  = CGRectMake(0,APPSIZE.height, APPSIZE.width, APPSIZE.height*2/3);
    [self.view addSubview:self.xLoginRegistView];
     self.xLoginView.frame =CGRectMake(0, 40, APPSIZE.width, APPSIZE.height*2/3 - 40);
    [self.xLoginRegistView addSubview:self.xLoginView];
     self.RegisterAreaTextF.inputView = self.AreaPicker;
    [self.RegisterAreaTextF addTarget:self action:@selector(RegisterAreaTextfieldArrow) forControlEvents:UIControlEventEditingDidBegin];
    [self.RegisterAreaTextF addTarget:self action:@selector(RegisterAreaTextfieldArrow) forControlEvents:UIControlEventEditingDidEnd];
    _LoginBlurView.dynamic = NO;
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
    self.RegisterRepwdTextF.delegate = self;
}



-(NSArray *)Areas
{
    if (!_Areas) {
        
         _Areas = @[GDLocalizedString(@"LoginVC-china"),GDLocalizedString(@"LoginVC-english")];
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
    self.LoginPhoneNumberTextF.placeholder = GDLocalizedString(@"LoginVC-004");
    self.LoginPasswdTextF.placeholder = GDLocalizedString(@"LoginVC-0011");
    [self.ForgetButton setTitle:GDLocalizedString(@ "LoginVC-003")  forState:UIControlStateNormal];
    [self.commitLoginButton setTitle:GDLocalizedString(@"LoginVC-001") forState:UIControlStateNormal];
    self.ORlabel.text =GDLocalizedString(@"LoginVC-OR");
    [self.LoginSelectButton setTitle:GDLocalizedString(@"LoginVC-001") forState:UIControlStateNormal];
    [self.SignUpselectButton setTitle:GDLocalizedString(@"LoginVC-002") forState:UIControlStateNormal];
    
    self.RegisterAreaTextF.text =  USER_EN ? GDLocalizedString(@"LoginVC-english"):GDLocalizedString(@"LoginVC-china");
    self.RegisterPhoneTextF.placeholder = GDLocalizedString(@"LoginVC-006");
    self.RegisterVerTextF.placeholder = GDLocalizedString(@"LoginVC-007");
    self.RegisterPasswdTextF.placeholder = GDLocalizedString(@"LoginVC-005");
    self.RegisterRepwdTextF.placeholder = GDLocalizedString(@"LoginVC-009");
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
    
    UIView  *moveView  = self.PhoneView.frame.origin.y < XScreenHeight? self.PhoneView :self.xLoginRegistView;
    
    if (up) {
        moveView.center = CGPointMake(self.view.frame.size.width / 2.0f, (self.view.frame.size.height - keyboardEndFrame.size.height) / 2.0f +40.0);
        
     } else {
         
       moveView.center = CGPointMake(self.view.frame.size.width / 2.0f, APPSIZE.height*2/3);
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
        self.FocusMV.center = CGPointMake(APPSIZE.width*0.75,38);
        
    }else if([sender.currentTitle isEqualToString:GDLocalizedString(@"LoginVC-001")]){
        
        self.xRegisterView.hidden = YES;
        self.FocusMV.center = CGPointMake(APPSIZE.width*0.25,38);
        
    }else{
        
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
    
 
    if (self.LoginPhoneNumberTextF.text.length == 0) {
        
         AlerMessage(GDLocalizedString(@"LoginVC-004"));
        
        return;
    }
    if (self.LoginPasswdTextF.text.length == 0) {
        
        AlerMessage(GDLocalizedString(@"LoginVC-0011"));
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
        
        [self coverShow:YES];
        
    }else{
        
        KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
        [hud applySuccessStyle];
        [hud hideAnimated:YES afterDelay:2];
        [hud setHiddenBlock:^(KDProgressHUD *hud) {
            
            [self dismiss];
            
        }];
        
    }
    
}


// 点击忘记密码
- (IBAction)ForgetPasswdButtonPressed:(id)sender {
    
     [self.navigationController pushViewController:[[NewForgetPasswdViewController alloc] initWithNibName:@"NewForgetPasswdViewController" bundle:nil] animated:YES];

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
    NSString *phone =response[@"phonenumber"];
    
    if (!phone) {
        
        [self coverShow:YES];
        
    }else{
        
        [self dismiss];
     }

}

//发送验证码
- (IBAction)SendVertificationCode:(id)sender {
   
    
     if (self.RegisterAreaTextF.text.length == 0) {
         AlerMessage(self.RegisterAreaTextF.placeholder);
         return ;
    }
    
    if ([self.RegisterAreaTextF.text containsString:GDLocalizedString(@"LoginVC-chinese")] && self.RegisterPhoneTextF.text.length != 11) {
        
        AlerMessage(GDLocalizedString(@"LoginVC-PhoneNumberError"));
        
        return ;
    }
    
    if ([self.RegisterAreaTextF.text containsString:GDLocalizedString(@"LoginVC-england")] && self.RegisterPhoneTextF.text.length != 10) {
        //@"请输入 10 位的手机号"
        AlerMessage(GDLocalizedString(@"LoginVC-EnglandNumberError"));
        
        return ;
    }
    
     NSString *AreaNumber = [self.RegisterAreaTextF.text containsString:@"44"] ?@"44" : @"86";
     NSString *phoneNumber = self.RegisterPhoneTextF.text;
    
     self.VertifButton.enabled = NO;
    
    [self startAPIRequestWithSelector:kAPISelectorSendVerifyCode  parameters:@{@"code_type":@"register", @"phonenumber":  phoneNumber, @"target": phoneNumber, @"mobile_code": AreaNumber}  expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        
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
        [self.VertifButton setTitle:GDLocalizedString(@"LoginVC-008")   forState:UIControlStateNormal];
        [self.verifyCodeColdDownTimer invalidate];
        _verifyCodeColdDownTimer = nil;
    }
}

#pragma mark ———————— 提交注册信息
- (IBAction)RegisterButtonCommitPressed:(id)sender {
    
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
    
    if ([self.RegisterAreaTextF.text containsString:GDLocalizedString(@"LoginVC-chinese")] && self.RegisterPhoneTextF.text.length != 11) {
          AlerMessage(GDLocalizedString(@"LoginVC-PhoneNumberError"));
        return NO;
    }
    
    if ([self.RegisterAreaTextF.text containsString:GDLocalizedString(@"LoginVC-england")] && self.RegisterPhoneTextF.text.length != 10) {
        //@"请输入 11 位的手机号"
         AlerMessage(GDLocalizedString(@"LoginVC-EnglandNumberError"));
        return NO;
    }
     if (self.RegisterVerTextF.text.length == 0) {
          AlerMessage(GDLocalizedString(@"LoginVC-007"));

        return NO;
    }
    
    if (self.RegisterPasswdTextF.text.length == 0) {
        AlerMessage(self.RegisterPasswdTextF.placeholder);
          return NO;
    }
    
    if (self.RegisterRepwdTextF.text.length == 0) {
        AlerMessage(self.RegisterRepwdTextF.placeholder);
         return NO;
    }
    
    if(self.RegisterPasswdTextF.text.length < 6 || self.RegisterPasswdTextF.text.length >16)
    {   //@"密码长度不小于6个字符"
        AlerMessage(GDLocalizedString(@"Person-passwd"));
         return NO;
    }
    
    if (![self.RegisterPasswdTextF.text isEqualToString:self.RegisterRepwdTextF.text]) {
        AlerMessage(GDLocalizedString(@"ChPasswd-004") );
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
  
      DetailWebViewController  *service =[[DetailWebViewController alloc] init];
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
    
    if ([self.PhoneView.countryCode isFirstResponder]) {
        
        self.PhoneView.countryCode.text = self.Areas[row];

    }else {
    
        self.RegisterAreaTextF.text = self.Areas[row];

    }
    
}

#pragma  Mark  ——————————UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.PhoneView.countryCode) {
        NSInteger row = [self.PhoneView.countryCode.text containsString:@"86"] ? 0 : 1;
        [self.AreaPicker selectRow:row inComponent:0 animated:YES];
        
    }
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
        [self.RegisterRepwdTextF becomeFirstResponder];
    }else if (textField == self.RegisterRepwdTextF)
    {
        [self RegisterButtonCommitPressed:nil];
    }
    
    return YES;
}


#pragma mark —————————— 用户填写资料
-(YourPhoneView *)PhoneView
{
    if (!_PhoneView) {
        
        _PhoneView =[[YourPhoneView alloc] initWithFrame:CGRectMake(0, XScreenHeight, XScreenWidth, 260)];
        _PhoneView.countryCode.inputView = self.NextAreaPicker;
        _PhoneView.countryCode.delegate = self;
        _PhoneView.delegate = self;
        
    }
    return _PhoneView;
}

-(UIView *)coverView
{
    if (!_coverView) {
        
        _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XScreenWidth, XScreenHeight)];
        _coverView.backgroundColor = XCOLOR_CLEAR;
        _coverView.hidden = YES;
        [self.view insertSubview:_coverView aboveSubview:self.xLoginRegistView];
        [self.coverView addSubview:self.cover];
        [self.coverView addSubview:self.PhoneView];
        
    }
    
    return _coverView;
}
-(UIButton *)cover
{
    if (!_cover) {
        
        _cover =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, XScreenWidth, XScreenHeight)];
        _cover.backgroundColor = XCOLOR_BLACK;
        _cover.alpha = 0;
        
    }
    return _cover;
}



#pragma mark ————————  YourPhoneViewDelegate
-(void)YourPhoneView:(YourPhoneView *)PhoneView WithButtonItem:(UIButton *)sender
{
    if (11 == sender.tag) {
        [self backAndLogout];
        [self coverShow:NO];
    }else if(10 == sender.tag){
        [self sendVerifyCode];
    }else{
        [self CommitVerifyCode];
    }
    
}


// 提交验证码
-(void)CommitVerifyCode
{
    
    if (![self checkPhoneTextField]) {
        
        return ;
    }
    
    if (self.PhoneView.VerifyTF.text.length==0) {
        
         AlerMessage(GDLocalizedString(@"LoginVC-007"));
        
        return ;
    }
    
    
    NSMutableDictionary *infoParameters =[NSMutableDictionary dictionary];
    [infoParameters setValue:self.PhoneView.countryCode.text forKey:@"mobile_code"];
    [infoParameters setValue:self.PhoneView.PhoneTF.text forKey:@"phonenumber"];
    [infoParameters setValue:@{@"code":self.PhoneView.VerifyTF.text} forKey:@"vcode"];
    
    
    [self startAPIRequestWithSelector:@"POST api/account/updatephonenumber"
                           parameters:@{@"accountInfo":infoParameters}
                              success:^(NSInteger statusCode, id response) {
                                  
                                  [self dismiss];
                                  
                              }];
    
}


// 发送验证码
-(void)sendVerifyCode
{
    
    if (![self checkPhoneTextField]) {
        
        return ;
    }
    
    
    self.PhoneView.SendCodeBtn.enabled = NO;
    
    NSString *AreaNumber =  [ self.PhoneView.VerifyTF.text containsString:@"44"] ? @"44":@"86";
    NSString *phoneNumber = self.PhoneView.PhoneTF.text;
    
    [self startAPIRequestWithSelector:kAPISelectorSendVerifyCode  parameters:@{@"code_type":@"phone", @"phonenumber":  phoneNumber, @"target": phoneNumber, @"mobile_code": AreaNumber}   expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        self.verifyCodeColdDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runVerifyCodeColdDownTimer2) userInfo:nil repeats:YES];
        self.verifyCodeColdDownCount= 60;
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        self.PhoneView.SendCodeBtn.enabled = YES;

    }];
    
}

//@"验证码倒计时"
- (void)runVerifyCodeColdDownTimer2 {
    
    self.verifyCodeColdDownCount--;
    if (self.verifyCodeColdDownCount > 0) {
        [self.PhoneView.SendCodeBtn setTitle:[NSString stringWithFormat:@"%@%d%@",GDLocalizedString(@"LoginVC-0013"), self.verifyCodeColdDownCount,GDLocalizedString(@"LoginVC-0014")] forState:UIControlStateNormal];
    } else {
        
        self.PhoneView.SendCodeBtn.enabled = YES;
        [self.PhoneView.SendCodeBtn setTitle:GDLocalizedString(@"LoginVC-008")   forState:UIControlStateNormal];
        [self.verifyCodeColdDownTimer invalidate];
        _verifyCodeColdDownTimer = nil;
    }
}

-(BOOL)checkPhoneTextField
{
    //"中国";
    if ([self.PhoneView.countryCode.text containsString:@"86"] && self.PhoneView.PhoneTF.text.length != 11) {
        
         AlerMessage(GDLocalizedString(@"LoginVC-PhoneNumberError"));
        
        return NO;
    }else if ([self.PhoneView.countryCode.text containsString:@"44"] && self.PhoneView.PhoneTF.text.length != 10) {
        //"英国";
        AlerMessage(GDLocalizedString(@"LoginVC-EnglandNumberError"));
         return NO;
        
    }else{
        
        return YES;
    }
}



//手机号码编辑框出现隐藏
-(void)coverShow:(BOOL)show
{
    if (show) {
        self.coverView.hidden = NO;
    }else{
        [self.view endEditing:YES];
     }
    
    CGFloat coverAlpha = show ? 0.5 : 0;
    CGFloat phoneViewAlpha = show ? 1 : 0;
    CGRect  NewFrame =self.PhoneView.frame;
    NewFrame.origin.y = show ? 100 + (XScreenWidth - 320)* 0.6 : XScreenHeight;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.cover.alpha = coverAlpha;
        self.PhoneView.alpha =phoneViewAlpha;
        self.PhoneView.frame = NewFrame;
        
    } completion:^(BOOL finished) {
        
        self.PhoneView.PhoneTF.text = @"";
        self.PhoneView.VerifyTF.text = @"";
        
        if (!show) {
            
            self.coverView.hidden = YES;
         }
        
    }];
    
}

//退出登录
-(void)backAndLogout{
    
    if(LOGIN){
        
        [[AppDelegate sharedDelegate] logout];
        
        [MobClick profileSignOff];/*友盟第三方统计功能统计退出*/
        
        [APService setAlias:@"" callbackSelector:nil object:nil];  //设置Jpush用户所用别名为空
        
        [self startAPIRequestWithSelector:kAPISelectorLogout parameters:nil showHUD:YES success:^(NSInteger statusCode, id response) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
    }
    
        
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

KDUtilRemoveNotificationCenterObserverDealloc



@end


