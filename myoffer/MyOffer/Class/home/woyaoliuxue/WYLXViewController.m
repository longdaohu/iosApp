//
//  XLiuxueViewController.m
//  XJHtester
//
//  Created by xuewuguojie on 16/3/29.
//  Copyright © 2016年 小米. All rights reserved.
//

#import "WYLXViewController.h"
#import "WYLXHeaderView.h"
#import "WYLXCell.h"
#import "WYLXSuccessView.h"
#import "NomalTableSectionHeaderView.h"
#import "WYLXGroup.h"

typedef enum {
    PickerViewTypeCountry = 110,
    PickerViewTypeSubject = 111,
    PickerViewTypeGrade = 112,
    PickerViewTypeCode = 113
}PickerViewType;//表头按钮选项


@interface WYLXViewController ()<UITableViewDataSource,UITableViewDelegate,WYLXCellDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic,strong)UITableView *tableView;
//国家名称数组
@property(nonatomic,strong)NSArray *countryArr;
//年级数组
@property(nonatomic,strong)NSArray *gradeArr;
//专业数组
@property(nonatomic,strong)NSArray *subjectArr;
//国家名称picker
@property(nonatomic,strong)UIPickerView *countryPicker;
//年级picker
@property(nonatomic,strong)UIPickerView *gradePicker;
//专业picker
@property(nonatomic,strong)UIPickerView *subjectPicker;
//正在编辑的cell
@property(nonatomic,strong)WYLXCell *editingCell;
//提示框
@property(nonatomic,strong)WYLXSuccessView *sucessView;
//数据源
@property(nonatomic,strong)NSArray *groups;

@end


@implementation WYLXViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [MobClick beginLogPageView:@"page我要留学"];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page我要留学"];
    
}

- (UIPickerView *)PickerViewWithTag:(PickerViewType)type{
    
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.dataSource = self;
    picker.delegate = self;
    picker.tag = type;
    return picker;
}

-(UIPickerView *)countryPicker
{
    if (!_countryPicker) {
        
        _countryPicker = [self PickerViewWithTag:PickerViewTypeCountry];
        
    }
    return _countryPicker;
}


-(UIPickerView *)gradePicker
{
    if (!_gradePicker) {
        
        _gradePicker = [self PickerViewWithTag:PickerViewTypeGrade];
        
    }
    return _gradePicker;
}

-(UIPickerView *)subjectPicker
{
    if (!_subjectPicker) {
        
        _subjectPicker = [self PickerViewWithTag:PickerViewTypeSubject];
        
    }
    return _subjectPicker;
}



-(NSArray *)groups{

    if (!_groups) {
        
        WYLXGroup *contry   =  [WYLXGroup groupWithHeader:@"想去的国家"   content:nil cellKey:@"country"];
        WYLXGroup *phone   =  [WYLXGroup groupWithHeader:@"联系电话"   content:nil cellKey:@"phone"];
        WYLXGroup *grade =  [WYLXGroup groupWithHeader:@"就读年级"   content:nil cellKey:@"grade"];
        WYLXGroup *subject  =  [WYLXGroup groupWithHeader:@"就读专业"   content:nil cellKey:@"subject"];
        
        _groups = @[contry,phone,grade,subject];
    }
    return _groups;
}


-(WYLXSuccessView *)sucessView
{
    if (!_sucessView) {
        
        XWeakSelf
        _sucessView = [WYLXSuccessView successViewWithBlock:^{
            
            [weakSelf.navigationController popViewControllerAnimated:YES];

        }];
 
         [self.view addSubview:_sucessView];
    }
    return _sucessView;
}



- (void)viewDidLoad {
  
    [super viewDidLoad];
    
    [self makeUI];
    
}


- (void)makeUI{

    self.title = GDLocalizedString(@"WoYaoLiuXue_title");
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self makeTableView];
    
    [self getSelectionResourse];
    
    [self addNotificationCenter];
    
}


//选择项数组
-(void)getSelectionResourse
{
    
    NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
    
    NSString *countryKey = @"Country_CN";
    NSArray *countries = [ud valueForKey:countryKey];
    if(!countries.count){
        [self baseDataSourse:@"country"];
    }
    self.countryArr = [countries valueForKeyPath:@"name"];

     NSString *gradeKey =  @"Grade_CN";
    NSArray *grades = [ud valueForKey:gradeKey];
    if(!grades.count){
        [self baseDataSourse:@"grade"];
    }
    self.gradeArr = [grades valueForKeyPath:@"name"];
    
     NSString *subjectKey =  @"Subject_CN";
    NSArray *subjectes = [ud valueForKey:subjectKey];
    if(!subjectes.count){
        [self baseDataSourse:@"subject"];
    }
    self.subjectArr = [subjectes valueForKeyPath:@"name"];
    
}

//键盘处理通知
-(void)addNotificationCenter
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)makeTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, XSCREEN_HEIGHT - XNAV_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.sectionFooterHeight = 8;
    self.tableView.backgroundColor = XCOLOR_BG;
    [self.view  addSubview:self.tableView];
    
    [self makeHeaderAndFooterView];

}

- (void)makeHeaderAndFooterView{
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, 100)];
    UIButton *commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.5 *(XSCREEN_WIDTH - 300), 25, 300, 50)];
    [commitBtn setTitle:@"我要留学" forState:UIControlStateNormal];
    [commitBtn setTitleColor:XCOLOR_WHITE forState:UIControlStateNormal];
    [commitBtn setTitleColor:XCOLOR_LIGHTGRAY forState:UIControlStateHighlighted];
    commitBtn.backgroundColor = XCOLOR_RED;
    commitBtn.layer.cornerRadius = CORNER_RADIUS;
    [commitBtn addTarget:self action:@selector(caseLiuxueRequest) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:commitBtn];
    
    
    WYLXHeaderView *headerView =[WYLXHeaderView headViewWithContent:GDLocalizedString(@"WoYaoLiuXue_FillInfor")];
   
    [self.tableView beginUpdates];
    self.tableView.tableHeaderView = headerView;
    self.tableView.tableFooterView = footerView;
    [self.tableView endUpdates];
 
}


#pragma mark —————— UITableViewDataSource,UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 20 * XPERCENT;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NomalTableSectionHeaderView *header =[NomalTableSectionHeaderView sectionViewWithTableView:tableView];
    
    WYLXGroup *group = self.groups[section];
    
    [header sectionHeaderWithTitle:group.headerTitle FontSize: XPERCENT *13.0];
    
    return header;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.groups.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    WYLXCell *cell =[WYLXCell cellWithTableView:tableView cellForIndexPath:indexPath];
    cell.delegate = self;
    switch (indexPath.section) {
            
        case 0:
            cell.titleTF.inputView = self.countryPicker;
             break;
        case 1:
            cell.titleTF.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case 2:
            cell.titleTF.inputView = self.gradePicker;
            break;
        default:
            cell.titleTF.inputView = self.subjectPicker;
            break;
    }
    
    return cell;
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
}


//判断必填项是否为空
-(BOOL)checkFillInformationWithContent:(WYLXGroup *)group{
    
    if (!group.content.length) {
        
         NSString *message = [NSString stringWithFormat:@"%@%@",group.headerTitle,GDLocalizedString(@"TiJiao-Empty")];
         AlerMessage(message);
        
         return NO;
    
    }else if ([group.cellKey isEqualToString:@"phone"] && (group.content.length < 7)) {
  
         AlerMessage(@"请输入正确的手机号码");
        
         return NO;
    
     }else{
        
        return YES;
    }

}
    


//提交成功提示框
-(void)sucessViewUp
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        
        self.sucessView.top = 0;

    }];
    
}


#pragma mark —————————— XliuxueTableViewCellDelegate
-(void)XliuxueTableViewCell:(WYLXCell *)cell withIndexPath:(NSIndexPath *)indexPath   textFieldDidBeginEditing:(UITextField *)textField{

    self.editingCell = cell;
    
    
    if (!cell.titleTF.text.length) {
        
        WYLXGroup *group = self.groups[indexPath.section];

        NSString *content;
        
        switch (indexPath.section) {
            case 0:
                 content =  self.countryArr.count == 0 ? @"英国" : self.countryArr[0];
                  break;
            case 2:
                 content =  self.gradeArr.count == 0 ? @"本科大四" : self.gradeArr[0];
                  break;
            case 3:
                 content =  self.subjectArr.count == 0 ? @"艺术与设计" : self.subjectArr[0];
                 break;
            default:
                break;
        }
        
        cell.titleTF.text = content;
        group.content = content;
    }
    
}

-(void)XliuxueTableViewCell:(WYLXCell *)cell withIndexPath:(NSIndexPath *)indexPath   textFieldDidEndEditing:(UITextField *)textField{
    
    WYLXGroup *group = self.groups[indexPath.section];
    
    if ([group.cellKey isEqualToString:@"phone"]) {
     
        group.content = textField.text;
        
    }
    
}


-(void)XliuxueTableViewCell:(WYLXCell *)cell withIndexPath:(NSIndexPath *)indexPath didClick:(UIBarButtonItem *)sender{
    
    NSInteger newSection = indexPath.section + 1;
    
    if (10  == sender.tag ||  self.groups.count == newSection) {
        
        [self.view endEditing:YES];
        
        return;
        
    }
    
    NSIndexPath *nextIndex = [NSIndexPath indexPathForRow:indexPath.row inSection:newSection];
    WYLXCell *nextCell = [self.tableView cellForRowAtIndexPath:nextIndex];
    [nextCell.titleTF becomeFirstResponder];
    
}


#pragma mark ----UIPickerViewDataSource, UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    switch (pickerView.tag) {
            
        case PickerViewTypeCountry:
            return self.countryArr.count;
            break;
        case PickerViewTypeSubject:
            return self.subjectArr.count;
            break;
        case PickerViewTypeCode:
             return 0;
            break;
         default:
             return self.gradeArr.count;
            break;
    }
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    switch (pickerView.tag) {
        case PickerViewTypeCountry:
            return  self.countryArr[row];
            break;
        case PickerViewTypeSubject:
             return  self.subjectArr[row];
            break;
        case PickerViewTypeCode:
            return @"中国(+86)";
            break;
        default:
            return  self.gradeArr[row];
            break;
    }
    
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    WYLXCell *Editingcell = ( WYLXCell *)self.editingCell;
    NSIndexPath *indexpath = [self.tableView indexPathForCell:Editingcell];
    WYLXGroup *group = self.groups[indexpath.section];
    
    NSString *content;
    switch (pickerView.tag) {
        case PickerViewTypeCountry:
            content = self.countryArr[row];
             break;
         case PickerViewTypeSubject:
            content = self.subjectArr[row];
            break;
        case PickerViewTypeCode:
            break;
        default:
            content =  self.gradeArr[row];
            break;
    }
    
    Editingcell.titleTF.text = content;
    group.content = content;
    
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
    
    UIEdgeInsets insets =   _tableView.contentInset;
    
    insets.bottom = up ? keyboardEndFrame.size.height : 50;
   
    _tableView.contentInset = insets;
    
    [self.view layoutSubviews];
    
    [UIView commitAnimations];
}


// 提交我要留学申请
-(void)caseLiuxueRequest{
    
    NSMutableDictionary *fastPass = [NSMutableDictionary dictionary];
    
    for (WYLXGroup *group in self.groups) {
        
        if (![self checkFillInformationWithContent:group])return;
        
        NSString *key;
        
        if ([group.cellKey isEqualToString:@"country"]) {
            
            key = @"des_country";
            
        }else if ([group.cellKey isEqualToString:@"phone"]) {
            
            key = @"phonenumber";
   
        }else if ([group.cellKey isEqualToString:@"grade"]) {
            
            key = @"grade";
   
        }else if ([group.cellKey isEqualToString:@"subject"]) {
            
            key = @"subject";
  
        }
        
        [fastPass setValue:group.content forKey:key];

    }
    
    XWeakSelf
    NSDictionary *parameters =  @{@"fastPass": fastPass};
    [self
     startAPIRequestWithSelector:kAPISelectorWoYaoLiuXue
     parameters:parameters
     success:^(NSInteger statusCode, id response) {
         
         [weakSelf sucessViewUp];
         
     }];
    
}



-(void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    KDClassLog(@"我要留学  dealloc");
}
@end
