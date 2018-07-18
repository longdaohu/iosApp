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
#import "HomeApplicationVC.h"
#import "HomeFeeVC.h"
#import "MyofferUpdateView.h"
#import <AdSupport/AdSupport.h>
#import "NSString+MD5.h"

#define  MENU_HEIGHT  XNAV_HEIGHT + 16
#define  CELL_CL_HEIGHT  XSCREEN_HEIGHT
#define  CELL_CL_WIDTH  XSCREEN_WIDTH
#define  ADKEY @"Advertiseseeee"

@interface HomeIndexVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView *clView;
@property(nonatomic,strong)HomeMenuBarView *MenuBarView;
@property(nonatomic,assign)UIStatusBarStyle currentStatusBarStyle;
@property(nonatomic,strong)NSArray *childViewControllersArray;
@property (assign, nonatomic)BOOL  hadShowNeWVersion;

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
    [self userInformation];
    [self checkTheNewVersion];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [MobClick endLogPageView:@"page新版首页"];
}

- (NSArray<UIViewController *> *)childViewControllersArray {
    
    if (!_childViewControllersArray) {
        //推荐
        HomeRecommendVC *recomend  = [[HomeRecommendVC alloc] init];
        //留学申请
        HomeApplicationVC *application  = [[HomeApplicationVC alloc] init];
        //学费支付
        HomeFeeVC *fee  = [[HomeFeeVC alloc] init];
        fee.type = HomeLandingTypeMoney;
        //海外租房
        HomeFeeVC *room  = [[HomeFeeVC alloc] init];
        room.type = HomeLandingTypeRoom;
        //游学职培
        HomeFeeVC *yes  = [[HomeFeeVC alloc] init];
        yes.type = HomeLandingTypeYesGlobal;
        //海外移民
        HomeFeeVC *uvic  = [[HomeFeeVC alloc] init];
        uvic.type = HomeLandingTypeUVIC;
        
        _childViewControllersArray = @[ recomend,
                                        application,
                                        fee,
                                        room,
                                        yes,
                                        uvic,
                                        ];
    }
    
    return _childViewControllersArray;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self makeUI];
    for (UIViewController *vc  in self.childViewControllersArray) {
        [self addChildViewController:vc];
    }
    [self makeOther];
}

- (void)makeUI{
    
    self.currentStatusBarStyle = UIStatusBarStyleDefault;
    [self makeCollectView];
    [self makeMenuView];
}

- (void)makeMenuView{
    
    WeakSelf;
    NSArray *titles = @[@"推荐",@"留学申请",@"学费支付",@"海外租房",@"游学职培",@"海外移民"];
    HomeMenuBarView *MenuView = [HomeMenuBarView menuInitWithTitles:titles clickButton:^(NSInteger index) {
        [weakSelf MenuScrollToIndex:index];
    }];
    MenuView.frame = CGRectMake(0, 0, XSCREEN_WIDTH, MENU_HEIGHT);
    self.MenuBarView = MenuView;
    [self.view addSubview:MenuView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
    cView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:cView];
    self.clView = cView;
    [cView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    
}

#pragma mark : UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.MenuBarView.titles.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    //            [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIViewController *vc  = self.childViewControllersArray[indexPath.row];
    [cell.contentView addSubview:vc.view];
    
    return cell;
}

#pragma mark : UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.MenuBarView menuDidScrollWithScrollView:scrollView];
    NSInteger index = (NSInteger)((scrollView.mj_offsetX / scrollView.mj_w) + 0.5);
    [self toSetTabBarHidden:index];
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
    [self toLoadViewControllerWithPage:index];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    NSInteger index = (NSInteger)((scrollView.mj_offsetX / scrollView.mj_w) + 0.5);
    [self toLoadViewControllerWithPage:index];
}


- (void)toSetTabBarHidden:(NSInteger)index{
    
    if (index == 0){
        self.tabBarController.tabBar.hidden = NO;
        return;
    }
    UIViewController *vc = self.childViewControllersArray[index];
    if (index == 1) {
        HomeApplicationVC *application = (HomeApplicationVC *)vc;
        [application toSetTabBarhidden];
    }else{
        HomeFeeVC *other = (HomeFeeVC *)vc;
        [other toSetTabBarhidden];
    }
}

- (void)toLoadViewControllerWithPage:(NSInteger)page{
    
    if (page == 0){
        self.tabBarController.tabBar.hidden = NO;
        return;
    }
    UIViewController *vc = self.childViewControllersArray[page];
    if (page == 1) {
        HomeApplicationVC *application = (HomeApplicationVC *)vc;
        [application toLoadView];
    }else{
        HomeFeeVC *other = (HomeFeeVC *)vc;
        [other toLoadView];
    }
}

#pragma mark : 事件处理
//菜单栏切换
- (void)MenuScrollToIndex:(NSInteger)index{
    
    NSInteger from_index = (NSInteger)((self.clView.mj_offsetX / self.clView.mj_w) + 0.5);
    BOOL ani =  (abs((int)(from_index - index)) == 1);
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.clView selectItemAtIndexPath:indexPath animated:ani scrollPosition:UICollectionViewScrollPositionLeft];
    if (!ani) {
        [self toLoadViewControllerWithPage:index];
    }
    
    self.currentStatusBarStyle = (index == 0) ? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
    [self changeStatusBar];
}

- (void)changeStatusBar{
    if ([UIApplication sharedApplication].statusBarStyle != self.currentStatusBarStyle) {
        [UIApplication sharedApplication].statusBarStyle =  self.currentStatusBarStyle;
    }
}


//请求用户信息
//判断用户是否登录且登录用户手机号码是否为空，如果为空用户退出登录；
-(void)userInformation
{
    if (!LOGIN) return;
    WeakSelf
    [self startAPIRequestWithSelector:kAPISelectorAccountInfo parameters:nil expectedStatusCodes:nil showHUD:NO showErrorAlert:NO errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        MyofferUser *user = [MyofferUser mj_objectWithKeyValues:response];
        if (0 == user.phonenumber.length) [weakSelf caseBackAndLogout];
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
    }];
}

//退出登录
-(void)caseBackAndLogout
{
    if(LOGIN){
        [[AppDelegate sharedDelegate] logout];
        [MobClick profileSignOff];/*友盟第三方统计功能统计退出*/
        //        [JPUSHService setAlias:@"" completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        //        } seq:0 ];//Jpush设置登录用户别名
        [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        } seq:0];
        [self startAPIRequestWithSelector:kAPISelectorLogout parameters:nil showHUD:YES success:^(NSInteger statusCode, id response) {
        }];
    }
}

-(void)makeOther{
    
    [self getAppReport];
    //--判断用户是否完成任务--
    if(![[NSUserDefaults standardUserDefaults] boolForKey:ADKEY]){
        [self advanceSupportWithDuration:180];
    }
    [self baseDataSourse]; //加载基础数据
}

//---推广接口，用户是否在使用myoffer---
-(void)advanceSupportWithDuration:(int)durationTime
{
    
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    NSString *secret = @"s9xyfjwilruwefnxdkjvhxck3sxceikrbzbde";
    
    NSString *signature = [NSString stringWithFormat:@"idfa=%@%@",adId,secret];
    signature = [signature KD_MD5];
    NSString  *path = [NSString stringWithFormat:@"GET /api/youqian/finish?idfa=%@&signature=%@",adId,signature];
    
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


//检查版本更新
- (void)checkTheNewVersion
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
            NSDictionary *appDic = [[NSBundle mainBundle] infoDictionary];
            NSString *ccurrentVersionStr = [appDic objectForKey:@"CFBundleShortVersionString"];
            NSString *currentVersion = [ccurrentVersionStr stringByReplacingOccurrencesOfString:@"." withString:@""];
            self.hadShowNeWVersion = YES;
            if (storeVersion.integerValue <= currentVersion.integerValue) return ;
            dispatch_async(dispatch_get_main_queue(), ^{
                //更新UI操作
                [[MyofferUpdateView updateView] show];
            });
            
        }else {
            // 网络访问失败
            self.hadShowNeWVersion = NO;
        }
        
    }];
    
    [task resume];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

