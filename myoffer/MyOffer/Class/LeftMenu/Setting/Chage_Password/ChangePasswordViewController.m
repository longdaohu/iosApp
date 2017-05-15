//
//  ChangePasswordViewController.m
//  MyOffer
//
//  Created by Blankwonder on 6/23/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//
#import "ProfileViewController.h"
#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController () <UITextFieldDelegate> {
    NSArray *_cells;
    
    UITextField *_oldPasswordTextField, *_newPasswordTextField, *_confirmPasswordTextField;
}

@end

@implementation ChangePasswordViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"page修改密码"];
    
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page修改密码"];
    
}



-(UITableViewCell *)cellDefault
{
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
}

-(UITextField *)textFieldCreateWithPlacehodler:(NSString *)placeholder
{
    UITextField *cellTextField = [[UITextField alloc] init];
    [cellTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    cellTextField.delegate = self;
    cellTextField.placeholder = placeholder;
    return cellTextField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = GDLocalizedString(@"Person-006" );//@"修改密码";
   
    if (self.newpasswd) {
        
        self.title = GDLocalizedString(@"Person-SetPasswd");//@"设置密码";

    }
    
    _tableView.rowHeight = 44;
    
    NSMutableArray *cells = [NSMutableArray array];

    if (!self.newpasswd) {
        UITableViewCell *cell = [self cellDefault];
        _oldPasswordTextField = [self textFieldCreateWithPlacehodler:GDLocalizedString(@"ChPasswd-001")];
        _oldPasswordTextField.returnKeyType = UIReturnKeyNext;
        _oldPasswordTextField.secureTextEntry = YES;
        [cell addSubview:_oldPasswordTextField];
        [cells addObject:cell];
    }
    
    {
        UITableViewCell *cell = [self cellDefault];
        _newPasswordTextField = [self textFieldCreateWithPlacehodler:GDLocalizedString(@"ChPasswd-002")];
        _newPasswordTextField.returnKeyType = UIReturnKeyNext;
        _newPasswordTextField.secureTextEntry = YES;
         [cell addSubview:_newPasswordTextField];
        [cells addObject:cell];
    }
    
    {
        UITableViewCell *cell = [self cellDefault];
        _confirmPasswordTextField = [self textFieldCreateWithPlacehodler:GDLocalizedString(@"ChPasswd-003")];
        _confirmPasswordTextField.returnKeyType = UIReturnKeyDone;
        _confirmPasswordTextField.secureTextEntry = YES;
        [cell addSubview:_confirmPasswordTextField];
        [cells addObject:cell];
    }
    
    _cells = cells;
    
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:GDLocalizedString(@"Evaluate-0017") style:UIBarButtonItemStylePlain target:self action:@selector(done)];

    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.newpasswd) {
        
        [_newPasswordTextField becomeFirstResponder];
        
    }else{
        
        [_oldPasswordTextField becomeFirstResponder];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _cells[indexPath.row];
}

#pragma mark UItextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    
    if (textField == _oldPasswordTextField) {
        [_newPasswordTextField becomeFirstResponder];
    }else if(textField == _newPasswordTextField) {
        [_confirmPasswordTextField becomeFirstResponder];
    }else if(textField == _confirmPasswordTextField)
    {
      [self done];
    }
    
       return YES;
}

- (void)done {
    
    
    if (_oldPasswordTextField.text.length == 0 &&!self.newpasswd) {
        
        AlerMessage(_oldPasswordTextField.placeholder);
         return;
    }
    
    if (_newPasswordTextField.text.length == 0) {
        AlerMessage(_newPasswordTextField.placeholder);

         return;
    }
    if (_confirmPasswordTextField.text.length == 0) {
        AlerMessage(_confirmPasswordTextField.placeholder);
          return;
    }
    
     if(_newPasswordTextField.text.length < 6  || _newPasswordTextField.text.length > 16)
    {   //@"密码长度不小于6个字符"
        AlerMessage(GDLocalizedString(@"Person-passwd"));
         return;
    }
    
     if (![_newPasswordTextField.text isEqualToString:_confirmPasswordTextField.text]) {
         AlerMessage(GDLocalizedString(@"ChPasswd-004"));
        return;//@"两次输入的密码不一致"
    }
    
    NSMutableDictionary *infoParameters =[NSMutableDictionary dictionary];
    
    if (!self.newpasswd) {
        
        [infoParameters setValue:_oldPasswordTextField.text forKey:@"old_password"];
    }
    [infoParameters setValue:_newPasswordTextField.text forKey:@"new_password"];

    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    
    [self startAPIRequestWithSelector:kAPISelectorUpdateAccountInfo  parameters:@{@"accountInfo":infoParameters} expectedStatusCodes:nil showHUD:NO showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
  
        MBProgressHUD *hud = [MBProgressHUD showSuccessWithMessage:@"密码设置成功" ToView:self.view];
        hud.completionBlock = ^{
            
            [self dismiss];
            
        };

        
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
    }];
    


}

- (void)viewDidLayoutSubviews {
    const CGFloat xInset = 20, yInset = 11;
    
    _oldPasswordTextField.frame = CGRectMake(xInset, yInset, _tableView.frame.size.width - xInset * 2.0f, _tableView.rowHeight - yInset * 2.0f);
    _newPasswordTextField.frame = CGRectMake(xInset, yInset, _tableView.frame.size.width - xInset * 2.0f, _tableView.rowHeight - yInset * 2.0f);
    _confirmPasswordTextField.frame = CGRectMake(xInset, yInset, _tableView.frame.size.width - xInset * 2.0f, _tableView.rowHeight - yInset * 2.0f);
}

KDUtilRemoveNotificationCenterObserverDealloc
@end
