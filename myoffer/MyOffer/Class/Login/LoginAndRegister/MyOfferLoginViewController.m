//
//  MyOfferLoginViewController.m
//  myOffer
//
//  Created by xuewuguojie on 2017/5/25.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "MyOfferLoginViewController.h"
#import "WYLXGroup.h"
#import "MyOfferInputView.h"
#import "LoginSelectViewController.h"
#import "BangViewController.h"
#import "ForgetPWViewController.h"

typedef NS_ENUM(NSInteger,otherLoginType){

    otherLoginTypeWX = 0,
    otherLoginTypeWB,
    otherLoginTypeQQ
};

@interface MyOfferLoginViewController ()<UIScrollViewDelegate,MyOfferInputViewDelegate>

@property(nonatomic,strong)UIButton *dismissBtn;
@property(nonatomic,strong)UIView *baseView;
@property(nonatomic,strong)UIImageView *logoView;
@property(nonatomic,strong)UIScrollView *bgView;
@property(nonatomic,strong)UIView *loginBgView;
@property(nonatomic,strong)UIView *registbgView;
@property(nonatomic,strong)NSArray *loginArr;
@property(nonatomic,strong)UIView *loginCellbgView;
@property(nonatomic,strong)UIView *registCellbgView;
@property(nonatomic,strong)NSArray *registArr;
@property(nonatomic,strong)UIButton *loginBtn;
@property(nonatomic,strong)UIButton *registBtn;
@property(nonatomic,strong)UIButton *protocolBtn;
@property(nonatomic,strong)UIButton *forgetBtn;
@property(nonatomic,strong)UIButton *toLoginBtn;
@property(nonatomic,strong)UIButton *toRegistBtn;
@end

@implementation MyOfferLoginViewController
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


- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self makeUI];
}

- (NSArray *)loginArr{

    if (!_loginArr) {
        
        WYLXGroup *login_Phone = [WYLXGroup groupWithType:EditTypePhone title:@"手机/邮箱" placeHolder:@"请输入手机号/邮箱" content:nil groupKey:@"username" spod:false cellType:CellGroupTypeView];
        WYLXGroup *login_passwd = [WYLXGroup groupWithType:EditTypePasswd title:@"密码" placeHolder:@"请输入密码" content:nil groupKey:@"password" spod:false cellType:CellGroupTypeView];

        _loginArr = @[login_Phone,login_passwd];
        
    }
    return  _loginArr;
}

- (NSArray *)registArr{
    
    if (!_registArr) {
        
        WYLXGroup *regist_Phone = [WYLXGroup groupWithType:EditTypeRegistPhone title:@"手机" placeHolder:@"请输入手机号" content:nil groupKey:@"username" spod:false cellType:CellGroupTypeView];
        WYLXGroup *regist_yzm = [WYLXGroup groupWithType:EditTypeVerificationCode title:@"验证码" placeHolder:@"请输入验证码" content:nil groupKey:@"vcode" spod:false cellType:CellGroupTypeView];

        WYLXGroup *login_passwd = [WYLXGroup groupWithType:EditTypePasswd title:@"密码" placeHolder:@"请输入6-16新密码" content:nil groupKey:@"password" spod:false  cellType:CellGroupTypeView];

        
        _registArr = @[regist_Phone,regist_yzm,login_passwd];
        
    }
    return  _registArr;
}


- (void)addSubView:(UIView *)subView  frame:(CGRect)frame toSuperView:(UIView *)superView{
   
      subView.frame = frame;
     [superView addSubview:subView];
}


- (UIButton *)buttonWithFrame:(CGRect)frame  title:(NSString *)title fontSize:(CGFloat)size titleColor:(UIColor *)color imageName:(NSString *)imageName  Action:(nonnull SEL)action{
   
    UIButton *sender = [[UIButton alloc] initWithFrame:frame];
  
    [sender setTitle:(title ? title : @"") forState:UIControlStateNormal];

    [sender setTitleColor:(color ? color : XCOLOR_TITLE) forState:UIControlStateNormal];
    
    [sender  setImage:XImage(imageName) forState:UIControlStateNormal];
    
    [sender addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];

    sender.titleLabel.font = XFONT(size);
    
    return sender;
}

- (void)makeUI{
    
    //logo图片
    self.logoView = [[UIImageView alloc] initWithImage:XImage(@"login_top")];
    CGFloat logo_X = 0;
    CGFloat logo_Y = 0;
    CGFloat logo_W = XSCREEN_WIDTH;
    CGFloat logo_H =  logo_W * self.logoView.image.size.height/self.logoView.image.size.width;
    [self addSubView:self.logoView  frame:CGRectMake(logo_X, logo_Y, logo_W, logo_H) toSuperView:self.view];

    //底部容器
    self.baseView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self addSubView:self.baseView  frame:self.view.bounds toSuperView:self.view];
    
    //底部 UIScrollView
    CGFloat bg_X = 0;
    CGFloat bg_Y = 0;
    CGFloat bg_W = XSCREEN_WIDTH;
    CGFloat bg_H = XSCREEN_HEIGHT - bg_Y;
    UIScrollView *bgView = [[UIScrollView alloc] init];
    self.bgView = bgView;
    bgView.scrollEnabled = NO;
    bgView.pagingEnabled = YES;
    bgView.bounces = NO;
    bgView.delegate = self;
    [self addSubView:bgView  frame:CGRectMake(bg_X, bg_Y, bg_W, bg_H) toSuperView:self.baseView];
    

    //退出登录按钮
    CGFloat dis_X = 14;
    CGFloat dis_W = 40;
    CGFloat dis_H =  dis_W;
    CGFloat dis_Y = XNAV_HEIGHT - dis_H;
    self.dismissBtn = [self buttonWithFrame:CGRectMake(dis_X, dis_Y, dis_W, dis_H) title:nil fontSize:1 titleColor:nil imageName:@"close_button" Action:@selector(dismiss:)];
    [self.view addSubview:self.dismissBtn];
    
    //登录板块
    CGFloat login_bg_X = 0;
    CGFloat login_bg_Y = logo_H;
    CGFloat login_bg_W = bg_W;
    CGFloat login_bg_H = bg_H - login_bg_Y;
    UIView *loginBg = [[UIView alloc] init];
    self.loginBgView = loginBg;
    loginBg.backgroundColor = XCOLOR_WHITE;
    [self addSubView:loginBg  frame:CGRectMake(login_bg_X, login_bg_Y, login_bg_W, login_bg_H) toSuperView:self.bgView];

    //添加点击事件，点击时收起键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHiden)];
    [loginBg addGestureRecognizer:tap];
    
    //登录板块子项
    [self makeLoginView];
 
    //注册板块
    CGFloat regist_bg_X = bg_W;
    CGFloat regist_bg_Y = login_bg_Y;
    CGFloat regist_bg_W = bg_W;
    CGFloat regist_bg_H = login_bg_H;
    UIView *registBg = [[UIView alloc] init];
    self.registbgView = registBg;
    registBg.backgroundColor = XCOLOR_WHITE;
    [self addSubView:registBg  frame:CGRectMake(regist_bg_X, regist_bg_Y, regist_bg_W, regist_bg_H) toSuperView:self.bgView];

    
    //添加点击事件，点击时收起键盘
    UITapGestureRecognizer *tap_B = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHiden)];
    [registBg addGestureRecognizer:tap_B];
    
    //注册板块子项
    [self makeRegistView];
    

    self.bgView.contentSize = CGSizeMake(self.bgView.subviews.count * bg_W, 0);
    
    [self makeNotificationCenter];
    
    
    //设置是否显示注册页面
    if (self.index > 0) [self toRegistBtnOnClick:self.toRegistBtn];
    
    
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



- (void)makeLoginView{

    CGFloat cell_W = self.loginBgView.bounds.size.width;
    CGFloat cell_X = 0 ;
    CGFloat cell_Y = 0 ;
    CGFloat cell_H = 0 ;
    
    //登录输入项容器
    CGFloat cell_bg_X = 0;
    CGFloat cell_bg_Y = 0;
    CGFloat cell_bg_W = cell_W;
    UIView *cellBgView = [[UIView alloc] init];
    self.loginCellbgView = cellBgView;
    [self.loginBgView  addSubview:cellBgView];

    //添加输入框子项
     for (NSInteger index = 0 ; index < self.loginArr.count; index++) {
    
         WYLXGroup *item  = self.loginArr[index];
         cell_H = item.cell_Height;
         cell_Y = index * cell_H;
         MyOfferInputView *cell = [[MyOfferInputView alloc] initWithFrame:CGRectMake(cell_X, cell_Y, cell_W, cell_H)];
         cell.tag = index;
         cell.group = item;
         cell.delegate = self;
         cell.inputTF.returnKeyType = (index == self.loginArr.count -1) ? UIReturnKeyDone  :  UIReturnKeyNext;
         [cellBgView addSubview:cell];
    }
    
    CGFloat cell_bg_H = cell_H + cell_Y;
    cellBgView.frame = CGRectMake(cell_bg_X, cell_bg_Y, cell_bg_W, cell_bg_H);
    
    //忘记密码
    self.forgetBtn = [self buttonWithFrame:CGRectZero title:@"忘记密码" fontSize:14 titleColor:XCOLOR_TITLE imageName:nil Action:@selector(forgetButtonOnClick:)];
    [self.forgetBtn sizeToFit];
    [self.loginBgView addSubview:self.forgetBtn];

    CGFloat leftMargin = 25;
    CGFloat topMargin = 10;
    
    CGFloat forget_W = self.forgetBtn.mj_w;
    CGFloat forget_X = cell_W - leftMargin - forget_W;
    CGFloat forget_Y = CGRectGetMaxY(cellBgView.frame) + topMargin;
    CGFloat forget_H =  30;
    self.forgetBtn.frame = CGRectMake(forget_X, forget_Y, forget_W, forget_H);
    
    
    //登录按钮
    CGFloat login_X = leftMargin;
    CGFloat login_Y = CGRectGetMaxY(self.forgetBtn.frame) + topMargin + XFONT_SIZE(1) * topMargin;
    CGFloat login_W = cell_W - login_X * 2;
    CGFloat login_H =  50;
    self.loginBtn = [self buttonWithFrame:CGRectMake(login_X, login_Y, login_W, login_H) title:@"登录" fontSize:14 titleColor:XCOLOR_WHITE imageName:nil Action:@selector(loginButtonOnClick:)];
    self.loginBtn.backgroundColor = XCOLOR_RED;
    self.loginBtn.layer.cornerRadius = 4;
    [self.loginBgView addSubview:self.loginBtn];


    //注册myOffer账号
    self.toRegistBtn = [self buttonWithFrame:CGRectZero title:@"注册myOffer账号" fontSize:14 titleColor:XCOLOR_LIGHTBLUE imageName:nil Action:@selector(toRegistBtnOnClick:)];
    [self.toRegistBtn sizeToFit];
    [self.loginBgView addSubview:self.toRegistBtn];
    self.toRegistBtn.titleLabel.textAlignment = NSTextAlignmentCenter;

    CGFloat toRegist_H =  30;
    CGFloat toRegist_Y =  self.loginBgView.mj_h - toRegist_H - 15;
    CGFloat toRegist_W = self.toRegistBtn.mj_w + 50;
    CGFloat toRegist_X = (cell_W - toRegist_W) * 0.5;
    self.toRegistBtn.frame = CGRectMake(toRegist_X, toRegist_Y, toRegist_W, toRegist_H);
   
    
    
    NSArray *icons = @[@"wechat_icon",@"weibo_icon",@"qq_icon"];
    //第三登录按钮
    CGFloat other_W = 40 + XFONT_SIZE(1) * 10;
    CGFloat other_H = other_W;
    CGFloat other_Y = toRegist_Y - other_H - topMargin - XFONT_SIZE(1) * topMargin;
    CGFloat other_X =  (cell_W  -  ((other_W + 20)* icons.count - 20)) * 0.5;
    for (NSInteger index = 0 ; index < icons.count; index++) {
      
         UIButton *otherBtn = [[UIButton alloc] initWithFrame:CGRectMake((other_W + 20) * index + other_X, other_Y, other_W, other_H)];
        [otherBtn setBackgroundImage:XImage(icons[index]) forState:UIControlStateNormal];
        [otherBtn addTarget:self action:@selector(otherBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        otherBtn.tag = index;
        [self.loginBgView addSubview:otherBtn];
        
    }
    
    //使用第三方登录
    UILabel *otherLab = [[UILabel alloc] init];
    otherLab.text = @"使用第三方登录";
    otherLab.font = XFONT(12);
    otherLab.textColor = XCOLOR_SUBTITLE;
    [self.loginBgView addSubview:otherLab];
    [otherLab sizeToFit];
    CGFloat otherLab_Y  = other_Y - otherLab.mj_h - 10;
    otherLab.center = CGPointMake(cell_W * 0.5, otherLab_Y);
    
    //分隔线
    CGFloat line_W = (cell_W - otherLab.mj_w - 80) * 0.5;
    CGFloat line_H = 1;
    CGFloat line_Y = otherLab.center.y;
    CGFloat line_X1 = otherLab.mj_x - line_W - 10;
    CGFloat line_X2 = CGRectGetMaxX(otherLab.frame) + 10;
    for (NSInteger index = 0 ; index < 2; index++) {
        
        CGFloat X = (index == 0) ? line_X1 : line_X2;
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake( X, line_Y, line_W, line_H)];
        line.backgroundColor = XCOLOR_line;
        [self.loginBgView addSubview:line];
    }
    
    
    
}

- (void)makeRegistView{

    
    CGFloat cell_W = self.registbgView.bounds.size.width;
    CGFloat cell_X = 0 ;
    CGFloat cell_Y = 0 ;
    CGFloat cell_H = 0 ;
    
    //注册输入框容器
    CGFloat cell_bg_X = 0;
    CGFloat cell_bg_Y = 0;
    CGFloat cell_bg_W = cell_W;
    UIView *registCellbgView = [[UIView alloc] init];
    self.registCellbgView = registCellbgView;
    [self.registbgView  addSubview:registCellbgView];
    
    for (NSInteger index = 0 ; index < self.registArr.count; index++) {
    
        //注册输入框
        WYLXGroup *item  = self.registArr[index];
        cell_H = item.cell_Height;
        cell_Y = index * cell_H;
        
        MyOfferInputView *cell = [[MyOfferInputView alloc] initWithFrame:CGRectMake(cell_X, cell_Y, cell_W, cell_H)];
        cell.group = item;
        cell.tag = index;
        cell.group = item;
        cell.delegate = self;
        cell.inputTF.returnKeyType = (index == self.registArr.count -1) ? UIReturnKeyDone  :  UIReturnKeyNext;
        [registCellbgView addSubview:cell];
        
    }
    
    CGFloat cell_bg_H = cell_H + cell_Y;
    registCellbgView.frame = CGRectMake(cell_bg_X, cell_bg_Y, cell_bg_W, cell_bg_H);
    
    //注册按钮
    CGFloat regist_X = 25;
    CGFloat regist_Y = CGRectGetMaxY(registCellbgView.frame) + XFONT_SIZE(1) * 10 + 15;
    CGFloat regist_W = cell_W - regist_X * 2;
    CGFloat regist_H =  50;
    self.registBtn = [self buttonWithFrame:CGRectMake(regist_X, regist_Y, regist_W, regist_H)  title:@"注册" fontSize:14 titleColor:XCOLOR_WHITE imageName:nil  Action:@selector(registButtonOnClick:)];
    [self.registbgView addSubview:self.registBtn];
    self.registBtn.layer.cornerRadius = 4;
    self.registBtn.backgroundColor = XCOLOR_RED;

   //注册即表示同意<myoffer用户协议>
    CGFloat pro_X = 0;
    CGFloat pro_H =  30;
    CGFloat pro_Y =  self.registbgView.mj_h - pro_H - 15;
    CGFloat pro_W = cell_W;
    self.protocolBtn = [self buttonWithFrame:CGRectMake(pro_X, pro_Y, pro_W, pro_H)  title:@"注册即表示同意<myoffer用户协议>" fontSize:14 titleColor:XCOLOR_SUBTITLE imageName:nil  Action:@selector(protocolBtnOnClick:)];
    [self.registbgView addSubview:self.protocolBtn];
    self.protocolBtn.titleLabel.textAlignment = NSTextAlignmentCenter;

    //已经加入我们？请登录
   self.toLoginBtn = [self buttonWithFrame:CGRectZero  title:@"已经加入我们？请登录" fontSize:14 titleColor:XCOLOR_LIGHTBLUE imageName:nil  Action:@selector(toLoginBtnOnClick:)];
    [self.registbgView addSubview:self.toLoginBtn];
    [self.toLoginBtn sizeToFit];
    CGFloat to_Login_H =  30;
    CGFloat to_Login_Y = pro_Y - to_Login_H - XFONT_SIZE(1) * 10;
    CGFloat to_Login_W = self.toLoginBtn.mj_w + 50;
    CGFloat to_Login_X = (cell_W - to_Login_W) * 0.5;
    self.toLoginBtn.frame = CGRectMake(to_Login_X, to_Login_Y, to_Login_W, to_Login_H);
    self.toLoginBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    
}

#pragma mark : UIScrollViewDelegate
//scrollView滚动时收起键盘
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
}


#pragma mark : MyOfferInputViewDelegate

- (void)cell:(MyOfferInputView *)cell  textFieldShouldReturn:(UITextField *)textField{
    
    if (cell.inputTF.returnKeyType == UIReturnKeyDone) {
        
        [self.view endEditing:YES];

    }else{
        
        //切换到下一个输入框
        MyOfferInputView *nextCell  = (MyOfferInputView *)self.loginCellbgView.subviews[cell.tag + 1];
        
        [nextCell.inputTF becomeFirstResponder];
    
    }
    
}

- (void)cell:(MyOfferInputView *)cell  shouldChangeCharacters:(NSString *)content{

    
    if (cell.group.groupType == EditTypeRegistPhone) {
        //监听注册框手机号码输入时 验证码按钮状态改变
        MyOfferInputView *nextCell  = (MyOfferInputView *)self.registCellbgView.subviews[cell.tag + 1];
     
        [nextCell changeVertificationCodeButtonEnable:(content.length > 0)];
    }

    
}


- (void)inputAccessoryViewClickWithCell:(MyOfferInputView *)cell{
    
    //键盘辅助工具条监听
    if (cell.group.groupType == EditTypeRegistPhone || cell.group.groupType == EditTypeVerificationCode) {
        
        MyOfferInputView *nextCell  = (MyOfferInputView *)self.registCellbgView.subviews[cell.tag + 1];
        
        [nextCell.inputTF becomeFirstResponder];
        
    }

    
}


//点击发送验证码
- (void)sendVertificationCodeWithCell:(MyOfferInputView *)cell{

    if (cell.group.groupType != EditTypeVerificationCode) return;
 
    MyOfferInputView *phoneCell = self.registCellbgView.subviews[cell.tag - 1];
    
   [phoneCell checKTextFieldWithGroupValue];
    
    BOOL isMatch = [self verifyWithPhone:phoneCell.group.content areaCode:phoneCell.group.areaCode];
    
    if (!isMatch) {  return; }
    
    NSDictionary *parameter = @{
                                @"code_type":@"register",
                                @"phonenumber": phoneCell.group.content,
                                @"target": phoneCell.group.content,
                                @"mobile_code": phoneCell.group.areaCode
                                };
    
    [self startAPIRequestWithSelector:kAPISelectorSendVerifyCode  parameters:parameter  expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        [cell vertificationTimerShow:YES];
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        [cell vertificationTimerShow:NO];

    }];
    
}







#pragma mark : 手机号码验证

- (BOOL)verifyWithPhone:(NSString *)phone areaCode:(NSString *)areaCode{
    
    NSString *errorStr;
    
    BOOL isMatch = YES;
    
    if (0 == phone.length) {
        
        errorStr = @"手机号码不能为空";
        
        isMatch = NO;
    }
    
    if ([areaCode containsString:@"86"]) {
        
        NSString *china = @"^1\\d{10}$";
        isMatch = [self predicateMatchWithValue:phone  key:china];
        if (!isMatch) errorStr = @"请输入“1”开头的11位数字";
    }
    
    
    if ([areaCode containsString:@"44"]) {
        
        NSString *english = @"^7\\d{9}$";
        isMatch = [self predicateMatchWithValue:phone  key:english];
        if (!isMatch) errorStr = @"请输入“7”开头的10位数字";
        
    }
    
    
    if ([areaCode containsString:@"60"] ) {
        
        NSString *maraxia = @"^\\d{7,9}$";
        isMatch = [self predicateMatchWithValue:phone  key:maraxia];
        if (!isMatch) errorStr = @"手机号码格式错误";
        
    }
    
    
    if (!isMatch) {
    
        [MBProgressHUD showError:errorStr toView:self.view];

     }
    
    return isMatch;
}

//手机号码验证
- (BOOL)predicateMatchWithValue:(NSString *)value key:(NSString *)key{
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", key];
    
    return  [pre evaluateWithObject:value];
}




#pragma mark : 提交注册信息

- (void)registButtonOnClick:(UIButton *)sender {
    
    if (![self checkNetworkState])return;
    
    
    for(MyOfferInputView *cell in  self.registCellbgView.subviews){
        
        [cell checKTextFieldWithGroupValue];
        
        switch (cell.group.groupType) {
            case EditTypeRegistPhone:
                
                if (![self verifyWithPhone:cell.group.content areaCode:cell.group.areaCode]) return;
                
                 break;
            case EditTypeVerificationCode:{
            
                if (cell.group.content.length <= 0 ) {
                     [MBProgressHUD showError:@"验证码不能为空" toView:self.view];
                     return;
                }
         
            }
                break;
            case EditTypePasswd:{
                
                if (cell.group.content.length < 6 || cell.group.content.length > 16) {
                    
                    [MBProgressHUD showError:cell.group.placeHolder toView:self.view];
                    return;
                }
  
                
            }
                break;
             default:
                break;
        }
        
    }
    

    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    for (WYLXGroup *group in self.registArr) {
        
        group.groupType == EditTypeVerificationCode ?  [parameter setValue:@{@"code":group.content} forKey:group.key] :  [parameter setValue:group.content forKey:group.key];
    }
 
    
    [self
     startAPIRequestWithSelector:kAPISelectorRegister
     parameters:parameter   success:^(NSInteger statusCode, NSDictionary *response) {
         
         [[AppDelegate sharedDelegate] loginWithAccessResponse:response];
         
         [MobClick event:@"myoffer_Register"];
         [MobClick profileSignInWithPUID:response[@"access_token"]];/*友盟统计记录用户账号*/
         
         MBProgressHUD *hud = [MBProgressHUD showSuccessWithMessage:nil ToView:nil];
         hud.completionBlock = ^{
             
             [self dismiss];
         };
 
     }];
 
}


#pragma mark : 键盘处理

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
 
    self.baseView.top = up ?  - (self.logoView.mj_h - XNAV_HEIGHT): 0;
    
    [self.view layoutSubviews];
    
    [UIView commitAnimations];
}



#pragma mark :事件处理
//退出登入
- (void)dismiss:(UIButton *)sender{
    
    [self dismiss];
    
}

//提交登录
- (void)loginButtonOnClick:(UIButton *)sender{
    
    for(MyOfferInputView *cell in  self.loginCellbgView.subviews){
    
        [cell checKTextFieldWithGroupValue];

    }
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    for (WYLXGroup *group in self.loginArr) {
        
        
        [parameter setValue:group.content forKey:group.key];
        
        switch (group.groupType) {
            case EditTypePhone:
            {
                
                if (group.content.length <= 0) {
                    
                    [MBProgressHUD showError:@"手机号码不能为空" toView:self.view];
                    
                    return;
                }
               
            }
                break;
                
            default:{
                
                if (group.content.length <= 0) {
                    
                    [MBProgressHUD showError:@"密码不能为空" toView:self.view];
                    
                    return;
                }
            
            
            }
                break;
        }
  
    }
    
    if (![self checkNetworkState]) return; //网络连接失败提示
  
    
    [self
     startAPIRequestWithSelector:kAPISelectorLogin
     parameters:parameter
     success:^(NSInteger statusCode, NSDictionary *response) {
         
         [self LoginSuccessWithResponse:response];
         
     }];
    
}

#pragma mark :登录
//正常登录成功相关处理  （非第三方）登录
-(void)LoginSuccessWithResponse:(NSDictionary *)response
{
    
    [APService setAlias:response[@"jpush_alias"] callbackSelector:nil object:nil];//Jpush设置登录用户别名
    [[AppDelegate sharedDelegate] loginWithAccessResponse:response];
    [MobClick profileSignInWithPUID:response[@"access_token"]];/*友盟统计记录用户账号*/
//        NSLog(@">>>>>>>>>>>>> access_token = %@",response[@"jpush_alias"]);
    [MobClick event:@"myofferUserLogin"];
    
    //当用户没有电话时发出通知，让用户填写手机号
    NSString *phone =response[@"phonenumber"];
    
    if (phone.length == 0) {
        
        [self.view endEditing:YES];
        
    }else{
        
        MBProgressHUD *HUD = [MBProgressHUD showSuccessWithMessage:nil ToView:self.view];
        HUD.completionBlock = ^{
            
            [self dismiss];
            
        };
        
    }
    
 
    
}

//去登录
- (void)toLoginBtnOnClick:(UIButton *)sender{
    
    [self.bgView setContentOffset:CGPointMake(0, 0) animated:YES];

}

//去注册
- (void) toRegistBtnOnClick:(UIButton *)sender{
    
    [self.bgView setContentOffset:CGPointMake(XSCREEN_WIDTH, 0) animated:YES];
}

#pragma mark : 第三方登录点击
- (void) otherBtnOnClick:(UIButton *)sender{

 
    UMSocialPlatformType platformType;
    NSString *platformName;
    switch (sender.tag) {
        case otherLoginTypeWX:
        {
            platformType = UMSocialPlatformType_WechatSession;
            platformName = @"wechat";
        }
            break;
        case otherLoginTypeWB:
        {
            
            platformType = UMSocialPlatformType_Sina;
            platformName = @"weibo";
            
        }
            break;
        default:
        {
            platformType = UMSocialPlatformType_QQ;
            platformName = @"qq";
        }
            break;
    }

    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
        
        if (!error) {
            
            UMSocialUserInfoResponse *resp = result;
            /*
            // 第三方登录数据(为空表示平台未提供)
            // 授权数据
            NSLog(@" uid: %@", resp.uid);
            NSLog(@" openid: %@", resp.openid);
            NSLog(@" accessToken: %@", resp.accessToken);
            NSLog(@" refreshToken: %@", resp.refreshToken);
            NSLog(@" expiration: %@", resp.expiration);
            
            // 用户数据
            NSLog(@" name: %@", resp.name);
            NSLog(@" iconurl: %@", resp.iconurl);
            NSLog(@" gender: %@", resp.unionGender);
            
            // 第三方平台SDK原始数据
            NSLog(@" originalResponse: %@", resp.originalResponse);
        
*/
            NSDictionary  *userInfo = @{ @"user_id" : resp.uid, @"provider" : platformName, @"token" : resp.accessToken };
            [self  loginWithParameters:userInfo];
            
        }
 
    }];
 
}
// 第三方登录传参并登录
-(void)loginWithParameters:(NSDictionary *)userInfo
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
    
    [[AppDelegate sharedDelegate] loginWithAccessResponse:response];
    
    [MobClick profileSignInWithPUID:response[@"access_token"] provider:[userInfo valueForKey:@"provider"]];/*友盟统计记录用户账号*/
    
    [MobClick event:@"otherUserLogin"];
    
    //当用户没有电话时发出通知，让用户填写手机号
    !response[@"phonenumber"]? [self caseBangding] :  [self dismiss];
    
}

//绑定手机号    当用户没有电话时发出通知，让用户填写手机号
- (void)caseBangding{
    
    [self.navigationController pushViewController:[[BangViewController alloc] init] animated:YES];
}



//选择登录页面，用于用户填写手机号、或绑定原有账号
- (void)caseLoginSelection:(NSDictionary *)userInfo{
    
    LoginSelectViewController *selectVC =[[LoginSelectViewController alloc] initWithNibName:@"LoginSelectViewController" bundle:[NSBundle mainBundle]];
    selectVC.parameter = userInfo;
    [self.navigationController pushViewController:selectVC animated:YES];
}


//点击查看协议
- (void)protocolBtnOnClick:(UIButton *)sender{
    
    WebViewController  *service =[[WebViewController alloc] init];
    service.path =  [NSString stringWithFormat:@"%@docs/%@/web-agreement.html",DOMAINURL,GDLocalizedString(@"ch_Language")];
    [self.navigationController pushViewController:service animated:YES];
}

//点击背景隐藏键盘
- (void)keyboardHiden{

    [self.view endEditing:YES];
}

//点击忘记密码
- (void)forgetButtonOnClick:(UIButton *)sender{
    
    [self keyboardHiden];
    
    [self.navigationController pushViewController:[[ForgetPWViewController alloc] init] animated:YES];
    

}

- (void)toRegistView{
    
    [self.bgView setContentOffset:CGPointMake(XSCREEN_WIDTH, 0) animated:NO];

}

- (void)dealloc{
    
    KDClassLog(@"登录 dealloc");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
