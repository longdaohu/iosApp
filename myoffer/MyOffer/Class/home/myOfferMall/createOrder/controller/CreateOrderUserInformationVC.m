//
//  CreateOrderUserInformationVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/7/3.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "CreateOrderUserInformationVC.h"

@interface CreateOrderUserInformationVC ()
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *userIDTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property(nonatomic,assign) BOOL formSuccessed;

@end

@implementation CreateOrderUserInformationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nextBtn.backgroundColor = XCOLOR_RED;
    self.bgView.backgroundColor  = XCOLOR_WHITE;
    self.nameTF.layer.cornerRadius = 4;
    self.userIDTF.layer.cornerRadius = 4;
    self.phoneTF.layer.cornerRadius = 4;
    
    [self addNotificationCenter];
}

- (void)setItem:(NSDictionary *)item{
    
    _item = item;
    
    NSNumber *isAuthenticated = item[@"isAuthenticated"];
    if ([isAuthenticated boolValue]) {
        self.nameTF.text = self.item[@"IDCardName"];
        self.userIDTF.text = self.item[@"IDCardNo"];
        self.phoneTF.text = self.item[@"mobile"];
        [self updateUI];
        return;
    }
    
}


- (IBAction)close:(UIButton *)sender {
    
    [self formDismiss];
}

- (void)formDismiss{
    
    [self.view endEditing:YES];
 
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        self.view.alpha = 0;
        self.view.mj_y = 0;
    } completion:^(BOOL finished) {
 
        if (!self.formSuccessed) {
            self.nameTF.text = @"";
            self.userIDTF.text = @"";
            self.phoneTF.text = @"";
        }
    }];
}

- (IBAction)nextBtnClick:(UIButton *)sender {
    
    if ([sender.currentTitle isEqualToString:@"下一步"]) {
 
            //        这里要提示用户信息错误
            if (self.nameTF.text.length  == 0|| self.userIDTF.text.length == 0 || self.phoneTF.text == 0) {
                [MBProgressHUD showMessage:@" 姓名/身份证号/手机号:不能为空"];
                return;
            }
            
            NSString *regex = @"[\u4e00-\u9fa5]{2,8}";
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
            if (![pred evaluateWithObject:self.nameTF.text]) {
                [MBProgressHUD showMessage:@"请输入正确的中文姓名"];
                return;
            }
            
            if (self.userIDTF.text.length  != 18) {
                [MBProgressHUD showMessage:@"请输入正确的身份证号"];
                return;
            }
            
            if (self.phoneTF.text.length  != 11 || ![self.phoneTF.text hasPrefix:@"1"]) {
                [MBProgressHUD showMessage:@"请输入正确的手机号"];
                return;
            }
  
        NSDictionary *parameters = @{
                                         @"mobile": self.phoneTF.text,
                                         @"IDCardNo": self.userIDTF.text,
                                         @"IDCardName": self.nameTF.text,
                                     };
        NSString  *path = [NSString stringWithFormat:@"PUT %@api/v1/accounts/id-card",DOMAINURL_API];
        WeakSelf;
        [self startAPIRequestWithSelector:path parameters:parameters expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
            [weakSelf updateUIWithResponse:response];
        } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
 
        }];
        
         return;
    }
    
    [self formDismiss];
    if (self.actionBlock) {
        self.actionBlock();
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
 
    
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self.view];
    
    if (!CGRectContainsPoint(self.bgView.frame, point)) {
        [self formDismiss];
    }
    
}
- (void)updateUIWithResponse:(id)response{
    
    if (!ResponseIsOK) {
        [MBProgressHUD showMessage:@"请确认姓名、身份证是否匹配"];
        return;
    }
    NSDictionary *result = response[@"result"];
    NSNumber *validity = result[@"validity"];
    if ([validity boolValue] ) {
        [self updateUI];
    }else{
        [MBProgressHUD showMessage:@"请确认姓名、身份证是否匹配"];
    }
}

- (void)updateUI{
    
    self.formSuccessed = YES;
    [self.nextBtn setTitle:@"确认信息" forState:UIControlStateNormal];
    self.nameTF.userInteractionEnabled = NO;
    self.userIDTF.userInteractionEnabled = NO;
    self.phoneTF.userInteractionEnabled = NO;
    self.nameTF.backgroundColor  = XCOLOR_WHITE;
    self.userIDTF.backgroundColor  = XCOLOR_WHITE;
    self.phoneTF.backgroundColor  = XCOLOR_WHITE;
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        self.view.mj_y = 0;
    }];
    
}

//键盘处理通知
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


#pragma mark : 键盘处理
- (void)keyboardWillShow:(NSNotification *)aNotification {
    [self moveTextViewForKeyboard:aNotification up:YES];
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    [self moveTextViewForKeyboard:aNotification up:NO];
}

- (void) moveTextViewForKeyboard:(NSNotification*)aNotification up: (BOOL) up {
    NSDictionary* userInfo = [aNotification userInfo];
    
    // Get animation info from userInfo
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    [userInfo[UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [userInfo[UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [userInfo[UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    CGFloat bg_y  = CGRectGetMaxY(self.bgView.frame);
    if ((bg_y + keyboardEndFrame.size.height) > self.view.bounds.size.height) {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:animationCurve];
        self.view.mj_y =  self.view.bounds.size.height - bg_y - keyboardEndFrame.size.height;
        [self.view layoutSubviews];
        [UIView commitAnimations];
        
        return;
    }
    
    if (up)return;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    self.view.mj_y =  0;
    [self.view layoutSubviews];
    [UIView commitAnimations];
 
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    KDClassLog(@" 合同信息填写用户信息 + CreateOrderUserInformationVC + dealloc");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
