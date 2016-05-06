
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
#import "IntelligentViewController.h"
#import "IntelligentResultViewController.h"
#import "centerSectionView.h"

@interface MeViewController ()<UITableViewDataSource,UITableViewDelegate>  {
}
@property(nonatomic,assign)int itemCount;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property(nonatomic,assign)int  recommendationsCount;
@property(nonatomic,assign)int  offersCount;
@property(nonatomic,assign)int  favoritesCount;
@property(nonatomic,strong)NSArray *cells;
@property(nonatomic,strong)NSArray *detailes;
@property (weak, nonatomic) IBOutlet UIImageView *centerHeader;
@property(nonatomic,assign)BOOL isApplied;//用户是否已经申请

@end
@implementation MeViewController

-(void)getRequestCenterSourse
{

  
     XJHUtilDefineWeakSelfRef;
    
    if ([AppDelegate sharedDelegate].isLogin) {
        
        [self startAPIRequestUsingCacheWithSelector:kAPISelectorRequestCenter parameters:nil success:^(NSInteger statusCode, NSDictionary *response) {
            
            weakSelf.recommendationsCount = [response[@"recommendationsCount"] intValue];
            weakSelf.offersCount =  [response[@"offersCount"] intValue];
            weakSelf.favoritesCount = [response[@"favoritesCount"] intValue];
            [weakSelf.tableView reloadData];
         }];
        
        
        [self startAPIRequestWithSelector:@"GET api/account/applicationliststateraw" parameters:nil success:^(NSInteger statusCode, id response) {
            
            NSString *state = response[@"state"];
            /*     state     状态有4个值
             *  【 pending  ——审核中
             *  【 PushBack ——退回
             *  【 Approved ——审核通过
             *  【 -1       ——没有申请过
             */
           if (![state containsString:@"1"] || [state containsString:@"ushBack"] ) {
               
                [weakSelf matchImageName:GDLocalizedString(@"center-statusImage") withOptionButtonTag:OptionButtonTypeZhuangTai];
               
                 weakSelf.isApplied = YES;
                return ;
            }
            else
            {
                [weakSelf matchImageName:GDLocalizedString(@"center-matchImage") withOptionButtonTag:OptionButtonTypeZineng];
                 weakSelf.isApplied = NO;
                
            }
        }];

     }else{
        
         [self matchImageName:GDLocalizedString(@"center-matchImage") withOptionButtonTag:OptionButtonTypeZineng];
         self.recommendationsCount = 0;
         self.offersCount = 0;
         self.favoritesCount = 0;
         self.isApplied = NO;
          [self.tableView reloadData];
     }
}
//用于设置tabelHeaderView图片
-(void)matchImageName:(NSString *)imageName withOptionButtonTag:(OptionButtonType)tag
{
    self.centerHeader.image = [UIImage imageNamed:imageName];
    self.OptionButton.tag = tag;
}

-(void)makeUI
{
    UIImage *headImage = [UIImage imageNamed:@"center_ban_CN.jpg"];
    CGFloat headHeigh = APPSIZE.width * headImage.size.height/headImage.size.width;
    
    self.tableView.rowHeight = 55;
    UIView *headBackView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, APPSIZE.width, headHeigh)];
    self.headView.frame = headBackView.bounds;
    [headBackView addSubview:self.headView];
    self.tableView.tableHeaderView = headBackView;
    [self.OptionButton addTarget:self action:@selector(OptionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //左侧菜单按钮
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BurgerMenu_39"] style:UIBarButtonItemStylePlain target:self action:@selector(showLeftMenu:)];
    
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
    
    NSString *list = GDLocalizedString(@"center-application");//"我的申请意向";
    NSString *listSub = GDLocalizedString(@"center-appDetail");
    NSString *status = GDLocalizedString(@"center-status");//"申请状态";
    NSString *statusSub = GDLocalizedString(@"center-statusDetail");
    NSString *material = GDLocalizedString(@"center-document" );//"申请材料";
    NSString *materialSub = GDLocalizedString(@"center-documentDetail" );
    NSString *myoffer = GDLocalizedString(@"center-myoffer" );
    NSString *myofferSub = GDLocalizedString(@"center-myofferDetail" );
    
    self.detailes =@[listSub,statusSub,materialSub,myofferSub];
    __weak typeof (self) weakSelf  =self;
    self.cells = @[@[
                      
                       newCell(list, [UIImage imageNamed:@"center_yixiang"],
                              ^{
                                  
                                  [weakSelf ApplyListView];
                               }),
                      newCell(status,[UIImage imageNamed:@"center_status"],
                              ^{
                                  
                                  [weakSelf ApplyStatusView];
                                  
                                }),

                      newCell(material,[UIImage imageNamed:@"center_matial"],
                              ^{
                                  RequireLogin
                                  ApplyMatialViewController *vc = [[ApplyMatialViewController alloc] initWithNibName:@"ApplyMatialViewController" bundle:nil];
                                  vc.hidesBottomBarWhenPushed = YES;
                                  [weakSelf.navigationController pushViewController:vc animated:YES];
                              }),
                      
                      newCell(myoffer, [UIImage imageNamed:@"center_myoffer"],
                              ^{
                                  RequireLogin
                                  MyOfferViewController *vc = [[MyOfferViewController alloc] initWithNibName:@"MyOfferViewController" bundle:nil];
                                  vc.hidesBottomBarWhenPushed = YES;
                                  [weakSelf.navigationController pushViewController:vc animated:YES];
                              })] ];
    
    
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRequestCenterSourse) name:@"requestCenter" object:nil];
    
}
-(void)inteligentOption
{
    RequireLogin
    KDClassLog(@"用于判断智能匹配是否有数据---- %d",self.recommendationsCount);
    if (self.recommendationsCount > 0 ) {
        IntelligentResultViewController *vc = [[IntelligentResultViewController alloc] initWithNibName:@"IntelligentResultViewController" bundle:nil];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else
    {
        IntelligentViewController *vc = [[IntelligentViewController alloc] initWithNibName:@"IntelligentViewController" bundle:nil];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}
-(void)ApplyStatusView
{
        RequireLogin
        ApplyStatusViewController *vc = [[ApplyStatusViewController alloc] initWithNibName:@"ApplyStatusViewController" bundle:nil];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
}

-(void)ApplyListView
{
        RequireLogin
        ApplyViewController *vc = [[ApplyViewController alloc] init];
        vc.isApplied = self.isApplied;
        [self.navigationController pushViewController:vc animated:YES];
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    centerSectionView  *sectionView = [[NSBundle mainBundle] loadNibNamed:@"centerSectionView" owner:self options:nil].lastObject;
    sectionView.favorCountLabel.text = [NSString stringWithFormat:@"%d %@",self.favoritesCount,GDLocalizedString(@"Evaluate-dangwei")];
    sectionView.pipeiCountLabel.text = [NSString stringWithFormat:@"%d %@",self.recommendationsCount,GDLocalizedString(@"Evaluate-dangwei")];
    sectionView.sectionBlock =^(UIButton *sender)
    {
        if (sender.tag == 10) {
            RequireLogin
            FavoriteViewController *vc = [[FavoriteViewController alloc] initWithNibName:@"FavoriteViewController" bundle:nil];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            [self inteligentOption];
        }
        
    };
    return sectionView;
}

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
    
    cell.detailTextLabel.text =  self.detailes[indexPath.row];
 
    
    if ([cell.textLabel.text containsString:@"ffer"]) {
        NSString *countString = self.offersCount != 0 ?[NSString stringWithFormat:@"%d",self.offersCount]:@"";
        cell.countLabel.text = countString;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ActionTableViewCell *cell = _cells[indexPath.section][indexPath.row];
    if (cell.action) cell.action();
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
  
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getRequestCenterSourse];
 
}


//打开左侧菜单
-(void)showLeftMenu:(UIBarButtonItem *)barButton
{
    [self.sideMenuViewController presentLeftMenuViewController];

}


-(void)OptionButtonPressed:(UIButton *)optionButton
{
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




@end
