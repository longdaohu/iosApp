//
//  LoginOrRegisterViewController.h
//  
//
//  Created by Blankwonder on 6/13/15.
//
//

#import <UIKit/UIKit.h>
#import "FXBlurView.h"

@interface LoginAndRegisterViewController : BaseViewController <UITextFieldDelegate> {
    IBOutlet KDEasyTouchButton *_loginButton, *_registerButton, *_backButton, *_resetPasswordButton;
    IBOutlet FXBlurView *_blurView;
    IBOutlet NSLayoutConstraint *_logoCenterY;
    
    IBOutlet UIView *_registerView;
    IBOutlet UITextField *_phoneTextField, *_passwordTextField, *_passwordConfirmTextField, *_verifyCodeTextField;
    IBOutlet KDEasyTouchButton *_sendVerifyCodeButton, *_registerConfirmButton;
    
    
    IBOutlet UIView *_loginView;
    IBOutlet UITextField *_loginPhoneTextField, *_loginPasswordTextField;
    
    IBOutlet UILabel *_registerLabel;
}

- (IBAction)login;
- (IBAction)register;
- (IBAction)back;
- (IBAction)forgotPassword;

- (IBAction)loginConfirm;

@end
