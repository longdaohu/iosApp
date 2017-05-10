//
//  MyOfferServerMallViewController.m
//  myOffer
//
//  Created by xuewuguojie on 2017/3/27.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "MyOfferServerMallViewController.h"
#import "MyOfferService.h"
#import "ServiceSKU.h"
#import "ServiceSKUCell.h"
#import "ServiceHeaderView.h"
#import "SDCycleScrollView.h"
#import "MyOfferAutoRunBanner.h"
#import "ServiceItemViewController.h"
#import "EmallCatigoryViewController.h"
#import "HomeSectionHeaderView.h"
#import "WebViewController.h"
#import "MyOfferServiceMallHeaderFrame.h"


@interface MyOfferServerMallViewController ()<UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) MyOfferService *sevice;
@property(nonatomic,strong) NSArray *SKU_frames;
@property(nonatomic,strong)SDCycleScrollView *autoLoopView;
@property(nonatomic,strong)MyOfferServiceMallHeaderFrame *headerFrame;

@end

@implementation MyOfferServerMallViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
    
    [self makeDataSource];
}

- (void)makeUI{
    
    self.title = @"留学购";
    
 
    
    XWeakSelf
 
    ServiceHeaderView *headerView = [ServiceHeaderView headerViewWithFrame:self.headerFrame.header_frame ationBlock:^(NSString *country) {
        
        [weakSelf casePushEmallCatigory:country];
        
    }];
    
    headerView.headerFrame = self.headerFrame;
    
    self.tableView.tableHeaderView = headerView;
    
    [self makeAutoLoopViewAtView:headerView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"QQService"]  style:UIBarButtonItemStyleDone target:self action:@selector(caseQQ)];
 
}

- (MyOfferServiceMallHeaderFrame *)headerFrame{
    
    if (!_headerFrame) {
        
        _headerFrame = [[MyOfferServiceMallHeaderFrame alloc] init];
    }
    
    return _headerFrame;
}

/**
 *  创建轮播图头部
 */
- (void)makeAutoLoopViewAtView:(UIView *)bgView{
    
    XWeakSelf
    
    SDCycleScrollView *autoLoopView = [SDCycleScrollView cycleScrollViewWithFrame:self.headerFrame.autoScroller_frame delegate:nil placeholderImage:nil];
    self.autoLoopView = autoLoopView;
    autoLoopView.alpha = 0;
    autoLoopView.placeholderImage =   [UIImage imageNamed:@"PlaceHolderImage"];
    autoLoopView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    autoLoopView.currentPageDotColor = XCOLOR_LIGHTBLUE;
    [bgView addSubview:autoLoopView];
    autoLoopView.clickItemOperationBlock = ^(NSInteger index) {
        
        [weakSelf  caseBannerWithIndex:index];
        
    };
}



- (void)makeDataSource{
    
    XWeakSelf

    [self startAPIRequestWithSelector:kAPISelectorMyofferMall parameters:nil expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        [weakSelf updateUIWithResponse:response];
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        
        //加载失败退出页面
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    
}

//更新UI
- (void)updateUIWithResponse:(id)response{

    if (!response)  return ;
     
    
    self.sevice =  [MyOfferService mj_objectWithKeyValues:response];
    NSMutableArray *items = [NSMutableArray array];
    for (ServiceSKU *item in self.sevice.skus) {
        
        ServiceSKUFrame *itemFrame = [[ServiceSKUFrame alloc] init];
        itemFrame.SKU = item;
        [items addObject:itemFrame];
    }
    
    self.SKU_frames  =  [items copy];
    
    //轮播图匹配数据
//    self.autoLoopView.titlesGroup = [self.sevice.banners valueForKey:@"title"];
    self.autoLoopView.imageURLStringsGroup = [self.sevice.banners valueForKey:@"thumbnail"];
    
    
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        
        self.autoLoopView.alpha = 1;
    }];
    
    
    [self.tableView reloadData];
 
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.sevice.skus.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ServiceSKUCell *cell = [ServiceSKUCell cellWithTableView:tableView indexPath:indexPath SKU_Frame:self.SKU_frames[indexPath.row]];
    
     return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{

    ServiceSKUFrame *itemFrame = self.SKU_frames[indexPath.row];

    return itemFrame.cell_Height;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return HEIGHT_ZERO;
}

- (void)tableView:(UITableView *)tableView  didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    ServiceSKUFrame *itemFrame = self.SKU_frames[indexPath.row];
    
    [self casePushServiceItemViewControllerWithId: itemFrame.SKU.service_id];
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section; {
    
    HomeSectionHeaderView *SectionView =[HomeSectionHeaderView sectionHeaderViewWithTitle:@"热门商品"];
   
    return  SectionView;
}



#pragma mark : 事件处理

- (void)casePushEmallCatigory:(NSString *)countryName{
    
    
    EmallCatigoryViewController *country =  [[EmallCatigoryViewController alloc] init];
    
    country.country_Name = countryName;
    
    [self.navigationController pushViewController:country animated:true];
}

- (void)caseBannerWithIndex:(NSInteger)index{

    MyOfferAutoRunBanner   *banner  =   self.sevice.banners[index];
 
    NSString *appStr = @"app://";
    
    //url 包含 app://跳转 ServiceItemViewController
    
    if ([banner.url containsString:@"app://"]) {
        
        NSString *item = [banner.url substringWithRange:NSMakeRange(appStr.length, banner.url.length - appStr.length)];
        
        item.length > 0 ?  [self casePushServiceItemViewControllerWithId:item] : nil;
        
        return;
    }
    
    //url 包含 app://跳转 WebViewController
    WebViewController *web = [[WebViewController alloc] initWithPath:banner.url];
    
    [self.navigationController  pushViewController:web animated:true];
   
   
}


//跳转到QQ客服聊天页面

-(void)caseQQ
{
    QQserviceSingleView *service = [[QQserviceSingleView alloc] init];
    [service call];
    
}
 

- (void)casePushServiceItemViewControllerWithId:(NSString *)service_id
{
    ServiceItemViewController *item = [[ServiceItemViewController alloc] init];
    item.service_id = service_id;
    [self.navigationController pushViewController:item animated:true];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)dealloc{
    
    KDClassLog(@"dealloc 留学购");
 }


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
