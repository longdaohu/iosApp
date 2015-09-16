
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
#import "AboutViewController.h"
#import "FeedbackViewController.h"

@interface MeViewController () <UIImagePickerControllerDelegate> {
}

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    _avatarImageView.layer.cornerRadius = _avatarImageView.bounds.size.width / 2.0f;
    _avatarImageView.layer.masksToBounds = YES;
    _avatarImageView.layer.borderWidth = 2;
    _avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _coverImageView.image = [[UIImage imageNamed:@"login_background.jpg"] blurredImageWithRadius:10 iterations:3 tintColor:nil];
    
    KDUtilDefineWeakSelfRef
    [_avatarImageView KD_addTapAction:^(UIView *view) {
        RequireLogin
        
        KDActionSheet *as = [[KDActionSheet alloc] initWithTitle:@"更换头像"
                                               cancelButtonTitle:@"取消"
                                                    cancelAction:nil
                                          destructiveButtonTitle:nil
                                               destructiveAction:nil];
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [as addButtonWithTitle:@"拍照" action:^{
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = weakSelf;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePicker.allowsEditing = YES;
                imagePicker.showsCameraControls = YES;
                [self presentViewController:imagePicker animated:YES completion:^{}];
            }];
        }
        [as addButtonWithTitle:@"从手机相册选择" action:^{
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
    
    self.cells = @[@[newCell(@"个人信息", [UIImage imageNamed:@"me_profile"],
                             ^{
                                 RequireLogin
                                 ProfileViewController *vc = [[ProfileViewController alloc] init];
                                 [self.navigationController pushViewController:vc animated:YES];
                             }),
                     newCell(@"我的关注院校", [UIImage imageNamed:@"me_like"],
                             ^{
                                 RequireLogin
                                 FavoriteViewController *vc = [[FavoriteViewController alloc] init];
                                 [self.navigationController pushViewController:vc animated:YES];
                             }),
                     newCell(@"我的申请意向", [UIImage imageNamed:@"me_list"],
                             ^{
                                 RequireLogin
                                 
                                 ApplyViewController *vc = [[ApplyViewController alloc] init];
                                 [self.navigationController pushViewController:vc animated:YES];
                             }),
                     newCell(@"用户反馈", [UIImage imageNamed:@"me_feedback"],
                             ^{
                                 FeedbackViewController *vc = [[FeedbackViewController alloc] init];
                                 [self.navigationController pushViewController:vc animated:YES];
                             }),
                     newCell(@"关于", [UIImage imageNamed:@"me_about"],
                             ^{
                                 AboutViewController *vc = [[AboutViewController alloc] init];
                                 [self.navigationController pushViewController:vc animated:YES];
                             })]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
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
        _usernameLabel.text = @"点击登录或注册";
    }
}

- (IBAction)logout {
    KDActionSheet *as = [[KDActionSheet alloc] initWithTitle:nil cancelButtonTitle:@"取消" cancelAction:nil destructiveButtonTitle:@"确认注销" destructiveAction:^{
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


@end