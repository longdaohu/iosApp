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

- (void)loadView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.view = self.tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"个人信息";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [self startAPIRequestWithSelector:kAPISelectorAccountInfo parameters:nil success:^(NSInteger statusCode, id response) {
        ActionTableViewCell *usernameCell = [[ActionTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        usernameCell.textLabel.text = @"用户名";
        usernameCell.detailTextLabel.text = response[@"accountInfo"][@"displayname"];
        usernameCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        [usernameCell setAction:^{
            TextFieldViewController *vc = [[TextFieldViewController alloc] init];
            vc.title = @"修改用户名";
            
            [vc setViewDidLoadAction:^(TextFieldViewController *vc) {
                vc.textField.text = response[@"accountInfo"][@"displayname"];
            }];
            
            [vc setDoneAction:^(TextFieldViewController *vc) {
                if (vc.textField.text.length == 0) {
                    [vc.navigationController popViewControllerAnimated:YES];
                    return;
                }
                
                [vc
                 startAPIRequestWithSelector:kAPISelectorUpdateAccountInfo
                 parameters:@{@"accountInfo":@{@"displayname": vc.textField.text}}
                 success:^(NSInteger statusCode, id response) {
                     KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
                     
                     [hud applySuccessStyle];
                     [hud hideAnimated:YES afterDelay:2];
                     [hud setHiddenBlock:^(KDProgressHUD *hud) {
                         [vc.navigationController popViewControllerAnimated:YES];
                     }];
                 }];
            }];
            
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
        ActionTableViewCell *passwordCell = [[ActionTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        passwordCell.textLabel.text = @"密码";
        passwordCell.detailTextLabel.text = @"修改密码";
        passwordCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        [passwordCell setAction:^{
            ChangePasswordViewController *vc = [[ChangePasswordViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        
        
        ActionTableViewCell *phonenumberCell = [[ActionTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        phonenumberCell.textLabel.text = @"手机号";
        phonenumberCell.detailTextLabel.text = response[@"accountInfo"][@"phonenumber"] ?: @"未绑定手机号";
        
        ActionTableViewCell *emailCell = [[ActionTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        emailCell.textLabel.text = @"邮箱";
        emailCell.detailTextLabel.text = response[@"accountInfo"][@"email"] ?: @"未绑定邮箱";
        
        self.cells = @[@[usernameCell], @[passwordCell], @[phonenumberCell], @[emailCell]];
        [self.tableView reloadData];
    }];

}


@end