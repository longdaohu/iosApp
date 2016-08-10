//
//  SeviceDetailViewController.m
//  myOffer
//
//  Created by xuewuguojie on 16/6/24.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "SeviceDetailViewController.h"
#import "PayOrderViewController.h"
#import "OrderItem.h"
#import "ApplyStatusViewController.h"

@interface SeviceDetailViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *Web;
@end

@implementation SeviceDetailViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"page服务套餐详情"];
    
}



-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"page订单套餐详情"];
    
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
    
    self.title = @"服务详情";
    self.Web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0,XScreenWidth, XScreenHeight - 64)];
    [self.view addSubview:self.Web];
    self.Web.delegate = self;
    
    NSURL    *url =[NSURL URLWithString:self.path];
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc] initWithURL:url];
    [request addValue:[[AppDelegate sharedDelegate] accessToken] forHTTPHeaderField:@"apikey"];
    NSString *lan = !USER_EN ? @"":@"en";
    [request addValue:lan forHTTPHeaderField:@"user-language"];
    [self.Web loadRequest:request];
    
    
    
    if (self.isBackRootViewController) {
         self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(pushApplyStatus)];
    }
    
}

#pragma mark ——————  WKWebViewDeleage
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //重写网页方法，监听网页链接
    
    NSString *jumpF = @"window.app = {jump: function (args) {window.location = 'app:jump/' + args;}};";
    [webView stringByEvaluatingJavaScriptFromString:jumpF];
    
    
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    
    NSString *absoluteString = request.URL.absoluteString;
    
//    NSLog(@"------------- %@",absoluteString);
    if ([absoluteString containsString:@"app:jump"]) {
        
         NSArray *items =[absoluteString  componentsSeparatedByString:@"+"];
        
         NSString *path =[NSString stringWithFormat:@"GET api/account/order/create?sku_id=%@",items[1]];//573e72480a86a4c34aa36b5e
        
        [self startAPIRequestWithSelector:path parameters:nil success:^(NSInteger statusCode, id response) {
         
            PayOrderViewController *pay =[[PayOrderViewController alloc] init];
            pay.order = [OrderItem orderWithDictionary:response[@"order"]];
            [self.navigationController pushViewController:pay animated:YES];
            
        }];
    }

    
    if ([absoluteString containsString:@"account/register"]) {
        
        [[AppDelegate sharedDelegate] presentLoginAndRegisterViewControllerAnimated:YES];
        
        return NO;
    }
    
    return YES;
}



- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
 
    
}

//返回
-(void)pushApplyStatus{
    
    ApplyStatusViewController *ApplyStatus = [[ApplyStatusViewController alloc] init];
    ApplyStatus.isBackRootViewController   = YES;
    [self.navigationController pushViewController:ApplyStatus animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(void)dealloc{
    
    NSLog(@"SeviceDetailViewController dealloc");
}


@end
