//
//  GPAscoreViewController.m
//  MyOffer
//
//  Created by xuewuguojie on 15/10/9.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "GPAscoreViewController.h"

@interface GPAscoreViewController ()
@property (weak, nonatomic) IBOutlet UITextField *GPATextF;
@property (weak, nonatomic) IBOutlet KDEasyTouchButton *commitButton;
@property (weak, nonatomic) IBOutlet UILabel *AVGlabel;

@end

@implementation GPAscoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.AVGlabel.text =  GDLocalizedString(@"AVGscore-002");
    [self.commitButton setTitle:GDLocalizedString(@"Evaluate-0017") forState:UIControlStateNormal];

    self.title = GDLocalizedString(@"ApplicationProfile-008"); 
    
    [self.GPATextF addTarget:self action:@selector(GPATextFChangeValue:) forControlEvents:UIControlEventEditingChanged];
    
    NSString *GPA = [NSString stringWithFormat:@"%@",[self.userInfo valueForKey:@"score"]];
    
    self.GPATextF.text = [NSString stringWithFormat:@"%@",GPA];
    
    self.commitButton.backgroundColor = [UIColor colorWithRed:229.0/255 green:12.0/255 blue:105.0/255 alpha:1];


}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.GPATextF becomeFirstResponder];
    
}

 ;

- (IBAction)commitButtonPressed:(UIButton *)sender {
    
    //@"平均分不能为空"
     if (self.GPATextF.text.length == 0) {
        [KDAlertView showMessage:GDLocalizedString(@"AVGscore-001") cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];//@"好的"];
        return;
    }
    
    [self startAPIRequestWithSelector: @"POST api/account/applicationdata" parameters:@{@"applicationData":@{@"score":self.GPATextF.text}} success:^(NSInteger statusCode, id response) {
        
        KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
        [hud applySuccessStyle];
        [hud hideAnimated:YES afterDelay:1];
        [hud setHiddenBlock:^(KDProgressHUD *hud) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    }];
    
}

-(void)GPATextFChangeValue:(UITextField *)textField
{
    if ([textField.text floatValue] >100) {
        
        textField.text  = [NSString stringWithFormat:@"100"];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
