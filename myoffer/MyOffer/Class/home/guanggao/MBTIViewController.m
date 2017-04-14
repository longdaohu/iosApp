//
//  MBTIViewController.m
//  myOffer
//
//  Created by xuewuguojie on 16/10/9.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "MBTIViewController.h"
#import "WYLXViewController.h"
#import "PipeiEditViewController.h"
#import "AUSearchResultViewController.h"
#import "NotificationViewController.h"
#import "XNewSearchViewController.h"
#import "ApplyStatusViewController.h"
#import "UniversityViewController.h"
#import "WebViewController.h"
#import "MyOfferServerMallViewController.h"

@interface MBTIViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *web;

@end

@implementation MBTIViewController

- (instancetype)initWithPath:(NSString *)path{

    self = [super init];
    
    if (self) {
        
        self.path = path;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self makeUI];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page性格测试"];

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"page性格测试"];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}


-(void)makeUI
{
    
    self.title = @"MBTI职业性格测试";
    
    NSString *bundleName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    bundleName = [bundleName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSString *version = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    NSString *userAgent = [NSString stringWithFormat:@"%@%@",bundleName,version];
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:userAgent forKey:@"UserAgent"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:parameter];
    
    
//    NSString *path = @"http://www.apesk.com/h/go_zy_dingzhi_m.asp?checkcode=PR9RZP86L1IC9HT4IA&hruserid=18201123448&l=MBTI-STEP-I-28&test_name=sha&test_email=sha";
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.path]];
    [request addValue:[[AppDelegate sharedDelegate] accessToken] forHTTPHeaderField:@"apikey"];
    self.web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0,XSCREEN_WIDTH, XSCREEN_HEIGHT - XNAV_HEIGHT)];
    
    [self.web loadRequest:request];
    [self.view addSubview:self.web];
    self.web.delegate = self;

    
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
//    self.progress = [KDProgressHUD showHUDAddedTo:self.view animated:YES];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //重写网页方法，监听网页链接
//    NSString *jumpF = @"window.app = {appJump: function (args) {window.location = 'app:appJump/' + args;}};";
//    
//    [webView stringByEvaluatingJavaScriptFromString:jumpF];
//    
//    if (!webView.isLoading) {
//        
//        [self.progress hideAnimated:YES afterDelay:0.5];
//    }
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    
    
    NSString *absoluteString = request.URL.absoluteString;
    
    NSInteger pageNumber = DEFAULT_NUMBER;
    if ([absoluteString containsString:@"app:appJump"]) {
        pageNumber = 0; //ok
    }else if ([absoluteString containsString:@"/evaluate"]){
        pageNumber = 1; //OK   智能匹配
    }else if([absoluteString containsString:@"/rank"]){
        pageNumber = 2; //OK   英澳排名
    }else if([absoluteString containsString:@"/intention"]){
        pageNumber = 3; //OK   留学咨询
    }else if([absoluteString hasSuffix:@"recommend?major"]){
        pageNumber = 4; //OK   留学咨询
    }else  if ([absoluteString containsString:@"recommend?major="]  || [absoluteString containsString:@"mbti/recommend"]|| [absoluteString containsString:@"mbti1_report_hr.asp"] ) {
        pageNumber = 5;  //Ok
    }else if([absoluteString containsString:@"jump/0"]) {
        pageNumber = 6;
    }else if([absoluteString containsString:@"/university/"]) {
        pageNumber = 7;
    }else if([absoluteString containsString:@"service.html"]) {
        pageNumber = 8;
    }else if([absoluteString containsString:@"www.apesk.com"]) {
        pageNumber = 9;
   
    }else{
    
        if (request.allHTTPHeaderFields[@"apikey"].length == 0) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSURL *url = [request URL];
                    
                    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
                    // set the new headers
                    [request addValue:[[AppDelegate sharedDelegate] accessToken] forHTTPHeaderField:@"apikey"];
                    
                    [self.web loadRequest:request];
                });
            });

            return NO;
        }
      }
    
    switch (pageNumber) {
            
        case 0:{
            
            NSString *pathURL = [absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *jump_str =[pathURL stringByReplacingOccurrencesOfString:@"app:appJump/" withString:@""];
            NSData *JSONData = [jump_str dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
            [self pageWithResponse:responseJSON];
            
            return NO;
        }
            break;
            
        case 1:{
            [self caseZhiNenPipei];
            
            return NO;
        }
            break;
            
        case 2:{
            NSString *country = [self.path hasSuffix:@"au"] ? @"澳大利亚":@"英国";
            
            if([self.path hasSuffix:@"au"])
            {
                [self AUWithCountryType:country];
                
            }else{
                
                [self UKWithCountryType:country orderBy:RANK_TI];
            }
            
            return NO;
        }
            break;
        case 3:{
            
            [self caseWoyaoluxue];
            
            return NO;
        }
            break;
        case 4:
        {
            [self caseWoyaoluxue];
            
            return NO;
        }
            break;
        case 5:{
            
            NSString *apiValue  = request.allHTTPHeaderFields[@"apikey"];
            
            if (apiValue.length == 0) {
                
                //                NSMutableURLRequest *request = [navigationAction.request mutableCopy];
                //                [request addValue:[[AppDelegate sharedDelegate] accessToken] forHTTPHeaderField:@"apikey"];
                
                [self.navigationController pushViewController:[[WebViewController alloc] initWithPath:absoluteString] animated:YES];
                
                return NO;
                
                //                [webView loadRequest:request];
                
            }else{
                
                return YES;
                
            }
        }
            break;
        case 6:
        {
            
            [self.navigationController pushViewController:[[ApplyStatusViewController alloc] init] animated:YES];
      
            return NO;
        }
            break;
        case 7:
        {
            NSRange UniRagne = [absoluteString rangeOfString:@"university/"];
            NSString *lastPath =[absoluteString substringWithRange:NSMakeRange((UniRagne.location + UniRagne.length), absoluteString.length - (UniRagne.location + UniRagne.length))];
            NSArray *contents = [lastPath componentsSeparatedByString:@"."];
            
            [self caseUniversityWithshortId:contents[0]];
            
            return NO;
        }
            break;
        case 8:
        {
            
            //            [self.navigationController pushViewController:[[ServiceMallViewController alloc] init] animated:YES];
            return NO;
        }
            break;
        case 9:
        {
          
            return YES;
        }
            break;
        default:
            return YES;
            break;
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

//院校排名
-(void)caseUniversityList:(NSDictionary *)response{
    
    NSDictionary  *dict =  response[@"args"];
    
    if([dict[@"state"] containsString:@"au"])
    {
        [self AUWithCountryType:@"澳大利亚"];
        
    }else if([dict[@"state"] containsString:@"uk"]){
        
        [self UKWithCountryType:@"英国" orderBy:RANK_TI];
        
    }else{
        
        [self UKWithCountryType:@"QS世界排名" orderBy:RANK_QS];
    }
}
-(void)UKWithCountryType:(NSString *)country orderBy:(NSString *)rankType{
    SearchResultViewController *vc = [[SearchResultViewController alloc] initWithFilter:@"country" value:country orderBy:rankType];
    vc.title  = [country isEqualToString:@"英国"]?[NSString stringWithFormat:@"%@大学排名",country] : country;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)AUWithCountryType:(NSString *)country{
    
    AUSearchResultViewController *newVc = [[AUSearchResultViewController alloc] initWithFilter:@"country" value:country orderBy:RANK_TI];
    newVc.title  = [NSString stringWithFormat:@"%@大学排名",country];
    [self.navigationController pushViewController:newVc animated:YES];
    
}

//智能匹配 \ 测试成功率
-(void)caseZhiNenPipei{
    
    RequireLogin
    
    [self.navigationController pushViewController:[[PipeiEditViewController alloc] init] animated:YES];
}

//推荐专业
-(void)caseSubjectPage{
    
    
}

//客服
-(void)caseQQserver{
    
    
}

//我要留学
-(void)caseWoyaoluxue{
    [self.navigationController pushViewController:[[WYLXViewController alloc] init] animated:YES];
}
//购买服务
-(void)casePay{
    
    [self.navigationController pushViewController:[[MyOfferServerMallViewController alloc] init] animated:YES];
}
//通知
-(void)caseNotication{
    
    [self.navigationController pushViewController:[[NotificationViewController alloc] init] animated:YES];
}
//学校详情
-(void)caseUniversityWithdict:(NSDictionary *)response{
    
    NSDictionary *dict =  response[@"args"];
    
    
    [self caseUniversityWithshortId: dict[@"id"]];
    
}
//学校详情
-(void)caseUniversityWithshortId:(NSString *)Uni_id{
    
    [self.navigationController pushUniversityViewControllerWithID:Uni_id animated:YES];
    
}
//搜索结果
-(void)caseSearchUniversityWithdict:(NSDictionary *)response{
    
    NSDictionary *dict =  response[@"args"];
    XNewSearchViewController *vc = [[XNewSearchViewController alloc] initWithSearchText:dict[@"search"] orderBy:RANK_QS];
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
    KDClassLog(@"MBTIViewController 性格测试网页  dealloc");   //可以释放
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
