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
#import "HomeCommoditieCell.h"
#import "myofferGroupModel.h"
#import "MyofferFooterView.h"
#import "ServiceSKU.h"
#import "MessageDetaillViewController.h"
#import "ServiceItemViewController.h"
#import "SMDetailViewController.h"

@interface HomeRecommendVC ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *groups;
@property(nonatomic,strong)SDCycleScrollView *bannerView;
@property(nonatomic,strong)UIView *header;
@property(nonatomic,assign)CGFloat commoditie_height;

@end

@implementation HomeRecommendVC

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self makeUI];
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
        
        CGFloat header_w = XSCREEN_WIDTH;
        CGFloat header_h =  140 * header_w / 375;
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, header_w, header_h)];
        self.header = header;
        header.backgroundColor = XCOLOR_WHITE;
    }
    
    return _header;
}

- (void)makeData{
    
    [self makeBannerData];
    [self makeHotProducts];
    [self makeHotActivity];
    [self makeHotVideo];
    [self makeHotArticle];
}
/*-----------banner----------*/
- (void)makeBannerData{
    WeakSelf;
    [self startAPIRequestWithSelector:@"GET http://120.76.78.88:8980/svc/app/banner" parameters:nil success:^(NSInteger statusCode, id response) {
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
    self.tableView.tableHeaderView = self.header;
 
    NSArray *cover_url_arr = (NSArray *)[items valueForKeyPath:@"cover_url"];
//    NSArray *title_arr = (NSArray *)[items valueForKeyPath:@"title"];
    
    NSMutableArray *cover_arr = [NSMutableArray array];
    [cover_url_arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *item = (NSString *)obj;
        item = [item stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [cover_arr addObject:item];
    }];
    
    if (!self.bannerView) {
        CGFloat b_x = 20;
        CGFloat b_w = XSCREEN_WIDTH - b_x * 2;
        CGRect banner_frame = CGRectMake(b_x, 0, b_w,self.header.mj_h);
        self.bannerView = [SDCycleScrollView  cycleScrollViewWithFrame:banner_frame delegate:self placeholderImage:nil];
        [self.header addSubview:self.bannerView];
        self.bannerView.placeholderImage =   [UIImage imageNamed:@"PlaceHolderImage"];
        self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        self.bannerView.layer.cornerRadius = CORNER_RADIUS;
        self.bannerView.layer.masksToBounds = YES;
    }
    self.bannerView.imageURLStringsGroup = cover_arr;
//    self.bannerView.titlesGroup = title_arr;
    
}
/*-----------banner----------*/
/*-----------hotProducts----------*/
- (void)makeHotProducts{
    WeakSelf;
    [self startAPIRequestWithSelector:@"GET http://120.76.78.88:8980/svc/app/hotProducts/5" parameters:nil success:^(NSInteger statusCode, id response) {
        [weakSelf makHotProductsWithResponse:response];
    }];
}
- (void)makHotProductsWithResponse:(id)response{
    
    if (!ResponseIsOK) return;
    NSArray *items = response[@"result"];
    if (items.count == 0) return;
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
    [self startAPIRequestWithSelector:@"GET http://120.76.78.88:8980/svc/app/hotActivity/app" parameters:nil success:^(NSInteger statusCode, id response) {
        [weakSelf makHotActivityWithResponse:response];
    }];
}
- (void)makHotActivityWithResponse:(id)response{
    if (!ResponseIsOK) return;
    NSArray *items = response[@"result"];
    if (items.count == 0) return;
    [self reloadWithItems:@[items] type:SectionGroupTypePopularActivity];
}
- (void)caseActivity:(NSString *)act_id{
   
    NSLog(@"caseActivity == %@",act_id);
}
/*-----------hotActivity----------*/
/*-----------热门视频----------*/
- (void)makeHotVideo{
    WeakSelf;
    [self startAPIRequestWithSelector:@"GET http://120.76.78.88:8980/svc/app/lecture" parameters:nil success:^(NSInteger statusCode, id response) {
        [weakSelf makHotVideoWithResponse:response];
    }];
}
- (void)makHotVideoWithResponse:(id)response{
    
    if (!ResponseIsOK) return;
    NSArray *items = response[@"result"];
    if (items.count == 0) return;
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
    [self startAPIRequestWithSelector:@"GET http://120.76.78.88:8980/svc/article/hotArticle" parameters:nil success:^(NSInteger statusCode, id response) {
        [weakSelf makHotArticleWithResponse:response];
    }];
}
- (void)makHotArticleWithResponse:(id)response{
    if (!ResponseIsOK) return;
    NSArray *items = response[@"result"];
    if (items.count == 0) return;
    [self reloadWithItems:items type:SectionGroupTypeArticleColumn];
}
/*-----------文章栏目----------*/
- (void)reloadWithItems:(NSArray *)items type:(SectionGroupType)type{
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
     self.commoditie_height =  150 * XSCREEN_WIDTH / 375   + 6;
}

-(void)makeTableView{
    
    CGFloat t_y = XNAV_HEIGHT + 16;
    CGFloat t_h = self.view.bounds.size.height - t_y;
    CGFloat t_w = self.view.bounds.size.width;
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, t_y, t_w, t_h) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
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
 
    self.tableView.tableFooterView = [MyofferFooterView footer];
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
        cell.actionBlock = ^(NSString *action_id) {
            [weakSelf caseActivity:action_id];
        };
        return cell;
    }
    
    if (group.type ==SectionGroupTypeHotCommodities) {
        HomeCommoditieCell  *cell = [[HomeCommoditieCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.group = group;
        cell.actionBlock = ^(NSString *name) {
            [weakSelf caseSKU:name];
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
    
    HomeSecView *header = [[HomeSecView alloc] init];
    header.group = self.groups[section];
    header.actionBlock = ^(SectionGroupType type) {
        NSLog(@" section >>>>>>>>>>>>> %ld",type);
    };
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footer = [UIView new];
//    footer.backgroundColor = XCOLOR_RED;
    
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
//    return 50;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
