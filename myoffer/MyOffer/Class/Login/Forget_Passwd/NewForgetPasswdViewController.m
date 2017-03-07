//
//  NewForgetPasswdViewController.m
//  myOffer
//
//  Created by xuewuguojie on 15/10/27.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "NewForgetPasswdViewController.h"

@interface NewForgetPasswdViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
 @property (weak, nonatomic) IBOutlet UITextField *AreaTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *veritfyTF;
@property (weak, nonatomic) IBOutlet UITextField *passwdTF;
@property (weak, nonatomic) IBOutlet UIButton *VerifycationButton;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@property(nonatomic,strong)NSArray *areaCodes;
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,assign)int verifyCount;


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

-(void)makeUI{
    
    
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.dataSource = self;
    picker.delegate = self;
    self.AreaTF.inputView = picker;
    
    self.commitButton.backgroundColor = XCOLOR_RED;
    self.VerifycationButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.VerifycationButton  setTitleColor:XCOLOR_RED forState:UIControlStateNormal];
    self.title = @"忘记密码";

}

#pragma mark : UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.passwdTF) {
        
        [self commitButtonPressed:self.commitButton];
        
    }
    
    return YES;
}


-(NSArray *)areaCodes
{
    if (!_areaCodes) {
        
        _areaCodes = @[@"中国(+86)",@"英国(+44)",@"马来西亚(+60)"];

     }
    return _areaCodes;
}

#pragma mark : 重置密码
- (IBAction)commitButtonPressed:(UIButton *)sender {
    
    if (![self checkNetworkState])return;
    
    if (![self verifyRegisterFields]) return;
    
    
    [self
     startAPIRequestWithSelector:kAPISelectorResetPassword
     parameters:@{@"target":self.phoneTF.text, @"new_password": self.passwdTF.text, @"vcode": self.veritfyTF.text}
     success:^(NSInteger statusCode, NSDictionary *response) {
         KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
         [hud applySuccessStyle];
         [hud hideAnimated:YES afterDelay:2];
         [hud setHiddenBlock:^(KDProgressHUD *hud) {
             [self.navigationController popViewControllerAnimated:YES];
         }];
     }];

}

#pragma mark : 发送验证码

- (IBAction)SendCodeButtonPressed:(UIButton *)sender {
  

    BOOL isMatch = [self verifyWithPhone:self.phoneTF.text];
    
    if (!isMatch) {  return; }
    
    
    NSString *areaCode;
    
    if ([self.AreaTF.text containsString:@"44"]) {
        
        areaCode = @"44";
        
    }else if( [self.AreaTF.text containsString:@"60"]){
        
        areaCode = @"60";
        
    }else{
        
        areaCode = @"86";
    }
    
    self.VerifycationButton.enabled = NO;
    
    NSDictionary *parameter = @{@"code_type":@"reset", @"phonenumber":  self.phoneTF.text, @"target":  self.phoneTF.text, @"mobile_code": areaCode};
    
    [self startAPIRequestWithSelector:kAPISelectorSendVerifyCode  parameters:parameter   expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runtimer) userInfo:nil repeats:YES];
        self.verifyCount = 60;
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
         self.VerifycationButton.enabled = YES;
        
     }];
    
}


#pragma mark : 手机号码验证

- (BOOL)verifyWithPhone:(NSString *)phone{
    
    NSString *errorStr;
    
    BOOL isMatch = YES;
    
    if (0 == phone.length) {
        
        errorStr = @"手机号码不能为空";
        
        isMatch = NO;
    }
    
    if ([self.AreaTF.text containsString:@"86"]) {
        
        NSString *china = @"^1\\d{10}$";
        isMatch = [self predicateMatchWithValue:phone  key:china];
        if (!isMatch) errorStr = @"请输入“1”开头的11位数字";
    }
    
    
    if ([self.AreaTF.text containsString:@"44"]) {
        
        NSString *english = @"^7\\d{9}$";
        isMatch = [self predicateMatchWithValue:phone  key:english];
        if (!isMatch) errorStr = @"请输入“7”开头的10位数字";
        
    }
    
    
    if ([self.AreaTF.text containsString:@"60"] ) {
        
        NSString *maraxia = @"^\\d{7,9}$";
        isMatch = [self predicateMatchWithValue:phone  key:maraxia];
        if (!isMatch) errorStr = @"手机号码格式错误";
        
    }
    
    
    if (!isMatch)  AlerMessage(errorStr);
    
    return isMatch;
}

#pragma mark : 手机号码验证

- (BOOL)predicateMatchWithValue:(NSString *)value key:(NSString *)key{
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", key];
    
    BOOL match =  [pre evaluateWithObject:value];
    
    return match;
}

#pragma mark : 注册相关字段验证

- (BOOL)verifyRegisterFields {
    
    BOOL phoneMatch = [self verifyWithPhone: self.phoneTF.text];
    
    if (!phoneMatch) {
        
        return NO;
    }
    
    if (self.veritfyTF.text.length == 0) {
        
        AlerMessage(@"验证码不能为空");
        
        return  NO;
    }
    
    
    if (self.passwdTF.text.length == 0) {
        
        AlerMessage(self.passwdTF.placeholder);
        
        return  NO;
    }
    
    
    if(self.passwdTF.text.length < 6 || self.passwdTF.text.length >16)
    {   //@"密码长度不小于6个字符"
        
        AlerMessage(GDLocalizedString(@"Person-passwd"));
        
        return  NO;
    }
    
    
    return YES;
}

#pragma mark : 验证码倒计时

- (void)runtimer {
    self.verifyCount--;
    if (self.verifyCount > 0) {
        [self.VerifycationButton setTitle:[NSString stringWithFormat:@"%@%d%@",GDLocalizedString(@"LoginVC-0013"), self.verifyCount,GDLocalizedString(@"LoginVC-0014")] forState:UIControlStateNormal];
    } else {
         self.VerifycationButton.enabled = YES;
        [self.VerifycationButton setTitle: @"重新发送"   forState:UIControlStateNormal];
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark :UIPickerViewDataSource, UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.areaCodes.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return self.areaCodes[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.AreaTF.text = self.areaCodes[row];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


#pragma mark :切换按钮的状态

- (IBAction)showPassword:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    self.passwdTF.secureTextEntry = !self.passwdTF.secureTextEntry;
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
