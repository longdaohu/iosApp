//
//  BBSingleTextFieldViewController.m
//  BuddyBook
//
//  Created by Blankwonder on 9/22/13.
//  Copyright (c) 2013 Suixing Tech. All rights reserved.
//

#import "TextFieldViewController.h"

@interface TextFieldViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@end

@implementation TextFieldViewController



- (void)loadView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.view = self.tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [self makeUI];
  
}

-(void)makeUI
{
    _cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    self.tableView.rowHeight = 44;
    UITextField *textField = [[UITextField alloc] init];
    textField.clearButtonMode = UITextFieldViewModeAlways;
    textField.returnKeyType = UIReturnKeyDone;
    textField.delegate = self;
    _textField = textField;
    
    [_cell addSubview:textField];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:GDLocalizedString(@"Evaluate-0017") style:UIBarButtonItemStylePlain target:self action:@selector(rightDone)];
    
    if (self.viewDidLoadAction) {
        
        self.viewDidLoadAction(self);
    }

}

- (void)viewDidLayoutSubviews {
    const CGFloat xInset = 20, yInset = 11;

    _textField.frame = CGRectMake(xInset, yInset, self.tableView.frame.size.width - xInset * 2.0f, self.tableView.rowHeight - yInset * 2.0f);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self rightDone];
    return YES;
}



- (void)rightDone {
    
    NSString *userName = self.textField.text;
    
    NSString *temp = [userName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

     if (userName.length == 0 || temp.length == 0) {
       
          AlerMessage(GDLocalizedString(@"TiJiao-Empty") );
      
         return;
    }
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [self startAPIRequestWithSelector:kAPISelectorUpdateAccountInfo parameters:@{@"accountInfo":@{@"displayname": self.textField.text}} expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
        [hud applySuccessStyle];
        [hud hideAnimated:YES afterDelay:1];
        [hud setHiddenBlock:^(KDProgressHUD *hud) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        self.navigationItem.rightBarButtonItem.enabled = YES;
 
    }];
    
    
     if (self.doneAction) {
         
        self.doneAction(self);
    }
}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.textField resignFirstResponder];
    [MobClick endLogPageView:@"page修改用户名"];

}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"page修改用户名"];
    
}


#pragma mark ——— UITableViewDelegate  UITableViewDataSoure

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return _cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    return self.footerText;
}


@end
