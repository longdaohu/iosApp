//
//  UniversityMapsViewController.m
//  MyOffer
//
//  Created by sara on 15/10/7.
//  Copyright © 2015年 UVIC. All rights reserved.
//  

#import "UniversityMapsViewController.h"

@interface UniversityMapsViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *bingMap;
@property(nonatomic,strong)KDProgressHUD *hud;
@end

@implementation UniversityMapsViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [MobClick beginLogPageView:@"page地图"];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page地图"];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    self.title =self.UniversityInfoDic[@"name"];
    NSString *path =[[NSBundle mainBundle] pathForResource:@"mapShow.html" ofType:nil];
    NSURL    *url =[NSURL URLWithString:path];
    NSURLRequest *requestx =[[NSURLRequest alloc] initWithURL:url];
    [self.bingMap loadRequest:requestx];
    self.bingMap.delegate = self;
    
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
 
    self.hud = [KDProgressHUD showHUDAddedTo:self.view animated:YES];

}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString  *location = self.UniversityInfoDic[@"map_location"];
    NSArray   *locationArray = [location componentsSeparatedByString:@","];
    NSString  *LocalTitle = self.UniversityInfoDic[@"name"];
    NSString  *LocalSubtitle = self.UniversityInfoDic[@"official_name"];
    NSString  *position = [NSString stringWithFormat:@"position:relative; width:%lfpx; height:%lfpx;",APPSIZE.width,APPSIZE.height];
    NSString  *excutString = [NSString stringWithFormat:@"getMap(%lf,%lf,'%@','%@','%@');", [locationArray.firstObject doubleValue], [locationArray.lastObject doubleValue],LocalTitle,LocalSubtitle,position];
    
    [webView stringByEvaluatingJavaScriptFromString:excutString];
    
    
    if (!webView.isLoading) {
        
        [self.hud hideAnimated:YES afterDelay:1];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end



