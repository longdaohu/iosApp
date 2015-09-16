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

    _cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

    self.tableView.rowHeight = 44;

    UITextField *textField = [[UITextField alloc] init];
    textField.clearButtonMode = UITextFieldViewModeAlways;
    textField.returnKeyType = UIReturnKeyDone;
    textField.delegate = self;
    _textField = textField;
    [_cell addSubview:textField];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];

    if (self.viewDidLoadAction) {
        self.viewDidLoadAction(self);
    }
}

- (void)viewDidLayoutSubviews {
    const CGFloat xInset = 20, yInset = 11;

    _textField.frame = CGRectMake(xInset, yInset, self.tableView.frame.size.width - xInset * 2.0f, self.tableView.rowHeight - yInset * 2.0f);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self done];
    return YES;
}

- (void)done {
    if (self.doneAction) {
        self.doneAction(self);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.textField resignFirstResponder];
}

#pragma mark - Table view data source

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
