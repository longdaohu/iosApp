//
//  BangViewController.m
//  myOffer
//
//  Created by xuewuguojie on 2016/11/9.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "BangViewController.h"
#import "PhoneBeenViewController.h"
#define  Bang_FontSize 16
#define  Time_Count 60

@interface BangViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)UIButton *sendCodeBtn;
@property(nonatomic,strong)UILabel *errorLab;
@property(nonatomic,strong)UIButton *submitBtn;
@property(nonatomic,strong)UITextField *areaFT;
@property(nonatomic,strong)UITextField *phoneTF;
@property(nonatomic,strong)UITextField *verificationTF;
@property(nonatomic,assign)NSInteger timeCountDown;
@property(nonatomic,strong)NSArray *area_arr;
@property(nonatomic,strong)UIPickerView *areaPicker;

@end

@implementation BangViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"page绑定手机号"];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}




-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    self.navigationController.interactivePopGestureRecognizer.enabled = YES;

    [MobClick endLogPageView:@"page绑定手机号"];

}


- (NSArray *)area_arr{

    if (!_area_arr) {
        
        _area_arr = @[@"中国(+86)",@"英国(+44)",@"马来西亚(+60)"];
        
    }
    return _area_arr;
}

- (UIPickerView *)areaPicker{

    if (!_areaPicker) {
        _areaPicker = [[UIPickerView alloc] init];
        _areaPicker.delegate = self;
        _areaPicker.dataSource = self;
    }
    return _areaPicker;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self makeUI];
    
}



- (void)makeUI{

    self.title = @"绑定手机";
    self.timeCountDown = Time_Count;
    
    CGFloat areaX = 20;
    CGFloat areaY = 30;
    CGFloat areaW = 150;
    CGFloat areaH = 50;
    UIView *areaBgView = [[UIView alloc] initWithFrame:CGRectMake(areaX, areaY, areaW, areaH)];
    [self.view addSubview:areaBgView];
    areaBgView.layer.borderColor =  [UIColor colorWithWhite:0 alpha:0.3].CGColor;
    areaBgView.layer.borderWidth =  1;
    areaBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    
    XTextField *areaFT = [[XTextField alloc] initWithFrame:CGRectMake(0, 10, areaW, 30)];
    [areaBgView addSubview:areaFT];
    areaFT.text = @"中国(+86)";
    [self leftViewWithView:areaFT];
    [areaFT setFont:XFONT(Bang_FontSize)];
    self.areaFT = areaFT;
    areaFT.inputView = self.areaPicker;
    areaFT.rightViewMode = UITextFieldViewModeAlways;
    areaFT.textAlignment = NSTextAlignmentCenter;
    areaFT.leftViewMode = UITextFieldViewModeNever;
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 30)];
    areaFT.rightView = rightView;
    CGFloat arrowW = 20;
    CGFloat arrowH = 30;
    CGFloat arrowY = 0;
    CGFloat arrowX = 0;
    UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake( arrowX, arrowY, arrowW, arrowH)];;
    arrowView.image =  [UIImage imageNamed:@"arrow_down"];
    arrowView.contentMode = UIViewContentModeScaleAspectFit;
    [rightView  addSubview:arrowView];
    
    
    CGFloat phoneX = CGRectGetMaxX(areaBgView.frame) + ITEM_MARGIN;
    CGFloat phoneY = areaY;
    CGFloat phoneW = XScreenWidth - phoneX  - areaX;
    CGFloat phoneH = areaH;
    UITextField *phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(phoneX, phoneY, phoneW, phoneH)];
    [self.view addSubview:phoneTF];
    [self cornerWithView:phoneTF];
    phoneTF.placeholder = @"请输入手机号";
     [phoneTF setFont:XFONT(Bang_FontSize)];
    [self leftViewWithView:phoneTF];
    self.phoneTF = phoneTF;
    phoneTF.keyboardType =  UIKeyboardTypeNumberPad;
    [phoneTF addTarget:self action:@selector(textFiledValueChange:) forControlEvents:UIControlEventEditingChanged];
    
    CGFloat errorX = areaX;
    CGFloat errorY = CGRectGetMaxY(phoneTF.frame) + 5;
    CGFloat errorW = XScreenWidth - areaX;
    CGFloat errorH = 20;
    UILabel *errorLab = [UILabel labelWithFontsize:Bang_FontSize TextColor:[UIColor redColor] TextAlignment:NSTextAlignmentLeft];
    errorLab.frame = CGRectMake(errorX, errorY, errorW, errorH);
    [self.view addSubview:errorLab];
    self.errorLab = errorLab;
    errorLab.text = @"手机格式有误";
    errorLab.alpha = 0;
    
    CGFloat verificationX = areaX;
    CGFloat verificationY = CGRectGetMaxY(areaBgView.frame) + 30;
    CGFloat verificationW = phoneW;
    CGFloat verificationH = phoneH;
    UITextField *verificationTF = [[UITextField alloc] initWithFrame:CGRectMake(verificationX, verificationY, verificationW, verificationH)];
    [self.view addSubview:verificationTF];
    [self cornerWithView:verificationTF];
    verificationTF.placeholder = @"请输入验证码";
    [verificationTF setFont:XFONT(Bang_FontSize)];
    [self leftViewWithView:verificationTF];
    self.verificationTF = verificationTF;
    verificationTF.keyboardType =  UIKeyboardTypeNumberPad;
    [verificationTF addTarget:self action:@selector(textFiledValueChange:) forControlEvents:UIControlEventEditingChanged];
    
    CGFloat codeX = CGRectGetMaxX(verificationTF.frame) + ITEM_MARGIN;
    CGFloat codeY = verificationY;
    CGFloat codeW = areaW;
    CGFloat codeH = verificationH;
    UIButton *sendCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(codeX, codeY, codeW, codeH)];
    [self.view addSubview:sendCodeBtn];
    [sendCodeBtn setTitle:@"获取验证码"  forState:UIControlStateNormal];
    [sendCodeBtn setTitleColor:XCOLOR_RED forState:UIControlStateNormal];
    [sendCodeBtn setTitleColor:XCOLOR_DARKGRAY forState:UIControlStateDisabled];
    [sendCodeBtn addTarget:self action:@selector(sendVerification:) forControlEvents:UIControlEventTouchUpInside];
    sendCodeBtn.titleLabel.font = XFONT(Bang_FontSize);
    sendCodeBtn.layer.cornerRadius = CORNER_RADIUS;
    sendCodeBtn.layer.borderColor = XCOLOR_RED.CGColor;
    sendCodeBtn.layer.borderWidth = 1;
    self.sendCodeBtn = sendCodeBtn;
    
    CGFloat submitX = verificationX;
    CGFloat submitY = CGRectGetMaxY(verificationTF.frame) + 80;
    CGFloat submitW = XScreenWidth - 2 * areaX;
    CGFloat submitH = 50;
    UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(submitX, submitY, submitW, submitH)];
    [self.view addSubview:submitBtn];
    [submitBtn setTitle:@"立即绑定"  forState:UIControlStateNormal];
    [submitBtn setTitleColor:XCOLOR_WHITE forState:UIControlStateNormal];
    submitBtn.backgroundColor = XCOLOR_DARKGRAY;
    [submitBtn addTarget:self action:@selector(caseSubmit:) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.titleLabel.font = XFONT(Bang_FontSize);
    submitBtn.layer.cornerRadius = CORNER_RADIUS;
    self.submitBtn = submitBtn;
    submitBtn.enabled = NO;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
    
}


//倒计时
- (void)runVerifyCodeColdDown{
    
    self.timeCountDown--;
    
    if (self.timeCountDown > 0) {
        
        [self.sendCodeBtn setTitle:[NSString stringWithFormat:@"请稍等%lds", (long)self.timeCountDown] forState:UIControlStateNormal];
        
    } else {
        
        self.sendCodeBtn.layer.borderColor = XCOLOR_RED.CGColor;
        self.sendCodeBtn.enabled = YES;
        [self.sendCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        [self.timer invalidate];
         self.timer  = nil;
         self.timeCountDown = 60;
    }
    
}

//发送验证码
- (void)sendVerification:(UIButton *)sender{
    
    
    NSString *nomalError = @"手机号码格式错误";
    
    if (self.phoneTF.text.length == 0) {
        
        self.errorLab.text = @"手机号码不能为空";
        
        [self showError:YES];
        
         return;
     }
    
    if ([self.areaFT.text containsString:@"86"]) {
        
        NSString *firstChar = [self.phoneTF.text substringWithRange:NSMakeRange(0, 1)];
        NSString *errorStr;
        if (![firstChar isEqualToString:@"1"] || self.phoneTF.text.length != 11) {
        
            errorStr = @"请输入“1”开头的11位数字";
            
            self.errorLab.text = errorStr;
            
            [self showError:YES];
            
            return;
            
        }
        
        
    }
  
    if ([self.areaFT.text containsString:@"44"]) {
        
        NSString *firstChar = [self.phoneTF.text substringWithRange:NSMakeRange(0, 1)];
        NSString *errorStr;

        if (![firstChar isEqualToString:@"7"] || self.phoneTF.text.length != 10) {
            
            errorStr = @"请输入“7”开头的10位数字";
            
            self.errorLab.text = errorStr;
            
            [self showError:YES];
            
            return;
            
        }
        
    }
    
    if ([self.areaFT.text containsString:@"60"] && (self.phoneTF.text.length < 7 || self.phoneTF.text.length > 9) ) {
        
        self.errorLab.text = nomalError;
        
        [self showError:YES];
        
         return;

    }
    
 
    
    sender.enabled = NO;
    
    sender.layer.borderColor = XCOLOR_DARKGRAY.CGColor;
    
    NSString *areaCode;
    
    if ( [self.areaFT.text containsString:@"44"]) {
    
        areaCode = @"44";
        
    }else if( [self.areaFT.text containsString:@"60"]){
    
        areaCode = @"60";
        
    }else{
        
        areaCode = @"86";
    }
    
    
    NSString *phone = self.phoneTF.text;
    
     [self startAPIRequestWithSelector:kAPISelectorSendVerifyCode  parameters:@{@"code_type": @"phone", @"phonenumber":  phone, @"target": phone, @"mobile_code": areaCode}  expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runVerifyCodeColdDown) userInfo:nil repeats:YES];
         
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        sender.layer.borderColor = XCOLOR_RED.CGColor;
        sender.enabled = YES;
        
    }];
    
}

- (void)showError:(BOOL)show{

    
     CGFloat  error_Alpha  =  show ? 1 : 0;
    
     [UIView animateWithDuration:ANIMATION_DUATION animations:^{
         
         self.errorLab.alpha = error_Alpha;
         
     } completion:^(BOOL finished) {
       
     }];
    
}



//提交
- (void)caseSubmit:(UIButton *)sender{
    
    
    NSString *nomalError = @"手机号码格式错误";
    
    if (self.phoneTF.text.length == 0) {
        
        self.errorLab.text = @"手机号码不能为空";
        
        [self showError:YES];
        
        return;
    }
    
    if ([self.areaFT.text containsString:@"86"]) {
        
        NSString *firstChar = [self.phoneTF.text substringWithRange:NSMakeRange(0, 1)];
        NSString *errorStr;
        if (![firstChar isEqualToString:@"1"] || self.phoneTF.text.length != 11) {
            
            errorStr = @"请输入“1”开头的11位数字";
            
            self.errorLab.text = errorStr;
            
            [self showError:YES];
            
            return;
            
        }
        
    }
    
    if ([self.areaFT.text containsString:@"44"]) {
        
        NSString *firstChar = [self.phoneTF.text substringWithRange:NSMakeRange(0, 1)];
        NSString *errorStr;
        
        if (![firstChar isEqualToString:@"7"] || self.phoneTF.text.length != 10) {
            
            errorStr = @"请输入“7”开头的10位数字";
            
            self.errorLab.text = errorStr;
            
            [self showError:YES];
            
            return;
            
        }
        
    }
    
    if ([self.areaFT.text containsString:@"60"] && (self.phoneTF.text.length < 7 || self.phoneTF.text.length > 9) ) {
        
        self.errorLab.text = nomalError;
        
        [self showError:YES];
        
        return;
        
    }

    
    
    NSMutableDictionary *infoParameters =[NSMutableDictionary dictionary];
    [infoParameters setValue:self.areaFT.text forKey:@"mobile_code"];
    [infoParameters setValue:self.phoneTF.text forKey:@"phonenumber"];
    [infoParameters setValue:@{@"code":self.verificationTF.text} forKey:@"vcode"];
    
    [self startAPIRequestWithSelector:@"POST api/account/updatephonenumber" parameters:@{@"accountInfo":infoParameters} expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:^{
        
    } additionalSuccessAction:^(NSInteger statusCode, id response) {
  
        
        KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow   animated:YES];
        [hud applySuccessStyle];
        [hud setLabelText:@"账号绑定成功"];
        [hud hideAnimated:YES afterDelay:1];
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        if ([error.userInfo[@"message"] containsString:@"phone"]) {
 
            [self casePhoneHaveBeenPageWithphoneNumber:error.userInfo[@"message"]];
            
        }

    }];
 
}



- (void)cornerWithView:(UIView *)sender
{
    sender.layer.borderColor =  [UIColor colorWithWhite:0 alpha:0.3].CGColor;
    sender.layer.borderWidth =  1;
}

- (void)leftViewWithView:(UITextField *)sender
{
    sender.leftViewMode =  UITextFieldViewModeAlways;
    sender.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
    
}

#pragma mark ——— UIPickerViewDataSource, UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.area_arr.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return self.area_arr[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
      self.areaFT.text = self.area_arr[row];
    
     if ([self.areaFT.text containsString:@"44"] && self.phoneTF.text.length > 10) {
        
        self.phoneTF.text = self.phoneTF.text.length > 10 ? [self.phoneTF.text substringWithRange:NSMakeRange(0, 10)] : self.phoneTF.text;
     
     }else if ([self.areaFT.text containsString:@"60"] && self.phoneTF.text.length > 9){
         
         self.phoneTF.text = self.phoneTF.text.length > 9 ? [self.phoneTF.text substringWithRange:NSMakeRange(0, 10)] : self.phoneTF.text;

     }
    
}

#pragma mark ——— UITextFieldDelegate
- (void)textFiledValueChange:(UITextField *)textField{
    
    self.submitBtn.enabled = self.phoneTF.text.length > 0 && self.verificationTF.text.length > 0 ? YES : NO ;
    
    self.submitBtn.backgroundColor = self.submitBtn.enabled ?  XCOLOR_RED : XCOLOR_DARKGRAY;
    
    if ([self.areaFT.text containsString:@"44"] && self.phoneTF.isFirstResponder) {
        
        self.phoneTF.text = textField.text.length > 10 ? [textField.text substringWithRange:NSMakeRange(0, 10)] : textField.text;
        
    }else if ([self.areaFT.text containsString:@"60"] && self.phoneTF.isFirstResponder){
    
        self.phoneTF.text = textField.text.length > 9 ? [textField.text substringWithRange:NSMakeRange(0, 9)] : textField.text;
     
    }else if ([self.areaFT.text containsString:@"86"] && self.phoneTF.isFirstResponder){
    
         self.phoneTF.text = textField.text.length > 11 ? [textField.text substringWithRange:NSMakeRange(0, 11)] : textField.text;

    }else if (self.verificationTF.text.length > 6 && self.verificationTF.isFirstResponder){
        
        self.verificationTF.text = textField.text.length > 6 ? [textField.text substringWithRange:NSMakeRange(0, 6)] : textField.text;
    
    }
    
    if (self.phoneTF.isFirstResponder && 1 == self.errorLab.alpha) {
        
        [self showError:NO];
    }
    
    
}


- (void)casePhoneHaveBeenPageWithphoneNumber:(NSString *)phone{
    
    NSArray *items = [phone componentsSeparatedByString:@"="];
    PhoneBeenViewController  *phoneBeen = [[PhoneBeenViewController alloc] init];
    phoneBeen.mergePhone = items[1];
    [self.navigationController pushViewController:phoneBeen animated:YES];
    
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}




@end
