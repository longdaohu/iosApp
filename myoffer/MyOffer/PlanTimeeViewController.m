//
//  PlanTimeeViewController.m
//  MyOffer
//
//  Created by xuewuguojie on 15/10/10.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "PlanTimeeViewController.h"

@interface PlanTimeeViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic,strong)UIPickerView *timePicker;
@property(nonatomic,strong)NSArray *PlanTimes;
@property (weak, nonatomic) IBOutlet UITextField *timeTextF;
@property (weak, nonatomic) IBOutlet KDEasyTouchButton *commitButton;
@property (weak, nonatomic) IBOutlet UILabel *PlanTimeLabel;



@end

@implementation PlanTimeeViewController

-(UIPickerView *)timePicker
{
    if (!_timePicker) {
        _timePicker = [[UIPickerView alloc] init];
        _timePicker.delegate = self;
        _timePicker.dataSource = self;
        //默认显示数组中index = 2的数据
        self.PlanTimes = @[@"2016",@"2017",@"2018"];
        [_timePicker selectRow:1 inComponent:0 animated:YES];
    }
    return _timePicker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.PlanTimeLabel.text = GDLocalizedString(@"ExpectTime-001");
        self.commitButton.backgroundColor = [UIColor colorWithRed:229.0/255 green:12.0/255 blue:105.0/255 alpha:1];
    
    [self.commitButton setTitle:GDLocalizedString(@"Evaluate-0017") forState:UIControlStateNormal];

    self.title = GDLocalizedString(@"ApplicationProfile-004" );//@"计划出国时间";
      NSString *target_date = [NSString stringWithFormat:@"%@",[self.userInfo valueForKey:@"target_date"]];
       self.timeTextF.text =  target_date;
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.timeTextF.inputView = self.timePicker;
    
    [self.timeTextF becomeFirstResponder];
}

#pragma  Mark   UIPickerViewDataSource, UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    
    return  self.PlanTimes.count;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    
    return  self.PlanTimes[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    
    self.timeTextF.text =  self.PlanTimes[row];
    
}



- (IBAction)saveButtonPress:(KDEasyTouchButton *)sender {
    
    if (self.timeTextF.text.length == 0) {
         // GDLocalizedString(@"ExpectedTime-001")  计划时间不能为空
        [KDAlertView showMessage:GDLocalizedString(@"ExpectedTime-001") cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];//@"好的"];
        return;
    }
    
 
    
    
    [self startAPIRequestWithSelector: @"POST api/account/applicationdata" parameters:@{@"applicationData":@{@"target_date":self.timeTextF.text}} success:^(NSInteger statusCode, id response) {
        
        KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
        [hud applySuccessStyle];
        [hud hideAnimated:YES afterDelay:1];
        [hud setHiddenBlock:^(KDProgressHUD *hud) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
     }];

 }


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
