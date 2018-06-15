//
//  HomeIndexVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/6/14.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeIndexVC.h"
#import "HomeMenuBarView.h"
#import "HomeRecommendVC.h"

#define  MENU_HEIGHT  XNAV_HEIGHT + 16
#define  CELL_CL_HEIGHT  XSCREEN_HEIGHT
#define  CELL_CL_WIDTH  XSCREEN_WIDTH

@interface HomeIndexVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView *clView;
@property(nonatomic,strong)HomeMenuBarView *MenuBarView;
@property(nonatomic,strong)NSMutableArray *reuseArr;
@property(nonatomic,strong)HomeRecommendVC *homeRecommend;
@property(nonatomic,assign)UIStatusBarStyle currentStatusBarStyle;

@end

@implementation HomeIndexVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    NavigationBarHidden(YES);
    [self presentViewWillAppear];
 
}

//页面出现时预加载功能
-(void)presentViewWillAppear{
    
    [MobClick beginLogPageView:@"page新版首页"];
    self.tabBarController.tabBar.hidden = NO;
    [self changeStatusBar];

//    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
 
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [MobClick endLogPageView:@"page新版首页"];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self makeUI];
}

- (NSMutableArray *)reuseArr{
    if(!_reuseArr){
        _reuseArr = [NSMutableArray array];
    }
    return _reuseArr;
}

- (HomeRecommendVC *)homeRecommend{
    
    if(!_homeRecommend){
        
        _homeRecommend = [[HomeRecommendVC alloc] init];
        _homeRecommend.view.frame =  self.view.bounds;
        [self addChildViewController:_homeRecommend];
    }
    return _homeRecommend;
}

- (void)makeUI{
    
   self.automaticallyAdjustsScrollViewInsets = NO;
   self.currentStatusBarStyle = UIStatusBarStyleDefault;
   [self makeCollectView];
   [self makeMenuView];
}

- (void)makeMenuView{
    
    WeakSelf;
    NSArray *titles = @[@"推荐",@"留学申请",@"学费支付",@"海外租房",@"游学职培"];
    HomeMenuBarView *MenuView = [HomeMenuBarView menuInitWithTitles:titles clickButton:^(NSInteger index) {
        [weakSelf MenuScrollToIndex:index];
    }];
    MenuView.frame = CGRectMake(0, 0, XSCREEN_WIDTH, MENU_HEIGHT);
    self.MenuBarView = MenuView;
    [self.view addSubview:MenuView];
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1* NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [MenuView initFirstResponse];
    });

}

- (void)makeCollectView{
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.itemSize = CGSizeMake(CELL_CL_WIDTH, CELL_CL_HEIGHT);
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flow.minimumLineSpacing = 0;
    flow.minimumInteritemSpacing = 0;
    UICollectionView *cView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flow];
    cView.dataSource = self;
    cView.delegate = self;
    cView.pagingEnabled = YES;
    cView.backgroundColor = XCOLOR_WHITE;
    cView.bounces = NO;
    [self.view addSubview:cView];
    self.clView = cView;
    
}

#pragma mark : UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.MenuBarView.titles.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *indenty = [NSString stringWithFormat:@"row%ld_%ld",indexPath.section,indexPath.row];
    if([self.reuseArr indexOfObject:indenty] > self.reuseArr.count){
        [self.reuseArr addObject:indenty];
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:indenty];
    }
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:indenty forIndexPath:indexPath];
    cell.contentView.backgroundColor = XCOLOR_RANDOM;
    
    if(indexPath.row == 0 && cell.contentView.subviews.count == 0){
        [cell.contentView addSubview:self.homeRecommend.view];
    }
    
//    if(indexPath.row == 1 && cell.contentView.subviews.count == 0){
//        [cell.contentView addSubview:self.homeApplication.view];
//    }
//
//    if(indexPath.row == 2 && cell.contentView.subviews.count == 0){
//        [cell.contentView addSubview:self.homeFee.view];
//    }
    
    return cell;
}

#pragma mark : UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.MenuBarView menuDidScrollWithScrollView:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //防止 非用户用原因 DidDidEndDeceleratingWithScrollView没被调用
    if (!decelerate) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.MenuBarView menuDidDidEndDeceleratingWithScrollView:scrollView];
    
    NSInteger index = (NSInteger)((scrollView.mj_offsetX / scrollView.mj_w) + 0.5);
    
    self.currentStatusBarStyle = (index == 0)?UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
    [self changeStatusBar];
 }

#pragma mark : 事件处理
//菜单栏切换
- (void)MenuScrollToIndex:(NSInteger)index{
    
    NSInteger from_index = (NSInteger)((self.clView.mj_offsetX / self.clView.mj_w) + 0.5);
    BOOL ani =  (abs((int)(from_index - index)) == 1);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.clView selectItemAtIndexPath:indexPath animated:ani scrollPosition:UICollectionViewScrollPositionLeft];
    
    self.currentStatusBarStyle = (index == 0)?UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
    [self changeStatusBar];
}

- (void)changeStatusBar{
    
    if ([UIApplication sharedApplication].statusBarStyle != self.currentStatusBarStyle) {
        [UIApplication sharedApplication].statusBarStyle =  self.currentStatusBarStyle;
    }
 
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
