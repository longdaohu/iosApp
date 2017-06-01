//
//  WebViewController.m
//  myOffer
//
//  Created by xuewuguojie on 16/9/18.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "WebViewController.h"
#import "WYLXViewController.h"
#import "PipeiEditViewController.h"
#import "AUSearchResultViewController.h"
#import "MyOfferServerMallViewController.h"
#import "NotificationViewController.h"
#import "SearchUniversityCenterViewController.h"
#import "ApplyStatusViewController.h"
#import "UniversityViewController.h"
#import "IntelligentResultViewController.h"


@interface WebViewController ()<WKNavigationDelegate,WKUIDelegate>
@property(nonatomic,strong)MBProgressHUD *hud;
@property(nonatomic,strong)WKWebView *web_wk;
//智能匹配数量
@property(nonatomic,assign)NSInteger recommendationsCount;
@end

@implementation WebViewController

- (instancetype)initWithPath:(NSString *)path{
    
    self = [super init];
    
    if (self) {
        
        self.path = path;
    }
    return self;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.hud hideAnimated:YES];
    
    [MobClick endLogPageView:[self page]];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:[self page]];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [self checkZhiNengPiPei];
    
}


- (NSString *)page
{
    NSString *page;
    if ([self.path containsString:@"aq#index="]) {
         self.title   = @"帮助中心";
         page = @"page帮助详情";
    }else  if ([self.path containsString:@"web-agreement.html"] || [self.path containsString:@"myoffer_License_Agreement"]) {
        page = @"page查看协议";
    }else  if ([self.path containsString:@"account/message/"] ) {
        page = @"page通知详情";
        self.title = @"通知详情";
    }else  if ([self.path containsString:@"mbti"] ) {
        page = @"page性格测试";
        self.title = @"MBTI职业性格测试";
    }else  if ([self.path containsString:@"superMentor.html"] ) {
        page = @"page超级导师";
    }else{
        page = @"landingPage";
    }
    
    return page;
    
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
    
    NSMutableURLRequest *request =[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.path]];
    [request addValue:[[AppDelegate sharedDelegate] accessToken] forHTTPHeaderField:@"apikey"];
    
    
    if([self.path containsString:@"agreement.html"]){
        
        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        wkWebConfig.userContentController = wkUController;
        self.web_wk = [[WKWebView alloc] initWithFrame:CGRectMake(0,0,XSCREEN_WIDTH,XSCREEN_HEIGHT - XNAV_HEIGHT) configuration:wkWebConfig];
        
    }else{
        
        self.web_wk = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0,XSCREEN_WIDTH, XSCREEN_HEIGHT - XNAV_HEIGHT)];
    }
    
    [self.web_wk loadRequest:request];
    [self.view addSubview:self.web_wk];
    self.web_wk.navigationDelegate = self;
    self.web_wk.allowsBackForwardNavigationGestures = YES;
    
    //监听网页加载进度
    [self.web_wk addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
    
}

- (void)setWebRect:(CGRect)webRect{

    _webRect = webRect;
    
    self.web_wk.frame = webRect;
}


#pragma mark ；  WKWebViewDeleage
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
   self.hud = [MBProgressHUD showMessage:nil toView:self.view];
 
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    
     NSString *jumpF = [self.path containsString:@"account/message/"] ?  @"window.app = {jump: function (args) {window.location = 'app:jump/' + args;}};" : @"window.app = {appJump: function (args) {window.location = 'app:appJump/' + args;}};";
    [webView evaluateJavaScript:jumpF completionHandler:nil];
    
    
    [self.hud hideAnimated:YES];
 
}


- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
    [KDAlertView showMessage:GDLocalizedString(@"NetRequest-connectError") cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];
  
    [self.hud hideAnimated:YES];
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    
    NSString *absoluteString = navigationAction.request.URL.absoluteString;
    
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
        pageNumber = 5;  //Ok   WebViewController
    }else if([absoluteString containsString:@"jump/0"]) {
        pageNumber = 6;  //    申请状态
    }else if([absoluteString containsString:@"/university/"]) {
        pageNumber = 7;  //     学校详情
    }else if([absoluteString containsString:@"service.html"] || [absoluteString containsString:@"emall/index.html"]) {
        pageNumber = 8;  //服务商城
    }else if([absoluteString isEqualToString:@"http://www.myoffer.cn/"]){
        pageNumber = 9;
    }else if(![absoluteString containsString:@"http://www.myoffer.cn"] && ![absoluteString containsString:@"www.sojump.hk"]){
        pageNumber = 10;
    }
    
    switch (pageNumber) {
            
        case 0:{
            NSString *pathURL = [absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *jump_str =[pathURL stringByReplacingOccurrencesOfString:@"app:appJump/" withString:@""];
            NSData *JSONData = [jump_str dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
            [self pageWithResponse:responseJSON];
            decisionHandler(WKNavigationActionPolicyCancel);
        }
            break;
            
        case 1:{
            [self caseZhiNenPipei];
            decisionHandler(WKNavigationActionPolicyCancel);
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

            decisionHandler(WKNavigationActionPolicyCancel);
        }
            break;
        case 3:{
        
            [self caseWoyaoluxue];
            
            decisionHandler(WKNavigationActionPolicyCancel);
        }
            break;
        case 4:
        {
            [self caseWoyaoluxue];
            
            decisionHandler(WKNavigationActionPolicyCancel);
        }
            break;
        case 5:{
        
            NSDictionary *header =  navigationAction.request.allHTTPHeaderFields;
            NSString *apiValue  = [header valueForKey:@"apikey"];
            
            if (apiValue.length == 0) {
                
//                NSMutableURLRequest *request = [navigationAction.request mutableCopy];
//                [request addValue:[[AppDelegate sharedDelegate] accessToken] forHTTPHeaderField:@"apikey"];
                
                WebViewController *webPage = [[WebViewController alloc] init];
                 webPage.path = absoluteString;
                [self.navigationController pushViewController:webPage animated:YES];
                
                decisionHandler(WKNavigationActionPolicyCancel);
                
//                [webView loadRequest:request];
                
            }else{
                
                decisionHandler(WKNavigationActionPolicyAllow);
                
            }
        }
            break;
            case 6:
        {
            
               [self.navigationController pushViewController:[[ApplyStatusViewController alloc] init] animated:YES];
                decisionHandler(WKNavigationActionPolicyCancel);
         }
            break;
        case 7:
        {
            NSRange UniRagne = [absoluteString rangeOfString:@"university/"];
            NSString *lastPath =[absoluteString substringWithRange:NSMakeRange((UniRagne.location + UniRagne.length), absoluteString.length - (UniRagne.location + UniRagne.length))];
            NSArray *contents = [lastPath componentsSeparatedByString:@"."];
            
            [self caseUniversityWithshortId:contents[0]];
            
            decisionHandler(WKNavigationActionPolicyCancel);
        }
            break;
        case 8:
        {
           
            [self.navigationController pushViewController:[[MyOfferServerMallViewController alloc] init] animated:YES];
            decisionHandler(WKNavigationActionPolicyCancel);
        }
            break;
        case 9:
            decisionHandler(WKNavigationActionPolicyCancel);
            break;
        case 10:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:absoluteString]];
            decisionHandler(WKNavigationActionPolicyCancel);

        }
            break;
       default:
            decisionHandler(WKNavigationActionPolicyAllow);
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


//判断是否有智能匹配数据或收藏学校
-(void)checkZhiNengPiPei
{
    if (LOGIN) {
        
        XWeakSelf
        [self startAPIRequestWithSelector:kAPISelectorZiZengPipeiGet  parameters:nil success:^(NSInteger statusCode, id response) {
            weakSelf.recommendationsCount = response[@"university"] ? 1 : 0;
        }];
    }
}


//智能匹配 \ 测试成功率
-(void)caseZhiNenPipei{
    
    if (!LOGIN) {
        
        self.recommendationsCount = 0;
    }
    
    
    if (self.recommendationsCount > 0) {
        
        RequireLogin
        
        [self.navigationController pushViewController:[[IntelligentResultViewController alloc] init]   animated:YES];
        
    }else{
        
        [self.navigationController pushViewController:[[PipeiEditViewController alloc] init]   animated:YES];
        
    }

}

//推荐专业
-(void)caseSubjectPage{
    
    
}

//客服
-(void)caseQQserver{
    
    
}

//我要留学
-(void)caseWoyaoluxue{
    
    [self presentViewController:[[WYLXViewController alloc] init]  animated:YES completion:nil];
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
    SearchUniversityCenterViewController *vc =[[SearchUniversityCenterViewController alloc] initWithSearchValue:dict[@"search"]];
   [self.navigationController pushViewController:vc animated:YES];
    
}
//查看YOUKU视频
-(void)caseVedioWithdict:(NSDictionary *)response{
    
    NSDictionary *dict =  response[@"args"];
    NSString *path = [dict[@"url"] length] > 0 ? dict[@"url"]: @"http://www.myoffer.cn/";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:path]];
    
    
}

//KVC 监听方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
       
        //不要让进度条倒着走...有时候goback会出现这种情况
        if ([change[@"new"] floatValue] < [change[@"old"] floatValue])  return;
        
        if ([change[@"new"] floatValue] >= 1)[self.hud setHidden:YES];
        
    }else{
        
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


-(void)dealloc
{
    
    [self.web_wk removeObserver:self forKeyPath:@"estimatedProgress"];
    KDClassLog(@"WebViewController网页  dealloc");   //可以释放
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
