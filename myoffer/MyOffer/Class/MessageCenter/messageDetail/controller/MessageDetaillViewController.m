//
//  MessageDetailViewController.m
//  myOffer
//
//  Created by xuewuguojie on 16/1/18.
//  Copyright © 2016年 UVIC. All rights reserved.
//



#define ZangFontSize 15
#import "MessageDetaillViewController.h"
#import "MessageDetailFrame.h"
#import "MessageCell.h"
#import "XWGJMessageFrame.h"
#import "MyOfferArticle.h"
#import "ShareNViewController.h"
#import "MyOfferUniversityModel.h"
#import "UniverstityTCell.h"
#import "UniversityViewController.h"
#import "HomeSectionHeaderView.h"
#import "MessageArticle.h"
#import "MyOfferServerMallViewController.h"
#import "MessageDetailHeaderView.h"

@interface MessageDetaillViewController ()<UITableViewDelegate,UITableViewDataSource,WKNavigationDelegate>
@property(nonatomic,strong)MyOfferTableView *tableView;
@property(nonatomic,strong)WKWebView *webView;//嵌套webView到Cell中
@property(nonatomic,strong)MessageArticle *articleModel;//请求返回数据字典
@property(nonatomic,strong)UIButton *ZangBtn;//点赞按钮
@property(nonatomic,strong)UIButton *shareBtn;//点分享按钮
@property(nonatomic,strong)MessageDetailHeaderView *headerView;
@property(nonatomic,strong)UILabel *countLab;
@property(nonatomic,strong)UIView *RightView;//导航右边按钮
@property(nonatomic,strong)ShareNViewController *shareVC;//分享
@property(nonatomic,strong)NSMutableArray *groups;//数据源

@end

@implementation MessageDetaillViewController

- (instancetype)initWithMessageId:(NSString *)message_id{
    
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

- (MessageDetailHeaderView *)headerView{
    
    if (!_headerView) {
        _headerView = [MessageDetailHeaderView new];
    }
    return _headerView;
}

- (ShareNViewController *)shareVC{
    
    if (!_shareVC) {
        
        NSString *shareURL = [NSString stringWithFormat:@"http://www.myoffer.cn/article/%@",self.message_id];
        NSString *path = self.articleModel.cover_url;
        NSString *shareTitle = self.articleModel.title;
        NSString *shareContent = self.articleModel.summary;
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



//自定义导航栏右侧按钮
-(UIView *)RightView
{
    if (!_RightView) {
        _RightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        _RightView.hidden = YES;
        
        CGFloat Lx = 0;
        CGFloat Ly = 0;
        CGFloat Lw = 40;
        CGFloat Lh = 40;
        self.ZangBtn  = [[UIButton alloc] initWithFrame:CGRectMake(Lx,Ly, Lw, Lh)];
        [self.ZangBtn  setImage:[UIImage imageNamed:@"nav_zang_HightLight"] forState:UIControlStateNormal];
        [self.ZangBtn  setImage:[UIImage imageNamed:@"nav_zang"] forState:UIControlStateDisabled];
        [self.ZangBtn  addTarget:self action:@selector(ZangBtnClick:)  forControlEvents:UIControlEventTouchUpInside];
        [_RightView addSubview:self.ZangBtn ];
        
        UILabel *countLab = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 20, 40)];
        self.countLab = countLab;
        countLab.textColor = XCOLOR_WHITE;
        countLab.font = XFONT(ZangFontSize);
        [_RightView addSubview:countLab];
        
        CGFloat Sy = 0;
        CGFloat Sx = 60;
        CGFloat Sw = 40;
        CGFloat Sh = 40;
        self.shareBtn = [[UIButton alloc] initWithFrame:CGRectMake( Sx, Sy, Sw, Sh)];
        [self.shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
        [self.shareBtn  setImage:[UIImage imageNamed:@"Uni_share"] forState:UIControlStateNormal];
        [_RightView addSubview:self.shareBtn];
        
    }
    
    return _RightView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self makeUI];
    [self makeDataSourse];
    
}

- (void)makeTableView
{
    self.tableView =[[MyOfferTableView alloc] initWithFrame:self.view.bounds  style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate =self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0,XNAV_HEIGHT, 0);
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}

- (void)makeUI{
    
    [self makeTableView];
    [self makeWebView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.RightView];
    
}

- (void)makeWebView{
    
    WKWebView *web = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, 0)];
    web.scrollView.scrollEnabled = NO;
    web.navigationDelegate = self;
    self.webView = web;
    NSString *RequestString =[NSString stringWithFormat:@"%@api/article/%@/detail",DOMAINURL,self.message_id];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:RequestString]]];
    
}

#pragma mark : 网络请求

- (void)makeDataSourse{
    
    WeakSelf
    
    NSString *path =[NSString stringWithFormat:@"%@%@",kAPISelectorArticleDetail,self.message_id];
    
    [self startAPIRequestWithSelector:path parameters:nil expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:^{
    } additionalSuccessAction:^(NSInteger statusCode, id response) {
        [weakSelf updateUIWithMessage:response];
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        [weakSelf.tableView emptyViewWithError:NetRequest_ConnectError];
    }];
    
}

-(void)updateUIWithMessage:(NSDictionary *)response{
    
    MessageArticle *article = [MessageArticle mj_objectWithKeyValues:response];
    self.articleModel = article;
    MessageDetailFrame *DetailFrame  = [MessageDetailFrame frameWithArticle:article];

    
    //根据点赞数量改变导航栏右侧相关控件宽度
    self.ZangBtn.enabled = !response[@"like"];
    self.countLab.text = article.like_count;
    
    //设置表头
    self.headerView.MessageFrame = DetailFrame;
    self.tableView.tableHeaderView = self.headerView;
    
    //1 第一分组
    myofferGroupModel *groupOne = [myofferGroupModel groupWithItems:@[DetailFrame]  header:nil footer:nil];
    groupOne.type = SectionGroupTypeA;
    [self.groups addObject:groupOne];
 
    //2 相关资讯 第二分组
    NSArray *recommendations  = article.recommendations;
    NSMutableArray *news_temps = [NSMutableArray array];
    for (MyOfferArticle *article in recommendations) {
        if(article.message_id != self.message_id){
            XWGJMessageFrame *newsFrame =  [XWGJMessageFrame messageFrameWithMessage:article];
            [news_temps addObject:newsFrame];
        }
    }
    
    if (news_temps.count > 0) {

        myofferGroupModel *article_group = [myofferGroupModel groupWithItems:[news_temps copy]  header:@"相关文章" footer:nil];
        article_group.type = SectionGroupTypeB;
        [self.groups addObject:article_group];
     }
    
    
    //3 相关院校  大于第二分组
    
    [article.related_universities enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UniversityFrameNew *uniFrame = [UniversityFrameNew universityFrameWithUniverstiy: (MyOfferUniversityModel*)obj];
        NSString *title = (idx == 0) ? @"相关院校" : @"";
                myofferGroupModel *uni_group = [myofferGroupModel groupWithItems:@[uniFrame] header:title footer:nil];
        uni_group.section_footer_height = Section_footer_Height_nomal;
        uni_group.type = SectionGroupTypeC;
        [self.groups addObject:uni_group];
        
    }];
    
    [self.tableView reloadData];

}
#pragma mark : WKWebViewDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    NSString *path  = navigationAction.request.URL.absoluteString;
    
    if ([path containsString:self.message_id] ) {
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
 
    NSString *article_rule =@"^http(s)?://www.(myofferdemo.com|myoffer.cn)/article/[0-9]+.html";
    NSString *uni_rule =@"^http(s)?://www.(myofferdemo.com|myoffer.cn)/university/[0-9]+.html";
    NSString *emall_path = @"emall/index.html";

    if([self matchWithPath:path rule:article_rule]){
        
        NSArray *arr = [path componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"./"]];
        if(arr.count > 2){
            
            NSString *url_path = [NSString stringWithFormat:@"GET api/article/short-id/%@",arr[arr.count-2]];
            WeakSelf
            [self startAPIRequestWithSelector:url_path parameters:nil expectedStatusCodes:nil showHUD:NO showErrorAlert:NO errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
                MessageDetaillViewController *detail = [[MessageDetaillViewController alloc] initWithMessageId:response[@"id"]] ;
                [weakSelf.navigationController pushViewController:detail animated:YES];
            } additionalFailureAction:nil];
        }
        
    }else if([self matchWithPath:path rule:uni_rule]){
 
        NSArray *arr = [path componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"./"]];
        if(arr.count > 2){
            [self.navigationController pushViewController:[[UniversityViewController alloc] initWithUniversityId:arr[arr.count-2]] animated:YES];
        }
        
    }else if([path hasSuffix:emall_path]){
        
        [self.navigationController pushViewController:[[MyOfferServerMallViewController alloc] init] animated:YES];
    }
 
    decisionHandler(WKNavigationActionPolicyCancel);
 
    /*
     *  WKNavigationActionPolicyAllow
     *  WKNavigationActionPolicyCancel   不允许
     */
}

// 正则表达式匹配 网页链接
- (BOOL)matchWithPath:(NSString *)path rule:(NSString *)rule{
    
     NSPredicate *article_pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",rule];
    return [article_pre evaluateWithObject:path];
}


// WKNavigationDelegate 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
    WeakSelf
    [webView evaluateJavaScript:@"document.body.style.paddingBottom = '30px'; document.body.offsetHeight;" completionHandler:^(id Result, NSError * error) {
        
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
    
    myofferGroupModel *group = self.groups[section];
    return group.section_footer_height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    myofferGroupModel *group = self.groups[section];
    return  group.section_header_height;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    myofferGroupModel *group = self.groups[section];
    HomeSectionHeaderView *sectionView = [HomeSectionHeaderView sectionHeaderViewWithTitle:group.header_title];
    return sectionView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    myofferGroupModel *group = self.groups[section];
    return group.items.count;
}
/**
 *  设置cell高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    myofferGroupModel *group = self.groups[indexPath.section];
    CGFloat cellHeight = 0;
    switch (group.type) {
        case SectionGroupTypeA:{
            cellHeight = self.webView.mj_h;
        }
            break;
        case SectionGroupTypeB:{
            XWGJMessageFrame   *messageFrame =  group.items[indexPath.row];
            cellHeight = messageFrame.cell_Height;
        }
            break;
        case SectionGroupTypeC:{
            UniversityFrameNew  *uniFrame = group.items[indexPath.row];
            cellHeight = uniFrame.cell_Height;
        }
            break;
        default:
            break;
    }
    
    return cellHeight;
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    myofferGroupModel *group = self.groups[indexPath.section];
    switch (group.type) {
        case SectionGroupTypeA:{
           
            UITableViewCell  *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIScrollView *web_bg = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, 0)];
            web_bg.scrollEnabled = NO;
            [cell.contentView addSubview:web_bg];
            web_bg.contentSize =  CGSizeMake(cell.bounds.size.width, self.webView.bounds.size.height);
            web_bg.mj_h = self.webView.bounds.size.height;
            [web_bg addSubview:self.webView];
            
            return cell;
        }
            break;
            
            
        case SectionGroupTypeB:{
            
            MessageCell *news_cell =[MessageCell cellWithTableView:tableView];
            news_cell.messageFrame =  group.items[indexPath.row];
            BOOL show =  !(group.items.count - 1 == indexPath.row);
            [news_cell separatorLineShow:show];
            
            return news_cell;
        }
            break;
            
        default:{
        
            UniverstityTCell *uni_cell = [UniverstityTCell cellViewWithTableView:tableView];
            uni_cell.uniFrame = group.items[indexPath.row];
            [uni_cell separatorLineShow:NO];
            return uni_cell;
        }
            break;
    }
    
 
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0) return;
    
    myofferGroupModel *group = self.groups[indexPath.section];
    
    UIViewController *VC = [UIViewController new];
    switch (group.type) {
        case SectionGroupTypeB:
        {
            XWGJMessageFrame *newsFrame  = group.items[indexPath.row];
            VC = [[MessageDetaillViewController alloc] initWithMessageId:newsFrame.News.message_id];
        }
            break;
        case SectionGroupTypeC:
        {
            UniversityFrameNew *uniFrame   = group.items[indexPath.row];
            VC = [[UniversityViewController alloc] initWithUniversityId:uniFrame.universtiy.NO_id] ;
        }
            break;
        default:
            break;
    }
    
    [self.navigationController pushViewController:VC animated:YES];

}

#pragma mark : 事件处理
//点赞
-(void)ZangBtnClick:(UIButton *)sender
{
    WeakSelf
    NSString *path =[NSString stringWithFormat:kAPISelectorMessageZang,self.message_id];
    [self startAPIRequestWithSelector:path  parameters:nil success:^(NSInteger statusCode, id response) {
        
        NSString *LikeCount = self.countLab.text;
        weakSelf.countLab.text = [NSString stringWithFormat:@"%ld",(long)LikeCount.integerValue + 1];
        sender.enabled = NO;
        
    }];
}

//弹出列表方法presentSnsIconSheetView需要设置delegate为self
-(BOOL)isDirectShareInIconActionSheet
{
    return YES;
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
