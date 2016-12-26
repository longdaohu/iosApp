//
//  MassageViewController.m
//  myOffer
//
//  Created by xuewuguojie on 16/1/14.
//  Copyright © 2016年 UVIC. All rights reserved.
//
#define REQUEST_SIZE 10
#import "MessageViewController.h"
#import "MessageCell.h"
#import "XWGJMessageButtonItemView.h"
#import "XWGJMessageCategoryItem.h"
#import "MessageDetaillViewController.h"
#import "XWGJMessageFrame.h"
#import "SDCycleScrollView.h"
#import "YYSingleNewsBO.h"
#import "XWGJNODATASHOWView.h"
#import "XUToolbar.h"
#import "NewsItem.h"

@interface MessageViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
//分区头数据
@property(nonatomic,strong)NSMutableArray *RequestKeys;
//推荐资讯
@property(nonatomic,strong)NSArray *banner;
//生活资讯数据源
@property(nonatomic,strong)NSMutableArray *Category_LifeArr;
//申请资讯数据源
@property(nonatomic,strong)NSMutableArray *Category_RequestArr;
//费用数据源
@property(nonatomic,strong)NSMutableArray *Category_FeeArr;
//考试资讯数据源
@property(nonatomic,strong)NSMutableArray *Category_TestArr;
//新闻资讯数据源
@property(nonatomic,strong)NSMutableArray *Category_NewsArr;
//签证数据源
@property(nonatomic,strong)NSMutableArray *Category_VisaArr;
//当前tableView数据源
@property(nonatomic,strong)NSArray *CurrentArr;
@property(nonatomic,assign)NSInteger currentIndex;
//分区选项
@property(nonatomic,strong)XWGJMessageButtonItemView *sectionHeaderView;
//表头轮播图
@property(nonatomic,strong)SDCycleScrollView *autoLoopView;
//状态栏遮盖
@property(nonatomic,strong)UIView *StatusBarBan;
//自定义ToolBar
@property(nonatomic,strong)XUToolbar *myToolbar;
//无数据提示框
@property(nonatomic,strong)XWGJNODATASHOWView *NODATA;
//是否有新消息图标
@property(nonatomic,strong)LeftBarButtonItemView *leftView;


@end

@implementation MessageViewController

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    self.tabBarController.tabBar.hidden = NO;
    
    [MobClick beginLogPageView:@"page资讯宝典"];
    
    [self leftViewMessage];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page资讯宝典"];
}


 
//数据为空时出现
-(XWGJNODATASHOWView *)NODATA
{
    if (!_NODATA) {
        
        XWeakSelf
        
        _NODATA =[[XWGJNODATASHOWView alloc] initWithFrame:self.view.bounds];
        
        _NODATA.hidden = YES;
        
        [self.view addSubview:_NODATA];
        
         _NODATA.ActionBlock = ^{
             
             [weakSelf  getDataSource:0 andFresh:0];
             
             [weakSelf  getAutoLoopViewData];
        };
        
    }
    return _NODATA;
}

-(XUToolbar *)myToolbar
{
    if (!_myToolbar) {
        
        _myToolbar =[[XUToolbar  alloc] initWithFrame:CGRectMake(0, 20, XSCREEN_WIDTH, 44)];
        
        [self.view addSubview:_myToolbar];
    }
    return _myToolbar;
}
-(NSMutableArray *)Category_LifeArr
{
    if (!_Category_LifeArr) {
        
        _Category_LifeArr = [NSMutableArray array];
    }
    return _Category_LifeArr;
}


-(NSMutableArray *)Category_RequestArr
{
    if (!_Category_RequestArr) {
        
        _Category_RequestArr = [NSMutableArray array];
    }
    return _Category_RequestArr;
}

-(NSMutableArray *)Category_FeeArr
{
    if (!_Category_FeeArr) {
        
        _Category_FeeArr = [NSMutableArray array];
    }
    return _Category_FeeArr;
}

-(NSMutableArray *)Category_NewsArr
{
    if (!_Category_NewsArr) {
        
        _Category_NewsArr = [NSMutableArray array];
    }
    return _Category_NewsArr;
}

-(NSMutableArray *)Category_TestArr
{
    if (!_Category_TestArr) {
        
        _Category_TestArr = [NSMutableArray array];
    }
    return _Category_TestArr;
}
-(NSMutableArray *)Category_VisaArr
{
    if (!_Category_VisaArr) {
        
        _Category_VisaArr = [NSMutableArray array];
    }
    return _Category_VisaArr;
}



//分区头数据
-(NSMutableArray *)RequestKeys
{
    if (!_RequestKeys) {
        
        _RequestKeys = [NSMutableArray array];
        XWGJMessageCategoryItem *life = [XWGJMessageCategoryItem CreateCategoryItemWithTitle:@"留学生活" andLastPage:0];
        XWGJMessageCategoryItem *request = [XWGJMessageCategoryItem CreateCategoryItemWithTitle:@"留学申请" andLastPage:0];
        XWGJMessageCategoryItem *fee  = [XWGJMessageCategoryItem CreateCategoryItemWithTitle:@"留学费用" andLastPage:0];
        XWGJMessageCategoryItem *test = [XWGJMessageCategoryItem CreateCategoryItemWithTitle:@"留学考试" andLastPage:0];
        XWGJMessageCategoryItem *news = [XWGJMessageCategoryItem CreateCategoryItemWithTitle:@"留学新闻" andLastPage:0];
        XWGJMessageCategoryItem *visa = [XWGJMessageCategoryItem CreateCategoryItemWithTitle:@"留学签证" andLastPage:0];
        [_RequestKeys addObject:life];
        [_RequestKeys addObject:request];
        [_RequestKeys addObject:fee];
        [_RequestKeys addObject:test];
        [_RequestKeys addObject:news];
        [_RequestKeys addObject:visa];
    }
    return _RequestKeys;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
    //第一次加载
    [self getDataSource:0 andFresh:NO];
    
    [self getAutoLoopViewData];
    
}

-(void)makeOtherView
{
    UIImageView *maskBgView =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, 64)];
    maskBgView.image = [UIImage imageNamed:@"gradient_up"];
    [self.view addSubview:maskBgView];
    
    
    self.StatusBarBan =[[UIView alloc] initWithFrame:CGRectMake(0, 0,XSCREEN_WIDTH, 20)];
    self.StatusBarBan.backgroundColor = XCOLOR_LIGHTBLUE;
    self.StatusBarBan.alpha = 0;
    [self.view addSubview:self.StatusBarBan];
   
    XWeakSelf
    self.leftView =[LeftBarButtonItemView leftViewWithBlock:^{
        [weakSelf showLeftMenu];

    }];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]  initWithCustomView:self.leftView];
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.myToolbar.items= @[leftItem,flexItem];
}

-(void)makeTableView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, XSCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    self.tableView.hidden     = YES;
    self.tableView.backgroundColor = XCOLOR_BG;
    self.tableView.tableFooterView =[[UIView alloc] init];
    self.tableView.mj_footer       = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.view addSubview:self.tableView];
    [self makeAutoLoopViewAtView];
    [self makeRefreshView];
}

//设置下拉刷新
-(void)makeRefreshView
{
 
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(getAutoLoopViewData)];
    //    header.lastUpdatedTimeLabel.hidden = YES;
    //    header.stateLabel.hidden = YES;
    self.tableView.mj_header = header;
    header.gifView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    
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
}




-(void)makeUI
{
    self.currentIndex = 0;

    [self makeTableView];
    
    [self makeOtherView];

}


/**
 *  创建轮播图头部
 */
- (void)makeAutoLoopViewAtView{
    
    XWeakSelf
    CGFloat autoY =  0;
    CGFloat autoH =  AdjustF(200.f);
    CGFloat autoX =  0;
    CGFloat autoW =  XSCREEN_WIDTH;
    SDCycleScrollView *autoLoopView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(autoX , autoY, autoW,autoH) delegate:nil placeholderImage:nil];
    autoLoopView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    //  autoLoopView.titlesGroup = titles;
    autoLoopView.currentPageDotColor = XCOLOR_RED;
    self.autoLoopView = autoLoopView;
    self.tableView.tableHeaderView = autoLoopView;
    autoLoopView.clickItemOperationBlock = ^(NSInteger index) {
        
        YYSingleNewsBO  *item  = weakSelf.banner[index];
        [weakSelf.navigationController pushViewController:[[MessageDetaillViewController alloc] initWithMessageId:item.newsId] animated:YES];
        
    };
}


- (void)getAutoLoopViewData{

 
     XWeakSelf
    
    [self
     startAPIRequestWithSelector:kAPISelectorArticleRecommendation
     parameters:nil
     expectedStatusCodes:nil
     showHUD:NO
     showErrorAlert:YES
     errorAlertDismissAction:nil
     additionalSuccessAction:^(NSInteger statusCode, id response) {
         
         NSMutableArray *banner = [NSMutableArray array];
         NSArray *banner_temps = (NSArray *)response;
         [banner_temps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             YYSingleNewsBO *new = [[YYSingleNewsBO alloc] init];
             new.message = banner_temps[idx];
             new.index = idx;
             [banner addObject:new];
         }];
         
         weakSelf.banner = [banner copy];
         weakSelf.autoLoopView.titlesGroup = [weakSelf.banner valueForKey:@"newsTitle"];
         weakSelf.autoLoopView.imageURLStringsGroup = [weakSelf.banner valueForKey:@"imageUrl"];
         [weakSelf.tableView.mj_header endRefreshing];

     } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
         
         [weakSelf.tableView.mj_header endRefreshing];

     }];

}


//请求数据
-(void)getDataSource:(NSInteger)index andFresh:(BOOL)fresh
{
 
    switch (index) {
            
        case 0:{
            if (!fresh && self.Category_LifeArr.count > 0) {
                
                self.CurrentArr = [self.Category_LifeArr copy];
                
                [self.tableView reloadData];
                
                return;
            }
        }
            break;
 
        case 1:{
            if (!fresh &&self.Category_RequestArr.count > 0) {
                
                self.CurrentArr = [self.Category_RequestArr copy];
                
                [self.tableView reloadData];
                
                return;
            }
            
        }
            break;
        case 2:{
            
            if (!fresh && self.Category_FeeArr.count > 0) {
                
                self.CurrentArr = [self.Category_FeeArr copy];
                
                [self.tableView reloadData];
                
                return;
            }
          }
            break;
        case 3:{
            
            if (!fresh && self.Category_TestArr.count > 0) {
                
                self.CurrentArr = [self.Category_TestArr copy];
                
                [self.tableView reloadData];
                
                return;
            }
         }
            break;
        case 4:{
            if (!fresh && self.Category_NewsArr.count > 0) {
                
                self.CurrentArr = [self.Category_NewsArr copy];
                
                [self.tableView reloadData];
                
                return;
            }
         }
            break;
        case 5:{
            
            if (!fresh && self.Category_VisaArr.count > 0) {
                
                self.CurrentArr = [self.Category_VisaArr copy];
                
                [self.tableView reloadData];
                
                return;
            }
         }
            break;
    }
  
    __block XWGJMessageCategoryItem *category = self.RequestKeys[index];

    
    NSString *keyWord = [category.titleName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *path =[NSString stringWithFormat:@"%@category=%@&page=%ld&size=%d",kAPISelectorArticleCategory,keyWord,(long)category.LastPage,REQUEST_SIZE];
    
     XWeakSelf
    
    [self startAPIRequestWithSelector:path
     
                           parameters:nil expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:^{
                               
                           } additionalSuccessAction:^(NSInteger statusCode, id response) {
                               ++category.LastPage;
                               
                                       switch (index) {
                                               
                                           case 0:{
                                               
                                                 for(NSDictionary *MessageDic in response[@"articles"])
                                               {
                                                   
                                                   XWGJMessageFrame *messageFrame = [self getMessgeFrameWithDictionory:MessageDic];
                                                   
                                                   [weakSelf.Category_LifeArr  addObject:messageFrame];
                                                   
                                               }
                                               
                                               weakSelf.CurrentArr = [weakSelf.Category_LifeArr copy];
                               
                               
                                           }
                                               break;
                                           case 1:{
                                               for(NSDictionary *MessageDic in response[@"articles"])
                                               {
                                                   XWGJMessageFrame *messageFrame = [self getMessgeFrameWithDictionory:MessageDic];

                                                   [weakSelf.Category_RequestArr  addObject:messageFrame];
                                                }
                                               weakSelf.CurrentArr = [weakSelf.Category_RequestArr copy];

                                           }
                                               
                                               break;
                                           case 2:{
                                                for(NSDictionary *MessageDic in response[@"articles"])
                                               {
                                                   XWGJMessageFrame *messageFrame = [self getMessgeFrameWithDictionory:MessageDic];

                                                   [weakSelf.Category_FeeArr  addObject:messageFrame];
                                               }
                                               weakSelf.CurrentArr = [self.Category_FeeArr copy];
                                           }
                                               break;
                                           case 3:{
                                               for(NSDictionary *MessageDic in response[@"articles"])
                                               {
                                                   XWGJMessageFrame *messageFrame = [self getMessgeFrameWithDictionory:MessageDic];

                                                   [weakSelf.Category_TestArr  addObject:messageFrame];
                                                }
                                                weakSelf.CurrentArr = [self.Category_TestArr copy];
                                           }
                                               break;
                                           case 4:{
                                               for(NSDictionary *MessageDic in response[@"articles"])
                                               {
                                                   XWGJMessageFrame *messageFrame = [self getMessgeFrameWithDictionory:MessageDic];

                                                   [weakSelf.Category_NewsArr  addObject:messageFrame];
                                                }
                                               weakSelf.CurrentArr = [self.Category_NewsArr copy];
                                           }
                                               break;
                                           case 5:{
                                               for(NSDictionary *MessageDic in response[@"articles"])
                                               {
                                                    XWGJMessageFrame *messageFrame = [self getMessgeFrameWithDictionory:MessageDic];
                                                   
                                                    [weakSelf.Category_VisaArr  addObject:messageFrame];
                                                }
                                               
                                                weakSelf.CurrentArr = [self.Category_VisaArr copy];
                                           }
                                               break;
                                        }
                                       
                               
                               [self.tableView.mj_footer endRefreshing];
                               
                               if ([response[@"articles"] count] < REQUEST_SIZE) {
                                   
                                   [self.tableView.mj_footer endRefreshingWithNoMoreData];
  
                                   category.IsNoMoreState = YES;
                               }
                               

                               [weakSelf.tableView reloadData];
                             
                               self.tableView.hidden = NO;
                               
                               self.NODATA.hidden = YES;
                               
                           } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
                               
                               [self.tableView.mj_footer endRefreshing];
                              
                               if (self.CurrentArr.count == 0) {
                                   
                                   self.NODATA.hidden = NO;
                                   
                                   self.tableView.hidden = YES;
                               }
                               
                           }];

}

- (XWGJMessageFrame *)getMessgeFrameWithDictionory:(NSDictionary *)MessageDic{
 
    NewsItem  *item                =  [NewsItem mj_objectWithKeyValues:MessageDic];
    XWGJMessageFrame *messageFrame =  [XWGJMessageFrame messageFrameWithMessage:item];
    
    return  messageFrame;
}

//自定义分区头
-(XWGJMessageButtonItemView *)sectionHeaderView
{
    if(!_sectionHeaderView)
    {
        XWeakSelf
        
        _sectionHeaderView = [[XWGJMessageButtonItemView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, 120)];
        
        _sectionHeaderView.ActionBlock = ^(UIButton *sender){
            
            [weakSelf getDataSource:sender.tag andFresh:NO];
            
            weakSelf.currentIndex = sender.tag;
            
            XWGJMessageCategoryItem *category = weakSelf.RequestKeys[sender.tag];
            //用于判断该选项是否已经加载完数据
            if (category.IsNoMoreState) {
                
                weakSelf.tableView.mj_footer.state = MJRefreshStateNoMoreData;
                
            }else{
                [weakSelf.tableView.mj_footer resetNoMoreData];
            }
            
            if (weakSelf.tableView.contentOffset.y > AdjustF(200.f)) {
                
                weakSelf.tableView.contentOffset = CGPointMake(0, AdjustF(200.f));
                
            }
        };
        
    }
    return _sectionHeaderView;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView.contentOffset.y < -150) [self.tableView setContentOffset:CGPointMake(0, -150) animated:NO];
      
    if (scrollView == self.tableView){
        
         self.StatusBarBan.alpha =  scrollView.contentOffset.y / AdjustF(200.f);
        
        self.myToolbar.alpha    = 1 - self.StatusBarBan.alpha  * 3;
        
        scrollView.contentInset =  (scrollView.contentOffset.y >= (AdjustF(200.f) - 64)) ? UIEdgeInsetsMake(20, 0, 0, 0) :  UIEdgeInsetsZero;
    
        
    }
}


- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
 
    scrollView.contentInset =  UIEdgeInsetsZero;
    
    return YES;
}

#pragma mark ——— UITableViewDelegate  UITableViewDataSoure
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return Uni_Cell_Height;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return self.sectionHeaderView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    return Uni_Cell_Height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.CurrentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell *cell =[MessageCell cellWithTableView:tableView];
    cell.messageFrame = self.CurrentArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XWGJMessageFrame  *messageFrame     = self.CurrentArr[indexPath.row];
 
    [self.navigationController pushViewController:[[MessageDetaillViewController alloc] initWithMessageId:messageFrame.News.messageID] animated:YES];
  
}

#pragma mark - ParallaxHeaderViewDelegate
- (void)lockScrollView:(CGFloat)maxOffset {
    
    [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x, maxOffset) animated:NO];
}

//加载更多
-(void)loadMoreData{
    
     [self getDataSource:self.currentIndex andFresh:YES];
    
}

//导航栏 leftBarButtonItem
-(void)leftViewMessage{
    
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
//显示侧边菜单
-(void)showLeftMenu
{
    
    [self.sideMenuViewController presentLeftMenuViewController];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
