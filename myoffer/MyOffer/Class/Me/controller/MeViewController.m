
//
//  MeViewController.m
//  MyOffer
//
//  Created by Blankwonder on 6/7/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

typedef enum {
    OptionButtonTypeZineng = 100,
    OptionButtonTypeZhuangTai
}OptionButtonType;//表头按钮选项



#import "MeViewController.h"
#import "ProfileViewController.h"
#import "FXBlurView.h"
#import "FavoriteViewController.h"
#import "ApplyViewController.h"
#import "ApplyStatusViewController.h"
#import "MyOfferViewController.h"
#import "ApplyMatialViewController.h"
#import "IntelligentResultViewController.h"
#import "centerSectionView.h"
#import "InteProfileViewController.h"
#import "MessageViewController.h"
#import "ServiceMallViewController.h"


@interface MeViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIWebViewDelegate>
//表头
@property (strong, nonatomic) IBOutlet UIView *headView;
//表头图片
@property (weak, nonatomic) IBOutlet UIImageView *centerHeader;
@property(nonatomic,strong)NSDictionary  *myCountResponse;
//cell数组
@property(nonatomic,strong)NSArray *cells;
//cellDetailtext数组
@property(nonatomic,strong)NSArray *CelldDetailes;
//是否有新消息图标
@property(nonatomic,strong)LeftBarButtonItemView *leftView;


@end

@implementation MeViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"page申请中心"];
    
    [self presentViewWillAppear];
    
}

//页面出现时预加载功能
-(void)presentViewWillAppear{

     [self getRequestCenterSourse];
    
     [self leftViewMessage];
    
     [self userDidClickItem];
    
     self.tabBarController.tabBar.hidden = NO;

}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page申请中心"];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
}


-(void)makeUI
{
    
    [self makeHeaderView];
    
    [self makeNavigationView];
    
    [self makeCellArray];
    
    [self makeOther];
    
}


-(void)getRequestCenterSourse{
    
    XJHUtilDefineWeakSelfRef;
    //查看是否有新通知消息
    if (LOGIN && [self checkNetWorkReaching]) {
        
        //判断是否有智能匹配数据或收藏学校
        [self startAPIRequestWithSelector:kAPISelectorRequestCenter parameters:nil showHUD:NO success:^(NSInteger statusCode, id response) {

             weakSelf.myCountResponse = response;
            
            [weakSelf.tableView reloadData];
        }];
        
        //判断显示图片
        /**     state     状态有4个值
         *  【 pending  ——审核中
         *  【 PushBack ——退回
         *  【 Approved ——审核通过
         *  【 -1       ——没有申请过
         */
        [self startAPIRequestWithSelector:kAPISelectorApplicationStatus parameters:nil showHUD:NO success:^(NSInteger statusCode, id response) {
           
            NSString *state       = response[@"state"];
            NSString *imageName   = [state containsString:@"1"] ? GDLocalizedString(@"center-matchImage") :GDLocalizedString(@"center-statusImage");
            OptionButtonType type =   [state containsString:@"1"] ? OptionButtonTypeZineng :OptionButtonTypeZhuangTai;
            [weakSelf matchImageName:imageName withOptionButtonTag:type];
            
         }];
        
    }else{
        
        [self matchImageName:GDLocalizedString(@"center-matchImage") withOptionButtonTag:OptionButtonTypeZineng];
         self.myCountResponse = nil;
        [self.tableView reloadData];
        
    }
    
}
//用于设置tabelHeaderView图片
-(void)matchImageName:(NSString *)imageName withOptionButtonTag:(OptionButtonType)tag
{
    self.centerHeader.image = [UIImage imageNamed:imageName];
    
    self.OptionButton.tag   = tag;
}


-(void)makeOther{

    [self.OptionButton addTarget:self action:@selector(OptionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRequestCenterSourse) name:@"requestCenter" object:nil];
    
}


-(void)makeCellArray
{
    //外包公司cell数据方式
    ActionTableViewCell *(^newCell)(NSString *text, UIImage *icon, void (^action)(void)) = ^ActionTableViewCell*(NSString *text, UIImage *icon, void (^action)(void)) {
        ActionTableViewCell *cell = [[ActionTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        cell.detailTextLabel.textColor =[UIColor darkGrayColor];
        cell.countLabel       =[[UILabel alloc] initWithFrame:CGRectMake(APPSIZE.width - 40,12,30, 30)];
        [cell.contentView addSubview:cell.countLabel];
        cell.textLabel.text   = text;
        cell.imageView.image  = icon;
        cell.action           = action;
        
        return cell;
    };
    
    XJHUtilDefineWeakSelfRef
    NSString *list        = GDLocalizedString(@"center-application");
    NSString *listSub     = GDLocalizedString(@"center-appDetail");
    NSString *status      = GDLocalizedString(@"center-status");
    NSString *statusSub   = GDLocalizedString(@"center-statusDetail");
    NSString *material    = GDLocalizedString(@"center-document" );
    NSString *materialSub = GDLocalizedString(@"center-documentDetail" );
    NSString *myoffer     = GDLocalizedString(@"center-myoffer" );
    NSString *myofferSub  = GDLocalizedString(@"center-myofferDetail" );
    self.CelldDetailes =@[listSub,statusSub,materialSub,myofferSub];
    self.cells = @[@[
                       newCell(list, [UIImage imageNamed:@"center_yixiang"],
                               ^{
                                   [weakSelf centerPageClickWithItemType:CenterClickItemTypeApplyList];
                               }),
                       newCell(status,[UIImage imageNamed:@"center_status"],
                               ^{
                                   [weakSelf centerPageClickWithItemType:CenterClickItemTypeApplyStatus];
                               }),
                       
                       newCell(material,[UIImage imageNamed:@"center_matial"],
                               ^{
                                   [weakSelf centerPageClickWithItemType:CenterClickItemTypeApplyMatial];
                               }),
                       
                       newCell(myoffer, [UIImage imageNamed:@"center_myoffer"],
                               ^{
                                   [weakSelf centerPageClickWithItemType:CenterClickItemTypeMyoffer];
                                   
                               })] ];

}




-(void)makeNavigationView
{
 
    XJHUtilDefineWeakSelfRef
    self.leftView   = [LeftBarButtonItemView leftViewWithBlock:^{
        
        [weakSelf showLeftMenu];

    }];
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc]  initWithCustomView:self.leftView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]  initWithImage:[UIImage imageNamed:@"QQService"] style:UIBarButtonItemStylePlain target:self action:@selector(QQservice)];
    
}

-(void)makeHeaderView
{
    self.centerHeader.image =[UIImage imageNamed:@"PlaceHolderImage"];
    UIImage *headImage = [UIImage imageNamed:@"center_ban_CN.jpg"];
    CGFloat headHeigh = XScreenWidth * headImage.size.height / headImage.size.width;
    self.headView.frame = CGRectMake(0, 0, XScreenWidth, headHeigh);
    self.tableView.tableHeaderView = self.headView;
}


//判断用户在未登录前在申请中心页面选择服务，当用户登录时直接跳转已选择服务
-(void)userDidClickItem
{
    if (LOGIN) {
        
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self centerPageClickWithItemType:self.clickType];

        });
     }
}
//实现不同选项跳转
-(void)centerPageClickWithItemType:(CenterClickItemType)type
{

    self.clickType = LOGIN ? CenterClickItemTypeNoClick : type;
    
    RequireLogin
    
    switch (type) {
        case CenterClickItemTypePipei:
            [self CasePipei];
            break;
        case CenterClickItemTypeFavor:
            [self CaseFavoriteUniversity];
            break;
        case CenterClickItemTypeApplyList:
            [self CaseApplyListView];
            break;
        case CenterClickItemTypeApplyStatus:
            [self CaseApplyStatusView];
            break;
        case CenterClickItemTypeApplyMatial:
            [self CaseApplyMatial];
            break;
        case CenterClickItemTypeMyoffer:
            [self CaseMyoffer];
            break;
        default:
            break;
    }
}

//分区头
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    centerSectionView *sectionView =  [centerSectionView centerSectionViewWithResponse:self.myCountResponse];
    
    sectionView.sectionBlock       =  ^(centerItemType type){
        switch (type) {
            case centerItemTypepipei:
                [self centerPageClickWithItemType:CenterClickItemTypePipei];
                break;
            case centerItemTypefavor:
                [self centerPageClickWithItemType:CenterClickItemTypeFavor];
                break;
            default:
                [self CaseServiceSelection];
                break;
        }
        
    };
    return sectionView;
}

#pragma mark ——— UITableViewDelegate  UITableViewDataSoure
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    return [self.cells[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ActionTableViewCell *cell = self.cells[indexPath.section][indexPath.row];
    cell.detailTextLabel.text =  self.CelldDetailes[indexPath.row];
    if ([cell.textLabel.text containsString:@"ffer"]) {
        NSString *countString =  [self.myCountResponse[@"offersCount"] integerValue]!= 0 ?[NSString stringWithFormat:@"%@",self.myCountResponse[@"offersCount"]]:@"";
        cell.countLabel.text  = countString;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ActionTableViewCell *cell = _cells[indexPath.section][indexPath.row];
    
    if (cell.action) cell.action();
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return  80 + (XScreenWidth - 320) * 0.2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
}


#pragma mark ——— UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
     if (buttonIndex) { //跳转到QQ下载页面
        UIWebView *webView    = [[UIWebView alloc] initWithFrame:CGRectZero];
        NSURL *url            = [NSURL URLWithString:@"http://appstore.com/qq"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        webView.delegate      = self;
        [webView loadRequest:request];
        [self.view addSubview:webView];
     }
}

//打开左侧菜单
-(void)showLeftMenu
{
    [self.sideMenuViewController presentLeftMenuViewController];
    
}

//表头图片不同状态下跳转方式
-(void)OptionButtonPressed:(UIButton *)optionButton
{
    [MobClick event:@"apply_topStutas"];
    RequireLogin
    switch (optionButton.tag) {
        case OptionButtonTypeZineng:
            [self centerPageClickWithItemType:CenterClickItemTypePipei];
            break;
        default:
            [self centerPageClickWithItemType:CenterClickItemTypeApplyStatus];
            break;
    }
}


//跳转到QQ客服聊天页面
-(void)QQservice
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        [MobClick event:@"KeFu"];
        UIWebView *webView    = [[UIWebView alloc] initWithFrame:CGRectZero];
        NSURL *url            = [NSURL URLWithString:@"mqq://im/chat?chat_type=wpa&uin=3062202216&version=1&src_type=web"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        webView.delegate      = self;
        [webView loadRequest:request];
        [self.view addSubview:webView];
        
    }else{
        
        UIAlertView *aler =[[UIAlertView alloc] initWithTitle:GDLocalizedString(@"Me-QQService") message:nil delegate:self cancelButtonTitle:GDLocalizedString(@"Potocol-Cancel") otherButtonTitles:GDLocalizedString(@"Me-QQDownload"),nil];
        [aler show];
    }
}

//导航栏leftBarButtonItem
-(void)leftViewMessage{

    if (LOGIN && [self checkNetWorkReaching]) {
        
        XJHUtilDefineWeakSelfRef
        
        
     [self startAPIRequestWithSelector:kAPISelectorCheckNews parameters:nil showHUD:NO success:^(NSInteger statusCode, id response) {
         
         NSUserDefaults *ud       = [NSUserDefaults standardUserDefaults];
         NSInteger message_count  = [response[@"message_count"] integerValue];
         NSInteger order_count    = [response[@"order_count"] integerValue];
         [ud setValue:[NSString stringWithFormat:@"%ld",(long)message_count] forKey:@"message_count"];
         [ud setValue:[NSString stringWithFormat:@"%ld",(long)order_count] forKey:@"order_count"];
         [ud synchronize];
         
         weakSelf.leftView.countStr =[NSString stringWithFormat:@"%ld",(long)[response[@"message_count"] integerValue]+[response[@"order_count"] integerValue]];
         
       }];
      
    }
    
    if (!LOGIN) {
        
        self.leftView.countStr  = @"0";
        [self matchImageName:GDLocalizedString(@"center-matchImage")  withOptionButtonTag:OptionButtonTypeZineng];
        self.myCountResponse    = nil;
        [self.tableView reloadData];
    }
    
}


//智能匹配跳转选项
-(void)CasePipei
{
    [MobClick event:@"apply_pipei"];
    
    if ([self.myCountResponse[@"recommendationsCount"] integerValue] > 0 ) {
        
        [self.navigationController pushViewController:[[IntelligentResultViewController alloc] initWithNibName:@"IntelligentResultViewController" bundle:nil] animated:YES];
        
    }else{
        
        [self.navigationController pushViewController:[[InteProfileViewController alloc] init] animated:YES];
        
    }
}

//跳转申请状态
-(void)CaseApplyStatusView
{
    [MobClick event: @"apply_applyStutasItem"];
    
    [self.navigationController pushViewController:[[ApplyStatusViewController alloc] init] animated:YES];
}
//跳转申请列表
-(void)CaseApplyListView
{
    
    [MobClick event: @"apply_applyItem"];
    [self.navigationController pushViewController:[[ApplyViewController alloc] init] animated:YES];
}

//跳转申请材料
-(void)CaseApplyMatial{
    
    [self.navigationController pushViewController:[[ApplyMatialViewController alloc] init] animated:YES];
}
//跳转申请MYOFFER
-(void)CaseMyoffer{
    
    [self.navigationController pushViewController:[[MyOfferViewController alloc] init] animated:YES];
}

//跳转收藏
-(void)CaseFavoriteUniversity{
    
    [MobClick event:@"apply_like"];
    [self.navigationController pushViewController:[[FavoriteViewController alloc] init] animated:YES];
    
}

//跳转服务包
-(void)CaseServiceSelection{
    
    [MobClick event:@"home_mall"];
    [self.navigationController pushViewController:[[ServiceMallViewController alloc] init] animated:YES];
}



KDUtilRemoveNotificationCenterObserverDealloc
@end
