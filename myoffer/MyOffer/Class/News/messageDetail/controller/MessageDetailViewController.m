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
#import "MessageDetailViewController.h"
#import "MessageDetailFrame.h"
#import "XWGJMessageTableViewCell.h"
#import "MessageDetailContentCell.h"
#import "ApplyViewController.h"
#import "XWGJMessageFrame.h"
#import "NewsItem.h"
#import <WebKit/WebKit.h>
#import "ShareViewController.h"
#import "UniversityItemNew.h"
#import "UniItemFrame.h"
#import "UniversityCell.h"
#import "UniDetailGroup.h"
#import "UniversityViewController.h"
#import "HomeSectionHeaderView.h"

@interface MessageDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,UMSocialUIDelegate,WKNavigationDelegate>
@property(nonatomic,strong)UITableView *tableView;
//嵌套webView到Cell中
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,strong)WKWebView *web_wk;
//请求返回数据字典
@property(nonatomic,strong)NSDictionary *ArticleInfo;
// 点赞按钮
@property(nonatomic,strong)UIButton *ZangBtn;
//点分享按钮
@property(nonatomic,strong)UIButton *shareBtn;
//导航右边按钮
@property(nonatomic,strong)UIView *RightView;

@property(nonatomic,strong)KDProgressHUD *hud;
//分享
@property(nonatomic,strong)ShareViewController *shareVC;
//无数据提示框
@property(nonatomic,strong)XWGJnodataView *noDataView;
//导航栏下图片
@property(nonatomic,strong)UIImageView *navImageView;
//数据源
@property(nonatomic,strong)NSMutableArray *groups;

@end

@implementation MessageDetailViewController

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
     self.noDataView.contentLabel.text = @"网络请求失败，请稍候再试!";
     [self.view insertSubview:self.noDataView  aboveSubview:self.tableView];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.RightView];
    
    if (self.navigationBgImage) {
        self.navImageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, -64, XScreenWidth, 64)];
        self.navImageView.clipsToBounds = YES;
        self.navImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.navImageView.image = self.navigationBgImage;
        [self.view addSubview:self.navImageView];
        
    }

}



-(void)makeWebView
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        self.web_wk = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, XScreenWidth, 1)];
        NSString *RequestString =[NSString stringWithFormat:@"%@api/article/%@/detail",DOMAINURL,self.NO_ID];
        [self.web_wk loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:RequestString]]];
        self.web_wk.scrollView.scrollEnabled = NO;
        self.web_wk.userInteractionEnabled = NO;
        [self.web_wk sizeToFit];
        self.web_wk.navigationDelegate = self;
        
    }else{
    
        self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, XScreenWidth, 1)];
        self.webView.delegate = self;
        self.webView.scrollView.scrollEnabled = NO;
        self.webView.userInteractionEnabled = NO;
        [self.webView sizeToFit];
        NSString *RequestString =[NSString stringWithFormat:@"%@api/article/%@/detail",DOMAINURL,self.NO_ID];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:RequestString]]];
     }
    
   
}
-(void)makeTableView
{
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, XScreenWidth, XScreenHeight - NAV_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate =self;
    self.tableView.alpha = 0.1;
    [self.view addSubview:self.tableView];
    
}

-(void)makeUI
{
    
    [self makeTableView];
    
    [self makeWebView];
    
    [self makeOtherView];
    
}

-(void)makeDataSourse
{
    
    XJHUtilDefineWeakSelfRef
    
 
    NSString *testpath =[NSString stringWithFormat:@"GET api/v2/article/%@",self.NO_ID];
    
    [self startAPIRequestWithSelector:testpath parameters:nil expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:^{
        
        [weakSelf dismiss];
        
    } additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        
        [UIView animateWithDuration:0.2 animations:^{
           
            weakSelf.tableView.alpha = 1;

        }];
        
        
        [weakSelf makeUIWithMessageDictionary:response];
        
        [weakSelf.tableView reloadData];

    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        weakSelf.noDataView.hidden = NO;
        
    }];
   
}

-(void)makeUIWithMessageDictionary:(NSDictionary *)response{
    
    
    self.ZangBtn.enabled = ![response[@"like"] integerValue];
    
    if ([response[@"like"] integerValue]) {
        
        [self.ZangBtn setTitleColor:XCOLOR_RED forState:UIControlStateNormal];
        
    }
    
    //根据点赞数量改变导航栏右侧相关控件宽度
    [self.ZangBtn  setTitle:[NSString  stringWithFormat:@"%@",response[@"like_count"]]  forState:UIControlStateNormal];
    CGSize LikeCountSize =[[NSString  stringWithFormat:@"%@",response[@"like_count"]]  KD_sizeWithAttributeFont:[UIFont systemFontOfSize:ZangFontSize]];
    
    CGRect NewRightFrame = self.RightView.frame;
    NewRightFrame.size.width += LikeCountSize.width;
    self.RightView.frame = NewRightFrame;
    
    CGRect NewShareFrame = self.shareBtn.frame;
    NewShareFrame.origin.x +=  LikeCountSize.width;
    self.shareBtn.frame = NewShareFrame;
    
    CGRect NewLoveFrame = self.ZangBtn.frame;
    NewLoveFrame.size.width +=  LikeCountSize.width;
    self.ZangBtn.frame = NewLoveFrame;
    
    
    self.ArticleInfo = (NSDictionary *)response;
    
    //第一分组
    MessageDetailFrame *DetailFrame  = [MessageDetailFrame frameWithDictionary:(NSDictionary *)response];
    UniDetailGroup *groupOne = [UniDetailGroup groupWithTitle:@"" contentes:@[DetailFrame] andFooter:NO];
    [self.groups addObject:groupOne];
    
    //相关资讯 第二分组
    NSArray *newses  = [NewsItem mj_objectArrayWithKeyValuesArray:response[@"recommendations"]];
    NSMutableArray *news_temps = [NSMutableArray array];
    for (NewsItem *news in newses) {
        if(news.messageID != self.NO_ID){
            XWGJMessageFrame *newsFrame =  [XWGJMessageFrame messageFrameWithMessage:news];
            [news_temps addObject:newsFrame];
        }
    }
    UniDetailGroup *groupTwo = [UniDetailGroup groupWithTitle:@"相关文章" contentes:[news_temps copy] andFooter:NO];
    [self.groups addObject:groupTwo];
    
    
    //相关院校  大于第二分组
    NSMutableArray *neightbour_temps = [NSMutableArray array];
    [response[@"related_universities"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UniversityItemNew *uni = [UniversityItemNew mj_objectWithKeyValues:obj];
        UniItemFrame *uniFrame = [UniItemFrame frameWithUniversity:uni];
        [neightbour_temps addObject:uniFrame];
        
        NSString *title = idx == 0 ? @"相关院校" : @"";
        NSArray *items = @[uniFrame];
        UniDetailGroup *group = [UniDetailGroup groupWithTitle:title contentes:items andFooter:YES];
        [self.groups addObject:group];
        
    }];
    
  
}




#pragma mark ——————  WKWebViewDeleage
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
  
     self.hud = [KDProgressHUD showHUDAddedTo:self.view animated:YES];
    
     [self.hud removeFromSuperViewOnHide];

}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    CGRect frame = webView.frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    
    [webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id obj, NSError * _Nullable error) {
       
        
        NSInteger height = [(NSString *)obj integerValue];
     
        self.web_wk.frame = CGRectMake(0, 0,XScreenWidth,height);
  
        [self.tableView reloadData];
            
        
    }];
    
    //加载完成后重新设置 tableview的cell的高度,和webview的frame
    if (!webView.isLoading) {
        
        self.RightView.hidden = NO;
        
        [self.hud hideAnimated:YES afterDelay:1];
    }

}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
    [self.hud hideAnimated:YES afterDelay:1];

}

#pragma mark ——————  UIWebViewDeleage
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
    self.hud = [KDProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.hud removeFromSuperViewOnHide];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGRect frame = webView.frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    
    NSInteger height = [[webView stringByEvaluatingJavaScriptFromString:
                         @"document.body.scrollHeight"] integerValue];
    self.webView.frame = CGRectMake(0, 0,XScreenWidth,height);
    
     self.tableView.alpha = 1;
    [self.tableView reloadData];
    
    //加载完成后重新设置 tableview的cell的高度,和webview的frame
    if (!webView.isLoading) {
        
        self.RightView.hidden = NO;

        [self.hud hideAnimated:YES afterDelay:1];
    }

    
}


//用于设置网页快捷链接跳转
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(nonnull NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
     NSURL  *url = request.URL;
    
    NSString *URLstr = [NSString stringWithFormat:@"%@",url];
    
    
    
    if ([URLstr containsString:@"api/article"]) {
        
        return YES;
        
    }else{
          //用于设置网页快捷链接跳转到自带浏览器
//          [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
        
    }
    
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    [self.hud hideAnimated:YES afterDelay:1];
 
}



#pragma mark —————— UITableViewDataDeleage UITableViewDeleage
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    UniDetailGroup *group = self.groups[section];
    
    return group.HaveFooter ? PADDING_TABLEGROUP : HEIGHT_ZERO;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    UniDetailGroup *group = self.groups[section];
    
    return  group.HaveHeader ? 40 : HEIGHT_ZERO;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HomeSectionHeaderView *sectionView = [[HomeSectionHeaderView alloc] init];
    
    UniDetailGroup *group = self.groups[section];
    
    sectionView.TitleLab.text = group.HeaderTitle;
    
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
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        CGFloat cellHight = indexPath.section==0 ? MessageDetailFrame.MessageDetailHeight + self.web_wk.frame.size.height : University_HEIGHT;
        
        return cellHight;
    }else{
        
        CGFloat cellHight = indexPath.section==0 ? MessageDetailFrame.MessageDetailHeight + self.webView.frame.size.height : University_HEIGHT;
        
        return cellHight;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UniDetailGroup *group = self.groups[indexPath.section];
    
    if (indexPath.section == 0) {
        MessageDetailFrame *MessageDetailFrame   =  group.items[0];

            MessageDetailContentCell *cell = [MessageDetailContentCell CreateCellWithTableView:tableView];
            cell.MessageFrame = group.items[0];

            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
            {
                self.web_wk.frame = CGRectMake(0, MessageDetailFrame.MessageDetailHeight, APPSIZE.width,self.web_wk.frame.size.height);
                [cell.contentView addSubview:self.web_wk];

            }else{
                self.webView.frame = CGRectMake(0, MessageDetailFrame.MessageDetailHeight, APPSIZE.width,self.webView.frame.size.height);
                [cell.contentView addSubview:self.webView];

            }

            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
            return cell;
        
        
    }else if(indexPath.section == 1){
        
        XWGJMessageTableViewCell *news_cell =[XWGJMessageTableViewCell cellWithTableView:tableView];
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
        MessageDetailViewController *detail  =[[MessageDetailViewController alloc] init];
        detail.NO_ID = newsFrame.News.messageID;
        [self.navigationController pushViewController:detail animated:YES];
        
    }else{
        UniItemFrame *uniFrame   = group.items[indexPath.row];
        UniversityViewController *Uni  =[[UniversityViewController alloc] init];
        Uni.uni_id =  uniFrame.item.NO_id;
        [self.navigationController pushViewController:Uni animated:YES];
    }
    
}


//点赞
-(void)ZangBtnClick
{
    XJHUtilDefineWeakSelfRef
    NSString *path =[NSString stringWithFormat:@"GET api/article/%@/like",self.NO_ID];
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

- (ShareViewController *)shareVC{
    
    if (!_shareVC) {
        
        NSString *shareURL = [NSString stringWithFormat:@"http://www.myoffer.cn/article/%@",self.NO_ID];
        NSString *path = [self.ArticleInfo[@"cover_url"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *shareTitle = self.ArticleInfo[@"title"];
        NSString *shareContent = self.ArticleInfo[@"summary"];
        NSMutableDictionary *shareInfor = [NSMutableDictionary dictionary];
        [shareInfor setValue:shareURL forKey:@"shareURL"];
        [shareInfor setValue:path forKey:@"icon"];
        [shareInfor setValue:shareTitle forKey:@"shareTitle"];
        [shareInfor setValue:shareContent forKey:@"shareContent"];
        
        XJHUtilDefineWeakSelfRef
        _shareVC = [[ShareViewController alloc] init];
        _shareVC.shareInfor = shareInfor;
        _shareVC.actionBlock = ^{
            
            [weakSelf.shareVC.view removeFromSuperview];
            
        };
        [self.view addSubview:_shareVC.view];

        [self addChildViewController:_shareVC];
        
    }
    return _shareVC;
}


//分享
- (void)share{
    
    if (_shareVC.view.superview != self.view) {
        
        [self.view addSubview:_shareVC.view];
        
        [self.shareVC  show];
    }
    
}


-(void)dealloc
{
    KDClassLog(@" MessageDetailViewController    dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
