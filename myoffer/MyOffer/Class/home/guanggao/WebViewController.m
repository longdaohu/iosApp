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
#import "InvitationRecordsVC.h"
#import "ShareNViewController.h"


@interface WebViewController ()<WKNavigationDelegate,WKUIDelegate>
@property(nonatomic,strong)WKWebView *web_wk;
@property(nonatomic,assign)NSInteger recommendationsCount;//智能匹配数量
@property(nonatomic,strong)ShareNViewController *shareVC;
@property(nonatomic,strong)UIProgressView *progressView;
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
        
        UIBarButtonItem *pre_item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_arrow_white"] style:UIBarButtonItemStyleDone target:self action:@selector(casePre)];
        UIBarButtonItem *pop_item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close_button"] style:UIBarButtonItemStyleDone target:self action:@selector(casePop)];
        self.navigationItem.leftBarButtonItems = @[pre_item,pop_item];
        
    }
    
}

- (void)casePre{
    
    if ([self.web_wk canGoBack] ) {
        
        [self.web_wk goBack];
        
    }else{
        
         [self casePop];
    }
}

- (ShareNViewController *)shareVC{
    
    if (!_shareVC) {
        
        NSString *path = [NSString stringWithFormat:@"%@ad/landing/38.html?accountId=%@",DOMAINURL,[MyofferUser defaultUser].user_id];
        NSString *shareURL = path;
        NSString *shareTitle = @"你的好友邀你一起赚现金，成功留学就差这一步！";
        NSString *shareContent = @"800元福利一键收入囊中，留学宜早不宜晚~";
        NSMutableDictionary *shareInfor = [NSMutableDictionary dictionary];
        [shareInfor setValue:shareURL forKey:@"shareURL"];
        [shareInfor setValue:shareTitle forKey:@"shareTitle"];
        [shareInfor setValue:shareContent forKey:@"shareContent"];
        [shareInfor setValue:@"plat" forKey:@"plat"];

        _shareVC = [ShareNViewController shareView];
        _shareVC.shareInfor = shareInfor;
        [self addChildViewController:_shareVC];
        [self.view addSubview:self.shareVC.view];
    }
    
    return _shareVC;
}

- (UIProgressView *)progressView{
    
    if (!_progressView) {
        
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, 3)];
        _progressView.progressTintColor =  XCOLOR_RED;
        _progressView.trackTintColor = XCOLOR(0, 0, 0, 0);
        _progressView.progressViewStyle = UIProgressViewStyleBar;
        [self.view addSubview:_progressView];
    }
    
    return _progressView;
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

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    
    NSString *jumpF = [self.path containsString:@"account/message/"] ?  @"window.app = {jump: function (args,temp) {window.location = 'app:jump/' + args + '/' + temp;}};" : @"window.app = {appJump: function (args,temp) {window.location = 'app:appJump/' + args + '/' + temp;}};  var a_list = document.querySelectorAll('a');for(var index = 0;index<a_list.length;index++){ a_list[index].setAttribute('target','');  } ";
//    a_list[index].setAttribute('style','display:inline-block; overflow:hidden;');
    [webView evaluateJavaScript:jumpF completionHandler:nil];
 
}


- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
    [KDAlertView showMessage:GDLocalizedString(@"NetRequest-connectError") cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")];

}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
//    app:jump/openURL/http://www.baidu.com
//    app:jump/1/35
//    app:jump/0/undefined
    
    //邀请有礼
    NSString *absoluteString = navigationAction.request.URL.absoluteString;
    if ([absoluteString isEqualToString:@"myoffer://jump-from-share"]) {
        
        [self caseShare]; //立即分享
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    if ([absoluteString isEqualToString:@"myoffer://view-all"]) {

        [self caseViewAll]; //查看全部
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
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
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    
}
/*
 白屏问题
  方法1：
 当 WKWebView 总体内存占用过大，页面即将白屏的时候，系统会调用上面的回调函数，我们在该函数里执行[webView reload](这个时候 webView.URL 取值尚不为 nil）解决白屏问题。在一些高内存消耗的页面可能会频繁刷新当前页面，H5侧也要做相应的适配操作
 方法2：
 检测 webView.title 是否为空
 可以在 viewWillAppear 的时候检测 webView.title 是否为空来 reload 页面
 */
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    
    [webView reload];
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
       
        CGFloat new_progress =[change[@"new"] floatValue];
        CGFloat old_progress =[change[@"old"] floatValue];

        self.progressView.alpha = 1;
        self.progressView.progress = new_progress;
        //不要让进度条倒着走...有时候goback会出现这种情况
        if (new_progress < old_progress)  return;
        if (new_progress >= 1){
            self.progressView.mj_w = XSCREEN_WIDTH;
            [UIView animateWithDuration:ANIMATION_DUATION animations:^{
                self.progressView.alpha = 0;
            } completion:^(BOOL finished) {
                self.progressView.progress = 0;
            }];
        };
        
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

//服务商城
- (void)caseServiceMall{
    
    MyOfferServerMallViewController *vc = [[MyOfferServerMallViewController alloc] init];
    PushToViewController(vc);
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

//推荐有礼分享
- (void)caseShare{
    
    [self.shareVC show];
}

//推荐有礼：查看全部
- (void)caseViewAll{
    
    InvitationRecordsVC *vc = [[InvitationRecordsVC alloc] init];
    PushToViewController(vc);
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
