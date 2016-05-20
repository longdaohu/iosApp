//
//  XWGJCatigoryViewController.m
//  myOffer
//
//  Created by xuewuguojie on 16/2/29.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "XWGJCatigoryViewController.h"
#import "XWGJRankTableViewCell.h"
#import "XWGJSubjectCollectionViewCell.h"
#import "XWGJCityCollectionViewCell.h"
#import "XWGJCityCollectionReusableView.h"
#import "XWGJCityCollectionViewHeaderView.h"
#import "XWGJBanView.h"
#import "XWGJRank.h"
#import "XWGJCatigorySubject.h"
#import "XWGJStateViewController.h"
#import "XWGJHotCity.h"
#import "SearchViewController.h"
#import "XWGJLXCountry.h"
#import "XWGJScrollView.h"
#import "NewSearchResultViewController.h"
#import "XNewSearchViewController.h"
#define INTERSET_TOP  70.0

@interface XWGJCatigoryViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
//背景scroller
@property(nonatomic,strong)XWGJScrollView *baseScroller;
//排名tableView
@property(nonatomic,strong)UITableView *tableView;
//专业collectionView
@property(nonatomic,strong)UICollectionView *Sub_CollectView;
//热门城市collectionView
@property(nonatomic,strong)UICollectionView *City_CollectView;
//排名数组
@property(nonatomic,strong)NSArray *RankList;
//专业数组
@property(nonatomic,strong)NSArray *SubjectList;
//表头
@property(nonatomic,strong)XWGJCityCollectionViewHeaderView *cityHeaderView;
//工具条
@property(nonatomic,strong)XWGJBanView  *bg_SelectView;
//热门城市数组
@property(nonatomic,strong)NSArray  *countryes;

@end


@implementation XWGJCatigoryViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
    
    [self getHotCitySource];
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    
    [MobClick beginLogPageView:@"page分类搜索"];

}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page分类搜索"];
    
}





//获取热门城市数组
-(void)getHotCitySource
{
    
    XJHUtilDefineWeakSelfRef
    [self startAPIRequestUsingCacheWithSelector:kAPISelectorCatigoryHotCities parameters:nil success:^(NSInteger statusCode, id response) {
        
        NSMutableArray *countryM  =[NSMutableArray array];
 
        for (NSDictionary *countryDic in response[@"hot"]) {
            
            XWGJLXCountry *country =[XWGJLXCountry ContryItemInitWithCountryDictionary:countryDic];
  
            [countryM addObject:country];
        }
        
        weakSelf.countryes = [countryM copy];
        
        [weakSelf.City_CollectView reloadData];
        
    }];
}


-(NSArray *)RankList
{
    if (!_RankList) {
        
        XWGJRank *rank_en = [XWGJRank rankItemInitWithIconName:@"Rank_ENG" TitleName:GDLocalizedString(@"Categoryrank-en") RankKey:@"ranking_ti"];
        XWGJRank *rank_au = [XWGJRank rankItemInitWithIconName:@"Rank_AU" TitleName:GDLocalizedString(@"Categoryrank-au")  RankKey:@"ranking_ti"];
        XWGJRank *rank_qs = [XWGJRank rankItemInitWithIconName:@"Rank_QS" TitleName:GDLocalizedString(@"Categoryrank-qs")  RankKey:@"ranking_qs"];
         _RankList = @[rank_en,rank_au,rank_qs];
        
    }
    return _RankList;
}



-(NSArray *)SubjectList
{
    if (!_SubjectList) {
        
        XWGJCatigorySubject *art =[XWGJCatigorySubject subjectItemInitWithIconName:@"sub_art"  TitleName:GDLocalizedString(@"CategorySub-art")];
        XWGJCatigorySubject *finance =[XWGJCatigorySubject subjectItemInitWithIconName:@"sub_finance"  TitleName:GDLocalizedString(@"CategorySub-finance")];
        XWGJCatigorySubject *social =[XWGJCatigorySubject subjectItemInitWithIconName:@"sub_social"  TitleName:GDLocalizedString(@"CategorySub-social")];
        XWGJCatigorySubject *humanity =[XWGJCatigorySubject subjectItemInitWithIconName:@"sub_humanit"  TitleName:GDLocalizedString(@"CategorySub-humanity")];
        XWGJCatigorySubject *engineer =[XWGJCatigorySubject subjectItemInitWithIconName:@"sub_engineer"  TitleName:GDLocalizedString(@"CategorySub-engineer")];
        XWGJCatigorySubject *education =[XWGJCatigorySubject subjectItemInitWithIconName:@"sub_education"  TitleName:GDLocalizedString(@"CategorySub-education")];
        XWGJCatigorySubject *medicine =[XWGJCatigorySubject subjectItemInitWithIconName:@"sub_medicine"  TitleName:GDLocalizedString(@"CategorySub-medicine")];
        XWGJCatigorySubject *business =[XWGJCatigorySubject subjectItemInitWithIconName:@"sub_business"  TitleName:GDLocalizedString(@"CategorySub-business")];
        XWGJCatigorySubject *farm =[XWGJCatigorySubject subjectItemInitWithIconName:@"sub_farm"  TitleName:GDLocalizedString(@"CategorySub-farm")];
        XWGJCatigorySubject *science =[XWGJCatigorySubject subjectItemInitWithIconName:@"sub_sciencee"  TitleName:GDLocalizedString(@"CategorySub-science")];
        _SubjectList = @[art,finance,social,humanity,engineer,education,medicine,business,farm,science];
        
          }
    return _SubjectList;
}


-(void)makeBaseScorller
{
    self.baseScroller = [[XWGJScrollView alloc] initWithFrame:CGRectMake(0, 0, XScreenWidth, XScreenHeight - 64)];
    self.baseScroller.contentSize = CGSizeMake(3*XScreenWidth, XScreenHeight);
    self.baseScroller.pagingEnabled = YES;
    self.baseScroller.delegate = self;
    self.baseScroller.alwaysBounceHorizontal = YES;
    self.baseScroller.directionalLockEnabled = YES;
    self.baseScroller.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.baseScroller];
}

-(void)makeRankTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(2*XScreenWidth, 0, XScreenWidth, XScreenHeight-114) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.contentInset = UIEdgeInsetsMake(INTERSET_TOP, 0, 0, 0);
    self.tableView.backgroundColor = XCOLOR_CLEAR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.baseScroller  addSubview:self.tableView];
    
}
-(void)makeCityCollectView
{
    CGRect cityRect = CGRectMake(0, 0, XScreenWidth, XScreenHeight - 114);
    CGFloat topHigh = 2 * (Country_Width - 20) + 45 + INTERSET_TOP;
    
    self.City_CollectView = [self makeCollectionViewWithFlowayoutWidth:FLOWLAYOUT_CityW andFrame:cityRect andcontentInset:UIEdgeInsetsMake(topHigh, 0, 40, 0)];
   
    
    UINib *city_xib = [UINib nibWithNibName:@"XWGJCityCollectionViewCell" bundle:nil];
    [self.City_CollectView registerNib:city_xib forCellWithReuseIdentifier:cityIdentify];
    
    
    UINib *citySection_xib = [UINib nibWithNibName:@"XWGJCityCollectionReusableView" bundle:nil];
    [self.City_CollectView registerNib:citySection_xib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"citySectionView"];
    
    self.cityHeaderView = [[XWGJCityCollectionViewHeaderView alloc] initWithFrame:CGRectMake(0, -topHigh, XScreenWidth, topHigh)];
   
    XJHUtilDefineWeakSelfRef
    
    self.cityHeaderView.actionBlock = ^(UIButton *sender){
         XWGJStateViewController *STATE = [[XWGJStateViewController alloc] init];
        STATE.countryName = sender.tag == 0 ? GDLocalizedString(@"CategoryVC-UK"):GDLocalizedString(@"CategoryVC-AU");
        [weakSelf.navigationController pushViewController:STATE animated:YES];
    };
    
    [self.City_CollectView addSubview:self.cityHeaderView];
  
}

-(void)makeSubjectCollectView
{
    CGRect subRect = CGRectMake(XScreenWidth, 0, XScreenWidth, XScreenHeight-114);
    self.Sub_CollectView = [self makeCollectionViewWithFlowayoutWidth:FLOWLAYOUT_SubW andFrame:subRect andcontentInset:UIEdgeInsetsMake(INTERSET_TOP, 0, 0, 0)];
    UINib *sub_xib = [UINib nibWithNibName:@"XWGJSubjectCollectionViewCell" bundle:nil];
    [self.Sub_CollectView registerNib:sub_xib forCellWithReuseIdentifier:subjectIdentify];
}



//创建CollectionView公共方法
-(UICollectionView *)makeCollectionViewWithFlowayoutWidth:(CGFloat)width andFrame:(CGRect)frame andcontentInset:(UIEdgeInsets)Inset
{
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    // 设置每一个cell的宽高 (cell在CollectionView中称之为item)
    flowlayout.itemSize = CGSizeMake(width, width);
    // 设置item行与行之间的间隙
    flowlayout.minimumLineSpacing = ITEM_MARGIN;
    // 设置item列与列之间的间隙
//    flowlayout.minimumInteritemSpacing = ITEM_MARGIN;
    flowlayout.sectionInset = UIEdgeInsetsMake(0, ITEM_MARGIN, 0, ITEM_MARGIN);
    [flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowlayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = XCOLOR_CLEAR;
    collectionView.contentInset = Inset;
    
    [self.baseScroller addSubview:collectionView];
    
    return collectionView;
}


-(void)makeBanView
{
    XJHUtilDefineWeakSelfRef
 
     CGFloat sh =  60;
    
    self.bg_SelectView = [[XWGJBanView alloc] initWithFrame:CGRectMake(0, 0,XScreenWidth,sh)];
    
    [self.view addSubview:self.bg_SelectView];
    
    //顶部工具栏切换页面
    self.bg_SelectView.actionBlock = ^(UIButton *sender){
        
        [weakSelf.baseScroller setContentOffset:CGPointMake(XScreenWidth*sender.tag, 0) animated:YES];
        
    };
  
}




-(void)makeUI
{

    [self makeOtherUI];
    
    [self makeBaseScorller];
    
    [self makeRankTableView];
    
    [self makeSubjectCollectView];
    
    [self makeCityCollectView];
    
    [self makeBanView];
    
    
}


-(void)makeOtherUI
{
    
    //自定义导航栏左侧按钮
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,40, 40)];
    rightButton.imageEdgeInsets = UIEdgeInsetsMake(-3, -20, 0, 0);
    [rightButton setImage:[UIImage imageNamed:@"menu_white"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(showLeftMenu:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tabbar_discover"] style:UIBarButtonItemStylePlain target:self action:@selector(searchButtonPressed:)];
    
}



#pragma mark ——————UICollectionViewDelegateFlowLayout
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{
    if (collectionView == self.City_CollectView) {
        
        if (kind == UICollectionElementKindSectionHeader){
            
            XWGJCityCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"citySectionView" forIndexPath:indexPath];
          
            XWGJLXCountry *country = self.countryes[indexPath.section];
            
            headerView.TitleLab.text = country.countryName;
            
            return  headerView;
            
        }else{
            
            return nil;
        }
        
    }else{
        
        return nil;
        
    }
    
}


#pragma mark —————— UICollectionViewDataSource UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    NSInteger setionNumber = collectionView == self.Sub_CollectView ? 1 : self.countryes.count;
    
    return setionNumber;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (collectionView == self.City_CollectView) {
        
        XWGJLXCountry *country = self.countryes[section];

        return country.HotCities.count;
        
    }else{
    
        return  self.SubjectList.count;
        
    }
    
}
static NSString *subjectIdentify = @"subjectCell";
static NSString *cityIdentify = @"cityCell";

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.Sub_CollectView) {
        
        XWGJSubjectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:subjectIdentify forIndexPath:indexPath];
        cell.subject =self.SubjectList[indexPath.row];
        
        return cell;
        
    }else{
        
        XWGJCityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cityIdentify forIndexPath:indexPath];
        
        XWGJLXCountry *country = self.countryes[indexPath.section];
        
        cell.city = country.HotCities[indexPath.row];
        
 
         return cell;
    }
    
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
     if (collectionView == self.City_CollectView) {
        
        return CGSizeMake(XScreenWidth, 40);
        
    }else{
        
        return CGSizeMake(0, 0);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (collectionView == self.Sub_CollectView) {
        
         XWGJCatigorySubject *subject = self.SubjectList[indexPath.row];
        
         XNewSearchViewController *vc = [[XNewSearchViewController alloc] initWithFilter:@"area" value:subject.TitleName orderBy:RANKQS];
        
         vc.CoreArea = subject.TitleName;
        
         [self.navigationController pushViewController:vc animated:YES];
        
    }else {
        
        XWGJLXCountry *country = self.countryes[indexPath.section];
        
        XWGJHotCity *city = country.HotCities[indexPath.row];
        
        SearchResultViewController *vc = [[SearchResultViewController alloc] initWithFilter:@"city" value:city.cityName orderBy:RANKTI];
        vc.xby = indexPath.section == 0 ? NO : YES;
         [self.navigationController pushViewController:vc animated:YES];
    }
    
}


#pragma mark —————— UITableViewDelegate  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.RankList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    XWGJRankTableViewCell *cell = [XWGJRankTableViewCell cellInitWithTableView:tableView];
    cell.rank = self.RankList[indexPath.row];
  
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XWGJRank *rank = self.RankList[indexPath.row];
    
    if (1 == indexPath.row) {
        
        NewSearchResultViewController *newVc = [[NewSearchResultViewController alloc] initWithFilter:@"country" value:rank.countryName orderBy:rank.key];
     
        newVc.title  = [rank.TitleName containsString:@"+"] ? [rank.TitleName componentsSeparatedByString:@"+"][1] : rank.TitleName;
        
        [self.navigationController pushViewController:newVc animated:YES];
        
    }else{
    
        SearchResultViewController *vc = [[SearchResultViewController alloc] initWithFilter:@"country" value:rank.countryName orderBy:rank.key];
        
        vc.title  = [rank.TitleName containsString:@"+"] ? [rank.TitleName componentsSeparatedByString:@"+"][1] : rank.TitleName;
        
        [self.navigationController pushViewController:vc animated:YES];
    
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return Country_Width;
}


#pragma mark ————————UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        
    }else{
        
        if ([scrollView isKindOfClass:[UITableView class]] ) {
            
            return;
         }
        
        
        if (!scrollView.isDragging) {
            
            return;
        }

        //监听滚动，实现顶部工具条按钮切换
        CGPoint offset = scrollView.contentOffset;
        
        CGFloat offsetX = offset.x;
        
        CGFloat width = scrollView.frame.size.width;
        
        int pageNum = (offsetX + .5f *  width) / width;
        
        UIButton *sender= (UIButton *)self.bg_SelectView.SelectView.subviews[pageNum];
        
        UIButton *lastBtn = self.bg_SelectView.lastBtn;
        
        if (sender != lastBtn) {
            
//            sender.enabled = NO;
//            
//            lastBtn.enabled = YES;
//            
//            self.bg_SelectView.lastBtn = sender;
//            
//            CGRect NewRect = self.bg_SelectView.FocusView.frame;
//            
//            NewRect.origin.x = ITEM_MARGIN + sender.tag * NewRect.size.width;
//            
//            [UIView animateWithDuration:0.5 animations:^{
//                
//                self.bg_SelectView.FocusView.frame = NewRect;
//                
//            }];
            
            [self.bg_SelectView selectBtnClick:sender];
        }
        
        // 限制y轴不动
        self.baseScroller.contentSize =  CGSizeMake(3 * XScreenWidth, 0);

    }
}

//打开左侧菜单
-(void)showLeftMenu:(UIBarButtonItem *)barButton
{
    [self.sideMenuViewController presentLeftMenuViewController];
    
}

//打开搜索
-(void)searchButtonPressed:(UIBarButtonItem *)barButton {
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    XWGJNavigationController *nav = [[XWGJNavigationController alloc] initWithRootViewController:searchVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end