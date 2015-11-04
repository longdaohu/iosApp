//
//  NewForgetPasswdViewController.m
//  myOffer
//
//  Created by xuewuguojie on 15/10/27.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "NewForgetPasswdViewController.h"

@interface NewForgetPasswdViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
 @property (weak, nonatomic) IBOutlet UITextField *AreaTextF;
@property (weak, nonatomic) IBOutlet UITextField *RegisterPhoneTextF;
@property (weak, nonatomic) IBOutlet UITextField *VeritficationTextF;
@property (weak, nonatomic) IBOutlet UITextField *RegisterPasswdTextF;
@property (weak, nonatomic) IBOutlet UITextField *RepasswdTextF;
@property (weak, nonatomic) IBOutlet UIButton *VerifycationButton;
@property(nonatomic,copy)NSString *AreaCode;
@property(nonatomic,strong)UIPickerView *piker;
@property(nonatomic,strong)NSArray *AreaCodes;
@property(nonatomic,strong)NSTimer *verifyCodeColdDownTimer;
@property(nonatomic,assign)int verifyCodeColdDownCount;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;


@end

@implementation NewForgetPasswdViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.AreaTextF.inputView = self.piker;
    self.commitButton.backgroundColor =MAINCOLOR;
    self.commitButton.layer.cornerRadius =2;
    self.VerifycationButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self ChangLanguageView];
    
}

-(void)ChangLanguageView
{
    self.title =GDLocalizedString(@"LoginVC-003"); //@"忘记密码";
   
    self.AreaTextF.text = GDLocalizedString(@"LoginVC-china");
  
    NSString *lang =[InternationalControl userLanguage];
     if ([lang containsString:GDLocalizedString(@"ch_Language")]) {
        
        self.AreaTextF.text = GDLocalizedString(@"LoginVC-english");
        
    }
    
    self.RegisterPhoneTextF.placeholder = GDLocalizedString(@"LoginVC-006");// "请输入11位手机号码";
    self.VeritficationTextF.placeholder = GDLocalizedString(@"LoginVC-007");//"请输入验证码";
    self.RegisterPasswdTextF.placeholder = GDLocalizedString(@"LoginVC-005");//"请输入新密码";
    self.RepasswdTextF.placeholder = GDLocalizedString(@"LoginVC-009");//"请再次输入密码";
    [self.commitButton  setTitle:GDLocalizedString(@"LoginVC-0012") forState:UIControlStateNormal];//"重置密码";
    [self.VerifycationButton  setTitle:GDLocalizedString(@"LoginVC-008") forState:UIControlStateNormal];//"重置密码";
 
}


 -(UIPickerView *)piker
{
    if (!_piker) {
        _piker = [[UIPickerView alloc] init];
        _piker.delegate = self;
        _piker.dataSource = self;
         self.AreaCodes = @[GDLocalizedString(@"LoginVC-china"),GDLocalizedString(@"LoginVC-english")];//@[@"中国(+86)",@"英国(+44)"];
     }
    return _piker;
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


- (IBAction)SendCodeButtonPressed:(UIButton *)sender {
  
    //"LoginVC-chinese" = "中国";
    if ([self.AreaTextF.text containsString:GDLocalizedString(@"LoginVC-chinese")] && self.RegisterPhoneTextF.text.length != 11) {
        
        [KDAlertView showMessage: GDLocalizedString(@"LoginVC-PhoneNumberError") cancelButtonTitle: GDLocalizedString(@"Evaluate-0016")];
        
         return ;
    }
    //"LoginVC-england" = "英国";
    if ([self.AreaTextF.text containsString:GDLocalizedString(@"LoginVC-england")] && self.RegisterPhoneTextF.text.length != 10) {
         [KDAlertView showMessage: GDLocalizedString(@"LoginVC-EnglandNumberError") cancelButtonTitle: GDLocalizedString(@"Evaluate-0016")];//@"好的"];
        return ;
    }
    
    NSString *phoneAreaString = self.AreaTextF.text;
    self.AreaCode = @"86";
    if([phoneAreaString containsString:GDLocalizedString(@"LoginVC-england")])//@"英国"])
    {
        self.AreaCode = @"44";
    }
    
     [self startAPIRequestWithSelector:kAPISelectorSendVerifyCode parameters:@{@"code_type":@"reset", @"phonenumber":  self.RegisterPhoneTextF.text, @"target":  self.RegisterPhoneTextF.text, @"mobile_code": self.AreaCode} success:^(NSInteger statusCode, NSDictionary *response) {
        
        self.verifyCodeColdDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runVerifyCodeColdDownTimer) userInfo:nil repeats:YES];
        
        self.verifyCodeColdDownCount = 60;
     }];
}

//注册相关字段验证
- (BOOL)verifyRegisterFields {
    
  
    //"LoginVC-chinese" = "中国";
    if ([self.AreaTextF.text containsString:GDLocalizedString(@"LoginVC-chinese")] && self.RegisterPhoneTextF.text.length != 11) {
        
        [KDAlertView showMessage: GDLocalizedString(@"LoginVC-PhoneNumberError") cancelButtonTitle: GDLocalizedString(@"Evaluate-0016")];
        
        return NO;
    }
    //"LoginVC-england" = "英国";
    if ([self.AreaTextF.text containsString:GDLocalizedString(@"LoginVC-england")] && self.RegisterPhoneTextF.text.length != 10) {
        
        [KDAlertView showMessage: GDLocalizedString(@"LoginVC-EnglandNumberError") cancelButtonTitle: GDLocalizedString(@"Evaluate-0016")];//@"好的"];
        return NO;
    }
    
    if (self.VeritficationTextF.text.length == 0) {
        [KDAlertView showMessage: GDLocalizedString(@"LoginVC-007")  cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];//@"好的"];
        return NO;
    }
    
    if(self.RegisterPasswdTextF.text.length < 6 || self.RegisterPasswdTextF.text.length >16)
    {   //@"密码长度不小于6个字符"
        [KDAlertView showMessage:GDLocalizedString(@"Person-passwd") cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];//@"好的"];
        return NO;
    }
    
    if (![self.RepasswdTextF.text isEqualToString:self.RegisterPasswdTextF.text]) {
        [KDAlertView showMessage:GDLocalizedString(@"ChPasswd-004")   cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];//@"好的"];
        return NO;
    }
    
    return YES;
}


//@"验证码倒计时"
- (void)runVerifyCodeColdDownTimer {
    self.verifyCodeColdDownCount--;
    if (self.verifyCodeColdDownCount > 0) {
        self.VerifycationButton.enabled = NO;
        [self.VerifycationButton setTitle:[NSString stringWithFormat:@"%@%d%@",GDLocalizedString(@"LoginVC-0013"), self.verifyCodeColdDownCount,GDLocalizedString(@"LoginVC-0014")] forState:UIControlStateNormal];
    } else {
         self.VerifycationButton.enabled = YES;
        [ self.VerifycationButton setTitle:GDLocalizedString(@"LoginVC-008")   forState:UIControlStateNormal];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

@end
