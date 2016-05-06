//
//  NotiDetailViewController.m
//  myOffer
//
//  Created by xuewuguojie on 15/12/30.
//  Copyright © 2015年 UVIC. All rights reserved.
//
#import "DetailWebViewController.h"
#import "ApplyStatusViewController.h"

@interface DetailWebViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *Web;
@property(nonatomic,strong)KDProgressHUD *progress;
@property(nonatomic,strong)UIImageView *navImageView;

@end

@implementation DetailWebViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
     [MobClick beginLogPageView:[self page]];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [MobClick endLogPageView:[self page]];
    
}

- (NSString *)page
{
   
    NSString *page;
    
    if (self.path) {
    
        page = @"page协议";

    
    }else if(self.notiID)
    {
        page = @"page通知详情";
        self.title =   GDLocalizedString(@"Left-message");
        
    }else{
        
        self.title = GDLocalizedString(@"Left-help");
        page = @"page帮助详情";

    }
    return page;
    
}

- (void)makeUI
{
    
     if (self.navigationBgImage) {
        self.navImageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, -64, XScreenWidth, 64)];
        self.navImageView.clipsToBounds = YES;
        self.navImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.navImageView.image = self.navigationBgImage;
        [self.view addSubview:self.navImageView];
    }
    
    self.Web =[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, APPSIZE.width, APPSIZE.height - 64)];
    self.Web.backgroundColor = BACKGROUDCOLOR;
    self.Web.delegate = self;
    [self.view addSubview:self.Web];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
     
    [self makeUI];
    
    if (self.notiID) {
        
        NSString *path = [NSString stringWithFormat:@"http://www.myoffer.cn/account/message/%@?client=app",self.notiID];
        NSURL    *url =[NSURL URLWithString:path];
        NSMutableURLRequest *request =[[NSMutableURLRequest alloc] initWithURL:url];
        [request addValue:[[AppDelegate sharedDelegate] accessToken] forHTTPHeaderField:@"apikey"];
        NSString *lan = !USER_EN ? @"":@"en";
        [request addValue:lan forHTTPHeaderField:@"user-language"];
        [self.Web loadRequest:request];

        
    }else if(self.path){
    
        [self.Web loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.path]]];
        
    }else{
       
        NSString *urlPath =[NSString stringWithFormat:@"http://www.myoffer.cn/faq#index=%ld",(long)self.index];
        [self.Web loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlPath]]];

     }
    
    
    
}
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
  
     NSString *pathURL = request.URL.absoluteString;
     if ([pathURL containsString:@"jump/0"]) {
         ApplyStatusViewController *status =[[ApplyStatusViewController alloc] init];
        [self.navigationController pushViewController:status animated:YES];
        
    }
    
    return YES;
}



- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    
    [self.progress hideAnimated:YES];
    KDProgressHUD *xhud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
    xhud.labelText = @"加载失败";
    [xhud hideAnimated:YES afterDelay:1];
    [xhud removeFromSuperViewOnHide];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
