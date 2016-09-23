//
//  HomeViewContViewController.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/18.
//  Copyright © 2016年 UVIC. All rights reserved.

#define ADKEY @"Advertiseseeee"
#define HEADER_HEIGHT XScreenHeight * 0.7



#import "HomeHeaderView.h"
#import "HomeViewContViewController.h"
#import "HomeSectionHeaderView.h"
#import "HomeFirstTableViewCell.h"
#import "HomeSecondTableViewCell.h"
#import "HomeThirdTableViewCell.h"
#import "UniCollectionViewCell.h"
#import "YYSingleNewsBO.h"
#import "YYAutoLoopView.h"
#import "WYLXViewController.h"
#import "MessageDetailViewController.h"
#import "InteProfileViewController.h"
#import "IntelligentResultViewController.h"
#import "HotUniversityFrame.h"
#import "HomeSearchView.h"
#import "SearchViewController.h"
#import "XiaobaiViewController.h"
#import <AdSupport/AdSupport.h>
#import "NSString+MD5.h"
#import "XNewSearchViewController.h"
#import "ServiceMallViewController.h"
#import "XUToolbar.h"
#import "UniDetailGroup.h"





@interface HomeViewContViewController ()<UITableViewDataSource,UITableViewDelegate,HomeSecondTableViewCellDelegate,HomeThirdTableViewCellDelegate,UIWebViewDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)UITableView *TableView;
//搜索工具条
@property(nonatomic,strong)HomeSearchView *searchView;
//轮播图
@property(nonatomic,strong)YYAutoLoopView *autoLoopView;
//广告数组
@property(nonatomic,strong)NSMutableArray *advertise_Arr;
//智能匹配数量
@property(nonatomic,assign)NSInteger recommendationsCount;
//下拉
@property(nonatomic,strong)MJRefreshGifHeader *fresh_Header;
//自定义ToolBar
@property(nonatomic,strong)XUToolbar *myToolbar;
//自定义导航栏LeftBarButtonItem
@property(nonatomic,strong)LeftBarButtonItemView *leftView;
//分组数据
@property(nonatomic,strong)NSMutableArray *groups;



@end

@implementation HomeViewContViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
 
    [self presentViewWillAppear];
    
}

//页面出现时预加载功能
-(void)presentViewWillAppear{
    
    [MobClick beginLogPageView:@"page新版首页"];
    
    self.tabBarController.tabBar.hidden = NO;
    
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
    
    //    [self UserLanguage];  //ENGLISH  设置环境
    
    [self checkZhiNengPiPei];
    
    [self userInformation];
    
    [self leftViewMessage];
    
    [self userDidClickItem];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page新版首页"];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
     
    [self makeDataSourceRefresh:NO];
    
    [self makeUI];
    
    [self makeOther];
  
}


-(void)makeOther{

    
    [self checkAPPVersion];

    [self baseDataSourse]; //加载基础数据

    [self getAppReport];
    
    //--判断用户是否完成任务--
    if(![[NSUserDefaults standardUserDefaults] boolForKey:ADKEY]){
        
        [self advanceSupportWithDuration:180];
        
    }

}

-(void)makeDataSourceRefresh:(BOOL)refresh{

    [self hotCityData:refresh];
    
    [self hotUniversity:refresh];
    
    [self hotArticle:refresh];
    
    [self hotPromotions:refresh];
}


-(NSMutableArray *)groups{

    if (!_groups) {
        
        _groups =[NSMutableArray array];
        
        UniDetailGroup *groupone = [UniDetailGroup groupWithTitle:@"留学目的地" contentes:nil andFooter:NO];
        [_groups addObject:groupone];
        
        UniDetailGroup *grouptwo = [UniDetailGroup groupWithTitle:@"热门阅读" contentes:nil andFooter:NO];
        [_groups addObject:grouptwo];
        
        UniDetailGroup *groupthree = [UniDetailGroup groupWithTitle:@"热门院校" contentes:nil andFooter:NO];
        [_groups addObject:groupthree];
    }
    return _groups;
}

-(NSMutableArray *)advertise_Arr
{
    if (!_advertise_Arr) {
        
        _advertise_Arr =[NSMutableArray array];
    }
    return _advertise_Arr;
}


//热门院校
-(void)hotUniversity:(BOOL)refresh
{
    
    [self startAPIRequestUsingCacheWithSelector:kAPISelectorHotUniversity parameters:nil success:^(NSInteger statusCode, id response) {
        
        
        [self dataSourseWithFresh:refresh GroupIndex:2];
        
        [self hotUniverstiyWithResponse:(NSArray *)response];
        
        [self.TableView reloadData];
        
    }];

}


//留学目的地数据
-(void)hotCityData:(BOOL)refresh
{
    [self startAPIRequestUsingCacheWithSelector:kAPISelectorHomepage parameters:nil success:^(NSInteger statusCode, NSArray *response) {
        
        [self dataSourseWithFresh:refresh GroupIndex:0];
        
        [self hotCityWithResponse:response];
        
        [self.TableView reloadData];
        
    }];
}

//热门文章
-(void)hotArticle:(BOOL)refresh
{
    [self startAPIRequestUsingCacheWithSelector:kAPISelectorArticleRecommendation parameters:nil success:^(NSInteger statusCode, id response) {
        
        [self dataSourseWithFresh:refresh GroupIndex:1];
        
        [self hotArticleWithResponse:(NSArray *)response];
        
        [self.TableView reloadData];
    }];
    
}


- (void)dataSourseWithFresh:(BOOL)refresh GroupIndex:(NSInteger)index{
    
    if (refresh) {
        UniDetailGroup *groupthree = self.groups[index];
        groupthree.items = nil;
    }
    
}

//留学目的地UI设置
-(void)hotCityWithResponse:(NSArray *)response
{
    NSArray *temp_city =  [response copy];
    NSRange cityRange = NSMakeRange(1, 3);
    NSArray *temp_cities = temp_city.count > 4 ? [[temp_city subarrayWithRange:cityRange] copy] : temp_city;
    UniDetailGroup *groupone = self.groups[0];
    groupone.cellHeight = XScreenWidth * 0.4;
    groupone.items = temp_cities;
}

//热门文章UI设置
-(void)hotArticleWithResponse:(NSArray *)response
{
    
    NSArray  *temp_articles  = (NSArray *)response;
    UniDetailGroup *grouptwo = self.groups[1];
    grouptwo.cellHeight =  ceilf(temp_articles.count * 0.5) * XScreenWidth * 0.4;
    grouptwo.items = @[temp_articles];
    
}
//热门院校UI设置
-(void)hotUniverstiyWithResponse:(NSArray *)response
{
    NSArray *temp_Unies = response;
    
    NSMutableArray *temp_universities = [NSMutableArray array];
    
    for (NSDictionary *uni_Info in temp_Unies) {
         HotUniversityFrame *uniFrame = [HotUniversityFrame frameWithUniversity:uni_Info];
        [temp_universities addObject:uniFrame];
    }
    
    
    UniDetailGroup *groupthree = self.groups[2];
    
    if (temp_universities.count>0) {
        HotUniversityFrame *uniFrame = temp_universities[0];
        groupthree.cellHeight = uniFrame.cellHeight;
    }
    
    groupthree.items =@[temp_universities];
    
}

//轮播图数据
-(void)hotPromotions:(BOOL)refresh
{
  
    XJHUtilDefineWeakSelfRef
    
    [self startAPIRequestWithSelector:@"GET api/app/promotions"  parameters:nil expectedStatusCodes:nil showHUD:NO showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        if (refresh) {
            
            [self.advertise_Arr removeAllObjects];
            
        }
        
        NSMutableArray *items = [NSMutableArray array];
        
        weakSelf.advertise_Arr = [(NSArray *)response mutableCopy];
        
        for (NSInteger i = 0; i < weakSelf.advertise_Arr.count; i++) {
            
            NSDictionary *obj = weakSelf.advertise_Arr[i];
            YYSingleNewsBO *new = [[YYSingleNewsBO alloc] init];
            new.message = obj;
            new.newsTitle = @"";
            new.index = i;
            [items addObject:new];
        }
        
         weakSelf.autoLoopView.banners = [items mutableCopy];
       
        self.autoLoopView.userInteractionEnabled = self.advertise_Arr.count > 0 ? YES : NO;
        
        [self.TableView.mj_header endRefreshing];
        
        [self.TableView reloadData];
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        self.autoLoopView.userInteractionEnabled = NO;
        
        [self.TableView.mj_header endRefreshing];
        
    }];
    

}

-(XUToolbar *)myToolbar
{
    if (!_myToolbar) {
        
        _myToolbar =[XUToolbar toolBar];
        [self.view addSubview:_myToolbar];
    }
    return _myToolbar;
}


-(void)makeUI
{
    
    [self makeHomeTableView];
    
    [self makeLeftBarButtonItemView];
    
}


-(void)makeLeftBarButtonItemView{

    XJHUtilDefineWeakSelfRef
    self.leftView =[LeftBarButtonItemView leftViewWithBlock:^{
        [weakSelf openLeftMenu];
    }];
    
    UIBarButtonItem *leftItem =[[UIBarButtonItem alloc]  initWithCustomView:self.leftView];
    UIBarButtonItem *flexItem =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.myToolbar.items= @[leftItem,flexItem];
}

-(void)makeHomeTableView
{

    self.TableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0, XScreenWidth, XScreenHeight) style:UITableViewStyleGrouped];
    self.TableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    self.TableView.delegate = self;
    self.TableView.dataSource = self;
    [self.view addSubview:self.TableView];
    self.TableView.sectionFooterHeight = HEIGHT_ZERO;
    self.TableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.TableView.backgroundColor = XCOLOR_BG;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self makeTableHeader];

    [self makeRefreshView];
    
     [self makeSearchView];
   
}

-(void)makeTableHeader
{
    HomeHeaderView *TableHeaderView =[HomeHeaderView headerViewWithFrame:CGRectMake(0, 0, XScreenWidth, HEADER_HEIGHT) withactionBlock:^(NSInteger itemTag) {
        [self HomeHeaderViewWithItemtap:itemTag];
    }];
    self.TableView.tableHeaderView  = TableHeaderView;
    [self makeAutoLoopViewAtView: TableHeaderView];
 

}

//页面刷新
-(void)refresh
{
    [self makeDataSourceRefresh:YES];
    
    [self leftViewMessage];
}

-(void)makeRefreshView
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
//    header.lastUpdatedTimeLabel.hidden = YES;
//    header.stateLabel.hidden = YES;
    self.fresh_Header = header;
    self.fresh_Header.gifView.transform = CGAffineTransformMakeScale(0.2, 0.2);

    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (int i = 0; i<=10; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Pre-comp 1_000%d", i]];
        [refreshingImages addObject:image];
    }
    
    NSMutableArray *nomalImages = [NSMutableArray array];
    [nomalImages addObject:[UIImage imageNamed:@"Pre-comp 1_0000"]];
    // 设置普通状态的动画图片
    [header setImages:nomalImages forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [header setImages:refreshingImages duration:0.1  forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [header setImages:refreshingImages duration:0.1 forState:MJRefreshStateRefreshing];
    // 设置header
    self.TableView.mj_header = header;
}


//搜索功能
-(void)makeSearchView
{
    CGFloat searchX = 20;
    CGFloat searchH = 44;
    CGFloat searchW = XScreenWidth - searchX * 2;
    CGFloat searchY = HEADER_HEIGHT * 0.6 + 20 - searchH * 0.5;
    HomeSearchView *searchView = [HomeSearchView ViewWithFrame:CGRectMake(searchX,searchY,searchW, searchH)];
    self.searchView = searchView;
    XJHUtilDefineWeakSelfRef
    searchView.actionBlock = ^{
        
        [weakSelf CaseSearchPage];
    };
    [self.view addSubview:searchView];
    
}


/**
 *  创建轮播图头部
 */
- (void)makeAutoLoopViewAtView:(UIView *)bgView{
    
    XJHUtilDefineWeakSelfRef
    
    CGFloat AY =  XScreenHeight * 0.7 * 0.6 + 20;
    
    CGFloat AH =  XScreenHeight * 0.7 - AY;
    
    self.autoLoopView = [[YYAutoLoopView alloc] initWithFrame:CGRectMake(0,AY, XScreenWidth,AH)];
    
    [bgView addSubview:self.autoLoopView];
    
    self.autoLoopView.clickAutoLoopCallBackBlock = ^(YYSingleNewsBO *StatusBarBannerNews){
        
        [weakSelf CaseLandingPageWithBan:StatusBarBannerNews.message_url];
        
    };
    
}


#pragma mark ———————— UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    self.myToolbar.top = 20 - scrollView.contentOffset.y;
    
    [self.searchView searchViewWithScrollViewDidScrollContentOffsetY:scrollView.contentOffset.y];
    
    if (scrollView.contentOffset.y >= - 100 && scrollView.contentOffset.y <= 0) {
        CGFloat Gscale =0.2 + 0.5 * ABS(scrollView.contentOffset.y)/ 100.0;
        self.fresh_Header.gifView.transform = CGAffineTransformMakeScale(Gscale, Gscale);
    }
    
}

#pragma mark  ———————————— UITableViewDelegate  UITableViewData
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section; {
  
    UniDetailGroup *group = self.groups[section];
    HomeSectionHeaderView *SectionView =[HomeSectionHeaderView sectionHeaderViewWithTitle:group.HeaderTitle];
    if (1 == section) {
        [SectionView moreButtonHidenNo];
         SectionView.actionBlock = ^{
             
              [self.tabBarController setSelectedIndex:2];
        };
    }
     return  SectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    UniDetailGroup *group = self.groups[section];
    
    return group.HaveHeader ? 40 : HEIGHT_ZERO;
 }

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
  
    UniDetailGroup *group = self.groups[indexPath.section];
    
    return   group.items.count > 0 ? group.cellHeight : HEIGHT_ZERO;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    UniDetailGroup *group = self.groups[section];

    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UniDetailGroup *group = self.groups[indexPath.section];

       switch (indexPath.section) {
        case 0:
        {
            HomeFirstTableViewCell *cell =[HomeFirstTableViewCell cellInitWithTableView:tableView];
            cell.itemInfo = group.items[indexPath.row];
            
            return cell;
         }
          break;
          case 1:{
            
            HomeSecondTableViewCell *cell =[HomeSecondTableViewCell cellInitWithTableView:tableView];
            cell.items = group.items[indexPath.row];
            cell.delegate = self;
             return cell;
        
        }
             break;
            default:
        {

            HomeThirdTableViewCell *cell =[HomeThirdTableViewCell cellInitWithTableView:tableView];
            cell.uniFrames = group.items[indexPath.row];
            cell.delegate = self;
            return cell;

         }
            break;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (0 == indexPath.section) {
        
        [self CaseSearchResultWithindexPath:indexPath];

    }
    
}
#pragma mark ——— HomeHeaderViewDelegate
-(void)HomeHeaderViewWithItemtap:(NSInteger )tag
{
   
//    NSArray *counries = [[NSUserDefaults standardUserDefaults] valueForKey:@"Country_CN"];
//    if (counries.count == 0) {
//         //用于防止用户第一次加载备用数据失败
//         [self getSelectionSourse];
//        
//         return;
//    }
    
     switch (tag) {
         case 0:
             [self CaseWoyaoliuXue];
            break;
        case 1:
             [self CaseLiuXueXiaoBai];
            break;
         case 2:
             [self CasePipeiWithItemType:HomePageClickItemTypePipei];
            break;
         case 3:
             [self CaseLandingPageWithBan:[NSString stringWithFormat:@"%@mbti/test",DOMAINURL]];
             break;
         case 4:
             [self CaseLandingPageWithBan:[NSString stringWithFormat:@"%@superMentor.html",DOMAINURL]];
              break;
         case 5:
             [self CaseServerMall];
             break;
        default:
            break;
    }
}
#pragma mark ——— HomeSecondTableViewCellDelegate
-(void)HomeSecondTableViewCell:(HomeSecondTableViewCell *)cell andDictionary:(NSDictionary *)response
{
    [MobClick event:@"home_newsItem"];
    MessageDetailViewController *detail =[[MessageDetailViewController alloc] init];
    detail.NO_ID = response[@"_id"];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark —————— HomeThirdTableViewCellDelegate
-(void)HomeThirdTableViewCell:(HomeThirdTableViewCell *)cell andDictionary:(NSDictionary *)response
{
     [MobClick event:@"home_universityItem"];
     [self.navigationController pushUniversityViewControllerWithID:response[@"_id"] animated:YES];
}

#pragma mark  ————————————  UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
     if (buttonIndex){
       
         [self CaseAppstore];
         
    }
    
}


//显示菜单列表
-(void)openLeftMenu{
    
    [self.sideMenuViewController presentLeftMenuViewController];
 
}

//检查版本更新
-(void)checkAPPVersion
{
    
    NSString *urlStr = @"https://itunes.apple.com/lookup?id=1016290891";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:req delegate:self];
}


-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    NSError *error;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    NSDictionary *appInfo = (NSDictionary *)jsonObject;
    NSArray *infoContent = [appInfo objectForKey:@"results"];
    NSString *storeVersion = [[infoContent objectAtIndex:0] objectForKey:@"version"];
    NSString *storeVersionStr = [storeVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSString *currentVersionStr = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    if (currentVersionStr.integerValue < storeVersionStr.integerValue) {
//        @"忽略此版本"
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"有可用的新版本！" delegate:self cancelButtonTitle:@"忽略此版本" otherButtonTitles:@"访问Appstore",nil];
        [alert show];
    }
    
}


//ENGLISH  设置环境
//--用户语言环境通知服务器----
//-(void)UserLanguage
//{
//    if ([[AppDelegate sharedDelegate] isLogin]) {
//        
//        NSString *lang =USER_EN ? @"en":@"zh-cn";
//        [self startAPIRequestWithSelector:kAPISelectorUserLanguage parameters:[NSDictionary dictionaryWithObject:lang forKey:@"language"] success:^(NSInteger statusCode, id response) {
//            
//        }];
//    }
//}

//---推广接口，用户是否在使用myoffer---
-(void)advanceSupportWithDuration:(int)durationTime
{
    
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    NSString *secret = @"s9xyfjwilruwefnxdkjvhxck3sxceikrbzbde";
    
    NSString *signature = [NSString stringWithFormat:@"idfa=%@%@",adId,secret];
    signature = [signature KD_MD5];
    
    NSString  *path = [NSString stringWithFormat:@"GET /api/youqian/finish?idfa=%@&signature=%@",adId,signature];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(durationTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        [self startAPIRequestWithSelector:path  parameters:nil expectedStatusCodes:nil showHUD:NO showErrorAlert:NO errorAlertDismissAction:^{
            
        } additionalSuccessAction:^(NSInteger statusCode, id response) {
            
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ADKEY];
            
            
        } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
            
            
            [self advanceSupportWithDuration:20];
        }];
        
        
    });
    
}
//--应用监听，用户登录立即发送提醒给服务器--
-(void)getAppReport
{
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    NSString  *path = [NSString stringWithFormat:@"GET /api/app/report?_id=%@",adId];
    
    [self startAPIRequestWithSelector:path  parameters:nil expectedStatusCodes:nil showHUD:NO showErrorAlert:NO errorAlertDismissAction:^{
        
    } additionalSuccessAction:^(NSInteger statusCode, id response) {
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
    }];
    
}

 
//请求用户信息      //判断用户是否登录且登录用户手机号码是否为空，如果为空用户退出登录；
-(void)userInformation
{
    if (!LOGIN) return;
    
    [self startAPIRequestWithSelector:kAPISelectorAccountInfo parameters:nil expectedStatusCodes:nil showHUD:NO showErrorAlert:NO errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        NSString *phone = response[@"accountInfo"][@"phonenumber"];
        
        if (0 == phone.length) {
            
            [self backAndLogout];
        }

    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        
    }];
}

//判断是否有智能匹配数据或收藏学校
-(void)checkZhiNengPiPei{
    
    if (LOGIN) {
        
        [self startAPIRequestUsingCacheWithSelector:kAPISelectorRequestCenter parameters:nil success:^(NSInteger statusCode, NSDictionary *response) {
            self.recommendationsCount = [response[@"recommendationsCount"] integerValue];
        }];
    }
}


//退出登录
-(void)backAndLogout{
    
    if(LOGIN){
        
        [[AppDelegate sharedDelegate] logout];
        
        [MobClick profileSignOff];/*友盟第三方统计功能统计退出*/
        
        [APService setAlias:@"" callbackSelector:nil object:nil];  //设置Jpush用户所用别名为空
        
        [self startAPIRequestWithSelector:kAPISelectorLogout parameters:nil showHUD:YES success:^(NSInteger statusCode, id response) {
            
        }];
    }
    
}

//导航栏leftBarbuttonItem
-(void)leftViewMessage{
    
    if (LOGIN && [self checkNetWorkReaching]) {
        
        XJHUtilDefineWeakSelfRef
       [self startAPIRequestWithSelector:kAPISelectorCheckNews parameters:nil showHUD:NO success:^(NSInteger statusCode, id response) {
     
            NSUserDefaults *ud       = [NSUserDefaults standardUserDefaults];
            NSInteger message_count  = [response[@"message_count"] integerValue];
            NSInteger order_count    = [response[@"order_count"] integerValue];
            [ud setValue:[NSString stringWithFormat:@"%ld",(long)message_count] forKey:@"message_count"];
            [ud setValue:[NSString stringWithFormat:@"%ld",(long)order_count] forKey:@"order_count"];
            [ud synchronize];

             weakSelf.leftView.countStr =[NSString stringWithFormat:@"%ld",(long)[response[@"message_count"] integerValue]+[response[@"order_count"] integerValue]];
        }];
        
    }
    
    if(!LOGIN){
    
        self.leftView.countStr = @"0";

    }
    
}


//跳转我要留学
-(void)CaseWoyaoliuXue
{
    [MobClick event:@"WoYaoLiuXue"];
    
    [self.navigationController pushViewController:[[WYLXViewController alloc] init] animated:YES];
}


//跳转留学小白
-(void)CaseLiuXueXiaoBai
{
    [MobClick event:@"XiaoBai"];
    [self.navigationController pushViewController:[[XiaobaiViewController alloc] init] animated:YES];
}

//跳转智能匹配
-(void)CasePipeiWithItemType:(HomePageClickItemType)type
{
    self.clickType = LOGIN ? HomePageClickItemTypeNoClick : type;
    
    RequireLogin
    
    switch (type) {
        case HomePageClickItemTypePipei:
        {
            [MobClick event:@"PiPei"];
            UIViewController *vc =  self.recommendationsCount > 0 ?  [[IntelligentResultViewController alloc] init] : [[InteProfileViewController alloc] init];
            [self.navigationController pushViewController:vc  animated:YES];
        }
            break;
        case HomePageClickItemTypetest:
            [self CaseLandingPageWithBan:[NSString stringWithFormat:@"%@mbti/test",DOMAINURL]];
            break;
        default:
            break;
    }
}



//跳转服务包
-(void)CaseServerMall{

    [MobClick event:@"home_mall"];
    [self.navigationController pushViewController:[[ServiceMallViewController alloc] init] animated:YES];
}

//跳转搜索功能
-(void)CaseSearchPage
{
    
    [MobClick event:@"home_shearchItemClick"];
    [self presentViewController:[[XWGJNavigationController alloc] initWithRootViewController:[[SearchViewController alloc] init]] animated:YES completion:nil];
}




//跳转LandingPage
-(void)CaseLandingPageWithBan:(NSString *)path
{
    [MobClick event:@"home_advertisementClick"];
    
    if([path containsString:@"mbti/test"])
    {

        self.clickType = LOGIN ? HomePageClickItemTypeNoClick : HomePageClickItemTypetest;
        
        RequireLogin
    }
    
    WebViewController *detail =[[WebViewController alloc] init];
    detail.path = path;
    [self.navigationController pushViewController:detail animated:YES];

}

//跳转LandingPage
-(void)CaseSearchResultWithindexPath:(NSIndexPath *)indexPath{

    NSString *item;
    switch (indexPath.row) {
        case 0:
            item = @"home_LondonItemClick";
            break;
        case 1:
            item = @"home_SydneyItemClick";
            break;
        default:
            item = @"home_ManchesterItemClick";
            break;
    }
    [MobClick event:item];
    
    UniDetailGroup *group = self.groups[indexPath.section];
    NSDictionary *info = group.items[indexPath.row];
    NSString *searchValue = info[@"search"];
    XNewSearchViewController *vc = [[XNewSearchViewController alloc] initWithFilter:KEY_CITY
                                                                              value:searchValue
                                                                            orderBy:RANKTI];
    vc.Corecity = searchValue;
    [self.navigationController pushViewController:vc animated:YES];
}


//判断用户在未登录前在申请中心页面选择服务，当用户登录时直接跳转已选择服务
-(void)userDidClickItem
{
    if (LOGIN) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self CasePipeiWithItemType:self.clickType];

        });
    }
}

//跳转到appstore下载页面
-(void)CaseAppstore
{
    NSString *appid = @"1016290891";
    
    NSString *str = [NSString stringWithFormat:
                     
                     @"itms-apps://itunes.apple.com/cn/app/id%@?mt=8", appid];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
