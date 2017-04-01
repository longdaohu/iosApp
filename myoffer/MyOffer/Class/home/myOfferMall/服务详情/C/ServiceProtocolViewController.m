//
//  ServiceProtocolViewController.m
//  myOffer
//
//  Created by xuewuguojie on 2017/3/30.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "ServiceProtocolViewController.h"
#import "ServiceProtocalItem.h"
#import "ServiceProtocalSectionHeaderView.h"
#import "ServiceProtocalBottomView.h"
#import "PayOrderViewController.h"
#import "OrderItem.h"

@interface ServiceProtocolViewController ()<UITableViewDelegate,UITableViewDataSource,WKNavigationDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *bgView;
//@property(nonatomic,assign)BOOL agreeToPay;
@end

@implementation ServiceProtocolViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
    
}



-(void)setAgreements:(NSArray *)agreements{
    
    _agreements = agreements;
    
    for (NSInteger index = 0; index <  agreements.count; index ++ ) {
        
        ServiceProtocalItem *item = agreements[index];
        
        WKWebView *web = [[WKWebView alloc] initWithFrame:self.bgView.bounds];
        web.scrollView.scrollEnabled = NO;
        web.navigationDelegate = self;
        web.tag = index;
        
        
        NSString *htmlStr = [NSString stringWithFormat:@"<html> \n <head>\n  <meta name= 'viewport' content='width=device-width, initial-scale=1.0, user-scalable=no'> <style type=\"text/css\"> \n ul,li,p,img,table,hr{width:100%%!important;}\n </style> \n </head> \n  <body>%@</body> \n </html>",item.detail];
        
        [web loadHTMLString:htmlStr baseURL:nil];
        
        
        item.web = web;
    }
    
    if (agreements.count) {
        
        ServiceProtocalItem *item = agreements.firstObject;
        item.isClose = true;
        
    }
}


- (void)makeUI{
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    self.view.alpha = 0;
    
    CGFloat margin = 10;
    CGFloat bg_X = margin;
    CGFloat bg_Y = XNAV_HEIGHT;
    CGFloat bg_H = XSCREEN_HEIGHT - bg_Y - margin * 2;
    CGFloat bg_W = XSCREEN_WIDTH - margin * 2;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(bg_X, bg_Y, bg_W, bg_H)];
    bgView.layer.cornerRadius = CORNER_RADIUS;
    bgView.layer.masksToBounds = YES;
    self.bgView = bgView;
    [self.view addSubview:bgView];
    bgView.backgroundColor = XCOLOR_WHITE;
    
    
    self.tableView =[[UITableView alloc] initWithFrame:self.bgView.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
    [self.bgView addSubview:self.tableView];
    self.tableView.backgroundColor = XCOLOR_BG;
    
    
    CGFloat header_W = bg_W;
    CGFloat header_H = 60;
    UILabel *headerLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, header_W, header_H)];
    headerLab.font = [UIFont boldSystemFontOfSize:20];
    headerLab.textAlignment = NSTextAlignmentCenter;
    headerLab.text = @"条款与协议";
    [bgView addSubview: headerLab];
    headerLab.backgroundColor = XCOLOR_WHITE;
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, header_H - 1, bg_W, 1)];
    line.backgroundColor = XCOLOR_line;
    [bgView addSubview:line];
    
    
    
    XWeakSelf
    ServiceProtocalBottomView *bottomView = [[NSBundle  mainBundle] loadNibNamed:@"ServiceProtocalBottomView" owner:self options:nil].lastObject;
    bottomView.actionBlock  = ^(BOOL isAgree){
     
        
        [weakSelf protocalViewWithAgree:isAgree];
    };
    CGFloat bottom_H =  100;
    bottomView.frame = CGRectMake(0, bg_H - bottom_H, bg_W, bottom_H);
    [bgView addSubview:bottomView];
    
    
    self.tableView.contentInset = UIEdgeInsetsMake(header_H, 0, bottom_H, 0);

}


#pragma mark —————— UITableViewDelegate,UITableViewDataSource

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell.clipsToBounds = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.agreements.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIScrollView *web_bgv = [[UIScrollView alloc] initWithFrame:self.bgView.bounds];
    web_bgv.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    web_bgv.scrollEnabled = NO;
    [cell.contentView addSubview:web_bgv];
    
    ServiceProtocalItem *item = self.agreements[indexPath.section];
    
    web_bgv.contentSize =  CGSizeMake(cell.bounds.size.width, item.web.bounds.size.height);
    web_bgv.mj_h = item.web.bounds.size.height;
    
    
    [web_bgv addSubview:item.web];
    
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
     ServiceProtocalItem *item =  self.agreements[section];

    XWeakSelf
    
    ServiceProtocalSectionHeaderView *sectionView = [ServiceProtocalSectionHeaderView tableView:tableView  sectionViewWithProtocalItem:item];
    
    sectionView.actionBlock = ^{
        
        item.isClose = !item.isClose;
        
        [weakSelf.tableView reloadData];
    };
    
    return sectionView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    ServiceProtocalItem *item = self.agreements[indexPath.section];
    
    return  item.height;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return HEIGHT_ZERO;
}



#pragma mark : WKWebViewDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    
    decisionHandler(WKNavigationActionPolicyAllow);
    /*
     *  WKNavigationActionPolicyAllow
     *  WKNavigationActionPolicyCancel   不允许
     */
}

// WKNavigationDelegate 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    XWeakSelf
    [webView evaluateJavaScript:@"document.body.offsetHeight;" completionHandler:^(id Result, NSError * error) {
        
        NSString *web_height = [NSString stringWithFormat:@"%@",Result];
        
        ServiceProtocalItem *item = self.agreements[webView.tag];
        
        item.web.mj_h = [web_height floatValue] + 20;
        
        item.height = [web_height floatValue] + 20;
        
        [weakSelf.tableView reloadData];
        
    }];
    
}

- (void)showProtocalViw{

    
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        
        self.view.alpha = 1;
    }];
    
}

-(void)HidenProtocalView{
    
    
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        
        self.view.alpha = 0;
    }];
    
}

- (void)protocalViewWithAgree:(BOOL)isAgree{
    
    
    if (isAgree) {
        
        
        [self createOrder];
        
        
    }else{
        
         [self HidenProtocalView];
        
    }
 
    
}



- (void)createOrder{
  
    
    
    NSString *path =[NSString stringWithFormat:@"GET api/account/order/create?sku_id=%@&skip=true",self.service_id];
    
    XWeakSelf
    
    [self startAPIRequestWithSelector:path parameters:nil success:^(NSInteger statusCode, id response) {
        
        PayOrderViewController *pay =[[PayOrderViewController alloc] init];
        
        pay.order = [OrderItem mj_objectWithKeyValues:response[@"order"]];
        
        [weakSelf.navigationController pushViewController:pay animated:YES];
        
        [weakSelf HidenProtocalView];
        
    }];
}



- (void)dealloc{
    
    KDClassLog(@"dealloc 留学协议详情");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
