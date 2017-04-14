//
//  ServiceItemViewController.m
//  myOffer
//
//  Created by xuewuguojie on 2017/3/27.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "ServiceItemViewController.h"
#import "ServiceItem.h"
#import "ServiceItemFrame.h"
#import "ServiceItemHeaderView.h"
#import "UniversityNavView.h"
#import "ServiceItemBottomView.h"
#import "ServiceProtocolViewController.h"

@interface ServiceItemViewController ()<WKNavigationDelegate,UITableViewDelegate,UITableViewDataSource>
//显示内容信息 webView
@property(nonatomic,strong)WKWebView *web_wk;

@property(nonatomic,strong)UITableView *tableView;
//tableHeaderView
@property(nonatomic,strong) ServiceItemHeaderView *headerView;

// < !--头部图片
@property(nonatomic,strong)UIImageView *flexView;
@property(nonatomic,assign)CGRect flexFrame;
@property(nonatomic,assign)CGPoint flexCenter;
// 头部图片 -->

//顶部View
@property(nonatomic,strong)UniversityNavView *topNavigationView;
//底部View
@property(nonatomic,strong)ServiceItemBottomView *bottomView;
//显示协议
@property(nonatomic,strong)ServiceProtocolViewController *protocalVC;

@end

@implementation ServiceItemViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeDataSource];
    
    [self makeUI];
    
}


-(void)makeUI{
    
    [self makeTableView];
    
    [self makeFlexibeView];
    
    [self makeTopNavigaitonView];
    
    [self makeBottomView];
    
    [self makeProtocalView];
    
}

- (void)makeProtocalView{

    ServiceProtocolViewController *protocalVC = [[ServiceProtocolViewController alloc] init];
    
    self.protocalVC = protocalVC;
    
    [self addChildViewController:protocalVC];
    
    [self.view addSubview:protocalVC.view];
}


- (void)makeFlexibeView{
    
    UIImage *FlexibleImg = XImage(@"service-info-bg");
    UIImageView *FlexibleView = [[UIImageView alloc] init];
    FlexibleView.contentMode = UIViewContentModeScaleAspectFit;
    FlexibleView.image = FlexibleImg;
    CGFloat iconHeight =  XSCREEN_WIDTH * FlexibleImg.size.height / FlexibleImg.size.width;
    
    FlexibleView.frame = CGRectMake(0, 0, XSCREEN_WIDTH, iconHeight);
    [self.view insertSubview:FlexibleView belowSubview:self.tableView];
    self.flexView = FlexibleView;
    self.flexFrame = self.flexView.frame;
    self.flexCenter = FlexibleView.center;
    
    self.tableView.contentInset = UIEdgeInsetsMake(self.flexFrame.size.height - 60, 0, 80, 0);
    
}

- (void)makeWebView{
    
    if (self.web_wk) [self.web_wk removeFromSuperview];
    
    WKWebView *web = [[WKWebView alloc] initWithFrame:self.view.bounds];
    web.scrollView.scrollEnabled = NO;
    web.navigationDelegate = self;
    self.web_wk = web;
    
    
}

- (void)makeBottomView{

    ServiceItemBottomView *bottomView = [[ServiceItemBottomView alloc] initWithFrame:CGRectMake(0, XSCREEN_HEIGHT - 80, XSCREEN_WIDTH, 90)];
    [self.view insertSubview:bottomView aboveSubview:self.tableView];
    self.bottomView = bottomView;
    XWeakSelf;
    bottomView.acitonBlock = ^(UIButton *sender){
        
        [weakSelf bottomViewWithItemOnClick:sender];
        
    };
    
}

#pragma mark : WKWebViewDelegate  WBWebSiteDataStore

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {

    [webView reload];
}

- (void)removeDataOfTypes:(NSSet<NSString *> *)websiteDataTypes modifiedSince:(NSDate *)date completionHandler:(void (^)(void))completionHandler{

    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    
    decisionHandler(WKNavigationActionPolicyAllow);
    //decisionHandler(WKNavigationActionPolicyCancel);  不允许
}

// WKNavigationDelegate 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    
    [webView evaluateJavaScript:@"document.body.offsetHeight;" completionHandler:^(id Result, NSError * error) {
        
        
        NSString *web_height = [NSString stringWithFormat:@"%@",Result];
        
        
        self.web_wk.mj_h = [web_height floatValue] + 20;
        
        
        [self.tableView reloadData];
        
        
    }];
    
    

    
}


- (void)makeDataSource{
    
    NSString *path = [NSString  stringWithFormat:@"GET api/emall/sku/%@",self.service_id];
    
    XWeakSelf
    [self startAPIRequestWithSelector:path  parameters:nil success:^(NSInteger statusCode, id response) {
        
        
        [weakSelf updateUIWithresponse:response];
        
    }];
    
}


- (void)updateUIWithresponse:(id)response{
    
    //每次刷新 新建WebView
    [self makeWebView];
    
 
    ServiceItem *item = [ServiceItem mj_objectWithKeyValues:response];
    
    ServiceItemFrame *itemFrame = [[ServiceItemFrame alloc] init];
    
    itemFrame.item = item;
    
    self.headerView.itemFrame = itemFrame;
    
    [self.tableView beginUpdates];
    
    self.headerView.frame = itemFrame.headerViewFrame;
    
    [self.tableView endUpdates];
    
    
    
    NSString *htmlStr = [NSString stringWithFormat:@"<html> \n <head>\n  <meta name= 'viewport' content='width=device-width, initial-scale=1.0, user-scalable=no'> <style type=\"text/css\"> \n p,img,table,hr{width:100%%!important;}\n </style> \n </head> \n  <body>%@</body> \n </html>",item.detail];
    
    [self.web_wk loadHTMLString:htmlStr baseURL:nil];
    
 
    [self.web_wk reload];

    
    self.bottomView.price =  item.price_str;
    
    self.topNavigationView.titleName = item.name ;
    
    self.protocalVC.agreements = item.agreements;
}




-(void)makeTableView
{
    self.tableView =[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];

    XWeakSelf
    ServiceItemHeaderView *headerView = [[ServiceItemHeaderView alloc] init];
    headerView.actionBlcok = ^(NSString *service_id){
        
        weakSelf.service_id = service_id;
        
        [weakSelf makeDataSource];
        
    };
    
    self.headerView = headerView;
    self.tableView.tableHeaderView = headerView;
    
}


//添加自定义顶部导航
-(void)makeTopNavigaitonView{
    
    
    XWeakSelf
    UniversityNavView *nav = [UniversityNavView ViewWithBlock:^(UIButton *sender) {
        
        [weakSelf navigationItemWithSender:sender];
    }];
    //隐藏收藏功能
    [nav navigationWithRightViewHiden:YES];
    self.topNavigationView = nav;
    [self.view insertSubview:nav aboveSubview:self.tableView];
    
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIScrollView *web_bgv = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    web_bgv.scrollEnabled = NO;
    [cell.contentView addSubview:web_bgv];
    
    web_bgv.contentSize =  CGSizeMake(cell.bounds.size.width, self.web_wk.bounds.size.height);
    web_bgv.mj_h = self.web_wk.bounds.size.height;
    
    [web_bgv addSubview:self.web_wk];
    

    
    return cell;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return self.web_wk.frame.size.height;
    
}


#pragma mark : UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offersetY =  scrollView.contentOffset.y +  (self.flexFrame.size.height - 60);
    
    //3 顶部自定义导航栏透明度
    [self.topNavigationView scrollViewContentoffset:offersetY andContenHeight:self.flexFrame.size.height - XNAV_HEIGHT];
     self.topNavigationView.nav_Alpha =  offersetY /  (self.flexFrame.size.height - XNAV_HEIGHT);

    
    if (offersetY > 0) {
        
        [UIView animateWithDuration:ANIMATION_DUATION animations:^{
            
            self.flexView.frame = self.flexFrame;
            
            self.flexView.center = self.flexCenter;
            
        }];
        
        
        return;
    }
    
    CGRect newRect = self.flexFrame;
    
    newRect.size.height = self.flexFrame.size.height - offersetY * 2;
    
    newRect.size.width  = self.flexFrame.size.width * newRect.size.height / self.flexFrame.size.height;
    
    self.flexView.frame = newRect;
    
    self.flexView.center = self.flexCenter;
    
}

#pragma mark : 底部工具条点击事件

- (void) bottomViewWithItemOnClick:(UIButton *)sender{

    if (sender.currentTitle.length) {
        
        RequireLogin
        
        self.protocalVC.service_id = self.service_id;
        
        [self.protocalVC showProtocalViw];
        
    }else{
        
        [self  caseQQ];
    }
}


#pragma mark : navigationView 点击事件

- (void)navigationItemWithSender:(UIButton *)sender{
    
    [self pop];
    
}

//跳转到QQ客服聊天页面

-(void)caseQQ{
    
    QQserviceSingleView *service = [[QQserviceSingleView alloc] init];
    [service call];
    
}

 
- (void)pop{
    
    [self.navigationController popViewControllerAnimated:true];
}


/*
 
 - (void)viewWillDisappear:(BOOL)animated{
 
 [super viewWillDisappear:animated];
 
 }
 
 [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
 [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
 [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
 [[NSUserDefaults standardUserDefaults] synchronize];

- (void)applicationDidReceiveMemoryWarning:(UIApplication*)application
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

//清除WKWebView的缓存
 myOffer[11812:2681126] [MC] Invalidating cache

- (void)deleteWebCache {
 
        NSSet *websiteDataTypes
        
        = [NSSet setWithArray:@[
                                
                                WKWebsiteDataTypeDiskCache,
                                
                                //WKWebsiteDataTypeOfflineWebApplicationCache,
                                
                                WKWebsiteDataTypeMemoryCache,
                                
                                //WKWebsiteDataTypeLocalStorage,
                                
                                //WKWebsiteDataTypeCookies,
                                
                                //WKWebsiteDataTypeSessionStorage,
                                
                                //WKWebsiteDataTypeIndexedDBDatabases,
                                
                                //WKWebsiteDataTypeWebSQLDatabases
                                
                                ]];
        
        //// All kinds of data
        
        //NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        
        //// Date from
        
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        
        //// Execute
        
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
            // Done
            
        }];
 
 
 
 NSHTTPCookie *cookieWID = [NSHTTPCookie cookieWithProperties:[NSDictionary dictionaryWithObjectsAndKeys:
 @"wid" ,NSHTTPCookieName,
 WID,NSHTTPCookieValue,
 @"www.google.com",NSHTTPCookieDomain,
 @"",NSHTTPCookiePath,
 @"false",@"HttpOnly",
 nil]];
 
 
 
 }
*/

- (void)dealloc{
    
    KDClassLog(@"dealloc 留学服务详情");
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
