//
//  HomeViewContViewController.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/18.
//  Copyright © 2016年 UVIC. All rights reserved.

#define ADKEY @"Advertiseseeee"
#define HEADER_HEIGHT XSCREEN_HEIGHT * 0.7

#import "HomeHeaderView.h"
#import "HomeViewContViewController.h"
#import "HomeSectionHeaderView.h"
#import "HomeFirstTableViewCell.h"
#import "HomeSecondTableViewCell.h"
#import "HomeThirdTableViewCell.h"
#import "UniCollectionViewCell.h"
#import "WYLXViewController.h"
#import "MessageDetaillViewController.h"
#import "PipeiEditViewController.h"
#import "IntelligentResultViewController.h"
#import "HotUniversityFrame.h"
#import "HomeSearchView.h"
#import "SearchViewController.h"
#import <AdSupport/AdSupport.h>
#import "NSString+MD5.h"
#import "SearchUniversityCenterViewController.h"
#import "MyOfferUniversityModel.h"
#import "HeadItem.h"
#import "SDCycleScrollView.h"
#import "MyOfferServerMallViewController.h"
#import "MyOfferAutoRunBanner.h"
#import "HomeHeaderFrame.h"
#import "CatigoryViewController.h"
#import "MyofferUpdateView.h"
#import "SuperMasterViewController.h"
#import "GuideOverseaViewController.h"
#import "DiscountVC.h"

@interface HomeViewContViewController ()<UITableViewDataSource,UITableViewDelegate,HomeSecondTableViewCellDelegate,HomeThirdTableViewCellDelegate>
@property(nonatomic,strong)UITableView *TableView;
//搜索工具条
@property(nonatomic,strong)HomeSearchView *searchView;
//轮播图
@property(nonatomic,strong)SDCycleScrollView *autoLoopView;
//智能匹配数量
@property(nonatomic,assign)NSInteger recommendationsCount;
//下拉
@property(nonatomic,strong)MJRefreshGifHeader *fresh_Header;
//分组数据
@property(nonatomic,strong)NSMutableArray *groups;
//轮播图数据
@property(nonatomic,strong)NSArray *banner;

@property(nonatomic,strong)UIView *topView;

@property(nonatomic,strong)HomeHeaderFrame *headerFrame;

@property(nonatomic,assign)UIStatusBarStyle currentStatusBarStyle;

@property(nonatomic,assign)BOOL hadShowNeWVersion;

@end


@implementation HomeViewContViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
 
    [self presentViewWillAppear];
    
    [UIApplication sharedApplication].statusBarStyle = (self.currentStatusBarStyle ==  UIStatusBarStyleLightContent ) ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
    
}

//页面出现时预加载功能
-(void)presentViewWillAppear{
    
    [MobClick beginLogPageView:@"page新版首页"];
 
    self.tabBarController.tabBar.hidden = NO;
    
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
    
    //    [self UserLanguage];  //ENGLISH  设置环境
    
    [self checkZhiNengPiPei];
    
    [self userInformation];
    
    [self userDidClickItem];
    
    [self checkAPPVersion];
    
 
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [MobClick endLogPageView:@"page新版首页"];
  
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
     
    [self makeDataSourceRefresh:NO];
    
    [self makeUI];
    
    [self makeOther];
 
}



-(void)makeOther{
  
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
        
        myofferGroupModel  *groupone = [myofferGroupModel groupWithItems:nil  header:@"留学目的地" footer:nil accessory:@"更多地区"];
        groupone.type = SectionGroupTypeA;
        groupone.head_accesory_arrow = YES;
        [_groups addObject:groupone];
        
        myofferGroupModel *grouptwo = [myofferGroupModel groupWithItems:nil  header:@"热门阅读" footer:nil accessory:@"更多资讯"];
        grouptwo.type = SectionGroupTypeB;
        grouptwo.head_accesory_arrow = YES;
        [_groups addObject:grouptwo];
        
        myofferGroupModel *groupthree = [myofferGroupModel groupWithItems:nil  header:@"热门院校" footer:nil accessory:@"更多资讯"];
        groupthree.type = SectionGroupTypeC;
        [_groups addObject:groupthree];
    }
    return _groups;
}


//热门院校
-(void)hotUniversity:(BOOL)refresh
{
    
    [self startAPIRequestUsingCacheWithSelector:kAPISelectorHotUniversity parameters:nil success:^(NSInteger statusCode, id response) {
        
        [self dataSourseWithFresh:refresh GroupIndex:2];
        
        [self hotUniverstiyWithResponse:(NSArray *)response];
        
        [self.TableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
    }];

}


//留学目的地数据
-(void)hotCityData:(BOOL)refresh
{
    
    [self startAPIRequestUsingCacheWithSelector:kAPISelectorHomepage parameters:nil success:^(NSInteger statusCode, NSArray *response) {
        
        [self dataSourseWithFresh:refresh GroupIndex:0];
        
        [self hotCityWithResponse:response];
        
        [self.TableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    
    }];
}

//热门文章
-(void)hotArticle:(BOOL)refresh
{
    
    [self startAPIRequestUsingCacheWithSelector:kAPISelectorArticleRecommendation parameters:nil success:^(NSInteger statusCode, id response) {
        
        
        [self dataSourseWithFresh:refresh GroupIndex:1];
        
        [self hotArticleWithResponse:(NSArray *)response];
        
        [self.TableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        
    }];
    
}


- (void)dataSourseWithFresh:(BOOL)refresh GroupIndex:(NSInteger)index{
    
    if (refresh) {
        
        myofferGroupModel *groupthree = self.groups[index];
        
        groupthree.items = nil;
    }
    
}

//留学目的地UI设置
-(void)hotCityWithResponse:(NSArray *)response
{
    myofferGroupModel *groupone = self.groups[0];
    groupone.cell_height_set = XSCREEN_WIDTH * 0.4;
    NSArray *temp_cities = response.count > 4 ? [response subarrayWithRange:NSMakeRange(1, 3)] : response;
    groupone.items = temp_cities;
}

//热门文章UI设置
-(void)hotArticleWithResponse:(NSArray *)response
{
    
    NSArray  *temp_articles  = (NSArray *)response;
    myofferGroupModel *grouptwo = self.groups[1];
    grouptwo.cell_height_set =  ceilf(temp_articles.count * 0.5) * XSCREEN_WIDTH * 0.4;
    grouptwo.items = @[temp_articles];
    
}
//热门院校UI设置
-(void)hotUniverstiyWithResponse:(NSArray *)response
{
    
    NSMutableArray *temp_universities = [NSMutableArray array];
    
    [response enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HotUniversityFrame *uniFrame = [HotUniversityFrame frameWithUniversity:obj];
        [temp_universities addObject:uniFrame];
    }];
    
    myofferGroupModel *groupthree = self.groups[2];
    
    if (temp_universities.count > 0) {
        HotUniversityFrame *uniFrame = temp_universities[0];
        groupthree.cell_height_set = uniFrame.cellHeight;
    }
    
    groupthree.items = @[temp_universities];
    
}

//轮播图数据
-(void)hotPromotions:(BOOL)refresh
{
  
    XWeakSelf
    
    [self startAPIRequestWithSelector:kAPISelectorMessagePromotions  parameters:nil expectedStatusCodes:nil showHUD:NO showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        
        weakSelf.banner  = [MyOfferAutoRunBanner mj_objectArrayWithKeyValuesArray:(NSArray *)response];
        
        weakSelf.autoLoopView.imageURLStringsGroup  =  [weakSelf.banner valueForKeyPath:@"thumbnail"];
        
        weakSelf.autoLoopView.userInteractionEnabled = weakSelf.banner.count ? YES : NO;
        
        [weakSelf.TableView.mj_header endRefreshing];
        
        [weakSelf.TableView reloadData];
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        weakSelf.autoLoopView.userInteractionEnabled = NO;
        
        [weakSelf.TableView.mj_header endRefreshing];
        
    }];
    

}


-(void)makeUI
{
    
    [self makeHomeTableView];
    
    
    UIImageView *maskBgView =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, 64)];
    maskBgView.image = [UIImage imageNamed:@"gradient_up"];
    [self.view addSubview:maskBgView];
    
    
    UIView *topView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, 0)];
    topView.backgroundColor = XCOLOR_WHITE;
    [self.view addSubview:topView];
    self.topView = topView;
    
    self.currentStatusBarStyle = UIStatusBarStyleLightContent;
    
}




- (HomeHeaderFrame *)headerFrame{

    if (!_headerFrame) {
        
        _headerFrame = [[HomeHeaderFrame alloc] init];
    }
    
    return _headerFrame;
}

-(void)makeHomeTableView{

    self.TableView =[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.TableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    self.TableView.delegate = self;
    self.TableView.dataSource = self;
    [self.view addSubview:self.TableView];
    self.TableView.sectionFooterHeight = HEIGHT_ZERO;
    self.TableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.TableView.backgroundColor = XCOLOR_BG;
    /*
     *automaticallyAdjustsScrollViewInsets属性被废弃了，顶部就多了一定的inset，
     关于安全区域适配，简书上的这篇文章iOS 11 安全区域适配总结介绍得非常详细，请参考这篇文章。
     */
    if (@available(iOS 11.0, *)) {
        self.TableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self makeTableHeader];

    [self makeRefreshView];
    
    [self makeSearchView];
   
}

//添加表头
-(void)makeTableHeader
{
  
    HomeHeaderView *TableHeaderView =[HomeHeaderView headerViewWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, self.headerFrame.Header_Height) actionBlock:^(NSInteger tag) {
        [self HomeHeaderViewWithTag:tag];
    }];
    
    TableHeaderView.headerFrame = self.headerFrame;
    self.TableView.tableHeaderView  = TableHeaderView;
    [self makeAutoLoopViewAtView: TableHeaderView];
 

}

//页面刷新
-(void)refresh
{
    [self makeDataSourceRefresh:YES];
    
}


//设置下拉刷新
-(void)makeRefreshView
{
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
//    header.lastUpdatedTimeLabel.hidden = YES;
//    header.stateLabel.hidden = YES;
    self.fresh_Header = header;
    self.fresh_Header.gifView.transform = CGAffineTransformMakeScale(0.2, 0.2);

    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (int i = 0; i<= 10; i++) {
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
-(void)makeSearchView{
    
    
    CGFloat searchX = 20;
    CGFloat searchH = 44;
    CGFloat searchW = XSCREEN_WIDTH - searchX * 2;
    CGFloat searchY = CGRectGetMaxY(self.headerFrame.autoScroller_frame) - searchH * 0.5;
    HomeSearchView *searchView = [HomeSearchView ViewWithFrame:CGRectMake(searchX,searchY,searchW, searchH)];
    self.searchView = searchView;
    XWeakSelf
    searchView.actionBlock = ^{
        
        [weakSelf CaseSearchPage];
    };
    [self.view addSubview:searchView];

}


#pragma mark : 创建轮播图头部
- (void)makeAutoLoopViewAtView:(UIView *)bgView{
    
    XWeakSelf
    SDCycleScrollView *autoLoopView = [SDCycleScrollView cycleScrollViewWithFrame:self.headerFrame.autoScroller_frame delegate:nil placeholderImage:nil];
    self.autoLoopView = autoLoopView;
    autoLoopView.placeholderImage =   [UIImage imageNamed:@"PlaceHolderImage"];
    autoLoopView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    autoLoopView.currentPageDotColor = XCOLOR_LIGHTBLUE;
    autoLoopView.pageControlBottomOffset =  15;
    [bgView addSubview:autoLoopView];
    autoLoopView.clickItemOperationBlock = ^(NSInteger index) {
        
         MyOfferAutoRunBanner  *item  = weakSelf.banner[index];
        [weakSelf CaseLandingPageWithBan:item.url];
        
    };
}

#pragma mark : UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    CGFloat show = (scrollView.contentOffset.y > CGRectGetMaxY(self.headerFrame.autoScroller_frame)) ? 20 : 0;
    
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        
         self.topView.mj_h = show;
        
    } completion:^(BOOL finished) {
     
        
        self.currentStatusBarStyle = show ?  UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
        
        [UIApplication sharedApplication].statusBarStyle = self.currentStatusBarStyle;
        
    }];
        
    
    if (scrollView.contentOffset.y < -150) [self.TableView setContentOffset:CGPointMake(0, -150) animated:NO];
 
    [self.searchView searchViewWithScrollViewDidScrollContentOffsetY:(CGRectGetMaxY(self.headerFrame.autoScroller_frame) - self.searchView.mj_h * 0.5 - scrollView.contentOffset.y)];
    
    if (scrollView.contentOffset.y >= - 100 && scrollView.contentOffset.y <= 0) {
      
        CGFloat Gscale = 0.2 + 0.5 * ABS(scrollView.contentOffset.y)/ 100.0;
        self.fresh_Header.gifView.transform = CGAffineTransformMakeScale(Gscale, Gscale);
    }
    
}

#pragma mark :UITableViewDelegate  UITableViewData

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section; {
  
    myofferGroupModel *group = self.groups[section];
    
    HomeSectionHeaderView *SectionView =[HomeSectionHeaderView sectionHeaderViewWithTitle:group.header_title];
    
    SectionView.accessory_title = group.accesory_title;
    
    if ((self.groups.count - 1) > section) {
        
        [SectionView arrowButtonHiden:NO];
        
         SectionView.actionBlock = ^{
             
              NSInteger  selectionIndex = (section == 0) ? 1:2;
              [self.tabBarController setSelectedIndex:selectionIndex];
             
             if (selectionIndex == 1) {
  
                 UINavigationController *nav  = self.tabBarController.childViewControllers[selectionIndex];
                 CatigoryViewController *catigroy =  (CatigoryViewController *)nav.childViewControllers[0];
                 [catigroy jumpToHotCity];
             }
             
             
        };
    }
     return  SectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    myofferGroupModel *group = self.groups[section];
    
    return group.section_header_height;
 }

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
  
    myofferGroupModel *group = self.groups[indexPath.section];
    
    return   group.items.count > 0 ? group.cell_height_set : HEIGHT_ZERO;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    myofferGroupModel *group = self.groups[section];

    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    myofferGroupModel *group = self.groups[indexPath.section];
  
       switch (group.type) {
        case SectionGroupTypeA:
        {
            HomeFirstTableViewCell *cell =[HomeFirstTableViewCell cellInitWithTableView:tableView];
            cell.itemInfo = group.items[indexPath.row];
            
            return cell;
         }
          break;
               
          case SectionGroupTypeB:{
              
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
#pragma mark : HomeHeaderViewDelegate
-(void)HomeHeaderViewWithTag:(NSInteger )tag
{
    
     switch (tag) {
         case 0:
             [self CaseWoyaoliuXue];
            break;
        case 1:
             [self CaseLiuXueXiaoBai];
            break;
         case 2:
             [self Casepipei];
            break;
         case 3:
         {
             [self.tabBarController setSelectedIndex:1];
             UINavigationController *nav  = self.tabBarController.childViewControllers[1];
             CatigoryViewController *catigroy =  (CatigoryViewController *)nav.childViewControllers[0];
             [catigroy jumpToRank];
         }
             break;
         case 4:
             [self CaseSuperMaster];
              break;
         case 5:
             [self CaseServerMall];
             break;
        default:
            break;
    }
}
#pragma mark : HomeSecondTableViewCellDelegate
-(void)HomeSecondTableViewCell:(HomeSecondTableViewCell *)cell andDictionary:(NSDictionary *)response
{
    [MobClick event:@"home_newsItem"];
 
    [self.navigationController pushViewController:[[MessageDetaillViewController alloc] initWithMessageId:response[@"_id"]] animated:YES];
}

#pragma mark : HomeThirdTableViewCellDelegate
-(void)HomeThirdTableViewCell:(HomeThirdTableViewCell *)cell WithUniversity:(MyOfferUniversityModel *)uni{

    [MobClick event:@"home_universityItem"];
    
    [self.navigationController pushUniversityViewControllerWithID:uni.NO_id animated:YES];
}

 

//检查版本更新
-(void)checkAPPVersion
{
    //如果提示过就不再重新请求网络更新提示
    if (self.hadShowNeWVersion) {
        
        return;
    }
    
    //https://itunes.apple.com/cn/app/myoffer/id1016290891
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/lookup?id=1016290891"]];
//    request.timeoutInterval = 15;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        // 网络请求完成之后就会执行，NSURLSession自动实现多线程
        

        if (data && (error == nil)) {
  
            // 网络访问成功
            NSError *error;
            id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            NSDictionary *appInfo = (NSDictionary *)jsonObject;
            
 
            
            NSArray *store_results = appInfo[@"results"];
            NSString *storeVersionStr = [[store_results objectAtIndex:0] objectForKey:@"version"];
            NSString *storeVersion = [storeVersionStr stringByReplacingOccurrencesOfString:@"." withString:@""];
            
//                    NSLog(@" itunes.apple  %@  %@",[NSThread currentThread],storeVersionStr);

            
            NSDictionary *appDic = [[NSBundle mainBundle] infoDictionary];
            NSString *ccurrentVersionStr = [appDic objectForKey:@"CFBundleShortVersionString"];
            NSString *currentVersion = [ccurrentVersionStr stringByReplacingOccurrencesOfString:@"." withString:@""];
            
            self.hadShowNeWVersion = YES;

            if (storeVersion.integerValue <= currentVersion.integerValue) return ;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //更新UI操作
                //.....
                [[MyofferUpdateView updateView] show];
                
            });
            
            
        }else {
            // 网络访问失败
            
//            NSLog(@"itunes.apple >>>> 失败");
            
            self.hadShowNeWVersion = NO;

        }
        
    }];
    
    [task resume];
}


/*
ENGLISH  设置环境
--用户语言环境通知服务器----
-(void)UserLanguage
{
    if ([[AppDelegate sharedDelegate] isLogin]) {
        
        NSString *lang =USER_EN ? @"en":@"zh-cn";
        [self startAPIRequestWithSelector:kAPISelectorUserLanguage parameters:[NSDictionary dictionaryWithObject:lang forKey:@"language"] success:^(NSInteger statusCode, id response) {
            
        }];
    }
}
*/

//---推广接口，用户是否在使用myoffer---
-(void)advanceSupportWithDuration:(int)durationTime
{
    
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    NSString *secret = @"s9xyfjwilruwefnxdkjvhxck3sxceikrbzbde";
    
    NSString *signature = [NSString stringWithFormat:@"idfa=%@%@",adId,secret];
    signature = [signature KD_MD5];
    
    NSString  *path = [NSString stringWithFormat:@"GET /api/youqian/finish?idfa=%@&signature=%@",adId,signature];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//    });
    
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
    
    XWeakSelf
    [self startAPIRequestWithSelector:kAPISelectorAccountInfo parameters:nil expectedStatusCodes:nil showHUD:NO showErrorAlert:NO errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        
        MyofferUser *user = [MyofferUser mj_objectWithKeyValues:response];
        
        if (0 == user.phonenumber.length) [weakSelf caseBackAndLogout];
        
  
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        
    }];
    
}

//判断是否有智能匹配数据或收藏学校
-(void)checkZhiNengPiPei
{
    if (!LOGIN) return;
 
     XWeakSelf
    [self startAPIRequestWithSelector:kAPISelectorZiZengPipeiGet parameters:nil showHUD:NO errorAlertDismissAction:nil success:^(NSInteger statusCode, id response) {
        
        weakSelf.recommendationsCount = response[@"university"] ? 1 : 0;

    }];
 
 }

//退出登录
-(void)caseBackAndLogout
{
    
    if(LOGIN){
        
        [[AppDelegate sharedDelegate] logout];
        
        [MobClick profileSignOff];/*友盟第三方统计功能统计退出*/
        
        [APService setAlias:@"" callbackSelector:nil object:nil];  //设置Jpush用户所用别名为空
        
        [self startAPIRequestWithSelector:kAPISelectorLogout parameters:nil showHUD:YES success:^(NSInteger statusCode, id response) {
            
        }];
    }
    
}



//跳转我要留学
-(void)CaseWoyaoliuXue
{
    [MobClick event:@"WoYaoLiuXue"];
    
    [self presentViewController:[[WYLXViewController alloc] init]  animated:YES completion:nil];
    
}

//跳转留学指南
-(void)CaseLiuXueXiaoBai
{
    [MobClick event:@"XiaoBai"];
    
    [self.navigationController pushViewController:[[GuideOverseaViewController alloc] init] animated:YES];
}




//跳转智能匹配
-(void)CasePipeiWithItemType:(HomePageClickItemType)type
{
    self.clickType = LOGIN ? HomePageClickItemTypeNoClick : type;
    
    switch (type) {
            
        case HomePageClickItemTypetest:
        {
            RequireLogin
            
            [self CaseLandingPageWithBan:[NSString stringWithFormat:@"%@mbti/test",DOMAINURL]];
        }
            break;
        default:
            break;
    }
}

//跳转服务包
-(void)Casepipei
{
    [MobClick event:@"PiPei"];
    
    if (!LOGIN)  self.recommendationsCount = 0;
    
    if (self.recommendationsCount > 0) {
        
        RequireLogin
        
        [self.navigationController pushViewController:[[IntelligentResultViewController alloc] init]   animated:YES];
        
        return;
        
    }
        
     [self.navigationController pushViewController:[[PipeiEditViewController alloc] init]   animated:YES];
 
}
//跳转服务包
-(void)CaseServerMall
{

    [MobClick event:@"home_mall"];
    [self.navigationController pushViewController:[[MyOfferServerMallViewController  alloc] init] animated:YES];
    
}

//跳转服务包
-(void)CaseSuperMaster
{
     [self.navigationController pushViewController:[[SuperMasterViewController  alloc] init] animated:YES];
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
    
    if ([path hasSuffix:@"superMentor.html"]) {
        
        [self CaseSuperMaster];
        
    }else{
        
        [self.navigationController pushViewController:[[WebViewController alloc] initWithPath:path] animated:YES];
    }
 
}

//跳转LandingPage
-(void)CaseSearchResultWithindexPath:(NSIndexPath *)indexPath
{

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
    
    myofferGroupModel *group = self.groups[indexPath.section];
    NSDictionary *info = group.items[indexPath.row];
    NSString *searchValue = info[@"search"];
    
    SearchUniversityCenterViewController *vc = [[SearchUniversityCenterViewController alloc] initWithKey:KEY_CITY value:searchValue];
    
    [self.navigationController pushViewController:vc animated:YES];
}

//判断用户在未登录前在申请中心页面选择服务，当用户登录时直接跳转已选择服务

-(void)userDidClickItem
{
    if (!LOGIN) return;
        
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self CasePipeiWithItemType:self.clickType];

    });
    
}


//改变状态栏颜色
- (void)caseChangestatusBarStyle{
    
    [UIApplication sharedApplication].statusBarStyle = self.currentStatusBarStyle;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
