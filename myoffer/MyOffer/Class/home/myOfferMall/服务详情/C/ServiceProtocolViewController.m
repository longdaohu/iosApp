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
#import "ServiceProductDescriptCell.h"

@interface ServiceProtocolViewController ()<UITableViewDelegate,UITableViewDataSource,WKNavigationDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)NSInteger lastIndex;
@property(nonatomic,strong)NSArray *agreements;
//头部标题
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)ServiceProtocalBottomView *bottomView;
@property(nonatomic,strong)UIView *bgView_protocal;
@property(nonatomic,strong)UIView *bgView_product;
@property(nonatomic,strong)UIView *title_line;
@property(nonatomic,strong)UIButton *close_btn;
@property(nonatomic,assign)BOOL current_product;
@property(nonatomic,strong)ServiceItem *item;

@end

@implementation ServiceProtocolViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
    
    self.lastIndex = DEFAULT_NUMBER;
    
}
- (void)setItemFrame:(ServiceItemFrame *)itemFrame{
    
    _itemFrame = itemFrame;
    
    self.item = itemFrame.item;
    
     self.agreements = itemFrame.item.agreements;

}

 
-(void)setAgreements:(NSArray *)agreements {
    
    _agreements = agreements;
    
    for (NSInteger index = 0; index <  agreements.count; index ++ ) {
        
        ServiceProtocalItem *item = agreements[index];
        WKWebView *web = [[WKWebView alloc] initWithFrame:self.bgView_protocal.bounds];
        web.scrollView.scrollEnabled = NO;
        web.navigationDelegate = self;
        web.tag = index;
        
        NSString *htmlStr = [NSString stringWithFormat:@"<html> \n <head>\n  <meta name= 'viewport' content='width=device-width, initial-scale=1.0, user-scalable=no'> <style type=\"text/css\"> \n ul,li,p,img,table,hr{width:100%%!important;}\n body {margin: 0; padding: 20px 15px 30px 15px;} \n  </style> \n </head> \n  <body>%@</body> \n </html>",item.detail];
        
        [web loadHTMLString:htmlStr baseURL:nil];
        
        item.web = web;
        
        item.isClose =  !((agreements.count - 1) == index);
        
    }
    
    self.lastIndex = (agreements.count - 1);

}

- (UIView *)bgView_protocal{
    
    if (!_bgView_protocal) {
        _bgView_protocal = [[UIView alloc] init];
        _bgView_protocal.layer.cornerRadius = CORNER_RADIUS;
        _bgView_protocal.layer.masksToBounds = YES;
        [self.view addSubview:_bgView_protocal];
        _bgView_protocal.backgroundColor = XCOLOR_WHITE;
    }
    
    return _bgView_protocal;
}


- (UIView *)bgView_product{
    
    if (!_bgView_product) {
        
        _bgView_product = [[UIView alloc] init];
        _bgView_product.clipsToBounds = YES;
        [self.view addSubview:_bgView_product];
        _bgView_product.backgroundColor = [UIColor redColor];
     }
    
    return _bgView_product;
}

- (UIView *)title_line{
    
    if (!_title_line) {
        _title_line = [[UIView alloc] init];
        _title_line.backgroundColor = XCOLOR_line;
        [self.bgView_protocal addSubview:_title_line];

    }
    
    return _title_line;
}



- (UILabel *)titleLab{
    
    if (!_titleLab) {
 
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.font = [UIFont boldSystemFontOfSize:20];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.backgroundColor = XCOLOR_WHITE;
        _titleLab = titleLab;
    }
    
    return _titleLab;
}


- (UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView =[[UITableView alloc] initWithFrame:CGRectZero  style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView =[[UIView alloc] init];
        [self.bgView_protocal addSubview:_tableView];
        _tableView.backgroundColor = XCOLOR_WHITE;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 40.0f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        
    }
    
    return _tableView;
}

- (ServiceProtocalBottomView *)bottomView{
    
    if (!_bottomView) {
        
        ServiceProtocalBottomView *bottomView = [[NSBundle  mainBundle] loadNibNamed:@"ServiceProtocalBottomView" owner:self options:nil].lastObject;
        XWeakSelf
        bottomView.actionBlock  = ^(BOOL isAgree){
             [weakSelf protocalViewWithAgree:isAgree];
        };
 
        _bottomView = bottomView;

    }
    
    return _bottomView;
}


- (UIButton *)close_btn{
    
    if (!_close_btn) {
    
        _close_btn = [[UIButton alloc] init];
        [_close_btn setImage:XImage(@"close_gray") forState:UIControlStateNormal];
        [_close_btn addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];

    }
    
    return _close_btn;
}


- (void)makeUI {
 
    UIButton *tapBtn = [[UIButton alloc] initWithFrame:self.view.bounds];
    [tapBtn addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tapBtn];
 
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    self.view.alpha = 0;
    
    CGFloat margin = 10;
    CGFloat bg_X = margin;
    CGFloat bg_Y = XNAV_HEIGHT;
    CGFloat bg_H = XSCREEN_HEIGHT - bg_Y * 2;
    CGFloat bg_W = XSCREEN_WIDTH - margin * 2;
    self.bgView_protocal.frame = CGRectMake(bg_X, bg_Y, bg_W, bg_H);
    
    CGFloat bg_product_height = XSCREEN_HEIGHT * 0.5;
    CGFloat bg_product_y = XSCREEN_HEIGHT;
    self.bgView_product.frame = CGRectMake(0, bg_product_y, XSCREEN_WIDTH, bg_product_height);
 
}

- (void)makeCurrentView{
 

    UIView *bgView = self.current_product ? self.bgView_product : self.bgView_protocal;

    CGFloat title_W = bgView.mj_w;
    [bgView  addSubview:self.titleLab];
    CGFloat title_H = 60;
    self.titleLab.frame = CGRectMake(0, 0, title_W, title_H);
    NSString *title = self.current_product ? @"商品参数" :  @"条款与协议";
     self.titleLab.text = title;

    
    self.tableView.frame = CGRectMake(0, title_H, title_W, bgView.mj_h - title_H);
    [bgView addSubview:self.tableView];
    
    if (self.current_product) {
        
        self.tableView.contentInset = UIEdgeInsetsZero;
        self.bottomView.frame = CGRectZero;
        self.title_line.frame = CGRectZero;
        
        self.close_btn.frame = CGRectMake(bgView.mj_w - 60, 0, 60, 60);
        [bgView addSubview:self.close_btn];
 
    }else{
        
        CGFloat bottom_H =  100;
        self.bottomView.frame = CGRectMake(0, bgView.mj_h - bottom_H, bgView.mj_w, bottom_H);
        [bgView addSubview:self.bottomView];
         self.tableView.contentInset = UIEdgeInsetsMake(0, 0, bottom_H, 0);
        
        self.title_line.frame = CGRectMake(0, title_H - LINE_HEIGHT, title_W, LINE_HEIGHT);
        [bgView addSubview:self.title_line];

    }
    [self.tableView reloadData];

}

#pragma mark :  UITableViewDelegate,UITableViewDataSource

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell.clipsToBounds = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return  self.current_product ? 1 : self.agreements.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.current_product ? self.item.comment_attr.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    if (self.current_product) {
     
        ServiceProductDescriptCell *cell_product = [ServiceProductDescriptCell cellWithTableView:tableView];
        
        cell_product.comment =self.item.comment_attr[indexPath.row];
        cell_product.cell_height = [self.itemFrame.commentFrames[indexPath.row] floatValue];
        
        return cell_product;
    }
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIScrollView *web_bgv = [[UIScrollView alloc] initWithFrame:self.bgView_protocal.bounds];
    web_bgv.scrollEnabled = NO;
    [cell.contentView addSubview:web_bgv];
    
    ServiceProtocalItem *item = self.agreements[indexPath.section];
    web_bgv.contentSize =  CGSizeMake(cell.bounds.size.width, item.web.bounds.size.height);
    web_bgv.mj_h = item.web.bounds.size.height;
    
    [web_bgv addSubview:item.web];
    
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (self.current_product) {
    
        return nil;
    }
     XWeakSelf
    ServiceProtocalSectionHeaderView *sectionView = [ServiceProtocalSectionHeaderView tableView:tableView  sectionViewWithProtocalItem:self.agreements[section]];
    sectionView.actionBlock = ^{
        [weakSelf headerView:section];
    };
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    if (self.current_product) {
 
        return  [self.itemFrame.commentFrames[indexPath.row] floatValue] + 20;
    }
    
    ServiceProtocalItem *item = self.agreements[indexPath.section];
 
    return item.height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (self.current_product) {
        
        return HEIGHT_ZERO;
    }
    return Section_header_Height_nomal;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return HEIGHT_ZERO;
}

#pragma mark : WKWebViewDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    decisionHandler(WKNavigationActionPolicyAllow);

}

// WKNavigationDelegate 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    XWeakSelf
    [webView evaluateJavaScript:@"document.body.offsetHeight;" completionHandler:^(id Result, NSError * error) {
        
        NSString *web_height = [NSString stringWithFormat:@"%@",Result];
        
        ServiceProtocalItem *item = self.agreements[webView.tag];
        
        item.web.mj_h = [web_height floatValue];
        
        item.height = [web_height floatValue];
        
        [weakSelf.tableView reloadData];
        
    }];
    
}


#pragma mark : 事件处理

- (void)headerView:(NSInteger)section{
 
    ServiceProtocalItem *item =  self.agreements[section];
    
    if (self.lastIndex == section) {
        
        item.isClose =  !item.isClose;
        
        self.lastIndex = DEFAULT_NUMBER;
        
        
    }else{
        
        if (DEFAULT_NUMBER != self.lastIndex) {
            
            ServiceProtocalItem *lastItem =  self.agreements[self.lastIndex];
            
            lastItem.isClose = YES;
            
        }
        
        
        item.isClose  = NO;
        
        self.lastIndex = section;
        
    }
    
    
    [self.tableView reloadData];
    
    [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
}


- (void)protocalShow:(BOOL)show{
 
    CGFloat alpha_protocal = show ? 1 : 0;
    
    if (show) {
        
        [self makeCurrentView];

        self.bgView_protocal.hidden = NO;
        self.bgView_product.hidden = YES;
 
    }else{
        
        [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];

    }
 
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        
        self.view.alpha = alpha_protocal;
        
    }];
    
}

- (void)productDescriptionShow:(BOOL)show{
 
    self.current_product = show;
    
    CGFloat alpha = show ? 1 : 0;
    
    if (show) {
    
        [self makeCurrentView];

        self.view.alpha = alpha;
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        self.bgView_protocal.hidden = YES;
        self.bgView_product.hidden = NO;
        
        [UIView animateWithDuration:ANIMATION_DUATION animations:^{
            
            self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
            self.bgView_product.mj_y = XSCREEN_HEIGHT * 0.5;
        }];
        
        return;
    }
    
    [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
 
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        
        self.view.alpha = alpha;

    } completion:^(BOOL finished) {
        
        self.bgView_product.mj_y = XSCREEN_HEIGHT;
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];

    }];
    
 
}

- (void)tap{
    
    if (self.current_product) {
        
        [self productDescriptionShow:NO];
   }
    }

- (void)protocalViewWithAgree:(BOOL)isAgree{
    
    isAgree ? [self createOrder] :  [self protocalShow:NO];
 
}


- (void)createOrder{
    
    NSString *path =[NSString stringWithFormat:@"GET api/account/order/create?sku_id=%@&skip=true",self.item.service_id];
    
    XWeakSelf
    
    [self startAPIRequestWithSelector:path parameters:nil success:^(NSInteger statusCode, id response) {
        
        PayOrderViewController *pay =[[PayOrderViewController alloc] init];
        
        pay.order = [OrderItem mj_objectWithKeyValues:response[@"order"]];
        
        [weakSelf.navigationController pushViewController:pay animated:YES];
 
        [weakSelf protocalShow:NO];
        
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
