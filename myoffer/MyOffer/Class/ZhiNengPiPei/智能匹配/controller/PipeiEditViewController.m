//
//  PipeiEditViewController.m
//  myOffer
//
//  Created by xuewuguojie on 2016/11/18.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "PipeiEditViewController.h"
#import "XWGJSummaryView.h"
#import "PipeiSectionHeaderView.h"
#import "PipeiGroup.h"
#import "PipeiEditCell.h"
#import "PipeiCountryCell.h"
#import "CountryItem.h"
#import "SubjectItem.h"
#import "EvaluateSearchCollegeViewController.h"
#define Bottom_Height 150

@interface PipeiEditViewController ()<UITableViewDelegate,UITableViewDataSource,PipeiEditCellDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *groups;
@property(nonatomic,strong)NSArray *countryItems_CN;
@property(nonatomic,strong)NSArray *subjectItems_CN;
@property(nonatomic,strong)UIPickerView *subjectPicker;
@property(nonatomic,strong)PipeiEditCell *editingCell;
@property(nonatomic,strong)UIButton *submitBtn;

@end

@implementation PipeiEditViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self getSelectionResourse];
    
    [self makeUI];
    
    [self requestDataSource];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

//就读专业
-(UIPickerView *)subjectPicker
{
    if(!_subjectPicker)
    {
        _subjectPicker = [[UIPickerView alloc] init];
        _subjectPicker.dataSource = self;
        _subjectPicker.delegate = self;
    }
    return _subjectPicker;
}

//用于网络数据请求
-(void)requestDataSource{
    
    if (!LOGIN) return;
    
    XWeakSelf
    [self startAPIRequestWithSelector:kAPISelectorZiZengPipeiGet  parameters:nil success:^(NSInteger statusCode, id response) {
        
        [weakSelf configrationUIWithresponse:response];
        
    }];
}

- (void)configrationUIWithresponse:(id)response{
    
    
    
    for (PipeiGroup *group in self.groups) {
        
        switch (group.groupType) {
                
            case PipeiGroupTypeCountry:{
                
                if (!response[@"des_country"]) {
                    
                    group.content  = @"英国";
                    
                }else{
                    
                    BOOL haveCountry = NO;
                    
                    for (NSInteger index = 0; index < self.countryItems_CN.count; index++) {
                        
                        CountryItem *item = self.countryItems_CN[index];
                        

                        if ([item.NOid isEqualToString:response[@"des_country"]]) {
                            
                            haveCountry = YES;
                            group.content = item.CountryName;

                            break;
                        }
                    }
                    
                    if (!haveCountry) {
                        
                        group.content  = @"英国";
                        
                    }
                }
            }
                
                break;
            case PipeiGroupTypeUniversity:
                group.content = response[@"university"];
                break;
            case PipeiGroupTypeSubject:{
                
                for (NSInteger index = 0; index < self.subjectItems_CN.count; index++) {
                    
                    SubjectItem *item = self.subjectItems_CN[index];
                    
                    if ([item.NOid isEqualToString:response[@"subject"]]) {
                        
                        group.content = item.subjectName;

                        [self.subjectPicker selectRow:index inComponent:0 animated:YES];
                        
                        break;
                    }
                }
                
            }
                break;
            case PipeiGroupTypeScorce:
                group.content = response[@"score"] ? [NSString stringWithFormat:@"%@",response[@"score"]] : @"";
                break;
            default:
                break;
        }
        
    }
    
    [self.tableView reloadData];
}

//请求匹配相关数据
-(void)getSelectionResourse
{
    
    NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
    
    self.countryItems_CN = [[ud valueForKey:@"Country_CN"] KD_arrayUsingMapEnumerateBlock:^id(NSDictionary *obj, NSUInteger idx)
                            {
                                CountryItem *item = [CountryItem CountryWithDictionary:obj];
                                return item;
                            }];
    
    
    self.subjectItems_CN = [[ud valueForKey:@"Subject_CN"] KD_arrayUsingMapEnumerateBlock:^id(NSDictionary *obj, NSUInteger idx)
                            {
                                SubjectItem *item = [SubjectItem subjectWithDictionary:obj];
                                return item;
                            }];
    
}


- (void)makeUI{
    
    self.title = @"智能匹配";
    
    [self makeTableView];
    
    [self makeBottomView];
    
}

- (void)makeBottomView{
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, XScreenHeight - Bottom_Height, XScreenWidth, Bottom_Height)];
    bottomView.backgroundColor = XCOLOR_BG;
    [self.view addSubview:bottomView];
    
    UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(PADDING_TABLEGROUP, 0, XScreenWidth - 2 * PADDING_TABLEGROUP, 50)];
    [submitBtn setTitle:@"获取匹配结果" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.layer.cornerRadius = CORNER_RADIUS;
    submitBtn.backgroundColor = XCOLOR_RED;
    [bottomView addSubview:submitBtn];
    self.submitBtn = submitBtn;
    
    
}

-(NSMutableArray *)groups{
    
    if (!_groups) {
        
        _groups = [NSMutableArray array];
        
        PipeiGroup *country = [PipeiGroup groupWithHeader: @"意向国家"  groupType:PipeiGroupTypeCountry];
        PipeiGroup *university = [PipeiGroup groupWithHeader: @"在读或毕业院校"  groupType:PipeiGroupTypeUniversity];
        PipeiGroup *subject = [PipeiGroup groupWithHeader: @"就读专业"  groupType:PipeiGroupTypeSubject];
        PipeiGroup *score = [PipeiGroup groupWithHeader: @"平均成绩（百分制）"  groupType:PipeiGroupTypeScorce];
        
        [_groups addObject:country];
        [_groups addObject:university];
        [_groups addObject:subject];
        [_groups addObject:score];
    }
    
    return _groups;
}


//添加表头
-(void)makeHeaderView
{
    XWGJSummaryView *headerView = [XWGJSummaryView ViewWithContent:@"myOffer通过REBAT大数据分析技术，运用独特TBDT算法，为你一键生成智能匹配方案。"];
    headerView.line.hidden = NO;
    self.tableView.tableHeaderView = headerView;
}

- (void)makeTableView
{
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0, XScreenWidth, XScreenHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
    self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self makeHeaderView];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, Bottom_Height, 0);
    self.tableView.backgroundColor = XCOLOR_BG;
}


#pragma mark —————— UITableViewDelegate,UITableViewDataSource
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    PipeiSectionHeaderView *header = [[PipeiSectionHeaderView alloc] init];
    
    PipeiGroup *sectionGroup =  self.groups[section];
    
    header.titleLab.text = sectionGroup.header;
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return  HEIGHT_ZERO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return  50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return  self.groups.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PipeiGroup *group = self.groups[indexPath.section];
    
    if (group.groupType == PipeiGroupTypeCountry) {
        
        PipeiCountryCell *countryCell = [PipeiCountryCell cellWithTableView:tableView];
        countryCell.valueBlock = ^(NSString *country){
        
            
            PipeiGroup *group = self.groups[0];
            
            group.content = country;
            
        };
        countryCell.countryName = group.content;
        
        return countryCell;
        
    }else{
        
        PipeiEditCell *cell =[PipeiEditCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.group =  group;
        if (group.groupType == PipeiGroupTypeSubject) {
            
            cell.contentTF.inputView = self.subjectPicker;
            
        }else if (group.groupType == PipeiGroupTypeScorce){
            
            cell.contentTF.keyboardType = UIKeyboardTypeNumberPad;
        }
        
        return cell;
    }
    
}
#pragma mark ——— PipeiEditCellDelegate
-(void)PipeiEditCellPush{
    
    
    [self.view endEditing:YES];
    
    EvaluateSearchCollegeViewController *search =[[EvaluateSearchCollegeViewController alloc] initWithNibName:@"EvaluateSearchCollegeViewController" bundle:nil];
    search.valueBlock = ^(NSString *value){
        
        PipeiEditCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        cell.contentTF.text = value;
        PipeiGroup *university = self.groups[1];
        university.content = value;
        
    };
    
    [self.navigationController pushViewController:search animated:YES];
    
    
}

-(void)PipeiEditCell:(PipeiEditCell *)cell  textFieldDidEndEditing:(UITextField *)textField{
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (indexPath.section == self.groups.count - 1) {
        
        PipeiGroup *group = self.groups[indexPath.section];
        
        group.content = textField.text;
    }
    
}

-(void)PipeiEditCell:(PipeiEditCell *)cell  textFieldDidBeginEditing:(UITextField *)textField{
    
    self.editingCell = cell;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (2 == indexPath.section && 0 == textField.text.length) {
        
        SubjectItem *item = self.subjectItems_CN[0];
        
        textField.text = item.subjectName;
        
        PipeiGroup *group = self.groups[2];
        
        group.content = item.subjectName;
        
    }
    
    
}


#pragma  Mark ------  UIPickerViewDataSource, UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.subjectItems_CN.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    SubjectItem *item = self.subjectItems_CN[row];
    
    return item.subjectName;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    SubjectItem *item = self.subjectItems_CN[row];
    
    self.editingCell.contentTF.text =  item.subjectName;
    
    PipeiGroup *group = self.groups[2];
    
    group.content = item.subjectName;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
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
    
    insets.bottom = up ? keyboardEndFrame.size.height + XNav_Height : Bottom_Height;
    
    self.tableView.contentInset = insets;
    
    [self.view layoutSubviews];
    
    [UIView commitAnimations];
}


//提交
- (void)submit:(UIButton *)sender{
    
    
    for (PipeiGroup *group in self.groups) {
        
        if (0 == group.content.length) {
            
            NSString *aler = [NSString stringWithFormat:@"%@不能为空",group.header];
            AlerMessage(aler);
            
            return;
        }
    }
    
    
    RequireLogin
    
 
    PipeiGroup *country = self.groups[0];
    PipeiGroup *university = self.groups[1];
    PipeiGroup *subject = self.groups[2];
    PipeiGroup *score = self.groups[3];
 
    NSString *country_ID;
    for (CountryItem *countyItem in self.countryItems_CN) {
        
        if ([countyItem.CountryName isEqualToString:country.content]) {
            
            country_ID = countyItem.NOid;
            
            break;
        }
        
    }
    
    
    NSString *subject_ID;
    for (SubjectItem *subjcetItem  in self.subjectItems_CN) {
        
        if ([subjcetItem.subjectName isEqualToString:subject.content]) {
            
            subject_ID = subjcetItem.NOid;
            
            break;
        }
        
    }

    
    NSDictionary *parameters =  @{@"des_country":country_ID,@"university":university.content,@"subject":subject_ID,@"score":score.content};
    
    [self
     startAPIRequestWithSelector:kAPISelectorZiZengPipeiPost
     parameters:parameters
     success:^(NSInteger statusCode, id response) {
         

//         IntelligentResultViewController *resultVC =[[IntelligentResultViewController alloc] initWithNibName:@"IntelligentResultViewController" bundle:nil];
//         resultVC.isComeBack = YES;
//         [self.navigationController pushViewController:resultVC animated:YES];
         
     }];
    
    
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
