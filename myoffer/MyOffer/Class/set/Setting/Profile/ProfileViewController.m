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
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }

}

- (void)viewDidLoad {
   
    [super viewDidLoad];
    
    self.title = @"个人信息";
}

- (void)viewWillAppear:(BOOL)animated {
   
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [MobClick beginLogPageView:@"page个人信息"];
 
    WeakSelf
    [self startAPIRequestWithSelector:kAPISelectorAccountInfo parameters:nil success:^(NSInteger statusCode, id response) {
       
        NSDictionary *accountInfo = response[@"accountInfo"];
        NSString *displayname_str = accountInfo[@"displayname"];
        NSString *phonenumber_str = accountInfo[@"phonenumber"];
        NSString *email_str = accountInfo[@"email"];
        NSString *hasPassword = accountInfo[@"hasPassword"];

        ActionTableViewCell *usernameCell = [[ActionTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
       
        //我的设置 - 个人信息页面
        usernameCell.textLabel.text = @"用户名";
        usernameCell.detailTextLabel.text =  displayname_str;
        usernameCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
         [usernameCell setAction:^{
             
             [MobClick event:@"userNameItemClick"];
            TextFieldViewController *vc = [[TextFieldViewController alloc] init];
            vc.title = @"修改用户名";
             [vc setViewDidLoadAction:^(TextFieldViewController *vc) {
                vc.textField.text =  displayname_str;
            }];
             
             [vc setDoneAction:^(TextFieldViewController *vc) {
                if (vc.textField.text.length == 0) {
                    [vc.navigationController popViewControllerAnimated:YES];
                    return;
                }
 
            }];
             [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        
        ActionTableViewCell *passwordCell = [[ActionTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        passwordCell.textLabel.text = @"密码";
        passwordCell.detailTextLabel.text =  hasPassword.boolValue ? @"修改密码" : @"新增密码" ;
        passwordCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [passwordCell setAction:^{
            
            [MobClick event:@"changePasswdItemClick"];
          
            if (phonenumber_str || email_str) {
                ChangePasswordViewController *vc = [[ChangePasswordViewController alloc] init];
                if(!hasPassword.boolValue)vc.newpasswd = @"true";
                [weakSelf.navigationController pushViewController:vc animated:YES];
              }
            else{
                UIAlertView  *aler  = [[UIAlertView alloc] initWithTitle:@"请先绑定手机号或Email" message:nil delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
                [aler show];
                
            }
        }];
         
        ActionTableViewCell *phonenumberCell = [[ActionTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        phonenumberCell.textLabel.text =  @"手机号";
        phonenumberCell.detailTextLabel.text = phonenumber_str? : GDLocalizedString(@"Person-007");//@"未绑定手机号";
        phonenumberCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [phonenumberCell setAction:^{
              
                [MobClick event:@"changePhoneItemClick"];

                BindPhoneViewController *vc = [[BindPhoneViewController alloc] init];
                 vc.title = phonenumber_str ? GDLocalizedString(@"Bind-changePhoneTitle") : GDLocalizedString(@"Bind-phoneTitle");

                if (phonenumber_str ||  email_str) {
                    vc.phoneNumber = @"phoneNumber";
                }
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }];
        
        ActionTableViewCell *emailCell = [[ActionTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        emailCell.textLabel.text = @"邮箱";
        emailCell.detailTextLabel.text = email_str ?: @"未绑定邮箱";
        emailCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [emailCell setAction:^{
          
            [MobClick event:@"changeEmailItemClick"];

            BindEmailViewController *vc = [[BindEmailViewController alloc] init];
            
            vc.title = email_str ? GDLocalizedString(@"Bind-changeEmailTitle"):GDLocalizedString(@"Bind-EmailTitle");
           
            if (phonenumber_str || email_str ) {
                vc.Email = @"Email";
            }
            [weakSelf.navigationController pushViewController:vc animated:YES];
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
