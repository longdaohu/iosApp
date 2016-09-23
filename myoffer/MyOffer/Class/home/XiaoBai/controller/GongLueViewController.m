//
//  GonglueListViewController.m
//  myOffer
//
//  Created by xuewuguojie on 16/4/20.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "GongLueViewController.h"
#import "MessageDetailViewController.h"
#import "GongLueListCell.h"
#import "GongLueListHeaderView.h"
#import "AUSearchResultViewController.h"
#import "SearchResultViewController.h"
#import "InteProfileViewController.h"
#import "IntelligentResultViewController.h"
#import "ApplyViewController.h"
#import "UniversityNavView.h"

@interface GongLueViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *TableView;
//弹性图片
@property(nonatomic,strong)UIImageView *FlexibleImageView;
//弹性图片初始Rect
@property(nonatomic,assign)CGRect   oldFlexibleViewRect;
//弹性图片初始Center
@property(nonatomic,assign)CGPoint  oldFlexibleViewCenter;
//用于判断用户是否已登录且有推荐院校数据
@property(nonatomic,assign)NSInteger recommendationsCount;
//自定义TableViewHeaderView
@property(nonatomic,strong)GongLueListHeaderView *headerView;
//自定义导航栏
@property(nonatomic,strong)UniversityNavView     *topNavigationView;


@end

@implementation GongLueViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [MobClick beginLogPageView:@"page申请攻略列表"];
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page申请攻略列表"];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
    
    [self checkZhiNengPiPei];
    
}


-(void)checkZhiNengPiPei{
    
    if (LOGIN) {
        //判断是否有智能匹配数据或收藏学校
        [self startAPIRequestUsingCacheWithSelector:kAPISelectorRequestCenter parameters:nil success:^(NSInteger statusCode, NSDictionary *response) {
            self.recommendationsCount = [response[@"recommendationsCount"] integerValue];
        }];
    }
}

-(void)makeUI
{
    
    [self makeFlexibleImageView];
    
    [self makeTableView];
    
    [self makeTopNavigaitonView];
    
}

-(void)makeFlexibleImageView
{
    self.FlexibleImageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, XScreenWidth, AdjustF(160.f))];
    self.FlexibleImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.FlexibleImageView.clipsToBounds = YES;
    self.oldFlexibleViewRect = self.FlexibleImageView.frame;
    self.oldFlexibleViewCenter = self.FlexibleImageView.center;
    [self.view addSubview:self.FlexibleImageView];
    self.FlexibleImageView.alpha = 0.1;
    [self.FlexibleImageView sd_setImageWithURL:[NSURL URLWithString:self.gonglue[@"cover"]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    [UIView transitionWithView:self.FlexibleImageView duration:0.5 options:UIViewAnimationOptionCurveEaseIn |UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.FlexibleImageView.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}

-(void)makeTopNavigaitonView{
    
    XJHUtilDefineWeakSelfRef
    self.topNavigationView = [[NSBundle mainBundle] loadNibNamed:@"UniversityNavView" owner:self options:nil].lastObject;
    self.topNavigationView.titleLab.text = self.gonglue[@"title"];
    self.topNavigationView.actionBlock = ^(UIButton *sender){
        [weakSelf pop];
    };
    
    [self.view addSubview:self.topNavigationView];
}

-(void)makeTableView
{
    self.TableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0, XScreenWidth, XScreenHeight) style:UITableViewStylePlain];
    self.TableView.backgroundColor =XCOLOR_CLEAR;
    self.TableView.delegate = self;
    self.TableView.dataSource = self;
    [self.view addSubview:self.TableView];
    self.TableView.tableFooterView =[[UIView alloc] init];
    self.TableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    
    [self makeTableViewHeaderView];
    
}


-(void)makeTableViewHeaderView
{
    GongLueListHeaderView *header  =[[GongLueListHeaderView alloc] initWithFrame:CGRectMake(0, 0, XScreenWidth, AdjustF(160.f))];
    header.gongLueDic = self.gonglue;
    self.headerView = header;
    self.TableView.tableHeaderView = header;
    
}


#pragma mark ———————— UITableViewData UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.gonglue[@"articles"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GongLueListCell *cell =[GongLueListCell cellWithTableView:tableView];
    
    cell.item = self.gonglue[@"articles"][indexPath.row];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    return University_HEIGHT;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *message =  self.gonglue[@"articles"][indexPath.row];
    
    if ([message[@"_id"] isEqualToString:@"ranks"]) {
        
        if ([self.gonglue[@"title"] containsString:@"英国"]) {
            SearchResultViewController *vc = [[SearchResultViewController alloc] initWithFilter:@"country" value:@"英国" orderBy:RANKTI];
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            
            AUSearchResultViewController *newVc = [[AUSearchResultViewController alloc] initWithFilter:@"country" value:@"澳大利亚" orderBy:RANKTI];
            [self.navigationController pushViewController:newVc animated:YES];
        }
        
        return;
    }
    
    if ([message[@"_id"] isEqualToString:@"recommendations"]) {
        
        RequireLogin
        
        if (self.recommendationsCount) {
            
            IntelligentResultViewController *vc = [[IntelligentResultViewController alloc] initWithNibName:@"IntelligentResultViewController" bundle:nil];
            vc.isComeBack = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            
            InteProfileViewController *vc =[[InteProfileViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        
        return;
    }
    
    
    if ([message[@"_id"] isEqualToString:@"application"]) {
        
        [self.tabBarController setSelectedIndex:3];
        
        return;
    }
    
    
    MessageDetailViewController *help =[[MessageDetailViewController alloc] init];
    help.NO_ID = message[@"_id"];
    [self.navigationController pushViewController:help animated:YES];
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    //1 顶部自定义导航栏
    [self.topNavigationView   scrollViewForGongLueViewContentoffsetY:scrollView.contentOffset.y  andHeight:self.headerView.bounds.size.height - NAV_HEIGHT];
    
    //2 自定义tableHeaderView
    self.headerView.contentOffsetY =  scrollView.contentOffset.y;
    
    //3 顶部自定义导航栏 titleLab.alpha 控制
    CGFloat height =  self.headerView.moBgView.frame.origin.y - CGRectGetMinY(self.headerView.headerTitleLab.frame);
    self.topNavigationView.titleLab.alpha  = (self.headerView.headerTitleLab.bounds.size.height - height)/ self.headerView.headerTitleLab.bounds.size.height;
    
    //4 头部图片拉伸
    if (scrollView.contentOffset.y < 0) {
        
        CGRect newFrame = self.oldFlexibleViewRect;
        newFrame.size.height = self.oldFlexibleViewRect.size.height - scrollView.contentOffset.y * 2;
        newFrame.size.width  =self.oldFlexibleViewRect.size.width * (newFrame.size.height)/self.oldFlexibleViewRect.size.height;
        self.FlexibleImageView.frame = newFrame;
        self.FlexibleImageView.center = self.oldFlexibleViewCenter;
        
    }else{
        
        [UIView animateWithDuration:ANIMATION_DUATION animations:^{
            self.FlexibleImageView.frame = self.oldFlexibleViewRect;
        }];
        
    }
    
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
