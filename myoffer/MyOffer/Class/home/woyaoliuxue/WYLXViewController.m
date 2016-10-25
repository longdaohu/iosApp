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
#import "WYLXFooterView.h"
#import "InteProfileViewController.h"
#import "YourPhoneView.h"
#import "WYLXSuccessView.h"
#import "NomalTableSectionHeaderView.h"

#define Failure @"fail"
typedef enum {
    PickerViewTypeCountry = 110,
    PickerViewTypeSubject = 111,
    PickerViewTypeGrade = 112,
    PickerViewTypeCode = 113
}PickerViewType;//表头按钮选项

typedef enum {
    LiuxuePageClickItemTypeNoClick,
    LiuxuePageClickItemTypeWoyaoliuxue,
    LiuxuePageClickItemTypePipei
}LiuxuePageClickItemType;


@interface WYLXViewController ()<UITableViewDataSource,UITableViewDelegate,WYLXCellDelegate,UIPickerViewDataSource,UIPickerViewDelegate,YourPhoneViewDelegate>

@property(nonatomic,strong)UITableView *tableView;
//分区title数组
@property(nonatomic,strong)NSArray *sectionTitles;
//手机号码
@property(nonatomic,copy)NSString *phoneNumber;
//国家名称
@property(nonatomic,copy)NSString *country;
//就读年级
@property(nonatomic,copy)NSString *grade;
//就读专业
@property(nonatomic,copy)NSString *ApplySubject;
//国家名称数组
@property(nonatomic,strong)NSArray *countryArr;
//年级数组
@property(nonatomic,strong)NSArray *gradeArr;
//专业数组
@property(nonatomic,strong)NSArray *subjectArr;
//国家区号picker
@property(nonatomic,strong)UIPickerView *countryCodePicker;
//国家名称picker
@property(nonatomic,strong)UIPickerView *countryPicker;
//年级picker
@property(nonatomic,strong)UIPickerView *gradePicker;
//专业picker
@property(nonatomic,strong)UIPickerView *subjectPicker;
//正在编辑的cell
@property(nonatomic,strong)WYLXCell *editingCell;
//填写手机号编辑框
@property(nonatomic,strong)YourPhoneView *PhoneView;
//遮盖
@property(nonatomic,strong)UIButton *cover;
//直接进入编辑框 ———— 倒计时Timer
@property(nonatomic,strong)NSTimer *verifyCodeColdDownTimer;
//直接进入编辑框 ———— 倒计时
@property(nonatomic,assign)int verifyCodeColdDownCount;
//国家区号数组
@property(nonatomic,strong)NSArray *AreaCodes;
//提示框
@property(nonatomic,strong)WYLXSuccessView *sucessView;
//用于标识提交留学按钮是还被点击
@property(nonatomic,assign)LiuxuePageClickItemType clickType;

@end


@implementation WYLXViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [MobClick beginLogPageView:@"page我要留学"];
    
    [self presentViewWillAppear];
}

-(void)presentViewWillAppear
{
    
    if (LOGIN) {
        
        [self getYourPhoneNumber:NO];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self PageClickWithItemType:self.clickType];
            
        });
        
    }else{
    
        self.phoneNumber = Failure;

    }

    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page我要留学"];
    
}

-(UIPickerView *)PickerViewWithTag:(PickerViewType)type
{
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

-(UIPickerView *)countryCodePicker
{
    if (!_countryCodePicker) {
        
        _countryCodePicker = [self PickerViewWithTag:PickerViewTypeCode];
        
    }
    return _countryCodePicker;
}


-(NSArray *)AreaCodes
{
    if (!_AreaCodes) {
        
        _AreaCodes = @[GDLocalizedString(@"LoginVC-china"),GDLocalizedString(@"LoginVC-english")];//@[@"中国(+86)",@"英国(+44)"];
    }
    return _AreaCodes;
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

-(NSArray *)sectionTitles
{
    if (!_sectionTitles) {
        
        _sectionTitles = @[GDLocalizedString(@"TiJiao-Country"),GDLocalizedString(@"UniversityBG-002"),GDLocalizedString(@"UniversityBG-003")];
    }
    return _sectionTitles;
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
    
    [self makePhoneView];
}


-(void)makePhoneView
{
    self.cover =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, XScreenWidth, XScreenHeight)];
    self.cover.backgroundColor = XCOLOR_BLACK;
    self.cover.alpha = 0;
    [self.view addSubview:self.cover];
    
    
    self.PhoneView =[[YourPhoneView alloc] initWithFrame:CGRectMake(0, XScreenHeight,XScreenWidth, 300)];
    self.PhoneView.countryCode.inputView = self.countryCodePicker;
    self.PhoneView.delegate = self;
    [self.view addSubview:self.PhoneView];
    
}


 //请求头像信息
-(void)getYourPhoneNumber:(BOOL)Alert
{
    [self startAPIRequestWithSelector:kAPISelectorAccountInfo parameters:nil expectedStatusCodes:nil showHUD:NO showErrorAlert:Alert errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        self.phoneNumber = response[@"accountInfo"][@"phonenumber"];
       
        if (Alert) {
            
            if (self.phoneNumber.length>0) {
                
                [self sendLiuxueRequest];
                
            }else{
                
                [self PhoneViewHiden:NO];
                
            }
         }
        
     } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        self.phoneNumber = Failure;
        
    }];
}

//选择项数组
-(void)getSelectionResourse
{
    
    NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
    
    NSString *countryKey = USER_EN ? @"Country_EN":@"Country_CN";
    NSArray *countries = [ud valueForKey:countryKey];
    if(countries.count == 0){
        [self baseDataSourse:@"country"];
    }
    self.countryArr = [countries valueForKeyPath:@"name"];

    NSString *gradeKey = USER_EN ? @"Grade_EN":@"Grade_CN";
    NSArray *grades = [ud valueForKey:gradeKey];
    if(grades.count == 0){
        [self baseDataSourse:@"grade"];
    }
    self.gradeArr = [grades valueForKeyPath:@"name"];
    
    NSString *subjectKey = USER_EN ? @"Subject_EN":@"Subject_CN";
    NSArray *subjectes = [ud valueForKey:subjectKey];
    if(subjectes.count == 0){
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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, XScreenWidth, XScreenHeight - XNav_Height) style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.sectionFooterHeight = 8;
    self.tableView.backgroundColor = XCOLOR_BG;
    [self.view  addSubview:self.tableView];
    
    [self makeHeaderAndFooterView];

}



-(void)makeHeaderAndFooterView
{
    
    XWeakSelf
    WYLXFooterView *footerView = [WYLXFooterView footerViewWithBlock:^(UIButton *sender) {
        
        [weakSelf liuxueFooterViewDidClick:sender];
 
    }];
    
    
    WYLXHeaderView *headerView =[WYLXHeaderView headViewWithFrame:CGRectMake(0, 0,XScreenWidth,0)];
    headerView.title = GDLocalizedString(@"WoYaoLiuXue_FillInfor");
    
    [self.tableView beginUpdates];
    self.tableView.tableHeaderView = headerView;
    self.tableView.tableFooterView = footerView;
    [self.tableView endUpdates];
    

}


#pragma mark —————— UITableViewDataSource,UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 20 * XPERCENT;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NomalTableSectionHeaderView *header =[NomalTableSectionHeaderView sectionViewWithTableView:tableView];
    
    [header sectionHeaderWithTitle:self.sectionTitles[section] FontSize: XPERCENT *13.0];
    
    return header;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.sectionTitles.count;
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
            cell.titleTF.inputView = self.gradePicker;
            break;
        default:
            cell.titleTF.inputView = self.subjectPicker;
            break;
    }
    
    
    return cell;
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
    [self.view endEditing:YES];
}


//判断必填项是否为空
-(BOOL)checkFillInformation
{
    
    if (!self.country) {
        
        NSString *message = [NSString stringWithFormat:@"%@%@",self.sectionTitles[0],GDLocalizedString(@"TiJiao-Empty")];
        AlerMessage(message);
        
        return NO;
    
    }else if (!self.grade)
    {
        NSString *message = [NSString stringWithFormat:@"%@%@",self.sectionTitles[1],GDLocalizedString(@"TiJiao-Empty")];
        AlerMessage(message);
        
        return NO;
    }

    else if (!self.ApplySubject)
    {
        NSString *message = [NSString stringWithFormat:@"%@%@",self.sectionTitles[2],GDLocalizedString(@"TiJiao-Empty")];
        
        AlerMessage(message);
 
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


#pragma mark —————————— XliuxueFooterBlock
-(void)liuxueFooterViewDidClick:(UIButton *)sender{
   
    switch (sender.tag) {
            
        case FooterButtonTypePipei:
            
            [self PageClickWithItemType:LiuxuePageClickItemTypePipei];
            
            break;
        case FooterButtonTypeLiuxue:
            
            [self PageClickWithItemType:LiuxuePageClickItemTypeWoyaoliuxue];
            
            break;
        default:
            
            break;
    }
 
}


#pragma mark —————————— XliuxueTableViewCellDelegate
-(void)XliuxueTableViewCell:(WYLXCell *)cell withIndexPath:(NSIndexPath *)indexPath   textFieldDidBeginEditing:(UITextField *)textField{

    self.editingCell = cell;
    
    
    if (cell.titleTF.text.length == 0) {
        
        switch (indexPath.section) {
            case 0:
            {
                NSString *countryName =  self.countryArr.count == 0 ? @"英国" : self.countryArr[0];
                cell.titleTF.text = countryName;
                self.country = countryName;
            }
                break;
            case 1:
            {
                NSString *gradeName =  self.gradeArr.count == 0 ? @"本科大四" : self.gradeArr[0];
                cell.titleTF.text = gradeName;
                self.grade = gradeName;

            }
                break;
            default:
            {
                NSString *subjectName =  self.subjectArr.count == 0 ? @"艺术与设计" : self.subjectArr[0];
                cell.titleTF.text = subjectName;
                self.ApplySubject = subjectName;
            }

                break;
        }

    }
    
}
-(void)XliuxueTableViewCell:(WYLXCell *)cell withIndexPath:(NSIndexPath *)indexPath didClick:(UIBarButtonItem *)sender
{
    
    NSInteger newSection = indexPath.section + 1;
    
    if (10  == sender.tag || 3 == newSection) {
        
        [self.view endEditing:YES];
        
        return;
        
    }
    
        NSIndexPath *nextIndex = [NSIndexPath indexPathForRow:indexPath.row inSection:newSection];
        WYLXCell *nextCell = [self.tableView cellForRowAtIndexPath:nextIndex];
        [nextCell.titleTF becomeFirstResponder];
    
}


#pragma mark ---- YourPhoneViewDelegate
-(void)YourPhoneView:(YourPhoneView *)PhoneView WithButtonItem:(UIButton *)sender
{
    if (11 == sender.tag) {
        
        [self PhoneViewHiden:YES];
        
    }else if(10 == sender.tag)
    {
        
        [self sendVerificationCode];
        
    }else{
        
        [self CommitVerifyCode];
        
    }
    
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
             return self.AreaCodes.count;
            break;
         default:
             return self.gradeArr.count;
            break;
    }
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    switch (pickerView.tag) {
        case PickerViewTypeCountry:{
            return  self.countryArr[row];
        }
            break;
        case PickerViewTypeSubject:{
            
             return  self.subjectArr[row];
        }
            break;
        case PickerViewTypeCode:
            return self.AreaCodes[row];
            break;

        default:
            return  self.gradeArr[row];
            break;
    }
    
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    WYLXCell *Editingcell = ( WYLXCell *)self.editingCell;
    
    switch (pickerView.tag) {
        case PickerViewTypeCountry:{
            
            Editingcell.titleTF.text = self.countryArr[row];
            self.country =  self.countryArr[row];
            
        }
            break;
         case PickerViewTypeSubject:{
            
             Editingcell.titleTF.text = self.subjectArr[row];
             self.ApplySubject =  self.subjectArr[row];

        }
            break;
        case PickerViewTypeCode:{
            
             self.PhoneView.countryCode.text =  self.AreaCodes[row];
            
        }
            break;
        default:{
            Editingcell.titleTF.text =  self.gradeArr[row];
            self.grade = self.gradeArr[row];
        }
            break;
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
    
 
    if (self.PhoneView.frame.origin.y < XScreenHeight) {
        
        if (up) {
            
            self.PhoneView.center = CGPointMake(self.view.frame.size.width / 2.0f, (self.view.frame.size.height - keyboardEndFrame.size.height) / 2.0f);
            
        } else {
            
             self.PhoneView.center = CGPointMake(self.view.frame.size.width / 2.0f, XScreenHeight * 2/3);
        }
        
    }else{
        
        UIEdgeInsets insets =   _tableView.contentInset;
        if (up) {
            insets.bottom = keyboardEndFrame.size.height;
        } else {
            insets.bottom = 50;
        }
        _tableView.contentInset = insets;
    
    }
    
    
    [self.view layoutSubviews];
    
    [UIView commitAnimations];
}



//实现不同选项跳转
-(void)PageClickWithItemType:(LiuxuePageClickItemType)type
{
    self.clickType = LOGIN ? LiuxuePageClickItemTypeNoClick : type;
    
    RequireLogin
    
    switch (type) {
            
        case  LiuxuePageClickItemTypePipei:
            
            [self casePipei];
            
            break;
        case  LiuxuePageClickItemTypeWoyaoliuxue:
            
            [self caseWoyaoliuxue];
            
            break;
            
        default:
            break;
    }
    
    
}
 

//点击智能匹配选项
-(void)casePipei{
    
    InteProfileViewController *pipei =[[InteProfileViewController alloc] init];
    pipei.isComeBack = YES;
    [self.navigationController pushViewController:pipei animated:YES];
}

//我要留学选项
-(void)caseWoyaoliuxue{

    if (![self checkFillInformation]) {
        
        return;
    }
    
    RequireLogin
    
    if ([self.phoneNumber isEqualToString:Failure ]|| self.phoneNumber.length == 0) {
        
        //如果第一次请求失败，得到一个错误的电话号码，这里要求重新请求
        [self getYourPhoneNumber:YES];
    }
    
    if(self.phoneNumber.length == 0){
        
        //如果用户手机号为空
        [self PhoneViewHiden:NO];
        
    }else{
        //有手机号，直接提交
        [self sendLiuxueRequest];
    }

}

// 提交我要留学申请
-(void)sendLiuxueRequest
{
 
    XWeakSelf
    NSDictionary *parameters =  @{@"fastPass": @{@"des_country": self.country, @"grade":self.grade, @"subject":self.ApplySubject, @"phonenumber":self.phoneNumber}};
    
    [self
     startAPIRequestWithSelector:kAPISelectorWoYaoLiuXue
     parameters:parameters
     success:^(NSInteger statusCode, id response) {
         
         [weakSelf sucessViewUp];
         
     }];
    
}

// 发送验证码
-(void)sendVerificationCode
{
    
    if (![self checkPhoneTextField]) {
        
        return ;
    }
    
    NSString *AreaNumber =  [self.PhoneView.countryCode.text containsString:@"44"] ? @"44":@"86";
    NSString *phoneNumber = self.PhoneView.PhoneTF.text;
    
    self.PhoneView.SendCodeBtn.enabled = NO;
    
    XWeakSelf
    
    [self startAPIRequestWithSelector:kAPISelectorSendVerifyCode parameters:@{@"code_type":@"phone", @"phonenumber":  phoneNumber, @"target": phoneNumber, @"mobile_code": AreaNumber} expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        weakSelf.verifyCodeColdDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runVerifyCodeColdDown) userInfo:nil repeats:YES];
        weakSelf.verifyCodeColdDownCount = Time_CountDown;
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        weakSelf.PhoneView.SendCodeBtn.enabled = YES;
        
    }];
    
}
//@"验证码倒计时"
- (void)runVerifyCodeColdDown {
    
    self.verifyCodeColdDownCount--;
    if (self.verifyCodeColdDownCount > 0) {
        
        [self.PhoneView.SendCodeBtn setTitle:[NSString stringWithFormat:@"%@%d%@",GDLocalizedString(@"LoginVC-0013"), self.verifyCodeColdDownCount,GDLocalizedString(@"LoginVC-0014")] forState:UIControlStateNormal];
    } else {
        self.PhoneView.SendCodeBtn.enabled = YES;
        [self.PhoneView.SendCodeBtn setTitle:GDLocalizedString(@"LoginVC-008")   forState:UIControlStateNormal];
        [self.verifyCodeColdDownTimer invalidate];
        _verifyCodeColdDownTimer = nil;
    }
}


//验证手机号码是否合理
-(BOOL)checkPhoneTextField
{
    //"中国";
    if ([self.PhoneView.countryCode.text containsString:@"86"] && self.PhoneView.PhoneTF.text.length != 11) {
        
        AlerMessage(GDLocalizedString(@"LoginVC-PhoneNumberError"));
        
        return NO;
        
    }else if ([self.PhoneView.countryCode.text containsString:@"44"] && self.PhoneView.PhoneTF.text.length != 10) {
        //"英国";
        AlerMessage(GDLocalizedString(@"LoginVC-EnglandNumberError"));
        
        return NO;
        
    }else{
        
        return YES;
    }
}

// 提交验证码
-(void)CommitVerifyCode
{
    
    if (![self checkPhoneTextField]) {
        
        return ;
    }
    
    if (self.PhoneView.VerifyTF.text.length==0) {
        
        AlerMessage(GDLocalizedString(@"LoginVC-007"));
        
        return ;
    }
    
    NSMutableDictionary *infoParameters =[NSMutableDictionary dictionary];
    [infoParameters setValue:self.PhoneView.countryCode.text forKey:@"mobile_code"];
    [infoParameters setValue:self.PhoneView.PhoneTF.text forKey:@"phonenumber"];
    [infoParameters setValue:@{@"code":self.PhoneView.VerifyTF.text} forKey:@"vcode"];
    
    
    [self startAPIRequestWithSelector:@"POST api/account/updatephonenumber"
                           parameters:@{@"accountInfo":infoParameters}
                              success:^(NSInteger statusCode, id response) {
                                  
                                  [self PhoneViewHiden:YES];
                                  
                                   self.phoneNumber = self.PhoneView.PhoneTF.text;
                                  
                              }];
    
}

//补充电话资料
-(void)PhoneViewHiden:(BOOL)hiden
{
    
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        
        CGRect  frame =self.PhoneView.frame;
        
        frame.origin.y = hiden ? XScreenHeight :100;
        
        self.PhoneView.frame = frame;
        
        self.cover.alpha = hiden ? 0 : 0.5;
        
    } completion:^(BOOL finished) {
        
        
    }];
}



-(void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    KDClassLog(@"我要留学  dealloc");
}
@end
