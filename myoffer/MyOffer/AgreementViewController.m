//
//  AgreementViewController.m
//  MyOffer
//
//  Created by Blankwonder on 6/22/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import "AgreementViewController.h"

@interface AgreementViewController ()
@property (weak, nonatomic) IBOutlet KDEasyTouchButton *commitBtn;

@end

@implementation AgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
 
    [self.commitBtn setTitle:GDLocalizedString(@"Potocol-Commit") forState:UIControlStateNormal]; //同意按钮
    NSString *RequestString = [NSString stringWithFormat:@"http://www.myoffer.cn/docs/%@/web-agreement.html",GDLocalizedString(@"ch_Language")];//zh-cn
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:RequestString]]];
    //取消按钮
   UIBarButtonItem *leftButton =[[UIBarButtonItem alloc] initWithTitle:GDLocalizedString(@"Potocol-Cancel") style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = leftButton;
}

- (void)cancel {
    self.dismissCompletion = nil;
    [self dismiss];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}


@end
