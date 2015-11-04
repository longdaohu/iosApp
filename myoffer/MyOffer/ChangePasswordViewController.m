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
-(UITableViewCell *)cellDefault
{
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
}

-(UITextField *)textFieldCreateWithPlacehodler:(NSString *)placeholder
{
    UITextField *cellTextField = [[UITextField alloc] init];
    [cellTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    cellTextField.delegate = self;
    cellTextField.enablesReturnKeyAutomatically = YES;
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
    
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    
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
    
    if (_oldPasswordTextField.text.length == 0 &&!self.newpasswd) {
        
        [KDAlertView showMessage:_oldPasswordTextField.placeholder cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")]; //@"好的"];
        return;
    }
     if(_newPasswordTextField.text.length < 6  || _newPasswordTextField.text.length > 15)
    {   //@"密码长度不小于6个字符"
        [KDAlertView showMessage:GDLocalizedString(@"Person-passwd") cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];//@"好的"];
        return;
    }
    
     if (![_newPasswordTextField.text isEqualToString:_confirmPasswordTextField.text]) {
        [KDAlertView showMessage:GDLocalizedString(@"ChPasswd-004")  cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];
        return;//@"两次输入的密码不一致"
    }
    
    NSMutableDictionary *infoParameters =[NSMutableDictionary dictionary];
    
    if (!self.newpasswd) {
        [infoParameters setValue:_oldPasswordTextField.text forKey:@"old_password"];
    }
    [infoParameters setValue:_newPasswordTextField.text forKey:@"new_password"];


    [self startAPIRequestWithSelector:kAPISelectorUpdateAccountInfo
                           parameters:@{@"accountInfo":infoParameters}
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
