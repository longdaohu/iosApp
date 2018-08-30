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
//#import "HomeRoomVC.h"
#import "MyofferUpdateView.h"
#import <AdSupport/AdSupport.h>
#import "NSString+MD5.h"
#import "CatigaryScrollView.h"
#import "IntroViewController.h"
#import "HomeIndexModel.h"
#import "HomeYasiVC.h"

#define  CELL_CL_HEIGHT  XSCREEN_HEIGHT
#define  CELL_CL_WIDTH  XSCREEN_WIDTH
#define  ADKEY @"Advertiseseeee"

@interface HomeIndexVC ()<UIScrollViewDelegate>
@property(nonatomic,strong)CatigaryScrollView *bgScrollView;
@property(nonatomic,strong)HomeMenuBarView *MenuBarView;
@property(nonatomic,assign)UIStatusBarStyle currentStatusBarStyle;
@property(nonatomic,strong)NSArray *childViewControllersArray;
@property (assign, nonatomic)BOOL  hadShowNeWVersion;
@property(nonatomic,strong)NSArray *groups;

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


- (NSArray *)groups{

    if (!_groups) {
 
        HomeIndexModel *recommend = [[HomeIndexModel alloc] initWithTitle:@"推荐" backgroudImageName:nil destVC:[HomeRecommendVC class] indexType:HomeIndexTypeDefault];
        HomeIndexModel *yasi = [[HomeIndexModel alloc] initWithTitle:@"雅思提分" backgroudImageName:@"home_application_bg" destVC:[HomeYasiVC class] indexType:HomeIndexTypeYasi];
        HomeIndexModel *applicate = [[HomeIndexModel alloc] initWithTitle:@"留学申请" backgroudImageName:@"home_application_bg" destVC:[HomeApplicationVC class] indexType:HomeIndexTypeLXSQ];
        HomeIndexModel *fee = [[HomeIndexModel alloc] initWithTitle:@"学费支付" backgroudImageName:@"home_fee_bg" destVC:[HomeFeeVC class] indexType:HomeIndexTypeFee];
        HomeIndexModel *room = [[HomeIndexModel alloc] initWithTitle:@"海外租房" backgroudImageName:@"home_room_bg" destVC:[HomeFeeVC class] indexType:HomeIndexType51Room];
        HomeIndexModel *yx = [[HomeIndexModel alloc] initWithTitle:@"游学职培" backgroudImageName:@"home_YESGlobal_bg" destVC:[HomeFeeVC class] indexType:HomeIndexTypeYouXue];
        HomeIndexModel *ym = [[HomeIndexModel alloc] initWithTitle:@"海外移民" backgroudImageName:@"home_UVIC_bg" destVC:[HomeFeeVC class] indexType:HomeIndexTypeHYYM];

        _groups = @[recommend,yasi,applicate,fee,room,yx,ym];
    }
    
    return _groups;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
    
    [self makeOther];
}

- (void)makeUI{
    
    self.currentStatusBarStyle = UIStatusBarStyleDefault;
    [self makeChildViewController];
    [self makeCollectView];
    [self makeMenuView];
 }

- (void)makeMenuView{
    
    WeakSelf;
    NSArray *titles = [self.groups valueForKeyPath:@"title"];
    HomeMenuBarView *MenuView = [HomeMenuBarView menuInitWithTitles:titles clickButton:^(NSInteger index) {
        [weakSelf MenuScrollToIndex:index];
    }];
    MenuView.frame = CGRectMake(0, 0, XSCREEN_WIDTH, HOME_MENU_HEIGHT);
    self.MenuBarView = MenuView;
    [self.view addSubview:MenuView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MenuView initFirstResponse];
    });
 
}

- (void)makeChildViewController{
    
    
    NSMutableArray *children = [NSMutableArray array];
    for (HomeIndexModel *itemModel in self.groups) {
 
        UIViewController *vc  = [[itemModel.destVC  alloc] init];
        [children addObject:vc];
        [self addChildViewController:vc];

        if (![vc isKindOfClass:[HomeFeeVC class]]) continue;
        
        if (itemModel.type == HomeIndexTypeFee) {
        
            HomeFeeVC *fee  = (HomeFeeVC *)vc;
            fee.type = HomeLandingTypeMoney;
        }
 
        if (itemModel.type == HomeIndexType51Room) {
            
            HomeFeeVC *room  = (HomeFeeVC *)vc;
            room.type = HomeLandingTypeRoom;
        }
        
        if (itemModel.type == HomeIndexTypeYouXue) {
            
            HomeFeeVC *yes  =  (HomeFeeVC *)vc;
            yes.type = HomeLandingTypeYesGlobal;
        }
        
        if (itemModel.type == HomeIndexTypeHYYM) {
            
            HomeFeeVC *uvic  =  (HomeFeeVC *)vc;
            uvic.type = HomeLandingTypeUVIC;
        }
    }
    
    self.childViewControllersArray = children;
    
}

- (void)makeCollectView{
 
    CatigaryScrollView *bgView = [[CatigaryScrollView alloc] initWithFrame:self.view.bounds];
    bgView.delegate = self;
    bgView.pagingEnabled = YES;
    bgView.bounces = NO;
    bgView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:bgView];
    self.bgScrollView = bgView;
    bgView.contentSize = CGSizeMake(self.childViewControllersArray.count * XSCREEN_WIDTH, 0);
    
    if (self.childViewControllersArray.count > 0) {
        UIViewController *vc =  self.childViewControllersArray.firstObject;
        [bgView addSubview:vc.view];
    }
    [self makeBackgroupImageView:bgView];
 }

- (void)makeBackgroupImageView:(UIScrollView *)bgView{
 
    for (NSInteger index = 0; index < self.groups.count; index++) {
        
        HomeIndexModel *homeItem = self.groups[index];
       
        if (!homeItem.backgroudImageName) continue;
 
        NSString *icon = [NSString stringWithFormat:@"%@.jpg",homeItem.backgroudImageName];
        NSString *icon_b = [NSString stringWithFormat:@"%@_word",homeItem.backgroudImageName];
        
        UIView *itemView = [[UIView alloc] initWithFrame:self.view.bounds];
        itemView.clipsToBounds = YES;
        itemView.mj_x = index * bgView.mj_w;
        [bgView addSubview:itemView];
        
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:itemView.bounds];
        bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        [itemView addSubview:bgImageView];
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:icon ofType:nil];
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:imagePath];
        [bgImageView setImage:image];
 
        UIImage *icon_word = XImage(icon_b);
        UIImageView *word_iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, HOME_MENU_HEIGHT + 40, XSCREEN_WIDTH, XSCREEN_WIDTH * icon_word.size.height/icon_word.size.width)];
        word_iconView.image = icon_word;
        [itemView addSubview:word_iconView];
    }
 
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

//隐藏底部导航
- (void)toSetTabBarHidden:(NSInteger)page{
 
    if (page == 0){
        self.tabBarController.tabBar.hidden = NO;
        return;
    }
    UIViewController *vc = self.childViewControllersArray[page];
    
    HomeIndexModel *indexModel = self.groups[page];
    if (indexModel.type == HomeIndexTypeLXSQ) {
        HomeApplicationVC *application = (HomeApplicationVC *)vc;
        [application toSetTabBarhidden];
        
    }else if (indexModel.type == HomeIndexType51Room){
        HomeFeeVC *room = (HomeFeeVC *)vc;
        //        HomeRoomVC *room = (HomeRoomVC *)vc;
        [room toSetTabBarhidden];
        
    }else if (indexModel.type == HomeIndexTypeYasi){
        
//        HomeFeeVC *room = (HomeFeeVC *)vc;
//        [room toSetTabBarhidden];
        
    }else{
        
        HomeFeeVC *other = (HomeFeeVC *)vc;
        [other toSetTabBarhidden];
    }
}

//跳转到对应页面
- (void)toLoadViewControllerWithPage:(NSInteger)page{
  
    if (page == 0){
        self.tabBarController.tabBar.hidden = NO;
        return;
    }
    
    UIViewController *vc = self.childViewControllersArray[page];
    vc.view.frame = CGRectMake(page * XSCREEN_WIDTH, 0, XSCREEN_WIDTH, XSCREEN_HEIGHT);
    [self.bgScrollView addSubview:vc.view];
    
    HomeIndexModel *indexModel = self.groups[page];
    if (indexModel.type == HomeIndexTypeLXSQ) {
        HomeApplicationVC *application = (HomeApplicationVC *)vc;
        [application toLoadView];
        
    }else if (indexModel.type == HomeIndexType51Room){
        HomeFeeVC *room = (HomeFeeVC *)vc;
        //        HomeRoomVC *room = (HomeRoomVC *)vc;
        [room toLoadView];
        
    }else{
        
        HomeFeeVC *other = (HomeFeeVC *)vc;
        [other toLoadView];
    }

}

#pragma mark : 事件处理
//菜单栏切换
- (void)MenuScrollToIndex:(NSInteger)index{
    
    NSInteger from_index = (NSInteger)((self.bgScrollView.mj_offsetX / self.bgScrollView.mj_w) + 0.5);
    BOOL ani =  (abs((int)(from_index - index)) == 1);
    [self.bgScrollView setContentOffset:CGPointMake(index * XSCREEN_WIDTH, 0) animated:ani];
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

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/lookup?id=1016290891"]];
    //    request.timeoutInterval = 15;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 网络请求完成之后就会执行，NSURLSession自动实现多线程
        if (data && (error == nil)) {
            self.hadShowNeWVersion = YES;
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
            if (storeVersion.integerValue <= currentVersion.integerValue) return ;
            dispatch_async(dispatch_get_main_queue(), ^{
                [[MyofferUpdateView updateView] show];  //更新UI操作
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

