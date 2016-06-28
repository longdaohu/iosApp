//
//  LoginSelectViewController.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/25.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "LoginSelectViewController.h"
#import "YourBindView.h"
#import "YourPhoneView.h"

@interface LoginSelectViewController ()<YourBindViewDelegate,YourPhoneViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
//欢迎信息
@property (weak, nonatomic) IBOutlet UILabel *HelloLab;
//提示信息
@property (weak, nonatomic) IBOutlet UILabel *PromptLab;
//选择绑定
@property (weak, nonatomic) IBOutlet KDEasyTouchButton *BindItemBtn;
//选择直接进入
@property (weak, nonatomic) IBOutlet KDEasyTouchButton *myOfferItemBtn;
//绑定编辑框
@property(nonatomic,strong)YourBindView *BindView;
//当出现编辑框时遮盖
@property(nonatomic,strong)UIButton *cover;
//直接进入编辑框 ———— 收集用户手机号
@property(nonatomic,strong)YourPhoneView *PhoneView;
//直接进入编辑框 ———— 地区编号用pickerView选择
@property(nonatomic,strong)UIPickerView *countryPicker;
//直接进入编辑框 ———— 地区编号数组
@property(nonatomic,strong)NSArray *Areas;
//直接进入编辑框 ———— 倒计时Timer
@property(nonatomic,strong)NSTimer *verifyCodeColdDownTimer;
//直接进入编辑框 ———— 倒计时
@property(nonatomic,assign)int verifyCodeColdDownCount;
//记住新创建用户返回数据
@property(nonatomic,strong)NSDictionary *LoginResponse;

@end

@implementation LoginSelectViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self changeLanguage];
    
    [self makeUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [MobClick beginLogPageView:@"page三方登录绑定账号"];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

 
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page三方登录绑定账号"];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}



//国际化语言
-(void)changeLanguage
{
    NSString *pingtai =  self.parameter[@"provider"];
    
    if ([pingtai isEqualToString:@"qq"]) {
        self.title = GDLocalizedString(@"bangdingVC-QQtitle");
        self.HelloLab.text = GDLocalizedString(@"bangdingVC-helloQQ");
        
    }else if ([pingtai isEqualToString:@"weibo"]) {
        
        self.title = GDLocalizedString(@"bangdingVC-weiboTitle");//@"微信登录";
        self.HelloLab.text = GDLocalizedString(@"bangdingVC-helloWB");//@"您好，微信用户";
    }
    else
    {
        self.title = GDLocalizedString(@"bangdingVC-title");//@"微信登录";
        self.HelloLab.text = GDLocalizedString(@"bangdingVC-hello");//@"您好，微信用户";
    }
    
    [self.myOfferItemBtn setTitle:GDLocalizedString(@"bangdingVC-login") forState:UIControlStateNormal]; //@"进入myOffer"
    [self.BindItemBtn setTitle:GDLocalizedString(@"bangdingVC-bangding")forState:UIControlStateNormal];//@"绑定myOffer账号"
    self.PromptLab.text =GDLocalizedString(@"bangdingVC-noti");//@"如果您已注册，请绑定myOffer账号";
    
}


-(UIPickerView *)countryPicker
{
    if (!_countryPicker) {
        
        _countryPicker =[[UIPickerView alloc] init];
        _countryPicker.dataSource = self;
        _countryPicker.delegate = self;
    }
    return _countryPicker;
}

-(NSArray *)Areas
{
    if (!_Areas) {
        
        _Areas = @[GDLocalizedString(@"LoginVC-china"),GDLocalizedString(@"LoginVC-english")];//@[@"中国(+86)",@"英国(+44)"];
    }
    return _Areas;
}


-(void)makeUI
{

    [self makeOther];

    [self makeBindView];
    
    [self makePhoneView];
    
    [self addNotificationCenter];

    
}
-(void)addNotificationCenter
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)makeOther
{
    self.BindItemBtn.layer.cornerRadius = 2;
    self.myOfferItemBtn.layer.cornerRadius = 2;
    self.myOfferItemBtn.layer.borderColor = XCOLOR_WHITE.CGColor;
    self.myOfferItemBtn.layer.borderWidth = 1;
    
    self.cover =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, XScreenWidth, XScreenHeight)];
    self.cover.backgroundColor = XCOLOR_BLACK;
    self.cover.alpha = 0;
    [self.view addSubview:self.cover];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
   
}
-(void)makeBindView
{
    self.BindView =[[YourBindView alloc] initWithFrame:CGRectMake(0, XScreenHeight,XScreenWidth, 210)];
    self.BindView.delegate = self;
    [self.view addSubview:self.BindView];
}
-(void)makePhoneView
{
    self.PhoneView =[[YourPhoneView alloc] initWithFrame:CGRectMake(0, XScreenHeight,XScreenWidth, 260)];
    self.PhoneView.countryCode.inputView = self.countryPicker;
     self.PhoneView.delegate = self;
    [self.view addSubview:self.PhoneView];

}


- (IBAction)bindItemClick:(UIButton *)sender {
 
    if (10 == sender.tag) {
        //绑定已有账户
        [self bindViewHiden:NO];
       
        return;
    }
    
    
    // 直接创建新用户登录
    if (LOGIN) {
        
        [self LoginSuccessWithResponse:self.LoginResponse];
        
    }else{
  
        [self  startAPIRequestUsingCacheWithSelector:kAPISelectorNewAndLogin parameters:self.parameter success:^(NSInteger statusCode, id response) {
         
            self.LoginResponse = (NSDictionary *)response;
          
            [self LoginSuccessWithResponse:response];
            
        }];
        
    }
}

// 直接创建新用户登录
-(void)LoginSuccessWithResponse:(NSDictionary *)response
{
    
    [APService setAlias:response[@"jpush_alias"] callbackSelector:nil object:nil];//Jpush设置登录用户别名
    
    [[AppDelegate sharedDelegate] loginWithAccessToken:response[@"access_token"]];
    
    [MobClick profileSignInWithPUID:response[@"access_token"]];/*友盟统计记录用户账号*/
    
    [MobClick event:@"otherUserLogin"];
    
    [MobClick event:@"other_Register"];
    
    //当用户没有电话时发出通知，让用户填写手机号
    NSString *phone =response[@"phonenumber"];
    
    if (!phone) {
        
         [self PhoneViewHiden:NO anddismiss:NO];
        
     }else{
         
         [self.navigationController dismissViewControllerAnimated:YES completion:nil];
         
     }
    
    
}
//填写用户资料的显示或隐藏
-(void)PhoneViewHiden:(BOOL)hiden anddismiss:(BOOL)dismiss
{
    
    if (dismiss) {
        
        [self back];
        
        return;
    }
    
 
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        CGRect  frame =self.PhoneView.frame;
        
        frame.origin.y = hiden ? XScreenHeight :CGRectGetMaxY(self.HelloLab.frame) + 40;
        
        self.PhoneView.frame = frame;
        
        self.cover.alpha = hiden ? 0 : 0.7;
        
    } completion:^(BOOL finished) {
        
//        if (hiden && dismiss) {
//            
//            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//            
//        }
    }];
    
}


#pragma mark ————————  YourPhoneViewDelegate
-(void)YourPhoneView:(YourPhoneView *)PhoneView WithButtonItem:(UIButton *)sender
{
    if (11 == sender.tag) {
        //如果点击取消
        [self PhoneViewHiden:NO anddismiss:YES];
        
    }else if(10 == sender.tag)
    {
        
        [self sendVerificationCode];
        
    }else{
        
        [self CommitVerifyCode];
        
    }
    
}

#pragma mark 提交验证码
-(void)CommitVerifyCode
{
    
    if (![self checkPhoneTextField]) {
        
        return ;
    }
    
    if (self.PhoneView.VerifyTF.text.length==0) {
        AlerMessage(GDLocalizedString(@"LoginVC-007"));
        return ;
    }
    

    
    NSMutableDictionary *infoParameters =[NSMutableDictionary dictionary];
    [infoParameters setValue:self.PhoneView.countryCode.text forKey:@"mobile_code"];
    [infoParameters setValue:self.PhoneView.PhoneTF.text forKey:@"phonenumber"];
    [infoParameters setValue:@{@"code":self.PhoneView.VerifyTF.text} forKey:@"vcode"];
    
    [self startAPIRequestWithSelector:@"POST api/account/updatephonenumber"
                           parameters:@{@"accountInfo":infoParameters}
                              success:^(NSInteger statusCode, id response) {
                                  
                                  [self PhoneViewHiden:YES anddismiss:YES];
                                  
                              }];
    
}




#pragma mark 发送验证码
-(void)sendVerificationCode
{
    
    if (![self checkPhoneTextField]) {
        
        return ;
    }
    
    NSString *AreaNumber =  [ self.PhoneView.countryCode.text containsString:@"44"] ? @"44":@"86";
 
    NSString *phoneNumber = self.PhoneView.PhoneTF.text;
    
    self.PhoneView.SendCodeBtn.enabled = NO;

    [self startAPIRequestWithSelector:kAPISelectorSendVerifyCode  parameters:@{@"code_type":@"phone", @"phonenumber":  phoneNumber, @"target": phoneNumber, @"mobile_code": AreaNumber}   expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        self.verifyCodeColdDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runVerifyCodeColdDown) userInfo:nil repeats:YES];
      
        self.verifyCodeColdDownCount = 60;
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
      
        self.PhoneView.SendCodeBtn.enabled = YES;
        
    }];
    
}

//@"验证码倒计时"
- (void)runVerifyCodeColdDown {
    
    self.verifyCodeColdDownCount--;
    
    if (self.verifyCodeColdDownCount > 0) {
       
        [self.PhoneView.SendCodeBtn setTitle:[NSString stringWithFormat:@"%@%d%@",GDLocalizedString(@"LoginVC-0013"), self.verifyCodeColdDownCount,GDLocalizedString(@"LoginVC-0014")] forState:UIControlStateNormal];
   
    } else {
     
        self.PhoneView.SendCodeBtn.enabled = YES;
       
        [self.PhoneView.SendCodeBtn setTitle:GDLocalizedString(@"LoginVC-008")   forState:UIControlStateNormal];
       
        [self.verifyCodeColdDownTimer invalidate];
       
        _verifyCodeColdDownTimer = nil;
    }
}

//验证手机号码是否合理
-(BOOL)checkPhoneTextField
{
    //"中国";
    if ([self.PhoneView.countryCode.text containsString:@"86"] && self.PhoneView.PhoneTF.text.length != 11) {
        
        AlerMessage(GDLocalizedString(@"LoginVC-PhoneNumberError"));
        
        return NO;
        
    }else if ([self.PhoneView.countryCode.text containsString:@"44"] && self.PhoneView.PhoneTF.text.length != 10) {
        //"英国";
        AlerMessage(GDLocalizedString(@"LoginVC-EnglandNumberError") );
      
        return NO;
        
    }else{
        
        return YES;
    }
}


#pragma mark —————— YourBindViewDelegate  绑定编辑框代理处理
-(void)YourBindView:(YourBindView *)bindView didClick:(UIButton *)sender
{
    
    if (11 == sender.tag) {
        
         [self commitBangding];
        
    }else{
        
         [self bindViewHiden:YES];
    }
}


#pragma mark ———————— 提交绑定
-(void)commitBangding
{
    
    if (self.BindView.Bind_PhoneFT.text.length == 0) {
        
         AlerMessage(self.BindView.Bind_PhoneFT.placeholder );
        
         return;
    }
    
    if (self.BindView.Bind_PastWordFT.text.length == 0) {
     
        AlerMessage(self.BindView.Bind_PastWordFT.placeholder);

         return;
    }
    //  1、 先用填填写的账号登录
    [self
     startAPIRequestWithSelector:kAPISelectorLogin
     parameters:@{@"username":self.BindView.Bind_PhoneFT.text, @"password": self.BindView.Bind_PastWordFT.text}
     success:^(NSInteger statusCode, NSDictionary *response) {
         
         [APService setAlias:response[@"jpush_alias"] callbackSelector:nil object:nil];//Jpush设置登录用户别名
         
         [[AppDelegate sharedDelegate] loginWithAccessToken:response[@"access_token"]];
         
         [self gotoBangDing:response[@"access_token"]];
         
         [MobClick event:@"other_Register"];

         [MobClick event:@"otherUserLogin"];
         
     }];
    
}

//2、已有账号登录情况下，再绑定WEIXIN账号
-(void)gotoBangDing:(NSString *)token
{
    [self
     startAPIRequestWithSelector:kAPISelectorBind parameters:self.parameter success:^(NSInteger statusCode, id response) {
         
         KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
         [hud applySuccessStyle];
         [hud hideAnimated:YES afterDelay:2];
         [hud setHiddenBlock:^(KDProgressHUD *hud) {

             [self.navigationController dismissViewControllerAnimated:YES completion:nil];
             
         }];
     }];
}


//隐藏绑定View
-(void)bindViewHiden:(BOOL)Hiden
{
     [self.view endEditing:YES];
    
    
    [UIView animateWithDuration:0.25 animations:^{
        
        CGRect newFrame = self.BindView.frame;
        newFrame.origin.y = Hiden ?  XScreenHeight : CGRectGetMaxY(self.HelloLab.frame) + 40;
        self.BindView.frame = newFrame;
        self.cover.alpha = Hiden ? 0 : 0.7;
        
    } completion:^(BOOL finished) {
        
        self.BindView.Bind_PhoneFT.text = @"";
        self.BindView.Bind_PastWordFT.text =  @"";
        
    }];
    
}




#pragma mark ——————- 键盘处理
- (void)keyboardWillShow:(NSNotification *)aNotification {
    
    [self moveTextViewForKeyboard:aNotification up:YES];
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    
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
    
    UIView  *moveView  = self.PhoneView.frame.origin.y < XScreenHeight ? self.PhoneView : self.BindView;
    
//    NSLog(@"-------- %lf   %lf",CGRectGetMaxY(moveView.frame),(XScreenHeight - keyboardEndFrame.size.height));
    
    if (up) {
        
          moveView.center = CGPointMake(XScreenWidth / 2.0f, (XScreenHeight - keyboardEndFrame.size.height) / 2.0f);
        
    } else {
        
        moveView.center = CGPointMake(XScreenWidth / 2.0f, XScreenHeight*2/3);
    }
    
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
}


#pragma mark ------ UIPickerViewDataSource, UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.Areas.count;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return self.Areas[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.PhoneView.countryCode.text = self.Areas[row];
    
}


-(void)back{

    if(LOGIN){
        
        [[AppDelegate sharedDelegate] logout];
        
        [MobClick profileSignOff];/*友盟第三方统计功能统计退出*/
        
        [APService setAlias:@"" callbackSelector:nil object:nil];  //设置Jpush用户所用别名为空
        
        [self startAPIRequestWithSelector:kAPISelectorLogout parameters:nil showHUD:YES success:^(NSInteger statusCode, id response) {
         
            [self.navigationController popViewControllerAnimated:YES];
            
         }];
        
        
    }else{
        
  
        [self.navigationController popViewControllerAnimated:YES];
        
    }

}

-(void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
     KDClassLog(@"LoginSelectionViewController  dealloc");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
