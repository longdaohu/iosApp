//
//  DEMOMenuViewController.m
//  RESideMenuExample
//
//  Created by Roman Efimov on 10/10/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "XWGJLeftMenuViewController.h"
#import "XWGJTabBarController.h"
#import "ApplyViewController.h"
#import "XWGJNavigationController.h"
#import "SetViewController.h"
#import "HelpViewController.h"
#import "leftHeadView.h"
#import "NotificationViewController.h"
#import "ApplyStatusViewController.h"
#import "DetailWebViewController.h"
#import "OrderViewController.h"
#import "MenuCell.h"
#import "MenuItem.h"


@interface XWGJLeftMenuViewController ()<UIActionSheetDelegate>
@property (strong, readwrite, nonatomic) UITableView *tableView;
@property(nonatomic,strong)leftHeadView *headerView;
@property(nonatomic,copy)NSString *Applystate;  //检查申请进程，判断我的申请跳转页面
@property(nonatomic,strong)NSArray *menuItems;
@end

@implementation XWGJLeftMenuViewController
-(NSArray *)menuItems{

    if (!_menuItems) {
        
        MenuItem *apply =[MenuItem menuItemInitWithName:GDLocalizedString(@"Left-Applycation") icon:@"menu_application"];
        MenuItem *offer =[MenuItem menuItemInitWithName:@"订单中心" icon:@"menu_service"];
        MenuItem *noti =[MenuItem menuItemInitWithName:GDLocalizedString(@"Left-noti") icon:@"menu_messages"];
        MenuItem *set =[MenuItem menuItemInitWithName:GDLocalizedString(@"Left-Set") icon:@"menu_setting"];
        MenuItem *help =[MenuItem menuItemInitWithName:GDLocalizedString(@"Left-helpCenter") icon:@"help"];
        MenuItem *logout =[MenuItem menuItemInitWithName:GDLocalizedString(@"Left-Logout") icon:@"logout"];
        _menuItems = @[apply,offer,noti,set,help,logout];
    }
    return _menuItems;
}


/**
 *获取数据源
 */
- (void)getDataSource {
    
     if(LOGIN) {
         self.headerView.userNameLabel.text = nil;
        //请求头像信息
        [self startAPIRequestUsingCacheWithSelector:kAPISelectorAccountInfo parameters:nil success:^(NSInteger statusCode, id response) {
            
            self.headerView.userNameLabel.text = response[@"accountInfo"][@"displayname"];
            self.headerView.iconImageView.image = [UIImage imageNamed:@"default_avatar.jpg"];
            [self.headerView.iconImageView KD_setImageWithURL:response[@"portraitUrl"]];
        }];
        
        //检查网络是否连接，如果没有连接，不再往下执行代码
        if (![self checkNetWorkReaching]) {
            
            return;
        }
        
        //检查是否有未读通知信息
      [self startAPIRequestWithSelector:kAPISelectorCheckNews parameters:nil success:^(NSInteger statusCode, id response) {
          
           NSString *countstr = [NSString stringWithFormat:@"%@",response[@"has_new_message"]];
            MenuItem *item = self.menuItems[2];
          item.newMessage = [countstr containsString:@"1"];
          
          [self.tableView reloadData];
    
        }];
        
          /** state     状态有4个值
          *  【 pending  ——审核中
          *  【 PushBack ——退回
          *  【 Approved ——审核通过
          *  【 -1       ——表示没有申请过
          *   检查申请进程，判断我的申请跳转页面
          */
        [self startAPIRequestWithSelector:@"GET api/account/applicationliststateraw" parameters:nil success:^(NSInteger statusCode, id response) {
                        self.Applystate = response[@"state"];
                    }];
         
         
    }
    
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"page左侧菜单"];

    if(LOGIN)
    {
        [self  getDataSource];
        
    }else{
        
        self.headerView.userNameLabel.text =GDLocalizedString(@"Me-005");//@"点击登录或注册";
        self.headerView.iconImageView.image = [UIImage imageNamed:@"default_avatar.jpg"];
     }
}




- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page左侧菜单"];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self makeUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(push:) name:@"push" object:nil];
    
}

-(void)makeUI
{
    self.view.backgroundColor =[UIColor clearColor];
    
    [self makeTableView];
    
    [self makeTableHeaderView];
}


-(void)makeTableView
{
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width*0.8, self.view.frame.size.height) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:tableView];
        
        tableView;
    });
    
    [self makeTableHeaderView];

}

-(void)makeTableHeaderView
{
    self.headerView = [[NSBundle mainBundle] loadNibNamed:@"leftHeadView" owner:nil options:nil].lastObject;
    self.tableView.tableHeaderView = self.headerView;
    
    KDUtilDefineWeakSelfRef
    [self.headerView.iconImageView KD_addTapAction:^(UIView *view) {
        
        [MobClick event:@"UserIconClick"];

        if(![[AppDelegate sharedDelegate] isLogin])
        {
            [self.sideMenuViewController hideMenuViewController];
            
            RequireLogin
        }
        //@"更换头像"  @"取消"
        KDActionSheet *as = [[KDActionSheet alloc] initWithTitle:GDLocalizedString(@"Me-008")
                                               cancelButtonTitle:GDLocalizedString(@"Me-007")
                                                    cancelAction:nil
                                          destructiveButtonTitle:nil
                                               destructiveAction:nil];
        // @"拍照"  @"从手机相册选择"
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [as addButtonWithTitle:GDLocalizedString(@"Me-009") action:^{
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = weakSelf;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePicker.allowsEditing = YES;
                imagePicker.showsCameraControls = YES;
                [self presentViewController:imagePicker animated:YES completion:^{}];
            }];
        }
        [as addButtonWithTitle:GDLocalizedString(@"Me-0010") action:^{
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = weakSelf;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.allowsEditing = YES;
            [self presentViewController:imagePicker animated:YES completion:^{}];
        }];
        [as showInView:[weakSelf view]];
    }];

}



-(void)pushViewController:(UIViewController *)vc
{
    
    UINavigationController *nav = (UINavigationController *)self.contentViewController.selectedViewController;
    
    [nav pushViewController:vc animated:NO];
    
}


-(void)caseApply
{
    
    [self.sideMenuViewController hideMenuViewController];

    
    [MobClick event:@"myApply"];
    
    if (![self checkWhenUserLogOut]) {
        
        return;
    }

    if ([self.Applystate containsString:@"1"] || !self.Applystate) {
 
        [self pushViewController:[[ApplyViewController alloc] initWithNibName:@"ApplyViewController" bundle:nil]];

     }else{
         
         [self pushViewController:[[ApplyStatusViewController alloc] init]];
    }
    
}


-(void)caseSetting
{
    [self.sideMenuViewController hideMenuViewController];

    
    [self pushViewController:[[SetViewController alloc] initWithNibName:@"SetViewController" bundle:nil]];
    
}

-(void)caseHelp
{
    [self.sideMenuViewController hideMenuViewController];

    [self pushViewController:[[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil]];
    
}

-(void)caseOrderList
{
    [self.sideMenuViewController hideMenuViewController];

    if (![self checkWhenUserLogOut]) {
        
        return;
    }
    
    [self pushViewController:[[OrderViewController alloc] init]];
    
}


-(void)caseNotication
{
    [MobClick event:@"notificationItemClick"];

    [self.sideMenuViewController hideMenuViewController];

    if (![self checkWhenUserLogOut]) {
        
        return;
    }
    [self pushViewController:[[NotificationViewController alloc] init]];
    
}


//注销
- (void)xlogout{
    
    UIActionSheet *sheet =[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:GDLocalizedString(@"Me-007")  destructiveButtonTitle:GDLocalizedString(@"Me-006") otherButtonTitles: nil];
    [sheet showInView:self.view];
    
}


#pragma mark UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
            [self caseApply];
            break;
        case 1:
            [self caseOrderList];
            break;
        case 2:
            [self caseNotication];
            break;
        case 3:
            [self caseSetting];
            break;
        case 4:
            [self caseHelp];
            break;
        default:
            [self xlogout];
            break;
    }
}

#pragma mark ------------- UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    return 50;
 }


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
   
    if (!LOGIN)
    {
        return self.menuItems.count - 1;
        
    }else{
    
        return self.menuItems.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MenuCell *cell = [MenuCell cellWithTableView:tableView indexPath:indexPath];
    cell.item = self.menuItems[indexPath.row];
    
    return cell;
}



#pragma mark -----UIActonSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (0 == buttonIndex) {
        
        if (LOGIN) {
            [[AppDelegate sharedDelegate] logout];
            [MobClick profileSignOff];/*友盟第三方统计功能统计退出*/
            self.headerView.userNameLabel.text =GDLocalizedString(@"Me-005");
            self.headerView.iconImageView.image = [UIImage imageNamed:@"default_avatar"];
            
            MenuItem *item = self.menuItems[2];
            item.newMessage = NO;
            [self.tableView reloadData];
            
            [APService setAlias:@"" callbackSelector:nil object:nil];  //设置Jpush用户所用别名为空
            [self startAPIRequestUsingCacheWithSelector:kAPISelectorLogout parameters:nil success:^(NSInteger statusCode, id response) {
                
            }];
        }
    }
}

#pragma mark -----UIImagePickerControlleDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = info[UIImagePickerControllerEditedImage];
    image = [image KD_imageByCroppedToSquare:600];
    
    NSData *data = UIImageJPEGRepresentation(image, 0.8);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.myoffer.cn/m/api/account/portrait"]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"BOUNDARY_STRING";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    [request addValue:[[AppDelegate sharedDelegate] accessToken] forHTTPHeaderField:@"apikey"];
    KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:self.view animated:YES];
    [[APIClient defaultClient] startTaskWithRequest:request expectedStatusCodes:nil success:^(NSInteger statusCode, id response) {
        [hud hideAnimated:YES afterDelay:1];
        [hud applySuccessStyle];
        
        self.headerView.iconImageView.image = image;
    } failure:^(NSInteger statusCode, NSError *error) {
        [hud hideAnimated:YES];
        [self showAPIErrorAlertView:error clickAction:nil];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
}




//接到通知判断页面跳转
-(void)push:(NSNotification *)noti
{

    NSDictionary *userInfo = noti.userInfo;
    NSInteger View_Id = [noti.userInfo[@"view_id"] integerValue];
   
    [self dismiss];
    
    [self.sideMenuViewController hideMenuViewController];
    
    UINavigationController *nav = (UINavigationController *)self.contentViewController.selectedViewController;
    
    [nav popToRootViewControllerAnimated:NO];
    
    switch (View_Id) {
        case 0:

            [self caseApply];

             break;
            
        case 1:{
         
            
            if (![self checkWhenUserLogOut]) {
                
                return;
            }
            
            NotificationViewController *notiVC = [[NotificationViewController alloc] init];
            notiVC.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:notiVC animated:NO];
            
            
            DetailWebViewController *detailVC =[[DetailWebViewController alloc] init];
            detailVC.notiID =userInfo[@"message_id"];
            [notiVC.navigationController pushViewController:detailVC  animated:YES];

        
        }
            break;
            
        case 2:{
            
            
            if (![self checkWhenUserLogOut]) {
                
                return;
            }

            ApplyViewController *apply = [[ApplyViewController alloc] initWithNibName:@"ApplyViewController" bundle:nil];
            apply.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:apply animated:NO];
                
        }
            break;
        case 3:{
            
            
            if (!USER_EN) {

                XWGJTabBarController *tab  = ( XWGJTabBarController *)self.contentViewController;
                
                [tab setSelectedIndex:2];
            }
            
        }
            break;
        default:
            break;
    }
    
}



@end
