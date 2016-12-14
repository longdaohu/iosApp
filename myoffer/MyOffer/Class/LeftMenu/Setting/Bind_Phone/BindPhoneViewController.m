//
//  BindPhoneViewController.m
//  myOffer
//
//  Created by xuewuguojie on 15/10/29.
//  Copyright © 2015年 UVIC. All rights reserved.
//
#import "BindPhoneViewController.h"
#import "ChangePasswordViewController.h"
@interface BindPhoneViewController ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate> {
    NSArray *_cells;
    UITextField *_AreaCodeTextField, *_PhoneTextField, *_VertificationTextField, *_PasswordTextField;
}
@property(nonatomic,strong)UIButton *VertificationButton;
@property(nonatomic,strong)NSTimer *verifyCodeColdDownTimer;
@property(nonatomic,assign)int verifyCodeColdDownCount;
@property(nonatomic,strong)NSArray *AreaCodes;
@property(nonatomic,strong)UIPickerView *piker;

@end

@implementation BindPhoneViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"page绑定手机号"];
    
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page绑定手机号"];
    
}



-(UIPickerView *)piker
{
    if (!_piker) {
        _piker = [[UIPickerView alloc] init];
        _piker.delegate = self;
        _piker.dataSource = self;
        
        NSUInteger row = USER_EN ? 1 : 0;
        
        [_piker selectRow:row inComponent:0 animated:YES];
        
   
     }
    return _piker;
}
-(NSArray *)AreaCodes
{
    if (!_AreaCodes) {
        
        _AreaCodes = @[@"中国(+86)",@"英国(+44)",@"马来西亚(+60)"];

    }
    return _AreaCodes;
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
    cellTextField.placeholder = placeholder;
    return cellTextField;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
      _tableView.allowsSelection = NO;
      _tableView.rowHeight = 44;
    
    NSMutableArray *cells = [NSMutableArray array];
    
    {
        UITableViewCell *cell = [self cellDefault];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        _AreaCodeTextField = [[XTextField alloc] init];
        _AreaCodeTextField.text = @"中国(+86)";
        _AreaCodeTextField.inputView = self.piker;
        [cell addSubview:_AreaCodeTextField];
        [cells addObject:cell];
    }
    
    {
        UITableViewCell *cell = [self cellDefault];
        _PhoneTextField = [self textFieldCreateWithPlacehodler:@"请输入新手机号码"];
        _PhoneTextField.returnKeyType = UIReturnKeyNext;
        _PhoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        [cell addSubview:_PhoneTextField];
        [cells addObject:cell];
    }
    
    {
        UITableViewCell *cell = [self cellDefault];
        _VertificationTextField = [self textFieldCreateWithPlacehodler:@"请输入验证码"];
        _VertificationTextField.keyboardType = UIKeyboardTypeNumberPad;
          self.VertificationButton =[[UIButton alloc] initWithFrame:CGRectMake(XSCREEN_WIDTH - 120, 0, 100, 44)];
        [self.VertificationButton setTitle:GDLocalizedString(@"LoginVC-008") forState:UIControlStateNormal];
        [self.VertificationButton addTarget:self action:@selector(SendVertificationCode:) forControlEvents:UIControlEventTouchUpInside];
        [self.VertificationButton setTitleColor:XCOLOR_RED forState:UIControlStateNormal];
        [self.VertificationButton setTitleColor:XCOLOR_DARKGRAY forState:UIControlStateDisabled];
        [cell addSubview:self.VertificationButton];
        [cell addSubview:_VertificationTextField];
        [cells addObject:cell];
    }
    
    if (self.phoneNumber.length != 0) {
        UITableViewCell *cell = [self cellDefault];
        _PasswordTextField = [self textFieldCreateWithPlacehodler:GDLocalizedString(@"ChPasswd-loginPasswd")];
        _PasswordTextField.frame = CGRectMake(20, 11, _tableView.frame.size.width - 20 * 2.0f, _tableView.rowHeight - 11 * 2.0f);
        _PasswordTextField.secureTextEntry = YES;
        _PasswordTextField.returnKeyType = UIReturnKeyDone;
        [cell addSubview:_PasswordTextField];
        [cells addObject:cell];
    }
    
    
    _cells = cells;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:GDLocalizedString(@"Evaluate-0017") style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_PhoneTextField becomeFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cells.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _cells[indexPath.row];
}


//提交修改手机号
- (void)done {
    
    
    NSString *nomalError = @"手机号码格式错误";
    
    
    if (_PhoneTextField.text.length == 0) {
        
        AlerMessage(@"手机号码不能为空");
        
        return ;
    }
    
    
    if ([_AreaCodeTextField.text containsString:@"86"]) {
        
        NSString *firstChar = [_PhoneTextField.text substringWithRange:NSMakeRange(0, 1)];
        NSString *errorStr;
        if (![firstChar isEqualToString:@"1"] || _PhoneTextField.text.length != 11) {
            
            errorStr = @"请输入“1”开头的11位数字";
            
            AlerMessage(errorStr);
            
            return;
            
        }
        
    }
    
    
    if ([_AreaCodeTextField.text containsString:@"44"]) {
        
        NSString *firstChar = [_PhoneTextField.text substringWithRange:NSMakeRange(0, 1)];
        NSString *errorStr;
        
        if (![firstChar isEqualToString:@"7"] || _AreaCodeTextField.text.length != 10) {
            
            errorStr = @"请输入“7”开头的10位数字";
            
            AlerMessage(errorStr);
            
            return;
            
        }
        
    }
    
    
    if ([_AreaCodeTextField.text containsString:@"60"] && (_PhoneTextField.text.length > 9 || _PhoneTextField.text.length < 7) ) {
        
        AlerMessage(nomalError);
        
        return;
        
    }
    
    
    if (_VertificationTextField.text.length==0) {
        
        AlerMessage(@"验证码不能为空");
        
        return ;
    }
    
    
    
    if (_PasswordTextField.text.length == 0) {
        
        AlerMessage(_PasswordTextField.placeholder);
        
        return ;
    }
    
    
    if(_PasswordTextField.text.length < 6 || _PasswordTextField.text.length >16)
    {   //@"密码长度不小于6个字符"
        AlerMessage(GDLocalizedString(@"Person-passwd"));
        
        return ;
    }
    
    
    NSMutableDictionary *infoParameters =[NSMutableDictionary dictionary];
    [infoParameters setValue:_AreaCodeTextField.text forKey:@"mobile_code"];
    [infoParameters setValue:_PhoneTextField.text forKey:@"phonenumber"];
    [infoParameters setValue:@{@"code":_VertificationTextField.text} forKey:@"vcode"];
    
    if (self.phoneNumber) {
        [infoParameters setValue:_PasswordTextField.text forKey:@"old_password"];
        if ( _PasswordTextField.text.length == 0) {
            AlerMessage(_PasswordTextField.placeholder);
             return;
        }
     }
    
    [self startAPIRequestWithSelector:@"POST api/account/updatephonenumber"
                               parameters:@{@"accountInfo":infoParameters}
                                  success:^(NSInteger statusCode, id response) {
                                      
                                      if (self.phoneNumber.length > 0) {
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
    
        
        UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:nil message:GDLocalizedString(@"Bind-phoneNoti") preferredStyle:UIAlertControllerStyleAlert];
 
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:GDLocalizedString(@"Potocol-Cancel")  style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
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




//发送验证码
-(void)SendVertificationCode:(UIButton *)sender
{
    
    NSString *nomalError = @"手机号码格式错误";
    
    
    if (_PhoneTextField.text.length == 0) {
        
        AlerMessage(@"手机号码不能为空");
        
        return ;
    }
    
    
    if ([_AreaCodeTextField.text containsString:@"86"]) {
        
        NSString *firstChar = [_PhoneTextField.text substringWithRange:NSMakeRange(0, 1)];
        NSString *errorStr;
        if (![firstChar isEqualToString:@"1"] || _PhoneTextField.text.length != 11) {
            
            errorStr = @"请输入“1”开头的11位数字";
            
            AlerMessage(errorStr);
            
            return;
            
        }
    }
    
    
    if ([_AreaCodeTextField.text containsString:@"44"]) {
        
        NSString *firstChar = [_PhoneTextField.text substringWithRange:NSMakeRange(0, 1)];
        NSString *errorStr;
        
        if (![firstChar isEqualToString:@"7"] || _AreaCodeTextField.text.length != 10) {
            
            errorStr = @"请输入“7”开头的10位数字";
            
            AlerMessage(errorStr);
            
            return;
            
        }
        
    }
    
    
    if ([_AreaCodeTextField.text containsString:@"60"] && (_PhoneTextField.text.length > 9 || _PhoneTextField.text.length < 7) ) {
        
        AlerMessage(nomalError);
        
        return;
        
    }
    
    
    NSString *areaCode;
    
    if ([_AreaCodeTextField.text containsString:@"44"]) {
        
        areaCode = @"44";
        
    }else if( [_AreaCodeTextField.text containsString:@"60"]){
        
        areaCode = @"60";
        
    }else{
        
        areaCode = @"86";
    }

 
    
    self.VertificationButton.enabled = NO;
     [self startAPIRequestWithSelector:kAPISelectorSendVerifyCode  parameters:@{@"code_type":@"phone", @"phonenumber":_PhoneTextField.text, @"target": _PhoneTextField.text, @"mobile_code": areaCode} expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        self.verifyCodeColdDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runVerifyCodeColdDownTimer) userInfo:nil repeats:YES];
         self.verifyCodeColdDownCount = 60;
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        self.VertificationButton.enabled = YES;

    }];
    
    
    
}

//@"验证码倒计时"
- (void)runVerifyCodeColdDownTimer {
    self.verifyCodeColdDownCount--;
    if (self.verifyCodeColdDownCount > 0) {
        [self.VertificationButton setTitle:[NSString stringWithFormat:@"%@%ds",GDLocalizedString(@"LoginVC-0013"), self.verifyCodeColdDownCount] forState:UIControlStateNormal];
    } else {
        self.VertificationButton.enabled = YES;
        [self.VertificationButton setTitle:@"重新发送"  forState:UIControlStateNormal];
        [self.verifyCodeColdDownTimer invalidate];
        self.verifyCodeColdDownTimer = nil;
    }
}

- (void)viewDidLayoutSubviews {
    
    const CGFloat xInset = 20, yInset = 11;
    
    _AreaCodeTextField.frame = CGRectMake(xInset, yInset, _tableView.frame.size.width - xInset * 2.0f, _tableView.rowHeight - yInset * 2.0f);
    _PhoneTextField.frame =_AreaCodeTextField.frame;
    _VertificationTextField.frame = CGRectMake(xInset, yInset, _tableView.frame.size.width - xInset * 2.0f - 100, _tableView.rowHeight - yInset * 2.0f);
    
}

#pragma  Mark   UIPickerViewDataSource, UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    
    return self.AreaCodes.count;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    
    return self.AreaCodes[row];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    _AreaCodeTextField.text = self.AreaCodes[row];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
}

#pragma mark UItextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    
    if (textField == _PasswordTextField)
    {
        [self done];
    }
    
    return YES;
}


KDUtilRemoveNotificationCenterObserverDealloc
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


