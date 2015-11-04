//
//  CommitInfoViewController.m
//  MyOffer
//

#import "peronInfoItem.h"
#import "CommitInfoViewController.h"
#import "CommitTableViewCell.h"
#import "PersonSectionView.h"

@interface CommitInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *infoTableView;
@property(nonatomic,strong)NSArray *orderInfo;
@property(nonatomic,strong)UIView *NotiTableHeaderView;
@property(nonatomic,strong)NSArray *selectedCoursesIDs;
@property(nonatomic,strong)NSDictionary *userInfo;
@property(nonatomic,strong)NSArray *PersonInfoGroups;
@property(nonatomic,strong)UITextField  *countryTextF;
@property(nonatomic,strong)UITextField  *timeTextF;
@property(nonatomic,strong)UITextField  *miniTextF;
@property(nonatomic,strong)UITextField  *AVGTextF;
@property(nonatomic,strong)UITextField  *subjectTextF;
@property(nonatomic,strong)UITextField  *GradeTextF;
@property(nonatomic,strong)UITextField  *ApplySubjectTextF;
@property(nonatomic,strong)UITextField  *universityTextField;
@property(nonatomic,strong)UITextField  *scoreTextF;
@property(nonatomic,strong)UITextField  *phonenumberTextF;
@property(nonatomic,strong)UITextField  *lastTextF;
@property(nonatomic,strong)UITextField  *firstTextF;
@property(nonatomic,strong)UIPickerView *IELSTminiPickerView;
@property(nonatomic,strong)UIPickerView *IELSTaveragePickerView;
@property(nonatomic,strong)UIPickerView *timePicker;
@property(nonatomic,strong)UIPickerView *gradePicker;
@property(nonatomic,strong)UIPickerView *SubjectPickerView;
@property(nonatomic,strong)UIPickerView *ApplySubjectPicker;
@property(nonatomic,strong)NSArray *PlanTimes;
@property(nonatomic,strong)NSArray *gradelist;
@property(nonatomic,strong)NSArray *IELSTminiScores;
@property(nonatomic,strong)NSArray *IELSTaverageScores;
@property(nonatomic,strong)NSArray *subjects;
@property (weak, nonatomic) IBOutlet KDEasyTouchButton *commitButtonPressed;

@end

@implementation CommitInfoViewController
- (instancetype)initWithApplyInfo:(NSArray *)info selectedIDs:(NSArray *)courseIds {
    self = [self init];
    if (self) {
        self.orderInfo = info;
        self.selectedCoursesIDs = courseIds;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)pickDataSourse
{
    _IELSTminiScores = @[@"9.0",@"8.5",@"8.0",@"7.5",@"7.0",@"6.5",@"6.0",@"5.5",@"5.0",@"4.5",@"4.0",@"3.5",@"3.0",@"2.5",@"2.0",@"1.5",@"1.0",@"0.5",@"0"];
    
    _IELSTaverageScores = _IELSTminiScores;
  
    [self
     startAPIRequestWithSelector:kAPISelectorSubjects
     parameters:@{@":lang":GDLocalizedString(@"ch_Language")}
     success:^(NSInteger statusCode, NSArray *response) {
         _subjects = [response KD_arrayUsingMapEnumerateBlock:^id(NSDictionary *obj, NSUInteger idx)
                      {
                          return obj[@"name"];
                      }];
         [self.SubjectPickerView reloadAllComponents];
     }];
    
    
}
-(UIPickerView *)timePicker
{
    if(!_timePicker)
    {
        _timePicker = [[UIPickerView alloc] init];
        _timePicker.tag = 110;
        _timePicker.delegate = self;
        _timePicker.dataSource = self;
        //默认显示数组中index = 2的数据
        self.PlanTimes = @[@"2016",@"2017",@"2018",@"2019"];
        [_timePicker selectRow:1 inComponent:0 animated:YES];
    }
    return _timePicker;
}

-(UIPickerView *)IELSTminiPickerView
{
    if (!_IELSTminiPickerView) {
        _IELSTminiPickerView = [[UIPickerView alloc] init];
        _IELSTminiPickerView.dataSource = self;
        _IELSTminiPickerView.delegate = self;
        _IELSTminiPickerView.tag = 111;
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
        _IELSTaveragePickerView.tag = 112;
        //默认显示数组中index = 2的数据
        [_IELSTaveragePickerView selectRow:2 inComponent:0 animated:YES];
    }
    return _IELSTaveragePickerView;
}

-(UIPickerView *)SubjectPickerView
{
    if (!_SubjectPickerView) {
        _SubjectPickerView = [[UIPickerView alloc] init];
        _SubjectPickerView.dataSource = self;
        _SubjectPickerView.delegate = self;
        _SubjectPickerView.tag = 113;
        [_SubjectPickerView selectRow:2 inComponent:0 animated:YES];
    }
    return _SubjectPickerView;
}

-(UIPickerView *)ApplySubjectPicker
{
    if (!_ApplySubjectPicker) {
        _ApplySubjectPicker = [[UIPickerView alloc] init];
        _ApplySubjectPicker.dataSource = self;
        _ApplySubjectPicker.delegate = self;
        _ApplySubjectPicker.tag = 114;
        [_ApplySubjectPicker selectRow:2 inComponent:0 animated:YES];
    }
    return _ApplySubjectPicker;
}

-(UIPickerView *)gradePicker
{
    if (!_gradePicker) {
        _gradePicker = [[UIPickerView alloc] init];
        _gradePicker.tag = 115;
        _gradePicker.delegate = self;
        _gradePicker.dataSource = self;
        //默认显示数组中index = 2的数据
       
        NSString *lang = [InternationalControl userLanguage];
        if ([lang containsString:@"en"]) {
              self.gradelist=  @[@"Grade 4,undergraduate",@"Grade 3,undergraduate",@"Grade 2,undergraduate",@"Grade 1,undergraduate",@"Grade 3,senior middle school",@"Grade 2,senior middle school",@"Grade 1,senior middle school",@"Grade 3,junior middle school",@"Grade 2,senior middle school",@"Grade 1,senior middle school",@"Master graduate",@"Current Master student ",@"Bachelor graduate"];
        }
        else
        {
            self.gradelist=  @[@"本科毕业已工作",@"本科大四",@"本科大三",@"本科大二",@"本科大一",@"大专毕业三年以上",@"大专毕业三年以下",@"大专大三",@"大专大二",@"大专大一",@"高三毕业已工作",@"高三",@"高二",@"高一",@"初三",@"初二",@"初一"];

        }
        
        [_gradePicker selectRow:1 inComponent:0 animated:YES];
    }
    return _gradePicker;
}



-(NSArray *)PersonInfoGroups
{
    if (!_PersonInfoGroups) {
        
        
        [self startAPIRequestWithSelector:@"GET api/account/applicationdata" parameters:nil success:^(NSInteger statusCode, NSDictionary *response) {
             self.userInfo   = response;
             NSString *des_country = [response valueForKey:@"des_country"];
             CommitTableViewCell *countryCell = [[NSBundle mainBundle] loadNibNamed:@"CommitTableViewCell" owner:nil options:nil].lastObject;
            countryCell.contentTextF.inputAccessoryView = self.toolBar;
            self.countryTextF = countryCell.contentTextF;
            countryCell.contentTextF.placeholder = GDLocalizedString(@"ApplicationProfile-003"); //@"您想去的国家或地区";
            if (des_country.length != 0) {
                countryCell.contentTextF.text = des_country;
            }
            
            NSString *target_date = [response valueForKey:@"target_date"];
            CommitTableViewCell *dateCell = [[NSBundle mainBundle] loadNibNamed:@"CommitTableViewCell" owner:nil options:nil].lastObject;
            dateCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            dateCell.contentTextF.inputView = self.timePicker;
            dateCell.contentTextF.inputAccessoryView = self.toolBar;
            self.timeTextF = dateCell.contentTextF;
            dateCell.contentTextF.placeholder = GDLocalizedString(@"ApplicationProfile-004");//@"计划出国的日期";
            if (target_date.length != 0) {
                dateCell.contentTextF.text = target_date;
            }
           
             NSString *apply = [response valueForKey:@"apply"];
            CommitTableViewCell *applyCell = [[NSBundle mainBundle] loadNibNamed:@"CommitTableViewCell" owner:nil options:nil].lastObject;
            applyCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            applyCell.contentTextF.inputView = self.ApplySubjectPicker;
            applyCell.contentTextF.inputAccessoryView = self.toolBar;
            self.ApplySubjectTextF = applyCell.contentTextF;
            applyCell.contentTextF.placeholder =GDLocalizedString(@"ApplicationProfile-005"); //@"期望专业";
            if (apply.length != 0) {
                applyCell.contentTextF.text = apply;
            }
          
            NSArray *group001 = @[countryCell,dateCell,applyCell];
            
            
            NSString *first_name = [response valueForKey:@"first_name"];
            CommitTableViewCell *firstCell = [[NSBundle mainBundle] loadNibNamed:@"CommitTableViewCell" owner:nil options:nil].lastObject;
            firstCell.contentTextF.inputAccessoryView = self.toolBar;
            self.firstTextF = firstCell.contentTextF;
              firstCell.contentTextF.placeholder = GDLocalizedString(@"ApplicationProfile-firstName");//@"你的名字";
            if (first_name.length != 0) {
                firstCell.contentTextF.text = first_name;
            }
         
            
            NSString *last_name = [response valueForKey:@"last_name"];
            CommitTableViewCell *lastCell = [[NSBundle mainBundle] loadNibNamed:@"CommitTableViewCell" owner:nil options:nil].lastObject;
            lastCell.contentTextF.inputAccessoryView = self.toolBar;
            lastCell.contentTextF.placeholder = GDLocalizedString(@"ApplicationProfile-lastName");//@"你的姓氏";
            self.lastTextF = lastCell.contentTextF;
            if (last_name.length != 0) {
                lastCell.contentTextF.text = last_name;
            }
         
            
            NSString *phonenumber = [response valueForKey:@"phonenumber"];
            CommitTableViewCell *phonenumberCell = [[NSBundle mainBundle] loadNibNamed:@"CommitTableViewCell" owner:nil options:nil].lastObject;
            phonenumberCell.contentTextF.keyboardType = UIKeyboardTypeNumberPad;
            phonenumberCell.contentTextF.inputAccessoryView = self.toolBar;
 
            phonenumberCell.contentTextF.placeholder = GDLocalizedString(@"ApplicationProfile-phone");//@"您的手机号码";
            self.phonenumberTextF = phonenumberCell.contentTextF;
            if (phonenumber.length != 0) {
                phonenumberCell.contentTextF.text = phonenumber;
            }
          
 
            NSString *university = [response valueForKey:@"university"];
            CommitTableViewCell *universityCell = [[NSBundle mainBundle] loadNibNamed:@"CommitTableViewCell" owner:nil options:nil].lastObject;
            universityCell.contentTextF.inputAccessoryView = self.toolBar;
           universityCell.contentTextF.placeholder = GDLocalizedString(@"ApplicationProfile-007");//@"您就读的学校";
            self.universityTextField = universityCell.contentTextF;
            if (university.length != 0) {
                universityCell.contentTextF.text = university;
            }
        
            NSString *grade = [response valueForKey:@"grade"];
            CommitTableViewCell *gradeCell = [[NSBundle mainBundle] loadNibNamed:@"CommitTableViewCell" owner:nil options:nil].lastObject;
            gradeCell.contentTextF.inputAccessoryView = self.toolBar;
            gradeCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            gradeCell.contentTextF.inputView =self.gradePicker;
            self.GradeTextF = gradeCell.contentTextF;
            gradeCell.contentTextF.placeholder =  GDLocalizedString(@"ApplicationProfile-grade");//@"您就读的年级";
            if (grade.length != 0) {
                gradeCell.contentTextF.text = grade;
            }
              NSString *subject = [response valueForKey:@"subject"];
            
            CommitTableViewCell *subjectCell = [[NSBundle mainBundle] loadNibNamed:@"CommitTableViewCell" owner:nil options:nil].lastObject;
            subjectCell.contentTextF.inputAccessoryView = self.toolBar;
            subjectCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            self.subjectTextF = subjectCell.contentTextF;
            subjectCell.contentTextF.inputView= self.SubjectPickerView;
            subjectCell.contentTextF.placeholder = GDLocalizedString(@"ApplicationProfile-field"); //@"您就读的专业";
            if (subject.length != 0) {
                subjectCell.contentTextF.text = subject;
            }
            
 
            NSString *score = [response valueForKey:@"score"];
            NSString *scoreStr =[NSString stringWithFormat:@"%@",score];
            CommitTableViewCell *scoreCell = [[NSBundle mainBundle] loadNibNamed:@"CommitTableViewCell" owner:nil options:nil].lastObject;
            scoreCell.contentTextF.keyboardType = UIKeyboardTypeDecimalPad;
            scoreCell.contentTextF.inputAccessoryView = self.toolBar;
            [scoreCell.contentTextF addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
            scoreCell.contentTextF.placeholder = GDLocalizedString(@"ApplicationProfile-008"); //@"您的平均成绩";
            self.scoreTextF = scoreCell.contentTextF;
            if (![scoreStr containsString:@"null"]) {
                scoreCell.contentTextF.text = scoreStr;
            }
            
            NSString *ielts_avg = [response valueForKey:@"ielts_avg"];
            NSString *ielts_avgStr =[NSString stringWithFormat:@"%@",ielts_avg];
            CommitTableViewCell *avgCell = [[NSBundle mainBundle] loadNibNamed:@"CommitTableViewCell" owner:nil options:nil].lastObject;
            avgCell.contentTextF.inputAccessoryView = self.toolBar;
            avgCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            self.AVGTextF = avgCell.contentTextF;
            avgCell.contentTextF.inputView= self.IELSTaveragePickerView;
            avgCell.contentTextF.placeholder = GDLocalizedString(@"ApplicationProfile-009");//@"您的雅思平均成绩";
            if (![ielts_avgStr containsString:@"null"]) {
                 avgCell.contentTextF.text = ielts_avgStr;
            }
          
            
            NSString *ielts_low = [response valueForKey:@"ielts_low"];
            NSString *ielts_lowStr =[NSString stringWithFormat:@"%@",ielts_low];
            CommitTableViewCell *lowCell = [[NSBundle mainBundle] loadNibNamed:@"CommitTableViewCell" owner:nil options:nil].lastObject;
            lowCell.contentTextF.inputAccessoryView = self.toolBar;
            lowCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            lowCell.contentTextF.inputView= self.IELSTminiPickerView;
            self.miniTextF = lowCell.contentTextF;
            lowCell.contentTextF.placeholder =GDLocalizedString(@"ApplicationProfile-lowScore");// @"您的雅思最低分";
            if (![ielts_lowStr containsString:@"null"]) {
                lowCell.contentTextF.text = ielts_lowStr;
            }
          
            NSArray *group002 = @[firstCell,lastCell,phonenumberCell,universityCell,gradeCell,subjectCell,scoreCell,avgCell,lowCell];
            
            _PersonInfoGroups =  @[group001,group002];
            
            [self.infoTableView reloadData];
            
        }];
    }
    return _PersonInfoGroups;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self pickDataSourse];
    
   [ self.commitButtonPressed setTitle:GDLocalizedString(@"ApplicationProfile-0012") forState:UIControlStateNormal];
    //申请时提交个人资料]
    self.title = GDLocalizedString(@"ApplicationProfile-001");
 

    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [self makeHeaderView];//设置表头
    self.infoTableView.sectionFooterHeight = 0;
}
//设置表头
-(void)makeHeaderView
{
    self.NotiTableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPSIZE.width, 100)];
    UILabel *notiLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.NotiTableHeaderView.bounds.size.width - 20, 100)];
    notiLabel.text = GDLocalizedString(@"ApplicationProfile-0016");// @"亲，你离成功申请只差填写基本资料哦。
    notiLabel.adjustsFontSizeToFitWidth = YES;
    notiLabel.numberOfLines = 0;
    [self.NotiTableHeaderView addSubview:notiLabel];
    self.infoTableView.tableHeaderView = self.NotiTableHeaderView;
 }

#pragma mark UITableViewDatasoure   UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PersonSectionView *personSV =[[NSBundle mainBundle] loadNibNamed:@"PersonSectionView" owner:nil options:nil].lastObject;
    personSV.sectionNumber = section;
    return personSV;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.PersonInfoGroups.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *cells = self.PersonInfoGroups[section];
    return cells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *cells = self.PersonInfoGroups[indexPath.section];
    
    CommitTableViewCell *cell = cells[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
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
    
    UIEdgeInsets insets = self.infoTableView.contentInset;
    if (up) {
        insets.bottom = keyboardEndFrame.size.height;
    } else {
        insets.bottom = 50;
    }
    
    
    self.infoTableView.contentInset = insets;
    
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
}


#pragma  Mark   UIPickerViewDataSource, UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (pickerView.tag == 110) {
        
        return self.PlanTimes.count;
        
    }else if(pickerView.tag == 111)
    {
        return self.IELSTminiScores.count;
    }else if(pickerView.tag == 112)
    {
        return self.IELSTaverageScores.count;
    }else if (pickerView.tag ==113 || pickerView.tag ==114)
    {
        return self.subjects.count;
    }
    else
    {
        return self.gradelist.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (pickerView.tag == 110) {
        
        return self.PlanTimes[row];
        
    }else if(pickerView.tag == 111)
    {
        return self.IELSTminiScores[row];
    }else if(pickerView.tag == 112)
    {
        return self.IELSTaverageScores[row];
    }else if(pickerView.tag == 113  ||pickerView.tag == 114)
    {
        return self.subjects[row];
    }
    else{
        return  self.gradelist[row];
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (pickerView.tag == 110) {
        
        self.timeTextF.text = self.PlanTimes[row];
        
    }else if(pickerView.tag == 111)
    {
        self.miniTextF.text = self.IELSTminiScores[row];
        
    }else if(pickerView.tag == 112)
    {
        self.AVGTextF.text =   self.IELSTaverageScores[row];
    }else if(pickerView.tag ==113){
        self.subjectTextF.text = self.subjects[row];
        
    }else if(pickerView.tag == 114)
    {
        self.ApplySubjectTextF.text =  self.subjects[row];
    }else
    {
        self.GradeTextF.text =self.gradelist[row];
    }
}

-(void)textFieldValueChange:(UITextField *)sender
{
    if ( [sender.text floatValue] >100) {
        sender.text = @"100";
    }
}
- (IBAction)commitButtonPressed:(KDEasyTouchButton *)sender {
   
    RequireLogin
    
    NSArray *textFields = @[self.countryTextF, self.timeTextF,self.ApplySubjectTextF,self.firstTextF,self.lastTextF,self.phonenumberTextF,self.universityTextField,self.GradeTextF,self.subjectTextF,self.scoreTextF,self.AVGTextF,self.miniTextF];
    
    for (UITextField  *textField in textFields) {
        
        if (textField.text.length == 0) {
            
            [KDAlertView showMessage:textField.placeholder cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];//@"好的"];
            return;
        }
    }
    
    NSDictionary *parameters =  @{@"des_country":self.countryTextF.text,@"target_date":self.timeTextF.text,@"grade":self.GradeTextF.text,@"university":self.universityTextField.text,@"subject":self.subjectTextF.text,@"phonenumber":self.phonenumberTextF.text,@"apply":self.ApplySubjectTextF.text,@"score":self.scoreTextF.text,@"ielts_low":self.miniTextF.text,@"ielts_avg":self.AVGTextF.text,@"last_name":self.firstTextF.text,@"first_name":self.lastTextF.text};
    
    
    [self startAPIRequestWithSelector: @"POST api/account/applicationdata" parameters:@{@"applicationData":parameters} success:^(NSInteger statusCode, id response) {
        
        [self
         startAPIRequestWithSelector:@"POST /api/account/checkin"
         parameters:@{@"courseIds": self.selectedCoursesIDs}
         success:^(NSInteger statusCode, id response) {
             KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
             [hud applySuccessStyle];
             [hud setLabelText: GDLocalizedString(@"ApplicationProfile-0015")];//@"加入成功"];
             [hud hideAnimated:YES afterDelay:2];
             [hud setHiddenBlock:^(KDProgressHUD *hud) {
                 [self.navigationController popToRootViewControllerAnimated:YES];
                  //[self dismiss];
             }];
         }];
       }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
