//
//  UniversitySearchViewController.m
//  MyOffer
//
//  Created by xuewuguojie on 15/10/9.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "UniversitySearchViewController.h"

@interface UniversitySearchViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITextField *gradeTextF;
@property (weak, nonatomic) IBOutlet UITextField *subjectTextF;
@property(nonatomic,strong)NSArray *schoolList;
@property(nonatomic,strong)NSArray *resultList;
@property(nonatomic,strong)UITableView *schoolTable;
@property(nonatomic,strong)UIPickerView *timePicker;
@property(nonatomic,strong)NSArray *gradelist;
@property(nonatomic,strong)UIPickerView *subjectPicker;
@property(nonatomic,strong)NSArray *SubjectList;
@property (weak, nonatomic) IBOutlet KDEasyTouchButton *commitButton;

@property (weak, nonatomic) IBOutlet UILabel *BIYELabel;
@property (weak, nonatomic) IBOutlet UILabel *GradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *SubjectLabel;


@end

@implementation UniversitySearchViewController

-(UIPickerView *)timePicker
{
    if (!_timePicker) {
        _timePicker = [[UIPickerView alloc] init];
        _timePicker.tag = 11;
        _timePicker.delegate = self;
        _timePicker.dataSource = self;
        //默认显示数组中index = 2的数据
        self.gradelist=  @[@"本科大四",@"本科大三",@"本科大二",@"本科大一",@"大专毕业三年以上",@"大专毕业三年以下",@"大专大三",@"大专大二",@"大专大一",@"高三毕业已工作",@"高三",@"高二",@"高一",@"初三",@"初二",@"初一"];
        [_timePicker selectRow:1 inComponent:0 animated:YES];
    }
    return _timePicker;
}


-(UIPickerView *)subjectPicker
{
    if (!_subjectPicker) {
        _subjectPicker = [[UIPickerView alloc] init];
        _subjectPicker.tag = 10;
        _subjectPicker.delegate = self;
        _subjectPicker.dataSource = self;
        //默认显示数组中index = 2的数据
        self.SubjectList = @[@"经济与金融",@"农学",@"社会科学",@"工程学",@"艺术与设计",@"理学",@"商科",@"医学",@"人文科学",@"教育学"];
        [_subjectPicker selectRow:1 inComponent:0 animated:YES];
    }
    return _subjectPicker;
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.searchTextField becomeFirstResponder];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.timePicker = nil;
    self.subjectPicker = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     [self.commitButton setTitle:GDLocalizedString(@"Evaluate-0017") forState:UIControlStateNormal];
    //教育背景
 
    
    self.BIYELabel.text = GDLocalizedString(@"UniversityBG-001");
    self.GradeLabel.text = GDLocalizedString(@"UniversityBG-002");
    self.SubjectLabel.text = GDLocalizedString(@"UniversityBG-003");
    self.title = GDLocalizedString(@"UniversityBG-004");
    
    
    self.commitButton.backgroundColor = [UIColor colorWithRed:229.0/255 green:12.0/255 blue:105.0/255 alpha:1];
    
    [self.searchTextField addTarget:self action:@selector(ValueChangeTextField:) forControlEvents:UIControlEventEditingChanged];
    [self createSearchSource];
    [self makeViewUI];
    self.gradeTextF.inputView  = self.timePicker;
    self.subjectTextF.inputView  = self.subjectPicker;
    
    self.searchTextField.text =  [self.userInfo valueForKey:@"university"];
    self.gradeTextF.text =  [self.userInfo valueForKey:@"grade"];
    self.subjectTextF.text =  [self.userInfo valueForKey:@"subject"];
    
    
    
    
}

-(void)ValueChangeTextField:(UITextField *)sender
{
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", sender.text];
    self.resultList = [self.schoolList filteredArrayUsingPredicate:pred];
    
    
    if ( self.resultList.count == 0 ) {
        
        self.schoolTable.hidden = YES;
    }else
    {
        self.schoolTable.hidden = NO;
        [self.schoolTable reloadData];
        
    }
    
}

#pragma mark


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"country"];
    if (!cell) {
        cell =[[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"country"];
    }
    
    cell.textLabel.text = self.resultList[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    self.searchTextField.text = self.resultList[indexPath.row];
    self.schoolTable.hidden = YES;
    [self.view endEditing:YES];

}

-(void)makeViewUI
{
     self.schoolTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64+88, APPSIZE.width, APPSIZE.height- 64+88)];
    self.schoolTable.dataSource = self;
    self.schoolTable.delegate = self;
    [self.view addSubview:self.schoolTable];
    self.schoolTable.hidden = YES;
    
}



-(void)createSearchSource
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"collegelist" ofType:nil];
    NSData *fileData = [NSData dataWithContentsOfFile:path];
    NSString *pathString = [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    NSString *noHeaderPath = [pathString stringByReplacingOccurrencesOfString:@"\[\"" withString:@""];
    NSString *noFooterpath = [noHeaderPath stringByReplacingOccurrencesOfString:@"\"]" withString:@""];
    self.schoolList = [noFooterpath componentsSeparatedByString:@"\",\""];
}



#pragma  Mark   UIPickerViewDataSource, UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (pickerView.tag == 11) {
        
        return  self.gradelist.count;
    }else{
        
        return  self.SubjectList.count;

    }
    
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    
    if (pickerView.tag == 11) {
        
        return self.gradelist[row];
    }else{
        
        return  self.SubjectList[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (pickerView.tag == 11) {
        
        self.gradeTextF.text =  self.gradelist[row];

    }else{
        
        self.subjectTextF.text = self.SubjectList[row];
        [self.view endEditing:YES];

    }
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

 - (IBAction)saveButtonPressed:(KDEasyTouchButton *)sender {
    
     if (self.searchTextField.text.length == 0) {
         [KDAlertView showMessage:@"学校名称不能为空" cancelButtonTitle:@"好的"];
         return;
     }
     
     if (self.gradeTextF.text.length == 0) {
         [KDAlertView showMessage:@"在读年级不能为空" cancelButtonTitle:@"好的"];
         return;
     }
     
     if (self.subjectTextF.text.length == 0) {
         [KDAlertView showMessage:@"在读专业不能为空" cancelButtonTitle:@"好的"];
         return;
     }
     
     
     
    [self startAPIRequestWithSelector: @"POST api/account/applicationdata" parameters:@{@"applicationData":@{@"university":self.searchTextField.text,@"grade":self.gradeTextF.text,@"subject":self.subjectTextF.text,}} success:^(NSInteger statusCode, id response) {
        
        KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
        [hud applySuccessStyle];
        [hud hideAnimated:YES afterDelay:1];
        [hud setHiddenBlock:^(KDProgressHUD *hud) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    }];
}




@end
