//
//  MessageDetailViewController.m
//  myOffer
//
//  Created by xuewuguojie on 16/1/18.
//  Copyright © 2016年 UVIC. All rights reserved.
//
/*
 UniDetailGroup *groupOne = [UniDetailGroup groupWithTitle:@"" contentes:sectionOne andFooter:NO];
 [self.groups addObject:groupOne];
 */


#define ZangFontSize 15
#import "MessageDetaillViewController.h"
#import "MessageDetailFrame.h"
#import "MessageCell.h"
#import "MessageDetailContentCell.h"
#import "ApplyViewController.h"
#import "XWGJMessageFrame.h"
#import "MyOfferArticle.h"
#import "ShareNViewController.h"
#import "MyOfferUniversityModel.h"
#import "UniItemFrame.h"
#import "UniversityCell.h"
#import "UniDetailGroup.h"
#import "UniversityViewController.h"
#import "HomeSectionHeaderView.h"
#import "MessageArticle.h"

@interface MessageDetaillViewController ()<UITableViewDelegate,UITableViewDataSource,WKNavigationDelegate,UMSocialUIDelegate>
@property(nonatomic,strong)UITableView *tableView;
//嵌套webView到Cell中
@property(nonatomic,strong)WKWebView *webView;
//请求返回数据字典
@property(nonatomic,strong)MessageArticle *ArticleInfo;
//点赞按钮
@property(nonatomic,strong)UIButton *ZangBtn;
//点分享按钮
@property(nonatomic,strong)UIButton *shareBtn;
//导航右边按钮
@property(nonatomic,strong)UIView *RightView;
//分享
@property(nonatomic,strong)ShareNViewController *shareVC;
//无数据提示框
@property(nonatomic,strong)XWGJnodataView *noDataView;
//数据源
@property(nonatomic,strong)NSMutableArray *groups;

@end

@implementation MessageDetaillViewController
-(instancetype)initWithMessageId:(NSString *)message_id{
    
    self = [super init];
    
    if (self) {
        
        self.message_id = message_id;
    }
    
    
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [MobClick beginLogPageView:@"page资讯详情"];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page资讯详情"];
    
}

-(NSMutableArray *)groups{
    
    if (!_groups) {
        
        _groups =[NSMutableArray array];
    }
    
    return _groups;
}


//自定义导航栏右侧按钮
-(UIView *)RightView
{
    if (!_RightView) {
        _RightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 40)];
        _RightView.hidden = YES;
        
        CGFloat Lx = 0;
        CGFloat Ly = 0;
        CGFloat Lw = _RightView.frame.size.width - 35;
        CGFloat Lh = 40;
        self.ZangBtn  = [[UIButton alloc] initWithFrame:CGRectMake(Lx,Ly, Lw, Lh)];
        [self.ZangBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.ZangBtn  setImage:[UIImage imageNamed:@"nav_likeHightLight"] forState:UIControlStateNormal];
        [self.ZangBtn  setImage:[UIImage imageNamed  :@"nav_likeNomal"] forState:UIControlStateDisabled];
        self.ZangBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.ZangBtn  addTarget:self action:@selector(ZangBtnClick)  forControlEvents:UIControlEventTouchUpInside];
        self.ZangBtn.titleEdgeInsets = UIEdgeInsetsMake(5, 10, 0, 0);
        self.ZangBtn.titleLabel.font =[UIFont systemFontOfSize:ZangFontSize];
        [_RightView addSubview:self.ZangBtn ];
        
        CGFloat Sy = 0;
        CGFloat Sw = 35;
        CGFloat Sh = 40;
        CGFloat Sx = _RightView.frame.size.width - Sw;
        self.shareBtn = [[UIButton alloc] initWithFrame:CGRectMake( Sx, Sy, Sw, Sh)];
        [self.shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
        [self.shareBtn  setImage:[UIImage imageNamed:@"nav_shareNomal"] forState:UIControlStateNormal];
        [self.shareBtn  setImage:[UIImage imageNamed:@"nav_shareHightLight"] forState:UIControlStateHighlighted];
        [_RightView addSubview:self.shareBtn];
        
    }
    
    return _RightView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
    
    [self makeDataSourse];
    
}

-(void)makeOtherView
{
    
    //没有数量是显示提示
    self.noDataView =[XWGJnodataView noDataView];
    self.noDataView.hidden = YES;
    self.noDataView.errorStr = @"网络请求失败，请稍候再试!";
    [self.view insertSubview:self.noDataView  aboveSubview:self.tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.RightView];
    
    
}



-(void)makeTableView
{
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, XSCREEN_HEIGHT - XNAV_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate =self;
    [self.view addSubview:self.tableView];
    
}

- (void)makeUI{
    
    [self makeTableView];
    
    [self makeWebView];
    
    [self makeOtherView];
    
}

- (void)makeWebView{
    
    WKWebView *web = [[WKWebView alloc] initWithFrame:self.view.bounds];
    web.scrollView.scrollEnabled = NO;
    web.navigationDelegate = self;
    self.webView = web;
    NSString *RequestString =[NSString stringWithFormat:@"%@api/article/%@/detail",DOMAINURL,self.message_id];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:RequestString]]];
    
}


-(void)makeDataSourse{
    
    XWeakSelf
    
    NSString *path =[NSString stringWithFormat:@"%@%@",kAPISelectorArticleDetail,self.message_id];
    
    [self startAPIRequestWithSelector:path parameters:nil expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:^{
        
        [weakSelf dismiss];
        
    } additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        [weakSelf updateUIWithMessage:response];
         
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        weakSelf.noDataView.hidden = NO;
        
    }];
    
}

-(void)updateUIWithMessage:(NSDictionary *)response{
    
    
    MessageArticle *article = [MessageArticle mj_objectWithKeyValues:response];
    
    self.ArticleInfo = article;

    
    self.ZangBtn.enabled = ![response[@"like"] integerValue];
    
    if ([response[@"like"] integerValue]) {
        
        [self.ZangBtn setTitleColor:XCOLOR_RED forState:UIControlStateNormal];
        
    }
    
    //根据点赞数量改变导航栏右侧相关控件宽度
    [self.ZangBtn  setTitle:article.like_count  forState:UIControlStateNormal];
    CGSize LikeCountSize =[article.like_count  KD_sizeWithAttributeFont:[UIFont systemFontOfSize:ZangFontSize]];
    
    CGRect NewRightFrame = self.RightView.frame;
    NewRightFrame.size.width += LikeCountSize.width;
    self.RightView.frame = NewRightFrame;
    
    CGRect NewShareFrame = self.shareBtn.frame;
    NewShareFrame.origin.x +=  LikeCountSize.width;
    self.shareBtn.frame = NewShareFrame;
    
    CGRect NewLoveFrame = self.ZangBtn.frame;
    NewLoveFrame.size.width +=  LikeCountSize.width;
    self.ZangBtn.frame = NewLoveFrame;
    
    
    
    //第一分组
    MessageDetailFrame *DetailFrame  = [MessageDetailFrame frameWithArticle:article];
    
    UniDetailGroup *groupOne = [UniDetailGroup groupWithTitle:@"" contentes:@[DetailFrame] andFooter:NO];
    [self.groups addObject:groupOne];
    
    //相关资讯 第二分组
    NSArray *recommendations  = article.recommendations;
    
    NSMutableArray *news_temps = [NSMutableArray array];
    for (MyOfferArticle *article in recommendations) {
        
        if(article.message_id != self.message_id){
            
            XWGJMessageFrame *newsFrame =  [XWGJMessageFrame messageFrameWithMessage:article];
            
            [news_temps addObject:newsFrame];
        }
    }
    UniDetailGroup *groupTwo = [UniDetailGroup groupWithTitle:@"相关文章" contentes:[news_temps copy] andFooter:NO];
    [self.groups addObject:groupTwo];
    
    
    //相关院校  大于第二分组
    NSMutableArray *neightbour_temps = [NSMutableArray array];
    
    [article.related_universities enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UniItemFrame *uniFrame = [UniItemFrame frameWithUniversity:(MyOfferUniversityModel *)obj];
        [neightbour_temps addObject:uniFrame];
        
        NSString *title = idx == 0 ? @"相关院校" : @"";
        NSArray *items = @[uniFrame];
        UniDetailGroup *group = [UniDetailGroup groupWithTitle:title contentes:items andFooter:YES];
        [self.groups addObject:group];
        
    }];
    
    
    [self.tableView reloadData];

}
#pragma mark : WKWebViewDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    
    [navigationAction.request.URL.absoluteString containsString:self.message_id] ? decisionHandler(WKNavigationActionPolicyAllow) : decisionHandler(WKNavigationActionPolicyCancel);
  
    /*
     *  WKNavigationActionPolicyAllow
     *  WKNavigationActionPolicyCancel   不允许
     */
}

// WKNavigationDelegate 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    
    [webView evaluateJavaScript:@"document.body.style.paddingBottom = '30px';" completionHandler:^(id Result, NSError * error) {
     }];
    
    
    XWeakSelf
    [webView evaluateJavaScript:@"document.body.offsetHeight;" completionHandler:^(id Result, NSError * error) {
        
        NSString *web_height = [NSString stringWithFormat:@"%@",Result];
        
        weakSelf.webView.mj_h = [web_height floatValue];
        
        [weakSelf.tableView reloadData];
        
    }];
    
    
    if (!webView.isLoading) {
        
        self.RightView.hidden = NO;
        
    }
    
}



#pragma mark :  UITableViewDataDeleage UITableViewDeleage
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    UniDetailGroup *group = self.groups[section];
    
    return group.HaveFooter ? PADDING_TABLEGROUP : HEIGHT_ZERO;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    UniDetailGroup *group = self.groups[section];
    
    return  group.HaveHeader ? 40 : HEIGHT_ZERO;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    UniDetailGroup *group = self.groups[section];
    
    HomeSectionHeaderView *sectionView = [HomeSectionHeaderView sectionHeaderViewWithTitle:group.HeaderTitle];
    
    return sectionView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    UniDetailGroup *group = self.groups[section];
    
    return group.items.count;
}
/**
 *  设置cell高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UniDetailGroup *group = self.groups[0];
    
    MessageDetailFrame *MessageDetailFrame   =  group.items[0];
    
    CGFloat cellHight = indexPath.section== 0 ?  self.webView.mj_h + MessageDetailFrame.MessageDetailHeight: Uni_Cell_Height;
    
    
    return cellHight;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UniDetailGroup *group = self.groups[indexPath.section];
    
    if (indexPath.section == 0) {
        
        MessageDetailFrame *MessageDetailFrame   =  group.items[0];
        MessageDetailContentCell *cell = [MessageDetailContentCell CreateCellWithTableView:tableView];
        cell.MessageFrame = group.items[0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIScrollView *web_bgv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MessageDetailFrame.MessageDetailHeight , self.view.bounds.size.width, 0)];
        web_bgv.scrollEnabled = NO;
        [cell.contentView addSubview:web_bgv];
        
        
        web_bgv.contentSize =  CGSizeMake(cell.bounds.size.width, self.webView.bounds.size.height);
        web_bgv.mj_h = self.webView.bounds.size.height;
        
        
        [web_bgv addSubview:self.webView];
        
        
        return cell;
        
        
    }else if(indexPath.section == 1){
        
        MessageCell *news_cell =[MessageCell cellWithTableView:tableView];
        news_cell.messageFrame =  group.items[indexPath.row];
        return news_cell;
        
    }else{
        
        UniversityCell *uni_cell =[UniversityCell cellWithTableView:tableView];
        uni_cell.itemFrame = group.items[indexPath.row];
        
        return uni_cell;
        
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0) return;
    
    UniDetailGroup *group = self.groups[indexPath.section];
    
    if ([group.HeaderTitle containsString:@"文章"]) {
        
        XWGJMessageFrame *newsFrame  = group.items[indexPath.row];
        
        [self.navigationController pushViewController:[[MessageDetaillViewController alloc] initWithMessageId:newsFrame.News.message_id] animated:YES];
        
    }else{
        
        UniItemFrame *uniFrame   = group.items[indexPath.row];
        [self.navigationController pushViewController:[[UniversityViewController alloc] initWithUniversityId:uniFrame.item.NO_id] animated:YES];
    }
    
}


//点赞
-(void)ZangBtnClick
{
    XWeakSelf
    NSString *path =[NSString stringWithFormat:kAPISelectorMessageZang,self.message_id];
    [self startAPIRequestWithSelector:path  parameters:nil success:^(NSInteger statusCode, id response) {
        
        NSString *LikeCount = self.ZangBtn.currentTitle;
        [weakSelf.ZangBtn setTitle:[NSString stringWithFormat:@"%ld",(long)LikeCount.integerValue + 1]  forState:UIControlStateNormal];
        [weakSelf.ZangBtn setTitleColor:XCOLOR_RED forState:UIControlStateNormal];
        
        weakSelf.ZangBtn.enabled = NO;
        
    }];
}


//弹出列表方法presentSnsIconSheetView需要设置delegate为self
-(BOOL)isDirectShareInIconActionSheet
{
    return YES;
}


- (ShareNViewController *)shareVC{
    
    if (!_shareVC) {
        
        NSString *shareURL = [NSString stringWithFormat:@"http://www.myoffer.cn/article/%@",self.message_id];
        NSString *path = self.ArticleInfo.cover_url;
        NSString *shareTitle = self.ArticleInfo.title;
        NSString *shareContent = self.ArticleInfo.summary;
        NSMutableDictionary *shareInfor = [NSMutableDictionary dictionary];
        [shareInfor setValue:shareURL forKey:@"shareURL"];
        [shareInfor setValue:path forKey:@"icon"];
        [shareInfor setValue:shareTitle forKey:@"shareTitle"];
        [shareInfor setValue:shareContent forKey:@"shareContent"];
        
        
        _shareVC = [ShareNViewController shareView];
        _shareVC.shareInfor = shareInfor;
        
        [self addChildViewController:_shareVC];
        [self.view addSubview:self.shareVC.view];
        
    }
    
    return _shareVC;
}


//分享
- (void)share{
    
    [self.shareVC  show];
    
}

-(void)dealloc
{
    KDClassLog(@"资讯详情  dealloc");
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}




@end
