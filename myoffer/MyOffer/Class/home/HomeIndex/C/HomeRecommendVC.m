//
//  HomeRecommendVC.m
//  newOffer
//
//  Created by xuewuguojie on 2018/6/4.
//  Copyright © 2018年 徐金辉. All rights reserved.
//

#import "HomeRecommendVC.h"
#import "HomeSecView.h"
#import "HomeRecommendArtCell.h"
#import "HomeHotVideoCell.h"
#import "HomeRecommendActivityCell.h"
#import "SDCycleScrollView.h"
#import "myofferGroupModel.h"
#import "MyofferFooterView.h"
#import "ServiceSKU.h"
#import "MessageDetaillViewController.h"
#import "ServiceItemViewController.h"
#import "SMDetailViewController.h"
#import "SuperMasterViewController.h"
#import "MyOfferServerMallViewController.h"
#import "HomeRecommendProdoctView.h"

@interface HomeRecommendVC ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *groups;
@property(nonatomic,strong)SDCycleScrollView *bannerView;
@property(nonatomic,strong)UIView *header;
@property(nonatomic,strong)HomeRecommendProdoctView *productView;
@property(nonatomic,assign)CGFloat commoditie_height;
@property(nonatomic,assign)NSInteger request_count;

@end

@implementation HomeRecommendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeUI];
    [self makeBannerData];
    [self makeData];
}

- (NSArray *)groups{
    
    if (!_groups) {
        
        myofferGroupModel *commodity  = [myofferGroupModel groupWithItems:nil header:@"热门商品"];
        commodity.accesory_title= @"查看更多";
        commodity.type = SectionGroupTypeHotCommodities;
        myofferGroupModel *activity  = [myofferGroupModel groupWithItems:nil header:@"热门活动"];
        activity.type = SectionGroupTypePopularActivity;
        myofferGroupModel *video  = [myofferGroupModel groupWithItems:nil header:@"热门视频"];
        video.type = SectionGroupTypeHotVideo;
        video.accesory_title= @"查看更多";
        myofferGroupModel *article  = [myofferGroupModel groupWithItems:nil header:@"文章栏目"];
        article.type = SectionGroupTypeArticleColumn;
        article.accesory_title= @"查看更多";
        _groups = @[commodity,activity,video,article];
    }
    
    return _groups;
}

- (UIView *)header{
    
    if (!_header) {
        
        CGFloat header_w = XSCREEN_WIDTH - 40;
        CGFloat header_h =  39 * header_w / 75  + 20;
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, header_w, header_h)];
        self.header = header;
        header.backgroundColor = XCOLOR_WHITE;
    }
    
    return _header;
}

- (void)makeData{
    [self makeHotProducts];
    [self makeHotActivity];
    [self makeHotVideo];
    [self makeHotArticle];
}
/*-----------banner----------*/
- (void)makeBannerData{
    WeakSelf;
    NSString *path = [NSString stringWithFormat:@"GET %@svc/app/banner",DOMAINURL_API];
    [self startAPIRequestWithSelector:path parameters:nil success:^(NSInteger statusCode, id response) {
        [weakSelf makBannerViewWithResponse:response];
    }];
}
- (void)makBannerViewWithResponse:(id)response{
    
    if (!ResponseIsOK) {
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0.001)];
        return;
    }
    NSArray *items = response[@"result"];
    if (items.count == 0) {
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0.001)];
        return;
    }
    
    NSArray *cover_url_arr = (NSArray *)[items valueForKeyPath:@"cover_url"];
    NSMutableArray *cover_arr = [NSMutableArray array];
    [cover_url_arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *item = (NSString *)obj;
        item = [item stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [cover_arr addObject:item];
    }];
    if (!self.bannerView) {
        CGFloat b_x = 20;
        CGFloat b_w = XSCREEN_WIDTH - b_x * 2;
        CGFloat b_h = b_w * 316.0/668;
        CGRect banner_frame = CGRectMake(b_x, 0, b_w,b_h);
        self.bannerView = [SDCycleScrollView  cycleScrollViewWithFrame:banner_frame delegate:self placeholderImage:nil];
        [self.header addSubview:self.bannerView];
        self.bannerView.placeholderImage =   [UIImage imageNamed:@"PlaceHolderImage"];
        self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        self.bannerView.layer.cornerRadius = CORNER_RADIUS;
        self.bannerView.layer.masksToBounds = YES;
        WeakSelf
        self.bannerView.clickItemOperationBlock = ^(NSInteger index) {
            NSDictionary *item  = items[index];
            [weakSelf CaseLandingPage:item[@"url"]];
        };
        self.header.mj_h = (b_h + 20);
        self.tableView.tableHeaderView = self.header;
    }
    self.bannerView.imageURLStringsGroup = cover_arr;
}
/*-----------banner----------*/
/*-----------hotProducts----------*/
- (void)makeHotProducts{
    WeakSelf;
    NSString *path = [NSString stringWithFormat:@"GET %@svc/app/hotProducts/3",DOMAINURL_API];
//    [self startAPIRequestWithSelector:path parameters:nil success:^(NSInteger statusCode, id response) {
//        [weakSelf makHotProductsWithResponse:response];
//    }];
    [self startAPIRequestWithSelector:path
                           parameters:nil expectedStatusCodes:nil showHUD:NO showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
                               [weakSelf makHotProductsWithResponse:response];
                           } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
                               [weakSelf caseEmpty];
                           }];
    
}
- (void)makHotProductsWithResponse:(id)response{
    
    if (!ResponseIsOK) {
        [self caseEmpty];
        return;
    }
    
    NSArray *items = response[@"result"];
    if (items.count == 0)  {
        [self caseEmpty];
        return;
    }
    [self caseEmpty];
    NSArray *skus = [ServiceSKU mj_objectArrayWithKeyValuesArray:items];
    [self reloadWithItems:@[skus] type:SectionGroupTypeHotCommodities];
    
}
- (void)caseSKU:(NSString *)sku_id{
    
    ServiceItemViewController *vc =[[ServiceItemViewController alloc] init];
    vc.service_id = sku_id;
    PushToViewController(vc);
}
/*-----------hotProducts----------*/
/*-----------hotActivity----------*/
- (void)makeHotActivity{
    WeakSelf;
    NSString *path = [NSString stringWithFormat:@"GET %@svc/app/hotActivity/app",DOMAINURL_API];
//    [self startAPIRequestWithSelector:path parameters:nil success:^(NSInteger statusCode, id response) {
//        [weakSelf makHotActivityWithResponse:response];
//    }];
    [self startAPIRequestWithSelector:path
                           parameters:nil expectedStatusCodes:nil showHUD:NO showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
                               [weakSelf makHotActivityWithResponse:response];
                           } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
                               [weakSelf caseEmpty];
                           }];
}
- (void)makHotActivityWithResponse:(id)response{
    if (!ResponseIsOK) {
        [self caseEmpty];
        return;
    }
    NSArray *items = response[@"result"];
    if (items.count == 0) {
        [self caseEmpty];
        return;
    }
    [self caseEmpty];
    [self reloadWithItems:@[items] type:SectionGroupTypePopularActivity];
}

- (void)caseActivity:(NSString *)url{
    
    if ([url isEqualToString:@"caseInvitation"]) {
        [self caseInvitation];
        return;
    }
    
    NSString *app_pre = @"app://";
    //url 包含 app://跳转 ServiceItemViewController
    if ([url containsString:app_pre]) {
        
        NSString *item = [url substringWithRange:NSMakeRange(app_pre.length, url.length - app_pre.length)];
        if (item.length > 0) {
            ServiceItemViewController *vc = [[ServiceItemViewController alloc] init];
            vc.service_id = item;
            PushToViewController(vc);
        }
        return;
    }
    //url 包含 app://跳转 WebViewController
    WebViewController *vc = [[WebViewController alloc] initWithPath:url];
    PushToViewController(vc);
    
}
/*-----------hotActivity----------*/
/*-----------热门视频----------*/
- (void)makeHotVideo{
    WeakSelf;
    NSString *path = [NSString stringWithFormat:@"GET %@svc/app/lecture",DOMAINURL_API];
//    [self startAPIRequestWithSelector:path parameters:nil success:^(NSInteger statusCode, id response) {
//        [weakSelf makHotVideoWithResponse:response];
//    }];
    [self startAPIRequestWithSelector:path
                           parameters:nil expectedStatusCodes:nil showHUD:NO showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
                               [weakSelf makHotVideoWithResponse:response];
                           } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
                               [weakSelf caseEmpty];
                           }];
}
- (void)makHotVideoWithResponse:(id)response{
    
    if (!ResponseIsOK)  {
        [self caseEmpty];
        return;
    }
    NSArray *items = response[@"result"];
    if (items.count == 0)  {
        [self caseEmpty];
        return;
    }
    [self caseEmpty];
    [self reloadWithItems:@[items] type:SectionGroupTypeHotVideo];
}
- (void)caseHotVideo:(NSString *)video_id{
    SMDetailViewController *vc = [[SMDetailViewController alloc] init];
    vc.message_id = video_id;
    PushToViewController(vc);
}
/*-----------热门视频----------*/
/*-----------文章栏目----------*/
- (void)makeHotArticle{
    WeakSelf;
    NSString *path = [NSString stringWithFormat:@"GET %@svc/article/hotArticle",DOMAINURL_API];
    [self startAPIRequestWithSelector:path
                           parameters:nil expectedStatusCodes:nil showHUD:NO showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
                               [weakSelf makHotArticleWithResponse:response];
                           } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
                               [weakSelf caseEmpty];
                           }];
}
- (void)makHotArticleWithResponse:(id)response{
    if (!ResponseIsOK)  {
        [self caseEmpty];
        return;
    }
    NSArray *items = response[@"result"];
    if (items.count == 0)  {
        [self caseEmpty];
        return;
    }
    
    [self caseEmpty];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setValue:items forKey:@"HotArticle"];
    [ud synchronize];
    
    [self reloadWithItems:items type:SectionGroupTypeArticleColumn];
}
/*-----------文章栏目----------*/
- (void)reloadWithItems:(NSArray *)items type:(SectionGroupType)type{
    
    self.request_count = 0 ;
    
    NSInteger index = 0;
    for (myofferGroupModel *group in self.groups) {
        if (group.type == type) {
            index = [self.groups indexOfObject:group];
            group.items = items;
            break;
        }
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)makeUI{
    
    [self makeTableView];
    self.view.backgroundColor = XCOLOR_WHITE;
    self.commoditie_height =  150 * XSCREEN_WIDTH / 375   + 6 + 15;
    self.productView = [[HomeRecommendProdoctView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, self.commoditie_height - 15)];
}

-(void)makeTableView{
    
    CGFloat t_y = XNAV_HEIGHT + 16;
    CGFloat t_h = self.view.bounds.size.height - t_y;
    CGFloat t_w = self.view.bounds.size.width;
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, t_y, t_w, t_h) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.estimatedRowHeight = 100;//很重要保障滑动流畅性
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, XTabBarHeight, 0);
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.tableView.backgroundColor = XCOLOR_WHITE;
}


#pragma mark :  UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.groups.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    myofferGroupModel *group = self.groups[section];
    return  group.items.count;
}

static NSString *identify = @"cell";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WeakSelf;
    myofferGroupModel *group = self.groups[indexPath.section];
    if (group.type == SectionGroupTypeArticleColumn){
        HomeRecommendArtCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeRecommendArtCell"];
        if (!cell) {
            cell =  Bundle(@"HomeRecommendArtCell");
        }
        cell.item = group.items[indexPath.row];
        return cell;
    }
    if (group.type ==  SectionGroupTypeHotVideo) {
        HomeHotVideoCell   *cell = Bundle(@"HomeHotVideoCell");
        cell.items = group.items[indexPath.row];
        cell.actionBlock = ^(NSString *video_id) {
            [weakSelf caseHotVideo:video_id];
        };
        return cell;
    }
    if (group.type == SectionGroupTypePopularActivity) {
        HomeRecommendActivityCell   *cell = Bundle(@"HomeRecommendActivityCell");
        cell.items = group.items[indexPath.row];
        cell.actionBlock = ^(NSString *url) {
            [weakSelf caseActivity:url];
        };
        return cell;
    }
    
    if (group.type ==SectionGroupTypeHotCommodities) {
        UITableViewCell *cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:self.productView];
        self.productView.group = group;
        self.productView.actionBlock = ^(NSString *sku_id) {
            [weakSelf caseSKU:sku_id];
        };
        return cell;
    }
    UITableViewCell *cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:nil];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    myofferGroupModel *group = self.groups[indexPath.section];
    if (group.type == SectionGroupTypeArticleColumn) {
        NSDictionary *item = group.items[indexPath.row];
        MessageDetaillViewController *vc = [[MessageDetaillViewController alloc] initWithMessageId:item[@"id"]];
        PushToViewController(vc);
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    WeakSelf;
    HomeSecView *header = [[HomeSecView alloc] init];
    header.leftMargin = 20;
    header.group = self.groups[section];
    header.actionBlock = ^(SectionGroupType type) {
        [weakSelf caseHeaderView:type];
    };
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footer = [UIView new];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    myofferGroupModel *group = self.groups[indexPath.section];
    if (group.type == SectionGroupTypeHotCommodities) {
        return  self.commoditie_height;
    }
    return  UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    myofferGroupModel *group = self.groups[section];
    return group.section_header_height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return  HEIGHT_ZERO;
}

#pragma mark : SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
}
/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
}

#pragma mark : 事件处理
- (void)caseEmpty{
    
    self.request_count +=1;
    if (self.request_count >= self.groups.count) {
        
        MyofferFooterView *footer = [MyofferFooterView footer];
        footer.actionBlock = ^{
            [self makeData];
        };
        footer.mj_h = self.tableView.mj_h;
        self.tableView.tableFooterView = footer;
    }else{
        self.tableView.tableFooterView = [UIView new];
    }

}

- (void)caseHeaderView:(SectionGroupType)type{
    
    switch (type) {
        case SectionGroupTypeHotVideo:
            [self caseSuperMaster];
            break;
        case SectionGroupTypeArticleColumn:
            [self caseMessage];
            break;
        case SectionGroupTypeHotCommodities:
            [self caseService];
            break;
        default:
            break;
    }
    
}
//跳转超级导师
-(void)caseSuperMaster{
    PushToViewController([[SuperMasterViewController alloc] init] );
}
//跳转资讯宝典
-(void)caseMessage{
    [self.tabBarController setSelectedIndex:2];
}
//跳转服务包
-(void)caseService{
    PushToViewController([[MyOfferServerMallViewController alloc] init] );
}
//跳转LandingPage
- (void)CaseLandingPage:(NSString *)path{
    
    if ([path containsString:@"superMentor.html"]) {
        [self caseSuperMaster];
    }else{
        PushToViewController([[WebViewController alloc] initWithPath:path]);
    }
}

//邀请有礼
- (void)caseInvitation{
    
    RequireLogin
    WeakSelf
    [self startAPIRequestWithSelector:kAPISelectorPromotionSummary  parameters:nil expectedStatusCodes:nil showHUD:NO showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        [weakSelf caseInvitationActivityWithResponse:response];
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) { }];
}

- (void)caseInvitationActivityWithResponse:(id)response{
    
    //网络请求出错
    if (!ResponseIsOK) {
        [MBProgressHUD showMessage:NetRequest_ConnectError];
        return;
    }
    NSDictionary *result = response[@"result"];
    NSString *path = [NSString stringWithFormat:@"https://m.myoffer.cn/invitation-activity.html?rewarded=%@&waitAward=%@&total=%@",result[@"rewarded"],result[@"waitAward"],result[@"total"]];
    WebViewController *vc = [[WebViewController alloc] initWithPath:path];
    vc.title = @"邀请有礼";
    PushToViewController(vc);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
