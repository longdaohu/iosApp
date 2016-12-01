//
//  NewForgetPasswdViewController.m
//  myOffer
//
//  Created by xuewuguojie on 15/10/27.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "NewForgetPasswdViewController.h"

@interface NewForgetPasswdViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
 @property (weak, nonatomic) IBOutlet UITextField *AreaTextF;
@property (weak, nonatomic) IBOutlet UITextField *RegisterPhoneTextF;
@property (weak, nonatomic) IBOutlet UITextField *VeritficationTextF;
@property (weak, nonatomic) IBOutlet UITextField *RegisterPasswdTextF;
@property (weak, nonatomic) IBOutlet UIButton *VerifycationButton;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property(nonatomic,strong)UIPickerView *piker;
@property(nonatomic,strong)NSArray *AreaCodes;
@property(nonatomic,strong)NSTimer *verifyCodeColdDownTimer;
@property(nonatomic,assign)int verifyCodeColdDownCount;


@end

@implementation NewForgetPasswdViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [MobClick beginLogPageView:@"page忘记密码"];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"page忘记密码"];
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self makeUI];
    
}


-(void)makeUI
{
    self.AreaTextF.inputView = self.piker;
    self.commitButton.backgroundColor =XCOLOR_RED;
    self.commitButton.layer.cornerRadius =2;
    self.VerifycationButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.title = @"忘记密码";
    [self.VerifycationButton  setTitleColor:XCOLOR_RED forState:UIControlStateNormal];
}

#pragma mark   UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.RegisterPasswdTextF) {
        
        [self commitButtonPressed:self.commitButton];
        
    }
    
    return YES;
}




 -(UIPickerView *)piker
{
    if (!_piker) {
        
        _piker = [self PickerView];
        
      }
    
    return _piker;
}
-(UIPickerView *)PickerView
{
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.dataSource = self;
    picker.delegate = self;
    return picker;
}

-(NSArray *)AreaCodes
{
    if (!_AreaCodes) {
        
        _AreaCodes = @[@"中国(+86)",@"英国(+44)",@"马来西亚(+60)"];

     }
    return _AreaCodes;
}


//重置密码
- (IBAction)commitButtonPressed:(UIButton *)sender {
    
     if (![self verifyRegisterFields]) {
         
        return;
    }
    
    
    [self
     startAPIRequestWithSelector:kAPISelectorResetPassword
     parameters:@{@"target":self.RegisterPhoneTextF.text, @"new_password": self.RegisterPasswdTextF.text, @"vcode": self.VeritficationTextF.text}
     success:^(NSInteger statusCode, NSDictionary *response) {
         KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
         [hud applySuccessStyle];
         [hud hideAnimated:YES afterDelay:2];
         [hud setHiddenBlock:^(KDProgressHUD *hud) {
             [self.navigationController popViewControllerAnimated:YES];
         }];
     }];

}

//发送验证码
- (IBAction)SendCodeButtonPressed:(UIButton *)sender {
  
    NSString *nomalError = @"手机号码格式错误";
    
    if (self.RegisterPhoneTextF.text.length == 0) {
        
        AlerMessage(@"手机号码不能为空");
        
        return ;
    }
    
    
    if ([self.AreaTextF.text containsString:@"86"]) {
        
        NSString *firstChar = [self.RegisterPhoneTextF.text substringWithRange:NSMakeRange(0, 1)];
        NSString *errorStr;
        if (![firstChar isEqualToString:@"1"] || self.RegisterPhoneTextF.text.length != 11) {
            
            errorStr = @"请输入“1”开头的11位数字";
            
            AlerMessage(errorStr);
            
            return;
            
        }
        
    }
    
    if ([self.AreaTextF.text containsString:@"44"]) {
        
        NSString *firstChar = [self.RegisterPhoneTextF.text substringWithRange:NSMakeRange(0, 1)];
        NSString *errorStr;
        
        if (![firstChar isEqualToString:@"7"] || self.RegisterPhoneTextF.text.length != 10) {
            
            errorStr = @"请输入“7”开头的10位数字";
            
            AlerMessage(errorStr);
            
            return;
            
        }
        
    }
    
    if ([self.AreaTextF.text containsString:@"60"] && (self.RegisterPhoneTextF.text.length > 9 || self.RegisterPhoneTextF.text.length < 7) ) {
        
        AlerMessage(nomalError);
        
        return;
        
    }
    
    
    NSString *areaCode;
    
    if ([self.AreaTextF.text containsString:@"44"]) {
        
        areaCode = @"44";
        
    }else if( [self.AreaTextF.text containsString:@"60"]){
        
        areaCode = @"60";
        
    }else{
        
        areaCode = @"86";
    }
    
    self.VerifycationButton.enabled = NO;
    
    NSDictionary *parameter = @{@"code_type":@"reset", @"phonenumber":  self.RegisterPhoneTextF.text, @"target":  self.RegisterPhoneTextF.text, @"mobile_code": areaCode};
    
    [self startAPIRequestWithSelector:kAPISelectorSendVerifyCode  parameters:parameter   expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        self.verifyCodeColdDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runVerifyCodeColdDownTimer) userInfo:nil repeats:YES];
        self.verifyCodeColdDownCount = 60;
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
         self.VerifycationButton.enabled = YES;
        
     }];
    
}

//注册相关字段验证
- (BOOL)verifyRegisterFields {
    
    
    if (![self checkNetworkState]) {
        
        return NO;
    }
    
    NSString *nomalError = @"手机号码格式错误";
    
    
    if (self.RegisterPhoneTextF.text.length == 0) {
        
        AlerMessage(@"手机号码不能为空");
        
        return NO;
    }
    
    
    if ([self.AreaTextF.text containsString:@"86"]) {
        
        NSString *firstChar = [self.RegisterPhoneTextF.text substringWithRange:NSMakeRange(0, 1)];
        NSString *errorStr;
        if (![firstChar isEqualToString:@"1"] || self.RegisterPhoneTextF.text.length != 11) {
            
            errorStr = @"请输入“1”开头的11位数字";
            
            AlerMessage(errorStr);
            
            return NO;
            
        }
    }
    
    
    
    if ([self.AreaTextF.text containsString:@"44"]) {
        
        NSString *firstChar = [self.RegisterPhoneTextF.text substringWithRange:NSMakeRange(0, 1)];
        NSString *errorStr;
        
        if (![firstChar isEqualToString:@"7"] || self.RegisterPhoneTextF.text.length != 10) {
            
            errorStr = @"请输入“7”开头的10位数字";
            
            AlerMessage(errorStr);
            
            return NO;
            
        }
        
    }
    
    
    if ([self.AreaTextF.text containsString:@"60"] && (self.RegisterPhoneTextF.text.length > 9 || self.RegisterPhoneTextF.text.length < 7) ) {
        
        AlerMessage(nomalError);
        
        return NO;
        
    }
    
    
    
    if (self.RegisterPasswdTextF.text.length == 0) {
        
        AlerMessage(@"密码不能为空");
        
        return NO;
    }
    
    
    
    if (self.RegisterPasswdTextF.text.length < 6) {
        
        
        AlerMessage(@"密码不能少于6位字符");
        return NO;
    }
    
    if (self.RegisterPasswdTextF.text.length >16) {
        
        AlerMessage(@"密码不能多于16位字符");
        return NO;
    }
    
    
    if (self.VeritficationTextF.text.length == 0) {
        
        AlerMessage(@"验证码不能为空");
        
         return NO;
    }
    
    
    if(self.RegisterPasswdTextF.text.length < 6 || self.RegisterPasswdTextF.text.length >16)
    {   //@"密码长度不小于6个字符"
        AlerMessage(GDLocalizedString(@"Person-passwd"));
         return NO;
    }
    
    
    return YES;
}

//@"验证码倒计时"
- (void)runVerifyCodeColdDownTimer {
    self.verifyCodeColdDownCount--;
    if (self.verifyCodeColdDownCount > 0) {
        [self.VerifycationButton setTitle:[NSString stringWithFormat:@"%@%d%@",GDLocalizedString(@"LoginVC-0013"), self.verifyCodeColdDownCount,GDLocalizedString(@"LoginVC-0014")] forState:UIControlStateNormal];
    } else {
         self.VerifycationButton.enabled = YES;
        [self.VerifycationButton setTitle: @"重新发送"   forState:UIControlStateNormal];
        [self.verifyCodeColdDownTimer invalidate];
        self.verifyCodeColdDownTimer = nil;
    }
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
    
    self.AreaTextF.text = self.AreaCodes[row];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)showPassword:(UIButton *)sender {
    
    // 切换按钮的状态
    sender.selected = !sender.selected;
    self.RegisterPasswdTextF.secureTextEntry = !self.RegisterPasswdTextF.secureTextEntry;
    NSString *imageName = sender.selected ? @"showpassword" : @"hidepassword";
    [sender setImage:XImage(imageName) forState:UIControlStateNormal];
    
}





- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

-(void)dealloc{
    
    KDClassLog(@"忘记密码  dealloc");
    
}



@end
