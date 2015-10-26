//
//  ChangePasswordViewController.m
//  MyOffer
//
//  Created by Blankwonder on 6/23/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController () <UITextFieldDelegate> {
    NSArray *_cells;
    
    UITextField *_oldPasswordTextField, *_newPasswordTextField, *_confirmPasswordTextField;
}

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = GDLocalizedString(@"Person-006" );//@"修改密码";
    _tableView.rowHeight = 44;
    
    NSMutableArray *cells = [NSMutableArray array];
    
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _oldPasswordTextField = [[UITextField alloc] init];
        _oldPasswordTextField.returnKeyType = UIReturnKeyNext;
        _oldPasswordTextField.delegate = self;
        _oldPasswordTextField.enablesReturnKeyAutomatically = YES;
        _oldPasswordTextField.secureTextEntry = YES;
        _oldPasswordTextField.placeholder = GDLocalizedString(@"ChPasswd-001"); //@"请输入旧密码";
        [cell addSubview:_oldPasswordTextField];
        [cells addObject:cell];
    }
    
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _newPasswordTextField = [[UITextField alloc] init];
        _newPasswordTextField.returnKeyType = UIReturnKeyNext;
        _newPasswordTextField.delegate = self;
        _newPasswordTextField.enablesReturnKeyAutomatically = YES;
        _newPasswordTextField.secureTextEntry = YES;
        _newPasswordTextField.placeholder =  GDLocalizedString(@"ChPasswd-002");// @"请输入新密码";
        [cell addSubview:_newPasswordTextField];
        [cells addObject:cell];
    }
    
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _confirmPasswordTextField = [[UITextField alloc] init];
        _confirmPasswordTextField.returnKeyType = UIReturnKeyDone;
        _confirmPasswordTextField.delegate = self;
        _confirmPasswordTextField.enablesReturnKeyAutomatically = YES;
        _confirmPasswordTextField.secureTextEntry = YES;
        _confirmPasswordTextField.placeholder = GDLocalizedString(@"ChPasswd-003");//@"请再次输入新密码";
        [cell addSubview:_confirmPasswordTextField];
        [cells addObject:cell];
    }
    
    _cells = cells;
    
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_oldPasswordTextField becomeFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _cells[indexPath.row];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _oldPasswordTextField) {
        [_newPasswordTextField becomeFirstResponder];
    } else if (textField == _newPasswordTextField) {
        [_confirmPasswordTextField becomeFirstResponder];
    } else {
        [self done];
    }
    return YES;
}

- (void)done {
    if (_oldPasswordTextField.text.length == 0) {
        
        [KDAlertView showMessage:_oldPasswordTextField.placeholder cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")]; //@"好的"];
        return;
    }
   
     if(_newPasswordTextField.text.length < 6 )
    {   //@"密码长度不小于6个字符"
        [KDAlertView showMessage:GDLocalizedString(@"Person-passwd") cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];//@"好的"];
        return;
    }
    
     if (![_newPasswordTextField.text isEqualToString:_confirmPasswordTextField.text]) {
        [KDAlertView showMessage:GDLocalizedString(@"ChPasswd-004")  cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];
        return;//@"两次输入的密码不一致"
    }
    
    [self startAPIRequestWithSelector:kAPISelectorUpdateAccountInfo
                           parameters:@{@"accountInfo":@{@"old_password":_oldPasswordTextField.text,
                                                         @"new_password": _newPasswordTextField.text}}
                              success:^(NSInteger statusCode, id response) {
                                  KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
                                  
                                  [hud applySuccessStyle];
                                  [hud hideAnimated:YES afterDelay:2];
                                  [hud setHiddenBlock:^(KDProgressHUD *hud) {
                                      [self dismiss];
                                  }];
        
    }];
}

- (void)viewDidLayoutSubviews {
    const CGFloat xInset = 20, yInset = 11;
    
    _oldPasswordTextField.frame = CGRectMake(xInset, yInset, _tableView.frame.size.width - xInset * 2.0f, _tableView.rowHeight - yInset * 2.0f);
    _newPasswordTextField.frame = CGRectMake(xInset, yInset, _tableView.frame.size.width - xInset * 2.0f, _tableView.rowHeight - yInset * 2.0f);
    _confirmPasswordTextField.frame = CGRectMake(xInset, yInset, _tableView.frame.size.width - xInset * 2.0f, _tableView.rowHeight - yInset * 2.0f);
}


@end
