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
#import "AgreementViewController.h"
#import "LoginSelectionViewController.h"
#import "UMSocial.h"

@interface NewLoginRegisterViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet FXBlurView *LoginBlurView;
@property (weak, nonatomic) IBOutlet KDEasyTouchButton *backButton;
@property (weak, nonatomic) IBOutlet KDEasyTouchButton *DismissButton;
@property(nonatomic,strong)NSTimer *verifyCodeColdDownTimer;
@property(nonatomic,assign)int verifyCodeColdDownCount;
@property (weak, nonatomic) IBOutlet UITextField *LoginPhoneNumberTextF;
@property (weak, nonatomic) IBOutlet UITextField *LoginPasswdTextF;
@property (weak, nonatomic) IBOutlet UITextField *RegisterAreaTextF;
@property (weak, nonatomic) IBOutlet UITextField *RegisterPhoneTextF;
@property (weak, nonatomic) IBOutlet UITextField *RegisterVerTextF;
@property (weak, nonatomic) IBOutlet UITextField *RegisterRepwdTextF;
@property (weak, nonatomic) IBOutlet UITextField *RegisterPasswdTextF;
@property (weak, nonatomic) IBOutlet UIButton *VertifButton;
@property(nonatomic,strong)UIPickerView *AreaPicker;
@property(nonatomic,strong)NSArray *Areas;
@property (weak, nonatomic) IBOutlet UIButton *ForgetButton;
@property (weak, nonatomic) IBOutlet UILabel *ORlabel;
@property (weak, nonatomic) IBOutlet UIButton *commitLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *LoginSelectButton;
@property (weak, nonatomic) IBOutlet UIButton *SignUpselectButton;
@property (weak, nonatomic) IBOutlet UIButton *RegisterCommitButton;
@property (weak, nonatomic) IBOutlet KDEasyTouchButton *LoginAButton;
@property (weak, nonatomic) IBOutlet KDEasyTouchButton *RegisterAButton;
@property (weak, nonatomic) IBOutlet UIButton *ServiceButton;
@property (weak, nonatomic) IBOutlet UIView *ButtonView;
@property (weak, nonatomic) IBOutlet UIImageView *welcomeMV;
@property(nonatomic,strong)UIImageView *FocusMV;
@property (weak, nonatomic) IBOutlet UIImageView *logoMV;

@end

@implementation NewLoginRegisterViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
//用于添加控件、设置控件相关属性
-(void)makeLoginRegiterView
{
    self.xLoginRegistView.frame  = CGRectMake(0,APPSIZE.height, APPSIZE.width, APPSIZE.height*2/3);
    [self.view addSubview:self.xLoginRegistView];
     self.xLoginView.frame =CGRectMake(0, 40, APPSIZE.width, APPSIZE.height*2/3 - 40);
    [self.xLoginRegistView addSubview:self.xLoginView];
     self.RegisterAreaTextF.inputView = self.AreaPicker;
    
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
    self.commitLoginButton.backgroundColor = MAINCOLOR;
    self.RegisterCommitButton.backgroundColor = MAINCOLOR;
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

#pragma mark
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

-(UIPickerView *)AreaPicker
{
    if (!_AreaPicker) {
        _AreaPicker =[[UIPickerView alloc] init];
        _AreaPicker.delegate =self;
        _AreaPicker.dataSource =self;
        self.Areas = @[GDLocalizedString(@"LoginVC-china"),GDLocalizedString(@"LoginVC-english")];//@[@"中国(+86)",@"英国(+44)"];
    }
    return _AreaPicker;
}

//设置控件中英文
-(void)ChangLanguageView

{   self.logoMV.image = [UIImage imageNamed:GDLocalizedString(@"LoginVC-icon")];
    self.LoginPhoneNumberTextF.placeholder = GDLocalizedString(@"LoginVC-004");//请输入手机号码或邮箱;
    self.LoginPasswdTextF.placeholder = GDLocalizedString(@"LoginVC-0011");//"请输入密码";
    [self.ForgetButton setTitle:GDLocalizedString(@ "LoginVC-003")  forState:UIControlStateNormal];
    [self.commitLoginButton setTitle:GDLocalizedString(@"LoginVC-001") forState:UIControlStateNormal];
    self.ORlabel.text =GDLocalizedString(@"LoginVC-OR");
    [self.LoginSelectButton setTitle:GDLocalizedString(@"LoginVC-001") forState:UIControlStateNormal];
    [self.SignUpselectButton setTitle:GDLocalizedString(@"LoginVC-002") forState:UIControlStateNormal];
    
    self.RegisterAreaTextF.text = GDLocalizedString(@"LoginVC-china");
    NSString *lang =[InternationalControl userLanguage];
    if ([lang containsString:GDLocalizedString(@"ch_Language")]) {
        self.RegisterAreaTextF.text = GDLocalizedString(@"LoginVC-english");
    }
     self.RegisterPhoneTextF.placeholder = GDLocalizedString(@"LoginVC-006");// "请输入11位手机号码";
    self.RegisterVerTextF.placeholder = GDLocalizedString(@"LoginVC-007");//"请输入验证码";
    self.RegisterPasswdTextF.placeholder = GDLocalizedString(@"LoginVC-005");//"请输入新密码";
    self.RegisterRepwdTextF.placeholder = GDLocalizedString(@"LoginVC-009");//"请再次输入密码";
    [self.RegisterCommitButton setTitle:GDLocalizedString(@"LoginVC-002") forState:UIControlStateNormal];
    [self.VertifButton setTitle:GDLocalizedString(@"LoginVC-008") forState:UIControlStateNormal];
//    [self.LogoImageView setImage:[UIImage imageNamed:GDLocalizedString(@"LoginVC-icon")]];
    [self.RegisterAButton setTitle:GDLocalizedString(@"LoginVC-001") forState:UIControlStateNormal];
    [self.LoginAButton setTitle:GDLocalizedString(@"LoginVC-002") forState:UIControlStateNormal];
    [self.welcomeMV setImage:[UIImage imageNamed:GDLocalizedString(@"LoginVC-welImage")]];
     NSString *serviceString = GDLocalizedString(@ "LoginVC-0010");
     NSRange NotiRangne =[serviceString rangeOfString:GDLocalizedString(@ "LoginVC-keyWord")];
     NSMutableAttributedString *AtributeStr = [[NSMutableAttributedString alloc] initWithString:serviceString ];
     [AtributeStr addAttribute:NSForegroundColorAttributeName value:MAINCOLOR range: NotiRangne];
     [AtributeStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NotiRangne];
     [self.ServiceButton setAttributedTitle: AtributeStr forState:UIControlStateNormal];
 }
//QQ登录
- (IBAction)QQLoginButtonPressed:(id)sender {
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQzone];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
         if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQzone];
             //            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
             NSMutableDictionary *weixinInfo =[NSMutableDictionary dictionary];
            
            [weixinInfo setValue:snsAccount.usid forKey:@"user_id"];
            
            [weixinInfo setValue:@"qq" forKey:@"provider"];
            
            [weixinInfo setValue:snsAccount.accessToken forKey:@"token"];
            
            [self  loginWithParameters:weixinInfo];
            
        }});
    
}

//微博登录
- (IBAction)weiboLoginButtonPressed:(id)sender {
   
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
            
            NSMutableDictionary *weixinInfo =[NSMutableDictionary dictionary];
            [weixinInfo setValue:snsAccount.usid forKey:@"user_id"];
            [weixinInfo setValue:@"weibo" forKey:@"provider"];
            [weixinInfo setValue:snsAccount.accessToken forKey:@"token"];
            [self  loginWithParameters:weixinInfo];
            
        }});
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeLoginRegiterView];
    [self ChangLanguageView];
     [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}


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
    
    if (up) {
        self.xLoginRegistView.center = CGPointMake(self.view.frame.size.width / 2.0f, (self.view.frame.size.height - keyboardEndFrame.size.height) / 2.0f +40.0);
        
     } else {
         
       self.xLoginRegistView.center = CGPointMake(self.view.frame.size.width / 2.0f, APPSIZE.height*2/3);
    }
    
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
}

- (IBAction)changeLoginView:(UIButton *)sender {
     self.xRegisterView.hidden = YES;
     self.xLoginView.hidden = NO;
    
    [UIView animateWithDuration:0.01 animations:^{
        self.FocusMV.center = CGPointMake(sender.center.x, 38);

    }];

 }
- (IBAction)changeRegisterView:(UIButton *)sender {
    
    self.xRegisterView.hidden = NO;
    self.xLoginView.hidden = YES;
    [UIView animateWithDuration:0.01 animations:^{
        self.FocusMV.center = CGPointMake(sender.center.x,38);
    }];
}

//跳转登录页面按钮
- (IBAction)LoginButtonPressed:(UIButton *)sender {
        CGRect NewRect = self.xLoginRegistView.frame;
        NewRect.origin.y = APPSIZE.height / 3;
        NewRect.size.width = APPSIZE.width;
        NewRect.size.height = APPSIZE.height - APPSIZE.height/3;
            [UIView animateWithDuration:0.5 animations:^{
             self.LoginBlurView.alpha = 1;
              self.backButton.alpha = 1;
              self.xLoginRegistView.frame = NewRect;
         }];
     self.xRegisterView.hidden = YES;
    
    self.FocusMV.center = CGPointMake(APPSIZE.width*0.25,38);

}

//跳转注册页面按钮
- (IBAction)RegisterButtonPress:(UIButton *)sender {

    CGRect NewRect = self.xLoginRegistView.frame;
    NewRect.origin.y = APPSIZE.height / 3;
    NewRect.size.width = APPSIZE.width;
    NewRect.size.height = APPSIZE.height - APPSIZE.height/3;
    [UIView animateWithDuration:0.5 animations:^{
        self.LoginBlurView.alpha = 1;
        self.backButton.alpha = 1;
        self.xLoginRegistView.frame = NewRect;
    }];
    self.xLoginView.hidden = YES;
    self.FocusMV.center = CGPointMake(APPSIZE.width*0.75,38);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view  endEditing:YES];
}
// 提交登录
- (IBAction)LoginButtonCommit:(id)sender {
    
    if (self.LoginPhoneNumberTextF.text.length == 0) {
        [KDAlertView showMessage:GDLocalizedString(@"LoginVC-004")  cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];//@"好的"];
        return;
    }
    if (self.LoginPasswdTextF.text.length == 0) {
        [KDAlertView showMessage:GDLocalizedString(@"LoginVC-0011") cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];//@"好的"];
        return;
    }
    [self
     startAPIRequestWithSelector:kAPISelectorLogin
     parameters:@{@"username":self.LoginPhoneNumberTextF.text , @"password": self.LoginPasswdTextF.text}
     success:^(NSInteger statusCode, NSDictionary *response) {
         KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
         [[AppDelegate sharedDelegate] loginWithAccessToken:response[@"access_token"]];
         [MobClick profileSignInWithPUID:response[@"access_token"]];/*友盟统计记录用户账号*/
         [hud applySuccessStyle];
         [hud hideAnimated:YES afterDelay:2];
         [hud setHiddenBlock:^(KDProgressHUD *hud) {
             
               [self whenUserLoginDismiss];
             
         }];
     }];

}
// 点击忘记密码
- (IBAction)ForgetPasswdButtonPressed:(id)sender {
    
    NewForgetPasswdViewController *Forget =[[NewForgetPasswdViewController alloc] initWithNibName:@"NewForgetPasswdViewController" bundle:nil];
    [self.navigationController pushViewController:Forget animated:YES];

}
// 点击微信登录
- (IBAction)weixinButtonPressed:(id)sender {
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            NSMutableDictionary *weixinInfo =[NSMutableDictionary dictionary];
            [weixinInfo setValue:snsAccount.usid forKey:@"user_id"];
            [weixinInfo setValue:@"wechat" forKey:@"provider"];
            [weixinInfo setValue:snsAccount.accessToken forKey:@"token"];
            [self  loginWithParameters:weixinInfo];
        }
    });

}

//第三方登录传参并登录
-(void)loginWithParameters:(NSMutableDictionary *)weixinInfo
{
    [self  startAPIRequestWithSelector:@"POST api/account/login" parameters:weixinInfo success:^(NSInteger statusCode, NSDictionary *response) {

        if (response[@"new"]) {
            LoginSelectionViewController *selectVC =[[LoginSelectionViewController alloc] initWithNibName:@"LoginSelectionViewController" bundle:[NSBundle mainBundle]];
            selectVC.parameter = weixinInfo;
            [self.navigationController pushViewController:selectVC animated:YES];
        }
        else if([response[@"role"] isEqualToString:@"user"])
        {
            [[AppDelegate sharedDelegate] loginWithAccessToken:response[@"access_token"]];
            
            [MobClick profileSignInWithPUID:response[@"access_token"] provider:[weixinInfo valueForKey:@"provider"]];/*友盟统计记录用户账号*/
            
            [self whenUserLoginDismiss];
         }
    }];
}




//发送验证码
- (IBAction)SendVertificationCode:(id)sender {
   
    
     if (self.RegisterAreaTextF.text.length == 0) {
        [KDAlertView showMessage: self.RegisterAreaTextF.placeholder cancelButtonTitle: GDLocalizedString(@"Evaluate-0016")];
        return ;
    }
    
    if ([self.RegisterAreaTextF.text containsString:GDLocalizedString(@"LoginVC-chinese")] && self.RegisterPhoneTextF.text.length != 11) {
        
        [KDAlertView showMessage: GDLocalizedString(@"LoginVC-PhoneNumberError") cancelButtonTitle: GDLocalizedString(@"Evaluate-0016")];
        
        return ;
    }
    
    if ([self.RegisterAreaTextF.text containsString:GDLocalizedString(@"LoginVC-england")] && self.RegisterPhoneTextF.text.length != 10) {
        //@"请输入 10 位的手机号"
        [KDAlertView showMessage: GDLocalizedString(@"LoginVC-EnglandNumberError") cancelButtonTitle: GDLocalizedString(@"Evaluate-0016")];//@"好的"];
        
        return ;
    }
    
    NSString *AreaNumber = @"86";
    if([ self.RegisterAreaTextF.text containsString:GDLocalizedString(@"LoginVC-england")])//@"英国"])
    {
       AreaNumber = @"44";
    }
    NSString *phoneNumber = self.RegisterPhoneTextF.text;
    
    [self startAPIRequestWithSelector:kAPISelectorSendVerifyCode parameters:@{@"code_type":@"register", @"phonenumber":  phoneNumber, @"target": phoneNumber, @"mobile_code": AreaNumber} success:^(NSInteger statusCode, NSDictionary *response) {
        self.verifyCodeColdDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runVerifyCodeColdDownTimer) userInfo:nil repeats:YES];
        self.verifyCodeColdDownCount= 60;
    }];
    
}
//@"验证码倒计时"
- (void)runVerifyCodeColdDownTimer {

    self.verifyCodeColdDownCount--;
      if (self.verifyCodeColdDownCount > 0) {
          self.VertifButton.enabled = NO;
        [self.VertifButton setTitle:[NSString stringWithFormat:@"%@%d%@",GDLocalizedString(@"LoginVC-0013"), self.verifyCodeColdDownCount,GDLocalizedString(@"LoginVC-0014")] forState:UIControlStateNormal];
    } else {
        self.VertifButton.enabled = YES;
        [self.VertifButton setTitle:GDLocalizedString(@"LoginVC-008")   forState:UIControlStateNormal];
        [self.verifyCodeColdDownTimer invalidate];
        _verifyCodeColdDownTimer = nil;
    }
}
//提交注册信息
- (IBAction)RegisterButtonCommitPressed:(id)sender {
    
    if (![self verifyRegisterFields]) {
        return;
    }
    
     NSString *AreaNumber = @"86";
    if([self.RegisterAreaTextF.text containsString:GDLocalizedString(@"LoginVC-england")])//@"英国"])
    {
        AreaNumber = @"44";
    }
    
    [self
     startAPIRequestWithSelector:kAPISelectorRegister
     parameters:@{@"mobile_code":AreaNumber,@"username":self.RegisterPhoneTextF.text, @"password":self.RegisterPasswdTextF.text, @"vcode": @{@"code":self.RegisterVerTextF.text}}
     success:^(NSInteger statusCode, NSDictionary *response) {
         KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
         
         [[AppDelegate sharedDelegate] loginWithAccessToken:response[@"access_token"]];
         
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
        
        [KDAlertView showMessage: GDLocalizedString(@"LoginVC-PhoneNumberError") cancelButtonTitle: GDLocalizedString(@"Evaluate-0016")];
        return NO;
    }
    
    if ([self.RegisterAreaTextF.text containsString:GDLocalizedString(@"LoginVC-england")] && self.RegisterPhoneTextF.text.length != 10) {
        //@"请输入 11 位的手机号"
        [KDAlertView showMessage: GDLocalizedString(@"LoginVC-EnglandNumberError") cancelButtonTitle: GDLocalizedString(@"Evaluate-0016")];//@"好的"];
        return NO;
    }
     if (self.RegisterVerTextF.text.length == 0) {
        [KDAlertView showMessage: GDLocalizedString(@"LoginVC-007")  cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];//@"好的"];
        return NO;
    }
    
    if(self.RegisterPasswdTextF.text.length < 6 || self.RegisterPasswdTextF.text.length >16)
    {   //@"密码长度不小于6个字符"
        [KDAlertView showMessage:GDLocalizedString(@"Person-passwd") cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];//@"好的"];
        return NO;
    }
    
    if (![self.RegisterPasswdTextF.text isEqualToString:self.RegisterRepwdTextF.text]) {
        [KDAlertView showMessage:GDLocalizedString(@"ChPasswd-004")   cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];//@"好的"];
        return NO;
    }
   
    return YES;
}
//点击进入服务条款页面
- (IBAction)ServiceButtonPressed:(id)sender {
    
    AgreementViewController *Forget =[[AgreementViewController alloc] initWithNibName:@"AgreementViewController" bundle:nil];
    [self.navigationController pushViewController:Forget animated:YES];
}


//返回注册登录第一页
- (IBAction)backButtonPressed:(KDEasyTouchButton *)sender {
    
    CGRect NewRect = self.xLoginRegistView.frame;
    NewRect.origin.y = APPSIZE.height;
     [UIView animateWithDuration:0.5 animations:^{
      
        self.LoginBlurView.alpha = 0;
        self.backButton.alpha = 0;
        self.xLoginRegistView.frame = NewRect;
         
     }];
    
    self.xLoginView.hidden = NO;
    self.xRegisterView.hidden = NO;
    
}
//退出登录页面
- (IBAction)popButtonPressed:(KDEasyTouchButton *)sender {
    [self dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma  Mark   UIPickerViewDataSource, UIPickerViewDelegate
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


-(void)whenUserLoginDismiss
{
    //用于判断用户是否改变
    NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
    NSString *displayname =[ud valueForKey:@"userDisplayName"];
    if (![displayname isEqualToString: self.LoginPhoneNumberTextF.text] ) {
        
        [ud setValue:@"changeYES" forKey:@"userChange"];
        
     }else{
        
        [ud setValue:@"changeNO" forKey:@"userChange"];
         
    }
    [ud  setValue:self.LoginPhoneNumberTextF.text  forKey:@"userDisplayName"];
    
    [ud synchronize];
    
     [self dismiss];
}

KDUtilRemoveNotificationCenterObserverDealloc



@end


