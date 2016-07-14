//
//  HomeViewContViewController.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/18.
//  Copyright © 2016年 UVIC. All rights reserved.

#define ADKEY @"Advertiseseeee"

#import "HomeHeaderView.h"
#import "HomeViewContViewController.h"
#import "HomeSectionHeaderView.h"
#import "HomeFirstTableViewCell.h"
#import "HomeSecondTableViewCell.h"
#import "HomeThirdTableViewCell.h"
#import "UniCollectionViewCell.h"
#import "YYSingleNewsBO.h"
#import "YYAutoLoopView.h"
#import "XLiuxueViewController.h"
#import "MessageDetailViewController.h"
#import "InteProfileViewController.h"
#import "IntelligentResultViewController.h"
#import "HotUniversityFrame.h"
#import "HomeSearchView.h"
#import "SearchViewController.h"
#import "AdvertiseViewController.h"
#import "XXiaobaiViewController.h"
#import <AdSupport/AdSupport.h>
#import "NSString+MD5.h"
#import "XNewSearchViewController.h"
#import "ServiceMallViewController.h"

@interface HomeViewContViewController ()<UITableViewDataSource,UITableViewDelegate,HomeHeaderViewDelegate,HomeSecondTableViewCellDelegate,HomeThirdTableViewCellDelegate,UIWebViewDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)UITableView *TableView;
//表头
@property(nonatomic,strong)HomeHeaderView *TableHeaderView;
//热门院校Frames数据
@property(nonatomic,strong)NSMutableArray *uniFrames;
//搜索工具条
@property(nonatomic,strong)HomeSearchView *searchView;
//轮播图
@property(nonatomic,strong)YYAutoLoopView *autoLoopView;
//分区头名称数组
@property(nonatomic,strong)NSArray *SectionTitles;
//广告数组
@property(nonatomic,strong)NSMutableArray *advertise_Arr;
//热门目地地
@property(nonatomic,strong)NSMutableArray *hotCity_Arr;
//推荐院校
@property(nonatomic,strong)NSMutableArray *recommends;
//智能匹配数量
@property(nonatomic,assign)NSInteger recommendationsCount;
//下拉
@property(nonatomic,strong)MJRefreshGifHeader *fresh_Header;

@end

@implementation HomeViewContViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
    
    [MobClick beginLogPageView:@"page新版首页"];
    
//    [self UserLanguage];  //ENGLISH  设置环境
    
    [self checkZhiNengPiPei];
    
    //判断用户是否登录且登录用户手机号码是否为空，如果为空用户退出登录；
    [self userInformation];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page新版首页"];
    
}

 
- (void)viewDidLoad {
    
    [super viewDidLoad];
     
    [self getSelectionSourse];
    
    [self hotCityData:NO];

    [self hotUniversity:NO];
    
    [self hotArticle:NO];
    
    [self hotPromotions:NO];
    
    [self makeUI];
    
    [self getAppReport];
    
    //--判断用户是否完成任务--
    if(![[NSUserDefaults standardUserDefaults] boolForKey:ADKEY]){
        
        [self advanceSupportWithDuration:180];
    }
 
}

-(NSMutableArray *)hotCity_Arr
{
    if (!_hotCity_Arr) {
        
        _hotCity_Arr =[NSMutableArray array];
    }
    return _hotCity_Arr;
}

-(NSMutableArray *)uniFrames
{
    if (!_uniFrames) {
        
        _uniFrames =[NSMutableArray array];
    }
    return _uniFrames;
}

-(NSMutableArray *)recommends
{
    if (!_recommends) {
        
        _recommends =[NSMutableArray array];
    }
    return _recommends;
}

-(NSMutableArray *)advertise_Arr
{
    if (!_advertise_Arr) {
        
        _advertise_Arr =[NSMutableArray array];
    }
    return _advertise_Arr;
}


-(void)checkZhiNengPiPei{
 
    if (LOGIN) {
        
        //判断是否有智能匹配数据或收藏学校
        [self startAPIRequestUsingCacheWithSelector:kAPISelectorRequestCenter parameters:nil success:^(NSInteger statusCode, NSDictionary *response) {
            
            self.recommendationsCount = [response[@"recommendationsCount"] integerValue];
            
        }];
    }
}


-(void)hotUniversity:(BOOL)refresh
{
    
    [self startAPIRequestUsingCacheWithSelector:kAPISelectorHotUniversity parameters:nil success:^(NSInteger statusCode, NSDictionary *response) {
        
        NSArray *uniArr =  (NSArray *)response;
        
        if (refresh) {
            
            [self.uniFrames removeAllObjects];
        }
        
        NSMutableArray *temps = [NSMutableArray array];
        for (NSDictionary *uniInfor in uniArr) {
            
            HotUniversityFrame *uniFrame = [[HotUniversityFrame alloc] init];
            uniFrame.universityDic = uniInfor;
            [temps addObject:uniFrame];
        }
        
        self.uniFrames = [temps mutableCopy];
   
        [self.TableView reloadData];
        
    }];

}



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

-(void)hotArticle:(BOOL)refresh
{
    [self startAPIRequestUsingCacheWithSelector:kAPISelectorArticleRecommendation parameters:nil success:^(NSInteger statusCode, id response) {
        
        if (refresh) {
            
            [self.recommends removeAllObjects];
        }
        
        self.recommends = [(NSArray *)response mutableCopy];
        
        [self.TableView reloadData];
    }];
   
}

-(NSArray *)SectionTitles
{
    if (!_SectionTitles) {
        
        _SectionTitles =@[GDLocalizedString(@"Discover_mudidi"),GDLocalizedString(@"Discover_news"),GDLocalizedString(@"Discover_hotUni")];
    }
    return _SectionTitles;
}


-(void)makeUI
{
    [self makeHomeTableView];
    
    [self checkAPPVersion];
    
 }

-(void)makeHomeTableView
{

    self.TableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0, XScreenWidth, XScreenHeight) style:UITableViewStyleGrouped];
    self.TableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    self.TableView.delegate = self;
    self.TableView.dataSource = self;
    [self.view addSubview:self.TableView];
    self.TableView.sectionFooterHeight = 0;
    self.TableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.TableView.backgroundColor = BACKGROUDCOLOR;
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    
    [self makeTableHeader];

    [self makeRefreshView];
    
    [self makeAutoLoopView];
    
    [self makeSearchView];
   
}

-(void)makeTableHeader
{
    
    self.TableHeaderView =[[HomeHeaderView alloc] init];
    self.TableHeaderView.delegate = self;
    self.TableHeaderView.frame = CGRectMake(0, 0, XScreenWidth, XScreenHeight * 0.6);
    self.TableView.tableHeaderView = self.TableHeaderView;
 
}

//页面刷新
-(void)refresh
{
    
    [self hotCityData:YES];
    
    [self hotUniversity:YES];
    
    [self hotArticle:YES];
    
    [self hotPromotions:YES];
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

-(void)makeSearchView
{
    self.searchView = [HomeSearchView View];
    XJHUtilDefineWeakSelfRef
    self.searchView.actionBlock = ^{
        
        
 
         [MobClick event:@"home_shearchItemClick"];

         [weakSelf presentViewController:[[XWGJNavigationController alloc] initWithRootViewController:[[SearchViewController alloc] init]] animated:YES completion:nil];
    };
    [self.view addSubview: self.searchView];
    
    CGFloat searchX = 20;
    CGFloat searchH = 44;
    CGFloat searchW = XScreenWidth - 40;
    CGFloat searchY = XScreenHeight * 0.6 * 0.5 + 20 -22;
    self.searchView.frame =CGRectMake(searchX,searchY,searchW, searchH);
    
}

-(void)searchViewWithAnimation:(BOOL)animated
{
    self.searchView.LeftBtn.hidden = animated;
    self.searchView.RightBtn.hidden = !animated;
    [UIView animateWithDuration:0.25 animations:^{
        CGRect newRect = self.searchView.frame;
        newRect.size.width = animated ? XScreenWidth - 40 : 44;
        self.searchView.frame = newRect;
        self.searchView.layer.cornerRadius = animated ? 5.0f : 22.0f;
    }];
    
}

#pragma mark ———————— UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
     CGFloat contant = XScreenHeight * 0.6 * 0.5 + 20 -22 - scrollView.contentOffset.y;
    
    if (contant > 20) {
    
        CGRect newRect = self.searchView.frame;
        newRect.origin.y = contant;
        self.searchView.frame = newRect;
     
          [self searchViewWithAnimation:YES];
        
    }else{
        
        CGRect newRect = self.searchView.frame;
        newRect.origin.y = 20;
        self.searchView.frame = newRect;
        
        if (self.searchView.frame.origin.y == 20) {
            
          [self searchViewWithAnimation:NO];

        }
    }
    
    if (scrollView.contentOffset.y >= - 100 && scrollView.contentOffset.y <= 0) {
        CGFloat Gscale =0.2 + 0.5 * ABS(scrollView.contentOffset.y)/ 100.0;
        self.fresh_Header.gifView.transform = CGAffineTransformMakeScale(Gscale, Gscale);
    }
    
}

//第一次网络请求
-(void)hotCityData:(BOOL)refresh
{
    [self startAPIRequestUsingCacheWithSelector:kAPISelectorHomepage parameters:nil success:^(NSInteger statusCode, NSArray *response) {
      
        NSArray *temps =  [response copy];
        
        NSRange range = NSMakeRange(1, 3);
      
        if (refresh) {
            
            [self.hotCity_Arr removeAllObjects];
        }
        
        self.hotCity_Arr = [[temps subarrayWithRange:range] mutableCopy];
 
        
        [self.TableView reloadData];
        
     }];
}


/**
 *  创建轮播图头部
 */
- (void)makeAutoLoopView {
    
    XJHUtilDefineWeakSelfRef
    
    CGFloat AY =  XScreenHeight * 0.6 * 0.5 + 20;
    CGFloat AH = XScreenHeight * 0.6 - AY;
    self.autoLoopView = [[YYAutoLoopView alloc] initWithFrame:CGRectMake(0,AY, XScreenWidth,AH)];
    [self.TableHeaderView addSubview:self.autoLoopView];
    
    self.autoLoopView.clickAutoLoopCallBackBlock = ^(YYSingleNewsBO *StatusBarBannerNews){
   
        [MobClick event:@"home_advertisementClick"];
        AdvertiseViewController *detail =[[AdvertiseViewController alloc] init];
        detail.advertise_title = weakSelf.advertise_Arr[StatusBarBannerNews.index][@"title"];
        detail.StatusBarBannerNews = StatusBarBannerNews;
        [weakSelf.navigationController pushViewController:detail animated:YES];
        
    };
    
}



#pragma mark  ———————————— UITableViewDelegate  UITableViewData
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section; {

    HomeSectionHeaderView *SectionView =[HomeSectionHeaderView view];
    SectionView.TitleLab.text =self.SectionTitles[section];
    SectionView.moreBtn.hidden = YES;
    if (section == 1 && !USER_EN) {
        SectionView.moreBtn.hidden = NO;
        SectionView.actionBlock = ^{
              [self.tabBarController setSelectedIndex:2];
        };
    }
    
    return  SectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return XScreenWidth *0.4;

            break;
        case 1:
             return  2 * XScreenWidth *0.4;
             break;
        default:
        {
            if (self.uniFrames.count > 0) {
             HotUniversityFrame *uniFrame = self.uniFrames[0];
            return uniFrame.cellHeight;

            }else
            {
                return 0;
             }
        }
             break;
    }

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    switch (section) {
        case 0:
            return self.hotCity_Arr.count;
            break;
        case 1:
            return self.recommends.count > 0 ? 1 : 0;
            break;
        default:
            return 1;
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
       switch (indexPath.section) {
        case 0:
        {
            HomeFirstTableViewCell *cell =[HomeFirstTableViewCell cellInitWithTableView:tableView];
            cell.itemInfo = self.hotCity_Arr[indexPath.row];
            return cell;
         }
          break;
          case 1:{
            
            HomeSecondTableViewCell *cell =[HomeSecondTableViewCell cellInitWithTableView:tableView];
            cell.items = self.recommends;
            cell.delegate = self;
             
            return cell;
        
        }
             break;
            default:
        {

            HomeThirdTableViewCell *cell =[HomeThirdTableViewCell cellInitWithTableView:tableView];
            cell.uniFrames = self.uniFrames;
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
        
        NSString *item;
        if (indexPath.row == 0) {
            
            item = @"home_LondonItemClick";
        }else{
            
            item = indexPath.row == 1? @"home_SydneyItemClick":@"home_ManchesterItemClick";
        }
        
         [MobClick event:item];
        
        
        NSDictionary *info = self.hotCity_Arr[indexPath.row];
        NSString *searchValue = info[@"search"];
        XNewSearchViewController *vc = [[XNewSearchViewController alloc] initWithFilter:KEY_CITY
                                                                                  value:searchValue
                                                                                orderBy:RANKTI];
        vc.Corecity = searchValue;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
}

#pragma mark —————— HomeHeaderViewDelegate
-(void)HomeHeaderView:(HomeHeaderView *)itemView WithItemtap:(UIButton *)sender
{
   
    
    NSArray *counries = [[NSUserDefaults standardUserDefaults] valueForKey:@"Country_CN"];
    if (counries.count == 0) {
         //用于防止用户第一次加载备用数据失败
         [self getSelectionSourse];
        
         return;
    }
    
     switch (sender.tag) {
         case 0:
         {
             [MobClick event:@"WoYaoLiuXue"];
             [self.navigationController pushViewController:[[XLiuxueViewController alloc] init] animated:YES];
         }
            break;
        case 1:
         {
             [MobClick event:@"XiaoBai"];
             [self.navigationController pushViewController:[[XXiaobaiViewController alloc] init] animated:YES];
             
         }
            
            break;
         case 2:{
             
             [MobClick event:@"PiPei"];
             RequireLogin
             if (self.recommendationsCount > 0 && LOGIN) {
                 [self.navigationController pushViewController:[[IntelligentResultViewController alloc] init] animated:YES];
             }else{
                  [self.navigationController pushViewController:[[InteProfileViewController alloc] init] animated:YES];
             }
         }
            break;
         case 3:
         {
             [MobClick event:@"home_mall"];
             [self liuxueService];
         }
            break;
        default:
            [self openLeftMenu];
            break;
    }
    
}

#pragma mark —————— HomeSecondTableViewCellDelegate
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

-(void)liuxueService
{
    [self.navigationController pushViewController:[[ServiceMallViewController alloc] init] animated:YES];
    
}

#pragma mark  ————————————  UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  
         if (buttonIndex) { //跳转到appstore下载页面
         
            NSString *appid = @"1016290891";
            
            NSString *str = [NSString stringWithFormat:
                             
                             @"itms-apps://itunes.apple.com/cn/app/id%@?mt=8", appid];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
     }
    
}



#pragma mark ------- 提前加载数据，存储在本地，下次调用
-(void)getSelectionSourse
{
    NSUserDefaults *ud  = [NSUserDefaults  standardUserDefaults];
    
    [self startAPIRequestUsingCacheWithSelector:kAPISelectorGrades parameters:@{@":lang":@"zh-cn"} success:^(NSInteger statusCode, NSArray * response) {
        
        [ud setValue:response forKey:@"Grade_CN"];
        
    }];
    
    
    [self startAPIRequestUsingCacheWithSelector:kAPISelectorSubjects parameters:@{@":lang":@"zh-cn"} success:^(NSInteger statusCode, NSArray * response) {
      
        [ud setValue:response forKey:@"Subject_CN"];
        
    }];
    
    [self startAPIRequestUsingCacheWithSelector:kAPISelectorCountries parameters:@{@":lang":@"zh-cn"} success:^(NSInteger statusCode, NSArray * response) {
        
        [ud setValue:response forKey:@"Country_CN"];
        
    }];
    
    
    [self startAPIRequestUsingCacheWithSelector:kAPISelectorSubjects parameters:@{@":lang":@"en"} success:^(NSInteger statusCode, NSArray * response) {
        
        [ud setValue:response forKey:@"Subject_EN"];
        
    }];
    
    
    [self startAPIRequestUsingCacheWithSelector:kAPISelectorCountries parameters:@{@":lang":@"en"} success:^(NSInteger statusCode, NSArray * response) {
        
        [ud setValue:response forKey:@"Country_EN"];
        
    }];
    [self startAPIRequestUsingCacheWithSelector:kAPISelectorGrades parameters:@{@":lang":@"en"} success:^(NSInteger statusCode, NSArray * response) {

        [ud setValue:response forKey:@"Grade_EN"];

    }];
 
    
    
    [ud synchronize];
    
    
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

 
//请求用户信息
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
