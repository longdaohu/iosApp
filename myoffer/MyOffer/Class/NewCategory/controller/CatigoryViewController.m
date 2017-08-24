//
//  XWGJCatigoryViewController.m
//  myOffer
//
//  Created by xuewuguojie on 16/2/29.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "CatigoryViewController.h"
#import "CatigaryCityCollectionCell.h"
#import "CatigaryCityCollectionReusableView.h"
#import "CatigoryRank.h"
#import "CatigorySubject.h"
#import "CountryStateViewController.h"
#import "CatigaryHotCity.h"
#import "SearchViewController.h"
#import "CatigaryCountry.h"
#import "CatigaryScrollView.h"
#import "AUSearchResultViewController.h"
#import "XBTopToolView.h"
#import "TopNavView.h"
#import "NomalCollectionController.h"
#import "CatigaryHotCityCell.h"
#import "HomeSectionHeaderView.h"
#import "SearchUniversityCenterViewController.h"
#import "CatigaryRankkCell.h"


@interface CatigoryViewController ()<UIScrollViewDelegate,XTopToolViewDelegate,UITableViewDelegate,UITableViewDataSource>
//背景scroller
@property(nonatomic,strong)CatigaryScrollView *bgView;
//排名tableView
@property(nonatomic,strong)UITableView *rank_tableView;
//专业collectionView
@property(nonatomic,strong)NomalCollectionController *nomalCollectionVC;
//热门城市collectionView
@property(nonatomic,strong)UITableView *city_tableView;
//排名数组
@property(nonatomic,strong)NSArray *rankList;
@property(nonatomic,strong)NSArray *colors;
//专业数组
@property(nonatomic,strong)NSArray *subjectList;
//自定义导航栏
@property(nonatomic,strong)TopNavView *topView;
//工具条
@property(nonatomic,strong)XBTopToolView  *topToolView;
//热门城市数组
@property(nonatomic,strong)NSArray  *country_Hotes;


@end

@implementation CatigoryViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    [MobClick beginLogPageView:@"page分类搜索"];
    
   
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page分类搜索"];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
    
    [self makeDataSource];
    
}


//获取热门城市数组
-(void)makeDataSource
{
    
    XWeakSelf
    
    [self startAPIRequestUsingCacheWithSelector:kAPISelectorCatigoryHotCities parameters:nil success:^(NSInteger statusCode, id response) {
        
        [weakSelf updateCityUIWithResponse:response];
        
    }];
}

//更新热门留学目的地
- (void)updateCityUIWithResponse:(id)response{

    self.country_Hotes =[CatigaryCountry mj_objectArrayWithKeyValuesArray:response[@"hot"]];
    
    for (CatigaryCountry *country in self.country_Hotes) {
        
        //给每组添加最后一个数据
        CatigaryHotCity *last_city = [[CatigaryHotCity alloc] init];
        last_city.country = country.country;
        
        NSString *imageName = @"ao_more.jpg";
        if ([country.country containsString:@"英"]) imageName = @"uk_more.jpg";
        if ([country.country containsString:@"美"]) imageName = @"usa_more.jpg";
        last_city.imageName = imageName;
        
        [country.hot_cities addObject:last_city];
    }
    
    [self.city_tableView reloadData];
}

//排名列表
-(NSArray *)rankList
{
    if (!_rankList) {
        
        CatigoryRank *rank_en = [CatigoryRank rankItemInitWithIconName:@"Rank_ENG" titleName:@"TIMES英国排名+TIMES UK University Rankings" rankType:RANK_TI];
        CatigoryRank *rank_au = [CatigoryRank rankItemInitWithIconName:@"Rank_AU" titleName:@"QS澳大利业大学排名+QS Australia University Rankings" rankType:RANK_TI];
        CatigoryRank *rank_qs = [CatigoryRank rankItemInitWithIconName:@"Rank_AU" titleName:@"QS世界排名+QS World University Rankings"  rankType:RANK_QS];
        
        _rankList = @[rank_en,rank_au,rank_qs];
        
    }
    return _rankList;
}

- (NSArray *)colors{

    if (!_colors) {
        
        _colors = @[XCOLOR(217, 231, 236, 1),XCOLOR(240, 235, 227, 1),XCOLOR(238, 232, 240, 1)];

    }
    
    return _colors;
}


//专业数据数组
-(NSArray *)subjectList
{
    
    if (!_subjectList) {
        
        NSArray *item_subjects = [[NSUserDefaults standardUserDefaults] valueForKey:@"Subject_CN"];
        
        if (item_subjects.count) {
            
            NSMutableArray *subject_temps = [NSMutableArray array];
            
            for (NSInteger  index = 0 ; index < item_subjects.count ; index ++) {
                
                NSDictionary *item = item_subjects[index];
                
                NSString *iconName;
                NSString *itemName = item[@"name"];
                if ([item[@"name"] containsString:@"经济"]) {
                    iconName = @"sub_finance";
                }else if ([item[@"name"] containsString:@"商科"]){
                    iconName = @"sub_business";
                }else if ([item[@"name"] containsString:@"工程"]){
                    iconName = @"sub_engineer";
                }else if ([item[@"name"] containsString:@"人文"]){
                    iconName = @"sub_humanit";
                }else if ([item[@"name"] containsString:@"理学"]){
                    iconName = @"sub_sciencee";
                }else if ([item[@"name"] containsString:@"建筑"]){
                    iconName = @"sub_built";
                }else if ([item[@"name"] containsString:@"艺术"]){
                    iconName = @"sub_art";
                }else if ([item[@"name"] containsString:@"医"]){
                    iconName = @"sub_medicine";
                }else if ([item[@"name"] containsString:@"农"]){
                    iconName = @"sub_farm";
                }
                
                CatigorySubject *subject =[CatigorySubject subjectItemInitWithIcon:iconName  title:itemName];
                [subject_temps addObject:subject];
            }
            
            _subjectList =  [subject_temps copy];
            
            
        }else{
            
            //备用数据，防止数据失败读取
            CatigorySubject *art =[CatigorySubject subjectItemInitWithIcon:@"sub_art"  title:GDLocalizedString(@"CategorySub-art")];
            CatigorySubject *finance =[CatigorySubject subjectItemInitWithIcon:@"sub_finance"  title:GDLocalizedString(@"CategorySub-finance")];
            CatigorySubject *built =[CatigorySubject subjectItemInitWithIcon:@"sub_built"  title:@"建筑与规划"];
            CatigorySubject *humanity =[CatigorySubject subjectItemInitWithIcon:@"sub_humanit"  title:GDLocalizedString(@"CategorySub-humanity")];
            CatigorySubject *engineer =[CatigorySubject subjectItemInitWithIcon:@"sub_engineer"  title:GDLocalizedString(@"CategorySub-engineer")];
            CatigorySubject *medicine =[CatigorySubject subjectItemInitWithIcon:@"sub_medicine"  title:GDLocalizedString(@"CategorySub-medicine")];
            CatigorySubject *business =[CatigorySubject subjectItemInitWithIcon:@"sub_business"  title:GDLocalizedString(@"CategorySub-business")];
            CatigorySubject *farm =[CatigorySubject subjectItemInitWithIcon:@"sub_farm"  title:GDLocalizedString(@"CategorySub-farm")];
            CatigorySubject *science =[CatigorySubject subjectItemInitWithIcon:@"sub_sciencee"  title:GDLocalizedString(@"CategorySub-science")];
          
            _subjectList = @[finance,business,engineer,humanity,science,built,art,medicine,farm];
            
        }
        
        
    }
    
    return _subjectList;
}


//导航工具条
- (void)makeTopView{
    
    self.topView= [[TopNavView alloc] initWithFrame:CGRectMake(0,  0, XSCREEN_WIDTH, XNAV_HEIGHT)];
 
    [self.view addSubview:self.topView];
    
    [self makeTopToolView];
    
    [self makeBaseScorller];
    
}

//滚动工具条
- (void)makeTopToolView{
    
    self.topToolView = [[XBTopToolView alloc] initWithFrame:CGRectMake(0,26,XSCREEN_WIDTH, TOP_HIGHT)];
    self.topToolView.itemNames = @[@"地区",@"专业",@"排名"];
    self.topToolView.delegate  = self;
    [self.view addSubview: self.topToolView];
    
    UIButton *searchBtn = [[UIButton alloc] init];
    [self.view addSubview:searchBtn];
    [searchBtn setImage:[UIImage imageNamed:@"search_icon"]  forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    searchBtn.imageView.contentMode = UIViewContentModeCenter;
    CGFloat search_W = 20;
    CGFloat search_H = search_W;
    CGFloat search_X = XSCREEN_WIDTH - search_W - 16;
    CGFloat search_Y = 0;
    searchBtn.frame =  CGRectMake(search_X, search_Y, search_W, search_H);
    searchBtn.center = CGPointMake(searchBtn.center.x, self.topToolView.center.y);
    
 }


- (void)makeBaseScorller{
    
    CGFloat baseX = 0;
    CGFloat baseY = CGRectGetMaxY(self.topView.frame);
    CGFloat baseW = XSCREEN_WIDTH;
    CGFloat baseH = XSCREEN_HEIGHT - 49- XNAV_HEIGHT;//49为底部导航高度
    self.bgView = [CatigaryScrollView viewWithFrame:CGRectMake(baseX, baseY, baseW,baseH)];
    self.bgView.bounces = NO;
    self.bgView.delegate = self;
    [self.view addSubview:self.bgView];
    self.bgView.backgroundColor = XCOLOR_WHITE;
    
    //热门城市
    [self makeCityCollectViewWithFrame:CGRectMake(baseW * 0, 0, baseW,baseH)];
    //热门专业
    [self makeSubjectCollectViewWithFrame:CGRectMake(baseW * 1, 0, baseW,baseH)];
    //国家排名
    [self makeRankTableViewWithFrame:CGRectMake(baseW * 2, 0, baseW,baseH)];
    
}

//热门城市
- (void)makeCityCollectViewWithFrame:(CGRect)frame{
    
    self.city_tableView =[self tableViewWithUITableViewStyle:UITableViewStyleGrouped frame:frame];
    [self.bgView addSubview:self.city_tableView];
    
}

- (UITableView *)tableViewWithUITableViewStyle:(UITableViewStyle)type frame:(CGRect)frame{

    UITableView *tableView =[[UITableView alloc] initWithFrame:frame style:type];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView =[[UIView alloc] init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return tableView;
}


//国家排名
-(void)makeRankTableViewWithFrame:(CGRect)frame
{
    self.rank_tableView =[self tableViewWithUITableViewStyle:UITableViewStylePlain frame:frame];
    self.rank_tableView.backgroundColor = XCOLOR_WHITE;
    [self.bgView addSubview:self.rank_tableView];

}

//热门专业
-(void)makeSubjectCollectViewWithFrame:(CGRect)frame
{
    NomalCollectionController *nomalCollectionVC  = [[NomalCollectionController alloc] init];
    [self addChildViewController:nomalCollectionVC];
    [self.bgView addSubview:nomalCollectionVC.view];
    nomalCollectionVC.view.frame = frame;
    self.nomalCollectionVC = nomalCollectionVC;
    nomalCollectionVC.items = self.subjectList;
    nomalCollectionVC.type = CollectionTypeSubject;
}


- (void)makeUI{
    
    [self makeTopView];
  
}


#pragma mark : UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return  tableView == self.city_tableView ? self.country_Hotes.count : self.rankList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

static NSString *rankIdentify = @"rankStyle";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (tableView == self.rank_tableView) {
        
        
        CatigaryRankkCell *rank_cell =  [tableView dequeueReusableCellWithIdentifier:rankIdentify];
        
        if (!rank_cell) {
            
            rank_cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CatigaryRankkCell class])  owner:self options:nil].lastObject;
        }
        
        rank_cell.rank = self.rankList[indexPath.section];
        
        rank_cell.bgView.backgroundColor = self.colors[indexPath.section];
         
        return rank_cell;
        
    }
    
    
        CatigaryHotCityCell *cell =[CatigaryHotCityCell cellInitWithTableView:tableView];
        
        CatigaryCountry *country  = self.country_Hotes[indexPath.section];
        
        cell.hot_cities = country.hot_cities;

       [cell bottomLineShow: (self.country_Hotes.count - 1) != indexPath.section];

        cell.actionBlock = ^(NSString *city){
            
            //设置一个更多城市，城市名称为空，城市名称是否为空，做为跳转判断的标准
            city ? [self CaseHotCityWithCityName:city belongCountry:country.country] :  [self CaseStateWithSection:indexPath.section];
            
        };
        
        
        return cell;
   
    
   

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.city_tableView) return;
    
    CatigoryRank *rank = self.rankList[indexPath.section];
    
    [rank.countryName containsString:@"澳"] ?   [self CaseAU:rank] : [self CaseUK:rank] ;
 }


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section; {
    
    NSString *title;
    if (tableView == self.city_tableView) {
          
        CatigaryCountry *group = self.country_Hotes[section];
        title = group.country;
    }
    
    HomeSectionHeaderView *SectionView =[HomeSectionHeaderView sectionHeaderViewWithTitle:title];
    SectionView.backgroundColor = XCOLOR_WHITE;
    [SectionView arrowButtonHiden:!(tableView == self.city_tableView)];
    SectionView.actionBlock = ^{
        
        [self CaseStateWithSection:section];
    };
   

    return SectionView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return tableView == self.city_tableView ? FLOWLAYOUT_CityW + 20 : 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return (tableView == self.city_tableView ) ?  Section_header_Height_nomal : 12;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return HEIGHT_ZERO;
}

#pragma mark : UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
//    if ([scrollView isKindOfClass:[UICollectionView class]]) return;
//    if ([scrollView isKindOfClass:[UITableView class]] || !scrollView.isDragging)  return;
    
    if (self.bgView.isDragging) {
        
        //监听滚动，实现顶部工具条按钮切换
        
        CGFloat offsetX = scrollView.contentOffset.x;
        
        CGFloat width = scrollView.frame.size.width;
        
        NSInteger pageNum =  (offsetX + .5f *  width) / width;
        
        [self.topToolView setSelectedIndex:pageNum];
        // 限制y轴不动
        self.bgView.contentSize =  CGSizeMake(3 * XSCREEN_WIDTH, 0);
    }
    
}


#pragma mark : XTopToolViewDelegate

- (void)XTopToolView:(XBTopToolView *)topToolView andButtonItem:(UIButton *)sender{
    
    [self.bgView setContentOffset:CGPointMake(XSCREEN_WIDTH * sender.tag, 0) animated:YES];
}



- (void)leftViewMessage:(NSNotification *)noti{
    
    NSString *object = (NSString *)noti.object;
    
    if (1 == object.integerValue){
    
    }
    
}


//打开左侧菜单
-(void)showLeftMenu{
    
    [self.sideMenuViewController presentLeftMenuViewController];
    
}

//打开搜索
-(void)searchButtonPressed:(UIBarButtonItem *)barButton {
    
    [self presentViewController:[[XWGJNavigationController alloc] initWithRootViewController:[[SearchViewController alloc] init]] animated:YES completion:nil];
}


//英国、世界排名
-(void)CaseUK:(CatigoryRank *)rank
{
    
    SearchResultViewController *vc = [[SearchResultViewController alloc] initWithFilter:@"country" value:rank.countryName orderBy:rank.rankType];
    
    vc.title  = [rank.titleName containsString:@"+"] ? [rank.titleName componentsSeparatedByString:@"+"][1] : rank.titleName;
    
    [self.navigationController pushViewController:vc animated:YES];
}


//澳大利亚排名
-(void)CaseAU:(CatigoryRank *)rank
{
    
    AUSearchResultViewController *newVc = [[AUSearchResultViewController alloc] initWithFilter:@"country" value:rank.countryName orderBy:rank.rankType];
    
    newVc.title  = [rank.titleName containsString:@"+"] ? [rank.titleName componentsSeparatedByString:@"+"][1] : rank.titleName;
    
    [self.navigationController pushViewController:newVc animated:YES];
    
}


//热门留学城市
-(void)CaseHotCityWithCityName:(NSString *)CityName belongCountry:(NSString *)country
{
    
    
    SearchUniversityCenterViewController *vc = [[SearchUniversityCenterViewController alloc] initWithKey:KEY_CITY value:CityName country:country];
   
    [self.navigationController pushViewController:vc animated:YES];
}

//英国、澳大利亚地区列表
-(void)CaseStateWithSection:(NSInteger)section{
    
    CatigaryCountry *country = self.country_Hotes[section];
    
    CountryStateViewController *country_state= [[CountryStateViewController alloc] init];
    
    country_state.countryName = country.country;
    
    [self.navigationController pushViewController:country_state animated:YES];
}

//从首页跳转到热门留学目的地
- (void)jumpToHotCity{

    [self.bgView setContentOffset:CGPointZero animated:YES];
    
    [self.topToolView setSelectedIndex:0];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
