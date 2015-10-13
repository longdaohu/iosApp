//
//  AgreementViewController.m
//  MyOffer
//
//  Created by Blankwonder on 6/22/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import "AgreementViewController.h"

@interface AgreementViewController ()

@end

@implementation AgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.myoffer.cn/docs/zh-cn/web-agreement.html"]]];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
}

- (void)cancel {
    self.dismissCompletion = nil;
    [self dismiss];
}

@end
