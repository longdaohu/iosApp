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
#import "XNewSearchViewController.h"
#import "XBTopToolView.h"
#import "TopNavView.h"
#import "NomalCollectionController.h"
#import "CatigoryRankStyleCell.h"

#define INTERSET_TOP  10.0

@interface CatigoryViewController ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,XTopToolViewDelegate>
//背景scroller
@property(nonatomic,strong)CatigaryScrollView *bgView;
//排名tableView
//@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UICollectionView *rank_collectView;
//专业collectionView
@property(nonatomic,strong)NomalCollectionController *nomalCollectionVC;
//热门城市collectionView
@property(nonatomic,strong)UICollectionView *City_CollectView;
//排名数组
@property(nonatomic,strong)NSArray *RankList;
//专业数组
@property(nonatomic,strong)NSArray *subjectList;
//自定义导航栏
@property(nonatomic,strong)TopNavView *topView;
//工具条
@property(nonatomic,strong)XBTopToolView   *topToolView;
//热门城市数组
@property(nonatomic,strong)NSArray  *Country_Hotcities;
//是否有新消息图标
@property(nonatomic,strong)LeftBarButtonItemView *leftView;

@end

@implementation CatigoryViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    
    [MobClick beginLogPageView:@"page分类搜索"];
    
    [self leftViewMessage];
    
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
        
        NSMutableArray *Country_Hotcities_temp  =[NSMutableArray array];
        
        for (NSDictionary *countryDic in response[@"hot"]) {
            
            CatigaryCountry *country =[CatigaryCountry ContryItemInitWithCountryDictionary:countryDic];
            
            [Country_Hotcities_temp addObject:country];
        }
        
        weakSelf.Country_Hotcities = [Country_Hotcities_temp copy];
        
        [weakSelf.City_CollectView reloadData];
        
    }];
}

//排名列表
-(NSArray *)RankList
{
    if (!_RankList) {
        
        CatigoryRank *rank_en = [CatigoryRank rankItemInitWithIconName:@"Rank_ENG" titleName:@"TIMES\n英国大学排名" rankType:RANK_TI];
        CatigoryRank *rank_au = [CatigoryRank rankItemInitWithIconName:@"Rank_AU" titleName:@"Australia\n澳大利业大学排名" rankType:RANK_TI];
        CatigoryRank *rank_qs = [CatigoryRank rankItemInitWithIconName:@"Rank_QS" titleName:@"QS世界排名"  rankType:RANK_QS];
        _RankList = @[rank_en,rank_au,rank_qs];
        
    }
    return _RankList;
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
                
                CatigorySubject *subject =[CatigorySubject subjectItemInitWithIconName:iconName  TitleName:itemName];
                [subject_temps addObject:subject];
            }
            
            _subjectList =  [subject_temps copy];
            
            
        }else{
            
            //备用数据，防止数据失败读取
            CatigorySubject *art =[CatigorySubject subjectItemInitWithIconName:@"sub_art"  TitleName:GDLocalizedString(@"CategorySub-art")];
            CatigorySubject *finance =[CatigorySubject subjectItemInitWithIconName:@"sub_finance"  TitleName:GDLocalizedString(@"CategorySub-finance")];
            CatigorySubject *built =[CatigorySubject subjectItemInitWithIconName:@"sub_built"  TitleName:@"建筑与规划"];
            CatigorySubject *humanity =[CatigorySubject subjectItemInitWithIconName:@"sub_humanit"  TitleName:GDLocalizedString(@"CategorySub-humanity")];
            CatigorySubject *engineer =[CatigorySubject subjectItemInitWithIconName:@"sub_engineer"  TitleName:GDLocalizedString(@"CategorySub-engineer")];
            CatigorySubject *medicine =[CatigorySubject subjectItemInitWithIconName:@"sub_medicine"  TitleName:GDLocalizedString(@"CategorySub-medicine")];
            CatigorySubject *business =[CatigorySubject subjectItemInitWithIconName:@"sub_business"  TitleName:GDLocalizedString(@"CategorySub-business")];
            CatigorySubject *farm =[CatigorySubject subjectItemInitWithIconName:@"sub_farm"  TitleName:GDLocalizedString(@"CategorySub-farm")];
            CatigorySubject *science =[CatigorySubject subjectItemInitWithIconName:@"sub_sciencee"  TitleName:GDLocalizedString(@"CategorySub-science")];
            _subjectList = @[finance,business,engineer,humanity,science,built,art,medicine,farm];
            
        }
        
        
    }
    
    return _subjectList;
}


//导航工具条
- (void)makeTopView{
    
    self.topView= [[TopNavView alloc] initWithFrame:CGRectMake(0,  -XNAV_HEIGHT, XSCREEN_WIDTH, XNAV_HEIGHT + 60)];
    [self.view addSubview:self.topView];
    
    [self makeTopToolView];
    
    [self makeBaseScorller];
    
}

//滚动工具条
- (void)makeTopToolView{
    
    self.topToolView = [[XBTopToolView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame) - TOP_HIGHT - ITEM_MARGIN,XSCREEN_WIDTH, TOP_HIGHT)];
    self.topToolView.itemNames = @[GDLocalizedString(@"CategoryNew-region"),GDLocalizedString(@"CategoryNew-major"),GDLocalizedString(@"CategoryNew-rank")];
    self.topToolView.delegate  = self;
    [self.view  addSubview:self.topToolView];
}


- (void)makeBaseScorller{
    
    CGFloat baseX = 0;
    CGFloat baseY = CGRectGetMaxY(self.topView.frame);
    CGFloat baseW = XSCREEN_WIDTH;
    CGFloat baseH = XSCREEN_HEIGHT - 49 - baseY - XNAV_HEIGHT;//49为底部导航高度
    self.bgView = [CatigaryScrollView viewWithFrame:CGRectMake(baseX, baseY, baseW,baseH)];
    self.bgView.delegate = self;
    [self.view addSubview:self.bgView];
    //热门城市
    [self makeCityCollectViewWithFrame:CGRectMake(baseW * 0, 0, baseW,baseH)];
    //热门专业
    [self makeSubjectCollectViewWithFrame:CGRectMake(baseW * 1, 0, baseW,baseH)];
    //国家排名
    [self makeRankTableViewWithFrame:CGRectMake(baseW * 2, 0, baseW,baseH)];
    
}

//热门城市
- (void)makeCityCollectViewWithFrame:(CGRect)frame{
    
    
    /*
     //设置每一个cell的宽高 (cell在CollectionView中称之为item)
     flowlayout.itemSize = CGSizeMake(width, width);
     // 设置item行与行之间的间隙
     flowlayout.minimumLineSpacing = ITEM_MARGIN;
     //设置item列与列之间的间隙
     flowlayout.minimumInteritemSpacing = ITEM_MARGIN;
     flowlayout.sectionInset = UIEdgeInsetsMake(0, ITEM_MARGIN, 0, ITEM_MARGIN);
     */
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    [flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowlayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = XCOLOR_CLEAR;
    [self.bgView addSubview:collectionView];
    self.City_CollectView =  collectionView;
    
    
    [self.City_CollectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    
    [self.City_CollectView registerNib:[UINib nibWithNibName:@"CatigaryCityCollectionCell" bundle:nil] forCellWithReuseIdentifier:cityCellReuse];
    [self.City_CollectView registerNib:[UINib nibWithNibName:@"CatigaryCityCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:citySectionReuse];
    
    
}

//国家排名
-(void)makeRankTableViewWithFrame:(CGRect)frame
{
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowlayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.contentInset = UIEdgeInsetsMake(ITEM_MARGIN, 0, 0, 0);
    collectionView.backgroundColor = XCOLOR_CLEAR;
    self.rank_collectView =  collectionView;
    [self.bgView addSubview:collectionView];
    
    [self.rank_collectView registerNib: [UINib nibWithNibName:@"CatigoryRankStyleCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:rankCellReuse];

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
    
    [self makeOtherUI];
}

- (void)makeOtherUI{
    
    XWeakSelf
    self.leftView =[LeftBarButtonItemView leftViewWithBlock:^{
        
        [weakSelf showLeftMenu];
        
    }];
    
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]  initWithCustomView:self.leftView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tabbar_discover"] style:UIBarButtonItemStylePlain target:self action:@selector(searchButtonPressed:)];
}



#pragma mark ——————UICollectionViewDelegateFlowLayout
static NSString *citySectionReuse = @"citySectionView";
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.City_CollectView && kind == UICollectionElementKindSectionHeader) {
        
        CatigaryCityCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:citySectionReuse forIndexPath:indexPath];
        
        NSString *headerTitle;
        
        if (indexPath.section == 0) {
            
            headerTitle = @"国家";
            
        }else{
            
            CatigaryCountry *country = self.Country_Hotcities[indexPath.section - 1];
            headerTitle  = country.countryName;
        }
        headerView.sectionNameLab.text = headerTitle;
        
        return  headerView;
        
        
    }
    
 
    return nil;

   
    
    
}


#pragma mark —————— UICollectionViewDataSource UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return  (collectionView == self.rank_collectView) ? 1 :  self.Country_Hotcities.count + 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (collectionView == self.rank_collectView) {
        
        return self.RankList.count;
        
    }else{
    
        if (section == 0) return  2;
        CatigaryCountry *country = self.Country_Hotcities[section - 1];
        return country.HotCities.count;
    }
    
    
}

static NSString *cityCellReuse = @"cityCell";
static NSString *rankCellReuse = @"rankStyleCell";
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView == self.rank_collectView) {
        
        CatigoryRankStyleCell *rank_cell = [collectionView dequeueReusableCellWithReuseIdentifier:rankCellReuse forIndexPath:indexPath];

        rank_cell.rank = self.RankList[indexPath.row];
        
        return rank_cell;
        
    }else{
    
    
        if (indexPath.section == 0) {
            
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
            
            UIImageView *bgView = [[UIImageView alloc] init];
            bgView.frame = cell.bounds;
            bgView.contentMode = UIViewContentModeScaleAspectFill;
            NSString *item = (indexPath.row == 0) ? GDLocalizedString(@"Category-UK") : GDLocalizedString(@"Category-AU");
            bgView.image = [UIImage imageNamed:item];
            
            [cell.contentView addSubview:bgView];
            cell.contentView.layer.cornerRadius = CORNER_RADIUS;
            cell.contentView.layer.masksToBounds = YES;
            
            return cell;
            
        }else{
            
            CatigaryCityCollectionCell *city_cell = [collectionView dequeueReusableCellWithReuseIdentifier:cityCellReuse forIndexPath:indexPath];
            CatigaryCountry *country = self.Country_Hotcities[indexPath.section - 1];
            city_cell.city = country.HotCities[indexPath.row];
            
            return city_cell;
            
        }
        
      }
    
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
     return  collectionView == self.City_CollectView  ? CGSizeMake(XSCREEN_WIDTH, 50)  : CGSizeMake(0, 0);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    
    if (collectionView == self.rank_collectView) {
        
        CatigoryRank *rank = self.RankList[indexPath.row];
        
        [rank.countryName isEqualToString:GDLocalizedString(@"CategoryVC-AU")] ?   [self CaseAU:rank] : [self CaseUK:rank] ;
        
        return;
    }
    
    
    if (indexPath.section == 0) {
        
        [self CaseStateWithIndexPath:indexPath];
        
    }else{
        
        [self CaseHotCityWithIndexPath:indexPath];
    }
    
}


#pragma mark : UICollectionViewLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (collectionView == self.rank_collectView) {
        

        return CGSizeMake(XSCREEN_WIDTH -  2 * ITEM_MARGIN, Country_Width -20);
        
    }
    
    if (indexPath.section == 0) {
        
        return CGSizeMake(XSCREEN_WIDTH -  2 * ITEM_MARGIN, Country_Width -20);
    }
    
    return CGSizeMake(FLOWLAYOUT_CityW, FLOWLAYOUT_CityW);
    
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return ITEM_MARGIN;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, ITEM_MARGIN, 0, ITEM_MARGIN);
}

/*
 - (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
 
 return ITEM_MARGIN;
 }
   
 - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
 - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;
 */


#pragma mark ———————— UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (![scrollView isKindOfClass:[UICollectionView class]]) {
        
        
        if ([scrollView isKindOfClass:[UITableView class]] || !scrollView.isDragging)  return;
        
        if (self.bgView.isDragging) {
            
            //监听滚动，实现顶部工具条按钮切换
            CGPoint offset = scrollView.contentOffset;
            
            CGFloat offsetX = offset.x;
            
            CGFloat width = scrollView.frame.size.width;
            
            NSInteger pageNum =  (offsetX + .5f *  width) / width;
            
            [self.topToolView SelectButtonIndex:pageNum];
            // 限制y轴不动
            self.bgView.contentSize =  CGSizeMake(3 * XSCREEN_WIDTH, 0);
        }
    }
}


#pragma mark ——— XTopToolViewDelegate
- (void)XTopToolView:(XBTopToolView *)topToolView andButtonItem:(UIButton *)sender{
    
    [self.bgView setContentOffset:CGPointMake(XSCREEN_WIDTH * sender.tag, 0) animated:YES];
}


- (void)leftViewMessage:(NSNotification *)noti{
    
    NSString *object = (NSString *)noti.object;
    
    if (1 == object.integerValue) {
        
        [self leftViewMessage];
    }
}

//导航栏 leftBarButtonItem
- (void)leftViewMessage{
    
    //先从本地获取消息数据 当网络联接时，再次请求最新网络数据
    NSUserDefaults *ud       = [NSUserDefaults standardUserDefaults];
    NSString *message_count  = [ud valueForKey:@"message_count"];
    NSString *order_count    = [ud valueForKey:@"order_count"];
    self.leftView.countStr =[NSString stringWithFormat:@"%ld",(long)[message_count integerValue]+[order_count integerValue]];
    
    if(!LOGIN) self.leftView.countStr = @"0";
    
    if (LOGIN && [self checkNetWorkReaching]) {
        
        XWeakSelf
        
        [self startAPIRequestWithSelector:kAPISelectorCheckNews parameters:nil showHUD:NO success:^(NSInteger statusCode, id response) {
            
            NSInteger message_count  = [response[@"message_count"] integerValue];
            NSInteger order_count    = [response[@"order_count"] integerValue];
            [ud setValue:[NSString stringWithFormat:@"%ld",(long)message_count] forKey:@"message_count"];
            [ud setValue:[NSString stringWithFormat:@"%ld",(long)order_count] forKey:@"order_count"];
            [ud synchronize];
            
            weakSelf.leftView.countStr =[NSString stringWithFormat:@"%ld",(long)[response[@"message_count"] integerValue]+[response[@"order_count"] integerValue]];
        }];
        
    }
    
}

//打开左侧菜单
-(void)showLeftMenu
{
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
-(void)CaseHotCityWithIndexPath:(NSIndexPath *)indexPath
{
    
    CatigaryCountry *country = self.Country_Hotcities[indexPath.section - 1];
    
    CatigaryHotCity *city = country.HotCities[indexPath.row];
    
    XNewSearchViewController *vc = [[XNewSearchViewController alloc] initWithFilter:KEY_CITY
                                                                              value:city.cityName
                                                                            orderBy:RANK_TI];
    vc.Corecity = city.cityName;
    
    [self.navigationController pushViewController:vc animated:YES];
}

//英国、澳大利亚地区列表
-(void)CaseStateWithIndexPath:(NSIndexPath *)indexPath
{
    CountryStateViewController *STATE = [[CountryStateViewController alloc] init];
    
    STATE.countryName = indexPath.row == 0 ? GDLocalizedString(@"CategoryVC-UK"):GDLocalizedString(@"CategoryVC-AU");
    
    [self.navigationController pushViewController:STATE animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
