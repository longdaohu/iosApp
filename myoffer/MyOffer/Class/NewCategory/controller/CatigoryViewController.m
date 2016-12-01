//
//  XWGJCatigoryViewController.m
//  myOffer
//
//  Created by xuewuguojie on 16/2/29.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "CatigoryViewController.h"
#import "CatigoryRankCell.h"
#import "CatigorySubjectCell.h"
#import "CatigaryCityCollectionCell.h"
#import "XWGJCityCollectionReusableView.h"
#import "CatigaryCityCollectionHeaderView.h"
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

#define INTERSET_TOP  70.0

@interface CatigoryViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,XTopToolViewDelegate>
//背景scroller
@property(nonatomic,strong)CatigaryScrollView *baseScrollView;
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
@property(nonatomic,strong)CatigaryCityCollectionHeaderView *cityHeaderView;
//工具条
@property(nonatomic,strong)TopNavView *topView;
@property(nonatomic,strong)XBTopToolView   *topToolView;
//热门城市数组
@property(nonatomic,strong)NSArray  *countryes;
//是否有新消息图标
@property(nonatomic,strong)LeftBarButtonItemView *leftView;

@end

@implementation CatigoryViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
    
    [self getHotCitySource];
    
}


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



//获取热门城市数组
-(void)getHotCitySource
{
    
    XWeakSelf
    
    [self startAPIRequestUsingCacheWithSelector:kAPISelectorCatigoryHotCities parameters:nil success:^(NSInteger statusCode, id response) {
        
        NSMutableArray *countryM  =[NSMutableArray array];
 
        for (NSDictionary *countryDic in response[@"hot"]) {
            
            CatigaryCountry *country =[CatigaryCountry ContryItemInitWithCountryDictionary:countryDic];
  
            [countryM addObject:country];
        }
        
        weakSelf.countryes = [countryM copy];
        
        [weakSelf.City_CollectView reloadData];
        
    }];
}


-(NSArray *)RankList
{
    if (!_RankList) {
        
        CatigoryRank *rank_en = [CatigoryRank rankItemInitWithIconName:@"Rank_ENG" TitleName:GDLocalizedString(@"Categoryrank-en") RankKey:RANKTI];
        CatigoryRank *rank_au = [CatigoryRank rankItemInitWithIconName:@"Rank_AU" TitleName:GDLocalizedString(@"Categoryrank-au")  RankKey:RANKTI];
        CatigoryRank *rank_qs = [CatigoryRank rankItemInitWithIconName:@"Rank_QS" TitleName:GDLocalizedString(@"Categoryrank-qs")  RankKey:RANKQS];
        _RankList = @[rank_en,rank_au,rank_qs];
        
    }
    return _RankList;
}


//专业数据数组
-(NSArray *)SubjectList
{
   
    if (!_SubjectList) {
        
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
            
             _SubjectList =  [subject_temps copy];
            
            
        }else{
        
            
            CatigorySubject *art =[CatigorySubject subjectItemInitWithIconName:@"sub_art"  TitleName:GDLocalizedString(@"CategorySub-art")];
            CatigorySubject *finance =[CatigorySubject subjectItemInitWithIconName:@"sub_finance"  TitleName:GDLocalizedString(@"CategorySub-finance")];
            CatigorySubject *built =[CatigorySubject subjectItemInitWithIconName:@"sub_built"  TitleName:@"建筑与规划"];
            CatigorySubject *humanity =[CatigorySubject subjectItemInitWithIconName:@"sub_humanit"  TitleName:GDLocalizedString(@"CategorySub-humanity")];
            CatigorySubject *engineer =[CatigorySubject subjectItemInitWithIconName:@"sub_engineer"  TitleName:GDLocalizedString(@"CategorySub-engineer")];
            CatigorySubject *medicine =[CatigorySubject subjectItemInitWithIconName:@"sub_medicine"  TitleName:GDLocalizedString(@"CategorySub-medicine")];
            CatigorySubject *business =[CatigorySubject subjectItemInitWithIconName:@"sub_business"  TitleName:GDLocalizedString(@"CategorySub-business")];
            CatigorySubject *farm =[CatigorySubject subjectItemInitWithIconName:@"sub_farm"  TitleName:GDLocalizedString(@"CategorySub-farm")];
            CatigorySubject *science =[CatigorySubject subjectItemInitWithIconName:@"sub_sciencee"  TitleName:GDLocalizedString(@"CategorySub-science")];
            _SubjectList = @[finance,business,engineer,humanity,science,built,art,medicine,farm];

        }
        
        
    }
    
    return _SubjectList;
}


//导航工具条
-(void)makeTopView
{
    self.topView= [[TopNavView alloc] initWithFrame:CGRectMake(0,  -XNav_Height, XScreenWidth, XNav_Height + 60)];
    [self.view addSubview:self.topView];
    [self makeTopToolView];
}

//滚动工具条
-(void)makeTopToolView
{
    self.topToolView = [[XBTopToolView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame) - TOP_HIGHT - ITEM_MARGIN,XScreenWidth, TOP_HIGHT)];
    self.topToolView.itemNames =   @[GDLocalizedString(@"CategoryNew-region"),GDLocalizedString(@"CategoryNew-major"),GDLocalizedString(@"CategoryNew-rank")];
    self.topToolView.delegate  = self;
    [self.view  addSubview:self.topToolView];
}

-(void)makeBaseScorller
{
    CGFloat baseX = 0;
    CGFloat baseY = 0;
    CGFloat baseW = XScreenWidth;
    CGFloat baseH = XScreenHeight - XNav_Height - 50;
    self.baseScrollView = [CatigaryScrollView viewWithFrame:CGRectMake(baseX, baseY, baseW,baseH)];
    self.baseScrollView.delegate = self;
    [self.view addSubview:self.baseScrollView];
    
    [self makeCityCollectViewWithFrame:CGRectMake(baseX, baseY, baseW,baseH)];
    
    [self makeSubjectCollectViewWithFrame:CGRectMake(baseW * 1, baseY, baseW,baseH)];
    
    [self makeRankTableViewWithFrame:CGRectMake(baseW * 2, baseY, baseW,baseH)];
    
}

-(void)makeCityCollectViewWithFrame:(CGRect)frame
{
   
    CGFloat topHigh = 2 * (Country_Width - 20) + 45 + INTERSET_TOP;
    
    self.City_CollectView = [self makeCollectionViewWithFlowayoutWidth:FLOWLAYOUT_CityW andFrame:frame andcontentInset:UIEdgeInsetsMake(topHigh, 0, 40, 0)];
    
    
    UINib *city_xib = [UINib nibWithNibName:@"CatigaryCityCollectionCell" bundle:nil];
    [self.City_CollectView registerNib:city_xib forCellWithReuseIdentifier:cityIdentify];
    
    
    UINib *citySection_xib = [UINib nibWithNibName:@"XWGJCityCollectionReusableView" bundle:nil];
    [self.City_CollectView registerNib:citySection_xib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"citySectionView"];
    
    self.cityHeaderView = [[CatigaryCityCollectionHeaderView alloc] initWithFrame:CGRectMake(0, -topHigh, XScreenWidth, topHigh)];
    
    XWeakSelf
    
    self.cityHeaderView.actionBlock = ^(UIButton *sender){
        
        [weakSelf CaseStateWithSender:sender];
    };
    
    [self.City_CollectView addSubview:self.cityHeaderView];
    
}

-(void)makeSubjectCollectViewWithFrame:(CGRect)frame
{
    self.Sub_CollectView = [self makeCollectionViewWithFlowayoutWidth:FLOWLAYOUT_SubW andFrame:frame andcontentInset:UIEdgeInsetsMake(INTERSET_TOP, 0, 0, 0)];
    UINib *sub_xib = [UINib nibWithNibName:@"CatigorySubjectCell" bundle:nil];
    [self.Sub_CollectView registerNib:sub_xib forCellWithReuseIdentifier:subjectIdentify];
}


-(void)makeRankTableViewWithFrame:(CGRect)frame
{
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.contentInset = UIEdgeInsetsMake(INTERSET_TOP, 0, 0, 0);
    self.tableView.backgroundColor = XCOLOR_BG;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.baseScrollView  addSubview:self.tableView];
    
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
    
    [self.baseScrollView addSubview:collectionView];
    
    return collectionView;
}




-(void)makeUI
{

    [self makeOtherUI];
    
    [self makeBaseScorller];
    
    [self makeTopView];
    

}


-(void)makeOtherUI
{
    
    XWeakSelf
    self.leftView =[LeftBarButtonItemView leftViewWithBlock:^{
        
        [weakSelf showLeftMenu];
        
    }];
    
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]  initWithCustomView:self.leftView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tabbar_discover"] style:UIBarButtonItemStylePlain target:self action:@selector(searchButtonPressed:)];
    
}



#pragma mark ——————UICollectionViewDelegateFlowLayout
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{
    if (collectionView == self.City_CollectView && kind == UICollectionElementKindSectionHeader) {
        
        XWGJCityCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"citySectionView" forIndexPath:indexPath];
        CatigaryCountry *country = self.countryes[indexPath.section];
        headerView.TitleLab.text = country.countryName;
        
        return  headerView;
        
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
        
        CatigaryCountry *country = self.countryes[section];

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
        
        CatigorySubjectCell *subject_cell = [collectionView dequeueReusableCellWithReuseIdentifier:subjectIdentify forIndexPath:indexPath];
      
        subject_cell.subject =self.SubjectList[indexPath.row];
        
        return subject_cell;
        
    }else{
        
        CatigaryCityCollectionCell *city_cell = [collectionView dequeueReusableCellWithReuseIdentifier:cityIdentify forIndexPath:indexPath];
        
        CatigaryCountry *country = self.countryes[indexPath.section];
        
        city_cell.city = country.HotCities[indexPath.row];
        
 
         return city_cell;
    }
    
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return  collectionView == self.City_CollectView  ? CGSizeMake(XScreenWidth, 40)  : CGSizeMake(0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
     collectionView == self.Sub_CollectView  ? [self CaseSubjectWithIndexPath:indexPath]  : [self CaseHotCityWithIndexPath:indexPath];
    
}


#pragma mark —————— UITableViewDelegate  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.RankList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CatigoryRankCell *rank_cell = [CatigoryRankCell cellInitWithTableView:tableView];
    
    rank_cell.rank = self.RankList[indexPath.row];
  
    return rank_cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CatigoryRank *rank = self.RankList[indexPath.row];
    
    [rank.countryName isEqualToString:GDLocalizedString(@"CategoryVC-AU")] ?   [self CaseAUwith:rank] : [self CaseUK:rank] ;
  
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return Country_Width;
}


#pragma mark ————————UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (![scrollView isKindOfClass:[UICollectionView class]]) {
        
        
        if ([scrollView isKindOfClass:[UITableView class]] || !scrollView.isDragging)  return;

        
        if (self.baseScrollView.isDragging) {
            
            //监听滚动，实现顶部工具条按钮切换
            CGPoint offset = scrollView.contentOffset;
            
            CGFloat offsetX = offset.x;
            
            CGFloat width = scrollView.frame.size.width;
            
            NSInteger pageNum =  (offsetX + .5f *  width) / width;
            
            [self.topToolView SelectButtonIndex:pageNum];
            
            // 限制y轴不动
            self.baseScrollView.contentSize =  CGSizeMake(3 * XScreenWidth, 0);
        }

        
   
    }
}


#pragma mark ——— XTopToolViewDelegate
-(void)XTopToolView:(XBTopToolView *)topToolView andButtonItem:(UIButton *)sender
{
    [self.baseScrollView setContentOffset:CGPointMake(XScreenWidth * sender.tag, 0) animated:YES];
}

-(void)leftViewMessage:(NSNotification *)noti{
    
    NSString *object = (NSString *)noti.object;
    
    if (1 == object.integerValue) {
        
        [self leftViewMessage];
    }
}

//导航栏 leftBarButtonItem
-(void)leftViewMessage{
    
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
    

     SearchResultViewController *vc = [[SearchResultViewController alloc] initWithFilter:@"country" value:rank.countryName orderBy:rank.key];
    
     vc.title  = [rank.TitleName containsString:@"+"] ? [rank.TitleName componentsSeparatedByString:@"+"][1] : rank.TitleName;
    
     [self.navigationController pushViewController:vc animated:YES];
}


//澳大利亚排名
-(void)CaseAUwith:(CatigoryRank *)rank
{
    
    AUSearchResultViewController *newVc = [[AUSearchResultViewController alloc] initWithFilter:@"country" value:rank.countryName orderBy:rank.key];
    
    newVc.title  = [rank.TitleName containsString:@"+"] ? [rank.TitleName componentsSeparatedByString:@"+"][1] : rank.TitleName;
    
    [self.navigationController pushViewController:newVc animated:YES];
    
}

//英国、澳大利亚地区列表
-(void)CaseStateWithSender:(UIButton *)sender
{
    CountryStateViewController *STATE = [[CountryStateViewController alloc] init];
    
    STATE.countryName = sender.tag == 0 ? GDLocalizedString(@"CategoryVC-UK"):GDLocalizedString(@"CategoryVC-AU");
    
    [self.navigationController pushViewController:STATE animated:YES];
}

//热门留学城市
-(void)CaseHotCityWithIndexPath:(NSIndexPath *)indexPath
{
    
    CatigaryCountry *country = self.countryes[indexPath.section];
    
    CatigaryHotCity *city = country.HotCities[indexPath.row];
    
    XNewSearchViewController *vc = [[XNewSearchViewController alloc] initWithFilter:KEY_CITY
                                                                              value:city.cityName
                                                                            orderBy:RANKTI];
    vc.Corecity = city.cityName;
    
    [self.navigationController pushViewController:vc animated:YES];
}

//留学专业
-(void)CaseSubjectWithIndexPath:(NSIndexPath *)indexPath{

    CatigorySubject *subject = self.SubjectList[indexPath.row];
    
    XNewSearchViewController *vc = [[XNewSearchViewController alloc] initWithFilter:@"area" value:subject.TitleName orderBy:RANKQS];
    
    vc.CoreArea = subject.TitleName;
    
    [self.navigationController pushViewController:vc animated:YES];
 
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
