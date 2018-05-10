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
#import "MyOfferServerMallViewController.h"
#import "NotificationViewController.h"
#import "SearchUniversityCenterViewController.h"
#import "ApplyStatusHistoryViewController.h"
#import "ApplyStatusViewController.h"
#import "UniversityViewController.h"
#import "IntelligentResultViewController.h"
#import "CatigoryViewController.h"
#import "MessageDetaillViewController.h"


@interface WebViewController ()<WKNavigationDelegate,WKUIDelegate>
@property(nonatomic,strong)MBProgressHUD *hud;
@property(nonatomic,strong)WKWebView *web_wk;
@property(nonatomic,assign)NSInteger recommendationsCount;//智能匹配数量
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
    
    NSString *tozhi_url_pre = [NSString stringWithFormat:@"%@account/message",DOMAINURL];
    NSString *tozhi_url_sub = @"client=app";
    if ([self.path hasPrefix:tozhi_url_pre] && [self.path hasSuffix:tozhi_url_sub]) {
        
    }else{
        
        UIBarButtonItem *pre_item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow"] style:UIBarButtonItemStyleDone target:self action:@selector(casePre)];
        UIBarButtonItem *pop_item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close_button"] style:UIBarButtonItemStyleDone target:self action:@selector(casePop)];
        self.navigationItem.leftBarButtonItems = @[pre_item,pop_item];
        
    }
    
}

- (void)casePre{
    
    if ([self.web_wk canGoBack] ) {
        
        [self.web_wk goBack];
        [self.hud hideAnimated:YES];
        
    }else{
        
         [self casePop];
    }
}

- (void)casePop{
    
    [self.navigationController popViewControllerAnimated:YES];
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
    
    
    if([self.path hasSuffix:@"agreement.html"]){

        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width,initial-scale=1.0,maximum-scale=1.0, user-scalable=no'); document.getElementsByTagName('head')[0].appendChild(meta);";
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        wkWebConfig.userContentController = wkUController;
        self.web_wk = [[WKWebView alloc] initWithFrame:CGRectMake(0,0,XSCREEN_WIDTH,XSCREEN_HEIGHT - XNAV_HEIGHT) configuration:wkWebConfig];
        self.title = @"myOffer用户协议";
        
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


#pragma mark :  WKWebViewDeleage
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
   self.hud = [MBProgressHUD showMessage:nil toView:self.view];
 
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    
    NSString *jumpF = [self.path containsString:@"account/message/"] ?  @"window.app = {jump: function (args,temp) {window.location = 'app:jump/' + args + '/' + temp;}};" : @"window.app = {appJump: function (args,temp) {window.location = 'app:appJump/' + args + '/' + temp;}};  var a_list = document.querySelectorAll('a');for(var index = 0;index<a_list.length;index++){ a_list[index].setAttribute('target','');  } ";
//    a_list[index].setAttribute('style','display:inline-block; overflow:hidden;');
    [webView evaluateJavaScript:jumpF completionHandler:nil];
    
    [self.hud hideAnimated:YES];
 
}


- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
    [KDAlertView showMessage:GDLocalizedString(@"NetRequest-connectError") cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];
  
    [self.hud hideAnimated:YES];
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
//    app:jump/openURL/http://www.baidu.com
//    app:jump/1/35
//    app:jump/1/32
//    app:jump/1/34
//    app:jump/0/undefined
    
    NSString *absoluteString = navigationAction.request.URL.absoluteString;
    
    //通知内在网页跳转
    NSString *pre_str = @"app:jump/openURL/";
    if ([absoluteString hasPrefix:pre_str]) {
 
        [MobClick event:@"activity_ms"];

        NSString *path = [absoluteString substringFromIndex:pre_str.length];
        if (![path hasPrefix:@"http"]) {
            
            path = [NSString stringWithFormat:@"http://%@",path];
        }
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:path]];
        
        decisionHandler(WKNavigationActionPolicyCancel);
        
        return;
    }

    //空白页
    if ([absoluteString isEqualToString:@"about:blank"]) {
        
        decisionHandler(WKNavigationActionPolicyCancel);

        return;
    }
    
    //文章详情
    NSString *article_rule =@"^http(s)?://www.(myofferdemo.com|myoffer.cn)/article/[0-9]+.html";
    if([self matchWithPath:absoluteString rule:article_rule] && ![self.path isEqualToString:absoluteString]){
        
//          NSLog(@">>>>>>>文章详情>>>>>>>>> %@  ==  %@",absoluteString,self.path);
        
        NSArray *arr = [absoluteString componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"./"]];
        if(arr.count > 2){
            
            NSString *url_path = [NSString stringWithFormat:@"GET api/article/short-id/%@",arr[arr.count-2]];
            WeakSelf
            [self startAPIRequestWithSelector:url_path parameters:nil expectedStatusCodes:nil showHUD:NO showErrorAlert:NO errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
                MessageDetaillViewController *detail = [[MessageDetaillViewController alloc] initWithMessageId:response[@"id"]] ;
                [weakSelf.navigationController pushViewController:detail animated:YES];
            } additionalFailureAction:nil];
        }
        
        decisionHandler(WKNavigationActionPolicyCancel);
        
        return;
        
    }
    

    
   
    if ([absoluteString containsString:@"app:appJump"]) {
        NSArray  *items = [absoluteString componentsSeparatedByString:@"/"];
        NSString *jump_str = @"";
        for (NSString *item in items) {
            if ([item containsString:@"args"]) {
                jump_str  = item;
                break;
            }
        }
        
        NSString *path = [jump_str toUTF8WithString];
        NSData *JSONData = [path dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
        [self pageWithResponse:responseJSON];
        decisionHandler(WKNavigationActionPolicyCancel);
        
    }else if ([absoluteString containsString:@"/evaluate"]){
        //OK   智能匹配
        [self caseZhiNenPipei];
        decisionHandler(WKNavigationActionPolicyCancel);
        
    }else if([absoluteString containsString:@"/rank"]){
         //OK   英澳排名
        [self caseUniversityList];
        decisionHandler(WKNavigationActionPolicyCancel);
        
    }else if([absoluteString containsString:@"/intention"]){
         //OK   留学咨询
        [self caseWoyaoluxue];
        decisionHandler(WKNavigationActionPolicyCancel);
        
    }else if([absoluteString hasSuffix:@"recommend?major"]){
       //OK   留学咨询
        [self caseWoyaoluxue];
        decisionHandler(WKNavigationActionPolicyCancel);
        
    }else  if ([absoluteString containsString:@"recommend?major="]  || [absoluteString containsString:@"mbti/recommend"]|| [absoluteString containsString:@"mbti1_report"] ) {
       
        //Ok   WebViewController
        NSDictionary *header =  navigationAction.request.allHTTPHeaderFields;
        NSString *apiValue  = [header valueForKey:@"apikey"];
        
        if (apiValue.length == 0) {
            
            WebViewController *webPage = [[WebViewController alloc] init];
            webPage.path = absoluteString;
            [self.navigationController pushViewController:webPage animated:YES];
            
            decisionHandler(WKNavigationActionPolicyCancel);
            
            
        }else{
            
            decisionHandler(WKNavigationActionPolicyAllow);
            
        }
        
        
    }else if([absoluteString containsString:@"jump/1"]) {
        [MobClick event:@"activity_ms"];
        // 申请服务状态
        [self caseApplyStatus:absoluteString];
        decisionHandler(WKNavigationActionPolicyCancel);
        
    }else if([absoluteString hasPrefix:@"app:jump/0"]) {
        
        // 申请状态
        [self caseApplyStatus];
        decisionHandler(WKNavigationActionPolicyCancel);
        
    }else if([absoluteString containsString:@"/university/"]) {
         //学校详情
        NSRange UniRagne = [absoluteString rangeOfString:@"university/"];
        NSString *lastPath =[absoluteString substringWithRange:NSMakeRange((UniRagne.location + UniRagne.length), absoluteString.length - (UniRagne.location + UniRagne.length))];
        NSArray *contents = [lastPath componentsSeparatedByString:@"."];
        [self caseUniversityWithshortId:contents[0]];
        decisionHandler(WKNavigationActionPolicyCancel);
        
    }else if([absoluteString containsString:@"service.html"] || [absoluteString containsString:@"emall/index.html"]) {
        //服务商城
        [self caseServiceMall];
        decisionHandler(WKNavigationActionPolicyCancel);
       
    }else{
//        NSLog(@">>>>>>>>>>>>>>>> %@  ==  %@",absoluteString,self.path);
        decisionHandler(WKNavigationActionPolicyAllow);
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
            [self caseUniversityList];
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
        default:
            break;
    }
}

//院校排名
-(void)caseUniversityList{
    
    [self.tabBarController setSelectedIndex:1];
    UINavigationController *nav  = self.tabBarController.childViewControllers[1];
    CatigoryViewController *catigroy =  (CatigoryViewController *)nav.childViewControllers[0];
    [catigroy jumpToRank];
  
}


//判断是否有智能匹配数据或收藏学校
-(void)checkZhiNengPiPei
{
//    if (LOGIN) {
//
//        WeakSelf
//        [self startAPIRequestWithSelector:kAPISelectorZiZengPipeiGet  parameters:nil success:^(NSInteger statusCode, id response) {
//            weakSelf.recommendationsCount = response[@"university"] ? 1 : 0;
//        }];
//    }
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

//审核状态
-(void)caseApplyStatus{
    
    [self.navigationController pushViewController:[[ApplyStatusViewController alloc] init] animated:YES];

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

//服务商城
- (void)caseServiceMall{
    
    [self.navigationController pushViewController:[[MyOfferServerMallViewController alloc] init] animated:YES];
    
}

//服务状态
- (void)caseApplyStatus:(NSString *)url_path{
  
    NSString *inner = @"jump/1/";
    NSString *process_id = [url_path componentsSeparatedByString:inner].lastObject;
    NSString *path = [NSString stringWithFormat:@"%@%@",kAPISelectorStatusDetail,process_id];
    WeakSelf
    [self startAPIRequestWithSelector:path parameters:nil success:^(NSInteger statusCode, id response) {
       
        ApplyStatusHistoryViewController *historyVC = [[ApplyStatusHistoryViewController alloc] init];
        historyVC.status_history = response;
        [weakSelf.navigationController pushViewController:historyVC animated:YES];
        
    }];
    
    
}

// 正则表达式匹配 网页链接
- (BOOL)matchWithPath:(NSString *)path rule:(NSString *)rule{
    
    NSPredicate *article_pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",rule];
    
    return [article_pre evaluateWithObject:path];
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
