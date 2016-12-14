//
//  LoginSelectViewController.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/25.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "LoginSelectViewController.h"
#import "YourBindView.h"
#import "BangViewController.h"

@interface LoginSelectViewController ()<YourBindViewDelegate>
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
    
    
}





-(void)makeUI
{

    [self makeOther];

    [self makeBindView];
    
    
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
    
    self.cover =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, XSCREEN_HEIGHT)];
    self.cover.backgroundColor = XCOLOR_BLACK;
    self.cover.alpha = 0;
    [self.view addSubview:self.cover];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow"] style:UIBarButtonItemStyleDone target:self action:@selector(caseBack)];
   
}
-(void)makeBindView
{
    self.BindView =[[YourBindView alloc] initWithFrame:CGRectMake(0, XSCREEN_HEIGHT,XSCREEN_WIDTH, 210)];
    self.BindView.delegate = self;
    [self.view addSubview:self.BindView];
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
    !response[@"phonenumber"]? [self caseBangding] :  [self dismiss];

    
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
        newFrame.origin.y = Hiden ?  XSCREEN_HEIGHT : CGRectGetMaxY(self.HelloLab.frame) + 40;
        self.BindView.frame = newFrame;
        self.cover.alpha = Hiden ? 0 : 0.7;
        
    } completion:^(BOOL finished) {
        
        self.BindView.Bind_PhoneFT.text = @"";
        self.BindView.Bind_PastWordFT.text =  @"";
        
    }];
    
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
    
    
    if (up) {
        
          self.BindView.center = CGPointMake(XSCREEN_WIDTH / 2.0f, (XSCREEN_HEIGHT - keyboardEndFrame.size.height) / 2.0f);
        
    } else {
        
        self.BindView.center = CGPointMake(XSCREEN_WIDTH / 2.0f, XSCREEN_HEIGHT*2/3);
    }
    
    [self.view layoutSubviews];
    
    [UIView commitAnimations];
}


-(void)caseBack{

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


- (void)caseBangding{
    
    [self.navigationController pushViewController:[[BangViewController alloc] init] animated:YES];
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
