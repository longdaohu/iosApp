//
//  GongLueViewController.m
//  myOffer
//
//  Created by xuewuguojie on 16/9/19.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "GongLueViewController.h"
#import "GongLueListCell.h"
#import "GlHeaderView.h"
#import "MessageDetailViewController.h"
#import "NewSearchResultViewController.h"
#import "SearchResultViewController.h"
#import "InteProfileViewController.h"
#import "IntelligentResultViewController.h"
#import "ApplyViewController.h"
#import "UniversityNavView.h"


@interface GongLueViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *TableView;
//用于判断用户是否已登录且有推荐院校数据
@property(nonatomic,assign)NSInteger recommendationsCount;
@property(nonatomic,strong)GlHeaderView *header;
//弹性图片
@property(nonatomic,strong)UIImageView *FlexibleImageView;
//弹性图片初始Rect
@property(nonatomic,assign)CGRect   oldFlexibleViewRect;
//弹性图片初始Center
@property(nonatomic,assign)CGPoint  oldFlexibleViewCenter;
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

-(void)makeUI
{
    
//    self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
//    self.titleLab.textAlignment = NSTextAlignmentCenter;
//    self.titleLab.textColor = XCOLOR_WHITE;
//    self.titleLab.font = [UIFont boldSystemFontOfSize:16];
//    self.titleLab.alpha = 0;
//    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
//    [titleView addSubview:self.titleLab];
//    self.navigationItem.titleView =  titleView;
//    self.titleLab.text = self.gonglue[@"title"];
//    
    [self makeFlexibleImageView];
    
    [self makeTableView];
    
    [self makeTopNavigaitonView];
    
}


-(void)makeTopNavigaitonView{
    
    
    XJHUtilDefineWeakSelfRef
    self.topNavigationView = [[NSBundle mainBundle] loadNibNamed:@"UniversityNavView" owner:self options:nil].lastObject;
    self.topNavigationView.frame = CGRectMake(0, 0, XScreenWidth, NAV_HEIGHT);
    self.topNavigationView.actionBlock = ^(UIButton *sender){
        
        [weakSelf pop];
        
    };
    
    [self.view addSubview:self.topNavigationView];
}

-(void)checkZhiNengPiPei{
    
    if (LOGIN) {
        //判断是否有智能匹配数据或收藏学校
        [self startAPIRequestUsingCacheWithSelector:kAPISelectorRequestCenter parameters:nil success:^(NSInteger statusCode, NSDictionary *response) {
            self.recommendationsCount = [response[@"recommendationsCount"] integerValue];
            
        }];
    }
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

-(void)makeTableViewHeaderView{


    
    GlHeaderView *header = [[NSBundle mainBundle] loadNibNamed:@"GlHeaderView" owner:self options:nil].lastObject;
    header.headerTitleLab.text = [self.gonglue valueForKey:@"title"];
    header.subTitle =  self.gonglue[@"tip"][@"content"];
    self.header = header;
    
    [self.TableView beginUpdates];
    
     self.TableView.tableHeaderView = self.header;
    
    [self.TableView endUpdates];
  
    
}


-(void)makeFlexibleImageView
{
    self.FlexibleImageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, XScreenWidth, AdjustF(160.f))];
    self.FlexibleImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.FlexibleImageView.clipsToBounds = YES;
    self.FlexibleImageView.backgroundColor = BACKGROUDCOLOR;
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
    
    return 100 +KDUtilSize(0)*2;
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
            
            NewSearchResultViewController *newVc = [[NewSearchResultViewController alloc] initWithFilter:@"country" value:@"澳大利亚" orderBy:RANKTI];
            [self.navigationController pushViewController:newVc animated:YES];
        }
        
        return;
    }
    
    if ([message[@"_id"] isEqualToString:@"recommendations"]) {
        
        RequireLogin
        
        if (self.recommendationsCount > 0) {
            
            IntelligentResultViewController *vc = [[IntelligentResultViewController alloc] initWithNibName:@"IntelligentResultViewController" bundle:nil];
//            vc.navigationBgImage = self.navigationBgImage;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            
            InteProfileViewController *vc =[[InteProfileViewController alloc] init];
//            vc.navigationBgImage = self.navigationBgImage;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        
        return;
    }
    
    if ([message[@"_id"] isEqualToString:@"application"]) {
        
        [self.tabBarController setSelectedIndex:3];
        
        return;
    }
    
    
    MessageDetailViewController *help =[[MessageDetailViewController alloc] init];
//    help.navigationBgImage = self.navigationBgImage;
    help.NO_ID = message[@"_id"];
    
    [self.navigationController pushViewController:help animated:YES];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
//    self.alpha_nav = scrollView.contentOffset.y / self.headerHeight;
//    
//    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:self.alpha_nav];
//    
//    self.headerView.contentOffsetY =  scrollView.contentOffset.y;
    
    
    
    if (scrollView.contentOffset.y < 0) {
        
        CGRect frame = self.oldFlexibleViewRect;
        
        frame.size.height = self.oldFlexibleViewRect.size.height - scrollView.contentOffset.y * 2;
        frame.size.width  =self.oldFlexibleViewRect.size.width * (frame.size.height)/self.oldFlexibleViewRect.size.height;
        self.FlexibleImageView.frame = frame;
        self.FlexibleImageView.center = self.oldFlexibleViewCenter;
        
    }else{
        
        
        [UIView animateWithDuration:0.25 animations:^{
            
            self.FlexibleImageView.frame = self.oldFlexibleViewRect;
        }];
    }
    
    
    
    
//    CGFloat height =  self.headerView.moBgView.frame.origin.y - CGRectGetMinY(self.headerView.headerTitleLab.frame);
//    self.titleLab.alpha =(self.headerView.headerTitleLab.bounds.size.height - height)/ self.headerView.headerTitleLab.bounds.size.height;
    
}


//回退
- (void)pop{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
