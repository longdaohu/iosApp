//
//  FeedbackViewController.m
//  MyOffer
//
//  Created by Blankwonder on 6/24/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.title = @"用户反馈";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_textView becomeFirstResponder];
}

- (IBAction)send {
    [self startAPIRequestWithSelector:@"POST api/app/feedback" parameters:@{@"content": _textView.text} success:^(NSInteger statusCode, id response) {
        KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
        [hud applySuccessStyle];
        [hud hideAnimated:YES afterDelay:1];
        [hud setHiddenBlock:^(KDProgressHUD *hud) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

- (void)keyboardWillShow:(NSNotification *)aNotification {
    [self moveTextViewForKeyboard:aNotification up:YES];
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    [self moveTextViewForKeyboard:aNotification up:NO];
}

- (void) moveTextViewForKeyboard:(NSNotification*)aNotification up: (BOOL) up {
    NSDictionary* userInfo = [aNotification userInfo];
    
    // Get animation info from userInfo
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [userInfo[UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [userInfo[UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [userInfo[UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    // Animate up or down
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    if (up) {
        _bottomMargin.constant = keyboardEndFrame.size.height;
    } else {
        _bottomMargin.constant = 0;
    }
    
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
}

@end
