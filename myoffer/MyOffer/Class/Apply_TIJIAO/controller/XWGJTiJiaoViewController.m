//
//  XWGJTiJiaoViewController.m
//  myOffer
//
//  Created by xuewuguojie on 16/2/25.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "XWGJTiJiaoViewController.h"
#import "XWGJPeronInfoItem.h"
#import "XWGJTJSectionGroup.h"
#import "XWGJYiXiangTableViewCell.h"
#import "XWGJJiBengTableViewCell.h"
#import "XWGJSectionHeaderView.h"
#import "CountryItem.h"
#import "SubjectItem.h"
#import "GradeItem.h"
#import "XWGJSummaryView.h"
#import "TiJiaoFooterView.h"
#import "UpgradeViewController.h"

typedef enum {
    PickerViewTypeCountry = 109,
    PickerViewTypeTime = 110,
    PickerViewTypeApply = 111,
    PickerViewTypeSubject = 112,
    PickerViewTypeGrade = 113,
    PickerViewTypeAvg = 114,
    PickerViewTypeLow = 115
}PickerViewType;//表头按钮选项


@interface XWGJTiJiaoViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,XWGJJiBengTableViewCellDelegate,XWGJYiXiangTableViewCellDelegate,TiJiaoFooterViewDelegate>
@property(nonatomic,strong)UITableView *TableView;
@property(nonatomic,strong)NSArray *Groups;
@property(nonatomic,strong)NSDictionary *userInfo;
@property(nonatomic,strong)UITableViewCell *editingCell;
@property(nonatomic,strong)NSIndexPath *EditingIndexPath;
@property(nonatomic,strong)UIPickerView *CountryPicker;
@property(nonatomic,strong)UIPickerView *TimePicker;
@property(nonatomic,strong)UIPickerView *ApplyPicker;
@property(nonatomic,strong)UIPickerView *SubjectPicker;
@property(nonatomic,strong)UIPickerView *GradePicker;
@property(nonatomic,strong)UIPickerView *AVGPicker;
@property(nonatomic,strong)UIPickerView *LowPicker;
@property(nonatomic,strong)NSArray *ApplyTimes;
@property(nonatomic,strong)NSArray *gradeItems;
@property(nonatomic,strong)NSArray *countryItems_CE;
@property(nonatomic,strong)NSArray *subjectItems_CE;
@property(nonatomic,strong)NSArray *gradeItems_CE;
@property(nonatomic,strong)NSArray *countryItems;
@property(nonatomic,strong)NSArray *ApplyItems;
@property(nonatomic,strong)NSArray *IELSTScores;
@property(nonatomic,strong)KDEasyTouchButton *commitBtn;    //提交申请按钮
@property(nonatomic,strong)UpgradeViewController *upgateVC; //升级VC

@end

@implementation XWGJTiJiaoViewController


-(UpgradeViewController *)upgateVC{

    if (!_upgateVC) {
        
        _upgateVC            =[[UpgradeViewController alloc] init];
        _upgateVC.view.frame = CGRectMake(0, XScreenHeight, XScreenWidth, XScreenHeight);
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

-(UIPickerView *)CountryPicker
{
    if (!_CountryPicker) {
        
        _CountryPicker = [self PickerViewWithTag:PickerViewTypeCountry];
        
    }
    return _CountryPicker;
}

-(UIPickerView *)TimePicker
{
    if (!_TimePicker) {
        
        _TimePicker = [self PickerViewWithTag:PickerViewTypeTime];
        
    }
    return _TimePicker;
}

-(UIPickerView *)ApplyPicker
{
    if (!_ApplyPicker) {
        
        _ApplyPicker = [self PickerViewWithTag:PickerViewTypeApply];
        
    }
    return _ApplyPicker;
}


-(UIPickerView *)SubjectPicker
{
    if (!_SubjectPicker) {
        
        _SubjectPicker = [self PickerViewWithTag:PickerViewTypeSubject];
        
    }
    return _SubjectPicker;
}
-(UIPickerView *)GradePicker
{
    if (!_GradePicker) {
        
        _GradePicker = [self PickerViewWithTag:PickerViewTypeGrade];
        
    }
    return _GradePicker;
}

-(UIPickerView *)AVGPicker
{
    if (!_AVGPicker) {
        
        _AVGPicker = [self PickerViewWithTag:PickerViewTypeAvg];
        
    }
    return _AVGPicker;
}

-(UIPickerView *)LowPicker
{
    if (!_LowPicker) {
        
        _LowPicker = [self PickerViewWithTag:PickerViewTypeLow];
        
    }
    return _LowPicker;
}

-(NSArray *)ApplyTimes
{
    if (!_ApplyTimes) {
        
       _ApplyTimes = @[@"2016",@"2017",@"2018+"];

    }
    return _ApplyTimes;
}


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
    
    [self getSelectionResourse];
    
}

-(void)viewWillAppear:(BOOL)animated
{
     [super viewWillAppear:animated];
     [MobClick beginLogPageView:@"page提交申请"];
}



- (void)viewWillDisappear:(BOOL)animated
{
     [super viewWillDisappear:animated];
     [MobClick endLogPageView:@"page提交申请"];
    
}

-(void)makeUI
{

    [self makeTableView];
    
    [self makeHeaderView];
    
    [self makeFooterView];
    
    [self makeComitButton];
   
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

-(void)makeComitButton
{
    KDEasyTouchButton *commit = [[KDEasyTouchButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.TableView.frame), XScreenWidth, 50)];
    self.commitBtn            = commit;
    commit.backgroundColor    = XCOLOR_LIGHTGRAY;
    commit.enabled            = NO;
    [commit setTitleColor:XCOLOR_WHITE forState:UIControlStateNormal];
    [commit setTitle:GDLocalizedString(@"TiJiao-Commit") forState:UIControlStateNormal];
    [commit addTarget:self action:@selector(commitUserInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commit];

}

-(void)makeTableView
{
    self.TableView             = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, XScreenWidth, XScreenHeight - 114) style:UITableViewStyleGrouped];
    self.TableView.dataSource  = self;
    self.TableView.delegate    = self;
    [self.view addSubview:self.TableView];
    self.TableView.backgroundColor =[UIColor clearColor];
    self.TableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.TableView.allowsSelection = NO;
    
}

//添加表头
-(void)makeHeaderView
{
    XWGJSummaryView *headerView    = [[XWGJSummaryView alloc] init];
    headerView.summary             = GDLocalizedString(@"ApplicationProfile-0016");
    headerView.frame               = CGRectMake(0, 0, 0, CGRectGetMaxY(headerView.summaryLab.frame));
    self.TableView.tableHeaderView = headerView;
}

//添加表尾
-(void)makeFooterView
{
    
    TiJiaoFooterView *footerView   = [[TiJiaoFooterView alloc] init];
    footerView.title               = GDLocalizedString(@"ApplicationProfile-footer");
    footerView.frame               = CGRectMake(0, 0, XScreenWidth, CGRectGetMaxY(footerView.descriptionBtn.frame) + 50);
    footerView.delegate            = self;
    self.TableView.tableFooterView = footerView;
    
}

-(NSArray *)Groups
{
    if (!_Groups) {
        
        __block  XWGJPeronInfoItem *LastItem = [XWGJPeronInfoItem personInfoItemInitWithPlacehoder:GDLocalizedString(@"TiJiao-LastName")  andAccessroy:NO];
        __block XWGJPeronInfoItem *FirstItem = [XWGJPeronInfoItem personInfoItemInitWithPlacehoder:GDLocalizedString(@"TiJiao-FirstName")  andAccessroy:NO];
        __block XWGJPeronInfoItem *phoneItem = [XWGJPeronInfoItem personInfoItemInitWithPlacehoder:GDLocalizedString(@"TiJiao-Phone")  andAccessroy:NO];

        __block XWGJPeronInfoItem *countryItem = [XWGJPeronInfoItem  personInfoItemInitWithPlacehoder:GDLocalizedString(@"TiJiao-Country") andAccessroy:YES];
        __block XWGJPeronInfoItem *timeItem    = [XWGJPeronInfoItem  personInfoItemInitWithPlacehoder:GDLocalizedString(@"TiJiao-Time")  andAccessroy:YES];
        __block  XWGJPeronInfoItem *applyItem  = [XWGJPeronInfoItem personInfoItemInitWithPlacehoder:GDLocalizedString(@"TiJiao-ApplySubject")  andAccessroy:YES];
       
        __block XWGJPeronInfoItem *universityItem = [XWGJPeronInfoItem personInfoItemInitWithPlacehoder:GDLocalizedString(@"TiJiao-University")  andAccessroy:NO];
        __block XWGJPeronInfoItem *subjectItem    = [XWGJPeronInfoItem personInfoItemInitWithPlacehoder:GDLocalizedString(@"TiJiao-Subjecting")  andAccessroy:YES];
        __block  XWGJPeronInfoItem *GPAItem       = [XWGJPeronInfoItem personInfoItemInitWithPlacehoder:GDLocalizedString(@"TiJiao-GPA")  andAccessroy:NO];
        __block XWGJPeronInfoItem *gradeItem      = [XWGJPeronInfoItem personInfoItemInitWithPlacehoder:GDLocalizedString(@"TiJiao-Grade")  andAccessroy:YES];
        __block   XWGJPeronInfoItem *avgItem      = [XWGJPeronInfoItem personInfoItemInitWithPlacehoder:GDLocalizedString(@"TiJiao-Average")  andAccessroy:YES];
        __block XWGJPeronInfoItem *lowItem        = [XWGJPeronInfoItem personInfoItemInitWithPlacehoder:GDLocalizedString(@"TiJiao-Low")  andAccessroy:YES];
       
        NSArray *FirstSections      =  @[LastItem,FirstItem,phoneItem];
        XWGJTJSectionGroup *JBgroup = [XWGJTJSectionGroup groupInitWithTitle:GDLocalizedString(@"TiJiao-JiBen") andSecitonIcon:@"TJ_JiBeng" andContensArray:FirstSections];
        
        
        NSArray *SecondSetions      = @[countryItem,timeItem,applyItem];
        XWGJTJSectionGroup *YXgroup = [XWGJTJSectionGroup groupInitWithTitle:GDLocalizedString(@"TiJiao-YiXiang") andSecitonIcon:@"TJ_YiXiang" andContensArray:SecondSetions];

        
        NSArray *ThirdSetions       =  @[universityItem,subjectItem,GPAItem,gradeItem,avgItem,lowItem];
        XWGJTJSectionGroup *BJgroup = [XWGJTJSectionGroup groupInitWithTitle:GDLocalizedString(@"TiJiao-Beijing") andSecitonIcon:@"TJ_BeiJin" andContensArray:ThirdSetions];

        _Groups                     = @[JBgroup ,YXgroup,BJgroup];
        
        
        XJHUtilDefineWeakSelfRef
        [self startAPIRequestWithSelector:@"GET api/account/applicationdata" parameters:nil success:^(NSInteger statusCode, NSDictionary *response) {
            
            weakSelf.userInfo   = response;
            LastItem.itemName   = response[@"last_name"];
            FirstItem.itemName  = response[@"first_name"];
            phoneItem.itemName  = response[@"phonenumber"];
            
            NSString *des_country = [NSString stringWithFormat:@"%@",response[@"des_country"]];
            NSString *country     = [des_country containsString:@"null"]?@"":des_country;
            countryItem.itemName  = !country.length?@"":[self getCountryLocalString:country];
            
            
            NSString *target_time = response[@"target_date"];
            NSInteger TimeIndex   = 0;
            
            if([self.ApplyTimes containsObject:target_time])
            {
                TimeIndex         = [self.ApplyTimes indexOfObject:target_time];
                timeItem.itemName = target_time;
            }

            [self.TimePicker selectRow:TimeIndex inComponent:0 animated:YES];
            
            
            applyItem.itemName      = !response[@"apply"]?@"":[self getApplySubjectLocalString:response[@"apply"]];;
            universityItem.itemName =  response[@"university"];
            subjectItem.itemName    =  !response[@"subject"]?@"":[self getInSubjectLocalString:response[@"subject"]];
 
            
            
            NSString *GPA      = [NSString stringWithFormat:@"%@",response[@"score"]];
            GPAItem.itemName   = [GPA containsString:@"null"]?@"":GPA;
            NSString *grade    = [NSString stringWithFormat:@"%@",response[@"grade"]];
            NSString *gradeStr = [grade containsString:@"null"]?@"":grade;
            gradeItem.itemName = gradeStr.length == 0 ? @"":[self getGradeLocalString:gradeStr];
            NSString *avg      = [NSString stringWithFormat:@"%@",response[@"ielts_avg"]];
            NSString *avgStr   = [avg containsString:@"null"]?@"":avg;
            avgItem.itemName   = avgStr.length == 0 ? @"" : avgStr;
              if (avgStr.length) {
                  
                NSInteger avgIndex = [self.IELSTScores containsObject:avgStr]?[self.IELSTScores indexOfObject:avgStr]:0;
                  
                [self.AVGPicker selectRow:avgIndex inComponent:0 animated:YES];
            }
            
            NSString *Low    = [NSString stringWithFormat:@"%@",response[@"ielts_low"]];
            NSString *LowStr = [Low containsString:@"null"]?@"":Low;
            lowItem.itemName =   LowStr.length == 0 ? @"" : LowStr;
            if (LowStr.length) {
                
                NSInteger LowIndex = [self.IELSTScores containsObject:LowStr]?[self.IELSTScores indexOfObject:LowStr]:0;
                
                [self.LowPicker selectRow:LowIndex inComponent:0 animated:YES];
            }
            
            [self.TableView reloadData];
            
        }];
    }
    return _Groups;
}



-(void)getSelectionResourse
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

    
    
    if (USER_EN) {
        
        self.countryItems = self.countryItems_CE[1];
        self.ApplyItems   = self.subjectItems_CE[1];
        self.gradeItems   = self.gradeItems_CE[1];
        
    }else{
        
        self.countryItems = self.countryItems_CE[0];
        self.ApplyItems   = self.subjectItems_CE[0];
        self.gradeItems   = self.gradeItems_CE[0];
    }
    
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
        
        Index            = [ItemIDs containsObject:ItemName]?[ItemIDs indexOfObject: ItemName]:0;
        
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



#pragma mark ————  UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 45.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return (0 == indexPath.section)? 44 : 64;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return self.Groups.count;

}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  
    XWGJSectionHeaderView *sectionView =[XWGJSectionHeaderView SectionViewWithTableView:tableView];
    
    sectionView.group = self.Groups[section];
    
    return sectionView;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    XWGJTJSectionGroup *group = self.Groups[section];
    
    return group.cellItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   

    XWGJTJSectionGroup *group = self.Groups[indexPath.section];
    
    
    if (0 == indexPath.section) {
        
        XWGJJiBengTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"JIBEN"];
        
        if (!cell) {
            
            cell = [[NSBundle mainBundle] loadNibNamed:@"XWGJJiBengTableViewCell" owner:self options:nil].lastObject;
        }
        
        cell.delegate = self;
        cell.indexPath = indexPath;
        cell.item = group.cellItems[indexPath.row];
        
        return cell;
    }else{
    
        XWGJYiXiangTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"YIXIANG"];
        
        if (!cell) {
            
            cell = [[NSBundle mainBundle] loadNibNamed:@"XWGJYiXiangTableViewCell" owner:self options:nil].lastObject;
        }
        
        cell.item = group.cellItems[indexPath.row];
        cell.indexPath = indexPath;
        cell.delegate = self;
        
        if ( 1 == indexPath.section) {
            
            switch (indexPath.row) {
                case 0:
                {
                    cell.ContentTF.inputView = self.CountryPicker;
                }
                    break;
                case 1:
                {
                    cell.ContentTF.inputView = self.TimePicker;
                }
                    break;
                default:
                    cell.ContentTF.inputView = self.ApplyPicker;
                    break;
            }
            
        }else{
        
            switch (indexPath.row) {
                case 1:
                {
                    cell.ContentTF.inputView = self.SubjectPicker;
                }
                    break;
                case 3:
                {
                    cell.ContentTF.inputView = self.GradePicker;
                }
                    break;
                case 4:
                {
                    cell.ContentTF.inputView = self.AVGPicker;
                }
                    break;
                case 5:
                {
                    cell.ContentTF.inputView = self.LowPicker;
                }
                    break;
                default:
                    break;
            }

        
        }
        
        
        return cell;
        
    }
    

}

#pragma mark ----UIPickerViewDataSource, UIPickerViewDelegate
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
        case PickerViewTypeCountry:{
            CountryItem *item = self.countryItems[row];
            return  item.CountryName;
           }
            break;
        case PickerViewTypeTime:{
            
             return   self.ApplyTimes[row];
        }
            break;
        case PickerViewTypeApply:case PickerViewTypeSubject:{
            
            SubjectItem *item = self.ApplyItems[row];
            return   item.subjectName;
        }
            break;
        case PickerViewTypeGrade:{
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
   
    XWGJYiXiangTableViewCell *Editingcell = ( XWGJYiXiangTableViewCell *)self.editingCell;
    
          switch (pickerView.tag) {
            case PickerViewTypeCountry:{
                
                 CountryItem *item          =  self.countryItems[row];
                 Editingcell.ContentTF.text = item.CountryName;
                
              }
                break;
              case PickerViewTypeTime:{
                  
                  Editingcell.ContentTF.text = self.ApplyTimes[row];
              }
                  break;
              case PickerViewTypeApply:case PickerViewTypeSubject:{
                  
                  SubjectItem *item          =  self.ApplyItems[row];
                  Editingcell.ContentTF.text = item.subjectName;
              }
                  break;
              case PickerViewTypeGrade:{
                  GradeItem *item            =  self.gradeItems[row];
                  Editingcell.ContentTF.text =  item.gradeName;
              }
                  break;
            default:{
                Editingcell.ContentTF.text   = self.IELSTScores[row];
            }
                break;
        }
    
}



#pragma mark ----XWGJJiBengTableViewCellDelegate
-(void)JiBengTableViewCell:(XWGJJiBengTableViewCell *)cell  withIndexPath:(NSIndexPath *)indexPath EditedTextField:(UITextField *)textField{

    
    XWGJTJSectionGroup *group =  self.Groups[indexPath.section];
    NSArray *cellItems        = group.cellItems;
    XWGJPeronInfoItem *item   = cellItems[indexPath.row];
    item.itemName             = textField.text;
    
}

-(void)JiBengTableViewCell:(XWGJJiBengTableViewCell *)cell  withIndexPath:(NSIndexPath *)indexPath textFieldDidBeginEditing:(UITextField *)textField{

    self.editingCell = cell;
    self.EditingIndexPath = indexPath;
  
}

-(void)JiBengTableViewCell:(XWGJJiBengTableViewCell *)cell  withIndexPath:(NSIndexPath *)indexPath didClick:(UIBarButtonItem *)sender{

    
    if (sender.tag == 10) {
        
        [self.view endEditing:YES];
        
        return;
        
    }
    
    
    NSInteger row = indexPath.row + 1 ;
    
    if (row > 2) {
        
        row = 0;
        
        NSIndexPath *nextIndex = [NSIndexPath indexPathForRow:row inSection:1];
        XWGJYiXiangTableViewCell *nextCell = [self.TableView cellForRowAtIndexPath:nextIndex];
        [nextCell.ContentTF becomeFirstResponder];
        
    }else{
    
        NSIndexPath *nextIndex = [NSIndexPath indexPathForRow:row inSection:0];
        XWGJJiBengTableViewCell *nextCell = [self.TableView cellForRowAtIndexPath:nextIndex];
        [nextCell.ContentTF becomeFirstResponder];
    
    }
    
     
}


-(void)YiXiangTableViewCell:(XWGJYiXiangTableViewCell *)cell  withIndexPath:(NSIndexPath *)indexPath EditedTextField:(UITextField *)textField
{
    
        XWGJTJSectionGroup *group =  self.Groups[indexPath.section];
        NSArray *cellItems        = group.cellItems;
        XWGJPeronInfoItem *item   = cellItems[indexPath.row];
        item.itemName             = textField.text;
  
}



-(void)YiXiangTableViewCell:(XWGJYiXiangTableViewCell *)cell  withIndexPath:(NSIndexPath *)indexPath textFieldDidBeginEditing:(UITextField *)textField
{
    
    self.editingCell = cell;
    
    self.EditingIndexPath     = indexPath;
    
    XWGJTJSectionGroup *group = self.Groups[indexPath.section];
    
    XWGJPeronInfoItem *item   = group.cellItems[indexPath.row];
    
    if (item.itemName.length != 0) {
        
        return;
    }
    
    if ( 1 == indexPath.section) {
        
        switch (indexPath.row) {
            case 0:
            {
                    CountryItem *countryItem = self.countryItems[0];
                    
                    textField.text           = countryItem.CountryName;
                    
                    item.itemName            = textField.text;
                
            }
                break;
            case 1:
            {
                 textField.text = self.ApplyTimes[0];
                 item.itemName  = textField.text;
                
            }
                break;
                
            default:
            {
                SubjectItem *applyItem = self.ApplyItems[0];
                textField.text         = applyItem.subjectName;
                item.itemName          = textField.text;
            
            }
                break;
        }
        
    }else{
    
    
        switch (indexPath.row) {
            case 1:
            {
                SubjectItem *applyItem = self.ApplyItems[0];
                textField.text         = applyItem.subjectName;
                item.itemName          = textField.text;
                
            }
                break;
            case 3:
            {
                GradeItem *gradeItem = self.gradeItems[0];
                textField.text       = gradeItem.gradeName;
                item.itemName        = textField.text;
                
            }
                break;
                case 4:case 5:
            {
                textField.text = self.IELSTScores[0];
                item.itemName  = textField.text;
            }
                break;
            default:
                break;
        }

    
    }
    
}
-(void)YiXiangTableViewCell:(XWGJYiXiangTableViewCell *)cell  withIndexPath:(NSIndexPath *)indexPath didClick:(UIBarButtonItem *)sender{

    
    if (sender.tag == 10) {
        
        [self.view endEditing:YES];
        
        return;
        
    }
    
    
    NSInteger row     = indexPath.row + 1 ;
    NSInteger section = indexPath.section;
    
    if (indexPath.section == 1) {
        
        if (row > 2) {
            
            row     = 0;
            
            section = indexPath.section + 1;
        }
        
    }else{
        
        if (row > 5) {
            
            [self.view endEditing:YES];
            
            return;
            
        }
        
        
    }

    NSIndexPath *nextIndex             = [NSIndexPath indexPathForRow:row inSection:section];
    XWGJYiXiangTableViewCell *nextCell = [self.TableView cellForRowAtIndexPath:nextIndex];
    [nextCell.ContentTF becomeFirstResponder];

}

#pragma mark ——————— TiJiaoFooterViewDelegate
-(void)TiJiaoFooterView:(TiJiaoFooterView *)footerView didClick:(UIButton *)sender{
    
    
    if (10 == sender.tag) {
        
        sender.selected                = !sender.selected;
        self.commitBtn.enabled         =  sender.selected;
        self.commitBtn.backgroundColor = sender.selected  ? XCOLOR_RED : XCOLOR_LIGHTGRAY;
        
    }else{
        
        WebViewController *adver = [[WebViewController alloc] init];
        adver.path                     = @"http://public.myoffer.cn/docs/zh-cn/myoffer_License_Agreement.pdf";
        [self.navigationController pushViewController:adver animated:YES];
    
    }
}


#pragma mark —————— 键盘处理
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
    
    UIEdgeInsets insets = self.TableView.contentInset;
    if (up) {
        insets.bottom   = keyboardEndFrame.size.height;
    } else {
        insets.bottom   = 50;
    }
    
    self.TableView.contentInset = insets;
    
    [self.view layoutSubviews];
    
    [UIView commitAnimations];
}


//提交用户申请资料
-(void)commitUserInfo
{
    
    
    
 

    RequireLogin
   
    for (XWGJTJSectionGroup *group in self.Groups) {
        
        for (XWGJPeronInfoItem *item  in group.cellItems) {
            
            if (item.itemName.length == 0) {
                
                [KDAlertView showMessage:[NSString stringWithFormat:@"%@%@",item.placeholder,GDLocalizedString(@"TiJiao-Empty")] cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];//@"好的"];
                return;
            }
        }
    }
    
    XWGJTJSectionGroup *FirstGroup  = self.Groups[0];
    XWGJTJSectionGroup *SecondGroup = self.Groups[1];
    XWGJTJSectionGroup *ThirdGroup  = self.Groups[2];
    
    
    NSDictionary *parameters =  @{@"des_country":[SecondGroup.cellItems[0] itemName],
                                  @"target_date":[SecondGroup.cellItems[1] itemName],
                                  @"apply":[SecondGroup.cellItems[2] itemName],
                                  
                                  @"last_name":[FirstGroup.cellItems[0] itemName],
                                  @"first_name":[FirstGroup.cellItems[1] itemName],
                                  @"phonenumber":[FirstGroup.cellItems[2] itemName],
                                  
                                  @"university":[ThirdGroup.cellItems[0] itemName],
                                  @"subject":[ThirdGroup.cellItems[1] itemName],
                                  @"score":[ThirdGroup.cellItems[2] itemName],
                                  @"grade":[ThirdGroup.cellItems[3] itemName],
                                  @"ielts_avg":[ThirdGroup.cellItems[4] itemName],
                                  @"ielts_low":[ThirdGroup.cellItems[5] itemName]
                                  };
    
    XJHUtilDefineWeakSelfRef
    
    
    
    [self startAPIRequestWithSelector: @"POST api/account/applicationdata" parameters:@{@"applicationData":parameters} success:^(NSInteger statusCode, id response) {
        
        [weakSelf
         startAPIRequestWithSelector:@"POST /api/account/checkin"
         parameters:@{@"courseIds": self.selectedCoursesIDs}
         success:^(NSInteger statusCode, id response) {
//             KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
//             [hud applySuccessStyle];
//             [hud setLabelText: GDLocalizedString(@"WoYaoLiuXue_submit")];//@"提交成功"];
//             [hud hideAnimated:YES afterDelay:2];
//             [hud setHiddenBlock:^(KDProgressHUD *hud) {
//                 
//                 [self.navigationController popToRootViewControllerAnimated:YES];
//                 //[self dismiss];
//             }];
             
             [weakSelf updateView];

             
         }];
    }];
  
  
  
}

//申请成功提示页
-(void)updateView{

     [UIView animateWithDuration:0.25 animations:^{
         self.upgateVC.view.top = 0;
    }];
    
    self.title = @"申请信息";
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
}

//返回
-(void)back{

    [self.navigationController popToRootViewControllerAnimated:YES];
}



- (void)dealloc{
    
    KDClassLog(@"dealloc  XWGJTiJiaoViewController");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
