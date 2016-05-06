//
//  DEMOMenuViewController.m
//  RESideMenuExample
//
//  Created by Roman Efimov on 10/10/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOLeftMenuViewController.h"
#import "XWGJTabBarController.h"
#import "ApplyViewController.h"
#import "XWGJNavigationController.h"
#import "SetViewController.h"
#import "HelpViewController.h"
#import "leftHeadView.h"

@interface DEMOLeftMenuViewController ()
@property (strong, readwrite, nonatomic) UITableView *tableView;
@property(nonatomic,strong)leftHeadView *headerView;
@property(nonatomic,strong)UIView *footerView;
@property(nonatomic,strong)UIButton *LogOutButton;
@end

@implementation DEMOLeftMenuViewController
- (void)reconfigure {
    
    
    if([AppDelegate sharedDelegate].isLogin) {
        self.headerView.userNameLabel.text = nil;
        [self startAPIRequestUsingCacheWithSelector:kAPISelectorAccountInfo parameters:nil success:^(NSInteger statusCode, id response) {
            
            self.headerView.userNameLabel.text = response[@"accountInfo"][@"displayname"];
            self.headerView.iconImageView.image = [UIImage imageNamed:@"default_avatar.jpg"];
            [self.headerView.iconImageView KD_setImageWithURL:response[@"portraitUrl"]];
        }];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if([[AppDelegate sharedDelegate] isLogin])
    {
        self.footerView.hidden = NO;
        [self  reconfigure];
    }else{
        
        self.headerView.userNameLabel.text =GDLocalizedString(@"Me-005");//@"点击登录或注册";
        self.headerView.iconImageView.image = [UIImage imageNamed:@"default_avatar.jpg"];
        self.footerView.hidden = YES;
    }
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width*0.8, self.view.frame.size.height)];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView;
    });
    
    [self makeUI];
}

-(void)makeUI
{
    
    [self.view addSubview:self.tableView];
    self.view.backgroundColor =[UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    
    self.headerView = [[NSBundle mainBundle] loadNibNamed:@"leftHeadView" owner:nil options:nil].lastObject;
    self.tableView.tableHeaderView = self.headerView;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.tableView.bounds.size.width, 100)];
    self.footerView = footerView;
    UIImageView *LogOutImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    LogOutImageView.contentMode = UIViewContentModeCenter;
    LogOutImageView.image = [UIImage imageNamed:@"logout"];
    [footerView addSubview:LogOutImageView];
    UILabel *logOutLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(LogOutImageView.frame), 0, 100, 50)];
    logOutLabel.text = GDLocalizedString(@ "Left-Logout") ;
    logOutLabel.textColor =[UIColor whiteColor];
    logOutLabel.font = [UIFont systemFontOfSize:17];
    [footerView addSubview:logOutLabel];
    self.LogOutButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 50)];
    [self.LogOutButton addTarget:self action:@selector(xlogout) forControlEvents:UIControlEventTouchUpInside];
    
    
    [footerView addSubview:self.LogOutButton];
    self.tableView.tableFooterView = footerView;
    
    
    
    KDUtilDefineWeakSelfRef
    [self.headerView.iconImageView KD_addTapAction:^(UIView *view) {
        
        
        if(![[AppDelegate sharedDelegate] isLogin])
        {
            
            [self.sideMenuViewController hideMenuViewController];
            
            
            RequireLogin
        }
        //"Me-008" = "Change Avatar";  @"更换头像"  @"取消"
        KDActionSheet *as = [[KDActionSheet alloc] initWithTitle:GDLocalizedString(@"Me-008")
                                               cancelButtonTitle:GDLocalizedString(@"Me-007")
                                                    cancelAction:nil
                                          destructiveButtonTitle:nil
                                               destructiveAction:nil];
        //GDLocalizedString(@"Me-009")  @"拍照"  @"从手机相册选择"
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


#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [self.sideMenuViewController setxContentViewController:[[XWGJTabBarController alloc] init] animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 1:
            [self caseOne];
            break;
        case 2:
            [self caseTwo];
            break;
        case 3:
            [self caseThree];
            break;
        default:
            break;
    }
}
-(void)caseOne
{
    
    XWGJTabBarController *tab =  [[XWGJTabBarController alloc] init];
    [self.sideMenuViewController setxContentViewController:tab animated:YES];
    [self.sideMenuViewController hideMenuViewController];
    tab.selectedIndex = 2;
    UINavigationController *nav  =  tab.viewControllers[2];
    
    if (![self checkWhenUserLogOut]) {
        
        return;
    }
    ApplyViewController *apply = [[ApplyViewController alloc] initWithNibName:@"ApplyViewController" bundle:nil]; apply.hidesBottomBarWhenPushed = YES;
    [nav pushViewController:apply animated:NO];
    
    
}
-(void)caseTwo
{
    XWGJTabBarController *tab =  [[XWGJTabBarController alloc] init];
    [self.sideMenuViewController setxContentViewController:tab animated:YES];
    [self.sideMenuViewController hideMenuViewController];
    tab.selectedIndex = 0;
    UINavigationController *nav  =  tab.viewControllers[0];
    SetViewController *set = [[SetViewController alloc] initWithNibName:@"SetViewController" bundle:nil];
    set.hidesBottomBarWhenPushed = YES;
    [nav pushViewController:set animated:NO];
    
}

-(void)caseThree
{
    XWGJTabBarController *tab =  [[XWGJTabBarController alloc] init];
    [self.sideMenuViewController setxContentViewController:tab animated:YES];
    [self.sideMenuViewController hideMenuViewController];
    
    UINavigationController *nav  =  tab.viewControllers[0];
    HelpViewController *help =[[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
    help.hidesBottomBarWhenPushed = YES;
    [nav pushViewController:help animated:NO];
    
}


#pragma mark -
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
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
        
        
        UIView *lineView2 =[[UIView alloc] initWithFrame:CGRectMake(35,49, cell.contentView.frame.size.width, 1)];
        lineView2.backgroundColor =[UIColor blackColor];
        UIView *lineView1 =[[UIView alloc] initWithFrame:CGRectMake(35,50, cell.contentView.frame.size.width
                                                                    , 1)];
        lineView1.backgroundColor =[UIColor darkGrayColor];
        
        [cell.contentView addSubview:lineView1];
        [cell.contentView addSubview:lineView2];
    }
    
    //    NSArray *titles = @[@"Home", @"Calendar", @"Profile", @"Settings", @"Log Out"];
    NSArray *titles  = @[GDLocalizedString(@ "Left-Home"),GDLocalizedString(@"Me-001"),GDLocalizedString(@ "Left-Set"),GDLocalizedString(@ "Left-helpCenter")];
    
    //    NSArray *images = @[@"IconHome", @"IconCalendar", @"IconProfile", @"IconSettings", @"IconEmpty"];
    NSArray *images = @[@"menu_explore",@"menu_application",@"menu_setting",@"help"];
    cell.textLabel.text = titles[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
    
    return cell;
}


//注销
- (void)xlogout {
    //  @"取消"  @"确认注销"
    
    KDActionSheet *as = [[KDActionSheet alloc] initWithTitle:nil cancelButtonTitle:GDLocalizedString(@"Me-007") cancelAction:nil destructiveButtonTitle:GDLocalizedString(@"Me-006") destructiveAction:^{
        
        if ([AppDelegate sharedDelegate].isLogin) {
            
            [[AppDelegate sharedDelegate] logout];
            [MobClick profileSignOff];/*友盟第三方统计功能统计退出*/
            self.headerView.userNameLabel.text =GDLocalizedString(@"Me-005");//@"点击登录或注册";
            
            self.headerView.iconImageView.image = [UIImage imageNamed:@"default_avatar.jpg"];
            
            self.footerView.hidden = YES;
        }
        
    }];
    
    [as showInView:[self view]];
}


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

@end
