//
//  LoginOrRegisterViewController.m
//  
//
//  Created by Blankwonder on 6/13/15.
//
//

#import "LoginAndRegisterViewController.h"

@interface LoginAndRegisterViewController () {
    UIView *_contentView;
    NSTimer *_verifyCodeColdDownTimer;
    int _verifyCodeColdDownCount;
}

@property (weak, nonatomic) IBOutlet KDEasyTouchButton *loginPageBtn;

@property (weak, nonatomic) IBOutlet KDEasyTouchButton *ForgetPasswdTF;

@end



@implementation LoginAndRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _phoneTextField.placeholder = GDLocalizedString(@"LoginVC-006");
    _verifyCodeTextField.placeholder = GDLocalizedString(@"LoginVC-007");
    _passwordTextField.placeholder = GDLocalizedString(@"LoginVC-005");
    _passwordConfirmTextField.placeholder = GDLocalizedString(@"LoginVC-009");
    _loginPhoneTextField.placeholder = GDLocalizedString(@"LoginVC-004");
    _loginPasswordTextField .placeholder = GDLocalizedString(@"LoginVC-0011");
    [self.loginPageBtn setTitle:GDLocalizedString(@"LoginVC-001") forState:UIControlStateNormal];
    [self.ForgetPasswdTF setTitle:GDLocalizedString(@"LoginVC-003") forState:UIControlStateNormal];
    [_loginButton setTitle:GDLocalizedString(@"LoginVC-001") forState:UIControlStateNormal];
    [_registerButton  setTitle:GDLocalizedString(@"LoginVC-002") forState:UIControlStateNormal];
    [_registerConfirmButton  setTitle:GDLocalizedString(@"LoginVC-002") forState:UIControlStateNormal];
    [_resetPasswordButton  setTitle:GDLocalizedString(@"LoginVC-0012") forState:UIControlStateNormal];
    
    
    
    _loginButton.layer.cornerRadius = 2;
    _loginButton.adjustAllRectWhenHighlighted = YES;
    _loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _loginButton.layer.borderWidth = 2;

    _blurView.dynamic = NO;
    [_blurView setTintColor:nil];
    [_blurView setIterations:3];
    [_blurView setBlurRadius:10];
    
    [_sendVerifyCodeButton setTitle:GDLocalizedString(@"LoginVC-008") forState:UIControlStateNormal];

    _sendVerifyCodeButton.layer.cornerRadius = 2;
    _sendVerifyCodeButton.layer.borderWidth = 2;
    _sendVerifyCodeButton.layer.borderColor = _sendVerifyCodeButton.currentTitleColor.CGColor;
    
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

- (IBAction)resetRegisterFields {
    _phoneTextField.text = @"";
    _verifyCodeTextField.text = @"";
    _passwordTextField.text = @"";
    _passwordConfirmTextField.text = @"";
}



- (BOOL)verifyRegisterFields {
    if (_phoneTextField.text.length != 11) {
        //@"请输入 11 位的手机号"   @"请输入验证码"  @"请输入密码"   //   @"两次输入的密码不一致"
        [KDAlertView showMessage: GDLocalizedString(@"LoginVC-006") cancelButtonTitle: GDLocalizedString(@"Evaluate-0016")];//@"好的"];
        return NO;
    }
    
    if (_verifyCodeTextField.text.length == 0) {
        [KDAlertView showMessage: GDLocalizedString(@"LoginVC-007")  cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];//@"好的"];
        return NO;
    }
    
    if (_passwordTextField.text.length == 0) {
        [KDAlertView showMessage: GDLocalizedString(@"LoginVC-0011") cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];//@"好的"];
        return NO;
    }
 
    if (![_passwordTextField.text isEqualToString:_passwordConfirmTextField.text]) {
        [KDAlertView showMessage:GDLocalizedString(@"ChPasswd-004")   cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];//@"好的"];
        return NO;
    }
    
    return YES;
}

- (IBAction)login {
    [self showContentView:_loginView];
}

- (IBAction)register {
    _resetPasswordButton.hidden = true;
    _registerConfirmButton.hidden = false;
    _registerLabel.hidden = false;
    [self resetRegisterFields];
    [self showContentView:_registerView];
}

-(IBAction)forgotPassword {
    _resetPasswordButton.hidden = false;
    _registerConfirmButton.hidden = true;
    _registerLabel.hidden = true;
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
        _contentView.center = CGPointMake(self.view.frame.size.width / 2.0f, (self.view.frame.size.height - keyboardEndFrame.size.height) / 2.0f);
    } else {
        _contentView.center = CGPointMake(self.view.frame.size.width / 2.0f, self.view.frame.size.height / 2.0f + 100.0);
    }
    
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
}


  - (IBAction)sendVerifyCode {
    if (_phoneTextField.text.length != 11) {
        // @"请输入 11 位的手机号"
        [KDAlertView showMessage: GDLocalizedString(@"LoginVC-006")  cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];//@"好的"];
        return;
    }
    [self startAPIRequestWithSelector:kAPISelectorSendVerifyCode parameters:@{@"code_type": _registerConfirmButton.hidden ? @"reset" : @"register", @"phonenumber": _phoneTextField.text, @"target": _phoneTextField.text} success:^(NSInteger statusCode, NSDictionary *response) {
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

- (IBAction)registerConfirm {
    if (![self verifyRegisterFields]) {
        return;
    }
    
    [self
     startAPIRequestWithSelector:kAPISelectorRegister
     parameters:@{@"username": _phoneTextField.text, @"password": _passwordTextField.text, @"vcode": @{@"code": _verifyCodeTextField.text}}
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



//@"请输入密码"   @"请输入手机号或邮箱"
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
     parameters:@{@"username": _loginPhoneTextField.text, @"password": _loginPasswordTextField.text}
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

-(IBAction)resetPasswordConfirm {
    if (![self verifyRegisterFields]) {
        return;
    }
    
    [self
     startAPIRequestWithSelector:kAPISelectorResetPassword
     parameters:@{@"target": _phoneTextField.text, @"new_password": _passwordTextField.text, @"vcode": _verifyCodeTextField.text}
     success:^(NSInteger statusCode, NSDictionary *response) {
         KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
         
         [hud applySuccessStyle];
         [hud hideAnimated:YES afterDelay:2];
         [hud setHiddenBlock:^(KDProgressHUD *hud) {
             [self login];
         }];
     }];
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

KDUtilRemoveNotificationCenterObserverDealloc

@end
