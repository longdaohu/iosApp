//
//  ProfileViewController.m
//  
//
//  Created by Blankwonder on 6/16/15.
//
//

#import "ProfileViewController.h"
#import "TextFieldViewController.h"
#import "ChangePasswordViewController.h"
#import "BindEmailViewController.h"
#import "BindPhoneViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page个人信息"];
    
}


- (void)loadView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.view = self.tableView;
}

- (void)viewDidLoad {
   
    [super viewDidLoad];
    
    self.title = GDLocalizedString(@"Setting-001");
}

- (void)viewWillAppear:(BOOL)animated {
   
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [MobClick beginLogPageView:@"page个人信息"];
    
    
    [self startAPIRequestWithSelector:kAPISelectorAccountInfo parameters:nil success:^(NSInteger statusCode, id response) {
        
        ActionTableViewCell *usernameCell = [[ActionTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
       
        //我的设置 - 个人信息页面
        usernameCell.textLabel.text = GDLocalizedString(@"Person-001"); //@"用户名";
        usernameCell.detailTextLabel.text = response[@"accountInfo"][@"displayname"];
        usernameCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
         [usernameCell setAction:^{
             
             [MobClick event:@"userNameItemClick"];
            TextFieldViewController *vc = [[TextFieldViewController alloc] init];
            vc.title = GDLocalizedString(@"Person-005"); //@"修改用户名";
             [vc setViewDidLoadAction:^(TextFieldViewController *vc) {
                vc.textField.text = response[@"accountInfo"][@"displayname"];
            }];
             
             [vc setDoneAction:^(TextFieldViewController *vc) {
                if (vc.textField.text.length == 0) {
                    [vc.navigationController popViewControllerAnimated:YES];
                    return;
                }
 
            }];
             [self.navigationController pushViewController:vc animated:YES];
        }];
        
        ActionTableViewCell *passwordCell = [[ActionTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        passwordCell.textLabel.text =GDLocalizedString(@"Person-002"); // @"密码";
        passwordCell.detailTextLabel.text = GDLocalizedString(@"Person-006");// @"修改密码";
        passwordCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [passwordCell setAction:^{
            
            [MobClick event:@"changePasswdItemClick"];
            
            if (response[@"accountInfo"][@"phonenumber"] || response[@"accountInfo"][@"email"]) {
                ChangePasswordViewController *vc = [[ChangePasswordViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
              }
            else{
                UIAlertView  *aler  = [[UIAlertView alloc] initWithTitle:@"请先绑定手机号或Email" message:nil delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
                [aler show];
                
            }
        }];
         
        ActionTableViewCell *phonenumberCell = [[ActionTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        phonenumberCell.textLabel.text =  GDLocalizedString(@"Person-003"); //@"手机号";
        phonenumberCell.detailTextLabel.text = response[@"accountInfo"][@"phonenumber"] ?: GDLocalizedString(@"Person-007");//@"未绑定手机号";
        phonenumberCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [phonenumberCell setAction:^{
              
                [MobClick event:@"changePhoneItemClick"];

                BindPhoneViewController *vc = [[BindPhoneViewController alloc] init];
                 vc.title = response[@"accountInfo"][@"phonenumber"]?GDLocalizedString(@"Bind-changePhoneTitle"): GDLocalizedString(@"Bind-phoneTitle");

                if (response[@"accountInfo"][@"phonenumber"] || response[@"accountInfo"][@"email"]) {
                    vc.phoneNumber = @"phoneNumber";
                }
                [self.navigationController pushViewController:vc animated:YES];
            }];
        
        ActionTableViewCell *emailCell = [[ActionTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        emailCell.textLabel.text =GDLocalizedString(@"Person-004");//  @"邮箱";
        emailCell.detailTextLabel.text = response[@"accountInfo"][@"email"] ?: GDLocalizedString(@"Person-008"); //@"未绑定邮箱";
        emailCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [emailCell setAction:^{
          
            [MobClick event:@"changeEmailItemClick"];

            BindEmailViewController *vc = [[BindEmailViewController alloc] init];
            
            vc.title = response[@"accountInfo"][@"email"]?GDLocalizedString(@"Bind-changeEmailTitle"):GDLocalizedString(@"Bind-EmailTitle");
           
            if (response[@"accountInfo"][@"phonenumber"] || response[@"accountInfo"][@"email"]) {
                vc.Email = @"Email";
            }
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
    
        
         self.cells = @[@[usernameCell], @[passwordCell], @[phonenumberCell], @[emailCell]];
        
         [self.tableView reloadData];
    }];
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return  Section_header_Height_min;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return  HEIGHT_ZERO;
}



@end
