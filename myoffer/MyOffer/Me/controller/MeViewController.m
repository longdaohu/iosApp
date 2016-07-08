
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
#import "XWGJCatigoryViewController.h"
#import "ServiceMallViewController.h"

@interface MeViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,UIAlertViewDelegate>  {
}
@property (strong, nonatomic) IBOutlet UIView *headView;
@property(nonatomic,strong)NSDictionary  *myCountResponse;
//cell数组
@property(nonatomic,strong)NSArray *cells;
//cellDetailtext数组
@property(nonatomic,strong)NSArray *CelldDetailes;
//是否有新消息图标
@property(nonatomic,strong)UIImageView *NotiNewView;
//表头图片
@property (weak, nonatomic) IBOutlet UIImageView *centerHeader;
@end
@implementation MeViewController


-(void)getRequestCenterSourse
{
  
     XJHUtilDefineWeakSelfRef;
    
    //查看是否有新通知消息
    if ([AppDelegate sharedDelegate].isLogin && [self checkNetWorkReaching]) {
        
        [self startAPIRequestWithSelector:kAPISelectorCheckNews  parameters:nil success:^(NSInteger statusCode, id response) {
            
             self.NotiNewView.image = [response[@"has_new_message"] integerValue] == 0 ?nil:[UIImage imageNamed:@"message_dot"];
            
        }];
        
        //判断是否有智能匹配数据或收藏学校
        [self startAPIRequestUsingCacheWithSelector:kAPISelectorRequestCenter parameters:nil success:^(NSInteger statusCode, NSDictionary *response) {
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
        [self startAPIRequestWithSelector:kAPISelectorApplicationStatus parameters:nil success:^(NSInteger statusCode, id response) {
            NSString *state = response[@"state"];
            NSString *imageName = [state containsString:@"1"] ? GDLocalizedString(@"center-matchImage") :GDLocalizedString(@"center-statusImage");
            OptionButtonType type =   [state containsString:@"1"] ? OptionButtonTypeZineng :OptionButtonTypeZhuangTai;
            [weakSelf matchImageName:imageName withOptionButtonTag:type];
            
        }];

     }else{
        
         [self matchImageName:GDLocalizedString(@"center-matchImage") withOptionButtonTag:OptionButtonTypeZineng];
         self.NotiNewView.image = nil;
         self.myCountResponse = nil;
         [self.tableView reloadData];

     }
}
//用于设置tabelHeaderView图片
-(void)matchImageName:(NSString *)imageName withOptionButtonTag:(OptionButtonType)tag
{
    self.centerHeader.image = [UIImage imageNamed:imageName];
    
    self.OptionButton.tag = tag;
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self getRequestCenterSourse];
    
    self.tabBarController.tabBar.hidden = NO;

    [MobClick beginLogPageView:@"page申请中心"];
    
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
    
    self.tableView.rowHeight = 55;
    
    [self makeHeaderView];
    
    [self.OptionButton addTarget:self action:@selector(OptionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self makeNavigationView];
    
    [self makeCellArray];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRequestCenterSourse) name:@"requestCenter" object:nil];
    
}

-(void)makeCellArray
{
    //外包公司cell数据方式
    ActionTableViewCell *(^newCell)(NSString *text, UIImage *icon, void (^action)(void)) = ^ActionTableViewCell*(NSString *text, UIImage *icon, void (^action)(void)) {
        ActionTableViewCell *cell = [[ActionTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        cell.detailTextLabel.textColor =[UIColor darkGrayColor];
        cell.countLabel =[[UILabel alloc] initWithFrame:CGRectMake(APPSIZE.width - 40,12,30, 30)];
        [cell.contentView addSubview:cell.countLabel];
        cell.textLabel.text = text;
        cell.imageView.image = icon;
        cell.action = action;
        
        return cell;
    };
    
    XJHUtilDefineWeakSelfRef
    
    NSString *list = GDLocalizedString(@"center-application");
    NSString *listSub = GDLocalizedString(@"center-appDetail");
    NSString *status = GDLocalizedString(@"center-status");
    NSString *statusSub = GDLocalizedString(@"center-statusDetail");
    NSString *material = GDLocalizedString(@"center-document" );
    NSString *materialSub = GDLocalizedString(@"center-documentDetail" );
    NSString *myoffer = GDLocalizedString(@"center-myoffer" );
    NSString *myofferSub = GDLocalizedString(@"center-myofferDetail" );
    
    self.CelldDetailes =@[listSub,statusSub,materialSub,myofferSub];
    
    self.cells = @[@[
                       
                       newCell(list, [UIImage imageNamed:@"center_yixiang"],
                               ^{
                                   [MobClick event: @"apply_applyItem"];
                                   [weakSelf ApplyListView];
                               }),
                       newCell(status,[UIImage imageNamed:@"center_status"],
                               ^{
                                   [MobClick event: @"apply_applyStutasItem"];
                                    [weakSelf ApplyStatusView];
                                   
                               }),
                       
                       newCell(material,[UIImage imageNamed:@"center_matial"],
                               ^{
                                   RequireLogin
                                   ApplyMatialViewController *vc = [[ApplyMatialViewController alloc] init];
                                   [weakSelf.navigationController pushViewController:vc animated:YES];
                               }),
                       
                       newCell(myoffer, [UIImage imageNamed:@"center_myoffer"],
                               ^{
                                   RequireLogin
                                   MyOfferViewController *vc = [[MyOfferViewController alloc] init];
                                   [weakSelf.navigationController pushViewController:vc animated:YES];
                               })] ];

}

-(void)makeNavigationView
{
    //自定义导航栏左侧按钮
    UIView *rightView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,40, 40)];
    [rightView addSubview:rightButton];
    rightButton.imageEdgeInsets = UIEdgeInsetsMake(-3, -20, 0, 0);
//    [rightButton setTintAdjustmentMode:UIViewTintAdjustmentModeAutomatic];
    [rightButton setImage:[UIImage imageNamed:@"menu_white"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(showLeftMenu:) forControlEvents:UIControlEventTouchUpInside];
    //用于显示按钮左上角红点标签
    self.NotiNewView =[[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 10, 10)];
    [rightView addSubview:self.NotiNewView];
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]  initWithCustomView:rightView];
    
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]  initWithImage:[UIImage imageNamed:@"QQService"] style:UIBarButtonItemStylePlain target:self action:@selector(QQservice)];
}
-(void)makeHeaderView
{
    self.centerHeader.image =[UIImage imageNamed:@"PlaceHolderImage"];
    UIImage *headImage = [UIImage imageNamed:@"center_ban_CN.jpg"];
    CGFloat headHeigh = APPSIZE.width * headImage.size.height/headImage.size.width;
    self.headView.frame = CGRectMake(0, 0, APPSIZE.width, headHeigh);
    self.tableView.tableHeaderView = self.headView;
}


//智能匹配跳转选项
-(void)inteligentOption
{
    RequireLogin
    if ((NSInteger)self.myCountResponse[@"recommendationsCount"] > 0 ) {
        
        IntelligentResultViewController *vc = [[IntelligentResultViewController alloc] initWithNibName:@"IntelligentResultViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else
    {
        InteProfileViewController *vc =[[InteProfileViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

//跳转申请状态
-(void)ApplyStatusView
{
        RequireLogin
        ApplyStatusViewController *vc = [[ApplyStatusViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
}
//跳转申请列表
-(void)ApplyListView
{
        RequireLogin
        ApplyViewController *vc = [[ApplyViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
}

//分区头
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    centerSectionView  *sectionView =  [[centerSectionView alloc] init];
//    sectionView.FavoriteCount = self.favoritesCount;
//    sectionView.PipeiCount = self.recommendationsCount;
    sectionView.response = self.myCountResponse;
    sectionView.sectionBlock =^(UIButton *sender)
    {
        
        switch (sender.superview.tag) {
            case 1:
            {
                [MobClick event:@"apply_pipei"];

                [self inteligentOption];

            }
                break;
            case 2:
            {
                RequireLogin
                [self.navigationController pushViewController:[[FavoriteViewController alloc] init] animated:YES];
                [MobClick event:@"apply_like"];
              }
                break;
            default:{
            
                 [self.navigationController pushViewController:[[ServiceMallViewController alloc] init] animated:YES];
            }
                break;
        }
    
        
    };
    return sectionView;
}

#pragma mark —————— UITableViewDelegate  UITableViewDataSoure
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  80 * APPSIZE.width/320;
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
    
    
    if ([cell.textLabel.text containsString:@"ffer"]) {
        
        NSString *countString =  [self.myCountResponse[@"offersCount"] integerValue]!= 0 ?[NSString stringWithFormat:@"%@",self.myCountResponse[@"offersCount"]]:@"";
        cell.countLabel.text = countString;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ActionTableViewCell *cell = _cells[indexPath.section][indexPath.row];
    
    if (cell.action) cell.action();
}


//打开左侧菜单
-(void)showLeftMenu:(UIBarButtonItem *)barButton
{
    [self.sideMenuViewController presentLeftMenuViewController];
    
}


//表头图片不同状态下跳转方式
-(void)OptionButtonPressed:(UIButton *)optionButton
{
    [MobClick event:@"apply_topStutas"];
     switch (optionButton.tag) {
        case OptionButtonTypeZineng:
             [self inteligentOption];
            break;
        default:
            [self ApplyStatusView];
            break;
    }
}


KDUtilRemoveNotificationCenterObserverDealloc


-(void)QQservice
{
 
      //跳转到QQ客服聊天页面
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        NSURL *url = [NSURL URLWithString:@"mqq://im/chat?chat_type=wpa&uin=3062202216&version=1&src_type=web"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        webView.delegate = self;
        [webView loadRequest:request];
        [self.view addSubview:webView];
        
    }else{
        
        UIAlertView *aler =[[UIAlertView alloc] initWithTitle:GDLocalizedString(@"Me-QQService") message:nil delegate:self cancelButtonTitle:GDLocalizedString(@"Potocol-Cancel") otherButtonTitles:GDLocalizedString(@"Me-QQDownload"),nil];
        [aler show];
    }
}

#pragma mark  ————————————  UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
     if (buttonIndex) { //跳转到QQ下载页面
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        NSURL *url = [NSURL URLWithString:@"http://appstore.com/qq"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        webView.delegate = self;
        [webView loadRequest:request];
        [self.view addSubview:webView];
     }
}


@end
