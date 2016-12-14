//
//  FeedbackViewController.m
//  MyOffer
//
//  Created by Blankwonder on 6/24/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet KDEasyTouchButton *sendButton;

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
    
    [_textView becomeFirstResponder];
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
    self.sendButton.layer.cornerRadius = 5;
    self.sendButton.layer.masksToBounds = YES;
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, XSCREEN_WIDTH -20, XSCREEN_HEIGHT - 414)];
    self.textView.layer.cornerRadius = 5;
    self.textView.layer.borderWidth = 1;
    self.textView.layer.borderColor = XCOLOR_LIGHTGRAY.CGColor;
    self.textView.layer.masksToBounds = YES;
    self.textView.font =[UIFont systemFontOfSize:15];
    [self.view addSubview:self.textView];
    self.textView.delegate = self;
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

KDUtilRemoveNotificationCenterObserverDealloc


- (void)textViewDidChange:(UITextView *)textView{

    if (textView.text.length > 300) {
        
        textView.text = [textView.text substringWithRange:NSMakeRange(0, 300)];
        
        AlerMessage(@"反馈意见长度不超过300个字！");
    }
 
}
@end
