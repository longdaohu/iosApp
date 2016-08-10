//
//  DiscoverViewController.m
//  MyOffer
//
//  Created by Blankwonder on 6/7/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#define ADKEY @"ADedddddeddd"

#import "DiscoverViewController.h"
#import "DiscoveryCell.h"
#import "SearchViewController.h"
#import <AdSupport/AdSupport.h>
#import "NSString+MD5.h"

@interface DiscoverViewController  (){
    BOOL _searchBarExpanded;
    CGFloat _dragStartContentOffsetY;
    NSArray *_items;
    NSMutableArray *_cells;
}
@property(nonatomic,assign) NSInteger count;
@property(nonatomic,strong)MJRefreshGifHeader *header;
@property (weak, nonatomic) IBOutlet UIView *topView;



@end

#define kCellIdentifier NSStringFromClass([DiscoveryCell class])

@implementation DiscoverViewController




-(void)makeUI
{
    _searchBarTextField.placeholder = GDLocalizedString(@"Discover_search");
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, self.tabBarController.tabBar.frame.size.height, 0);
    
     //    _searchBar.layer.borderWidth = 2;
    //    _searchBar.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.1].CGColor;
    _searchBar.layer.masksToBounds = NO;
    _searchBar.layer.shadowColor = [UIColor blackColor].CGColor;
    _searchBar.layer.shadowOffset = CGSizeMake(1, 1);
    _searchBar.layer.shadowRadius = 1;
    _searchBar.layer.shadowOpacity = 0.2;
    
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(xloadNewData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.header = header;
 
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
    self.tableView.mj_header = header;
    
    
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    [self makeUI];
    
    [self getSelectionSourse];
    
    [self firstTimeLoadData];
    
    [self getAppReport];
    
      //--判断用户是否完成任务--
     if(![[NSUserDefaults standardUserDefaults] boolForKey:ADKEY]){
         
        [self advanceSupportWithDuration:180];
     }
    
 
    
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page发现院校"];
    
}




- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"page发现院校"];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    
    [self setSearchBarExpanded:YES animated:NO];

    [self UserLanguage];
}


//--用户语言环境通知服务器----
-(void)UserLanguage
{
     if ([[AppDelegate sharedDelegate] isLogin]) {
        
         NSString *lang =USER_EN?@"en":@"zh-cn";
        [self startAPIRequestWithSelector:kAPISelectorUserLanguage parameters:[NSDictionary dictionaryWithObject:lang forKey:@"language"] success:^(NSInteger statusCode, id response) {
            
        }];
    }
}

//请求数据源
-(void)getDataSource:(BOOL)refresh
{
     XJHUtilDefineWeakSelfRef
    [self startAPIRequestWithSelector:kAPISelectorHomepage
                           parameters:nil expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:^{
                           
                           } additionalSuccessAction:^(NSInteger statusCode, id response) {
  
                               
                               NSArray *responseArray = (id)response;

                               _items = responseArray;
                               
                               [_tableView reloadData];
                               
                               [weakSelf.header endRefreshing];
                               
                           } additionalFailureAction:^(NSInteger statusCode, NSError *error) {

 
                                   [weakSelf.header endRefreshing];
                                   
                            }];

}

//第一次网络请求（有缓存）
-(void)firstTimeLoadData
{
         [self startAPIRequestUsingCacheWithSelector:kAPISelectorHomepage parameters:nil success:^(NSInteger statusCode, NSArray *response) {
            NSArray *responseArray = (id)response;
    
             _items = responseArray;

            [_tableView reloadData];
         }];
}

//请求新数据
-(void)xloadNewData
{
    [[KDImageCache sharedInstance] cleanAllDiskCache];
    
     [self getDataSource:YES];
}



- (void)setSearchBarExpanded:(BOOL)expanded animated:(BOOL)animated {
    if (_searchBarExpanded == expanded) return;
    _searchBarExpanded = expanded;
    void (^action)() = ^{
        if (expanded) {
            _searchBarTextField.alpha = 1;
            _searchBarWidth.constant = self.view.frame.size.width - 80.0;
            _searchBarTextFieldWidth.constant = _searchBarWidth.constant - 71.0 + 10.0;
        } else {
            _searchBarTextField.alpha = 0;
            _searchBarWidth.constant = 45.0;
        }
        [self.view layoutIfNeeded];
    };
    
    [self.view layoutIfNeeded];
    if (animated) {
        [UIView animateWithDuration:0.5 animations:action];
    } else {
        action();
    }
    
    if (!expanded) {
        
        [_searchBarTextField resignFirstResponder];
    }
    
    if (animated) {
        if (!expanded) {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
            animation.duration = 0.5;
            animation.fromValue = @(5.0f);
            animation.toValue = @(45.0f / 2.0f);
            animation.removedOnCompletion = NO;
            animation.fillMode = kCAFillModeForwards;
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            
            [_searchBar.layer addAnimation:animation forKey:@"animation"];
        } else {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
            animation.duration = 0.5;
            animation.toValue = @(5.0f);
            animation.fromValue = @(45.0f / 2.0f);
            animation.removedOnCompletion = NO;
            animation.fillMode = kCAFillModeForwards;
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            
            [_searchBar.layer addAnimation:animation forKey:@"animation"];
        }
    } else {
        _searchBar.layer.cornerRadius = expanded ? 5 : 45.0 / 2.0;
    }
}

//点击搜索按钮
- (IBAction)searchButtonPressed {
    
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    XWGJNavigationController *nav = [[XWGJNavigationController alloc] initWithRootViewController:searchVC];
    [self presentViewController:nav animated:YES completion:nil];
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.header.gifView.transform = CGAffineTransformMakeScale(0.2, 0.2);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
     if (scrollView.contentOffset.y >= - 100 && scrollView.contentOffset.y <= 0) {
        CGFloat Gscale =0.2 + 0.5 * ABS(scrollView.contentOffset.y)/ 100.0;
        self.header.gifView.transform = CGAffineTransformMakeScale(Gscale, Gscale);
    }
  
    
    if (self.header.isRefreshing) {
        
       self.topView.alpha = 0 ;
        
    }
        
            CGFloat topViewAlpha = 5 * ( 64 + scrollView.contentOffset.y )/ 64.0;
            
             self.topView.alpha = topViewAlpha ;
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    DiscoveryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiscoveryCell"];
    if(!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:kCellIdentifier owner:nil options:nil].firstObject;

    }
    
    NSDictionary *info = _items[indexPath.row];
    
    [[KDImageCache sharedInstance]
     loadImageWithURL:info[@"image"]
     completion:^(UIImage *image, NSString *imageURL) {
         if (image) {
             cell.backgroundImageView.image = image;
         }
     }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        return 122 * APPSIZE.width / 320.0;
    }else {
        return 213 * APPSIZE.width / 320.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    NSDictionary *info = _items[indexPath.row];
    
    if (info[@"university"]) {
        
        [self.navigationController pushUniversityViewControllerWithID:info[@"university"] animated:YES];
        
    } else if (info[@"search"])  {
        
        
        SearchResultViewController *vc = [[SearchResultViewController alloc] initWithSearchText:info[@"search"] orderBy:RANKTI];
        
        [self.navigationController pushViewController:vc animated:YES];

    }
    
    

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


//--提前加载数据，存储在本地，下次调用--
-(void)getSelectionSourse
{
    NSUserDefaults *ud  = [NSUserDefaults  standardUserDefaults];
    
    [self startAPIRequestUsingCacheWithSelector:kAPISelectorGrades parameters:@{@":lang":@"zh-cn"} success:^(NSInteger statusCode, NSArray * response) {
        
        
        [ud setValue:response forKey:@"Grade_CN"];
        
    }];
    
    
    [self startAPIRequestUsingCacheWithSelector:kAPISelectorGrades parameters:@{@":lang":@"en"} success:^(NSInteger statusCode, NSArray * response) {
        
        [ud setValue:response forKey:@"Grade_EN"];
        
    }];
    
    
    [self startAPIRequestUsingCacheWithSelector:kAPISelectorSubjects parameters:@{@":lang":@"zh-cn"} success:^(NSInteger statusCode, NSArray * response) {
        [ud setValue:response forKey:@"Subject_CN"];
        
        
    }];
    
    [self startAPIRequestUsingCacheWithSelector:kAPISelectorSubjects parameters:@{@":lang":@"en"} success:^(NSInteger statusCode, NSArray * response) {
        
        [ud setValue:response forKey:@"Subject_EN"];
        
    }];
    
    
    [self startAPIRequestUsingCacheWithSelector:kAPISelectorCountries parameters:@{@":lang":@"en"} success:^(NSInteger statusCode, NSArray * response) {
        
        [ud setValue:response forKey:@"Country_EN"];
        
    }];
    
    [self startAPIRequestUsingCacheWithSelector:kAPISelectorCountries parameters:@{@":lang":@"zh-cn"} success:^(NSInteger statusCode, NSArray * response) {
        
        [ud setValue:response forKey:@"Country_CN"];
        
    }];
    
    
    [ud synchronize];
    
}

 


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
