//
//  AdvertiseViewController.m
//  myOffer
//
//  Created by xuewuguojie on 16/4/14.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>
#import "AdvertiseViewController.h"
#import "XLiuxueViewController.h"
#import "InteProfileViewController.h"
#import "NewLoginRegisterViewController.h"
#import "NewSearchResultViewController.h"
#import "XLiuxueViewController.h"
#import "ServiceMallViewController.h"
#import "NotificationViewController.h"
#import "UniversityViewController.h"
#import "XNewSearchViewController.h"


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

    [self makeUI];
}

-(void)makeUI
{
    
    NSString *bundleName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    bundleName = [bundleName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSString *version = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    NSString *userAgent = [NSString stringWithFormat:@"%@%@",bundleName,version];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:userAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    
    self.title = self.path ? @"" :self.advertise_title;
    self.web_wk = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0,XScreenWidth, XScreenHeight - 64)];
    self.URLpath =self.path ? self.path : [NSString stringWithFormat:@"%@",self.StatusBarBannerNews.message_url];
//        self.URLpath = @"http://www.myofferdemo.com/demo/appJump";
//        self.URLpath = @"http://www.myofferdemo.com/superMentor.html";
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.URLpath]];
    [request addValue:[[AppDelegate sharedDelegate] accessToken] forHTTPHeaderField:@"apikey"];
    [self.web_wk loadRequest:request];
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
    [self.hud hideAnimated:YES];
     NSString *jumpF = @"window.app = {appJump: function (args) {window.location = 'app:appJump/' + args;}};";
    [webView evaluateJavaScript:jumpF completionHandler:nil];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
    [KDAlertView showMessage:GDLocalizedString(@"NetRequest-connectError") cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];
    [self.hud hideAnimated:YES];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    
     NSString *absoluteString = navigationAction.request.URL.absoluteString;
    
    if ([absoluteString containsString:@"app:appJump"]) {
        
        NSString *pathURL = [absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *temp =[pathURL stringByReplacingOccurrencesOfString:@"app:appJump/" withString:@""];
        NSData *JSONData = [temp dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
        [self pageWithResponse:responseJSON];
        decisionHandler(WKNavigationActionPolicyCancel);
        
    }else{
        
        if ([absoluteString hasSuffix:@"/evaluate"]) {
            
            [self caseZhiNenPipei];
            decisionHandler(WKNavigationActionPolicyCancel);
            
        }else if([absoluteString hasSuffix:@"/rank"]){
            
            NSString *country = [self.URLpath hasSuffix:@"au"] ? @"澳大利亚":@"英国";
            
            if([self.URLpath hasSuffix:@"au"])
            {
                [self AUWithCountryType:country];
                
            }else{
                
                [self UKWithCountryType:country orderBy:RANKTI];
              }
            
            decisionHandler(WKNavigationActionPolicyCancel);
            
        }else if([absoluteString hasSuffix:@"/intention"]){
            
            [self caseWoyaoluxue];
            
            decisionHandler(WKNavigationActionPolicyCancel);
            
        }else{
            
            decisionHandler(WKNavigationActionPolicyAllow);
        }
    }
}

-(void)pageWithResponse:(NSDictionary *)responseJSON{

    
    switch ([responseJSON[@"page"] integerValue]) {
        case 0:
            RequireLogin;
            break;
        case 1 : case 4:
            [self caseZhiNenPipei];
            break;
        case 2:
            [self caseUniversityList:responseJSON];
            break;
        case 3:
            [self caseQQserver];
            break;
        case 5:
            [self caseWoyaoluxue];
            break;
        case 6:
            [self casePay];
            break;
        case 7:
            [self caseNotication];
            break;
        case 8:
            [self caseUniversityWithdict:responseJSON];
            break;
        case 9:
            [self caseSearchUniversityWithdict:responseJSON];
            break;
        case 10:
            [self caseVedioWithdict:responseJSON];
            break;
        default:
            break;
    }
    
}

//智能匹配 \ 测试成功率
-(void)caseZhiNenPipei{
    
    [self.navigationController pushViewController:[[InteProfileViewController alloc] init] animated:YES];
}
//院校排名
-(void)caseUniversityList:(NSDictionary *)response{
    
    NSDictionary  *dict =  response[@"args"];
    
    if([dict[@"state"] containsString:@"au"])
    {
        [self AUWithCountryType:@"澳大利亚"];
        
    }else if([dict[@"state"] containsString:@"uk"]){
        
        [self UKWithCountryType:@"英国" orderBy:RANKTI];
    
    }else{
        
        [self UKWithCountryType:@"QS世界排名" orderBy:RANKQS];
    }
}
-(void)UKWithCountryType:(NSString *)country orderBy:(NSString *)rankType{
    SearchResultViewController *vc = [[SearchResultViewController alloc] initWithFilter:@"country" value:country orderBy:rankType];
    vc.title  = [country isEqualToString:@"英国"]?[NSString stringWithFormat:@"%@大学排名",country] : country;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)AUWithCountryType:(NSString *)country{
    
    NewSearchResultViewController *newVc = [[NewSearchResultViewController alloc] initWithFilter:@"country" value:country orderBy:RANKTI];
     newVc.title  = [NSString stringWithFormat:@"%@大学排名",country];
    [self.navigationController pushViewController:newVc animated:YES];
    
}

//客服
-(void)caseQQserver{
    
    
}

//我要留学
-(void)caseWoyaoluxue{
    [self.navigationController pushViewController:[[XLiuxueViewController alloc] init] animated:YES];
}
//购买服务
-(void)casePay{
    [self.navigationController pushViewController:[[ServiceMallViewController alloc] init] animated:YES];
}
//通知
-(void)caseNotication{
    [self.navigationController pushViewController:[[NotificationViewController alloc] init] animated:YES];
}
//学校详情
-(void)caseUniversityWithdict:(NSDictionary *)response{
   
    NSDictionary *dict =  response[@"args"];
    [self.navigationController pushUniversityViewControllerWithID:dict[@"id"] animated:YES];
    
}
//搜索结果
-(void)caseSearchUniversityWithdict:(NSDictionary *)response{
    
    NSDictionary *dict =  response[@"args"];
    XNewSearchViewController *vc = [[XNewSearchViewController alloc] initWithSearchText:dict[@"search"] orderBy:RANKQS];
    [self.navigationController pushViewController:vc animated:YES];
}
//查看YOUKU视频
-(void)caseVedioWithdict:(NSDictionary *)response{
  
     NSDictionary *dict =  response[@"args"];
     NSString *path = [dict[@"url"] length] > 0 ? dict[@"url"]: @"http://www.myoffer.cn/";
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:path]];
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
