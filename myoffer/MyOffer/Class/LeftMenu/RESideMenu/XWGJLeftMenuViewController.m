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
#import "OrderViewController.h"
#import "MenuCell.h"
#import "MenuItem.h"
#import "MeViewController.h"
#import "HomeViewContViewController.h"
#import "MessageViewController.h"
#import "CatigoryViewController.h"

@interface XWGJLeftMenuViewController ()<UIActionSheetDelegate>
@property (strong, readwrite, nonatomic) UITableView *tableView;
@property(nonatomic,strong)leftHeadView *headerView;
@property(nonatomic,copy)NSString *Applystate;  //检查申请进程，判断我的申请跳转页面
@property(nonatomic,strong)NSMutableArray *menuItems;
@property(nonatomic,assign)BOOL haveIcon;
@end

@implementation XWGJLeftMenuViewController


-(NSMutableArray *)menuItems{

    if (!_menuItems) {
        
        _menuItems =[NSMutableArray array];
        
    }
    return _menuItems;
}


-(void)makeCellItems{
    
    [self.menuItems removeAllObjects];
    
    MenuItem *apply  = [MenuItem menuItemInitWithName:GDLocalizedString(@"Left-Applycation") icon:@"menu_application" count:@"0"];
    MenuItem *set    = [MenuItem menuItemInitWithName:GDLocalizedString(@"Left-Set") icon:@"menu_setting" count:@"0"];
    MenuItem *help   = [MenuItem menuItemInitWithName:GDLocalizedString(@"Left-helpCenter") icon:@"help" count:@"0"];
    MenuItem *logout = [MenuItem menuItemInitWithName:GDLocalizedString(@"Left-Logout") icon:@"logout" count:@"0"];
    
    if (LOGIN) {
        
        NSUserDefaults *ud       = [NSUserDefaults standardUserDefaults];
        
        NSString *message_count  = [ud valueForKey:@"message_count"];
        
        NSString *order_count    = [ud valueForKey:@"order_count"];
        
        MenuItem *order   = [MenuItem menuItemInitWithName:@"订单中心" icon:@"menu_service" count:order_count];
        
        MenuItem *message = [MenuItem menuItemInitWithName:GDLocalizedString(@"Left-noti") icon:@"menu_messages" count:message_count];
        
        NSArray *temps = @[apply,order,message,set,help,logout];
        
        self.menuItems = [temps mutableCopy];
        
    
        
        [self startAPIRequestWithSelector:kAPISelectorCheckNews parameters:nil showHUD:NO success:^(NSInteger statusCode, id response) {
            
            MenuItem *order = self.menuItems[1];
            order.messageCount = [NSString stringWithFormat:@"%@",response[@"order_count"]];
            MenuItem *message = self.menuItems[2];
            message.messageCount = [NSString stringWithFormat:@"%@",response[@"message_count"]];
            
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0],[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];

        }];
        
        
        
        
    }else{
        
        MenuItem *offer = [MenuItem menuItemInitWithName:@"订单中心" icon:@"menu_service" count:@"0"];
        MenuItem *noti  = [MenuItem menuItemInitWithName:GDLocalizedString(@"Left-noti") icon:@"menu_messages" count:@"0"];
        NSArray *temps  = @[apply,offer,noti,set,help,logout];
        self.menuItems  = [temps mutableCopy];
    }
    
    
    [self.tableView reloadData];

}

/**
 *获取数据源
 */
- (void)makeDataSource {
    
    
    [self makeCellItems];
    
 
     if(LOGIN) {
         
         //请求头像信息
         if (!self.haveIcon){
             
              [self startAPIRequestUsingCacheWithSelector:kAPISelectorAccountInfo parameters:nil success:^(NSInteger statusCode, id response) {
                
                 self.haveIcon = YES;
                 self.headerView.userNameLabel.text = response[@"accountInfo"][@"displayname"];
                 self.headerView.iconImageView.image = [UIImage imageNamed:@"default_avatar.jpg"];
                 [self.headerView.iconImageView KD_setImageWithURL:response[@"portraitUrl"]];
                 
             }];
  
         }
   
         
     }else{
         
         self.haveIcon = NO;
         self.headerView.userNameLabel.text =GDLocalizedString(@"Me-005");//@"点击登录或注册";
         self.headerView.iconImageView.image = [UIImage imageNamed:@"default_avatar.jpg"];
     }
    
    
    if (LOGIN) {
    
        //检查网络是否连接，如果没有连接，不再往下执行代码
        if (![self checkNetWorkReaching]) {
            
            return;
        }
        
         /** state     状态有4个值
         *  【 pending  ——审核中
         *  【 PushBack ——退回
         *  【 Approved ——审核通过
         *  【 -1       ——表示没有申请过
         *   检查申请进程，判断我的申请跳转页面
         */
        [self startAPIRequestWithSelector:@"GET api/account/applicationliststateraw" parameters:nil showHUD:NO success:^(NSInteger statusCode, id response) {
            
            self.Applystate = response[@"state"];
            
        }];
        

    }
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"page左侧菜单"];
    
    [self  makeDataSource];
        

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
    
     RequireLogin
    
    if ([self.Applystate containsString:@"1"] || !self.Applystate) {
 
        [self pushViewController:[[ApplyViewController alloc] initWithNibName:@"ApplyViewController" bundle:nil]];

     }else{
         
         [self pushViewController:[[ApplyStatusViewController alloc] init]];
    }
    
}


-(void)caseSetting
{
     [self.sideMenuViewController hideMenuViewController];

     [self pushViewController:[[SetViewController alloc] init]];
    
}

-(void)caseHelp
{
    [self.sideMenuViewController hideMenuViewController];

    [self pushViewController:[[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil]];
    
}

-(void)caseOrderList
{
    [self.sideMenuViewController hideMenuViewController];

    RequireLogin
    
    [self pushViewController:[[OrderViewController alloc] init]];
    
}


-(void)caseNotication
{
    [MobClick event:@"notificationItemClick"];

    [self.sideMenuViewController hideMenuViewController];

    RequireLogin
  
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
   
    return  LOGIN ? self.menuItems.count :self.menuItems.count - 1;
    
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
        
      
            [[AppDelegate sharedDelegate] logout];
            [MobClick profileSignOff];/*友盟第三方统计功能统计退出*/
//            self.headerView.userNameLabel.text =GDLocalizedString(@"Me-005");
//            self.headerView.iconImageView.image = [UIImage imageNamed:@"default_avatar"];
//            [self makeCellItems];

            [APService setAlias:@"" callbackSelector:nil object:nil];  //设置Jpush用户所用别名为空
            [self startAPIRequestUsingCacheWithSelector:kAPISelectorLogout parameters:nil success:^(NSInteger statusCode, id response) {
            }];
        
        [self makeDataSource];
        
        UINavigationController *nav = (UINavigationController *)self.contentViewController.selectedViewController;
       
        switch (self.contentViewController.selectedIndex) {
            case 3:
            {
                MeViewController *vc =nav.childViewControllers[0];
                [vc leftViewMessage];
            }
                break;
            case 2:
            {
                MessageViewController *vc =nav.childViewControllers[0];
                [vc leftViewMessage];
            }
                break;
            case 1:
            {
                CatigoryViewController  *vc =nav.childViewControllers[0];
                [vc leftViewMessage];
            }
                break;
            default:{
            
                HomeViewContViewController *vc =nav.childViewControllers[0];
                [vc leftViewMessage];
            }
                break;
                

        }
    }
    
}

#pragma mark -----UIImagePickerControlleDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = info[UIImagePickerControllerEditedImage];
    image = [image KD_imageByCroppedToSquare:600];
    
    NSData *data = UIImageJPEGRepresentation(image, 0.8);
    
    NSString *path = [NSString stringWithFormat:@"%@m/api/account/portrait",DOMAINURL];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:path]];
   
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
            
            RequireLogin
     
            NotificationViewController *notiVC = [[NotificationViewController alloc] init];
            notiVC.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:notiVC animated:NO];
            
            WebViewController *noti =[[WebViewController alloc] init];
            noti.path    = [NSString stringWithFormat:@"%@account/message/%@?client=app",DOMAINURL,userInfo[@"message_id"]];
            [notiVC.navigationController pushViewController:noti  animated:YES];
        
        }
            break;
            
        case 2:{
            
            RequireLogin
     
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
