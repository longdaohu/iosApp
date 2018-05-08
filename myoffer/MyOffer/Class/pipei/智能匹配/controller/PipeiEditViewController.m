//
//  PipeiEditViewController.m
//  myOffer
//
//  Created by xuewuguojie on 2016/11/18.
//  Copyright © 2016年 UVIC. All rights reserved.


#import "PipeiEditViewController.h"
#import "XWGJSummaryView.h"
#import "ZhiXunCell.h"
#import "CountryItem.h"
#import "EvaluateSearchCollegeViewController.h"
#import "IntelligentResultViewController.h"
#import "PromttViewController.h"
#import "WYLXGroup.h"
#import "MyOfferSubjecct.h"
#import "MyOfferCountry.h"
#import "WYLXHeaderView.h"

#define Bottom_Height 150

@interface PipeiEditViewController ()<UITableViewDelegate,UITableViewDataSource,ZiXunCellDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *groups;//分组数组
@property(nonatomic,strong)NSArray *countryItems_CN;//国家原始数据
@property(nonatomic,strong)NSArray *subjectItems_CN;//学科原始数据
@property(nonatomic,strong)UIPickerView *subjectPicker;//学科Picker
@property(nonatomic,strong)UIPickerView *countryPicker;//国家Picker
@property(nonatomic,strong)ZhiXunCell *editingCell;//用于标识正在编辑的Cell
@property(nonatomic,strong)UIButton *submitBtn;//提交按钮
@property(nonatomic,assign)BOOL submitBtnHadDone;//判断提交按钮是否被点击过
@property(nonatomic,strong)PromttViewController *prompVC;//提示页

@end

@implementation PipeiEditViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"page智能匹配"];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //当提交按钮被点击后，如果用户登录后，回到当前页面时会重新加载点击事件
    self.submitBtnHadDone = LOGIN ? self.submitBtnHadDone : NO;
    if (self.submitBtnHadDone) [self submitBtnOnClick:self.submitBtn];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page智能匹配"];
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self getSelectionResourse];
    
    [self makeUI];
    
    [self addNotification];
    
    [self makeDataSource];
    
    [self makeAccountinfo];
    
}

- (void)makeUI{
    
    [self makeTableView];
    
    [self makeBottomView];
   
}

- (void)makeBottomView{
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, XSCREEN_HEIGHT - Bottom_Height, XSCREEN_WIDTH, Bottom_Height)];
    bottomView.backgroundColor = XCOLOR_WHITE;
    [self.view addSubview:bottomView];
    
    UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(25, 0, XSCREEN_WIDTH - 50, 50)];
    [submitBtn setTitle:@"获取匹配结果" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = XFONT(14);
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.layer.cornerRadius = CORNER_RADIUS;
    submitBtn.backgroundColor = XCOLOR_RED;
    [bottomView addSubview:submitBtn];
    self.submitBtn = submitBtn;
    
}

//添加表头
-(void)makeHeaderView
{
    WYLXHeaderView *headerView =[WYLXHeaderView headViewWithTitle:@"通过REBAT大数据分析技术，运用独特TBDT算法，为你一键生成智能匹配方案。"];
    headerView.mj_y = -64;
    
    [self.view insertSubview:headerView aboveSubview:self.tableView];
    self.tableView.contentInset = UIEdgeInsetsMake(headerView.mj_h - 64, 0, 0, 0);

}

- (void)makeTableView {
    
    self.tableView =[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
    self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.showsVerticalScrollIndicator = NO;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    //添加表头
    [self makeHeaderView];

 
}


//添加通知中心
- (void)addNotification{

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

//就读专业
-(UIPickerView *)countryPicker
{
    if(!_subjectPicker){
        
        _countryPicker = [[UIPickerView alloc] init];
        _countryPicker.dataSource = self;
        _countryPicker.delegate = self;
    }
    
    return _countryPicker;
}


#pragma mark : 网格请求

//之前提交的数据
-(void)makeDataSource{
    
    if (!LOGIN) return;
    
    WeakSelf
    [self startAPIRequestWithSelector:kAPISelectorZiZengPipeiGet  parameters:nil success:^(NSInteger statusCode, id response) {
        [weakSelf updateUIWithResponse:response];
    }];
    
}

//用于判断用户是否改变,当用户第一次进入时，会出现提示窗口
- (void)makeAccountinfo{

    
    if (!LOGIN)return;
    
    [self startAPIRequestUsingCacheWithSelector:kAPISelectorAccountInfo parameters:nil success:^(NSInteger statusCode, id response) {
        
        NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
        
        NSString *tokenKey = response[@"accountInfo"][@"_id"];
        
        NSString *value = [ud valueForKey:tokenKey];
        
        if (!value) {
            
            [ud setValue:[[AppDelegate sharedDelegate] accessToken] forKey:tokenKey];
            [ud synchronize];
            
            //当没有数据时，出现智能匹配提示页面
            PromttViewController *pro = [PromttViewController promptView];
            self.prompVC  = pro;
            [pro promptViewShow:YES];
        }
        
    }];
  
}



//提交智能匹配数据
- (void)submitBtnOnClick:(UIButton *)sender{
    
    self.submitBtnHadDone = YES;
    
    for (WYLXGroup *group in self.groups) {
        
        if (group.content.length == 0) {
            [MBProgressHUD showError:[NSString stringWithFormat:@"%@不能为空",group.title] toView:self.view];
            return;
        }
        
    }
    
    RequireLogin
    
    //当从学校页面来到编辑智能匹配页面时，从if里进入
    if (self.Uni_Country) {
        [self fromUniversitySubmit];
        return;
    }
    
    
    sender.enabled = NO;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    for (WYLXGroup *group in self.groups) {
        
        parameters[group.key] = group.content;
        
        if (group.groupType == EditTypeSuject) {
            
            NSString *value = group.content;
         
            
            for (MyOfferSubjecct *subject in self.subjectItems_CN) {
                
                if ([value isEqualToString:subject.name]) {
                
                    value = subject.subject_id;
                    
                    break;
                }
            }
 
            parameters[group.key] = value;

        }
        
    }
    
    WeakSelf
    
    [self startAPIRequestWithSelector:@"POST api/v2/account/evaluate" parameters:parameters expectedStatusCodes:nil showHUD:NO showErrorAlert:YES errorAlertDismissAction:^{
        
    } additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        [weakSelf configrationWithResponse:response];
        
        sender.enabled = YES;
        
        weakSelf.submitBtnHadDone = NO;
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        sender.enabled = YES;
        
        weakSelf.submitBtnHadDone = NO;
        
    }];
    
    
}


//根据网络请求设置UI
- (void)updateUIWithResponse:(NSDictionary *)response{
   
    //新用户未填写资料
    if (response.allKeys.count < 2) return;
    
    for (WYLXGroup *group in self.groups) {
        
        switch (group.groupType) {
                
            case EditTypeCountry:{
                
                NSString *countryName;
                NSInteger index = 0;
                
                for (NSInteger i = 0;  i  < self.countryItems_CN.count;  i ++) {
                    
                    if ([self.countryItems_CN[i] containsString:response[group.key]]) {
                        
                        NSArray *items = [self.countryItems_CN[i] componentsSeparatedByString:@"+"];
                        
                        countryName = items.firstObject;
                        
                        index = i;
                    }
                    
                }
                
                group.content = countryName;
                [self.subjectPicker selectRow:index inComponent:0 animated:YES];
                
                
            }
                break;
            case EditTypeUniversity:
            {
                group.content = response[group.key];

            }
                break;
            case EditTypeSuject:
            {
                
                NSInteger index = 0;
                
                NSString *subject = response[group.key];
                
                for (NSInteger i = 0;  i  < self.subjectItems_CN.count;  i ++) {
                    
                    MyOfferSubjecct *sub = self.subjectItems_CN[i];
                    
                    if ([sub.name isEqualToString:subject] || [sub.subject_id isEqualToString:subject]) {
                        
                        group.content = sub.name;
                        
                        index = i;
                    }
                    
                }
                
                [self.subjectPicker selectRow:index inComponent:0 animated:YES];
                
            }
                break;
                
            case EditTypeSCore:
            {
                
                group.content = response[group.key] ?  [NSString stringWithFormat:@"%.2f",round([response[group.key] floatValue]*100)/100] : @"";

            }
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
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
     self.countryItems_CN = @[@"英国+100",@"澳大利亚+101",@"美国+102",@"新西兰+103",@"中国香港+104"];
    
     NSArray *subjectes = [ud valueForKey:@"Subject_CN"];
     self.subjectItems_CN = [MyOfferSubjecct mj_objectArrayWithKeyValuesArray:subjectes];
    
    if(subjectes.count == 0) [self baseDataSourse:@"subject"];

}


-(NSArray *)groups{
    
    if (!_groups) {

        WYLXGroup *country   =  [WYLXGroup groupWithType:EditTypeCountry title:@"意向国家" placeHolder:@"英国" content:(self.Uni_Country?self.Uni_Country:nil) groupKey:@"des_country" spod:true];
        WYLXGroup *university    =  [WYLXGroup groupWithType:EditTypeUniversity title:@"在读或毕业院校" placeHolder:@"例如：北京大学" content:nil groupKey:@"university" spod:false];
        WYLXGroup *subject    =  [WYLXGroup groupWithType:EditTypeSuject title:@"就读专业" placeHolder:@"经济与金融" content:nil groupKey:@"subject" spod:true];
        WYLXGroup *score  =  [WYLXGroup groupWithType:EditTypeSCore title:@"平均成绩（百分制）" placeHolder:@"例如：80" content:nil groupKey:@"score" spod:false];
        
        _groups = @[country,university,subject,score];
 
    }
    
    return _groups;
}



#pragma mark : UITableViewDelegate,UITableViewDataSource
//超出cell的bounds范围，不能显示
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.clipsToBounds = YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WYLXGroup *group = self.groups[indexPath.row];

    CGFloat cell_Height = group.cell_Height;
    
    if (self.Uni_Country && group.groupType == EditTypeCountry) {
        
        cell_Height = HEIGHT_ZERO;
    }
    
    return cell_Height;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   return  self.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZhiXunCell *cell =[ZhiXunCell cellWithTableView:tableView indexPath:indexPath];
   
    cell.delegate = self;

    cell.group = self.groups[indexPath.row];
  
    switch (cell.group.groupType) {
        case EditTypeSuject:
            cell.inputTF.inputView = self.subjectPicker;
            break;
        case EditTypeSCore:
            cell.inputTF.keyboardType = UIKeyboardTypeDecimalPad;
            break;
        case EditTypeCountry:
            cell.inputTF.inputView = self.countryPicker;
            break;
        case EditTypeUniversity:
            [cell.inputTF addTarget:self action:@selector(casePushUniversity:) forControlEvents:UIControlEventEditingDidBegin];
              break;
        default:
            break;
    }
    
    
    return cell;
    
}

#pragma mark : zixunCellDelegate

- (void)zixunCell:(ZhiXunCell *)cell indexPath:(NSIndexPath *)indexPath   textFieldDidBeginEditing:(UITextField *)textField{
    
    WYLXGroup *group = self.groups[indexPath.row];
    
    self.editingCell = cell;

    //点击学校选项，需要收起键盘，实现跳转
    if (group.groupType ==  EditTypeUniversity) {
        
        [self.view endEditing:YES];
        
        return;
    };
    
    //如果 输入框已有数据， 不需要填充默认数据
    if (cell.inputTF.text.length) return;
    
    NSString *content;
    
    switch (group.groupType) {
        case EditTypeCountry:
            content =  self.countryItems_CN.count == 0 ? @"英国" :  [self.countryItems_CN[0] componentsSeparatedByString:@"+"][0];
            break;
        case EditTypeSuject:
            content =  self.subjectItems_CN.count == 0 ? @"经济与金融" : [self.subjectItems_CN[0] name];
            break;
        default:
            break;
    }

    cell.inputTF.text = content;
    
    group.content = content;
    
}


-  (void)zixunCell:(ZhiXunCell *)cell indexPath:(NSIndexPath *)indexPath   textFieldDidEndEditing:(UITextField *)textField{
    
    WYLXGroup *group = self.groups[indexPath.row];
    
    group.content = textField.text;
}


- (void)zixunCell:(ZhiXunCell *)cell indexPath:(NSIndexPath *)indexPath didClickWithTextField:(UITextField *)textField{
    
    NSIndexPath *nextIndex = [NSIndexPath indexPathForRow: indexPath.row + 1 inSection:indexPath.section];
    
    //最后一条数据时收起键盘
    if (nextIndex.row == self.groups.count) {
        
        [self.view endEditing:YES];
        
        return;
    };
    
    ZhiXunCell *nextCell = [self.tableView cellForRowAtIndexPath:nextIndex];
    
    [nextCell.inputTF becomeFirstResponder];
    
}



#pragma  Mark :  UIPickerViewDataSource, UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return (pickerView == self.subjectPicker) ? self.subjectItems_CN.count : self.countryItems_CN.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString *name;
    
    if (pickerView == self.subjectPicker) {
        
        MyOfferSubjecct *subject = self.subjectItems_CN[row];
        name = subject.name;
        
    }else{
    
        name = [self.countryItems_CN[row] componentsSeparatedByString:@"+"][0];
    }
    
    return name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:self.editingCell];
    WYLXGroup *group = self.groups[indexPath.row];
    
    NSString *name;
    
    switch (group.groupType) {
        case EditTypeCountry:
             name  = [self.countryItems_CN[row] componentsSeparatedByString:@"+"][0];
             break;
        default:{
            MyOfferSubjecct *subjectb  = self.subjectItems_CN[row];
            name = subjectb.name;
        }
            break;
    }
 
    
    
    group.content =  name;

    self.editingCell.inputTF.text =  name;

}

//滚动表格时，收起键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
}


#pragma mark : 用于键盘处理
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
    
    insets.bottom = up ? keyboardEndFrame.size.height + XNAV_HEIGHT : 0;
    
    self.tableView.contentInset = insets;
    
    [self.view layoutSubviews];
    
    [UIView commitAnimations];
}

//获取专业名称对应ID
- (NSString *)subjectIDWithSubjectName:(NSString *)name{
    
    NSString *subject_ID;
    
    for (MyOfferSubjecct *subject  in self.subjectItems_CN) {
        
        if ([subject.name isEqualToString:name]) {
            
            subject_ID = subject.subject_id;
            
            break;
        }
    }
    
    return subject_ID;
}

//当从学校页面来到编辑智能匹配页面时，从if里进入
-(void)fromUniversitySubmit{
    
    NSMutableString *pString = [NSMutableString string];
    
    [pString  appendFormat:@"?"];
    
    for (WYLXGroup *group in self.groups) {
        
        [pString  appendFormat:@"%@", [NSString stringWithFormat:@"%@=%@&",group.key,group.content]];
        
    }
    
    if (self.actionBlock) {
        
        self.actionBlock([[pString substringWithRange:NSMakeRange(0, pString.length-1)] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

//根据条件跳转页面
- (void)configrationWithResponse:(id)response{
    
    if (self.actionBlock) {
        
        self.actionBlock(@"去刷新");
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        
        IntelligentResultViewController *resultVC =[[IntelligentResultViewController alloc] initWithNibName:@"IntelligentResultViewController" bundle:nil];
        resultVC.from_Edit_Pipei = YES;
        [self.navigationController pushViewController:resultVC animated:YES];
    }
    
}



- (void)casePushUniversity:(UITextField *)sender{
    
        EvaluateSearchCollegeViewController *search =[[EvaluateSearchCollegeViewController alloc] init];
    
        search.valueBlock = ^(NSString *value){
    
            if ( 0 == value.length) return ;
            
            self.editingCell.inputTF.text = value;
            
            NSIndexPath *indexPath = [self.tableView indexPathForCell:self.editingCell];
          
            WYLXGroup *university = self.groups[indexPath.row];
            
            university.content = value;
    
        };
    
        [self.navigationController pushViewController:search animated:YES];
    
}




- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    KDClassLog(@"智能匹配 + 编辑 + PipeiEditViewController +dealloc");
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
