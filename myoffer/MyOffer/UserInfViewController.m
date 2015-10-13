//
//  UserInfViewController.m
//  MyOffer
//
//  Created by xuewuguojie on 15/10/9.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "UserInfViewController.h"

@interface UserInfViewController ()
@property (weak, nonatomic) IBOutlet UITextField *FirstName;
@property (weak, nonatomic) IBOutlet UITextField *LastName;
@property (weak, nonatomic) IBOutlet UITextField *PhoneNumberTextF;
@property (weak, nonatomic) IBOutlet KDEasyTouchButton *commitButtonPress;
@property (weak, nonatomic) IBOutlet UILabel *UserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end
  @implementation UserInfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.PhoneNumberTextF.placeholder = GDLocalizedString(@"Person-003");
    self.FirstName.placeholder = GDLocalizedString(@"UserName-005");
    self.LastName.placeholder = GDLocalizedString(@"UserName-004");
    self.title =  GDLocalizedString(@"UserName-003");  // @"姓名";
    self.phoneLabel.text = GDLocalizedString(@"Person-003" );
    self.UserNameLabel.text =      self.title = GDLocalizedString(@"UserName-003");
    
    
    NSString *lastName = [self.userInfo valueForKey:@"last_name"];
     NSString *FirstName = [self.userInfo valueForKey:@"first_name"];
    self.FirstName.text = FirstName;
    self.LastName.text = lastName;
    self.PhoneNumberTextF.text = [self.userInfo valueForKey:@"phonenumber"];
    self.commitButtonPress.backgroundColor = [UIColor colorWithRed:229.0/255 green:12.0/255 blue:105.0/255 alpha:1];
    [self.commitButtonPress setTitle:GDLocalizedString(@"Evaluate-0017") forState:UIControlStateNormal];

    
 
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.FirstName becomeFirstResponder];

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (IBAction)commitButtonPressed:(KDEasyTouchButton *)sender {
    
    if (self.LastName.text.length == 0) {
        [KDAlertView showMessage: GDLocalizedString(@"UserName-001") cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];//@"好的"];
        return;
    }
    if (self.FirstName.text.length == 0) {
        [KDAlertView showMessage: GDLocalizedString(@"UserName-002") cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];//@"好的"];
        return;
    }
    
    if (self.PhoneNumberTextF.text.length == 0) {
        //
        [KDAlertView showMessage:GDLocalizedString(@"LoginVC-006")  cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];//@"好的"];
        return;
    }
    

    [self startAPIRequestWithSelector: @"POST api/account/applicationdata" parameters:@{@"applicationData":@{@"first_name":self.FirstName.text,@"last_name":self.LastName.text,@"phonenumber":self.PhoneNumberTextF.text}} success:^(NSInteger statusCode, id response) {

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
