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

@interface MyOfferServerMallViewController ()<UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) MyOfferService *sevice;
@property(nonatomic,strong) NSArray *SKU_frames;
@property(nonatomic,strong)SDCycleScrollView *autoLoopView;
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
    
    CGRect headerRect = CGRectMake(0, 0, XSCREEN_WIDTH, AdjustF(160.f) + AdjustF(100.f));
    
    XWeakSelf
 
    ServiceHeaderView *headerView = [ServiceHeaderView headerViewWithFrame:headerRect ationBlock:^(NSString *country) {
        
        [weakSelf casePushEmallCatigory:country];
        
    }];
    
    
    self.tableView.tableHeaderView = headerView;
    
    [self makeAutoLoopViewAtView:headerView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"QQService"]  style:UIBarButtonItemStyleDone target:self action:@selector(caseQQ)];
 
}


/**
 *  创建轮播图头部
 */
- (void)makeAutoLoopViewAtView:(UIView *)bgView{
    
    XWeakSelf
    CGFloat autoY =  0;
    CGFloat autoX =  0;
    CGFloat autoH =  AdjustF(160.f);
    CGFloat autoW =  XSCREEN_WIDTH;
    SDCycleScrollView *autoLoopView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(autoX , autoY, autoW,autoH) delegate:nil placeholderImage:nil];
    self.autoLoopView = autoLoopView;
    autoLoopView.alpha = 0;
    autoLoopView.placeholderImage =   [UIImage imageNamed:@"PlaceHolderImage"];
    autoLoopView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    autoLoopView.currentPageDotColor = XCOLOR_RED;
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
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        
        [self webViewWithpath:@"mqq://im/chat?chat_type=wpa&uin=3062202216&version=1&src_type=web"];
        
        return ;
    }
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"联系客服前请先下载QQ，是否需要下载QQ？"  message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *commitAction = [UIAlertAction actionWithTitle:@"下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //跳转到QQ下载页面
        [self webViewWithpath:@"http://appstore.com/qq"];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:commitAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}


- (void)webViewWithpath:(NSString *)path{
    
    UIWebView *webView    = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
    [webView loadRequest:request];
    [self.view addSubview:webView];
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
