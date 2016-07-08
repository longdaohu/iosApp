//
//  AdvertiseViewController.m
//  myOffer
//
//  Created by xuewuguojie on 16/4/14.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "AdvertiseViewController.h"
#import <WebKit/WebKit.h>
#import "NewSearchResultViewController.h"
#import "XLiuxueViewController.h"
#import "InteProfileViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface AdvertiseViewController ()<UIWebViewDelegate,WKNavigationDelegate>
@property(nonatomic,strong)KDProgressHUD *hud;
@property(nonatomic,strong)WKWebView *web_wk;
@property(nonatomic,strong)NSString  *URLpath;
@property(nonatomic,strong)JSContext *context;
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

    self.title = self.path ? @"" :self.advertise_title;
    self.web_wk = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0,XScreenWidth, XScreenHeight - 64)];
    self.URLpath =self.path ? self.path : [NSString stringWithFormat:@"%@",self.StatusBarBannerNews.message_url];
    [self.web_wk loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.URLpath]]];
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
    
//    JSContext *context=[webView  valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
//    self.context = context;
//    
//    self.context[@"showLogin"] = ^() {
//        //这里 获取程序中的登录状态
//    //   BOOL needLogin = [ApplicationDelegate showLoginToBackHere];
//
//    };
    
    
    [self.hud hideAnimated:YES];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
    [KDAlertView showMessage:GDLocalizedString(@"NetRequest-connectError") cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];
    [self.hud hideAnimated:YES];
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    
    
     NSString *absoluteString = navigationAction.request.URL.absoluteString;
    
    if ([absoluteString hasSuffix:@"/evaluate"]) {
        
        [self.navigationController pushViewController:[[InteProfileViewController alloc] init] animated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
  
    }else if([absoluteString hasSuffix:@"/rank"]){
        
        
            NSString *country = [self.URLpath hasSuffix:@"au"] ? @"澳大利亚":@"英国";
        
           if([self.URLpath hasSuffix:@"au"])
           {
               NewSearchResultViewController *newVc = [[NewSearchResultViewController alloc] initWithFilter:@"country" value:country orderBy:RANKTI];
               newVc.title  = country;
               [self.navigationController pushViewController:newVc animated:YES];
               
           }else{
           
               SearchResultViewController *vc = [[SearchResultViewController alloc] initWithFilter:@"country" value:country orderBy:RANKTI];
                vc.title  =  country;
               [self.navigationController pushViewController:vc animated:YES];
           }

        decisionHandler(WKNavigationActionPolicyCancel);

    }else if([absoluteString hasSuffix:@"/intention"]){
        
        [self.navigationController pushViewController:[[XLiuxueViewController alloc] init] animated:YES];

        decisionHandler(WKNavigationActionPolicyCancel);
    
    }else{
        
         decisionHandler(WKNavigationActionPolicyAllow);
    }
    
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
