//
//  GonglueListViewController.m
//  myOffer
//
//  Created by xuewuguojie on 16/4/20.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "GongLueViewController.h"
#import "MessageDetaillViewController.h"
#import "GongLueCell.h"
#import "GongLueHeaderView.h"
#import "AUSearchResultViewController.h"
#import "PipeiEditViewController.h"
#import "IntelligentResultViewController.h"
#import "ApplyViewController.h"
#import "UniversityNavView.h"
#import "GonglueItem.h"
#import "myofferFlexibleView.h"

@interface GongLueViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
//弹性图片
@property(nonatomic,strong)myofferFlexibleView *flexView;
//@property(nonatomic,strong)UIImageView *FlexibleImageView;
////弹性图片初始Rect
//@property(nonatomic,assign)CGRect   oldFlexibleViewRect;
////弹性图片初始Center
//@property(nonatomic,assign)CGPoint  oldFlexibleViewCenter;
//用于判断用户是否已登录且有推荐院校数据
@property(nonatomic,assign)NSInteger recommendationsCount;
//自定义TableViewHeaderView
@property(nonatomic,strong)GongLueHeaderView *headerView;
//自定义导航栏
@property(nonatomic,strong)UniversityNavView     *topNavigationView;


@end

@implementation GongLueViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [MobClick beginLogPageView:@"page申请攻略列表"];
    
    [self checkZhiNengPiPei];
    
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page申请攻略列表"];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
    
}


/**
  //判断是否有智能匹配数据或收藏学校
 */
-(void)checkZhiNengPiPei{
    
    if (!LOGIN) return;
        
    XWeakSelf
    [self startAPIRequestWithSelector:kAPISelectorZiZengPipeiGet  parameters:nil success:^(NSInteger statusCode, id response) {
        
        weakSelf.recommendationsCount = response[@"university"] ? 1 : 0;
        
    }];
        
    
}

- (void)makeUI{
    
    [self makeTableView];

    [self makeFlexibleImageView];
    
    [self makeTopNavigaitonView];
    
}

//头部图片
-(void)makeFlexibleImageView
{
    
    myofferFlexibleView *flexView = [[myofferFlexibleView alloc] init];
    [self.view insertSubview:flexView belowSubview:self.tableView];
    self.flexView = flexView;
    flexView.alpha = 0.1;
    XWeakSelf

    NSString *path = [self.gonglue.cover  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.flexView.coverView sd_setImageWithURL:[NSURL URLWithString: path] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        CGFloat image_height = XSCREEN_WIDTH * image.size.height/image.size.width;
        
        [weakSelf flexWithHeight:image_height];
        
    }];
    
    
}

- (void)flexWithHeight:(CGFloat )height{
    
    
    self.flexView.frame = CGRectMake(0, 0, XSCREEN_WIDTH, height);
    
    [UIView transitionWithView:self.flexView duration:0.5 options:UIViewAnimationOptionCurveEaseIn |UIViewAnimationOptionTransitionCrossDissolve animations:^{
        
        self.flexView.alpha = 1;
        
    } completion:^(BOOL finished) {
        
    }];
    
    GongLueHeaderView *headerView  =[[GongLueHeaderView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, height)];
    headerView.top_View_Height = height;
    headerView.gonglue = self.gonglue;
    self.tableView.tableHeaderView = headerView;
    self.headerView = headerView;
}


//自定义导航栏
-(void)makeTopNavigaitonView{
    
    XWeakSelf

    self.topNavigationView =  [UniversityNavView ViewWithBlock:^(UIButton *sender) {
        
         [weakSelf pop];
    }];
    self.topNavigationView.titleName = self.gonglue.title;
    
    [self.view addSubview:self.topNavigationView];
    
}

- (void)makeTableView
{
    UITableView *tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0, XSCREEN_WIDTH, XSCREEN_HEIGHT) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor  colorWithWhite:1 alpha:0];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    tableView.tableFooterView =[[UIView alloc] init];
    tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;

}


#pragma mark : UITableViewData UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return    self.gonglue.articles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GongLueCell *cell =[GongLueCell cellWithTableView:tableView];
  
    cell.item =  self.gonglue.articles[indexPath.row];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    return Uni_Cell_Height;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MyOfferArticle *item =  self.gonglue.articles[indexPath.row];
    
    if ([item.message_id isEqualToString:@"ranks"]) {
        

        [self caseSearchResult];
        
        return;
    }
    
    if ([item.message_id  isEqualToString:@"recommendations"]) {
        
        [self caseIntelligent];
        
        return;
    }
    
    
    if ([item.message_id  isEqualToString:@"application"]) {
        
        [self.tabBarController setSelectedIndex:3];
        
        return;
    }
    
    
    [self caseMassageWithId:item.message_id];
}


#pragma mark : UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (self.flexView.mj_h == 0) return;
 
    //1 顶部自定义导航栏
    [self.topNavigationView  scrollViewForGongLueViewContentoffsetY:offsetY  andHeight:self.flexView.mj_h - XNAV_HEIGHT];
   
    //2 自定义tableHeaderView
    [self.headerView scrollViewDidScrollWithcontentOffsetY:offsetY];
    
     //3 顶部自定义导航栏透明度
    self.topNavigationView.nav_Alpha = self.headerView.nav_Alpha;
    
    //4 下拉图片处理
    [self.flexView flexWithContentOffsetY:offsetY];
    
    
}


#pragma mark : 调用方法
/**
    区分英国、澳大利亚
 */
-(void)caseSearchResult
{
    if ([self.gonglue.title containsString:@"英国"]) {
        
        SearchResultViewController *vc = [[SearchResultViewController alloc] initWithFilter:@"country" value:@"英国" orderBy:RANK_TI];
        [self.navigationController pushViewController:vc animated:YES];
        
        return;
        
    }
        
    AUSearchResultViewController *newVc = [[AUSearchResultViewController alloc] initWithFilter:@"country" value:@"澳大利亚" orderBy:RANK_TI];
    [self.navigationController pushViewController:newVc animated:YES];
    
}


/**
 智能匹配
 recommendationsCount   用来区分用户是否提交过智能匹配数据
 */
- (void)caseIntelligent{
    
    if (self.recommendationsCount > 0) {
        
        RequireLogin
        
        IntelligentResultViewController *vc = [[IntelligentResultViewController alloc] initWithNibName:@"IntelligentResultViewController" bundle:nil];
      
        [self.navigationController pushViewController:vc animated:YES];
        
        return;
    }
        
      [self.navigationController pushViewController:[[PipeiEditViewController alloc] init] animated:YES];
    
    
 
    
}

//跳转资讯详情
- (void)caseMassageWithId:(NSString *)message_id{
    
    [self.navigationController pushViewController:[[MessageDetaillViewController alloc] initWithMessageId:message_id] animated:YES];

}


//回退
- (void)pop{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc{
    
    KDClassLog(@"留学攻略列表  dealloc");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
