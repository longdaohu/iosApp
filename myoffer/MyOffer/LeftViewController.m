//
//  LeftViewController.m
//  YRSideViewController
//
//  Created by 王晓宇 on 14-5-10.
//  Copyright (c) 2014年 YueRuo. All rights reserved.
//

#import "LeftViewController.h"
#import "AppDelegate.h"
#import "SetViewController.h"
#import  "XWGJTabBarController.h"
#import "leftHeadView.h"
#import "ApplySubmitViewController.h"

@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong)UITableView *MenuTableView;
@property(nonatomic,strong)leftHeadView *headerView;
@property(nonatomic,strong)NSArray *MenuItems;
@property(nonatomic,assign)NSInteger LastRow;

@end

@implementation LeftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSArray *)MenuItems
{
    if (!_MenuItems) {
        //侧边菜单
      //  _MenuItems = @[@"主页",@"我的申请",@"设置",@"注销"];
        _MenuItems = @[GDLocalizedString(@ "Left-Home"),GDLocalizedString(@ "Left-Applycation"),GDLocalizedString(@ "Left-Set"),GDLocalizedString(@ "Left-Logout")];

        
    }
    return _MenuItems;
}
- (void)viewDidLoad
{    self.view.backgroundColor =[UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1];
    [super viewDidLoad];
    [self makeUI];
    self.LastRow = 0;
    
}
-(void)makeUI
{
    self.MenuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 160, 267, APPSIZE.height) style:UITableViewStylePlain];
    self.MenuTableView.backgroundColor =[UIColor clearColor];
    self.MenuTableView.dataSource = self;
    self.MenuTableView.delegate =self;
    [self.view addSubview:self.MenuTableView];
    self.headerView = [[NSBundle mainBundle] loadNibNamed:@"leftHeadView" owner:nil options:nil].lastObject;
    [self.view addSubview:self.headerView];
    self.MenuTableView.tableFooterView =[[UIView alloc] init];
    
    KDUtilDefineWeakSelfRef
    [self.headerView.iconImageView KD_addTapAction:^(UIView *view) {
        RequireLogin
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

- (void)reconfigure {
  
     self.headerView.userNameLabel.text =GDLocalizedString(@"Me-005");//@"点击登录或注册";
     self.headerView.iconImageView.image = [UIImage imageNamed:@"default_avatar"];
     if([AppDelegate sharedDelegate].isLogin) {
        self.headerView.userNameLabel.text = nil;
        [self startAPIRequestUsingCacheWithSelector:kAPISelectorAccountInfo parameters:nil success:^(NSInteger statusCode, id response) {
            self.headerView.userNameLabel.text = response[@"accountInfo"][@"displayname"];
             self.headerView.iconImageView.image = [UIImage imageNamed:@"default_avatar"];
            [self.headerView.iconImageView KD_setImageWithURL:response[@"portraitUrl"]];
        }];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self  reconfigure];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.MenuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//    cell.selectedBackgroundView.backgroundColor =[UIColor redColor];
     cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor= [UIColor clearColor];
    cell.textLabel.text = self.MenuItems[indexPath.row];
   
     return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
  
    YRSideViewController *sideViewController=[((AppDelegate*)[[UIApplication sharedApplication]delegate])sideViewController];
    
     if(indexPath.row == self.MenuItems.count-1 )
     {
         [tableView deselectRowAtIndexPath:indexPath animated:YES];
         [self logout];
         return;
         
     }else
     {
         if(self.LastRow != indexPath.row)
         {
             
             self.LastRow = indexPath.row;
             
             if (indexPath.row == 0) {
                 
                 XWGJTabBarController * mainController = [[XWGJTabBarController alloc] init];
                 [sideViewController setRootViewController:mainController];
                 
             }
             if (indexPath.row == 1) {
                 RequireLogin
                 ApplySubmitViewController *vc = [[ApplySubmitViewController alloc] initWithNibName:@"ApplySubmitViewController" bundle:nil];
                 vc.from = @"left";
                 UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                 [sideViewController setRootViewController:nav];
              }
              if (indexPath.row ==2) {
                 
                 SetViewController  *setController =[[SetViewController alloc] initWithNibName:@"SetViewController" bundle:nil];
                 XWGJNavigationController  *nav = [[XWGJNavigationController alloc] initWithRootViewController:setController];
                 [sideViewController setRootViewController:nav];
              }
          }
         [sideViewController hideSideViewController:YES];

     }
   
 }
//注销
- (void)logout {
    //  @"取消"  @"确认注销"
     KDActionSheet *as = [[KDActionSheet alloc] initWithTitle:nil cancelButtonTitle:GDLocalizedString(@"Me-007") cancelAction:nil destructiveButtonTitle:GDLocalizedString(@"Me-006") destructiveAction:^{
        
        if ([AppDelegate sharedDelegate].isLogin) {
            
            [[AppDelegate sharedDelegate] logout];
            
            self.headerView.userNameLabel.text =GDLocalizedString(@"Me-005");//@"点击登录或注册";
            
            self.headerView.iconImageView.image = [UIImage imageNamed:@"default_avatar"];
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




-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
//    NSLog(@"left view rotate");
}
@end

