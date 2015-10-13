//
//  planSubViewController.m
//  MyOffer
//
//  Created by xuewuguojie on 15/10/10.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "planSubViewController.h"

@interface planSubViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic,strong)UIPickerView *subjectPicker;
@property(nonatomic,strong)NSArray *PlanSubjects;
@property (weak, nonatomic) IBOutlet UITextField *subjectTextF;
@property (weak, nonatomic) IBOutlet KDEasyTouchButton *commitButton;
@property (weak, nonatomic) IBOutlet UILabel *expectLabel;



@end

@implementation planSubViewController

-(UIPickerView *)subjectPicker
{
    if (!_subjectPicker) {
        
        _subjectPicker = [[UIPickerView alloc] init];
        _subjectPicker.delegate = self;
        _subjectPicker.dataSource = self;
        //默认显示数组中index = 2的数据
        self.PlanSubjects = @[@"经济与金融",@"农学",@"社会科学",@"工程学",@"艺术与设计",@"理学",@"商科",@"医学",@"人文科学",@"教育学"];
        [_subjectPicker selectRow:1 inComponent:0 animated:YES];
        
    }
    
    return _subjectPicker;
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.subjectTextF.inputView = self.subjectPicker;
    [self.subjectTextF becomeFirstResponder];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.expectLabel.text = GDLocalizedString(@"ExpectStudy-001");
     self.commitButton.backgroundColor = [UIColor colorWithRed:229.0/255 green:12.0/255 blue:105.0/255 alpha:1];
    [self.commitButton setTitle:GDLocalizedString(@"Evaluate-0017") forState:UIControlStateNormal];


    self.title = GDLocalizedString(@"ApplicationProfile-005"); //@"希望就读专业";
     self.subjectTextF.text = [self.userInfo valueForKey:@"apply"];
    
}

#pragma  Mark   UIPickerViewDataSource, UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    
    return  self.PlanSubjects.count;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    
    return  self.PlanSubjects[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    
    self.subjectTextF.text =  self.PlanSubjects[row];
    
}


- (IBAction)saveButtonPressed:(KDEasyTouchButton *)sender {
    
    if (self.subjectTextF.text.length == 0) {
          //@"学科专业不能为空"
         [KDAlertView showMessage:GDLocalizedString(@"ExpectedSubject-001")cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];//@"好的"];
        return;
    }

    [self startAPIRequestWithSelector: @"POST api/account/applicationdata" parameters:@{@"applicationData":@{@"apply":self.subjectTextF.text}} success:^(NSInteger statusCode, id response) {
        
        KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
        [hud applySuccessStyle];
        [hud hideAnimated:YES afterDelay:1];
        [hud setHiddenBlock:^(KDProgressHUD *hud) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    }];
}

@end
