//
//  CreateOrderWebVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/7/4.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "CreateOrderWebVC.h"
#define POST_JS @"function my_post(path, params) {\
var method = \"POST\";\
var form = document.createElement(\"form\");\
form.setAttribute(\"method\", method);\
form.setAttribute(\"action\", path);\
for(var key in params){\
if (params.hasOwnProperty(key)) {\
var hiddenFild = document.createElement(\"input\");\
hiddenFild.setAttribute(\"type\", \"hidden\");\
hiddenFild.setAttribute(\"name\", key);\
hiddenFild.setAttribute(\"value\", params[key]);\
}\
form.appendChild(hiddenFild);\
}\
document.body.appendChild(form);\
form.submit();\
}"

@interface CreateOrderWebVC ()<WKNavigationDelegate,WKUIDelegate>
@property(nonatomic,strong)WKWebView *web_wk;
@property(nonatomic,strong)UIView *progressView;

@end


@implementation CreateOrderWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
}

-(void)makeUI
{
    
    self.title = @"留学合同";
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width,initial-scale=1.0,maximum-scale=1.0, user-scalable=no'); document.getElementsByTagName('head')[0].appendChild(meta);";
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;
    self.web_wk = [[WKWebView alloc] initWithFrame:CGRectMake(0,0,XSCREEN_WIDTH,XSCREEN_HEIGHT - XNAV_HEIGHT) configuration:wkWebConfig];
    self.web_wk.navigationDelegate = self;
    if ([self.path containsString:@"contracts/pdf"]) {
        NSMutableURLRequest *request =[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.path]];
        [self.web_wk loadRequest:request];
        [self.view addSubview:self.web_wk];
    }else{
        [self.view addSubview:self.web_wk];
        NSError *parseError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.item options:NSJSONWritingPrettyPrinted error:&parseError];
        NSString *dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSString * js = [NSString stringWithFormat:@"%@my_post(\"%@\", %@)",POST_JS,self.path,dataStr];
        [self.web_wk evaluateJavaScript:js completionHandler:nil];
    }
    
    //监听网页加载进度
    [self.web_wk addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew| NSKeyValueObservingOptionOld context:nil];
 
}


#pragma mark :  WKWebViewDeleage

-  (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSString *absoluteString = navigationAction.request.URL.absoluteString;
    if ([absoluteString containsString:@"myoffer.cn/aboutus"]) {
        [self caseDissmissDelay];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
        
    }else{
     
        decisionHandler(WKNavigationActionPolicyAllow);
    }
        
}

- (UIView *)progressView{
    
    if (!_progressView) {
        
        _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 3)];
        _progressView.layer.cornerRadius = 1.5;
        _progressView.backgroundColor = XCOLOR_RED;
        [self.view addSubview:_progressView];
    }
    
    return _progressView;
}


//KVC 监听方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        self.progressView.alpha = 1;
        self.progressView.mj_w = XSCREEN_WIDTH * [change[@"new"] floatValue];
        
        //不要让进度条倒着走...有时候goback会出现这种情况
        if ([change[@"new"] floatValue] < [change[@"old"] floatValue])  return;
        
        if ([change[@"new"] floatValue] >= 1){
            self.progressView.mj_w = XSCREEN_WIDTH;
            [UIView animateWithDuration:ANIMATION_DUATION animations:^{
                self.progressView.alpha = 0;
            } completion:^(BOOL finished) {
                self.progressView.mj_w = 0;
            }];
        };
        
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


- (void)caseDissmissDelay{
    
    if (self.webSuccesedCallBack) {
        self.webSuccesedCallBack();
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [self.web_wk removeObserver:self forKeyPath:@"estimatedProgress"];
    KDClassLog(@"CreateOrderWebVC + 留学合同网页 + dealloc");   //可以释放
}


@end

