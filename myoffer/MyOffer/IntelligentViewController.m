//
//  TWOViewController.m
//  TESTER
//
//  Created by xuewuguojie on 15/11/4.
//  Copyright © 2015年 xuewuguojie. All rights reserved.
//
#import "CountryItem.h"
#import "GradeItem.h"
#import "SubjectItem.h"
#import "IntelligentViewController.h"
#import "IntelligentResultViewController.h"
#import <QuartzCore/QuartzCore.h>

typedef enum {
    countryPikerType = 109,
    timePikerType,
    applySubjectPikerType,
    inSubjectPikerType,
    IELSTminiPickerType,
    IELSTaveragePikerType,
    gradePickerType
} pikerType;

@interface IntelligentViewController ()<UITextFieldDelegate,UIScrollViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *myscroll;
@property (weak, nonatomic) IBOutlet UITextField *countryTF;
@property (weak, nonatomic) IBOutlet UITextField *timeTF;
@property (weak, nonatomic) IBOutlet UITextField *applySubjectTF;
@property (weak, nonatomic) IBOutlet UITextField *shoolTF;
@property (weak, nonatomic) IBOutlet UITextField *inSubjectTF;
@property (weak, nonatomic) IBOutlet UITextField *scoreTF;
@property (weak, nonatomic) IBOutlet UITextField *gradeTF;
@property (weak, nonatomic) IBOutlet UITextField *averageTF;
@property (weak, nonatomic) IBOutlet UITextField *lowTF;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (weak, nonatomic) IBOutlet UILabel *yixiangLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectExpectLabel;
@property (weak, nonatomic) IBOutlet UILabel *beijingLabel;
@property (weak, nonatomic) IBOutlet UILabel *universityLabel;
@property (weak, nonatomic) IBOutlet UILabel *AGPLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectCurrentLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeNotiLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowLabel;
@property (weak, nonatomic) IBOutlet UILabel *averageLabel;
@property(nonatomic,strong)UIPickerView *timePiker;
@property(nonatomic,strong)UIPickerView *countryPiker;
@property(nonatomic,strong)UIPickerView *applySubjectPiker;
@property(nonatomic,strong)UIPickerView *inSubjectPiker;
@property(nonatomic,strong)UIPickerView *IELSTminiPicker;
@property(nonatomic,strong)UIPickerView *IELSTaveragePicker;
@property(nonatomic,strong)UIPickerView *gradePicker;
@property(nonatomic,strong)NSArray *countryItems_EN;
@property(nonatomic,strong)NSArray *countryItems_CN;
@property(nonatomic,strong)NSArray *countryItems;
@property(nonatomic,strong)NSArray *timeItems;
@property(nonatomic,strong)NSArray *subjectItems;
@property(nonatomic,strong)NSArray *subjectItems_CN;
@property(nonatomic,strong)NSArray *subjectItems_EN;
@property(nonatomic,strong)NSArray *miniItems;
@property(nonatomic,strong)NSArray *gradeItems;
@property(nonatomic,strong)NSArray *gradeItems_EN;
@property(nonatomic,strong)NSArray *gradeItems_CN;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewConstraint;
@property(nonatomic,strong)UIImageView *adImageView;


@end

@implementation IntelligentViewController
-(UIPickerView *)countryPiker
{
    if(!_countryPiker)
    {
        _countryPiker = [[UIPickerView alloc] init];
        _countryPiker.tag = countryPikerType;
        _countryPiker.delegate = self;
        _countryPiker.dataSource = self;
        
        [_countryPiker selectRow:1 inComponent:0 animated:YES];
    }
    return _countryPiker;
}


-(UIPickerView *)timePiker
{
    if(!_timePiker)
    {
        _timePiker = [[UIPickerView alloc] init];
        _timePiker.tag = timePikerType;
        _timePiker.delegate = self;
        _timePiker.dataSource = self;
        //默认显示数组中index = 2的数据
        self.timeItems = @[@"2016",@"2017",@"2018",@"2019"];
        [_timePiker selectRow:1 inComponent:0 animated:YES];
    }
    return _timePiker;
}

-(UIPickerView *)applySubjectPiker
{
    if (!_applySubjectPiker) {
        _applySubjectPiker = [[UIPickerView alloc] init];
        _applySubjectPiker.dataSource = self;
        _applySubjectPiker.delegate = self;
        _applySubjectPiker.tag = applySubjectPikerType;
        [_applySubjectPiker selectRow:1 inComponent:0 animated:YES];

    }
    return _applySubjectPiker;
}



-(UIPickerView *)inSubjectPiker
{
    if (!_inSubjectPiker) {
        _inSubjectPiker = [[UIPickerView alloc] init];
        _inSubjectPiker.dataSource = self;
        _inSubjectPiker.delegate = self;
        _inSubjectPiker.tag = inSubjectPikerType;
        [_inSubjectPiker selectRow:1 inComponent:0 animated:YES];
        
    }
    return _inSubjectPiker;
}
-(NSArray *)miniItems
{
    if (!_miniItems) {
        
        _miniItems = @[@"9.0",@"8.5",@"8.0",@"7.5",@"7.0",@"6.5",@"6.0",@"5.5",@"5.0",@"4.5",@"4.0",@"3.5",@"3.0",@"2.5",@"2.0",@"1.5",@"1.0",@"0.5",@"0"];
    }
    return _miniItems;
}

-(UIPickerView *)IELSTminiPicker
{
    if (!_IELSTminiPicker) {
        _IELSTminiPicker = [[UIPickerView alloc] init];
        _IELSTminiPicker.dataSource = self;
        _IELSTminiPicker.delegate = self;
        _IELSTminiPicker.tag = IELSTminiPickerType;
        
        //默认显示数组中index = 2的数据
        [_IELSTminiPicker selectRow:1 inComponent:0 animated:YES];
    }
    return _IELSTminiPicker;
}

-(UIPickerView *)IELSTaveragePicker
{
    if (!_IELSTaveragePicker) {
        _IELSTaveragePicker = [[UIPickerView alloc] init];
        _IELSTaveragePicker.dataSource = self;
        _IELSTaveragePicker.delegate = self;
        _IELSTaveragePicker.tag = IELSTaveragePikerType;
        //默认显示数组中index = 2的数据
        [_IELSTaveragePicker selectRow:1 inComponent:0 animated:YES];
    }
    return _IELSTaveragePicker;
}


-(UIPickerView *)gradePicker
{
    if (!_gradePicker) {
        _gradePicker = [[UIPickerView alloc] init];
        _gradePicker.tag = gradePickerType;
        _gradePicker.delegate = self;
        _gradePicker.dataSource = self;
        //默认显示数组中index = 2的数据
  
         [_gradePicker selectRow:1 inComponent:0 animated:YES];
    }
    return _gradePicker;
}

-(void)makeUI
{
    [self maketextFieldStasus:self.countryTF placeholder:GDLocalizedString(@"ApplicationProfile-003")];
    
    [self maketextFieldStasus:self.timeTF placeholder:GDLocalizedString(@"ApplicationProfile-004")];
    
    [self maketextFieldStasus:self.gradeTF  placeholder: GDLocalizedString(@"ApplicationProfile-grade")];
    
    [self maketextFieldStasus:self.shoolTF placeholder:GDLocalizedString(@"Evaluate-009")];
    
    
    [self maketextFieldStasus:self.scoreTF  placeholder:GDLocalizedString(@"Evaluate-0011")];
    
    [self maketextFieldStasus:self.averageTF placeholder:GDLocalizedString(@"Evaluate-0012")];
     [self maketextFieldStasus:self.lowTF  placeholder:GDLocalizedString(@"Evaluate-0013")];
    
    [self maketextFieldStasus:self.inSubjectTF placeholder:GDLocalizedString(@"Evaluate-0010")];
    [self maketextFieldStasus:self.applySubjectTF placeholder:GDLocalizedString(@"Evaluate-0014")];

    
    self.countryTF.inputView = self.countryPiker;
    self.timeTF.inputView = self.timePiker;
    self.applySubjectTF.inputView = self.applySubjectPiker;
    self.inSubjectTF.inputView = self.inSubjectPiker;
    
    self.gradeTF.inputView = self.gradePicker;
    self.averageTF.inputView = self.IELSTaveragePicker;
    self.lowTF.inputView =self.IELSTminiPicker;
    
    self.countryTF.inputAccessoryView = self.toolBar;
    self.timeTF.inputAccessoryView = self.toolBar;
    self.inSubjectTF.inputAccessoryView = self.toolBar;
    self.shoolTF.inputAccessoryView = self.toolBar;
    self.applySubjectTF.inputAccessoryView = self.toolBar;
    self.averageTF.inputAccessoryView = self.toolBar;
    self.gradeTF.inputAccessoryView = self.toolBar;
    self.lowTF.inputAccessoryView = self.toolBar;
    self.averageTF.inputAccessoryView = self.toolBar;
    self.scoreTF.inputAccessoryView = self.toolBar;
    
    self.commitButton.backgroundColor = MAINCOLOR;
    self.commitButton.layer.cornerRadius = 2;
    self.commitButton.layer.masksToBounds = YES;
    self.gradeNotiLabel.adjustsFontSizeToFitWidth = YES;
    NSString *headTitle = GDLocalizedString(@"Evaluate-AD");
    CGSize headTitleSize =[headTitle boundingRectWithSize:CGSizeMake(APPSIZE.width - 20, 999) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size;
    self.titleLabel.frame =CGRectMake(10, 0, headTitleSize.width, headTitleSize.height);
//    self.myscroll.contentSize = CGSizeMake(APPSIZE.width, headTitleSize.height + 330+163);
    self.contentViewConstraint.constant = headTitleSize.height + 590;
    
}

-(UIImageView *)adImageView
{
    if (!_adImageView) {
        _adImageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, APPSIZE.height, APPSIZE.width, APPSIZE.height)];
        _adImageView.image = [UIImage imageNamed:@"center_AD"];
       [[UIApplication sharedApplication].windows.lastObject addSubview:_adImageView];
    }
    return _adImageView;
}

-(void)whenNoUserInformation
{

    [UIView animateWithDuration:1 animations:^{
         self.adImageView.center = CGPointMake(APPSIZE.width*0.5, APPSIZE.height*0.5);
    }];
    self.adImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(advertisementDisappear)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.adImageView addGestureRecognizer:tap];
}

-(void)advertisementDisappear
{
    
    [UIView animateWithDuration:1 animations:^{
        self.adImageView.frame = CGRectMake(0, APPSIZE.height, APPSIZE.width, APPSIZE.height);
        self.adImageView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.adImageView removeFromSuperview];
    }];
    
}


-(void)currentLanguageEnvironment{
    
    self.title = GDLocalizedString(@"Evaluate-inteligent");//@"智能匹配";
    self.titleLabel.text = GDLocalizedString(@"Evaluate-AD");
    self.yixiangLabel.text = GDLocalizedString(@"Evaluate-Yixiang");
    self.countryLabel.text = GDLocalizedString(@"ExpectedCountry-002");
    self.timeLabel.text = GDLocalizedString(@"ExpectedTime-002");
    self.subjectExpectLabel.text = GDLocalizedString(@"ExpectedSubject-002");
    self.beijingLabel.text = GDLocalizedString(@"Evaluate-Beijin");
    self.AGPLabel.text = GDLocalizedString(@"Evaluate-004" );
    self.subjectCurrentLabel.text = GDLocalizedString(@"Evaluate-003");
    self.gradeLabel.text = GDLocalizedString(@"UniversityBG-002");
    self.gradeNotiLabel.text = GDLocalizedString(@"Evaluate-gradeNoti");
    self.lowLabel.text = GDLocalizedString(@"Evaluate-006");
    self.averageLabel.text =  GDLocalizedString(@"Evaluate-005");
    self.universityLabel.text = GDLocalizedString(@"Evaluate-002");
    [self.commitButton setTitle:GDLocalizedString(@"Evaluate-commitButton") forState:UIControlStateNormal];
}



-(void)maketextFieldStasus:(UITextField *)textfield placeholder:(NSString *)placeholder
{
    UIView *leftView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
    textfield.leftView = leftView;
    textfield.placeholder = placeholder;
    [textfield setValue:[UIColor clearColor] forKeyPath:@"_placeholderLabel.textColor"];
    textfield.leftViewMode = UITextFieldViewModeAlways;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self getSelectionResourse];
    [self makeUI];
    [self requestDataSource];
    [self currentLanguageEnvironment];
    self.myscroll.delegate =self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(NSInteger)getArrayIndex:(NSArray *)dataArray withdataIDString:(NSString *)dataID
{
    
     NSArray *DataIDs = [dataArray valueForKeyPath:@"NOid"];
    
     NSInteger index  =  [DataIDs indexOfObject: [NSNumber numberWithInt:dataID.intValue]];
    
    return index;

}

-(BOOL)userInfoWasChange
{
    //用于判断用户是否改变
    NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
    
    BOOL isChange = [[ud valueForKey:@"userChange"] isEqualToString: @"changeYES"];
    
    [ud setValue:@"changeNO" forKey:@"userChange"];
    
    [ud synchronize];
    
    return  isChange;
}


-(void)getSelectionResourse
{

    NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
    
    
    NSArray *countryResponse_CN  = [ud valueForKey:@"Country_CN"];
    NSArray *countryResponse_EN  = [ud valueForKey:@"Country_EN"];
 
    self.countryItems_CN = [countryResponse_CN KD_arrayUsingMapEnumerateBlock:^id(NSDictionary *obj, NSUInteger idx)
                            {
                                CountryItem *item = [CountryItem CountryWithDictionary:obj];
                                return item;
                            }];
    
    
    self.countryItems_EN = [countryResponse_EN KD_arrayUsingMapEnumerateBlock:^id(NSDictionary *obj, NSUInteger idx)
                            {
                                CountryItem *item = [CountryItem CountryWithDictionary:obj];
                                return item;
                            }];
    
     NSArray *response_CN  = [ud valueForKey:@"Grade_CN"];
     NSArray *response_EN  = [ud valueForKey:@"Grade_EN"];
     self.gradeItems_CN = [response_CN KD_arrayUsingMapEnumerateBlock:^id(NSDictionary *obj, NSUInteger idx)
                   {
                        GradeItem *item = [GradeItem gradeWithDictionary:obj];
                        return item;
                   }];
    
    self.gradeItems_EN = [response_EN KD_arrayUsingMapEnumerateBlock:^id(NSDictionary *obj, NSUInteger idx)
                          {
                               GradeItem *item = [GradeItem gradeWithDictionary:obj];
                               return item;
                          }];
    
    NSArray *SubjectResponse_CN  = [ud valueForKey:@"Subject_CN"];
    NSArray *SubjectResponse_EN  = [ud valueForKey:@"Subject_EN"];

    self.subjectItems_CN = [SubjectResponse_CN KD_arrayUsingMapEnumerateBlock:^id(NSDictionary *obj, NSUInteger idx)
                     {
                          SubjectItem *item = [SubjectItem subjectWithDictionary:obj];
                          return item;
                     }];
    self.subjectItems_EN = [SubjectResponse_EN KD_arrayUsingMapEnumerateBlock:^id(NSDictionary *obj, NSUInteger idx)
                            {
                                 SubjectItem *item = [SubjectItem subjectWithDictionary:obj];
                                 return item;
                            }];
    if ([[InternationalControl userLanguage] containsString:@"en"]) {
        
         self.countryItems = [self.countryItems_EN copy];
         self.gradeItems = [self.gradeItems_EN copy];
         self.subjectItems = [self.subjectItems_EN copy];
        
    }else{
        
        self.countryItems = [self.countryItems_CN copy];
        self.gradeItems = [self.gradeItems_CN copy];
        self.subjectItems = [self.subjectItems_CN copy];
    }
}




//用于判断提交过来的字符串是否是数字
-(BOOL)validateNumberString:(NSString *)preString
{
    NSString *Regex = @"[0-9]+";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [predicate evaluateWithObject:preString];
}

//用于网络数据请求
-(void)requestDataSource
{
    
    
       if ([AppDelegate sharedDelegate].isLogin) {
           
        [self startAPIRequestWithSelector:@"GET api/account/evaluate"  parameters:nil success:^(NSInteger statusCode, id response) {
            
            NSArray *countryIDs_CN = [self.countryItems_CN valueForKeyPath:@"CountryName"];
            NSArray *countryIDs_EN = [self.countryItems_EN valueForKeyPath:@"CountryName"];
            NSInteger cindex = 0;
                        if ([self validateNumberString:response[@"des_country"]]) {
                           
                            NSArray *countryIDs = [self.countryItems_CN valueForKeyPath:@"NOid"];
                            NSString *des_countryStr = response[@"des_country"];
                            NSNumber *des_country =  [NSNumber numberWithInt:des_countryStr.intValue];
                            cindex = [countryIDs indexOfObject: des_country];
                            CountryItem *cItem = [self.countryItems objectAtIndex:cindex];
                            
                            self.countryTF.text = cItem.CountryName;

             
                        }else if( [response[@"des_country"] length] > 1 )
                        {
             
                            if ([countryIDs_CN containsObject:response[@"des_country"]]) {
                                
                                cindex = [countryIDs_CN indexOfObject:KDUtilStringGuard(response[@"des_country"])];
                                
                            }else if([countryIDs_EN containsObject:response[@"des_country"]])
                            {
                                cindex = [countryIDs_EN indexOfObject:KDUtilStringGuard(response[@"des_country"])];
                                
                            }else
                            {
                                cindex = 0;
                            }
                            
                            CountryItem *cItem = [self.countryItems objectAtIndex:cindex];
                            self.countryTF.text = cItem.CountryName;
            
                        }else{
            
                            self.countryTF.text = @"";
                            
                            if ([self userInfoWasChange]) {
                                
                                [self whenNoUserInformation];
                                
                            }
             
                        }
            
 
 
 
            NSArray *gradeIDs_CN = [self.gradeItems_CN valueForKeyPath:@"gradeName"];
            NSArray *gradeIDs_EN = [self.gradeItems_EN valueForKeyPath:@"gradeName"];
            NSInteger gindex = 0;
            if ([response[@"grade"] length] == 0) {
                
                self.gradeTF.text = @"";
                
                
            }else if ([self validateNumberString:response[@"grade"]]) {
                
                gindex = [self getArrayIndex:self.gradeItems_CN withdataIDString:response[@"grade"]];
                
                GradeItem *gItem = [self.gradeItems objectAtIndex:gindex];
                
                self.gradeTF.text = gItem.gradeName;
                
            }else
            {
                
                if ([self.gradeItems_CN  containsObject:response[@"grade"]]) {
                    
                    gindex = [gradeIDs_CN indexOfObject:KDUtilStringGuard(response[@"grade"])];
                    
                }else if([gradeIDs_EN containsObject:response[@"grade"]])
                {
                    gindex = [gradeIDs_EN indexOfObject:KDUtilStringGuard(response[@"grade"])];
                    
                }else
                {
                    gindex = 0;
                }
                
                GradeItem *gItem = [self.gradeItems objectAtIndex:gindex];
                self.gradeTF.text = gItem.gradeName;
            }
            
            NSArray *subjectIDs_CN = [self.subjectItems_CN valueForKeyPath:@"subjectName"];
            NSArray *subjectIDs_EN = [self.subjectItems_EN valueForKeyPath:@"subjectName"];
            NSInteger insindex = 0;
            if ([response[@"subject"] length] == 0) {
                
                self.inSubjectTF.text = @"";
                
                
            }else if ([self validateNumberString:response[@"subject"]]) {
                
                insindex = [self getArrayIndex:self.subjectItems_CN withdataIDString:response[@"subject"]];
                SubjectItem *insItem = [self.subjectItems objectAtIndex:insindex];
                self.inSubjectTF.text = insItem.subjectName;
                
            }else
            {
                
                if ([subjectIDs_CN  containsObject:response[@"subject"]]) {
                    
                    insindex = [subjectIDs_CN indexOfObject:KDUtilStringGuard(response[@"subject"])];
                    
                }else if([subjectIDs_EN containsObject:response[@"subject"]])
                {
                    insindex = [subjectIDs_EN indexOfObject:KDUtilStringGuard(response[@"subject"])];
                    
                }else
                {
                    insindex = 0;
                }
                
                SubjectItem *insItem = [self.subjectItems objectAtIndex:insindex];
                self.inSubjectTF.text = insItem.subjectName;
            }

            
            NSInteger applyindex = 0;
            if ([response[@"apply"] length] == 0) {
                
                self.applySubjectTF.text = @"";
                
            }else if ([self validateNumberString:response[@"apply"]]) {
                
                insindex = [self getArrayIndex:self.subjectItems_CN withdataIDString:response[@"apply"]];
                SubjectItem *applyItem = [self.subjectItems objectAtIndex:insindex];
                self.applySubjectTF.text = applyItem.subjectName;
                
            }else
            {
                if ([subjectIDs_CN  containsObject:response[@"apply"]]) {
                    
                    applyindex = [subjectIDs_CN indexOfObject:KDUtilStringGuard(response[@"apply"])];
                    
                }else if([subjectIDs_EN containsObject:response[@"apply"]])
                {
                    applyindex = [subjectIDs_EN indexOfObject:KDUtilStringGuard(response[@"apply"])];
                    
                }else
                {
                    applyindex = 0;
                }
                
                SubjectItem *applyItem = [self.subjectItems objectAtIndex:applyindex];
                self.applySubjectTF.text = applyItem.subjectName;
            }

            
            
            self.timeTF.text =  KDUtilStringGuard(response[@"target_date"]);
            
            
            self.shoolTF.text =  KDUtilStringGuard(response[@"university"]);
            
            
            self.scoreTF.text =  KDUtilStringGuard(response[@"score"]);
            
            
            self.lowTF.text =  KDUtilStringGuard(response[@"ielts_low"]);
            
            self.averageTF.text =  KDUtilStringGuard(response[@"ielts_avg"]);
            
            
         }];
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

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
    
    UIEdgeInsets insets = self.myscroll.contentInset;
    if (up) {
        insets.bottom = keyboardEndFrame.size.height;
    } else {
        insets.bottom = 50;
    }
    
    self.myscroll.contentInset = insets;
    
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
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
        case applySubjectPikerType: case inSubjectPikerType:
            
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
        case countryPikerType:
            return [self getCountryName:row];
            break;
        case timePikerType:
            return self.timeItems[row];
            break;
        case applySubjectPikerType: case inSubjectPikerType:
            
            return  [self getSubjectName:row];
            break;
        case IELSTminiPickerType:  case IELSTaveragePikerType:
            return self.miniItems[row];
        default:
            return [self getGradeName:row];
            break;
    }

}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    switch (pickerView.tag) {
        case countryPikerType:
            self.countryTF.text =[self getCountryName:row];
            break;
        case timePikerType:
            self.timeTF.text = self.timeItems[row];
            break;
        case applySubjectPikerType:
            self.applySubjectTF.text =  [self getSubjectName:row];
            break;
        case inSubjectPikerType:
            self.inSubjectTF.text =  [self getSubjectName:row];
            break;
        case IELSTminiPickerType:
            self.lowTF.text =self.miniItems[row];
            break;
        case IELSTaveragePikerType:
            self.averageTF.text =self.miniItems[row];
            break;
          default:
            self.gradeTF.text = [self getGradeName:row];
            break;
    }

}

-(NSString *)getSubjectName:(NSInteger)row
{
    SubjectItem *item = self.subjectItems[row];
    return item.subjectName;
}

-(NSString *)getGradeName:(NSInteger)row
{
    GradeItem *item = self.gradeItems[row];
    
    return item.gradeName;
}

-(NSString *)getCountryName:(NSInteger)row
{
    CountryItem *item = self.countryItems[row];
    
    return item.CountryName;
}

- (IBAction)endEditing:(UIBarButtonItem *)sender {
    
    [self.view endEditing:YES];
    
}


-(NSInteger)getCommitArrayIndex:(NSArray *)dataArray withDataKey:(NSString *)key andPredicateString:(NSString *)PreKey
{
    NSArray *DataIDs = [dataArray valueForKeyPath:key];
    
    NSInteger index  = [DataIDs indexOfObject:PreKey];
    
    return index;
}

- (IBAction)commitButtonPressed:(UIButton *)sender {
    
    RequireLogin
    
    NSArray *textFields = @[self.countryTF, self.timeTF,self.applySubjectTF,self.shoolTF,self.inSubjectTF,self.scoreTF,self.gradeTF,self.averageTF,self.lowTF];
    
    for (UITextField *textField in textFields) {
        if (textField.text.length == 0) {
            [KDAlertView showMessage:textField.placeholder cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];
            return;
        }
    }
    
    NSInteger cindex = [self getCommitArrayIndex:self.countryItems withDataKey:@"CountryName"  andPredicateString:self.countryTF.text];
    CountryItem *cItem = [self.countryItems objectAtIndex:cindex];
    
    
    NSInteger gindex =[self getCommitArrayIndex:self.gradeItems withDataKey:@"gradeName" andPredicateString:self.gradeTF.text];
    GradeItem *gItem = [self.gradeItems objectAtIndex:gindex];
    
    
    
    NSInteger insindex = [self getCommitArrayIndex:self.subjectItems withDataKey:@"subjectName" andPredicateString:self.inSubjectTF.text];
    
    SubjectItem *insItem = [self.subjectItems objectAtIndex:insindex];
    
    NSInteger apindex = [self getCommitArrayIndex:self.subjectItems withDataKey:@"subjectName" andPredicateString:self.applySubjectTF.text];//[subjects
    SubjectItem *apItem = [self.subjectItems objectAtIndex:apindex];
    
    
    NSDictionary *parameters =  @{@"des_country":cItem.NOid,@"target_date":self.timeTF.text,@"grade":gItem.NOid,@"university":self.shoolTF.text,@"subject":insItem.NOid,@"apply":apItem.NOid,@"score":self.scoreTF.text,@"ielts_low":self.lowTF.text,@"ielts_avg":self.averageTF.text};
    
  
    [self
     startAPIRequestWithSelector:@"POST api/account/evaluate"
     parameters:parameters
     success:^(NSInteger statusCode, id response) {
         
              IntelligentResultViewController *resultVC =[[IntelligentResultViewController alloc] initWithNibName:@"IntelligentResultViewController" bundle:nil];
             [self.navigationController pushViewController:resultVC animated:YES];
         
      }];
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _scoreTF) {
        
        textField.text  = [textField.text intValue] <= 100 ? textField.text :@"100" ;
    }
}

KDUtilRemoveNotificationCenterObserverDealloc

@end
