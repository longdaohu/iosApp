//
//  serviceProtocolVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/4/9.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "serviceProtocolVC.h"
#import "ServiceItem.h"
#import "ServiceProductDescriptCell.h"
#import "ServiceProtocalItem.h"
#import "ServiceProtocalSectionHeaderView.h"

@interface serviceProtocolVC ()<UITableViewDelegate,UITableViewDataSource,WKNavigationDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)ServiceItem *item;
@property(nonatomic,strong)NSArray *agreements;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UIButton *closeBtn;
@property(nonatomic,assign)NSInteger lastIndex;

@end

@implementation serviceProtocolVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeUI];
}

- (void)makeUI{
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    self.view.alpha = 0;
    
    switch (self.type) {
        case protocolViewTypeHtml:
            [self makeHtmlUI];
            break;
        case protocolViewTypeList:
            [self makeListUI];
            break;
        default:
            break;
    }
}

- (UIView *)bgView{
    
    if (!_bgView) {
        
        _bgView = [UIView new];
        _bgView.backgroundColor = XCOLOR_RED;
        [self.view addSubview:_bgView];
    }
    return _bgView;
}

- (UILabel *)titleLab{
    
    if (!_titleLab) {
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, 60)];
        titleLab.font = [UIFont boldSystemFontOfSize:20];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.backgroundColor = XCOLOR_WHITE;
        _titleLab = titleLab;
    }
    return _titleLab;
}

- (UIButton *)closeBtn{
    
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [_closeBtn setImage:XImage(@"close_gray") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(pageClose) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _closeBtn;
}


- (void)setItemFrame:(ServiceItemFrame *)itemFrame{
    
    _itemFrame = itemFrame;
    
    self.item = itemFrame.item;
    if (self.type == protocolViewTypeHtml) {
        self.agreements = itemFrame.item.agreements;
    }
    [self.tableView reloadData];
}

-(void)setAgreements:(NSArray *)agreements {
    
    _agreements = agreements;
    
    self.lastIndex = (agreements.count - 1);
    
    for (NSInteger index = 0; index <  agreements.count; index ++ ) {
        
        ServiceProtocalItem *item = agreements[index];
        WKWebView *web = [[WKWebView alloc] initWithFrame:self.bgView.bounds];
        web.scrollView.scrollEnabled = NO;
        web.navigationDelegate = self;
        web.tag = index;
        NSString *htmlStr = [NSString stringWithFormat:@"<html> \n <head>\n  <meta name= 'viewport' content='width=device-width, initial-scale=1.0, user-scalable=no'> <style type=\"text/css\"> \n ul,li,p,img,table,hr{width:100%%!important;}\n body {margin: 0; padding: 20px 15px 30px 15px;} \n  </style> \n </head> \n  <body>%@</body> \n </html>",item.detail];
        
        [web loadHTMLString:htmlStr baseURL:nil];
        item.web = web;
        item.isClose =  !(self.lastIndex == index);
        
    }
    
}



- (void)makeListUI{
    
    CGFloat bg_h = XSCREEN_HEIGHT * 0.5;
    CGFloat bg_y = XSCREEN_HEIGHT;
    CGFloat bg_x = 0;
    CGFloat bg_w = XSCREEN_WIDTH;
    self.bgView.frame = CGRectMake(bg_x, bg_y, bg_w, bg_h);
    
    self.titleLab.text = @"商品参数";
    [self.bgView addSubview:self.titleLab];
    
    self.closeBtn.mj_x = bg_w - self.closeBtn.mj_w;
    [self.bgView addSubview:_closeBtn];
 
    [self makeTableWithType:UITableViewStylePlain];
    [self.bgView insertSubview:self.tableView atIndex:0];
    self.tableView.frame = self.bgView.bounds;
    self.tableView.contentInset = UIEdgeInsetsMake(self.titleLab.mj_h, 0, 0, 0);
    
}

- (void)makeHtmlUI{
    
    CGFloat bg_h = XSCREEN_HEIGHT * 0.9;
    CGFloat bg_y = XSCREEN_HEIGHT * 0.05;
    CGFloat bg_x = 10;
    CGFloat bg_w = XSCREEN_WIDTH - bg_x * 2;
    self.bgView.frame = CGRectMake(bg_x, bg_y, bg_w, bg_h);
    self.bgView.layer.cornerRadius = 8;
    self.bgView.layer.masksToBounds = YES;
    
    self.titleLab.text = @"条款与协议";
    self.titleLab.mj_w = bg_w;
    [self.bgView addSubview:self.titleLab];
    
    [self.closeBtn setImage:XImage(@"protocol_close") forState:UIControlStateNormal];
    self.closeBtn.mj_x = bg_w - self.closeBtn.mj_w;
    [self.bgView addSubview:self.closeBtn];
    
    [self makeTableWithType:UITableViewStyleGrouped];
    [self.bgView insertSubview:self.tableView atIndex:0];
    self.tableView.frame = self.bgView.bounds;
    self.tableView.contentInset = UIEdgeInsetsMake(self.titleLab.mj_h, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = XCOLOR_WHITE;
    
}


- (void)makeTableWithType:(UITableViewStyle)type{
    
    self.tableView =[[UITableView alloc] initWithFrame:CGRectZero style:type];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
}


#pragma mark :  UITableViewDelegate,UITableViewDataSource

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell.clipsToBounds = YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return (self.type == protocolViewTypeList)  ? 1 : self.agreements.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.type == protocolViewTypeList) {
        return self.item.comment_attr.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.type == protocolViewTypeList) {

        ServiceProductDescriptCell *cell_product = [ServiceProductDescriptCell cellWithTableView:tableView];
        cell_product.comment = self.item.comment_attr[indexPath.row];
        cell_product.cell_height = [self.itemFrame.commentFrames[indexPath.row] floatValue];
        
        return cell_product;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIScrollView *web_bgv = [[UIScrollView alloc] initWithFrame:self.bgView.bounds];
    web_bgv.scrollEnabled = NO;
    [cell.contentView addSubview:web_bgv];
    
    ServiceProtocalItem *item = self.agreements[indexPath.section];
    web_bgv.contentSize =  CGSizeMake(cell.bounds.size.width, item.web.bounds.size.height);
    web_bgv.mj_h = item.web.bounds.size.height;
    [web_bgv addSubview:item.web];
    
    
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (self.type == protocolViewTypeList) {

        return nil;
    }
    WeakSelf
    ServiceProtocalSectionHeaderView *sectionView = [ServiceProtocalSectionHeaderView tableView:tableView  sectionViewWithProtocalItem:self.agreements[section]];
    sectionView.actionBlock = ^{
        
        [weakSelf headerViewClickWithSection:section];
    };
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.type == protocolViewTypeList) {

        return  [self.itemFrame.commentFrames[indexPath.row] floatValue] + 20;
    }
    ServiceProtocalItem *item = self.agreements[indexPath.section];
    return item.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (self.type == protocolViewTypeList) {

        return HEIGHT_ZERO;
    }
    return Section_header_Height_nomal;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return HEIGHT_ZERO;
}

#pragma mark : WKWebViewDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    decisionHandler(WKNavigationActionPolicyAllow);
    
}

// WKNavigationDelegate 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    WeakSelf
    [webView evaluateJavaScript:@"document.body.offsetHeight;" completionHandler:^(id Result, NSError * error) {
        
        NSString *web_height = [NSString stringWithFormat:@"%@",Result];
        
        ServiceProtocalItem *item = self.agreements[webView.tag];
        
        item.web.mj_h = [web_height floatValue];
        
        item.height = [web_height floatValue];
        
        [weakSelf.tableView reloadData];
        
    }];
    
}



#pragma mark :事件处理
- (void)pageClose{
    
    [self pageWithHiden:YES];
    
}

//商品详情
- (void)pageWithHiden:(BOOL)hiden{
    
    CGFloat alpha = hiden ? 0 : 0.8;
    CGFloat bg_y = hiden ? XSCREEN_HEIGHT : XSCREEN_HEIGHT * 0.5;
 
    //隐藏
    if (!hiden) {
        //显示
        self.view.alpha = 1;
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    }
        
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        
         self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:alpha];
        (self.type == protocolViewTypeList) ? ( self.bgView.mj_y =  bg_y) : 0;
 
    } completion:^(BOOL finished) {
        
        if (hiden) {
            self.view.alpha = 0;
        }
    }];
 
  
}

- (void)headerViewClickWithSection:(NSInteger)section{
    
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
 
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        [self.tableView setContentOffset:CGPointMake(0, -self.tableView.contentInset.top)];
    } completion:^(BOOL finished) {
        [self.tableView reloadData];
    }];
 
}

- (void)dealloc{
    
    KDClassLog(@"留学协议 + ServiceProtocolViewController + dealloc");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 
@end
