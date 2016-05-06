//
//  AdvertiseViewController.m
//  myOffer
//
//  Created by xuewuguojie on 16/4/14.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "AdvertiseViewController.h"
#import <WebKit/WebKit.h>

@interface AdvertiseViewController ()<UIWebViewDelegate,WKNavigationDelegate>
@property(nonatomic,strong)UIWebView *web;
@property(nonatomic,strong)KDProgressHUD *hud;
@property(nonatomic,strong)WKWebView *web_wk;

@end

@implementation AdvertiseViewController


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSString *page = self.path ? @"page查看协议":@"page广告";
    
    [MobClick endLogPageView:page];
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    NSString *page = self.path ? @"page查看协议":@"page广告";

    [MobClick beginLogPageView:page];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.path ?@"" :self.advertise_title;
    
    self.web_wk = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0,XScreenWidth, XScreenHeight - 64)];
    NSString *RequestString =self.path ? self.path : [NSString stringWithFormat:@"%@",self.StatusBarBannerNews.message_url];
    [self.web_wk loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:RequestString]]];
    [self.web_wk sizeToFit];

    [self.view addSubview:self.web_wk];
    self.web_wk.navigationDelegate = self;
    
}


#pragma mark ——————  WKWebViewDeleage
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    self.hud = [KDProgressHUD showHUDAddedTo:self.view animated:YES];
     [self.hud removeFromSuperViewOnHide];
    
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self.hud hideAnimated:YES afterDelay:0.1];

}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
    [KDAlertView showMessage:GDLocalizedString(@"NetRequest-connectError") cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];
    [self.hud hideAnimated:YES afterDelay:0.1];
    
}

-(void)dealloc
{

    KDClassLog(@"----AdvertiseViewController------dealloc----");

}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


@end
