
//
//  MeViewController.m
//  MyOffer
//
//  Created by Blankwonder on 6/7/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import "MeViewController.h"
#import "ProfileViewController.h"
#import "FXBlurView.h"
#import "FavoriteViewController.h"
#import "ApplyViewController.h"
#import "SetViewController.h"
#import "ApplySubmitViewController.h"
#import "MyOfferViewController.h"
#import "ApplyMatialViewController.h"

@interface MeViewController () <UIImagePickerControllerDelegate> {
}

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_logoutButton setTitle:GDLocalizedString(@"Me-004") forState:UIControlStateNormal];
   
    //设置按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting_39"] style:UIBarButtonItemStylePlain target:self action:@selector(settingButtonPressed:)];
    
    _avatarImageView.layer.cornerRadius = _avatarImageView.bounds.size.width / 2.0f;
    _avatarImageView.layer.masksToBounds = YES;
    _avatarImageView.layer.borderWidth = 2;
    _avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _coverImageView.image = [[UIImage imageNamed:@"login_background.jpg"] blurredImageWithRadius:10 iterations:3 tintColor:nil];
    
    KDUtilDefineWeakSelfRef
    [_avatarImageView KD_addTapAction:^(UIView *view) {
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
    
    ActionTableViewCell *(^newCell)(NSString *text, UIImage *icon, void (^action)(void)) = ^ActionTableViewCell*(NSString *text, UIImage *icon, void (^action)(void)) {
        ActionTableViewCell *cell = [[ActionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = text;
        cell.imageView.image = icon;
        cell.action = action;
        
        return cell;
    };
    
    NSString *list = GDLocalizedString(@"Me-001");//"我的申请意向";
    NSString *status = GDLocalizedString(@"Me-002");//"申请状态";
    NSString *material = GDLocalizedString(@"Me-003");//"申请材料";
    
    
    self.cells = @[@[ newCell(list, [UIImage imageNamed:@"list_39"],
                              ^{
                                  RequireLogin
                                  
                                  ApplyViewController *vc = [[ApplyViewController alloc] init];
                                  [self.navigationController pushViewController:vc animated:YES];
                              }),
                      newCell(status, [UIImage imageNamed:@"status_39"],
                              ^{
                                  RequireLogin
                                  ApplySubmitViewController *vc = [[ApplySubmitViewController alloc] initWithNibName:@"ApplySubmitViewController" bundle:nil];
                                  vc.hidesBottomBarWhenPushed = YES;
                                  [self.navigationController pushViewController:vc animated:YES];
                              }),
                      newCell(material, [UIImage imageNamed:@"materials_39"],
                              ^{
                                  RequireLogin
                                  ApplyMatialViewController *vc = [[ApplyMatialViewController alloc] initWithNibName:@"ApplyMatialViewController" bundle:nil];
                                  vc.hidesBottomBarWhenPushed = YES;
                                  [self.navigationController pushViewController:vc animated:YES];
                              }),
                      newCell(@"myOffer", [UIImage imageNamed:@"myoffer_39"],
                              ^{
                                  RequireLogin
                                  MyOfferViewController *vc = [[MyOfferViewController alloc] initWithNibName:@"MyOfferViewController" bundle:nil];
                                  vc.hidesBottomBarWhenPushed = YES;
                                  [self.navigationController pushViewController:vc animated:YES];
                              })] ];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reconfigure];
}

- (void)reconfigure {
    if ([AppDelegate sharedDelegate].isLogin) {
        _logoutButton.hidden = NO;
        
        _usernameLabel.text = nil;
        [self startAPIRequestUsingCacheWithSelector:kAPISelectorAccountInfo parameters:nil success:^(NSInteger statusCode, id response) {
            _usernameLabel.text = response[@"accountInfo"][@"displayname"];
            _avatarImageView.image = [UIImage imageNamed:@"default_avatar"];
            [_avatarImageView KD_setImageWithURL:response[@"portraitUrl"]];
        }];
    } else {
        _logoutButton.hidden = YES;
        _avatarImageView.image = [UIImage imageNamed:@"default_avatar"];
        _usernameLabel.text =GDLocalizedString(@"Me-005");//@"点击登录或注册";
    }
}
- (IBAction)logout {
    NSString *cancelString = GDLocalizedString(@"Me-007"); //取消
    NSString *commintString = GDLocalizedString(@"Me-006"); //@"确认注销"
    KDActionSheet *as = [[KDActionSheet alloc] initWithTitle:nil cancelButtonTitle:cancelString cancelAction:nil destructiveButtonTitle:commintString destructiveAction:^{
        [[AppDelegate sharedDelegate] logout];
        [self reconfigure];
    }];
    [as showInView:self.view];
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
        
        _avatarImageView.image = image;
    } failure:^(NSInteger statusCode, NSError *error) {
        [hud hideAnimated:YES];
        [self showAPIErrorAlertView:error clickAction:nil];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:^{}];
}


-(void)settingButtonPressed:(UIButton *)sender
{
    SetViewController *setVC =[[SetViewController alloc] initWithNibName:@"SetViewController" bundle:nil];
    setVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:setVC animated:YES];
}


@end
