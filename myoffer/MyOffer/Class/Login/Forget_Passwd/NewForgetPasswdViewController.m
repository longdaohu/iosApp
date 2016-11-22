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
//@property (weak, nonatomic) IBOutlet UITextField *RepasswdTextF;
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
    [self ChangLanguageView];
    
}


-(void)makeUI
{
    self.AreaTextF.inputView = self.piker;
    self.commitButton.backgroundColor =XCOLOR_RED;
    self.commitButton.layer.cornerRadius =2;
    self.VerifycationButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.RegisterPasswdTextF.delegate =self;
//    self.RepasswdTextF.delegate =self;
    self.RegisterPasswdTextF.returnKeyType = UIReturnKeyNext;
    
}

#pragma mark   UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.RegisterPasswdTextF) {
        
        [self commitButtonPressed:nil];
        
    }
    
    return YES;
}

-(void)ChangLanguageView
{
    self.title =GDLocalizedString(@"LoginVC-003"); //@"忘记密码";
   
    self.AreaTextF.text = GDLocalizedString(@"LoginVC-china");
  
//    NSString *lang =[InternationalControl userLanguage];
//    
//     if ([lang containsString:GDLocalizedString(@"ch_Language")]) {
//         self.AreaTextF.text = GDLocalizedString(@"LoginVC-english");
//    }
    self.RegisterPhoneTextF.placeholder = GDLocalizedString(@"LoginVC-006");// "请输入11位手机号码";
    self.VeritficationTextF.placeholder = GDLocalizedString(@"LoginVC-007");//"请输入验证码";

    [self.commitButton  setTitle:GDLocalizedString(@"LoginVC-0012") forState:UIControlStateNormal];//"重置密码";
    [self.VerifycationButton  setTitle:GDLocalizedString(@"LoginVC-008") forState:UIControlStateNormal];//"重置密码";
 
}


 -(UIPickerView *)piker
{
    if (!_piker) {
        
        _piker = [self PickerView];
        
//        NSUInteger row = USER_EN ? 1 : 0;
//        [_piker selectRow:0 inComponent:0 animated:YES];
        
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
        
        _AreaCodes = @[GDLocalizedString(@"LoginVC-china"),GDLocalizedString(@"LoginVC-english")];
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


- (IBAction)SendCodeButtonPressed:(UIButton *)sender {
  
    //"LoginVC-chinese" = "中国";
    if ([self.AreaTextF.text containsString:@"86"] && self.RegisterPhoneTextF.text.length != 11) {
        AlerMessage(GDLocalizedString(@"LoginVC-PhoneNumberError"));
          return ;
    }
    //"LoginVC-england" = "英国";
    if ([self.AreaTextF.text containsString:@"44"] && self.RegisterPhoneTextF.text.length != 10) {
        AlerMessage(GDLocalizedString(@"LoginVC-EnglandNumberError"));
         return ;
    }
  
    self.AreaCode = [self.AreaTextF.text containsString:@"86"] ? @"86":@"44";
    self.VerifycationButton.enabled = NO;
    NSDictionary *parameter = @{@"code_type":@"reset", @"phonenumber":  self.RegisterPhoneTextF.text, @"target":  self.RegisterPhoneTextF.text, @"mobile_code": self.AreaCode};
    
    [self startAPIRequestWithSelector:kAPISelectorSendVerifyCode  parameters:parameter   expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        self.verifyCodeColdDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runVerifyCodeColdDownTimer) userInfo:nil repeats:YES];
        self.verifyCodeColdDownCount = 60;
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
         self.VerifycationButton.enabled = YES;
     }];
    
}

//注册相关字段验证
- (BOOL)verifyRegisterFields {
    
     //"LoginVC-chinese" = "中国";
    if ([self.AreaTextF.text containsString:@"86"] && self.RegisterPhoneTextF.text.length != 11) {
        AlerMessage(GDLocalizedString(@"LoginVC-PhoneNumberError"));
        return  NO;
    }
    //"LoginVC-england" = "英国";
    if ([self.AreaTextF.text containsString:@"44"] && self.RegisterPhoneTextF.text.length != 10) {
        AlerMessage(GDLocalizedString(@"LoginVC-EnglandNumberError"));
        return  NO;
    }
    
    if (self.VeritficationTextF.text.length == 0) {
        AlerMessage(GDLocalizedString(@"LoginVC-007"));
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

//@"验证码倒计时"
- (void)runVerifyCodeColdDownTimer {
    self.verifyCodeColdDownCount--;
    if (self.verifyCodeColdDownCount > 0) {
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
