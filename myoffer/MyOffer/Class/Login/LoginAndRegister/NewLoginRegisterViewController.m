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
#import "UMSocial.h"
#import "APService.h"
#import "LoginSelectViewController.h"
#import "BangViewController.h"

@interface NewLoginRegisterViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
//蒙版
@property (weak, nonatomic) IBOutlet FXBlurView *LoginBlurView;
//后退按钮
@property (weak, nonatomic) IBOutlet KDEasyTouchButton *backButton;
//XX按钮
@property (weak, nonatomic) IBOutlet KDEasyTouchButton *DismissButton;
//验证码Timer
@property(nonatomic,strong)NSTimer *verifyCodeColdDownTimer;
//验证码倒计时
@property(nonatomic,assign)int verifyCodeCount;

@property (weak, nonatomic) IBOutlet UITextField *LoginPhoneNumberTextF;

@property (weak, nonatomic) IBOutlet UITextField *LoginPasswdTextF;
//注册地区编号
@property (weak, nonatomic) IBOutlet UITextField *RegisterAreaTextF;
//注册手机号
@property (weak, nonatomic) IBOutlet UITextField *RegisterPhoneTextF;
//注册验证码
@property (weak, nonatomic) IBOutlet UITextField *RegisterVerTextF;
//注册密码
@property (weak, nonatomic) IBOutlet UITextField *RegisterPasswdTextF;
//发送验证码按钮
@property (weak, nonatomic) IBOutlet UIButton *VerificationBtn;
//地区编号数组
@property(nonatomic,strong)NSArray *AreaArr;
//登录——忘记密码
@property (weak, nonatomic) IBOutlet UIButton *ForgetButton;
//登录——或者Lab
@property (weak, nonatomic) IBOutlet UILabel *ORlabel;
//登录——提交登录按钮
@property (weak, nonatomic) IBOutlet UIButton *signInCommitButton;
//切换登录选项
@property (weak, nonatomic) IBOutlet UIButton *LoginSelectButton;
//切换注册选项
@property (weak, nonatomic) IBOutlet UIButton *SignUpselectButton;
//注册提交按钮
@property (weak, nonatomic) IBOutlet UIButton *signUpCommitButton;
//弹出注册页面
@property (weak, nonatomic) IBOutlet KDEasyTouchButton *signUpButton;
//弹出登录页面
@property (weak, nonatomic) IBOutlet KDEasyTouchButton *signInButton;
//查看服务条款
@property (weak, nonatomic) IBOutlet UIButton *ServiceButton;

@property (weak, nonatomic) IBOutlet UIView *ButtonView;
//切换注册登录的三角图标
@property(nonatomic,strong)UIImageView *FocusView;
//地区输入框右边图片
@property (weak, nonatomic) IBOutlet UIImageView *ArrowAreaMView;
//明文按钮
@property (weak, nonatomic) IBOutlet UIButton *showPasswdBtn;



@end

@implementation NewLoginRegisterViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    [MobClick beginLogPageView:@"page登录页面"];
  
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    //第三方绑定注释时左划手势失效，返回登录页面时，忘记密码、注册协议页面手势失效问题修改
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;

}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page登录页面"];
    
}


//arrow上下转换
-(void)RegisterAreaTextfieldArrow
{
     [UIView animateWithDuration:ANIMATION_DUATION animations:^{
         self.ArrowAreaMView.transform = self.RegisterAreaTextF.isEditing? CGAffineTransformRotate(self.ArrowAreaMView.transform, M_PI):CGAffineTransformIdentity;
    }];
    
}



//用于添加控件、设置控件相关属性
-(void)makeUI
{
    
    CGRect loginBgViewFrame = self.LoginBgView.frame;
    loginBgViewFrame.origin.x = 0;
    loginBgViewFrame.origin.y = XSCREEN_HEIGHT;
    loginBgViewFrame.size.width = XSCREEN_WIDTH;
    loginBgViewFrame.size.height = XSCREEN_HEIGHT*2/3;
    self.LoginBgView.frame  = loginBgViewFrame;
    [self.view addSubview:self.LoginBgView];
    
    
    CGRect LoginViewFrame = self.LoginView.frame;
    LoginViewFrame.origin.x = 0;
    LoginViewFrame.origin.y = 40;
    LoginViewFrame.size.width = loginBgViewFrame.size.width;
    LoginViewFrame.size.height = loginBgViewFrame.size.height - LoginViewFrame.origin.y;
    self.LoginView.frame = LoginViewFrame;
    [self.LoginBgView addSubview:self.LoginView];
    
    
    UIPickerView *AreaPicker =[[UIPickerView alloc] init];
    AreaPicker.delegate =self;
    AreaPicker.dataSource =self;
    [AreaPicker selectRow:0 inComponent:0 animated:YES];
    self.RegisterAreaTextF.inputView =AreaPicker;
    
    
    _LoginBlurView.dynamic = NO;
    [_LoginBlurView setTintColor:nil];
    [_LoginBlurView setIterations:3];
    [_LoginBlurView setBlurRadius:10];
    [_LoginBlurView updateAsynchronously:YES completion:^{}];
    _LoginBlurView.frame = CGRectMake(0, 0, XSCREEN_WIDTH, XSCREEN_HEIGHT);
   
    self.signInButton.layer.borderColor = XCOLOR_WHITE.CGColor;
    
    self.signInCommitButton.backgroundColor = XCOLOR_RED;
    self.signUpCommitButton.backgroundColor = XCOLOR_RED;
    self.ServiceButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.VerificationBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    self.FocusView =[[UIImageView alloc] initWithFrame:CGRectMake(0,30, 30, 10)];
    self.FocusView.contentMode =  UIViewContentModeScaleAspectFit;
    self.FocusView.image =[UIImage imageNamed:@"Triangle"];
    [self.ButtonView addSubview:self.FocusView];
    self.FocusView.center = CGPointMake(self.LoginSelectButton.center.x, 38);
  
    
    [self.LoginPasswdTextF addTarget:self action:@selector(loginPasswordValueChange:) forControlEvents:UIControlEventEditingChanged];
    [self.RegisterAreaTextF addTarget:self action:@selector(RegisterAreaTextfieldArrow) forControlEvents:UIControlEventEditingDidBegin];
    [self.RegisterAreaTextF addTarget:self action:@selector(RegisterAreaTextfieldArrow) forControlEvents:UIControlEventEditingDidEnd];
}



-(NSArray *)AreaArr
{
    if (!_AreaArr) {
        
        _AreaArr = @[@"中国(+86)",@"英国(+44)",@"马来西亚(+60)"];
     }
    return _AreaArr;
}


//设置控件中英文
-(void)ChangLanguageView
{
    
    NSString *serviceString = GDLocalizedString(@ "LoginVC-0010");
     NSRange NotiRangne =[serviceString rangeOfString:GDLocalizedString(@ "LoginVC-keyWord")];
    NSMutableAttributedString *AtributeStr = [[NSMutableAttributedString alloc] initWithString:serviceString ];
     [AtributeStr addAttribute:NSForegroundColorAttributeName value:XCOLOR_RED range: NotiRangne];
     [AtributeStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NotiRangne];
     [self.ServiceButton setAttributedTitle: AtributeStr forState:UIControlStateNormal];
 }


- (void)makeNotificationCenter{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
    
    [self ChangLanguageView];
    
    [self makeNotificationCenter];
  
}

#pragma mark ——————- 键盘处理
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
    
    CGSize contentSize = self.view.bounds.size;
    
    if (up) {
        
        self.LoginBgView.center = CGPointMake(contentSize.width / 2.0f, (contentSize.height - keyboardEndFrame.size.height) / 2.0f + 40.0);
        
     } else {
         
       self.LoginBgView.center = CGPointMake(contentSize.width / 2.0f, XSCREEN_HEIGHT*2/3);
    }
    
    [self.view layoutSubviews];
    
    [UIView commitAnimations];
}


//注册切换登录按钮
- (IBAction)changeLoginView:(UIButton *)sender {
    
     [self LoginView:NO withSender:sender];

 }
//登录切换注册按钮
- (IBAction)changeRegisterView:(UIButton *)sender {
   
    [self LoginView:YES withSender:sender];
}

//登录、注册按钮之间切换
- (void)LoginView:(BOOL)hiden withSender:(UIButton *)sender
{
    
   [self.view endEditing:YES];
    
    self.SignUpView.hidden = !hiden;
    
    self.LoginView.hidden = hiden;
    
    [UIView animateWithDuration:0.01 animations:^{
    
        self.FocusView.center = CGPointMake(sender.center.x, 38);
        
    }];
    
    //密码框是否明文显示
    if ([sender.currentTitle isEqualToString:@"登录"] || self.RegisterPasswdTextF.secureTextEntry == NO)  [self showPassword:self.showPasswdBtn];
    

}

//用于控制登录、注册页面显示或隐藏
-(void)LoginViewShow:(BOOL)show sender:(UIButton *)sender
{
   
    CGRect NewRect = self.LoginBgView.frame;
    NewRect.origin.y = show ? XSCREEN_HEIGHT / 3 : XSCREEN_HEIGHT;
    NewRect.size.width = XSCREEN_WIDTH;
    NewRect.size.height = 2 * XSCREEN_HEIGHT/3;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.LoginBlurView.alpha = show ? 1 : 0;
        self.backButton.alpha = show ? 1 : 0;
        self.LoginBgView.frame = NewRect;
        
    }];
    
  
    if ([sender.currentTitle isEqualToString:GDLocalizedString(@"LoginVC-002")]) {
        
        self.LoginView.hidden = YES;
        self.FocusView.center = CGPointMake(XSCREEN_WIDTH*0.75,38);
        
    }else if([sender.currentTitle isEqualToString:GDLocalizedString(@"LoginVC-001")]){
        
        
        self.SignUpView.hidden = YES;
        self.FocusView.center = CGPointMake(XSCREEN_WIDTH*0.25,38);
        
    }else{
        
        //当登录、注册页面回到初始位置时，子控件内容会被清空
        self.LoginPasswdTextF.text = @"";
        self.LoginPhoneNumberTextF.text = @"";
        self.RegisterPhoneTextF.text = @"";
        self.RegisterVerTextF.text = @"";
        self.RegisterPasswdTextF.text = @"";
        self.VerificationBtn.enabled = YES;
        [self.VerificationBtn setTitle:@"获取验证码"  forState:UIControlStateNormal];
        [self.verifyCodeColdDownTimer invalidate];
        _verifyCodeColdDownTimer = nil;
        
        self.LoginView.hidden = NO;
        self.SignUpView.hidden = NO;
        
    }
 
}

//跳转登录页面按钮   //跳转注册页面按钮
- (IBAction)LoginButtonPressed:(UIButton *)sender {
    
      [self LoginViewShow:YES sender:sender];
  
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
   
    if ([[AppDelegate sharedDelegate] isLogin])  return; //当登录情况，根本不会用到这个方法
    
    [self.view  endEditing:YES];
}

// 正常（非第三方）登录
- (IBAction)LoginButtonCommit:(id)sender {
    
 
    if (![self checkNetworkState]) return; //网络连接失败提示
    
    if (0 ==  self.LoginPhoneNumberTextF.text.length) {
        
         AlerMessage(@"手机号码不能为空");
        
        return;
    }
    
    if (0 ==  self.LoginPasswdTextF.text.length ) {
        
        AlerMessage(@"密码不能为空");
        
        return;
    }
    
    [self
     startAPIRequestWithSelector:kAPISelectorLogin
     parameters:@{@"username":self.LoginPhoneNumberTextF.text , @"password": self.LoginPasswdTextF.text}
     success:^(NSInteger statusCode, NSDictionary *response) {
  
         [self LoginSuccessWithResponse:response];
  
     }];
  
}


//正常登录成功相关处理  （非第三方）登录
-(void)LoginSuccessWithResponse:(NSDictionary *)response
{
    NSLog(@"正常登录成功相关处理  = %@",response);
    
    [APService setAlias:response[@"jpush_alias"] callbackSelector:nil object:nil];//Jpush设置登录用户别名
    [[AppDelegate sharedDelegate] loginWithAccessToken:response[@"access_token"]];
    [MobClick profileSignInWithPUID:response[@"access_token"]];/*友盟统计记录用户账号*/
    NSLog(@"access_token = %@",response[@"jpush_alias"]);
    [MobClick event:@"myofferUserLogin"];
    
    //当用户没有电话时发出通知，让用户填写手机号
    NSString *phone =response[@"phonenumber"];
    
    if (phone.length == 0) {
        
        [self.view endEditing:YES];
        
    }else{
        
        KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
        [hud applySuccessStyle];
        [hud hideAnimated:YES afterDelay:2];
        [hud setHiddenBlock:^(KDProgressHUD *hud) {
            
            [self dismiss];
            
        }];
        
    }
    
}

// 第三方登录
- (IBAction)otherLogin:(UIButton *)sender
{
    
    NSString *shareplatform;
    NSString *platformName;
    if ( 999 == sender.tag) {
     
        shareplatform = UMShareToSina;
        platformName = @"weibo";
        
    }else if ( 998 == sender.tag) {
        
        shareplatform = UMShareToQzone;
        platformName = @"qq";

    }else {

        shareplatform = UMShareToWechatSession;
        platformName = @"wechat";

    }
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:shareplatform];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:shareplatform];
           
            NSMutableDictionary *userInfo =[NSMutableDictionary dictionary];
            [userInfo setValue:snsAccount.usid forKey:@"user_id"];
            [userInfo setValue:platformName forKey:@"provider"];
            [userInfo setValue:snsAccount.accessToken forKey:@"token"];
            [self  loginWithParameters:userInfo];
        }
    });
    
 
}

// 第三方登录传参并登录
-(void)loginWithParameters:(NSMutableDictionary *)userInfo
{
     //存储第三方登录平台信息  用于绑定手机页面使用
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setValue:userInfo[@"provider"]  forKey:@"provider"];
    [ud synchronize];
    
    [self  startAPIRequestWithSelector:kAPISelectorLogin  parameters:userInfo success:^(NSInteger statusCode, NSDictionary *response) {
        
         if (response[@"new"]) {
             
             [self caseLoginSelection:userInfo];
             
        }else if([response[@"role"] isEqualToString:@"user"]){
            
            [self OtherLoginSuccessWithResponse:response andUserInfo:userInfo];
            
        }
        
    }];
    
}

//登录前判断用户资料是否包含手机号码
-(void)OtherLoginSuccessWithResponse:(NSDictionary *)response andUserInfo:(NSDictionary *)userInfo
{
    [APService setAlias:response[@"jpush_alias"] callbackSelector:nil object:nil];//Jpush设置登录用户别名
    
    [[AppDelegate sharedDelegate] loginWithAccessToken:response[@"access_token"]];
    
    [MobClick profileSignInWithPUID:response[@"access_token"] provider:[userInfo valueForKey:@"provider"]];/*友盟统计记录用户账号*/
    
    [MobClick event:@"otherUserLogin"];
    
    //当用户没有电话时发出通知，让用户填写手机号
    !response[@"phonenumber"]? [self caseBangding] :  [self dismiss];
    
}

#pragma mark : 发送验证码

- (IBAction)SendVertificationCode:(id)sender {
    
    BOOL isMatch = [self verifyWithPhone:self.RegisterPhoneTextF.text];
    
    if (!isMatch) {  return; }
  
    NSString *areaCode;
    
    if ([self.RegisterAreaTextF.text containsString:@"44"]) {
        
        areaCode = @"44";
        
    }else if( [self.RegisterAreaTextF.text containsString:@"60"]){
        
        areaCode = @"60";
        
    }else{
        
        areaCode = @"86";
    }

    
    NSString *phoneNumber = self.RegisterPhoneTextF.text;
    
    UIButton *vertificationBtn = (UIButton *)sender;
    
    vertificationBtn.enabled = NO;
    
    [self startAPIRequestWithSelector:kAPISelectorSendVerifyCode  parameters:@{@"code_type":@"register", @"phonenumber":  phoneNumber, @"target": phoneNumber, @"mobile_code": areaCode}  expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        self.verifyCodeColdDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runVerifyCodeColdDownTimer) userInfo:nil repeats:YES];
        self.verifyCodeCount= 60;
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        vertificationBtn.enabled = YES;
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
    
    if ([self.RegisterAreaTextF.text containsString:@"86"]) {
        
        NSString *china = @"^1\\d{10}$";
        isMatch = [self predicateMatchWithValue:phone  key:china];
        if (!isMatch) errorStr = @"请输入“1”开头的11位数字";
    }
    
    
    if ([self.RegisterAreaTextF.text containsString:@"44"]) {
        
        NSString *english = @"^7\\d{9}$";
        isMatch = [self predicateMatchWithValue:phone  key:english];
        if (!isMatch) errorStr = @"请输入“7”开头的10位数字";
        
    }
    
    
    if ([self.RegisterAreaTextF.text containsString:@"60"] ) {
        
        NSString *maraxia = @"^\\d{7,9}$";
        isMatch = [self predicateMatchWithValue:phone  key:maraxia];
        if (!isMatch) errorStr = @"手机号码格式错误";
        
    }
    
    
    if (!isMatch)  AlerMessage(errorStr);
    
    return isMatch;
}


//手机号码验证
- (BOOL)predicateMatchWithValue:(NSString *)value key:(NSString *)key{
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", key];
    
    BOOL match =  [pre evaluateWithObject:value];
    
    
    return match;
}


#pragma mark : 验证码倒计时

- (void)runVerifyCodeColdDownTimer {

    self.verifyCodeCount--;
    
    if (self.verifyCodeCount > 0) {
 
        [self.VerificationBtn setTitle:[NSString stringWithFormat:@"%@%d%@",GDLocalizedString(@"LoginVC-0013"), self.verifyCodeCount,GDLocalizedString(@"LoginVC-0014")] forState:UIControlStateNormal];
          
    } else {
        
        self.VerificationBtn.enabled = YES;
        [self.VerificationBtn setTitle:@"重新发送"  forState:UIControlStateNormal];
        [self.verifyCodeColdDownTimer invalidate];
        _verifyCodeColdDownTimer = nil;
        
    }
}

#pragma mark : 提交注册信息

- (IBAction)RegisterButtonCommitPressed:(id)sender {
    
    
    if (![self checkNetworkState])return;
    
    
    if (![self verifyRegisterFields]) return;
    
    
    NSString *areaCode;
    
    if ([self.RegisterAreaTextF.text containsString:@"44"]) {
        
        areaCode = @"44";
        
    }else if( [self.RegisterAreaTextF.text containsString:@"60"]){
        
        areaCode = @"60";
        
    }else{
        
        areaCode = @"86";
    }
    
    [self
     startAPIRequestWithSelector:kAPISelectorRegister
     parameters:@{@"mobile_code":areaCode,@"username":self.RegisterPhoneTextF.text, @"password":self.RegisterPasswdTextF.text, @"vcode": @{@"code":self.RegisterVerTextF.text}}
     success:^(NSInteger statusCode, NSDictionary *response) {
       
         [[AppDelegate sharedDelegate] loginWithAccessToken:response[@"access_token"]];
         [MobClick event:@"myoffer_Register"];
         [MobClick profileSignInWithPUID:response[@"access_token"]];/*友盟统计记录用户账号*/

         KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
         [hud applySuccessStyle];
         [hud hideAnimated:YES afterDelay:2];
         [hud setHiddenBlock:^(KDProgressHUD *hud) {
             [self dismiss];
         }]; 
     }];

}

//返回注册登录第一页
- (IBAction)backButtonPressed:(KDEasyTouchButton *)sender {
  
    [self LoginViewShow:NO sender:sender];
    
}
//退出登录页面
- (IBAction)popButtonPressed:(KDEasyTouchButton *)sender {
    
    [self dismiss];
}

// 点击进入服务条款页面
- (IBAction)ServiceButtonPressed:(id)sender {
  
      WebViewController  *service =[[WebViewController alloc] init];
      service.path =  [NSString stringWithFormat:@"%@docs/%@/web-agreement.html",DOMAINURL,GDLocalizedString(@"ch_Language")];
      [self.navigationController pushViewController:service animated:YES];
    
}

#pragma mark ——— UIPickerViewDataSource, UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.AreaArr.count;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return self.AreaArr[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
      self.RegisterAreaTextF.text = self.AreaArr[row];
    
}

#pragma mark ——— UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
     if (textField == self.LoginPhoneNumberTextF) {
        
        [self.LoginPasswdTextF becomeFirstResponder];
        
    }else if (textField == self.LoginPasswdTextF)
    {
        [self LoginButtonCommit:nil];
        
    }else if (textField == self.RegisterPasswdTextF)
    {
        [self RegisterButtonCommitPressed:nil];

    }
 
    
    return YES;
}


//绑定手机号    当用户没有电话时发出通知，让用户填写手机号
- (void)caseBangding{
    
    [self.navigationController pushViewController:[[BangViewController alloc] init] animated:YES];
}



// 点击忘记密码
- (IBAction)ForgetPasswdButtonPressed:(id)sender {
    
    [self.navigationController pushViewController:[[NewForgetPasswdViewController alloc] initWithNibName:@"NewForgetPasswdViewController" bundle:nil] animated:YES];
    
}

// 切换按钮的状态   密码输入框是否显示明文
- (IBAction)showPassword:(UIButton *)sender {

    sender.selected = !sender.selected;
    
    self.RegisterPasswdTextF.secureTextEntry = !self.RegisterPasswdTextF.secureTextEntry;
    NSString *imageName = sender.selected ? @"showpassword" : @"hidepassword";
    [sender setImage:XImage(imageName) forState:UIControlStateNormal];
    
}


//监听登录密码输入位数
- (void)loginPasswordValueChange:(UITextField *)textField{

    if (textField.text.length > 16){
    
        textField.text = [textField.text substringWithRange:NSMakeRange(0, 16)];
    }
 }


//注册相关字段验证
- (BOOL)verifyRegisterFields {
    

    BOOL phoneMatch = [self verifyWithPhone: self.RegisterPhoneTextF.text];
    
    if (!phoneMatch) {
     
        return NO;
    }
    
    if (self.RegisterVerTextF.text.length == 0) {
        
        AlerMessage(@"验证码不能为空");
        
        return  NO;
    }
    
    
    if (self.RegisterPasswdTextF.text.length == 0) {
        
        AlerMessage(self.RegisterPasswdTextF.placeholder);

        return  NO;
    }
    
    
    if(self.RegisterPasswdTextF.text.length < 6 || self.RegisterPasswdTextF.text.length >16)
    {   //@"密码长度不小于6个字符"
        
        AlerMessage(GDLocalizedString(@"Person-passwd"));
  
        return  NO;
    }
    
    
    return YES;
}

//选择登录页面，用于用户填写手机号、或绑定原有账号
- (void)caseLoginSelection:(NSDictionary *)userInfo{

    LoginSelectViewController *selectVC =[[LoginSelectViewController alloc] initWithNibName:@"LoginSelectViewController" bundle:[NSBundle mainBundle]];
    selectVC.parameter = userInfo;
    [self.navigationController pushViewController:selectVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    KDClassLog(@"登录 dealloc");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end


