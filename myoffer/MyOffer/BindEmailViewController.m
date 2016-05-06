//
//  BindEmailViewController.m
//  myOffer
//
//  Created by xuewuguojie on 15/10/29.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "BindEmailViewController.h"
#import "ChangePasswordViewController.h"

@interface BindEmailViewController ()<UITextFieldDelegate,UIAlertViewDelegate> {
    NSArray *_cells;
    UITextField *_EmailTextField, *_VertificationTextField,*_PasswordTextField;
}
@property(nonatomic,strong)UIButton *VertificationButton;
@property(nonatomic,strong)NSTimer *verifyCodeColdDownTimer;
@property(nonatomic,assign)int verifyCodeColdDownCount;

 @end

@implementation BindEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self makeUI];
}

-(void)makeUI
{
    
    self.title = GDLocalizedString(@"Bind-EmailTitle");//@"绑定邮箱";

    _tableView.rowHeight = 44;
    
    NSMutableArray *cells = [NSMutableArray array];
    
    {
        UITableViewCell *cell = [self cellDefault];
        _EmailTextField = [self textFieldCreateWithPlacehodler:GDLocalizedString(@"Bind-email")];
        _EmailTextField.returnKeyType = UIReturnKeyNext;
        [cell addSubview:_EmailTextField];
        [cells addObject:cell];
    }
    
    {
        UITableViewCell *cell = [self cellDefault];
        _VertificationTextField = [self textFieldCreateWithPlacehodler:GDLocalizedString(@"LoginVC-007")];
        _VertificationTextField.returnKeyType = UIReturnKeyNext;
        if (!self.Email)
        {
            _VertificationTextField.returnKeyType = UIReturnKeyDone;
        }
        self.VertificationButton =[[UIButton alloc] init];
        [self.VertificationButton setTitle:GDLocalizedString(@"LoginVC-008")forState:UIControlStateNormal];
        [self.VertificationButton addTarget:self action:@selector(SendVertificationCode:) forControlEvents:UIControlEventTouchUpInside];
        [self.VertificationButton setTitleColor:MAINCOLOR forState:UIControlStateNormal];
        [cell addSubview:self.VertificationButton];
        [cell addSubview:_VertificationTextField];
        [cells addObject:cell];
    }
    
    if (self.Email.length){
        
        UITableViewCell *cell = [self cellDefault];
        _PasswordTextField = [self textFieldCreateWithPlacehodler:GDLocalizedString(@"ChPasswd-loginPasswd")];
        _PasswordTextField.frame = CGRectMake(20, 11, _tableView.frame.size.width - 20 * 2.0f, _tableView.rowHeight - 11 * 2.0f);
        _PasswordTextField.returnKeyType = UIReturnKeyDone;
        _PasswordTextField.secureTextEntry = YES;
        [cell addSubview:_PasswordTextField];
        [cells addObject:cell];
    }
    
    
    _cells = cells;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    

}
-(UITableViewCell *)cellDefault
{
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
}

-(UITextField *)textFieldCreateWithPlacehodler:(NSString *)placeholder
{
    UITextField *cellTextField = [[UITextField alloc] init];
    [cellTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    cellTextField.delegate = self;
//    cellTextField.enablesReturnKeyAutomatically = YES;
    cellTextField.placeholder = placeholder;
    return cellTextField;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_EmailTextField becomeFirstResponder];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _cells[indexPath.row];
}


#pragma mark  UITextFieldDelege
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  
    if (textField == _EmailTextField) {
        [_VertificationTextField becomeFirstResponder];
    }else if (textField == _PasswordTextField)
    {
        [self done];
    }else
    {
        if (!self.Email) {
            [self done];
        }
        else{
            [_PasswordTextField becomeFirstResponder];
        }
    }
     return YES;
}


-(BOOL)checkTextField
{
    if(_EmailTextField.text.length == 0)
    {
        [KDAlertView showMessage:_EmailTextField.placeholder cancelButtonTitle:GDLocalizedString(@"NetRequest-OK")];// = "好的";
        
        return NO;
    }
    else if (![self validateEmail:_EmailTextField.text]) {
        
        [KDAlertView showMessage:GDLocalizedString(@"Bind-emailError") cancelButtonTitle:GDLocalizedString(@"NetRequest-OK")];
        
        return NO;
    }
    else
    {
       return YES;
    }
    
}

- (void)done {
    
    if (![self checkTextField]) {
        
        return;
    }
    if (_VertificationTextField.text.length == 0) {
        
        return;
    }
    
     NSMutableDictionary *infoParameters =[NSMutableDictionary dictionary];
    [infoParameters setValue:_EmailTextField.text forKey:@"email"];
    [infoParameters setValue:@{@"code":_VertificationTextField.text} forKey:@"vcode"];
    
    if (self.Email.length > 0) {
        
        [infoParameters setValue:_PasswordTextField.text forKey:@"old_password"];
        
        if(_PasswordTextField.text.length == 0)
        {
            [KDAlertView showMessage:_PasswordTextField.placeholder cancelButtonTitle:GDLocalizedString(@"NetRequest-OK")];// = "好的";
            
            return;
        }
      }
    
     [self startAPIRequestWithSelector:@"POST api/account/updateemail"
                           parameters:@{@"accountInfo":infoParameters}
                              success:^(NSInteger statusCode, id response) {
                                   if (self.Email.length > 0) {
                                      KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
                                      [hud applySuccessStyle];
                                      [hud hideAnimated:YES afterDelay:2];
                                      [hud setHiddenBlock:^(KDProgressHUD *hud) {
                                          [self dismiss];
                                      }];
                                  }else{
                                      [self setNewPassword];
                                  }
                              }];
}

 -(void)setNewPassword
{
    
    if([[UIDevice currentDevice].systemVersion floatValue] > 8.0){
        
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:nil message:GDLocalizedString(@"Bind-mailNoti") preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:GDLocalizedString(@ "Potocol-Cancel")  style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
 
            [self.navigationController popViewControllerAnimated:YES];
        }];
 
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:GDLocalizedString(@"Person-SetPasswd") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            ChangePasswordViewController *passwordVC =[[ChangePasswordViewController alloc] initWithNibName:@"ChangePasswordViewController" bundle:nil];
            passwordVC.newpasswd = @"newPasswd";
            [self.navigationController pushViewController:passwordVC animated:YES];
        }];
        
        [alertCtrl addAction:cancelAction];
        
        [alertCtrl addAction:okAction];
        
        [self presentViewController:alertCtrl animated:YES completion:nil];
    }else{
        UIAlertView  *alert =[[UIAlertView alloc] initWithTitle:nil message:GDLocalizedString(@"Bind-mailNoti") delegate:self cancelButtonTitle:GDLocalizedString(@"Potocol-Cancel")  otherButtonTitles:GDLocalizedString(@"Person-SetPasswd"), nil];
        [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        ChangePasswordViewController *passwordVC =[[ChangePasswordViewController alloc] initWithNibName:@"ChangePasswordViewController" bundle:nil];
        passwordVC.newpasswd = @"newPasswd";
        [self.navigationController pushViewController:passwordVC animated:YES];
        
    }
}


-(void)SendVertificationCode:(UIButton *)sender
{
 
    if (![self checkTextField]) {
        
        return;
    }
    
     [self startAPIRequestWithSelector:kAPISelectorSendVerifyCode parameters:@{@"code_type":@"email", @"email": _EmailTextField.text} success:^(NSInteger statusCode, NSDictionary *response) {
        
        self.verifyCodeColdDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runVerifyCodeColdDownTimer) userInfo:nil repeats:YES];
        
        self.verifyCodeColdDownCount = 60;
    }];

}
//验证码正则表达式
-(BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//@"验证码倒计时"
- (void)runVerifyCodeColdDownTimer {
    self.verifyCodeColdDownCount--;
    if (self.verifyCodeColdDownCount > 0) {
        self.VertificationButton.enabled = NO;
        [self.VertificationButton setTitle:[NSString stringWithFormat:@"%@%d%@",GDLocalizedString(@"LoginVC-0013"), self.verifyCodeColdDownCount,GDLocalizedString(@"LoginVC-0014")] forState:UIControlStateNormal];
    } else {
        self.VertificationButton.enabled = YES;
        [ self.VertificationButton setTitle:GDLocalizedString(@"LoginVC-008")   forState:UIControlStateNormal];
        [self.verifyCodeColdDownTimer invalidate];
        self.verifyCodeColdDownTimer = nil;
    }
}

- (void)viewDidLayoutSubviews {
    
    const CGFloat xInset = 20, yInset = 11;
    
    _EmailTextField.frame = CGRectMake(xInset, yInset, _tableView.frame.size.width - xInset * 2.0f, _tableView.rowHeight - yInset * 2.0f);
    
    _VertificationTextField.frame = CGRectMake(xInset, yInset, _tableView.frame.size.width - xInset * 2.0f - 100, _tableView.rowHeight - yInset * 2.0f);
    
    self.VertificationButton.frame = CGRectMake(_tableView.frame.size.width - 120, 0, 100, 44);
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

KDUtilRemoveNotificationCenterObserverDealloc

@end

    

