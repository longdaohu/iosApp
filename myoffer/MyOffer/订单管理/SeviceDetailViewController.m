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


@interface SeviceDetailViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *Web;
@end

@implementation SeviceDetailViewController




- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];

}

-(void)makeUI
{
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(void)dealloc{
    
    NSLog(@"SeviceDetailViewController dealloc");
}


@end
