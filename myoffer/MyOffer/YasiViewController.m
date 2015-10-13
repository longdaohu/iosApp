//
//  YasiViewController.m
//  MyOffer
//
//  Created by xuewuguojie on 15/10/9.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "YasiViewController.h"

@interface YasiViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *YasiAverageCore;
@property (weak, nonatomic) IBOutlet UITextField *YasiLowScore;
@property(nonatomic,strong)UIPickerView *AverageScorePicker;
@property(nonatomic,strong)UIPickerView *LowScorePicker;
@property(nonatomic,strong)NSArray *AverageScorelist;
@property (weak, nonatomic) IBOutlet KDEasyTouchButton *commitButton;
@property (weak, nonatomic) IBOutlet UILabel *lowScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *AVGScoreLabel;

@end

@implementation YasiViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.AverageScorePicker = [[UIPickerView alloc] init];
    self.AverageScorePicker.tag =100;
    self.AverageScorePicker.delegate = self;
    self.AverageScorePicker.dataSource = self;
    //默认显示数组中index = 2的数据
    self.AverageScorelist= @[@"9.0",@"8.5",@"8.0",@"7.5",@"7.0",@"6.5",@"6.0",@"5.5",@"5.0",@"4.5",@"4.0",@"3.5",@"3.0",@"2.5",@"2.0",@"1.5",@"1.0",@"0.5",@"0"];
    [self.AverageScorePicker selectRow:1 inComponent:0 animated:YES];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.YasiAverageCore.inputView = self.AverageScorePicker;
    
    [self.YasiAverageCore becomeFirstResponder];
    
    [self.commitButton setTitle:GDLocalizedString(@"Evaluate-0017") forState:UIControlStateNormal];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.commitButton.backgroundColor = [UIColor colorWithRed:229.0/255 green:12.0/255 blue:105.0/255 alpha:1];
    
    self.title = GDLocalizedString(@"ApplicationProfile-009");// @"雅思成绩";
    self.YasiLowScore.placeholder =GDLocalizedString(@"YASI-003");// 请选择雅思最低分
    self.YasiAverageCore.placeholder  =GDLocalizedString(@"YASI-004"); // 请选择雅思平均分
    self.lowScoreLabel.text  = GDLocalizedString(@"YASI-005"); // 雅思最低分
    self.AVGScoreLabel.text  = GDLocalizedString(@"YASI-006");// 雅思平均分
    
 
    
    self.LowScorePicker = [[UIPickerView alloc] init];
    self.LowScorePicker.tag = 110;
    self.LowScorePicker.dataSource = self;
    self.LowScorePicker.delegate = self;
    self.YasiLowScore.inputView =self.LowScorePicker;
    
    
    NSString *LowScore= [NSString stringWithFormat:@"%@",[self.userInfo valueForKey:@"ielts_low"]];
    NSString *AvgageScore= [NSString stringWithFormat:@"%@",[self.userInfo valueForKey:@"ielts_avg"]];
    self.YasiLowScore.text  = LowScore;
    self.YasiAverageCore.text  = AvgageScore;
    

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.AverageScorePicker = nil;
    self.LowScorePicker = nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma  Mark   UIPickerViewDataSource, UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    
    return  self.AverageScorelist.count;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    
    return  self.AverageScorelist[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (pickerView.tag == 110) {
        
        self.YasiLowScore.text = self.AverageScorelist[row];
    }
    else
    {
        self.YasiAverageCore.text =  self.AverageScorelist[row];

    }
    
}

- (IBAction)saveButtonPress:(KDEasyTouchButton *)sender {
    
       //@"雅思最低分不能为空"   @"雅思平均分不能为空"
    if (self.YasiLowScore.text.length == 0) {
        [KDAlertView showMessage:GDLocalizedString(@"YASI-001")  cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];
        return;
    }
    if (self.YasiAverageCore.text.length == 0) {
        [KDAlertView showMessage:GDLocalizedString(@"YASI-002")  cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];//@"好的"];
        return;
    }
    
 
    [self startAPIRequestWithSelector: @"POST api/account/applicationdata" parameters:@{@"applicationData":@{@"ielts_low":self.YasiLowScore.text,@"ielts_avg":self.YasiAverageCore.text}} success:^(NSInteger statusCode, id response) {
        
        KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
        [hud applySuccessStyle];
        [hud hideAnimated:YES afterDelay:1];
        [hud setHiddenBlock:^(KDProgressHUD *hud) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    }];
}


@end
