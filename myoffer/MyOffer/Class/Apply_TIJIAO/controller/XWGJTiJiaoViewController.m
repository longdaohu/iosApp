//
//  XWGJTiJiaoViewController.m
//  myOffer
//
//  Created by xuewuguojie on 16/2/25.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "XWGJTiJiaoViewController.h"
#import "XWGJTJSectionGroup.h"
#import "ZhiXunCell.h"
#import "XWGJSectionHeaderView.h"
#import "CountryItem.h"
#import "SubjectItem.h"
#import "GradeItem.h"
#import "WYLXHeaderView.h"
#import "TiJiaoFooterView.h"
#import "UpgradeViewController.h"
#import "EvaluateSearchCollegeViewController.h"
#import "WYLXGroup.h"

typedef enum {
    PickerViewTypeCountry = 109,
    PickerViewTypeTime = 110,
    PickerViewTypeApply = 111,
    PickerViewTypeSubject = 112,
    PickerViewTypeGrade = 113,
    PickerViewTypeAvg = 114,
    PickerViewTypeLow = 115
}PickerViewType;//表头按钮选项


@interface XWGJTiJiaoViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,ZiXunCellDelegate>
@property(nonatomic,strong)UITableView *tableView;
//数据源
@property(nonatomic,strong)NSArray *editGroups;
//正在编辑的cell
@property(nonatomic,strong)UITableViewCell *editingCell;

//CountryPicker 国家picker  //TimePicker 时间picker
//SubjectPicker ApplyPicker 专业picker   GradePicker 年级picker      AVGPicker 平均分picker       LowPicker 最低分picker
@property(nonatomic,strong)UIPickerView  *CountryPicker,*TimePicker,*ApplyPicker,*SubjectPicker,*GradePicker,*AVGPicker,*LowPicker;
//专业数组  //年级数组  //专业数组  //国家数组   //雅思成绩
@property(nonatomic,strong)NSArray *ApplyTimes,*gradeItems, *ApplyItems,*countryItems,*IELSTScores;
//国家中文数组 //专业数组  //年级数组
@property(nonatomic,strong)NSArray *countryItems_CE,*subjectItems_CE, *gradeItems_CE;
//提交申请按钮
//@property(nonatomic,strong)UIButton *commitBtn;
//升级VC
@property(nonatomic,strong)UpgradeViewController *upgateVC;

@property(nonatomic,copy)NSString *universityName;

@end

@implementation XWGJTiJiaoViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"page提交申请"];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}



- (void)viewWillDisappear:(BOOL)animated
{
  
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page提交申请"];
    
}

-(UpgradeViewController *)upgateVC{

    if (!_upgateVC) {
        
        _upgateVC    = [[UpgradeViewController alloc] init];
        _upgateVC.view.frame = CGRectMake(0, XSCREEN_HEIGHT, XSCREEN_WIDTH, XSCREEN_HEIGHT);
        [self.view addSubview:_upgateVC.view];
        
    }
    return _upgateVC;
}


-(UIPickerView *)PickerViewWithTag:(PickerViewType)type
{
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.dataSource    = self;
    picker.delegate      = self;
    picker.tag           = type;
    return picker;
}

//国家picker
-(UIPickerView *)CountryPicker
{
    if (!_CountryPicker) {
        
        _CountryPicker = [self PickerViewWithTag:PickerViewTypeCountry];
        
    }
    return _CountryPicker;
}

//时间picker
-(UIPickerView *)TimePicker
{
    if (!_TimePicker) {
        
        _TimePicker = [self PickerViewWithTag:PickerViewTypeTime];
        
    }
    return _TimePicker;
}

//专业picker
-(UIPickerView *)ApplyPicker
{
    if (!_ApplyPicker) {
        
        _ApplyPicker = [self PickerViewWithTag:PickerViewTypeApply];
        
    }
    return _ApplyPicker;
}

//就读专业picker
-(UIPickerView *)SubjectPicker
{
    if (!_SubjectPicker) {
        
        _SubjectPicker = [self PickerViewWithTag:PickerViewTypeSubject];
        
    }
    return _SubjectPicker;
}
//年级picker
-(UIPickerView *)GradePicker
{
    if (!_GradePicker) {
        
        _GradePicker = [self PickerViewWithTag:PickerViewTypeGrade];
        
    }
    return _GradePicker;
}
//平均分picker
-(UIPickerView *)AVGPicker
{
    if (!_AVGPicker) {
        
        _AVGPicker = [self PickerViewWithTag:PickerViewTypeAvg];
        
    }
    return _AVGPicker;
}

//最低分picker
-(UIPickerView *)LowPicker
{
    if (!_LowPicker) {
        
        _LowPicker = [self PickerViewWithTag:PickerViewTypeLow];
        
    }
    return _LowPicker;
}

//时间数组
-(NSArray *)ApplyTimes
{
    if (!_ApplyTimes) {
        
       _ApplyTimes = @[@"2017",@"2018",@"2019+"];

    }
    return _ApplyTimes;
}

//分数数组
-(NSArray *)IELSTScores
{
    if (!_IELSTScores) {
        
        _IELSTScores = @[@"9",@"8.5",@"8",@"7.5",@"7",@"6.5",@"6",@"5.5",@"5",@"4.5",@"4",@"3.5",@"3",@"2.5",@"2",@"1.5",@"1",@"0.5",@"0"];
    
    }
    return _IELSTScores;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
    
    [self makeBaseSourse];
    
}


-(void)makeUI
{

    [self makeTableView];
    
    [self makeFooterView];
    
    [self makeOther];
    
}

-(void)makeOther
{
    self.title =  GDLocalizedString(@"TiJiao-Title");
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self addChildViewController:self.upgateVC];
    
    //加载用户已购买套餐数据
    [self startAPIRequestWithSelector:@"GET /api/account/sp" parameters:nil success:^(NSInteger statusCode, id response) {
        
        self.upgateVC.serviceResponse = response;
        
    }];

}


-(void)makeTableView
{
    UITableView  *tableView =  [[UITableView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, XSCREEN_HEIGHT - XNAV_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView   = tableView;
    tableView.dataSource  = self;
    tableView.delegate    = self;
    [self.view addSubview:self.tableView];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    tableView.allowsSelection = NO;
    
    [self makeHeaderView];
}


//添加表头
-(void)makeHeaderView{
    
    WYLXHeaderView *headerView =[WYLXHeaderView headViewWithTitle:@"只需补充基本资料，剩下的交给myOffer资深顾问定制属于你的绝绝佳留学方案。"];
    headerView.mj_y = - XNAV_HEIGHT;
    [self.view insertSubview:headerView aboveSubview:self.tableView];
    self.tableView.contentInset = UIEdgeInsetsMake(headerView.mj_h - XNAV_HEIGHT, 0, 0, 0);
    
}


//添加表尾
-(void)makeFooterView
{
    XWeakSelf
    TiJiaoFooterView *footerView   = [TiJiaoFooterView footerWithContent:GDLocalizedString(@"ApplicationProfile-footer") actionBlock:^(UIButton *sender) {
        
        [weakSelf  TiJiaoFooterViewItemOnClick:sender];
        
    }];
    
    self.tableView.tableFooterView = footerView;
}




- (NSArray *)editGroups{

    if (!_editGroups) {
        
        WYLXGroup *lastName_cell   =  [WYLXGroup groupWithType:EditTypeDefault title:@"姓" placeHolder:@"例如：韩" content:nil groupKey:@"last_name" spod:NO];
        WYLXGroup *firstName_cell   =  [WYLXGroup groupWithType:EditTypeDefault title:@"名" placeHolder:@"例如：梅梅" content:nil groupKey:@"first_name" spod:NO];
        WYLXGroup *phone_cell   =  [WYLXGroup groupWithType:EditTypePhoneNomal title:@"联系电话" placeHolder:@"请输入手机号码" content:nil groupKey:@"phonenumber" spod:NO];
        WYLXGroup *country_cell   =  [WYLXGroup groupWithType:EditTypeCountry title:@"国家目的地" placeHolder:@"英国" content:nil groupKey:@"des_country" spod:true];
        WYLXGroup *plan_time_cell   =  [WYLXGroup groupWithType:EditTypeTime title:@"计划出国时间" placeHolder:@"2017" content:nil groupKey:@"target_date" spod:true];
        WYLXGroup *plan_subject_cell   =  [WYLXGroup groupWithType:EditTypeSujectplan title:@"希望就读专业" placeHolder:@"经济与金融" content:nil groupKey:@"apply" spod:true];
     
        WYLXGroup *uni_cell   =  [WYLXGroup groupWithType:EditTypeUniversity title:@"最近就读学校" placeHolder:@"例如：英国大学" content:nil groupKey:@"university" spod:NO];

        WYLXGroup *in_subject_cell   =  [WYLXGroup groupWithType:EditTypeSuject title:@"就读专业" placeHolder:@"经济与金融" content:nil groupKey:@"subject" spod:NO];

        WYLXGroup *GPA_cell   =  [WYLXGroup groupWithType:EditTypeSCore title:@"GPA平均成绩（百分制）" placeHolder:@"例如：80" content:nil groupKey:@"score" spod:NO];

        WYLXGroup *grade_cell   =  [WYLXGroup groupWithType:EditTypeGrade title:@"就读年级" placeHolder:@"本科大四" content:nil groupKey:@"grade" spod:NO];

        WYLXGroup *avg_cell   =  [WYLXGroup groupWithType:EditTypeYSavg title:@"雅思平均分" placeHolder:@"例如：8" content:nil groupKey:@"ielts_avg" spod:NO];
        WYLXGroup *lowest_cell   =  [WYLXGroup groupWithType:EditTypeYSlower title:@"雅思最低分" placeHolder:@"例如：8" content:nil groupKey:@"ielts_low" spod:NO];

      
        
        NSArray *FirstSections   =  @[lastName_cell,firstName_cell,phone_cell];
        XWGJTJSectionGroup *JBgroup = [XWGJTJSectionGroup groupInitWithTitle:@"填写基本信息"  celles:FirstSections];
        
        
        NSArray *SecondSetions   = @[country_cell,plan_time_cell,plan_subject_cell];
        XWGJTJSectionGroup *YXgroup = [XWGJTJSectionGroup groupInitWithTitle:@"填写留学意向"  celles:SecondSetions];
        
        
        NSArray *ThirdSetions   =  @[uni_cell,in_subject_cell,GPA_cell,grade_cell,avg_cell,lowest_cell];
        XWGJTJSectionGroup *BJgroup = [XWGJTJSectionGroup groupInitWithTitle:@"填写背景资料" celles:ThirdSetions];

        
        _editGroups = @[JBgroup,YXgroup,BJgroup];
        
        
        
        
        XWeakSelf
        
        [self startAPIRequestWithSelector:@"GET api/account/applicationdata" parameters:nil success:^(NSInteger statusCode, NSDictionary *response) {
            
            //姓名
            lastName_cell.content   = response[@"last_name"];
            firstName_cell.content  = response[@"first_name"];
            //手机号码
            phone_cell.content  = response[@"phonenumber"];
            //国家
            NSString *des_country = [NSString stringWithFormat:@"%@",response[@"des_country"]];
            NSString *country     = [des_country containsString:@"null"]?@"":des_country;
            country_cell.content = !country.length?@"":[self getCountryLocalString:country];
            
            //出国时间
            NSString *target_time = response[@"target_date"];
            NSInteger TimeIndex   = 0;
            if([weakSelf.ApplyTimes containsObject:target_time])
            {
                TimeIndex         = [weakSelf.ApplyTimes indexOfObject:target_time];
                plan_time_cell.content = target_time;
            }
            [weakSelf.TimePicker selectRow:TimeIndex inComponent:0 animated:YES];
            
            //专业
            plan_subject_cell.content    = !response[@"apply"] ? @"" : [weakSelf getApplySubjectLocalString:response[@"apply"]];;
            //专业
            in_subject_cell.content    =  !response[@"subject"]?@"": [weakSelf getInSubjectLocalString:response[@"subject"]];
            //学校名称
            uni_cell.content =  response[@"university"];
            
            //平均成绩
            NSString *GPA    = [NSString stringWithFormat:@"%@",response[@"score"]];
            GPA_cell.content   = [GPA containsString:@"null"]?@"":GPA;
            //年级
            NSString *grade    = [NSString stringWithFormat:@"%@",response[@"grade"]];
            NSString *gradeStr = [grade containsString:@"null"]?@"":grade;
            grade_cell.content = gradeStr.length == 0 ? @"":[weakSelf getGradeLocalString:gradeStr];
            //雅思平均分
            NSString *avg      = [NSString stringWithFormat:@"%@",response[@"ielts_avg"]];
            NSString *avgStr   = [avg containsString:@"null"]?@"":avg;
            avg_cell.content   = avgStr.length == 0 ? @"" : avgStr;
            if (avgStr.length) {
                
                NSInteger avgIndex = [weakSelf.IELSTScores containsObject:avgStr] ? [weakSelf.IELSTScores indexOfObject:avgStr]:0;
                [weakSelf.AVGPicker selectRow:avgIndex inComponent:0 animated:YES];
            }
            
            //最低分
            NSString *Low    = [NSString stringWithFormat:@"%@",response[@"ielts_low"]];
            NSString *LowStr = [Low containsString:@"null"]?@"":Low;
            lowest_cell.content =   LowStr.length == 0 ? @"" : LowStr;
            if (LowStr.length) {
                
                NSInteger LowIndex = [weakSelf.IELSTScores containsObject:LowStr]?[weakSelf.IELSTScores indexOfObject:LowStr]:0;
                [weakSelf.LowPicker selectRow:LowIndex inComponent:0 animated:YES];
            }
            
            [weakSelf.tableView reloadData];
            
        }];

        
        
        
        
    }

    return _editGroups;
} 

//选择项数据
-(void)makeBaseSourse
{
    
    NSUserDefaults *ud       = [NSUserDefaults standardUserDefaults];
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
    self.countryItems_CE = @[countryItems_CN,countryItems_EN];
    
 
    
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
    
    self.subjectItems_CE     = @[subjectItems_CN,subjectItems_EN];

    
 
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
    self.gradeItems_CE = @[gradeItems_CN,gradeItems_EN];

    
 

    self.countryItems = self.countryItems_CE[0];
    self.ApplyItems   = self.subjectItems_CE[0];
    self.gradeItems   = self.gradeItems_CE[0];
    
}
//国家名称本地化
-(NSString *)getCountryLocalString:(NSString *)country{


    NSInteger index = [self getIndexWithTextFieldName:country andItems:self.countryItems andGroups:self.countryItems_CE andKeyWord:@"CountryName"];

    [self.CountryPicker selectRow:index inComponent:0 animated:YES];
    CountryItem *cItem = self.countryItems[index];
    return cItem.CountryName;
}



//apply专业名称本地化
-(NSString *)getApplySubjectLocalString:(NSString *)subject
{
    
    NSInteger index = [self getIndexWithTextFieldName:subject andItems:self.ApplyItems andGroups:self.subjectItems_CE andKeyWord:@"subjectName"];
    
    [self.ApplyPicker selectRow:index inComponent:0 animated:YES];
    
    SubjectItem *item = [self.ApplyItems objectAtIndex:index];
    
    return item.subjectName;
}

//专业名称本地化
-(NSString *)getInSubjectLocalString:(NSString *)subject
{

    NSInteger index = [self getIndexWithTextFieldName:subject andItems:self.ApplyItems andGroups:self.subjectItems_CE andKeyWord:@"subjectName"];
    
    [self.SubjectPicker selectRow:index inComponent:0 animated:YES];
    
    SubjectItem *item = [self.ApplyItems objectAtIndex:index];
    
    return item.subjectName;
}


-(NSInteger)getIndexWithTextFieldName:(NSString *)ItemName andItems:(NSArray *)items andGroups:(NSArray *)groupCEs andKeyWord:(NSString *)key
{
    NSInteger Index = 0;
    
    if ([self validateNumberString:ItemName]) {
        
        NSArray *ItemIDs = [items valueForKeyPath:@"NOid"];
        
        Index     = [ItemIDs containsObject:ItemName]?[ItemIDs indexOfObject: ItemName]:0;
        
    }else{
        
        NSArray *IDs_CNs = [groupCEs[0] valueForKeyPath:key];
        NSArray *IDs_ENs = [groupCEs[1]  valueForKeyPath:key];
        
        if ([IDs_CNs  containsObject:ItemName]) {
            
            Index   = [IDs_CNs indexOfObject:ItemName];
            
        }else if([IDs_ENs containsObject:ItemName])
        {
            Index   = [IDs_ENs indexOfObject:ItemName];
            
        }else
        {
            Index   = 0;
        }
    }
    
    return Index;
}


//年级名称本地化
-(NSString *)getGradeLocalString:(NSString *)grade
{
  
    NSInteger gindex = [self getIndexWithTextFieldName:grade andItems:self.gradeItems andGroups:self.gradeItems_CE andKeyWord:@"gradeName"];

    [self.GradePicker selectRow:gindex inComponent:0 animated:YES];
    
    GradeItem *item  = [self.gradeItems objectAtIndex:gindex];
    
    return item.gradeName;
}


//用于判断提交过来的字符串是否是数字
-(BOOL)validateNumberString:(NSString *)preString
{
    NSString *Regex = @"[0-9]+";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    
    return [predicate evaluateWithObject:preString];
}


#pragma mark : UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return Section_header_Height_nomal;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XWGJTJSectionGroup *sectionGroup = self.editGroups[indexPath.section];

    WYLXGroup *group = sectionGroup.celles[indexPath.row];
    
    return group.cell_Height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.editGroups.count;

}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *footer = [UIView new];
    
    footer.backgroundColor = XCOLOR_WHITE;
    
    return footer;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  
    XWGJSectionHeaderView *sectionView =[XWGJSectionHeaderView SectionViewWithTableView:tableView];
    
    sectionView.group = self.editGroups[section];
    
    
    return sectionView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    XWGJTJSectionGroup *group = self.editGroups[section];
    
    return group.celles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    XWGJTJSectionGroup *group = self.editGroups[indexPath.section];
    
    ZhiXunCell *cell = [ZhiXunCell cellWithTableView:tableView indexPath:indexPath];
    
    cell.delegate = self;
    
    cell.group = group.celles[indexPath.row];
    
    switch (cell.group.groupType) {
        case EditTypeDefault:
            cell.inputTF.keyboardType =  UIKeyboardTypeNamePhonePad;
            break;
        case EditTypePhoneNomal:
            cell.inputTF.keyboardType = UIKeyboardTypePhonePad;
            break;
        case EditTypeCountry:
            cell.inputTF.inputView = self.CountryPicker;
            break;
        case EditTypeTime:
            cell.inputTF.inputView = self.TimePicker;
            break;
        case EditTypeSujectplan:
            cell.inputTF.inputView = self.ApplyPicker;
            break;
        case EditTypeUniversity:
            [cell.inputTF addTarget:self action:@selector(casePushUniversity:) forControlEvents:UIControlEventEditingDidBegin];
            break;
        case EditTypeSuject:
            cell.inputTF.inputView = self.SubjectPicker;
            break;
        case EditTypeSCore:
            cell.inputTF.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case EditTypeGrade:
            cell.inputTF.inputView = self.GradePicker;
            break;
        case EditTypeYSavg:
            cell.inputTF.inputView = self.AVGPicker;
            break;
        case EditTypeYSlower:
            cell.inputTF.inputView = self.LowPicker;
            break;
        default:
            break;
    }
    
    
    
    
    return cell;
    

}

#pragma mark :UIPickerViewDataSource, UIPickerViewDelegate

 - (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    switch (pickerView.tag) {
        case PickerViewTypeCountry:
            return self.countryItems.count;
            break;
        case PickerViewTypeTime:
            return self.ApplyTimes.count;
            break;
        case PickerViewTypeApply: case PickerViewTypeSubject:
            return self.ApplyItems.count;
            break;
        case PickerViewTypeGrade:
            return self.gradeItems.count;
            break;
        case PickerViewTypeAvg: case PickerViewTypeLow:
            return self.IELSTScores.count;
            break;
        default:
            return self.countryItems.count;
            break;
    }
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    switch (pickerView.tag) {
        case PickerViewTypeCountry:
        {
            CountryItem *item = self.countryItems[row];
            return  item.CountryName;
           }
            break;
        case PickerViewTypeTime:
             return   self.ApplyTimes[row];
            break;
        case PickerViewTypeApply:case PickerViewTypeSubject:
        {
            SubjectItem *item = self.ApplyItems[row];
            return   item.subjectName;
        }
            break;
        case PickerViewTypeGrade:
        {
            GradeItem *item = self.gradeItems[row];
            return   item.gradeName;
        }
            break;
        default:
            return self.IELSTScores[row];
            break;
    }
    
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
   
    ZhiXunCell *cell = ( ZhiXunCell *)self.editingCell;
    
          switch (pickerView.tag) {
            case PickerViewTypeCountry:
              {
                 CountryItem *item          =  self.countryItems[row];
                 cell.inputTF.text = item.CountryName;
              }
                break;
              case PickerViewTypeTime:
                  cell.inputTF.text = self.ApplyTimes[row];
                  break;
              case PickerViewTypeApply:case PickerViewTypeSubject:
              {
                  SubjectItem *item          =  self.ApplyItems[row];
                  cell.inputTF.text = item.subjectName;
              }
                  break;
              case PickerViewTypeGrade:{
                  GradeItem *item            =  self.gradeItems[row];
                  cell.inputTF.text =  item.gradeName;
              }
                  break;
            default:
                cell.inputTF.text   = self.IELSTScores[row];
                break;
        }
    
}



#pragma mark : zixunCellDelegate

- (void)zixunCell:(ZhiXunCell *)cell indexPath:(NSIndexPath *)indexPath   textFieldDidBeginEditing:(UITextField *)textField{
    
    self.editingCell = cell;
    XWGJTJSectionGroup *sectionGroup = self.editGroups[indexPath.section];
    WYLXGroup *group = sectionGroup.celles[indexPath.row];
    
    //点击学校选项，需要收起键盘，实现跳转
    if (group.groupType ==  EditTypeUniversity) {
        
        [cell.inputTF resignFirstResponder];
  
        return;
    };
    
    //如果 输入框已有数据， 不需要填充默认数据
    if (cell.inputTF.text.length) return;
    
    NSString *content = @"";
    
    switch (group.groupType) {
        case EditTypeCountry:
        {
             content =   @"英国";
            if (self.countryItems.count >0) {
                
                CountryItem *item =self.countryItems.firstObject;
                content = item.CountryName;
            }
  
        }
            break;
        case EditTypeSuject: case EditTypeSujectplan:{
            
            content =   @"经济与金融";
            if (self.ApplyItems.count >0) {
                
                SubjectItem *item =self.ApplyItems.firstObject;
                content = item.subjectName;
            }
            
        }
             break;
        case EditTypeGrade:
        {
            content =   @"本科大四";
            if (self.gradeItems.count >0) {
                
                GradeItem *item =self.gradeItems.firstObject;
                content = item.gradeName;
            }
            
        }
            break;
            
        case EditTypeYSavg: case EditTypeYSlower:{
            
            content =  self.IELSTScores.firstObject;
            
        }
            break;
            
        case EditTypeTime:{
            
            content =  self.ApplyTimes.firstObject;
            
        }
            break;
        
        default:
            break;
    }
    
 
    cell.inputTF.text = content;
    
    group.content = content;
    
}


-  (void)zixunCell:(ZhiXunCell *)cell indexPath:(NSIndexPath *)indexPath   textFieldDidEndEditing:(UITextField *)textField{
    
  
    XWGJTJSectionGroup *sectionGroup = self.editGroups[indexPath.section];

    WYLXGroup *group = sectionGroup.celles[indexPath.row];
    
    group.content = textField.text;
 
}


- (void)zixunCell:(ZhiXunCell *)cell indexPath:(NSIndexPath *)indexPath didClickWithTextField:(UITextField *)textField{
    
    XWGJTJSectionGroup *sectionGroup = self.editGroups[indexPath.section];

    NSInteger section = indexPath.section;
    
    NSInteger row = 0;
    
    if ((indexPath.row + 1) == sectionGroup.celles.count) {
        
        section = indexPath.section + 1;
        row = 0;
    
    }else{
     
        row = indexPath.row + 1;
    }
    
    
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow: row inSection:section];
    
    //最后一条数据时收起键盘
    if (section == (self.editGroups.count)) {
        
        [self.view endEditing:YES];
        
        self.editingCell = nil;
        
        return;
    };
    
    ZhiXunCell *nextCell = [self.tableView cellForRowAtIndexPath:nextIndexPath];
    
    [nextCell.inputTF becomeFirstResponder];
    
}

 
#pragma mark : TiJiaoFooterBlock

-(void)TiJiaoFooterViewItemOnClick:(UIButton *)sender{
   
    if(sender.currentAttributedTitle.length > 0){
        
        WebViewController *adver = [[WebViewController alloc] initWithPath:@"http://public.myoffer.cn/docs/zh-cn/myoffer_License_Agreement.pdf"];
        [self.navigationController pushViewController:adver animated:YES];
        
    }else{
  
        [self caseCommitUserInfo];
        
    }
    
}


#pragma mark : 键盘处理

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
    
    CGFloat upHeight = up ? keyboardEndFrame.size.height : 0;
    
    UIEdgeInsets inset = self.tableView.contentInset;
    inset.bottom = upHeight;
    self.tableView.contentInset =  inset;
  
    [self.view layoutSubviews];
    
    [UIView commitAnimations];
    
    
}



//提交用户申请资料
-(void)caseCommitUserInfo
{
    
    RequireLogin
    
     NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

    for (XWGJTJSectionGroup *group in self.editGroups) {
        
        for (WYLXGroup *item  in group.celles) {
            
            if (!item.content.length) {
                
                [MBProgressHUD showError:[NSString stringWithFormat:@"%@ 不能为空",item.title] toView:self.view];
                
                return;
            }
            
            
            [parameters setValue:item.content  forKey:item.key];
            
        }
    }
    
    
    
    XWeakSelf
    [self startAPIRequestWithSelector: @"POST api/account/applicationdata" parameters:@{@"applicationData":parameters} success:^(NSInteger statusCode, id response) {
        
        [weakSelf
         startAPIRequestWithSelector:@"POST /api/account/checkin"
         parameters:@{@"courseIds": self.selectedCoursesIDs}
         success:^(NSInteger statusCode, id response) {
             [weakSelf updateView];
             
         }];
    }];
   
}

#pragma mark : UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    if (scrollView.isDragging) {
        
        [self.view endEditing:YES];
        
    }
}


//申请成功提示页
- (void)updateView{

     [UIView animateWithDuration:ANIMATION_DUATION animations:^{
         
         self.upgateVC.view.top = 0;
    }];
    
    self.title = @"申请信息";
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(caseBack)];
}

//返回
- (void)caseBack{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)casePushUniversity:(UITextField *)sender{
    
    
    EvaluateSearchCollegeViewController *search =[[EvaluateSearchCollegeViewController alloc] init];
    
    search.valueBlock = ^(NSString *value){
        
        if ( 0 == value.length) return;
        
        ZhiXunCell *cell = (ZhiXunCell *)self.editingCell;
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:self.editingCell];
        
        cell.inputTF.text = value;
        
        XWGJTJSectionGroup *sectionGroup = self.editGroups[indexPath.section];
        
        WYLXGroup *uni_cell = sectionGroup.celles[indexPath.row];
        
        uni_cell.content = value;
  
        
    };
    
    [self.navigationController pushViewController:search animated:YES];
    
}


- (void)dealloc{
    
    KDClassLog(@"dealloc  提交申请个人资料");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end


/*
 
 switch (indexPath.section) {
 case 0:{
 
 cell.inputTF.inputView = nil;
 
 switch (indexPath.row) {
 case 0:
 cell.inputTF.keyboardType =  UIKeyboardTypeNamePhonePad;
 break;
 case 1:
 cell.inputTF.keyboardType =  UIKeyboardTypeNamePhonePad;
 break;
 case 2:
 cell.inputTF.keyboardType = UIKeyboardTypePhonePad;
 break;
 default:
 break;
 }
 
 }
 break;
 case 1:{
 
 switch (indexPath.row) {
 case 0:
 cell.inputTF.inputView = self.CountryPicker;
 break;
 case 1:
 cell.inputTF.inputView = self.TimePicker;
 break;
 case 2:
 cell.inputTF.inputView = self.ApplyPicker;
 break;
 default:
 break;
 }
 
 
 }
 break;
 case 2:{
 
 switch (indexPath.row) {
 case 0:
 break;
 case 1:
 cell.inputTF.inputView = self.SubjectPicker;
 break;
 case 2:{
 
 cell.inputTF.inputView = nil;
 cell.inputTF.keyboardType = UIKeyboardTypePhonePad;
 
 }
 break;
 case 3:
 cell.inputTF.inputView = self.GradePicker;
 break;
 case 4:
 cell.inputTF.inputView = self.AVGPicker;
 break;
 case 5:
 cell.inputTF.inputView = self.LowPicker;
 break;
 default:
 break;
 }
 }
 break;
 default:
 break;
 }
 
 
 
 
 */


