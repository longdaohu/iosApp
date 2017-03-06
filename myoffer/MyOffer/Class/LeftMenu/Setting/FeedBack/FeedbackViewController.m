//
//  FeedbackViewController.m
//  MyOffer
//
//  Created by Blankwonder on 6/24/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()<UITextViewDelegate> {
    
    IBOutlet NSLayoutConstraint *_bottomMargin;
    
}
@property (weak, nonatomic) IBOutlet KDEasyTouchButton *sendButton;
@property (weak, nonatomic) IBOutlet UITextView *reponseView;
@property (weak, nonatomic) IBOutlet UILabel *placeHoderLab;

@end

@implementation FeedbackViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page反馈"];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [MobClick beginLogPageView:@"page反馈"];

}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.reponseView becomeFirstResponder];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self makeUI];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
-(void)makeUI
{
    self.title = GDLocalizedString(@"Setting-003");//@"用户反馈";
  
    [self.sendButton setTitle:GDLocalizedString(@"FeedBack-002") forState:UIControlStateNormal];
 
}


- (IBAction)send {
    
    [self startAPIRequestWithSelector:kAPISelectorFeedback parameters:@{@"content": self.reponseView.text} success:^(NSInteger statusCode, id response) {
     
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
    
    _bottomMargin.constant = up ? keyboardEndFrame.size.height : 0;
    
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
}

KDUtilRemoveNotificationCenterObserverDealloc

- (void)textViewDidChange:(UITextView *)textView{

    
    self.placeHoderLab.hidden = textView.text.length > 0;
    
    if (textView.text.length > 300) {
        
        textView.text = [textView.text substringWithRange:NSMakeRange(0, 300)];
        
        AlerMessage(@"反馈意见长度不超过300个字！");
    }
 
}



@end
