//
//  ServiceMallViewController.m
//  myOffer
//
//  Created by xuewuguojie on 16/6/21.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "ServiceMallViewController.h"
#import <WebKit/WebKit.h>
#import <sys/utsname.h>
#import "PayOrderViewController.h"
#import "OrderItem.h"
#import "SeviceDetailViewController.h"

@interface ServiceMallViewController ()<UIWebViewDelegate,WKNavigationDelegate>
@property(nonatomic,strong)KDProgressHUD *progress;
@property(nonatomic,strong)UIWebView *Web;


@end

@implementation ServiceMallViewController


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"page订单列表"];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [MobClick beginLogPageView:@"page订单列表"];

    if (self.refresh) {
        
        [self.Web reload];
    }
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
    
    self.title = @"留学服务";
    self.Web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0,XScreenWidth, XScreenHeight - 64)];
    [self.view addSubview:self.Web];
    self.Web.delegate = self;
    
    NSString *path =[NSString stringWithFormat:@"%@service.html/",DOMAINURL];

    NSURL    *url =[NSURL URLWithString:path];
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc] initWithURL:url];
    [request addValue:[[AppDelegate sharedDelegate] accessToken] forHTTPHeaderField:@"apikey"];


    [self.Web loadRequest:request];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark ——————  WKWebViewDeleage
- (void)webViewDidStartLoad:(UIWebView *)webView
{
     self.progress = [KDProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.progress setRemoveFromSuperViewOnHide:YES];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //重写网页方法，监听网页链接
    
     NSString *jumpF = @"window.app = {jump: function (args) {window.location = 'app:jump/' + args;}};";
    [webView stringByEvaluatingJavaScriptFromString:jumpF];
    
    [self.progress hideAnimated:YES];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
   
 
    
    NSString *absoluteString = request.URL.absoluteString;
    
    
    if ([absoluteString containsString:@"app:jump"]) {
        
        NSArray *items =[absoluteString  componentsSeparatedByString:@"+"];
        
        NSString *path =[NSString stringWithFormat:@"GET api/account/order/create?sku_id=%@",items[1]];//573e72480a86a4c34aa36b5e
        
        [self startAPIRequestWithSelector:path parameters:nil success:^(NSInteger statusCode, id response) {
            
            PayOrderViewController *pay =[[PayOrderViewController alloc] init];
            pay.order = [OrderItem orderWithDictionary:response[@"order"]];
            [self.navigationController pushViewController:pay animated:YES];
        }];
 
    }
    
    
    if ([absoluteString containsString:@"service_dtl"]) {
        
        SeviceDetailViewController *detail =[[SeviceDetailViewController alloc] init];
        detail.path = absoluteString;
        [self.navigationController pushViewController:detail animated:YES];
      
        
        return NO;
    }
    
    
    if ([absoluteString containsString:@"account/register"]) {
        
        [[AppDelegate sharedDelegate] presentLoginAndRegisterViewControllerAnimated:YES];
        
        return NO;
    }
    
    
    return YES;
}



- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    
    [self.progress hideAnimated:YES];
//    KDProgressHUD *failHud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
//    failHud.labelText = @"加载失败";
//    [failHud hideAnimated:YES afterDelay:1];
//    [failHud removeFromSuperViewOnHide];

}


-(void)dealloc{

    KDClassLog(@"ServiceMallViewController  dealloc");
}


@end






