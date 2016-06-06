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


@interface XWGJLeftMenuViewController ()<UIActionSheetDelegate>
@property (strong, readwrite, nonatomic) UITableView *tableView;
@property(nonatomic,strong)leftHeadView *headerView;
@property(nonatomic,strong)UIView *footerView;
@property(nonatomic,strong)UIButton *LogOutButton;
@property(nonatomic,copy)NSString *Applystate;
@property(nonatomic,strong)UIImageView *newsTag;  //是否有新通知图标
@property(nonatomic,strong)NSArray *cellImages;
@property(nonatomic,strong)NSArray *cellTitles;

@end

@implementation XWGJLeftMenuViewController

-(NSArray *)cellImages
{
    if (!_cellImages) {
        
        _cellImages = @[@"menu_application",@"menu_messages",@"menu_setting",@"help",@"logout"];
     }
    return _cellImages;
}

-(NSArray *)cellTitles
{
    if (!_cellTitles) {
        
        _cellTitles = @[GDLocalizedString(@"Left-Applycation"),GDLocalizedString(@"Left-noti"),GDLocalizedString(@ "Left-Set"),GDLocalizedString(@ "Left-helpCenter"),GDLocalizedString(@ "Left-Logout")];

    }
    return _cellTitles;
}


-(UIImageView *)newsTag{

    if (!_newsTag) {
        
        _newsTag =[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.8 - 70, 20 , 10, 10)];
        
        _newsTag.image =[UIImage imageNamed:@"message_dot"];
        
        _newsTag.hidden = YES;
    }
    return _newsTag;
}

/**
 *获取数据源
 */
- (void)getDataSource {
    
     if([AppDelegate sharedDelegate].isLogin) {
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
          
           self.newsTag.hidden = [countstr containsString:@"0"];
 
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

    if([[AppDelegate sharedDelegate] isLogin])
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

-(void)makeTableView
{
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width*0.8, self.view.frame.size.height)];
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

-(void)makeUI
{
    
    self.view.backgroundColor =[UIColor clearColor];
    
    [self makeTableView];
    
    [self makeTableHeaderView];
    
}



//获取TabBarController 子控制器导航栏
-(UINavigationController *)CurrentNavigation
{
    NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
    NSString *index = [ud valueForKey:tabBarSelectIndex];
    
    XWGJTabBarController *tab =  [[XWGJTabBarController alloc] init];
    [self.sideMenuViewController setxContentViewController:tab animated:YES];
    [self.sideMenuViewController hideMenuViewController];
    tab.selectedIndex = index.integerValue;
    UINavigationController *nav  =  tab.viewControllers[index.integerValue];
    
    return nav;
}

-(void)caseApply
{
     [MobClick event:@"myApply"];
    [self.sideMenuViewController hideMenuViewController];
    UINavigationController *nav = (UINavigationController *)self.contentViewController.selectedViewController;
    
    if (![self checkWhenUserLogOut]) {
        
        return;
    }
    
    if ([self.Applystate containsString:@"1"] || !self.Applystate) {
        ApplyViewController *apply = [[ApplyViewController alloc] initWithNibName:@"ApplyViewController" bundle:nil];

        [nav pushViewController:apply animated:NO];
    }else{
        ApplyStatusViewController *stateVC = [[ApplyStatusViewController alloc] init];

        [nav pushViewController:stateVC animated:NO];
    }
    
    
}
-(void)caseSetting
{
    [self.sideMenuViewController hideMenuViewController];
    UINavigationController *nav = (UINavigationController *)self.contentViewController.selectedViewController;
    SetViewController *set = [[SetViewController alloc] initWithNibName:@"SetViewController" bundle:nil];
    [nav pushViewController:set animated:NO];
    
}

-(void)caseHelp
{
 
    [self.sideMenuViewController hideMenuViewController];

    UINavigationController *nav = (UINavigationController *)self.contentViewController.selectedViewController;
    
    HelpViewController *help =[[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];

    [nav pushViewController:help animated:NO];
    
    
}

-(void)caseNotication
{
    [MobClick event:@"notificationItemClick"];

    [self.sideMenuViewController hideMenuViewController];
    
    UINavigationController *nav = (UINavigationController *)self.contentViewController.selectedViewController;
    
    if (![self checkWhenUserLogOut]) {
        
        return;
    }
    NotificationViewController *notiVC = [[NotificationViewController alloc] init];

    [nav pushViewController:notiVC animated:NO];
    
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
            [self caseNotication];
            break;
        case 2:
            [self caseSetting];
            break;
        case 3:
            [self caseHelp];
            break;
        default:
            [self xlogout];
            break;
    }
}

#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    return 50;
 }

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    if (![AppDelegate sharedDelegate].isLogin)
    {
        return self.cellImages.count-1;
        
    }else{
    
        return self.cellImages.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MenuLeft";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:20];
        cell.textLabel.textColor = [UIColor whiteColor];
        
        
        UIView *lineView2 =[[UIView alloc] initWithFrame:CGRectMake(35,49, cell.contentView.frame.size.width, 1)];
        lineView2.backgroundColor =[UIColor blackColor];
        UIView *lineView1 =[[UIView alloc] initWithFrame:CGRectMake(35,50, cell.contentView.frame.size.width
                                                                    , 1)];
        lineView1.backgroundColor =[UIColor darkGrayColor];
        
        [cell.contentView addSubview:lineView1];
        
        [cell.contentView addSubview:lineView2];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (indexPath.row == 1) {
        
         [cell.contentView addSubview:self.newsTag];
    }
  
     cell.textLabel.text = self.cellTitles[indexPath.row];
    
     cell.imageView.image = [UIImage imageNamed:self.cellImages[indexPath.row]];
    
    return cell;
}



//注销
- (void)xlogout{
    
     UIActionSheet *sheet =[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:GDLocalizedString(@"Me-007")  destructiveButtonTitle:GDLocalizedString(@"Me-006") otherButtonTitles: nil];
    
    [sheet showInView:self.view];
 
}


#pragma mark -----UIActonSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (0 == buttonIndex) {
        
        if ([AppDelegate sharedDelegate].isLogin) {
            [[AppDelegate sharedDelegate] logout];
            [MobClick profileSignOff];/*友盟第三方统计功能统计退出*/
            self.headerView.userNameLabel.text =GDLocalizedString(@"Me-005");
            self.headerView.iconImageView.image = [UIImage imageNamed:@"default_avatar"];
            
            self.newsTag.hidden = YES;
            
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
