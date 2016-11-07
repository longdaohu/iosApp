//
//  InteProfileViewController.m
//  myOffer
//
//  Created by sara on 15/12/27.
//  Copyright © 2015年 UVIC. All rights reserved.
//
#import "IntelligentResultViewController.h"
#import "InteProfileViewController.h"
#import "XprofileTableViewCell.h"
#import "CountryItem.h"
#import "GradeItem.h"
#import "SubjectItem.h"
#import "InputAccessoryToolBar.h"
#import "XWGJSummaryView.h"
#import "EvaluateSearchCollegeViewController.h"
#import "promptViewController.h"
#import "promptViewController.h"

#define Bottom_Height 50
typedef enum {
    countryPikerType = 109,
    timePikerType,
    applySubjectPikerType,
    SubjectPikerType,
    IELSTminiPickerType,
    IELSTaveragePikerType,
    gradePickerType
} pikerType;


@interface InteProfileViewController ()<InputAccessoryToolBarDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,XprofileTableViewCellDelegate>
@property(nonatomic,strong)UITableView *tableView;
//网络请求结果
@property(nonatomic,strong)NSDictionary *response;
//时间pick
@property(nonatomic,strong)UIPickerView *timePiker;
//国家pick
@property(nonatomic,strong)UIPickerView *countryPicker;
//年级pick
@property(nonatomic,strong)UIPickerView *gradePicker;
//意向专业pick
@property(nonatomic,strong)UIPickerView *applyPicker;
//就读专业pick
@property(nonatomic,strong)UIPickerView *subjectPicker;
//最低分数pick
@property(nonatomic,strong)UIPickerView *miniPicker;
//平均分pick
@property(nonatomic,strong)UIPickerView *avgPicker;
//国家TextField
@property (strong, nonatomic)  UITextField *countryTF;
//时间TextField
@property (strong, nonatomic)  UITextField *timeTF;
//申请意向TextField
@property (strong, nonatomic)  UITextField *applySubjectTF;
//学校TextField
@property (strong, nonatomic)  UITextField *universityTF;
//就读专业TextField
@property (strong, nonatomic)  UITextField *subjectedTF;
//平均分TextField
@property (strong, nonatomic)  UITextField *GPATF;
//年级TextField
@property (strong, nonatomic)  UITextField *gradeTF;
//平均TextField
@property (strong, nonatomic)  UITextField *avgTF;
//最低分TextField
@property (strong, nonatomic)  UITextField *lowTF;
//最低分数组
@property(nonatomic,strong)NSArray *miniItems;
//国家数组
@property(nonatomic,strong)NSArray *countryItems;
//国家中文分数组
@property(nonatomic,strong)NSArray *countryItems_CE;
//时间数组
@property(nonatomic,strong)NSArray *timeItems;
//专业数组
@property(nonatomic,strong)NSArray *subjectItems;
@property(nonatomic,strong)NSArray *subjectItems_CE;
//年级数组
@property(nonatomic,strong)NSArray *gradeItems;
@property(nonatomic,strong)NSArray *gradeItems_CE;
//提示页
@property(nonatomic,strong)promptViewController *prompVC;
//底部按钮
@property(nonatomic,strong)UIButton *bottomView;
//键盘工具条
@property(nonatomic,strong)InputAccessoryToolBar *toolView;

@end

@implementation InteProfileViewController


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page智能匹配"];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [MobClick beginLogPageView:@"page智能匹配"];
}

-(NSArray *)timeItems
{
    if (!_timeItems) {
        
        _timeItems = @[@"2016",@"2017",@"2018+"];
    }
    return _timeItems;
}


-(NSArray *)miniItems
{
    if (!_miniItems) {
        
        _miniItems = @[@"9",@"8.5",@"8",@"7.5",@"7",@"6.5",@"6",@"5.5",@"5",@"4.5",@"4",@"3.5",@"3",@"2.5",@"2",@"1.5",@"1",@"0.5",@"0"];
    }
    return _miniItems;
}

//请求匹配相关数据
-(void)getSelectionResourse
{
    
    NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
    
    NSArray *countryItems_CN = [[ud valueForKey:@"Country_CN"] KD_arrayUsingMapEnumerateBlock:^id(NSDictionary *obj, NSUInteger idx)
                                {
                                    CountryItem *item = [CountryItem CountryWithDictionary:obj];
                                    return item;
                                }];
    
    
    
    NSArray *countryItems_EN = [[ud valueForKey:@"Country_EN"] KD_arrayUsingMapEnumerateBlock:^id(NSDictionary *obj, NSUInteger idx)
                                {
                                    CountryItem *item = [CountryItem CountryWithDictionary:obj];
                                    return item;
                                }];
    
    
    self.countryItems_CE =  @[countryItems_CN,countryItems_EN];
    
    
    
    NSArray *subjectItems_CN = [[ud valueForKey:@"Subject_CN"] KD_arrayUsingMapEnumerateBlock:^id(NSDictionary *obj, NSUInteger idx)
                                {
                                    SubjectItem *item = [SubjectItem subjectWithDictionary:obj];
                                    return item;
                                }];
    NSArray *subjectItems_EN = [[ud valueForKey:@"Subject_EN"] KD_arrayUsingMapEnumerateBlock:^id(NSDictionary *obj, NSUInteger idx)
                                {
                                    SubjectItem *item = [SubjectItem subjectWithDictionary:obj];
                                    return item;
                                }];
    
    
    self.subjectItems_CE = @[subjectItems_CN,subjectItems_EN];
    
    
    
    NSArray *gradeItems_CN = [[ud valueForKey:@"Grade_CN"] KD_arrayUsingMapEnumerateBlock:^id(NSDictionary *obj, NSUInteger idx)
                              {
                                  GradeItem *item = [GradeItem gradeWithDictionary:obj];
                                  return item;
                              }];
    
    NSArray *gradeItems_EN = [[ud valueForKey:@"Grade_EN"] KD_arrayUsingMapEnumerateBlock:^id(NSDictionary *obj, NSUInteger idx)
                              {
                                  GradeItem *item = [GradeItem gradeWithDictionary:obj];
                                  return item;
                              }];
    
    self.gradeItems_CE =  @[gradeItems_CN,gradeItems_EN];
    
    
    if (USER_EN) {
        
        self.countryItems = self.countryItems_CE[1];
        self.subjectItems = self.subjectItems_CE[1];
        self.gradeItems = self.gradeItems_CE[1];
        
    }else{
        
        self.countryItems = self.countryItems_CE[0];
        self.subjectItems = self.subjectItems_CE[0];
        self.gradeItems = self.gradeItems_CE[0];
    }
    
}

//键盘辅助工具条
-(InputAccessoryToolBar *)toolView
{
    if (!_toolView) {
        
        _toolView =[[NSBundle mainBundle] loadNibNamed:@"InputAccessoryToolBar" owner:self options:nil].lastObject;
        _toolView.delegate = self;
        }
    return _toolView;
}


//创建UIPickerView快捷方式
-(UIPickerView *)createPickerViewWithTag:(pikerType)type
{
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.dataSource = self;
    picker.delegate = self;
    picker.tag = type;
   
    return picker;
}

//时间
-(UIPickerView *)timePiker
{
    if(!_timePiker)
    {
        _timePiker = [self createPickerViewWithTag:timePikerType];
 
    }
    return _timePiker;
}

//年级
-(UIPickerView *)gradePicker
{
    if(!_gradePicker)
    {
        _gradePicker = [self  createPickerViewWithTag:gradePickerType];

    }
    return _gradePicker;
}

//意向专业
-(UIPickerView *)applyPicker
{
    if(!_applyPicker)
    {
        _applyPicker = [self  createPickerViewWithTag:applySubjectPikerType];
     }
    return _applyPicker;
}

//就读专业
-(UIPickerView *)subjectPicker
{
    if(!_subjectPicker)
    {
         _subjectPicker = [self  createPickerViewWithTag:SubjectPikerType];
  
    }
    return _subjectPicker;
}

//最低分数
-(UIPickerView *)miniPicker
{
    if (!_miniPicker) {
        _miniPicker = [self  createPickerViewWithTag:IELSTminiPickerType];
       }
    return _miniPicker;
}
//平均分数
-(UIPickerView *)avgPicker
{
    if (!_avgPicker) {
 
        _avgPicker  = [self  createPickerViewWithTag:IELSTaveragePikerType];
 
    }
    return _avgPicker;
}
//国家
-(UIPickerView *)countryPicker
{
    if (!_countryPicker) {
        
        _countryPicker  = [self  createPickerViewWithTag:countryPikerType];
 
    }
    return _countryPicker;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
    
    [self requestDataSource];
    
    [self getSelectionResourse];
 
    [self makeOther];
    
}

-(void)makeOther{

    
    
    self.title = GDLocalizedString(@"Evaluate-inteligent");//@"智能匹配";

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    if (LOGIN) {
        
        //用于判断用户是否改变,当用户第一次进入时，会出现提示窗口
        [self startAPIRequestUsingCacheWithSelector:kAPISelectorAccountInfo parameters:nil success:^(NSInteger statusCode, id response) {
            
            
            NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
            
            NSString *tokenKey = response[@"accountInfo"][@"_id"];
            
            NSString *value = [ud valueForKey:tokenKey];
            
            
            if (!value) {
                
                [self prompViewAppear:YES]; //当没有数据时，出现智能匹配提示页面
                
                [ud setValue:[[AppDelegate sharedDelegate] accessToken] forKey:tokenKey];
                
                [ud synchronize];
            }
            
        }];

    }else{
    
        RequireLogin
     
    }
    
    
    
}

-(void)makeUI
{
    [self makeTableView];
    [self makeHeaderView];
    
}




-(void)makeTableView
{
    
    CGFloat bottomH = Bottom_Height;
    CGFloat tableX = 0;
    CGFloat tableY = 0;
    CGFloat tableW = XScreenWidth;
    CGFloat tableH = XScreenHeight - XNav_Height - bottomH;
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(tableX, tableY,tableW,tableH)];
    self.tableView.dataSource =self;
    self.tableView.delegate =self;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    self.tableView.backgroundColor = XCOLOR_BG;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self makeFooterViewWithBottonHeight:bottomH];
 }


//底部提交按钮
-(void)makeFooterViewWithBottonHeight:(CGFloat)height
{
    
    self.bottomView =[[UIButton alloc] initWithFrame:CGRectMake(0, XScreenHeight - XNav_Height - height, XScreenWidth, height)];
    self.bottomView.backgroundColor = XCOLOR_LIGHTGRAY;
    [self.bottomView addTarget:self action:@selector(commitButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView setTitle:GDLocalizedString(@"Evaluate-commitButton") forState:UIControlStateNormal];
    self.bottomView.titleLabel.font = FontWithSize(16);
    self.bottomView.enabled = NO;
    [self.view addSubview:self.bottomView];
}

//添加表头
-(void)makeHeaderView
{

    XWGJSummaryView *headerView = [XWGJSummaryView ViewWithContent:GDLocalizedString(@"Evaluate-AD")];
    self.tableView.tableHeaderView = headerView;
    
}


//用于网络数据请求
-(void)requestDataSource{
    
    if (!LOGIN) return;
    
        XWeakSelf
        [self startAPIRequestWithSelector:kAPISelectorZiZengPipeiGet  parameters:nil success:^(NSInteger statusCode, id response) {
            
              weakSelf.response = response;
            
              [weakSelf.tableView reloadData];
            
        }];
 }


#pragma mark ————  UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 498;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XprofileTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"XprofileTableViewCell" owner:self options:nil].lastObject;
    cell.delegate = self;
    
    cell.countryTF.inputAccessoryView = self.toolView;
    cell.timeTF.inputAccessoryView = self.toolView;
    cell.applySubjectTF.inputAccessoryView = self.toolView;
    cell.universityTF.inputAccessoryView = self.toolView;
    cell.subjectedTF.inputAccessoryView = self.toolView;
    cell.GPATF.inputAccessoryView = self.toolView;
    cell.gradeTF.inputAccessoryView = self.toolView;
    cell.lowTF.inputAccessoryView = self.toolView;
    cell.avgTF.inputAccessoryView = self.toolView;
    
    //意向国家
    self.countryTF = cell.countryTF;
    cell.countryTF.inputView = self.countryPicker;
    NSString *des_country = [NSString stringWithFormat:@"%@",self.response[@"des_country"]];
    NSString *country = [des_country containsString:@"null"]?@"":des_country;
    self.countryTF.text = !country.length?@"":[self getCountryLocalString:country];
    
    
    //出国时间
    cell.timeTF.inputView = self.timePiker;
    self.timeTF =  cell.timeTF;
    NSString *target_time = self.response[@"target_date"];
    NSInteger TimeIndex = 0;

    if([self.timeItems containsObject:target_time])
    {
        TimeIndex = [self.timeItems indexOfObject:target_time];
         self.timeTF.text = target_time;
    }
    [self.timePiker selectRow:TimeIndex inComponent:0 animated:YES];
    
    
    //就读学校
    NSString *universityStr = [NSString stringWithFormat:@"%@",self.response[@"university"]];
    cell.universityTF.text =  [universityStr containsString:@"null"] ?@"":universityStr;
    self.universityTF = cell.universityTF;
    
    //就读年级
    self.gradeTF = cell.gradeTF;
    self.gradeTF.inputView = self.gradePicker;
    NSString *grade =[NSString stringWithFormat:@"%@",self.response[@"grade"]];
    NSString *gradeStr = [grade containsString:@"null"]?@"":grade;
    self.gradeTF.text = gradeStr.length == 0 ? @"":[self getGradeLocalString:gradeStr];
    
    
    //GPA平均成绩
    NSString *GPAStr = [NSString stringWithFormat:@"%@",self.response[@"score"]];
    cell.GPATF.text = [GPAStr containsString:@"null"] ?@"":GPAStr;
    self.GPATF = cell.GPATF;
    
    
    //最近就读专业
    self.subjectedTF = cell.subjectedTF;
    cell.subjectedTF.inputView = self.subjectPicker;
    self.subjectedTF.text=  !self.response[@"subject"]?@"":[self getInSubjectLocalString:self.response[@"subject"]];
    
    
    //希望就读专业
    self.applySubjectTF = cell.applySubjectTF;
    cell.applySubjectTF.inputView = self.applyPicker;
    self.applySubjectTF.text = !self.response[@"apply"]?@"":[self getApplySubjectLocalString:self.response[@"apply"]];;
    
    
    
    //雅思平均成绩
    NSString *avgStr = [NSString stringWithFormat:@"%@",self.response[@"ielts_avg"]];
    cell.avgTF.text =   [avgStr containsString:@"null"] ?@"":avgStr;
    self.avgTF = cell.avgTF;
    cell.avgTF.inputView = self.avgPicker;
    if (![avgStr containsString:@"null"]) {
        NSInteger avgIndex = [self.miniItems indexOfObject:avgStr];
        [self.avgPicker selectRow:avgIndex inComponent:0 animated:YES];
    }
    
    //雅思最低分
    NSString *lowStr = [NSString stringWithFormat:@"%@",self.response[@"ielts_low"]];
    cell.lowTF.text = [lowStr containsString:@"null"] ?@"":lowStr;
    cell.lowTF.inputView = self.miniPicker;
    self.lowTF= cell.lowTF;
    if (![lowStr containsString:@"null"]) {
        NSInteger lowIndex = [self.miniItems indexOfObject:lowStr];
        [self.miniPicker selectRow:lowIndex inComponent:0 animated:YES];
    }
    
    [self checkTextField];
    
    return cell;
}



-(NSInteger)getIndexWithTextFieldName:(NSString *)ItemName andItems:(NSArray *)items andGroups:(NSArray *)groupCEs andKeyWord:(NSString *)key
{
    NSInteger Index = 0;
    
    if ([self validateNumberString:ItemName]) {
        
        NSArray *ItemIDs = [items valueForKeyPath:@"NOid"];
        
        Index = [ItemIDs containsObject:ItemName]?[ItemIDs indexOfObject: ItemName]:0;
        
    }else{
        
        NSArray *IDs_CNs = [groupCEs[0] valueForKeyPath:key];
        NSArray *IDs_ENs = [groupCEs[1]  valueForKeyPath:key];
        
        if ([IDs_CNs  containsObject:ItemName]) {
            
            Index = [IDs_CNs indexOfObject:ItemName];
            
        }else if([IDs_ENs containsObject:ItemName])
        {
            Index= [IDs_ENs indexOfObject:ItemName];
            
        }else
        {
            Index = 0;
        }
    }
    
    return Index;
}


//国家名称本地化
-(NSString *)getCountryLocalString:(NSString *)country{
    
    
    NSInteger index = [self getIndexWithTextFieldName:country andItems:self.countryItems andGroups:self.countryItems_CE andKeyWord:@"CountryName"];
    
    [self.countryPicker selectRow:index inComponent:0 animated:YES];
    
    
    CountryItem *cItem = self.countryItems.count ? self.countryItems[index] : nil;
  
    return cItem.CountryName;
}


//年级名称本地化
-(NSString *)getGradeLocalString:(NSString *)grade
{
    
    NSInteger gindex = [self getIndexWithTextFieldName:grade andItems:self.gradeItems andGroups:self.gradeItems_CE andKeyWord:@"gradeName"];
    
    [self.gradePicker selectRow:gindex inComponent:0 animated:YES];
    
    GradeItem *item = self.gradeItems.count ? [self.gradeItems objectAtIndex:gindex]: nil;
    
    return item.gradeName;
}

//apply专业名称本地化
-(NSString *)getApplySubjectLocalString:(NSString *)subject
{
    
    NSInteger index = [self getIndexWithTextFieldName:subject andItems:self.subjectItems andGroups:self.subjectItems_CE andKeyWord:@"subjectName"];
    
    [self.applyPicker selectRow:index inComponent:0 animated:YES];
    
    SubjectItem *item = self.subjectItems.count ? [self.subjectItems objectAtIndex:index]: nil;
    
    return item.subjectName;
}


//专业名称本地化
-(NSString *)getInSubjectLocalString:(NSString *)subject
{
    
    NSInteger index = [self getIndexWithTextFieldName:subject andItems:self.subjectItems andGroups:self.subjectItems_CE andKeyWord:@"subjectName"];
    
    [self.subjectPicker selectRow:index inComponent:0 animated:YES];
  
    SubjectItem *item = self.subjectItems.count ? [self.subjectItems objectAtIndex:index]: nil;
    
    return item.subjectName;
}


//用于判断提交过来的字符串是否是数字
-(BOOL)validateNumberString:(NSString *)preString
{
    NSString *Regex = @"[0-9]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [predicate evaluateWithObject:preString];
}


#pragma  Mark ------  UIPickerViewDataSource, UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

    switch (pickerView.tag) {
        case countryPikerType:
            return self.countryItems.count;
            break;
        case timePikerType:
            return self.timeItems.count;
            break;
        case applySubjectPikerType:
            return self.subjectItems.count;
            break;
        case SubjectPikerType:
            return self.subjectItems.count;
            break;
         case IELSTminiPickerType:  case IELSTaveragePikerType:
            return self.miniItems.count;
        default:
            return self.gradeItems.count;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    

    switch (pickerView.tag) {
        case countryPikerType:{
             CountryItem *item = self.countryItems[row];
             return  item.CountryName;
           }
            break;
        case timePikerType:
            return self.timeItems[row];
            break;
        case applySubjectPikerType:{
            SubjectItem *item = self.subjectItems[row];
            return item.subjectName;
        }
            break;
        case SubjectPikerType:{
            SubjectItem *item = self.subjectItems[row];
            return item.subjectName;
        }
            break;
        case IELSTminiPickerType:  case IELSTaveragePikerType:
            return self.miniItems[row];
        default:{
            GradeItem *item = self.gradeItems[row];
             return item.gradeName;
        }
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    switch (pickerView.tag) {
        case countryPikerType:
        {
            CountryItem *item = self.countryItems[row];
           self.countryTF.text =  item.CountryName;
        }
             break;
        case timePikerType:
            self.timeTF.text = self.timeItems[row];
            break;
        case applySubjectPikerType:{
         
             SubjectItem *item = self.subjectItems[row];
             self.applySubjectTF.text =  item.subjectName;
        }
             break;
        case SubjectPikerType:
        {
            SubjectItem *item = self.subjectItems[row];
            self.subjectedTF.text =  item.subjectName;
        }
             break;
        case IELSTminiPickerType:
            self.lowTF.text =self.miniItems[row];
            break;
        case IELSTaveragePikerType:
            self.avgTF.text =self.miniItems[row];
            break;
        default:{
            GradeItem *item = self.gradeItems[row];
            self.gradeTF.text = item.gradeName;
         }
            break;
    }

 }


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{

    [self textFieldeditingEndChectk];
    
}

#pragma mark ———— 用于键盘处理
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
    
    UIEdgeInsets insets = self.tableView.contentInset;
    
    insets.bottom = up ? keyboardEndFrame.size.height : 0;
    
    self.tableView.contentInset = insets;
    
    [self.view layoutSubviews];
    
    [UIView commitAnimations];
}


#pragma mark ———————— 提交数据
-(void)commitButtonPress:(UIButton *)sender
{
    
    RequireLogin
    
    NSInteger cindex = [self getCommitArrayIndex:self.countryItems withDataKey:@"CountryName"  andPredicateString:self.countryTF.text];
    CountryItem *cItem = [self.countryItems objectAtIndex:cindex];
    
    
    NSInteger gindex =[self getCommitArrayIndex:self.gradeItems withDataKey:@"gradeName" andPredicateString:self.gradeTF.text];
    GradeItem *gItem = [self.gradeItems objectAtIndex:gindex];
    
    
    
    NSInteger insindex = [self getCommitArrayIndex:self.subjectItems withDataKey:@"subjectName" andPredicateString:self.subjectedTF.text];
    
    SubjectItem *insItem = [self.subjectItems objectAtIndex:insindex];
    
    NSInteger apindex = [self getCommitArrayIndex:self.subjectItems withDataKey:@"subjectName" andPredicateString:self.applySubjectTF.text];//[subjects
    SubjectItem *apItem = [self.subjectItems objectAtIndex:apindex];
    
    
    NSDictionary *parameters =  @{@"des_country":cItem.NOid,@"target_date":self.timeTF.text,@"grade":gItem.NOid,@"university":self.universityTF.text,@"subject":insItem.NOid,@"apply":apItem.NOid,@"score":self.GPATF.text,@"ielts_low":self.lowTF.text,@"ielts_avg":self.avgTF.text};
    
    
 
    [self
     startAPIRequestWithSelector:kAPISelectorZiZengPipeiPost
     parameters:parameters
     success:^(NSInteger statusCode, id response) {
         
              IntelligentResultViewController *resultVC =[[IntelligentResultViewController alloc] initWithNibName:@"IntelligentResultViewController" bundle:nil];
              resultVC.isComeBack = YES;
             [self.navigationController pushViewController:resultVC animated:YES];
         
     }];
    
}

-(NSInteger)getCommitArrayIndex:(NSArray *)dataArray withDataKey:(NSString *)key andPredicateString:(NSString *)PreKey
{
    NSArray *DataIDs = [dataArray valueForKeyPath:key];
    
    NSInteger index  = [DataIDs indexOfObject:PreKey];
    
    return index;
}


//提示页面
- (promptViewController *)prompVC{

    if (!_prompVC) {
        
        XWeakSelf
        _prompVC = [[promptViewController alloc] initWithBlock:^{
            
            [weakSelf prompViewAppear:NO];
            
        }];
        
        _prompVC.view.frame = CGRectMake(0, XScreenHeight, XScreenWidth, XScreenHeight);
        
    }
    
    return _prompVC;
}


//当没有数据时，出现智能匹配提示页面
- (void)prompViewAppear:(BOOL)appear{

    if (appear) {
        
        [[UIApplication sharedApplication].windows.lastObject addSubview:self.prompVC.view];
        
    }
 
    CGFloat prompTop = appear ? 0 : XScreenHeight;
    
    CGFloat prompAlpha = appear ? 1 : 0;
    
    [UIView animateWithDuration:0.5 animations:^{

        if (!appear) {
            
            [self.navigationController setNavigationBarHidden:NO];
            
        }
        
        self.prompVC.view.top = prompTop;
        self.prompVC.view.alpha = prompAlpha;
        
    } completion:^(BOOL finished) {
        
        if (!appear) {
            
            [self.prompVC.view removeFromSuperview];
            
        }else{
        
            [self.navigationController setNavigationBarHidden:YES animated:NO];

        }
        
    }];
    
    
}

//键盘辅助工具条,实现键盘隐藏、键盘跳转
-(void)tabBarDidSelectWithItem:(UIBarButtonItem *)item
{
    if (item.tag == 10) {
        
        [self textFieldeditingEndChectk];
        
    }else{
        if ([self.countryTF isFirstResponder]) {
            
            [self.timeTF becomeFirstResponder];
            
        }else if ([self.timeTF isFirstResponder])
        {
            [self.applySubjectTF becomeFirstResponder];
            
        }else if([self.applySubjectTF isFirstResponder])
        {
            [self.universityTF becomeFirstResponder];
            
        }else if([self.universityTF isFirstResponder]){
            
            [self.subjectedTF becomeFirstResponder];
            
        }else if ([self.subjectedTF isFirstResponder])
        {
            [self.GPATF becomeFirstResponder];
        
         }else if([self.GPATF isFirstResponder]){
           
             [self.gradeTF becomeFirstResponder];
             
        }else if([self.gradeTF isFirstResponder]){
            
            [self.avgTF becomeFirstResponder];
            
        }else if([self.avgTF isFirstResponder]){
            
            [self.lowTF becomeFirstResponder];
            
        }else
        {
            [self textFieldeditingEndChectk];
        }
    }
}


#pragma mark ————  UITextfieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
   
    if ([self.countryTF isFirstResponder] ) {
        
        if (self.countryTF.text.length == 0) {

            CountryItem *item = self.countryItems.count ? self.countryItems[0] : nil;
            
            self.countryTF.text = item.CountryName ? item.CountryName : @"";
            
        }
        
    }else if ([self.timeTF isFirstResponder])
    {
        if (self.timeTF.text.length == 0) {
 
             self.timeTF.text = self.timeItems.count ? self.timeItems[0] : @"";
         }
        
    }else if([self.applySubjectTF isFirstResponder])
    {
        if (self.applySubjectTF.text.length == 0) {
            
            SubjectItem *subjectItem =  self.subjectItems.count ? self.subjectItems[0] : nil;
 
            self.applySubjectTF.text = subjectItem.subjectName ? subjectItem.subjectName : @"";
        }
        
    }else if([self.universityTF isFirstResponder]){
        

        
    }else if ([self.subjectedTF isFirstResponder])
    {
        if (self.subjectedTF.text.length == 0) {
            
             SubjectItem *subjectItem =  self.subjectItems.count ? self.subjectItems[0] : nil;

            self.subjectedTF.text = subjectItem.subjectName ? subjectItem.subjectName : @"";
        }
        
    }else if([self.GPATF isFirstResponder]){
        
        
        
    }else if([self.gradeTF isFirstResponder]){
        
        if (self.gradeTF.text.length == 0) {
            
            GradeItem  *gItem = self.gradeItems.count ? self.gradeItems[0] : nil;
 
            self.gradeTF.text =  gItem.gradeName ? gItem.gradeName : @"";
        }
    }else if([self.avgTF isFirstResponder]){
        
        if (self.avgTF.text.length == 0) {
            
            self.avgTF.text = self.miniItems.count ? self.miniItems[0] : @"";
            
        }
        
    }else
    {
        if (self.lowTF.text.length == 0) {
            
            self.lowTF.text = self.miniItems.count ? self.miniItems[0] : @"";
        }
    }
  
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    [self checkTextField];

}


#pragma mark ————  XprofileTableViewCellDelegate

-(void)XprofileTableViewCell:(XprofileTableViewCell *)tableViewCell  WithButtonItem:(UIButton *)sender{

    EvaluateSearchCollegeViewController *search =[[EvaluateSearchCollegeViewController alloc] initWithNibName:@"EvaluateSearchCollegeViewController" bundle:nil];
   
    search.valueBlock = ^(NSString *value){
    
        tableViewCell.universityTF.text = value;
        
    };
    
    [self.navigationController pushViewController:search animated:YES];
}




//用于键盘收起时，检验输入框是否为空
- (void)textFieldeditingEndChectk{
    
    [self checkTextField];
    
    [self.view endEditing:YES];
}

//判断提交按钮是否可用
- (void)checkTextField{
    
    
    if (self.countryTF.text.length  && self.timeTF.text.length  && self.applySubjectTF.text.length  && self.universityTF.text.length  && self.subjectedTF.text.length  && self.GPATF.text.length  && self.gradeTF.text.length  &&  self.avgTF.text.length &&  self.lowTF.text.length) {
        
        self.bottomView.enabled = YES;
        self.bottomView.backgroundColor = XCOLOR_RED;
    }else{
        self.bottomView.enabled = NO;
        self.bottomView.backgroundColor = XCOLOR_LIGHTGRAY;
    }
    
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    KDClassLog(@"智能匹配 dealloc");
}
//    KDUtilRemoveNotificationCenterObserverDealloc

@end
