
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
#import "CenterHeaderView.h"
#import "MessageViewController.h"
#import "PipeiEditViewController.h"
#import "MyOfferServerMallViewController.h"


@interface MeViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIWebViewDelegate>
//表头
@property (strong, nonatomic) IBOutlet UIView *headView;
//表头图片
@property (weak, nonatomic) IBOutlet UIImageView *centerHeader;
//智能匹配数据或收藏学校数字
@property(nonatomic,strong)NSDictionary  *myCountResponse;
//cell数组
@property(nonatomic,strong)NSArray *cells;
//cellDetailtext数组
@property(nonatomic,strong)NSArray *CelldDetailes;
//是否有新消息图标
@property(nonatomic,strong)LeftBarButtonItemView *leftView;
//智能匹配数量
@property(nonatomic,assign)NSInteger recommendationsCount;

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

#pragma mark : 网络请求

-(void)getRequestCenterSourse{
    
    if (LOGIN && [self checkNetWorkReaching]) {
        
        [self requestWithPath:kAPISelectorRequestCenter];
        [self requestWithPath:kAPISelectorApplicationStatus];
        [self requestWithPath:kAPISelectorZiZengPipeiGet];
        
        return;
    }
        
    [self matchImageName:GDLocalizedString(@"center-matchImage") tag:OptionButtonTypeZineng];
     self.myCountResponse = nil;
    [self.tableView reloadData];
    
}

#pragma mark : 网络请求

- (void)requestWithPath:(NSString *)path{
    
    XWeakSelf
    [self startAPIRequestWithSelector:path parameters:nil showHUD:NO success:^(NSInteger statusCode, id response) {
        
        
        if ([path isEqualToString:kAPISelectorApplicationStatus]) {
            
            [weakSelf resultWithApplyStatusWithResponse:response];
        }
        
     
        if ([path isEqualToString:kAPISelectorZiZengPipeiGet]) {
            
            [weakSelf PiPeiWithResponse:response];

         }
        
        
        if ([path isEqualToString:kAPISelectorRequestCenter]) {
            
            [weakSelf resultWithRequestCenterWithResponse:response];

         }
        
      
        if ([path isEqualToString:kAPISelectorCheckNews]) {
            
            [weakSelf resultWithCheckNewsWithResponse:response];
            
        }
        
        
    }];
    
}

//判断是否有智能匹配数据或收藏学校
- (void)resultWithRequestCenterWithResponse:(id)response{
   
    self.myCountResponse = response;
    
    [self.tableView reloadData];
}


//判断是否有智能匹配数据或收藏学校
- (void)PiPeiWithResponse:(id)response{
   
    self.recommendationsCount = response[@"university"] ? 1 : 0;
   
}

//判断显示图片
- (void)resultWithApplyStatusWithResponse:(id)response{

    /**     state     状态有4个值
     *  【 pending  ——审核中
     *  【 PushBack ——退回
     *  【 Approved ——审核通过
     *  【 -1       ——没有申请过
     */
    NSString *state       = response[@"state"];
    NSString *imageName   = [state containsString:@"1"] ? GDLocalizedString(@"center-matchImage") :GDLocalizedString(@"center-statusImage");
    OptionButtonType type =   [state containsString:@"1"] ? OptionButtonTypeZineng :OptionButtonTypeZhuangTai;
    [self matchImageName:imageName tag:type];
   
}

//显示是否有新消息显示在导航栏
- (void)resultWithCheckNewsWithResponse:(id)response{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSInteger message_count  = [response[@"message_count"] integerValue];
    NSInteger order_count    = [response[@"order_count"] integerValue];
    [ud setValue:[NSString stringWithFormat:@"%ld",(long)message_count] forKey:@"message_count"];
    [ud setValue:[NSString stringWithFormat:@"%ld",(long)order_count] forKey:@"order_count"];
    [ud synchronize];
    
    self.leftView.countStr =[NSString stringWithFormat:@"%ld",(long)(message_count +order_count)];
   
}


//用于设置tabelHeaderView图片
-(void)matchImageName:(NSString *)imageName tag:(OptionButtonType)tag
{
    self.centerHeader.image = XImage(imageName);
    
    self.OptionButton.tag   = tag;
}


-(void)makeOther{

    [self.OptionButton addTarget:self action:@selector(OptionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRequestCenterSourse) name:@"requestCenter" object:nil];
    
}

//设置cell
-(void)makeCellArray
{
    
    ActionTableViewCell *(^newCell)(NSString *text, UIImage *icon, void (^action)(void)) = ^ActionTableViewCell*(NSString *text, UIImage *icon, void (^action)(void)) {
        ActionTableViewCell *cell = [[ActionTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        cell.detailTextLabel.textColor =[UIColor darkGrayColor];
        cell.countLabel       =[[UILabel alloc] initWithFrame:CGRectMake(XSCREEN_WIDTH - 40,12,30, 30)];
        [cell.contentView addSubview:cell.countLabel];
        cell.textLabel.text   = text;
//        cell.imageView.image  = icon;
        cell.action           = action;
        
        return cell;
    };
    
    
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
                       newCell(list, XImage(@"center_yixiang"),
                               ^{
                                   [self itemOnClickWithType:ItemTypeClickApplyList];
                               }),
                       newCell(status,XImage(@"center_status"),
                               ^{
                                   [self itemOnClickWithType:ItemTypeClickApplyStatus];
                               }),
                       
                       newCell(material,XImage(@"center_matial"),
                               ^{
                                   [self itemOnClickWithType:ItemTypeClickApplyMatial];
                               }),
                       
                       newCell(myoffer, XImage(@"center_myoffer"),
                               ^{
                                   [self itemOnClickWithType:ItemTypeClickMyoffer];
                                   
                               })] ];

}



//导航栏UI设置
-(void)makeNavigationView
{
 
    XWeakSelf
    self.leftView   = [LeftBarButtonItemView leftViewWithBlock:^{
        
        [weakSelf showLeftMenu];

    }];
    
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc]  initWithCustomView:self.leftView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]  initWithImage:XImage(@"nav_QQ")  style:UIBarButtonItemStylePlain target:self action:@selector(QQservice)];
    
}

//表头UI设置
-(void)makeHeaderView
{
    
    UIImage *headImage =  XImage(@"center_ban_CN.jpg");
    CGFloat headerW = XSCREEN_WIDTH;
    CGFloat headerH = XSCREEN_WIDTH * headImage.size.height / headImage.size.width;
    self.headView.frame = CGRectMake(0, 0, headerW, headerH);
    
    self.tableView.tableHeaderView = self.headView;
}




#pragma mark :UITableViewDelegate  UITableViewDataSoure

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
 
    CenterHeaderView *headerView =  [CenterHeaderView centerSectionViewWithResponse:self.myCountResponse actionBlock:^(centerItemType type) {
        
        switch (type) {
            case centerItemTypepipei:
                [self CasePipei];
                break;
            case centerItemTypefavor:
                [self itemOnClickWithType:ItemTypeClickFavor];
                break;
            default:
                [self CaseServiceSelection];
                break;
        }

        
    }];
 
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    return [self.cells[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ActionTableViewCell *cell = self.cells[indexPath.section][indexPath.row];
    cell.detailTextLabel.text =  self.CelldDetailes[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ActionTableViewCell *cell = _cells[indexPath.section][indexPath.row];
    
    if (cell.action) cell.action();
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return  100 +  XPERCENT * 12;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
}


//判断用户在未登录前在申请中心页面选择服务，当用户登录时直接跳转已选择服务
-(void)userDidClickItem
{
    if (!LOGIN) return;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self itemOnClickWithType:self.clickType];
    });
    
}

#pragma mark : 实现不同选项跳转

-(void)itemOnClickWithType:(ItemTypeClick)type
{
    self.clickType = LOGIN ? ItemTypeClickNO : type;
    
    RequireLogin
    
    switch (type) {
        case ItemTypeClickPipei:
            [self CasePipei];
            break;
        case ItemTypeClickFavor:
            [self CaseFavoriteUniversity];
            break;
        case ItemTypeClickApplyList:
            [self CaseApplyListView];
            break;
        case ItemTypeClickApplyStatus:
            [self CaseApplyStatusView];
            break;
        case ItemTypeClickApplyMatial:
            [self CaseApplyMatial];
            break;
        case ItemTypeClickMyoffer:
            [self CaseMyoffer];
            break;
        default:
            break;
    }
}


//表头图片不同状态下跳转方式
-(void)OptionButtonClick:(UIButton *)optionButton
{
    [MobClick event:@"apply_topStutas"];
    
    if (optionButton.tag == OptionButtonTypeZineng) {
        
        [self CasePipei];
        
        return;
    }
    
    RequireLogin
    [self itemOnClickWithType:ItemTypeClickApplyStatus];
  
    
}



//导航栏 leftBarButtonItem
-(void)leftViewMessage
{
    
    NSUserDefaults *ud       = [NSUserDefaults standardUserDefaults];
    NSString *message_count  = [ud valueForKey:@"message_count"];
    NSString *order_count    = [ud valueForKey:@"order_count"];
    
    self.leftView.countStr =[NSString stringWithFormat:@"%ld",(long)(message_count.integerValue + order_count.integerValue)];
    
    if (LOGIN && [self checkNetWorkReaching]) {
        
        [self requestWithPath:kAPISelectorCheckNews];
    
        return;
    }
    
    //没有登录时要还原初始数据
    self.leftView.countStr  = @"0";
    [self matchImageName:GDLocalizedString(@"center-matchImage")  tag:OptionButtonTypeZineng];
    self.myCountResponse    = nil;
    [self.tableView reloadData];
    
}

//智能匹配跳转选项
-(void)CasePipei
{
    [MobClick event:@"apply_pipei"];
    
    if (!LOGIN) self.recommendationsCount = 0;
    
    if (self.recommendationsCount > 0 ) {
        
        RequireLogin
        
        [self.navigationController pushViewController:[[IntelligentResultViewController alloc] initWithNibName:@"IntelligentResultViewController" bundle:nil] animated:YES];
       
        return;
        
    }
 
    [self pushWithVC:@"PipeiEditViewController"];
    
}

#pragma mark : 跳转到QQ客服聊天页面
-(void)QQservice{

    QQserviceSingleView *service = [[QQserviceSingleView alloc] init];
    [service call];
}

//打开左侧菜单
-(void)showLeftMenu
{
    [self.sideMenuViewController presentLeftMenuViewController];
}

//跳转申请状态
-(void)CaseApplyStatusView
{
    [MobClick event: @"apply_applyStutasItem"];

     [self pushWithVC:NSStringFromClass([ApplyStatusViewController class])];

}

//跳转申请列表
-(void)CaseApplyListView
{
    [MobClick event: @"apply_applyItem"];
 
     [self pushWithVC:NSStringFromClass([ApplyViewController class])];

}

//跳转申请材料
-(void)CaseApplyMatial{
   
    [self pushWithVC:NSStringFromClass([ApplyMatialViewController class])];
    
}

//跳转申请MYOFFER
-(void)CaseMyoffer{
    
    [self pushWithVC:NSStringFromClass([MyOfferViewController class])];

    
}

//跳转收藏
-(void)CaseFavoriteUniversity{
   
    [MobClick event:@"apply_like"];
    
    [self pushWithVC:NSStringFromClass([FavoriteViewController class])];

}

//跳转服务包
-(void)CaseServiceSelection
{
    
    [MobClick event:@"home_mall"];
    
    [self pushWithVC:NSStringFromClass([MyOfferServerMallViewController class])];

}
//跳转
- (void)pushWithVC:(NSString *)vcStr{
    
    [self.navigationController pushViewController:[[NSClassFromString(vcStr)  alloc] init] animated:YES];

}



KDUtilRemoveNotificationCenterObserverDealloc

@end
