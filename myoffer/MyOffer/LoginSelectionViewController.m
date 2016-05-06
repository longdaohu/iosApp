//
//  LoginSelectionViewController.m
//  MyOffer
//
//  Created by xuewuguojie on 15/9/29.
//  Copyright © 2015年 UVIC. All rights reserved.
//
/*
 myOffer
 AppID：wx6ef4fb49781fdd34
 AppSecret：776f9dafbfe76ffb6e20ff5a8e4c4177
 */

#define  WeixinAppID @"wx6ef4fb49781fdd34"
#define  WeixinAppSecret @"776f9dafbfe76ffb6e20ff5a8e4c4177"
#import "FXBlurView.h"
#import "LoginSelectionViewController.h"
#import "UMSocial.h"


@interface LoginSelectionViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet KDEasyTouchButton *loginButton;
@property (strong, nonatomic) IBOutlet UIView *bindView;
@property (weak, nonatomic) IBOutlet UITextField *passwdFT;
@property (weak, nonatomic) IBOutlet UITextField *phoneFT;
//@property (weak, nonatomic) IBOutlet FXBlurView *blurView;
@property (weak, nonatomic) IBOutlet KDEasyTouchButton *bangButton;
@property (weak, nonatomic) IBOutlet UILabel *notiLabel;
@property (weak, nonatomic) IBOutlet UILabel *helloLabel;

@end

@implementation LoginSelectionViewController
-(void)changeLanguage
{

    NSString *pingtai =  self.parameter[@"provider"];
    if ([pingtai isEqualToString:@"qq"]) {
        self.title = GDLocalizedString(@"bangdingVC-QQtitle");
        self.helloLabel.text = GDLocalizedString(@"bangdingVC-helloQQ");
    }else if ([pingtai isEqualToString:@"weibo"]) {

        self.title = GDLocalizedString(@"bangdingVC-weiboTitle");//@"微信登录";
        self.helloLabel.text = GDLocalizedString(@"bangdingVC-helloWB");//@"您好，微信用户";
    }
    else
    {
        self.title = GDLocalizedString(@"bangdingVC-title");//@"微信登录";
        self.helloLabel.text = GDLocalizedString(@"bangdingVC-hello");//@"您好，微信用户";
    }
    
    [self.loginButton setTitle:GDLocalizedString(@"bangdingVC-login") forState:UIControlStateNormal]; //@"进入myOffer"
    [self.bangButton setTitle:GDLocalizedString(@"bangdingVC-bangding")forState:UIControlStateNormal];//@"绑定myOffer账号"
     self.notiLabel.text =GDLocalizedString(@"bangdingVC-noti");//@"如果您已注册，请绑定myOffer账号";

}

-(void)makeUI
{
    self.notiLabel.adjustsFontSizeToFitWidth = YES;
    self.loginButton.layer.cornerRadius = 2;
    self.loginButton.adjustAllRectWhenHighlighted = YES;
    self.loginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.loginButton.layer.borderWidth = 2;
    self.bindView.frame = CGRectMake(0, APPSIZE.height-200, APPSIZE.width, 200);
    [self.view addSubview:self.bindView];
    self.bindView.alpha = 0;
    
    self.passwdFT.delegate = self;
    self.phoneFT.delegate = self;
    
    //用于背景图片虚化
    //    self.blurView.dynamic =  NO;
    //    [self.blurView setTintColor:nil];
    //    [self.blurView setIterations:3];
    //    [self.blurView setBlurRadius:10];
    //    self.blurView.alpha = 0;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //登录绑定页面
    [self changeLanguage];
    [self makeUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (IBAction)bangDing:(UIButton *)sender {
    //用于显示背景模糊效果
//      self.blurView.alpha = 1;
      [UIView animateWithDuration:0.5 animations:^{
        CGRect  frame =self.bindView.frame;
        frame.origin.y = 200;
        self.bindView.frame = frame;
        self.bindView.alpha = 1;
    }];
}

//直接创建新用户登录
- (IBAction)weiZhuChe:(UIButton *)sender {
 
    NSString  *testPath =  @"POST api/account/oauth/newandlogin";
  
  [self  startAPIRequestUsingCacheWithSelector:testPath parameters:self.parameter success:^(NSInteger statusCode, id response) {
               NSString *token = [response valueForKey:@"access_token"];
              [[AppDelegate sharedDelegate] loginWithAccessToken:token];
              [self  whenUserLoginDismiss];
      
    }];
    
}

- (IBAction)commitBangding:(id)sender {
  
    [self commitBangding];
    
}
-(void)commitBangding
{
   
        if (self.phoneFT.text.length == 0) {
            [KDAlertView showMessage:self.phoneFT.placeholder cancelButtonTitle:GDLocalizedString(@"NetRequest-OK")];//@"好的"];
            return;
        }
    
        if (self.passwdFT.text.length == 0) {
            [KDAlertView showMessage:self.passwdFT.placeholder cancelButtonTitle:GDLocalizedString(@"NetRequest-OK")];// Noti-hao@"好的"];
            return;
        }
        //  1、 先用填填写的账号登录
        [self
         startAPIRequestWithSelector:kAPISelectorLogin
         parameters:@{@"username":self.phoneFT.text, @"password": self.passwdFT.text}
         success:^(NSInteger statusCode, NSDictionary *response) {
              [[AppDelegate sharedDelegate] loginWithAccessToken:response[@"access_token"]];
              [self gotoBangDing:response[@"access_token"]];
           }];
    
}
//2、已有账号登录情况下，再绑定WEIXIN账号
-(void)gotoBangDing:(NSString *)token
{
      [self
     startAPIRequestWithSelector:@"POST api/account/bind" parameters:self.parameter success:^(NSInteger statusCode, id response) {

         KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
                 [hud applySuccessStyle];
                 [hud hideAnimated:YES afterDelay:2];
                 [hud setHiddenBlock:^(KDProgressHUD *hud) {
                     
                     [self whenUserLoginDismiss];
                     
                 }];
     }];
 }

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self commitBangding];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

  //用于判断用户是否改变
-(void)whenUserLoginDismiss
{
    NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
    NSString *displayname =[ud valueForKey:@"userDisplayName"];
    if (![displayname isEqualToString: self.phoneFT.text] ) {
        
        [ud setValue:@"changeYES" forKey:@"userChange"];
        
    }else{
        
        [ud setValue:@"changeNO" forKey:@"userChange"];
        
    }
    
    [ud  setValue:self.phoneFT.text  forKey:@"userDisplayName"];
    
    [ud synchronize];
    
     [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

 @end
