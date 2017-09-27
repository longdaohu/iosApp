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
#import "myofferFlexibleView.h"

@interface ServiceItemViewController ()<WKNavigationDelegate,UITableViewDelegate,UITableViewDataSource>
//显示内容信息 webView
@property(nonatomic,strong)WKWebView *web_wk;

@property(nonatomic,strong)MyOfferTableView *tableView;
//tableHeaderView
@property(nonatomic,strong) ServiceItemHeaderView *headerView;
//头部图片
@property(nonatomic,strong)myofferFlexibleView *flexView;
//顶部View
@property(nonatomic,strong)UniversityNavView *topNavigationView;
//底部View
@property(nonatomic,strong)ServiceItemBottomView *bottomView;
//显示协议
@property(nonatomic,strong)ServiceProtocolViewController *protocalVC;

@property(nonatomic,strong)ServiceItemFrame *service_Frame;

@end

@implementation ServiceItemViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
  
    [MobClick beginLogPageView:@"page留学购详情"];
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page留学购详情"];
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
    CGFloat iconHeight =  XSCREEN_WIDTH * FlexibleImg.size.height / FlexibleImg.size.width;
    myofferFlexibleView *flexView = [myofferFlexibleView flexibleViewWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH,iconHeight)];
    [self.view insertSubview:flexView belowSubview:self.tableView];
    self.flexView = flexView;
    flexView.image_name = @"service-info-bg";
    
    self.tableView.contentInset = UIEdgeInsetsMake(iconHeight - 60, 0, 80, 0);
    
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
    
    NSString *path = [NSString  stringWithFormat:@"%@%@",kAPISelectorMyofferServiceDetail,self.service_id];
    
    XWeakSelf
    [self startAPIRequestWithSelector:path parameters:nil expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
       
         [weakSelf updateUIWithresponse:response];
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
         [weakSelf showError];
    }];
    
}


- (void)updateUIWithresponse:(id)response{
    
    //每次刷新 新建WebView
    [self makeWebView];
 
    ServiceItem *item = [ServiceItem mj_objectWithKeyValues:response];
    
    ServiceItemFrame *itemFrame = [[ServiceItemFrame alloc] init];
    
    itemFrame.item = item;
    
    self.service_Frame = itemFrame;
    
    self.headerView.itemFrame = itemFrame;
  
    self.tableView.tableHeaderView =  self.headerView;
    
 
    
    NSString *htmlStr = [NSString stringWithFormat:@"<html> \n <head>\n  <meta name= 'viewport' content='width=device-width, initial-scale=1.0, user-scalable=no'> <style type=\"text/css\"> \n p,img,table,hr{width:100%%!important;}\n </style> \n </head> \n  <body>%@</body> \n </html>",item.detail];
    
    [self.web_wk loadHTMLString:htmlStr baseURL:nil];
  
    [self.web_wk reload];

    
    self.bottomView.price =  item.price_str;
    
    self.topNavigationView.titleName = item.name ;
    
    self.protocalVC.agreements = item.agreements;
}




-(void)makeTableView
{
    self.tableView =[[MyOfferTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
  
    
}


- (ServiceItemHeaderView *)headerView{

    if (!_headerView) {
        
        XWeakSelf
        ServiceItemHeaderView *headerView = [[ServiceItemHeaderView alloc] init];
        headerView.actionBlcok = ^(NSString *service_id){
            
            weakSelf.service_id = service_id;
            
            [weakSelf makeDataSource];
            
        };
        
        
        _headerView = headerView;
    }
    
    return _headerView;
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
    
    web_bgv.contentSize =  CGSizeMake(cell.bounds.size.width, self.web_wk.mj_h);
    web_bgv.mj_h = self.web_wk.bounds.size.height;
    
    [web_bgv addSubview:self.web_wk];
    

    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return self.web_wk.mj_h;
    
}


#pragma mark : UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offersetY =  scrollView.contentOffset.y +  (self.flexView.bounds.size.height - 60);
    
    //1 顶部自定义导航栏透明度
    [self.topNavigationView scrollViewContentoffset:offersetY andContenHeight:self.flexView.bounds.size.height - XNAV_HEIGHT];
     self.topNavigationView.nav_Alpha =  offersetY /  (self.flexView.bounds.size.height - XNAV_HEIGHT);

    //2 图片拉伸
    [self.flexView flexWithContentOffsetY:offersetY];
    
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
    
    [self dismiss];
    
}

//跳转到QQ客服聊天页面

-(void)caseQQ{
    
    QQserviceSingleView *service = [[QQserviceSingleView alloc] init];
    [service call];
    
}

//显示错误提示
- (void)showError{
    
    if (!self.service_Frame) {
      
        [self.tableView emptyViewWithError:NetRequest_ConnectError];
        
         self.bottomView.alpha = 0;
    }
    
        
 }

- (void)dealloc{
    
    KDClassLog(@"dealloc 留学服务详情");
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
