//
//  EvaluateViewController.m
//  MyOffer
//
//  Created by Blankwonder on 6/7/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

typedef NS_ENUM(NSUInteger,pickeTag)
{
    pickeTagMini = 100,
    pickeTagAverage = 110,
    pickeTagSubject = 111,
    pickeTagApplySubject = 112,
    
};


#import "EvaluateViewController.h"
#import "EvaluateSearchCollegeViewController.h"

@interface EvaluateViewController () <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>{
    NSArray *_titles;
    NSArray *_cells;
    // 毕业院校             在读专业              平均分              雅思平均分         雅思最低分            申请专业
    UITextField *_universityTextField, *_subjectTextField, *_scoreTextField, *_IELTSTextField, *_IELTSMinTextField, *_applySubjectTextField;
    //在读专业PICKER      申请专业PICKER
    UIPickerView *_subjectPickerView, *_applySubjectPickerView;
    NSArray *_subjects;
    NSArray *_IELSTaverageScores;
    NSArray *_IELSTminiScores;
    
 }

@property(nonatomic,strong)UIPickerView *IELSTminiPickerView;
@property(nonatomic,strong)UIPickerView *IELSTaveragePickerView;
@property(nonatomic,strong)UIPickerView *XsubjectPickerView;
@property(nonatomic,strong)UIPickerView *XapplySubjectPickerView;
@property (weak, nonatomic) IBOutlet KDEasyTouchButton *saveButton;

@end

@implementation EvaluateViewController


-(void)pickDataSourse
{
    _IELSTminiScores = @[@"9.0",@"8.5",@"8.0",@"7.5",@"7.0",@"6.5",@"6.0",@"5.5",@"5.0",@"4.5",@"4.0",@"3.5",@"3.0",@"2.5",@"2.0",@"1.5",@"1.0",@"0.5",@"0"];
    
    _IELSTaverageScores = [_IELSTminiScores copy];
    
}

-(UIPickerView *)IELSTminiPickerView
{
    if (!_IELSTminiPickerView) {
        _IELSTminiPickerView = [[UIPickerView alloc] init];
        _IELSTminiPickerView.dataSource = self;
        _IELSTminiPickerView.delegate = self;
        _IELSTminiPickerView.tag = pickeTagMini;

        //默认显示数组中index = 2的数据
        [_IELSTminiPickerView selectRow:2 inComponent:0 animated:YES];
    }
    return _IELSTminiPickerView;
}

-(UIPickerView *)IELSTaveragePickerView
{
    if (!_IELSTaveragePickerView) {
        _IELSTaveragePickerView = [[UIPickerView alloc] init];
        _IELSTaveragePickerView.dataSource = self;
        _IELSTaveragePickerView.delegate = self;
        _IELSTaveragePickerView.tag = pickeTagAverage;
        //默认显示数组中index = 2的数据
        [_IELSTaveragePickerView selectRow:2 inComponent:0 animated:YES];
        
    }
    return _IELSTaveragePickerView;
}

-(UIPickerView *)XsubjectPickerView
{
    if (!_XsubjectPickerView) {
        _XsubjectPickerView = [[UIPickerView alloc] init];
        _XsubjectPickerView.dataSource = self;
        _XsubjectPickerView.delegate = self;
        _XsubjectPickerView.tag = pickeTagSubject;
 
    }
    return _XsubjectPickerView;
}

-(UIPickerView *)XapplySubjectPickerView
{
    if (!_XapplySubjectPickerView) {
        _XapplySubjectPickerView = [[UIPickerView alloc] init];
        _XapplySubjectPickerView.dataSource = self;
        _XapplySubjectPickerView.delegate = self;
        _XapplySubjectPickerView.tag = pickeTagApplySubject;
 
     }
    return _XapplySubjectPickerView;
}

//创建tableViewCell的数据
-(void)createTableCellData
{
    
//    _titles = @[@"毕业院校", @"在读专业", @"平均分", @"雅思平均分数", @"雅思最低分数", @"申请专业"];
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
        
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
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
    
     _universityTextField = universityTextField;
    _subjectTextField = subjectTextField;
    _scoreTextField = scoreTextField;
    _IELTSTextField = IELTSTextField;
    _IELTSMinTextField = IELTSMinTextField;
    
    _applySubjectTextField = applySubjectTextField;
    
    
    _IELTSMinTextField.inputView = self.IELSTminiPickerView;
    _IELTSTextField.inputView = self.IELSTaveragePickerView;
    _subjectTextField.inputView = self.XsubjectPickerView;
    _applySubjectTextField.inputView = self.XapplySubjectPickerView;
    _scoreTextField.keyboardType = UIKeyboardTypeDecimalPad;
    //监听
    [_scoreTextField addTarget:self action:@selector(scoreValueChange:) forControlEvents:UIControlEventEditingChanged];
    
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

    [self
     startAPIRequestWithSelector:kAPISelectorSubjects
     parameters:@{@":lang":GDLocalizedString(@"ch_Language")}
     success:^(NSInteger statusCode, NSArray *response) {
         _subjects = [response KD_arrayUsingMapEnumerateBlock:^id(NSDictionary *obj, NSUInteger idx)
                      {
                          return obj[@"name"];
                      }];
         
         //         [_subjectPickerView reloadAllComponents];
         //         [_applySubjectPickerView reloadAllComponents];
     }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.saveButton  setTitle:GDLocalizedString(@"Evaluate-0017") forState:UIControlStateNormal];
    [self pickDataSourse];
    [self createTableCellData];
    [self requestDataSource];
    
    _tableView.contentInset = UIEdgeInsetsMake(-10, 0, 50, 0);
    //    self.navigationItem.title = @"在线评估";
      self.navigationItem.title = GDLocalizedString(@"Evaluate-001");
    
}
//用于网络请求
-(void)requestDataSource
{
    if ([AppDelegate sharedDelegate].isLogin) {
        [self startAPIRequestUsingCacheWithSelector:@"GET api/account/evaluate" parameters:nil success:^(NSInteger statusCode, id response) {
            
            NSString *IELTSTstring = KDUtilStringGuard(response[@"ielts_avg"]);
            _IELTSTextField.text = IELTSTstring;
            if (IELTSTstring.length == 1) {
                _IELTSTextField.text = [NSString stringWithFormat:@"%@.0",IELTSTstring];
            }
            
            
            NSString *ministring = KDUtilStringGuard(response[@"ielts_low"]);
            _IELTSMinTextField.text = ministring;
            if (IELTSTstring.length == 1)
            {
                _IELTSMinTextField.text = [NSString stringWithFormat:@"%@.0",ministring];
            }
            
            
            _scoreTextField.text = KDUtilStringGuard(response[@"score"]);
            _subjectTextField.text = response[@"subject"];
            _universityTextField.text = response[@"university"];
            _applySubjectTextField.text = response[@"apply"];
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    
    NSString  *test = [[NSUserDefaults standardUserDefaults] valueForKey:@"isSignIn"];
    if ([test isEqualToString:@"不刷新"]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"刷新" forKey:@"isSignIn" ];
        [[NSUserDefaults standardUserDefaults]  synchronize];
    }
    else
    {
        [self requestDataSource];
    }
    
}


#pragma  Mark   UIPickerViewDataSource, UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (pickerView.tag == pickeTagMini) {
        
        return  _IELSTminiScores.count ;
    }else if (pickerView.tag == pickeTagAverage) {
        
        return  _IELSTaverageScores.count;
    }
    else
    {
        return _subjects.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (pickerView.tag == pickeTagMini)
    {
        
        return  _IELSTminiScores[row];
    }else if (pickerView.tag == pickeTagAverage) {
        
        return  _IELSTaverageScores[row];
    }
    else
    {
        return _subjects[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (pickerView.tag == pickeTagMini)
    {
        
        _IELTSMinTextField.text  = _IELSTminiScores[row];
        
    }else if (pickerView.tag == pickeTagAverage) {
        
        _IELTSTextField.text = _IELSTaverageScores[row];
    }
    else if (pickerView.tag == pickeTagSubject)
    {
        
        _subjectTextField.text = _subjects[row];
    }
    else
    {
        _applySubjectTextField.text = _subjects[row];
        
    }
    
}

#pragma  Mark   UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _titles.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _titles[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = _cells[indexPath.section];
    if (indexPath.section == 0) {
        UIButton *firstBtn =[[UIButton alloc] initWithFrame:cell.contentView.bounds];
        [firstBtn addTarget:self action:@selector(gotoCollegeSearch) forControlEvents:UIControlEventTouchUpInside];
        firstBtn.backgroundColor =[UIColor clearColor];
        [cell.contentView addSubview:firstBtn];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}


#pragma  Mark   UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    //用于设置textField的默认值
    if (textField == _subjectTextField || textField == _applySubjectTextField) {
        if (textField.text.length == 0) {
            textField.text = _subjects[0];
        }
    }else if(textField == _IELTSTextField || textField == _IELTSMinTextField)
    {
        if (textField.text.length == 0)
        {
            textField.text = _IELSTminiScores[0];
        }
    }
 }

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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

//提交填写信息
- (IBAction)submit {
    RequireLogin
    
    NSArray *textField = @[_universityTextField, _subjectTextField, _scoreTextField, _IELTSTextField, _IELTSMinTextField, _applySubjectTextField];
    
    for (UITextField *t in textField) {
        if (t.text.length == 0) {
            [KDAlertView showMessage:t.placeholder cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];
//           [KDAlertView showMessage:t.placeholder cancelButtonTitle:@"好的"];
            
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
//             [KDAlertView showMessage:@"重新查看大学列表会有惊喜哟！" cancelButtonTitle:@"好的"];
             [KDAlertView showMessage:GDLocalizedString(@"Evaluate-0015") cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];

         }
         
     }];
}


//跳转到学校搜索页面
-(void)gotoCollegeSearch
{
    EvaluateSearchCollegeViewController *searchVC =[[EvaluateSearchCollegeViewController alloc] initWithNibName:@"EvaluateSearchCollegeViewController" bundle:[NSBundle mainBundle]];
    
    searchVC.valueBlock = ^(NSString *test){
        
        _universityTextField.text =  test;
        
    };
    
    [self.navigationController pushViewController:searchVC animated:YES];
}

//监听 _scoreTextField 平均分是否起过100
-(void)scoreValueChange:(UITextField *)textField
{
    
    
    
    if (textField == _scoreTextField) {
        
        if ([textField.text integerValue] > 100) {
            
            _scoreTextField.text = @"100";
            
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
