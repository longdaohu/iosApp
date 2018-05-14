//
//  ForgetPWViewController.m
//  MyOffer
//
//  Created by xuewuguojie on 2017/5/27.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "ForgetPWViewController.h"
#import "WYLXGroup.h"
#import "MyOfferInputView.h"

@interface ForgetPWViewController ()<MyOfferInputViewDelegate>
@property(nonatomic,strong)NSArray *registArr;
@property(nonatomic,strong)UIView *registCellbgView;
@property(nonatomic,strong)UIButton *registBtn;

@end

@implementation ForgetPWViewController

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
    
    
    self.title = @"忘记密码";
    self.view.backgroundColor = XCOLOR_WHITE;
    
    
    CGFloat cell_W = self.view.bounds.size.width;
    CGFloat cell_X = 0 ;
    CGFloat cell_Y = 0 ;
    CGFloat cell_H = 0 ;
    
    CGFloat cell_bg_X = 0;
    CGFloat cell_bg_Y = 0;
    CGFloat cell_bg_W = cell_W;
    UIView *registCellbgView = [[UIView alloc] init];
    self.registCellbgView = registCellbgView;
    [self.view  addSubview:registCellbgView];
    
    
    for (NSInteger index = 0 ; index < self.registArr.count; index++) {
        
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
    
    
    
    CGFloat regist_X = 25;
    CGFloat regist_Y = CGRectGetMaxY(registCellbgView.frame) + XFONT_SIZE(1) * 10 + 15;
    CGFloat regist_W = cell_W - regist_X * 2;
    CGFloat regist_H =  50;
    self.registBtn = [self buttonWithFrame:CGRectMake(regist_X, regist_Y, regist_W, regist_H)  title:@"重置密码" fontSize:14 titleColor:XCOLOR_WHITE imageName:nil  Action:@selector(resetButtonOnClick:)];
    [self.view addSubview:self.registBtn];
    
    self.registBtn.layer.cornerRadius = 4;
    self.registBtn.backgroundColor = XCOLOR_RED;

    
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


- (NSArray *)registArr{
    
    if (!_registArr) {
        
        WYLXGroup *regist_Phone = [WYLXGroup groupWithType:EditTypeRegistPhone title:@"手机" placeHolder:@"请输入手机号" content:nil groupKey:@"target" spod:false cellType:CellGroupTypeView];
        WYLXGroup *regist_yzm = [WYLXGroup groupWithType:EditTypeVerificationCode title:@"验证码" placeHolder:@"请输入验证码" content:nil groupKey:@"vcode" spod:false cellType:CellGroupTypeView];
        
        WYLXGroup *login_passwd = [WYLXGroup groupWithType:EditTypePasswd title:@"密码" placeHolder:@"请输入6-16新密码" content:nil groupKey:@"new_password" spod:false  cellType:CellGroupTypeView];
        
        
        _registArr = @[regist_Phone,regist_yzm,login_passwd];
        
    }
    return  _registArr;
}



#pragma mark : MyOfferInputViewDelegate

- (void)cell:(MyOfferInputView *)cell  textFieldShouldReturn:(UITextField *)textField{
    
    if (cell.inputTF.returnKeyType == UIReturnKeyDone) {
        
        [self.view endEditing:YES];
        
    }else{
        
        MyOfferInputView *nextCell  = (MyOfferInputView *)self.registCellbgView.subviews[cell.tag + 1];
        
        [nextCell.inputTF becomeFirstResponder];
        
    }
    
}

- (void)cell:(MyOfferInputView *)cell  shouldChangeCharacters:(NSString *)content{
    
    
    if (cell.group.groupType == EditTypeRegistPhone) {
        
        MyOfferInputView *nextCell  = (MyOfferInputView *)self.registCellbgView.subviews[cell.tag + 1];
        
        [nextCell changeVertificationCodeButtonEnable:(content.length > 0)];
    }
    
    
}


- (void)inputAccessoryViewClickWithCell:(MyOfferInputView *)cell{
    
    if (cell.group.groupType == EditTypeRegistPhone || cell.group.groupType == EditTypeVerificationCode) {
        
        MyOfferInputView *nextCell  = (MyOfferInputView *)self.registCellbgView.subviews[cell.tag + 1];
        
        [nextCell.inputTF becomeFirstResponder];
    }
    
}


//点击发送验证码
- (void)sendVertificationCodeWithCell:(MyOfferInputView *)cell{
    
    if (cell.group.groupType != EditTypeVerificationCode) return;
    
    MyOfferInputView *phoneCell = self.registCellbgView.subviews[cell.tag -1];
    
    [phoneCell checKTextFieldWithGroupValue];
    
    BOOL isMatch = [self verifyWithPhone:phoneCell.group.content areaCode:phoneCell.group.areaCode];
    
    if (!isMatch) {  return; }
    
    NSDictionary *parameter = @{
                                @"code_type":@"reset",
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
    
    BOOL match =  [pre evaluateWithObject:value];
    
    
    return match;
}


//提交按钮
- (void)resetButtonOnClick:(UIButton *)sender {

    [self.view endEditing:YES];
    
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
        [parameter setValue:group.content forKey:group.key];
    }
    
    WeakSelf
    [self
     startAPIRequestWithSelector:kAPISelectorResetPassword
     parameters:parameter
     success:^(NSInteger statusCode, NSDictionary *response) {
         MBProgressHUD *HUD = [MBProgressHUD showSuccessWithMessage:nil ToView:self.view];
         HUD.completionBlock = ^{
             [weakSelf.navigationController popViewControllerAnimated:YES];
         };
         
     }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    
    KDClassLog(@"忘记密码  dealloc");
    
}

@end
