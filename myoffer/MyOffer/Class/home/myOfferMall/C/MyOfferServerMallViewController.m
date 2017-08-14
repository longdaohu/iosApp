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
#import "SDCycleScrollView.h"
#import "MyOfferAutoRunBanner.h"
#import "ServiceItemViewController.h"
#import "EmallCatigoryViewController.h"
#import "HomeSectionHeaderView.h"
#import "WebViewController.h"
#import "ServiceOverseaDestinationView.h"
#import "ServiceOverSeaDestination.h"
#import "SMListViewController.h"
#import "GroupModel.h"


@interface MyOfferServerMallViewController ()<UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) MyOfferService *sevice;
@property(nonatomic,strong)SDCycleScrollView *autoLoopView;
@property(nonatomic,strong)NSArray *groups;
@property(nonatomic,strong)NSArray *overSeaArr;
@property(nonatomic,strong)ServiceOverseaDestinationView *overseaView;
@property(nonatomic,strong)UIView *headerView;

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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"QQ_service"]  style:UIBarButtonItemStyleDone target:self action:@selector(caseQQ)];
    
}


- (ServiceOverseaDestinationView *)overseaView{

    if (!_overseaView) {
        XWeakSelf
        _overseaView = [ServiceOverseaDestinationView overseaView];
        _overseaView.actionBlock = ^(NSString *destination){
            
            [weakSelf casePushEmallCatigory:destination];
            
        };
        
         //4 留学目的地
        _overseaView.group = self.overSeaArr;
    }
    
    return _overseaView;
}


- (NSArray *)overSeaArr{

    if (!_overSeaArr) {
        
        ServiceOverSeaDestination *UK = [ServiceOverSeaDestination destinationWithImage:@"destination_UK" name:@"英国"];
        ServiceOverSeaDestination *AU = [ServiceOverSeaDestination destinationWithImage:@"destination_AU" name:@"澳大利亚"];
        ServiceOverSeaDestination *NZ = [ServiceOverSeaDestination destinationWithImage:@"destination_NZ" name:@"新西兰"];
        ServiceOverSeaDestination *HK = [ServiceOverSeaDestination destinationWithImage:@"destination_HK" name:@"香港"];
        
        _overSeaArr = @[UK,AU,NZ,HK];
    }
    return _overSeaArr;
}


- (UIView *)headerView{
    
    if (!_headerView) {
        
        _headerView = [[UIView alloc] init];
    }
    
    return _headerView;
}

/**
 *  创建轮播图头部
 */

- (SDCycleScrollView *)autoLoopView{

    if(!_autoLoopView){
    
        XWeakSelf
        
        SDCycleScrollView *autoLoopView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, AutoScroll_Height) delegate:nil placeholderImage:nil];
        
        autoLoopView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        autoLoopView.currentPageDotColor = XCOLOR_LIGHTBLUE;
        autoLoopView.clickItemOperationBlock = ^(NSInteger index) {
            
            [weakSelf  caseBannerWithIndex:index];
            
        };
        
        _autoLoopView = autoLoopView;

    }
    
    return _autoLoopView;
}



//网络请求
- (void)makeDataSource{
    
    XWeakSelf

    [self startAPIRequestWithSelector:kAPISelectorMyofferMall parameters:nil expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        [weakSelf updateUIWithResponse:response];
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        //加载失败退出页面
        [weakSelf dismiss];
    }];
    
    
}

//更新UI
- (void)updateUIWithResponse:(id)response{

    //1 数据模型
    self.sevice =  [MyOfferService mj_objectWithKeyValues:response];
    

    //2 留学目的地
    NSMutableArray *groups_temp = [NSMutableArray array];
    GroupModel *one = [GroupModel groupWithIndex:0 header:@"留学目的地" footer:@"" items:@[self.overSeaArr]];
    [groups_temp addObject:one];
    
    
    //3 热门商品
    NSMutableArray *items = [NSMutableArray array];
    for (ServiceSKU *item in self.sevice.skus) {
        
        ServiceSKUFrame *itemFrame = [[ServiceSKUFrame alloc] init];
        itemFrame.SKU = item;
        [items addObject:itemFrame];
    }
    
    if (items.count > 0) {
        
        GroupModel *two = [GroupModel  groupWithIndex:1 header:@"热门商品" footer:@"" items: [items copy]];
        [groups_temp addObject:two];
    }
    self.groups = [groups_temp copy];
    
  
    
    //5 轮播图匹配数据
    NSArray *images = [self.sevice.banners valueForKey:@"thumbnail"];
    if (images.count > 0) {
        
        self.headerView.frame = CGRectMake(0, 0, XSCREEN_WIDTH, AutoScroll_Height);
        self.tableView.tableHeaderView = self.headerView;
        [self.headerView addSubview:self.autoLoopView];
        self.autoLoopView.imageURLStringsGroup = images;
    }
 
    
    [self.tableView reloadData];
    
 
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    GroupModel *group = self.groups[section];
    
    return group.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    GroupModel *group = self.groups[indexPath.section];
    
    if (group.index == 0) {
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;

        [cell.contentView addSubview:self.overseaView];
        
        return cell;
    }

    
    ServiceSKUCell *cell = [ServiceSKUCell cellWithTableView:tableView indexPath:indexPath SKU_Frame:group.items[indexPath.row]];
    
    [cell bottomLineShow:(group.items.count - 1) != indexPath.row];
    
     return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section; {
    
    GroupModel *group = self.groups[section];
    
    HomeSectionHeaderView *SectionView =[HomeSectionHeaderView sectionHeaderViewWithTitle:group.header];
    
    SectionView.backgroundColor = XCOLOR_WHITE;
    
    return  SectionView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{

    GroupModel *group = self.groups[indexPath.section];
    
    CGFloat cell_Height = 0;
    
    if (group.index == 0) {
        
        cell_Height  = self.overseaView.mj_h;
        
    }else{
    
        ServiceSKUFrame *itemFrame = group.items[indexPath.row];
    
        cell_Height = itemFrame.cell_Height;
    }
 
    return  cell_Height;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return SECTION_HEADER_HIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return HEIGHT_ZERO;
}

- (void)tableView:(UITableView *)tableView  didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    GroupModel *group = self.groups[indexPath.section];

    if (0 == group.index) return;
    
    ServiceSKUFrame *itemFrame = group.items[indexPath.row];
    
    [self casePushServiceItemViewControllerWithId: itemFrame.SKU.service_id];
    
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
