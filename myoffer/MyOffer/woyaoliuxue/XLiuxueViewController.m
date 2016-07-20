//
//  XLiuxueViewController.m
//  XJHtester
//
//  Created by xuewuguojie on 16/3/29.
//  Copyright © 2016年 小米. All rights reserved.
//

#import "XLiuxueViewController.h"
#import "XliuxueHeaderView.h"
#import "XliuxueTableViewCell.h"
#import "XliuxueFooterView.h"
#import "XliusectionView.h"
#import "InteProfileViewController.h"
#import "YourPhoneView.h"
#import "Xliuxue_ SuccessView.h"

#define Failure @"fail"
typedef enum {
    PickerViewTypeCountry = 110,
    PickerViewTypeSubject = 111,
    PickerViewTypeGrade = 112,
    PickerViewTypeCode = 113
}PickerViewType;//表头按钮选项

@interface XLiuxueViewController ()<UITableViewDataSource,UITableViewDelegate,XliuxueTableViewCellDelegate,UIPickerViewDataSource,UIPickerViewDelegate,XliuxueFooterViewDelegate,YourPhoneViewDelegate>
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
@property(nonatomic,strong)XliuxueTableViewCell *editingCell;
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
@property(nonatomic,strong)Xliuxue__SuccessView *sucessView;
//用于标识提交留学按钮是还被点击
@property(nonatomic,assign)BOOL isClicked;
@end


@implementation XLiuxueViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [MobClick beginLogPageView:@"page我要留学"];
    
    [self presentViewWillAppear];
}

-(void)presentViewWillAppear
{
    
    if (!LOGIN) {
        
        self.phoneNumber = Failure;
        self.isClicked = NO;
        
    }else{
        
        [self getYourPhoneNumber:NO];
        
        if (self.isClicked) {
            
            [self LiuxueButtonClick];
        }
        
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

-(Xliuxue__SuccessView *)sucessView
{
    if (!_sucessView) {
        
        XJHUtilDefineWeakSelfRef
        _sucessView = [[Xliuxue__SuccessView alloc] initWithFrame:CGRectMake(0, XScreenHeight, XScreenWidth, XScreenHeight)];
        _sucessView.actionBlock = ^{
            
              [weakSelf.navigationController popViewControllerAnimated:YES];
            
        };
         [self.view addSubview:_sucessView];
    }
    return _sucessView;
}



- (void)viewDidLoad {
  
    [super viewDidLoad];
    
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
//    [self.cover addTarget:self action:@selector(removeCover) forControlEvents:UIControlEventTouchUpInside];
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
    self.countryArr = [countries valueForKeyPath:@"name"];

    NSString *gradeKey = USER_EN ? @"Grade_EN":@"Grade_CN";
    NSArray *grades = [ud valueForKey:gradeKey];
    self.gradeArr = [grades valueForKeyPath:@"name"];
    
    NSString *subjectKey = USER_EN ? @"Subject_EN":@"Subject_CN";
    NSArray *subjectes = [ud valueForKey:subjectKey];
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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, XScreenWidth, XScreenHeight - 64) style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.sectionFooterHeight = 5 + (XScreenWidth - 320)* 0.1;
    [self.view  addSubview:self.tableView];
    
    [self makeHeaderView];
    
    [self makeFooterView];

}



-(void)makeFooterView
{
    XliuxueFooterView *footerView =[XliuxueFooterView footerView];
    footerView.delegate = self;
    self.tableView.tableFooterView = footerView;

}

-(void)makeHeaderView
{
    XliuxueHeaderView *headerView =[XliuxueHeaderView headView];
    headerView.title = GDLocalizedString(@"WoYaoLiuXue_FillInfor");
    headerView.frame = CGRectMake(0, 0,XScreenWidth,headerView.Height);
    self.tableView.tableHeaderView = headerView;
    
}

#pragma mark —————— UITableViewDataSource,UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 30;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    XliusectionView *sectionView =[XliusectionView sectionView];
   
    sectionView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 0);
 
    sectionView.titleLab.text = self.sectionTitles[section];
    
    return sectionView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    XliuxueTableViewCell *cell =[XliuxueTableViewCell cellWithTableView:tableView];
    cell.indexPath = indexPath;
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
    [UIView animateWithDuration:0.25 animations:^{
        CGRect newRect = self.sucessView.frame;
        newRect.origin.y = 0;
        self.sucessView.frame = newRect;
    }];
    
}


#pragma mark —————————— XliuxueFooterViewDelegate
-(void)liuxueFooterView:(XliuxueFooterView *)footerView didClick:(UIButton *)sender{
 
    
    if ( 1 == sender.tag) {
        
        InteProfileViewController *pipei =[[InteProfileViewController alloc] init];
        pipei.isComeBack = YES;
        [self.navigationController pushViewController:pipei animated:YES];
        
    }else{
        
        [self LiuxueButtonClick];
    }
}
-(void)LiuxueButtonClick
{
    
     if (![self checkFillInformation]) {
        
        return;
    }
    
    self.isClicked = YES;
    
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



#pragma mark —————— 提交我要留学申请
-(void)sendLiuxueRequest
{
 
     NSDictionary *parameters =  @{@"fastPass": @{@"des_country": self.country, @"grade":self.grade, @"subject":self.ApplySubject, @"phonenumber":self.phoneNumber}};
    
    [self
     startAPIRequestWithSelector:kAPISelectorWoYaoLiuXue
     parameters:parameters
     success:^(NSInteger statusCode, id response) {
         
         [self sucessViewUp];
         
         [self.navigationController setNavigationBarHidden:YES animated:YES];

     }];
    
}


#pragma mark —————————— XliuxueTableViewCellDelegate
-(void)XliuxueTableViewCell:(XliuxueTableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath   textFieldDidBeginEditing:(UITextField *)textField{

    self.editingCell = cell;
    
    
    if (cell.titleTF.text.length == 0) {
        
        switch (indexPath.section) {
            case 0:
            {
                cell.titleTF.text = self.countryArr[0];
                self.country = self.countryArr[0];
            }
                break;
            case 1:
            {
                cell.titleTF.text = self.gradeArr[0];
                self.grade = self.gradeArr[0];

            }
                break;
            default:
                cell.titleTF.text = self.subjectArr[0];
                self.ApplySubject = self.subjectArr[0];

                break;
        }

    }
    
}
-(void)XliuxueTableViewCell:(XliuxueTableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath didClick:(UIBarButtonItem *)sender
{
    
    NSInteger newSection = indexPath.section + 1;
    
    if (10  == sender.tag || 3 == newSection) {
        
        [self.view endEditing:YES];
        
        return;
        
    }
    
        NSIndexPath *nextIndex = [NSIndexPath indexPathForRow:indexPath.row inSection:newSection];
        XliuxueTableViewCell *nextCell = [self.tableView cellForRowAtIndexPath:nextIndex];
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
#pragma mark 提交验证码
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


#pragma mark 发送验证码
-(void)sendVerificationCode
{
    
    if (![self checkPhoneTextField]) {
        
        return ;
    }
    
    NSString *AreaNumber =  [self.PhoneView.countryCode.text containsString:@"44"] ? @"44":@"86";
    NSString *phoneNumber = self.PhoneView.PhoneTF.text;
    
    self.PhoneView.SendCodeBtn.enabled = NO;
    
    [self startAPIRequestWithSelector:kAPISelectorSendVerifyCode parameters:@{@"code_type":@"phone", @"phonenumber":  phoneNumber, @"target": phoneNumber, @"mobile_code": AreaNumber} expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        self.verifyCodeColdDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runVerifyCodeColdDown) userInfo:nil repeats:YES];
        self.verifyCodeColdDownCount= 60;
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        self.PhoneView.SendCodeBtn.enabled = YES;

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


//-(void)removeCover{
//
//    [self PhoneViewHiden:YES];
//}


-(void)PhoneViewHiden:(BOOL)hiden
{
    
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        CGRect  frame =self.PhoneView.frame;
        
        frame.origin.y = hiden ? XScreenHeight :100;
        
        self.PhoneView.frame = frame;
        
        self.cover.alpha = hiden ? 0 : 0.5;
        
    } completion:^(BOOL finished) {
        
        
    }];
    
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
    
    XliuxueTableViewCell *Editingcell = ( XliuxueTableViewCell *)self.editingCell;
    
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
            
             self.PhoneView.center = CGPointMake(self.view.frame.size.width / 2.0f, APPSIZE.height*2/3);
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
    

    
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
}


-(void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    KDClassLog(@"XLiuxueViewController  dealloc");
}
@end
