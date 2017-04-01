//
//  EmallCatigoryViewController.m
//  myOffer
//
//  Created by xuewuguojie on 2017/3/27.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "EmallCatigoryViewController.h"
#import "ServiceSKU.h"
#import "ServiceSKUFrame.h"
#import "ServiceSKUCell.h"
#import "ServiceItemViewController.h"
#import "UniversityNavView.h"
#import "EmallCatigroyHeaderView.h"
#import "EmallCatigoryGroup.h"
#import "EmallCatigroySectionView.h"

@interface EmallCatigoryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)UITableView *tableView;
@property(nonatomic,strong)UniversityNavView *topNavigationView;
@property(nonatomic,strong)NSArray *groups;
@property(nonatomic,copy)NSString *current_Service;
@property(nonatomic,strong)NSArray *current_frames;
@property(nonatomic,strong)UIImageView *flexView;
@property(nonatomic,assign)CGRect flexFrame;
@property(nonatomic,assign)CGPoint flexCenter;
@property(nonatomic,strong)EmallCatigroySectionView *banView;
@property(nonatomic,assign)CGRect banViewFrame;


@end

@implementation EmallCatigoryViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}

- (NSArray *)groups{

    if (!_groups) {
    
        EmallCatigoryGroup *request  = [EmallCatigoryGroup groupWithCatigory:@"留学申请" items:@[]];
        EmallCatigoryGroup *service  = [EmallCatigoryGroup groupWithCatigory:@"签证服务" items:@[]];
        EmallCatigoryGroup *lang  = [EmallCatigoryGroup groupWithCatigory:@"语言培训" items:@[]];
        
        _groups = @[request,service,lang];
    }
    
    return _groups;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];

    [self makeDataSource];
    
    
}

- (void)makeUI{
    
    self.title = self.country_Name;
    
    self.current_Service = @"留学申请";
    
    [self makeTableView];
    
    [self makeTopNavigaitonView];
    
    [self makeFlexiableView];
    
}


-(void)makeTableView
{
    self.tableView =[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    self.tableView.showsVerticalScrollIndicator = false;
    
}


//添加自定义顶部导航
-(void)makeTopNavigaitonView{
    
    XWeakSelf
    UniversityNavView *nav = [UniversityNavView ViewWithBlock:^(UIButton *sender) {
        
        [weakSelf navigationItemWithSender:sender];
    }];
    
    self.topNavigationView = nav;
    nav.titleName = self.country_Name;
    [nav navigationWithRightViewHiden:YES];
    [nav navigationWithQQHiden:NO];
    [self.view insertSubview:nav aboveSubview:self.tableView];
    
}

- (void)makeFlexiableView{

    NSString *contry_img = @"emall_AU.jpeg";
    
    if ([self.country_Name containsString:@"英"]) {
        
        contry_img = @"emall_UK.jpeg";
        
    }else if([self.country_Name containsString:@"香"]){
        
        contry_img = @"emall_HK.jpeg";
        
    }else{
    
        contry_img = @"emall_AU.jpeg";
    }
    
    
    UIImage *FlexibleImg = XImage(contry_img);
    UIImageView *FlexibleView = [[UIImageView alloc] init];
    FlexibleView.contentMode = UIViewContentModeScaleAspectFit;
    FlexibleView.image = FlexibleImg;
    CGFloat iconHeight =  XSCREEN_WIDTH * FlexibleImg.size.height / FlexibleImg.size.width;
    FlexibleView.frame = CGRectMake(0, 0, XSCREEN_WIDTH, iconHeight);
    [self.view insertSubview:FlexibleView belowSubview:self.tableView];
    self.flexView = FlexibleView;
    self.flexFrame = self.flexView.frame;
    self.flexCenter = FlexibleView.center;
    
    [self maketableViewHeaderWithHeight:iconHeight];

    
}

- (void)maketableViewHeaderWithHeight:(CGFloat)height{
    
    CGFloat bannerHeight = 60;
    
    EmallCatigroyHeaderView *headerView = [EmallCatigroyHeaderView headerViewWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, height + bannerHeight)];
    headerView.upHeight = height;
    headerView.title = self.country_Name;
    self.tableView.tableHeaderView = headerView;
    
    
    XWeakSelf
    EmallCatigroySectionView *banView = [EmallCatigroySectionView headerViewWithFrame:CGRectMake(0, height, XSCREEN_WIDTH, bannerHeight) actionBlock:^(UIButton *sender) {
        
        [weakSelf makeCurrentSKUWithTitle:(sender.currentTitle)];
    }];
    
    [self.view addSubview:banView];
    self.banView = banView;
    self.banViewFrame = banView.frame;

}


- (void)makeDataSource{

    
    NSString *subPath = [NSString stringWithFormat:@"api/emall/skus?country=%@&category=%@",self.country_Name,self.current_Service];
    
    NSString *utfPath = [subPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
   NSString *path = [NSString stringWithFormat:@"GET %@",utfPath];
    
    XWeakSelf
    [self startAPIRequestWithSelector:path parameters:nil success:^(NSInteger statusCode, id response) {
        
        
        [weakSelf updateUIWithResponse:response];
        
    }];
    
 
}

- (void)updateUIWithResponse:(id)response{
    
    if (!response) {
        
        return ;
    }
    
    if (![response isKindOfClass:[NSArray class]]) {
        
        return;
    }
    
 
    
    NSArray *skus  = [ServiceSKU mj_objectArrayWithKeyValuesArray:(NSArray *)response];

    
    NSMutableArray *items = [NSMutableArray array];
    
    for (ServiceSKU *item in skus) {
        
        ServiceSKUFrame *itemFrame = [[ServiceSKUFrame alloc] init];
        itemFrame.SKU = item;
        [items addObject:itemFrame];
    }
    
    
    for (EmallCatigoryGroup *group in self.groups) {
        
        if([group.catigroy isEqualToString:self.current_Service]){
        
            group.sku_frames = [items copy];
            
            break;
        }
        
    }
    
    
    self.current_frames = [items copy];
    
    [self.tableView reloadData];
    
}


- (void)makeCurrentSKUWithTitle:(NSString *)title{
    
    
    self.current_Service = title;
    
    for (EmallCatigoryGroup *group in self.groups) {
        
        if([group.catigroy isEqualToString:self.current_Service]){
            
            self.current_frames = [group.sku_frames copy];
            
            break;
        }
        
    }
    
    
    if (self.current_frames.count > 0) {
        
        [self.tableView reloadData];
        
        return;
    }
    
    
    [self makeDataSource];
    
}





#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.current_frames.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    ServiceSKUFrame *itemFrame = self.current_frames[indexPath.row];
    
    ServiceSKUCell *cell = [ServiceSKUCell cellWithTableView:tableView SKU_Frame:itemFrame];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    ServiceSKUFrame *itemFrame = self.current_frames[indexPath.row];
    
    return itemFrame.cell_Height;
}


- (void)tableView:(UITableView *)tableView  didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    ServiceSKUFrame *itemFrame = self.current_frames[indexPath.row];
    ServiceItemViewController *item = [[ServiceItemViewController alloc] init];
    item.service_id = itemFrame.SKU.service_id;
    [self.navigationController pushViewController:item animated:true];
    
    
}

#pragma mark : UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat offersetY =  scrollView.contentOffset.y;
    
    //导航栏显示隐藏
    [self.topNavigationView scrollViewContentoffset:offersetY  andContenHeight:self.flexView.bounds.size.height - XNAV_HEIGHT];
    
    self.topNavigationView.nav_Alpha =  offersetY / (self.flexView.bounds.size.height - XNAV_HEIGHT);
    
    CGRect banNewRect = self.banViewFrame;
    banNewRect.origin.y = self.banViewFrame.origin.y -  offersetY;
    
    if (banNewRect.origin.y < XNAV_HEIGHT) {
        
        banNewRect.origin.y = XNAV_HEIGHT;
    }
    self.banView.frame = banNewRect;
    

    if (offersetY > 0) {
        
        
        self.flexView.frame = self.flexFrame;
        self.flexView.mj_y = -offersetY;
        
        return;
    }
    
    CGRect newRect = self.flexFrame;
    
    newRect.size.height = self.flexFrame.size.height - offersetY * 2;
    
    newRect.size.width  = self.flexFrame.size.width * newRect.size.height / self.flexFrame.size.height;
  
    self.flexView.frame = newRect;
    
    self.flexView.center = self.flexCenter;
    
    
}


#pragma mark :   navigationView 点击事件

- (void)navigationItemWithSender:(UIButton *)sender{

    if (sender.tag ==  NavItemStyleQQ) {
    
        [self caseQQ];
        
    }else{
    
        [self pop];
    }
    
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


- (void)pop{

    [self.navigationController popViewControllerAnimated:true];
}


- (void)dealloc{
    
    KDClassLog(@"dealloc 留学国家地区");
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
