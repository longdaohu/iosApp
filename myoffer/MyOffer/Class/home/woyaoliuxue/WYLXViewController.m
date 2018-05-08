//
//  XLiuxueViewController.m
//  XJHtester
//
//  Created by xuewuguojie on 16/3/29.
//  Copyright © 2016年 小米. All rights reserved.
//

#import "WYLXViewController.h"
#import "WYLXHeaderView.h"
#import "WYLXSuccessView.h"
#import "WYLXGroup.h"
#import "ZhiXunCell.h"
#import "ZixunFooterView.h"


typedef NS_ENUM(NSInteger,PickerViewType){
    
    PickerViewTypeCountry = 110,
    PickerViewTypeSubject,
    PickerViewTypeGrade,
    PickerViewTypeCode
};


@interface WYLXViewController ()<UITableViewDataSource,UITableViewDelegate,ZiXunCellDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

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
@property(nonatomic,strong)ZhiXunCell *editingCell;
//提示框
@property(nonatomic,strong)WYLXSuccessView *sucessView;
//数据源
@property(nonatomic,strong)NSArray *groups;

@property(nonatomic,strong)ZixunFooterView *footer;

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
  
        WYLXGroup *contry   =  [WYLXGroup groupWithType:EditTypeCountry title:@"想去的留学目的地" placeHolder:@"英国" content:nil groupKey:@"des_country" spod:true];
        WYLXGroup *phone    =  [WYLXGroup groupWithType:EditTypePhone title:@"联系电话" placeHolder:@"请输入手机号码" content:nil groupKey:@"phonenumber" spod:false];
        WYLXGroup *grade    =  [WYLXGroup groupWithType:EditTypeGrade title:@"就读年级" placeHolder:@"本科大四" content:nil groupKey:@"grade" spod:true];
        WYLXGroup *subject  =  [WYLXGroup groupWithType:EditTypeSuject title:@"就读专业" placeHolder:@"经济与金融" content:nil groupKey:@"subject" spod:true];
        
        _groups = @[contry,phone,grade,subject];
    }
    return _groups;
}


-(WYLXSuccessView *)sucessView
{
    if (!_sucessView) {
        
        WeakSelf
        _sucessView = [WYLXSuccessView successViewWithBlock:^{
            
            [weakSelf dismiss];

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
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    [self.view  addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self makeHeaderAndFooterView];
 
}

- (void)makeHeaderAndFooterView{
    
    
    WeakSelf
    WYLXHeaderView *headerView =[WYLXHeaderView headViewWithTitle:@"嗨, 想快速获得留学信息和申请方案？只需填写留学意向，我们的专业顾问将立即为你服务！"];
    headerView.actionBlock = ^{
        
        [weakSelf dismiss];

    };
    [self.view insertSubview:headerView aboveSubview:self.tableView];
    self.tableView.contentInset = UIEdgeInsetsMake(headerView.mj_h, 0, 0, 0);
    
    ZixunFooterView *footer = [[ZixunFooterView alloc] initWithFrame:CGRectMake(0, XSCREEN_HEIGHT - 60, XSCREEN_WIDTH, 60)];
    self.footer = footer;
    footer.actionBlock = ^(UIButton *sender){
      
        if ([sender.currentTitle isEqualToString:@"提交"]) {
            
            [weakSelf caseLiuxueRequest];
            
        }else{
        
            [weakSelf caseCall];
        }
        
        
    };
    [self.view insertSubview:footer aboveSubview:self.tableView];
  
}


#pragma mark : UITableViewDataSource,UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{

    WYLXGroup *group = self.groups[indexPath.row];

    return group.cell_Height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return self.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    ZhiXunCell *cell =[ZhiXunCell cellWithTableView:tableView indexPath:indexPath];
    
    cell.group = self.groups[indexPath.row];
    
    cell.delegate = self;
    
    switch (indexPath.row) {
            
        case 0:
            cell.inputTF.inputView = self.countryPicker;
             break;
        case 1:
            cell.inputTF.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case 2:
            cell.inputTF.inputView = self.gradePicker;
            break;
        default:
            cell.inputTF.inputView = self.subjectPicker;
            break;
    }
    
    return cell;
    
}


#pragma mark : UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
}




//提交成功提示框
-(void)sucessViewUp
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        
        self.sucessView.alpha = 1;

    }];
    
}


#pragma mark : zixunCellDelegate

- (void)zixunCell:(ZhiXunCell *)cell indexPath:(NSIndexPath *)indexPath   textFieldDidBeginEditing:(UITextField *)textField{

    self.editingCell = cell;
    
    WYLXGroup *group = self.groups[indexPath.row];

    if (!cell.inputTF.text.length) {
        
        NSString *content;
        
        switch (indexPath.row) {
            case 0:
                content =  self.countryArr.count == 0 ? @"英国" : self.countryArr[0];
                break;
            case 2:
                content =  self.gradeArr.count == 0 ?  @"本科大四" : self.gradeArr[0];
                break;
            case 3:
                content =  self.subjectArr.count == 0 ? @"艺术与设计" : self.subjectArr[0];
                break;
            default:
                break;
        }
        
        cell.inputTF.text = content;
        
        group.content = content;
    }
  
    
}

-  (void)zixunCell:(ZhiXunCell *)cell indexPath:(NSIndexPath *)indexPath   textFieldDidEndEditing:(UITextField *)textField{

    WYLXGroup *group = self.groups[indexPath.row];
    
    if (group.groupType == EditTypePhone) {
        
        group.content = textField.text;

    }

}


- (void)zixunCell:(ZhiXunCell *)cell indexPath:(NSIndexPath *)indexPath didClickWithTextField:(UITextField *)textField{
    
     NSIndexPath *nextIndex = [NSIndexPath indexPathForRow: indexPath.row + 1 inSection:indexPath.section];
  
    if (nextIndex.row == self.groups.count) {
        
        [self.view endEditing:YES];
    
        return;
    };
    
    
    ZhiXunCell *nextCell = [self.tableView cellForRowAtIndexPath:nextIndex];
    
    [nextCell.inputTF becomeFirstResponder];
    
}




#pragma mark : UIPickerViewDataSource, UIPickerViewDelegate

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
    
    
    NSIndexPath *indexpath = [self.tableView indexPathForCell:self.editingCell];
    
    WYLXGroup *group = self.groups[indexpath.row];
    
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
    

    self.editingCell.inputTF.text = content;
    group.content = content;
    
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
    
    UIEdgeInsets insets =   _tableView.contentInset;
    
    insets.bottom = up ? keyboardEndFrame.size.height : 0;
   
    _tableView.contentInset = insets;
    
    [self.view layoutSubviews];
    
    [UIView commitAnimations];
}


// 提交我要留学申请
-(void)caseLiuxueRequest{
    
    NSMutableDictionary *fastPass = [NSMutableDictionary dictionary];
    
    for (WYLXGroup *group in self.groups) {
  
        
        if ((group.groupType == EditTypePhone) && (group.content.length < 7)) {
            
           MBProgressHUD *hud = [MBProgressHUD showMessage:@"请输入正确电话号码！" toView:self.view];
            // 再设置模式
            hud.mode = MBProgressHUDModeText;
            
            [hud hideAnimated:YES afterDelay:1];
            
            return;
        }
        
        NSString *value = group.content ? group.content : group.placeHolder;
        
        [fastPass setValue:value forKey:group.key];

    }
    
    
    WeakSelf
    NSDictionary *parameters =  @{@"fastPass": fastPass};
    [self
     startAPIRequestWithSelector:kAPISelectorWoYaoLiuXue
     parameters:parameters
     success:^(NSInteger statusCode, id response) {
         
         [weakSelf sucessViewUp];
         
     }];
    
}


- (void)caseCall{
    
    
    NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"4000666522"];
   
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:^(BOOL success) {
        
        [self.footer callButtonEnable:YES];
    }];
    
}




-(void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    KDClassLog(@"我要留学  dealloc");
}
@end
