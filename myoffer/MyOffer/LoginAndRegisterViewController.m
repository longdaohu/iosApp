//
//  LoginOrRegisterViewController.m
//  
//
//  Created by Blankwonder on 6/13/15.
//
//
#import "AgreementViewController.h"
#import "LoginAndRegisterViewController.h"
#import "LoginSelectionViewController.h"
#import "UMSocial.h"

@interface LoginAndRegisterViewController () {
    UIView *_contentView;
    NSTimer *_verifyCodeColdDownTimer;
    int _verifyCodeColdDownCount;
}
@property (weak, nonatomic) IBOutlet UIImageView *IconImageView;
@property (weak, nonatomic) IBOutlet KDEasyTouchButton *loginPageBtn;
@property (weak, nonatomic) IBOutlet KDEasyTouchButton *ForgetPasswdTF;
@property (weak, nonatomic) IBOutlet UILabel *OptionLabel;
@property (weak, nonatomic) IBOutlet UIView *SanfanView;
 @property(nonatomic,strong)NSArray *phoneAreas;
@property (weak, nonatomic) IBOutlet UIButton *phoneSelectBtn;
@property (weak, nonatomic) IBOutlet UIButton *SelectionBtn;
@property(nonatomic,copy)NSString *AreaCode;
@end

 @implementation LoginAndRegisterViewController

- (IBAction)showSelectButton:(UIButton *)sender {
    
    NSString *lang = sender.titleLabel.text;
    
    if ([lang containsString:GDLocalizedString(@"LoginVC-chinese")])// @"中国"
     {
        [self.SelectionBtn setTitle:GDLocalizedString(@"LoginVC-english") forState:UIControlStateNormal];//@"英国+44"
     }
    else
    {
        [self.SelectionBtn setTitle:GDLocalizedString(@"LoginVC-china") forState:UIControlStateNormal];//@"中国+86"
        
    }
    self.SelectionBtn.hidden = NO;

}

- (IBAction)ChangeArea:(UIButton *)sender {
    
     [self.phoneSelectBtn setTitle:sender.titleLabel.text forState:UIControlStateNormal];
    
    if ([sender.titleLabel.text containsString:GDLocalizedString(@"LoginVC-chinese")])// @"中国"
    {
        _phoneTextField.placeholder = GDLocalizedString(@"LoginVC-006") ;//@"请输入手机号码";
    }
    else
    {
        _phoneTextField.placeholder = GDLocalizedString(@"LoginVC-phoneEG");//@"请输入手机号码:7xx";
    }
    
    self.SelectionBtn.hidden = YES;
}
//点击协议按钮
- (IBAction)ShowProtocalNoti:(UIButton *)sender {
     AgreementViewController *pvc =[[AgreementViewController  alloc] initWithNibName:@"AgreementViewController" bundle:nil];
    UINavigationController *nav =[[UINavigationController alloc] initWithRootViewController:pvc];
    [self presentViewController:nav animated:YES completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.IconImageView  setImage:[UIImage imageNamed:GDLocalizedString(@"LoginVC-icon")]];
    [self.protocalButton  setTitle:GDLocalizedString(@"LoginVC-0010") forState:UIControlStateNormal];
    [self.phoneSelectBtn  setTitle:GDLocalizedString(@"LoginVC-china") forState:UIControlStateNormal];
    _phoneTextField.placeholder = GDLocalizedString(@"LoginVC-006");// "请输入11位手机号码";
    _verifyCodeTextField.placeholder = GDLocalizedString(@"LoginVC-007");//"请输入验证码";
    _passwordTextField.placeholder = GDLocalizedString(@"LoginVC-005");//"请输入新密码";
    _passwordConfirmTextField.placeholder = GDLocalizedString(@"LoginVC-009");//"请再次输入密码";
    _loginPhoneTextField.placeholder = GDLocalizedString(@"LoginVC-004");//"请输入手机号或邮箱";
    _loginPasswordTextField .placeholder = GDLocalizedString(@"LoginVC-0011");//"请输入密码";
    [self.loginPageBtn setTitle:GDLocalizedString(@"LoginVC-001") forState:UIControlStateNormal];//"登录";
    [self.ForgetPasswdTF setTitle:GDLocalizedString(@"LoginVC-003") forState:UIControlStateNormal];//"忘记密码";
    [_loginButton setTitle:GDLocalizedString(@"LoginVC-001") forState:UIControlStateNormal];//"登录";
    [_registerButton  setTitle:GDLocalizedString(@"LoginVC-002") forState:UIControlStateNormal];//"注册";
    [_registerConfirmButton  setTitle:GDLocalizedString(@"LoginVC-002") forState:UIControlStateNormal];//"注册";
    [_resetPasswordButton  setTitle:GDLocalizedString(@"LoginVC-0012") forState:UIControlStateNormal];//"重置密码";
    self.OptionLabel.text = GDLocalizedString(@"LoginVC-moreOption");//"第三方登录";
    self.OptionLabel.adjustsFontSizeToFitWidth = YES;
    
     _loginButton.layer.cornerRadius = 2;
    _loginButton.adjustAllRectWhenHighlighted = YES;
    _loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _loginButton.layer.borderWidth = 2;
 
    _blurView.dynamic = NO;
    [_blurView setTintColor:nil];
    [_blurView setIterations:3];
    [_blurView setBlurRadius:10];
    
    [_sendVerifyCodeButton setTitle:GDLocalizedString(@"LoginVC-008") forState:UIControlStateNormal];//"获取验证码";
    _sendVerifyCodeButton.layer.cornerRadius = 2;
    _sendVerifyCodeButton.layer.borderWidth = 2;
    _sendVerifyCodeButton.layer.borderColor = _sendVerifyCodeButton.currentTitleColor.CGColor;
    
    self.phoneSelectBtn.layer.borderWidth = 2;
    self.phoneSelectBtn.layer.borderColor = _sendVerifyCodeButton.currentTitleColor.CGColor;
    
    _blurView.alpha = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.tapToEndEditing = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_blurView updateAsynchronously:YES completion:^{}];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (IBAction)resetRegisterFields {
    _phoneTextField.text = @"";
    _verifyCodeTextField.text = @"";
    _passwordTextField.text = @"";
    _passwordConfirmTextField.text = @"";
}


//注册相关字段验证
- (BOOL)verifyRegisterFields {
    
    if ([self.phoneSelectBtn.titleLabel.text containsString:GDLocalizedString(@"LoginVC-chinese")] && _phoneTextField.text.length != 11) {
        
        [KDAlertView showMessage: GDLocalizedString(@"LoginVC-PhoneNumberError") cancelButtonTitle: GDLocalizedString(@"Evaluate-0016")];
        return NO;
    }
    
    if ([self.phoneSelectBtn.titleLabel.text containsString:GDLocalizedString(@"LoginVC-england")] && _phoneTextField.text.length != 10) {
        //@"请输入 11 位的手机号"
        [KDAlertView showMessage: GDLocalizedString(@"LoginVC-EnglandNumberError") cancelButtonTitle: GDLocalizedString(@"Evaluate-0016")];//@"好的"];
        return NO;
    }
    
     if (_verifyCodeTextField.text.length == 0) {
        [KDAlertView showMessage: GDLocalizedString(@"LoginVC-007")  cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];//@"好的"];
        return NO;
    }
    
    if(_passwordTextField.text.length < 6 )
    {   //@"密码长度不小于6个字符"
        [KDAlertView showMessage:GDLocalizedString(@"Person-passwd") cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];//@"好的"];
        return NO;
    }
    
    if (![_passwordTextField.text isEqualToString:_passwordConfirmTextField.text]) {
        [KDAlertView showMessage:GDLocalizedString(@"ChPasswd-004")   cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];//@"好的"];
        return NO;
    }
    
    return YES;
}

- (IBAction)login {
    
    [UIView animateWithDuration:1 animations:^{
        self.SanfanView.alpha = 0;
    }];
     [self showContentView:_loginView];
}

- (IBAction)register {
    [UIView animateWithDuration:1 animations:^{
        self.SanfanView.alpha = 0;
    }];
    _resetPasswordButton.hidden = true;
    _registerConfirmButton.hidden = false;
  //  _registerLabel.hidden = false;
    self.protocalButton.hidden = false;

    [self resetRegisterFields];
    [self showContentView:_registerView];
}

-(IBAction)forgotPassword {
    _resetPasswordButton.hidden = false;
    _registerConfirmButton.hidden = true;
 //   _registerLabel.hidden = true;
    
    self.protocalButton.hidden = true;
    [self resetRegisterFields];
    [self showContentView:_registerView];
}

- (void)showContentView:(UIView *)view {
    if(_registerConfirmButton.hidden) {
        // reset password view
        [self.view endEditing:NO];
        [UIView animateWithDuration:1 animations:^{
             _contentView.alpha = 0;
            _contentView.center = CGPointMake(self.view.frame.size.width / 2.0f, self.view.frame.size.height);
        }];
    }
     _contentView = view;
    view.center = CGPointMake(self.view.frame.size.width / 2.0f, self.view.frame.size.height);
    [self.view addSubview:view];
    view.alpha = 0;
    [self.view layoutIfNeeded];

    [UIView animateWithDuration:1 animations:^{
        _blurView.alpha = 1;
        _logoCenterY.constant = 150;
        [self.view layoutIfNeeded];
        
        view.alpha = 1;
        view.center = CGPointMake(self.view.frame.size.width / 2.0f, self.view.frame.size.height / 2.0f + 100.0);
        
        _registerButton.alpha = 0;
        _loginButton.alpha = 0;
        
        _backButton.alpha = 1;
    }];
}

- (IBAction)back {
    [self.view endEditing:NO];
    self.SanfanView.alpha = 1;

    [UIView animateWithDuration:1 animations:^{
        _blurView.alpha = 0;
        _logoCenterY.constant = 50;
        [self.view layoutIfNeeded];
        
        _contentView.alpha = 0;
        _contentView.center = CGPointMake(self.view.frame.size.width / 2.0f, self.view.frame.size.height);
        
        _registerButton.alpha = 1;
        _loginButton.alpha = 1;
        
        _backButton.alpha = 0;
    }];
}


- (void)keyboardWillShow:(NSNotification *)aNotification {
    [self moveTextViewForKeyboard:aNotification up:YES];
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    [self moveTextViewForKeyboard:aNotification up:NO];
}

- (void) moveTextViewForKeyboard:(NSNotification*)aNotification up: (BOOL) up {
    NSDictionary* userInfo = [aNotification userInfo];
    
    // Get animation info from userInfo
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
         _contentView.center = CGPointMake(self.view.frame.size.width / 2.0f, (self.view.frame.size.height - keyboardEndFrame.size.height) / 2.0f +45.0);
        
        
    } else {
        _contentView.center = CGPointMake(self.view.frame.size.width / 2.0f, self.view.frame.size.height / 2.0f + 100.0);
    }
    
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
}

//发送验证码
  - (IBAction)sendVerifyCode {
  
      if ([self.phoneSelectBtn.titleLabel.text containsString:GDLocalizedString(@"LoginVC-chinese")] && _phoneTextField.text.length != 11) {
          
          [KDAlertView showMessage: GDLocalizedString(@"LoginVC-PhoneNumberError") cancelButtonTitle: GDLocalizedString(@"Evaluate-0016")];
           return ;
      }
     if ([self.phoneSelectBtn.titleLabel.text containsString:GDLocalizedString(@"LoginVC-england")] && _phoneTextField.text.length != 10) {
          //@"请输入 10 位的手机号"
           [KDAlertView showMessage: GDLocalizedString(@"LoginVC-EnglandNumberError") cancelButtonTitle: GDLocalizedString(@"Evaluate-0016")];//@"好的"];

         return ;
      }
      NSString *phoneAreaString = self.phoneSelectBtn.titleLabel.text;
      self.AreaCode = @"86";
      if([phoneAreaString containsString:GDLocalizedString(@"LoginVC-england")])//@"英国"])
      {
          self.AreaCode = @"44";
      }
      
      
      [self startAPIRequestWithSelector:kAPISelectorSendVerifyCode parameters:@{@"code_type": _registerConfirmButton.hidden ? @"reset" : @"register", @"phonenumber":  _phoneTextField.text, @"target":  _phoneTextField.text, @"mobile_code": self.AreaCode} success:^(NSInteger statusCode, NSDictionary *response) {
       
         _verifyCodeColdDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(verifyCodeColdDownTimer) userInfo:nil repeats:YES];
        _verifyCodeColdDownCount = 60;
        [self verifyCodeColdDownTimer];
    }];
      
      
}

//@"获取验证码"   
- (void)verifyCodeColdDownTimer {
    _verifyCodeColdDownCount--;
    if (_verifyCodeColdDownCount > 0) {
        _sendVerifyCodeButton.enabled = NO;
        [_sendVerifyCodeButton setTitle:[NSString stringWithFormat:@"%@%d%@",GDLocalizedString(@"LoginVC-0013"), _verifyCodeColdDownCount,GDLocalizedString(@"LoginVC-0014")] forState:UIControlStateNormal];
    } else {
        _sendVerifyCodeButton.enabled = YES;
        [_sendVerifyCodeButton setTitle:GDLocalizedString(@"LoginVC-008")   forState:UIControlStateNormal];
        [_verifyCodeColdDownTimer invalidate];
        _verifyCodeColdDownTimer = nil;
    }
}
//提交注册
- (IBAction)registerConfirm {
   
    if (![self verifyRegisterFields]) {
        return;
    }
    
    NSString *phoneAreaString = self.phoneSelectBtn.titleLabel.text;
    self.AreaCode = @"86";
    if([phoneAreaString containsString:GDLocalizedString(@"LoginVC-england")])//@"英国"])
    {
        self.AreaCode = @"44";
    }
    
    [self
     startAPIRequestWithSelector:kAPISelectorRegister
     parameters:@{@"mobile_code":self.AreaCode,@"username":_phoneTextField.text, @"password": _passwordTextField.text, @"vcode": @{@"code": _verifyCodeTextField.text}}
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


 //提交登录  //@"请输入密码"   @"请输入手机号或邮箱"
- (IBAction)loginConfirm {
   
    if (_loginPasswordTextField.text.length == 0) {
        [KDAlertView showMessage:GDLocalizedString(@"LoginVC-005") cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];//@"好的"];
        return;
    }
    
    if (_loginPhoneTextField.text.length == 0) {
        [KDAlertView showMessage:GDLocalizedString(@"LoginVC-004")  cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];//@"好的"];
        return;
    }
    

    
    [self
     startAPIRequestWithSelector:kAPISelectorLogin
     parameters:@{@"username":_loginPhoneTextField.text , @"password": _loginPasswordTextField.text}
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
/*2015-10-23 18:55:44.678 myOffer[8540:776746] Can't find keyplane that supports type 4 for keyboard iPhone-Portrait-NumberPad; using 1730230351_Portrait_iPhone-Simple-Pad_Default
 185629  [APIClient] Request started: POST http://www.myoffer.cn/api/account/resetpassword
 185629  [APIClient] Request body: {"mobile_code":"44","new_password":"123123","target":"7751412197","vcode":"815963"}
 185629 *[APIClient] Response body: {"error":"User is not exist"}
 185629 *[APIClient] Request completed: [400], http://www.myoffer.cn/api/account/resetpassword
 */

//重置密码
-(IBAction)resetPasswordConfirm {
   
    if (![self verifyRegisterFields]) {
        return;
    }
    
    [self
     startAPIRequestWithSelector:kAPISelectorResetPassword
     parameters:@{@"target":_phoneTextField.text, @"new_password": _passwordTextField.text, @"vcode": _verifyCodeTextField.text}
     success:^(NSInteger statusCode, NSDictionary *response) {
         KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
         [hud applySuccessStyle];
         [hud hideAnimated:YES afterDelay:2];
         [hud setHiddenBlock:^(KDProgressHUD *hud) {
             [self login];
         }];
     }];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.SelectionBtn.hidden = YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _loginPhoneTextField) {
        [_loginPasswordTextField becomeFirstResponder];
    } else if (textField == _loginPasswordTextField) {
        [self loginConfirm];
    } else if (textField == _phoneTextField) {
        [self sendVerifyCode];
    } else if (textField == _verifyCodeTextField) {
        [_passwordTextField becomeFirstResponder];
    } else if (textField == _passwordTextField) {
        [_passwordConfirmTextField becomeFirstResponder];
    } else if (textField == _passwordConfirmTextField) {
        [self registerConfirm];
    }
    
    return YES;
}

- (IBAction)weixinButtonPress:(KDEasyTouchButton *)sender {
    
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
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                }
      }];
    
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.SelectionBtn.hidden = YES;
}

KDUtilRemoveNotificationCenterObserverDealloc

@end
