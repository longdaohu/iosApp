//
//  HelpDetailViewController.m
//  myOffer
//
//  Created by xuewuguojie on 15/11/25.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "HelpDetailViewController.h"

@interface HelpDetailViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *helpWebView;
@property(nonatomic,strong)  KDProgressHUD *hud;
@end

@implementation HelpDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = GDLocalizedString(@"Left-help");
    NSString *path = [NSString stringWithFormat:@"http://www.myoffer.cn/faq#index=%ld",(long)self.index];
    NSURL *url =[NSURL URLWithString:path];
    NSURLRequest *requestx =[[NSURLRequest alloc] initWithURL:url];
    [self.helpWebView loadRequest:requestx];
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
    self.hud = hud;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{

    [self.hud hideAnimated:YES];
    [self.hud  removeFromSuperViewOnHide];


}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
     [self.hud hideAnimated:YES];
      KDProgressHUD *xhud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
      xhud.labelText = @"加载失败";
     [xhud hideAnimated:YES afterDelay:2];
     [xhud removeFromSuperViewOnHide];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
