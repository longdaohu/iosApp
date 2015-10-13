//
//  EvaluateViewController.m
//  MyOffer
//
//  Created by Blankwonder on 6/7/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import "EvaluateViewController.h"

@interface EvaluateViewController () <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>{
    NSArray *_titles;
    NSArray *_cells;
    
    UITextField *_universityTextField, *_subjectTextField, *_scoreTextField, *_IELTSTextField, *_IELTSMinTextField, *_applySubjectTextField;
    UIPickerView *_subjectPickerView, *_applySubjectPickerView;
    NSArray *_subjects;
    IBOutlet KDEasyTouchButton *_saveButton;
    
}


@end


@implementation EvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_saveButton  setTitle:GDLocalizedString(@"Evaluate-0017") forState:UIControlStateNormal];
    
    
    _tableView.contentInset = UIEdgeInsetsMake(-10, 0, 50, 0);
    self.navigationItem.title = GDLocalizedString(@"Evaluate-001");
    _titles = @[GDLocalizedString(@"Evaluate-002"), GDLocalizedString(@"Evaluate-003"),GDLocalizedString(@"Evaluate-004"), GDLocalizedString(@"Evaluate-005"), GDLocalizedString(@"Evaluate-006"), GDLocalizedString(@"Evaluate-007")];
    
    UITableViewCell *(^newCell)(NSString *placeholder, UITextField **textFieldPtr) = ^UITableViewCell*(NSString *placeholder, UITextField **textFieldPtr) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.frame = CGRectMake(0, 0, 320, 44);
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, 290, 44)];
        textField.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        textField.placeholder = placeholder;
        textField.delegate = self;
        textField.returnKeyType = UIReturnKeyDone;
        textField.inputAccessoryView = _toolbar;
        *textFieldPtr = textField;
        
        [cell.contentView addSubview:textField];
        
        return cell;
    };
    
    

    UITextField *universityTextField, *subjectTextField, *scoreTextField, *IELTSTextField, *IELTSMinTextField, *applySubjectTextField;
    
    _cells = @[newCell( GDLocalizedString(@"Evaluate-009"), &universityTextField),
               newCell( GDLocalizedString(@"Evaluate-0010"),& subjectTextField),
               newCell( GDLocalizedString(@"Evaluate-0011"), &scoreTextField),
               newCell( GDLocalizedString(@"Evaluate-0012"), &IELTSTextField),
               newCell( GDLocalizedString(@"Evaluate-0013"), &IELTSMinTextField),
               newCell( GDLocalizedString(@"Evaluate-0014"), &applySubjectTextField)];
    
    [(UITableViewCell *)_cells[1] setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [(UITableViewCell *)_cells[5] setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    _universityTextField = universityTextField;
    _subjectTextField = subjectTextField;
    _scoreTextField = scoreTextField;
    _IELTSTextField = IELTSTextField;
    _IELTSMinTextField = IELTSMinTextField;
    _applySubjectTextField = applySubjectTextField;
    
    _IELTSMinTextField.keyboardType = UIKeyboardTypeDecimalPad;
    _IELTSTextField.keyboardType = UIKeyboardTypeDecimalPad;
    _scoreTextField.keyboardType = UIKeyboardTypeDecimalPad;
    
    {
        _applySubjectPickerView = [[UIPickerView alloc] init];
        _subjectPickerView = [[UIPickerView alloc] init];
        _applySubjectPickerView.delegate = self;
        _applySubjectPickerView.dataSource = self;
        _subjectPickerView.delegate = self;
        _subjectPickerView.dataSource = self;
        
        _subjectTextField.inputView = _subjectPickerView;
        _applySubjectTextField.inputView = _applySubjectPickerView;
    }
    
    if (self.dismissCompletion) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismiss)];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    self.tapToEndEditing = YES;
    
    
    
    NSString  *lan = [InternationalControl userLanguage];
    if ( [lan containsString:@"en"]) {
        
        lan = @"en";
    }
    else
    {
        lan = @"zh-cn";

    }
    
    
    [self
     startAPIRequestWithSelector:kAPISelectorSubjects parameters:@{@":lang": lan }
     success:^(NSInteger statusCode, NSArray *response) {
         _subjects = [response KD_arrayUsingMapEnumerateBlock:^id(NSDictionary *obj, NSUInteger idx) {
             return obj[@"name"];
         }];
         [_subjectPickerView reloadAllComponents];
         [_applySubjectPickerView reloadAllComponents];
     }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([AppDelegate sharedDelegate].isLogin) {
        [self startAPIRequestUsingCacheWithSelector:@"GET api/account/evaluate" parameters:nil success:^(NSInteger statusCode, id response) {
            _IELTSTextField.text = KDUtilStringGuard(response[@"ielts_avg"]);
            _IELTSMinTextField.text = KDUtilStringGuard(response[@"ielts_low"]);
            _scoreTextField.text = KDUtilStringGuard(response[@"score"]);
            _subjectTextField.text = response[@"subject"];
            _universityTextField.text = response[@"university"];
            _applySubjectTextField.text = response[@"apply"];
        }];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _subjects.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _subjects[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *str = _subjects[row];
    if (pickerView == _subjectPickerView) {
        _subjectTextField.text = str;
    } else {
        _applySubjectTextField.text = str;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _subjectTextField || textField == _applySubjectTextField) {
        if (textField.text.length == 0) {
            textField.text = _subjects[0];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _titles.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _titles[section];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _cells[indexPath.section];
}

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
    
    // Animate up or down
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    UIEdgeInsets insets = _tableView.contentInset;
    if (up) {
        insets.bottom = keyboardEndFrame.size.height;
    } else {
        insets.bottom = 50;
    }
    _tableView.contentInset = insets;
    
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
}

- (IBAction)submit {
    RequireLogin
    
    NSArray *textField = @[_universityTextField, _subjectTextField, _scoreTextField, _IELTSTextField, _IELTSMinTextField, _applySubjectTextField];
    
    for (UITextField *t in textField) {
        if (t.text.length == 0) {
            [KDAlertView showMessage:t.placeholder cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];
            return;
        }
    }
    
    [self
     startAPIRequestWithSelector:@"POST api/account/evaluate"
     parameters:@{@"university": _universityTextField.text,
                  @"subject": _subjectTextField.text,
                  @"score": _scoreTextField.text,
                  @"ielts_avg": _IELTSTextField.text,
                  @"ielts_low": _IELTSMinTextField.text,
                  @"apply": _applySubjectTextField.text}
     success:^(NSInteger statusCode, id response) {
         if (self.dismissCompletion) {
             [self dismiss];
         } else{
             [KDAlertView showMessage:GDLocalizedString(@"Evaluate-0015") cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];
         }
         
     }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

@end
