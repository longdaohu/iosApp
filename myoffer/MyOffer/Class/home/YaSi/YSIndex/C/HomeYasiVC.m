//
//  HomeYasiVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/27.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeYasiVC.h"
#import "HomeYaSiHeaderView.h"
#import "YaSiHomeModel.h"
#import "YSCalendarVC.h"
#import "YaSiScheduleVC.h"
#import "YasiCatigoryModel.h"
#import "YasiCatigoryItemModel.h"
#import "YSScheduleModel.h"
#import "HomeBannerObject.h"
#import "HomeYSSectionView.h"
#import "YXDateHelpObject.h"
#import "YSImagesCell.h"
#import "ServiceItemFrame.h"
#import "CreateOrderVC.h"
#import "YSCalendarCourseModel.h"

@interface HomeYasiVC ()
@property(nonatomic,strong)YaSiHomeModel *ysModel;
@property(nonatomic,assign)NSInteger current_index;
@property(nonatomic,strong)HomeYaSiHeaderView *YSHeader;
@property(nonatomic,strong) UIView *YSFooter;

@end

@implementation HomeYasiVC

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if(self.ysModel){
        if (self.ysModel.login_state != LOGIN && !self.ysModel.living_items_loaded) {
            //当用户登录时请求今日直播数据
            [self makeTodayOnliveData];
        }
        self.ysModel.login_state = LOGIN;
        if (self.headerView) {
            [self.YSHeader userLoginChange];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeYSData];
    self.type = UITableViewStylePlain;
    [self makeYSHeaderView];
}

- (void)setUser:(MyofferUser *)user{
    super.user = user;
    
    if (self.ysModel) {
        self.ysModel.user_coin = user.coin;
    }
    if (self.YSHeader) {
        self.YSHeader.score_signed = user.coin;
    }
}

- (void)makeYSData{
    
    myofferGroupModel *ys_group  = [myofferGroupModel groupWithItems:@[@"test"] header:@"test"];
    self.groups = @[ys_group];
    
    self.ysModel = [[YaSiHomeModel alloc] init];
    self.ysModel.login_state = LOGIN;
    if (self.user) {
        self.ysModel.user_coin = self.user.coin;
    }
    
    [self makeIELTSData];
    [self makeCategoryData];
    [self makeTodayOnliveData];
}

- (void)toLoadView{
    
    [super toLoadView];
    self.tableView.backgroundColor = XCOLOR_CLEAR;
    self.tableView.tableFooterView = self.YSFooter;
}

- (void)makeYSHeaderView{
    
    HomeYaSiHeaderView *header = [[HomeYaSiHeaderView alloc] initWithFrame:self.ysModel.header_frame];
    header.ysModel = self.ysModel;
    self.headerView = header;
    self.YSHeader = header;
    
    WeakSelf;
    header.actionBlock = ^(YSHomeHeaderActionType type) {
        [weakSelf caseHeaderActionType: type];
    };
    
}

- (UIView *)YSFooter{
    if (!_YSFooter) {
        
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, 1)];
        UIView *clrView = [[UIView alloc] initWithFrame:self.view.bounds];
        clrView.backgroundColor = XCOLOR_WHITE;
        [footer addSubview:clrView];
        
        _YSFooter = footer;
    }
    return _YSFooter;
}

#pragma mark : UITableViewDatasource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    WeakSelf;
    HomeYSSectionView *titleView = [[HomeYSSectionView alloc] init];
    titleView.actionBlock = ^(NSInteger index) {
        [weakSelf   caseSectionTitleChange:index];
    };
    return titleView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YSImagesCell *cell =[tableView dequeueReusableCellWithIdentifier:@"YSimages"];
    if (!cell) {
        cell =[[YSImagesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YSimages"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.current_index = self.current_index;
    cell.item = self.ysModel.catigory_Package_current;
    
    return cell;
}


#pragma mark :UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return  XSCREEN_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!self.ysModel.catigory_Package_current) {
        return  HEIGHT_ZERO;
    }else{
        NSNumber *cell_value = self.ysModel.catigory_Package_current.cell_arr[self.current_index];
        return  [cell_value floatValue];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 65;
}


#pragma mark : 数据请求

- (void)makeIELTSData{
    
    WeakSelf;
    NSString *path = [NSString stringWithFormat:@"GET %@api/v1/banners?type=IELTS&source=app",DOMAINURL_API];
    [self startAPIRequestWithSelector:path
                           parameters:nil expectedStatusCodes:nil showHUD:NO showErrorAlert:NO errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
                               [weakSelf makeIELTSWithResponse:response];
                           } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
                               //                               [weakSelf caseEmpty];
                           }];
    
}
- (void)makeIELTSWithResponse:(id)response{
    
    if (!ResponseIsOK) {
        return;
    }
    NSDictionary *result = response[@"result"];
    if (result.count == 0) {
        return;
    }
    NSArray *banners = [HomeBannerObject mj_objectArrayWithKeyValuesArray:result[@"items"]];
    if (banners.count > 0) {
        
        self.ysModel.banners = banners;
        self.YSHeader.ysModel = self.ysModel;
        self.YSHeader.frame = self.ysModel.header_frame;
        self.tableView.tableHeaderView = self.YSHeader;
        
        [self.tableView reloadData];
    }
}


//今日直播
- (void)makeTodayOnliveData{
    
    if (!LOGIN) return;
    WeakSelf;
    NSString *path = [NSString stringWithFormat:@"GET %@api/v1/ielts/courses-group-by-date",DOMAINURL_API];
    NSDate *today = [NSDate date];
    NSDate *tomorrow = [NSDate dateTomorrow];
    YXDateHelpObject *helpObj = [YXDateHelpObject manager];
    NSString *startTime = [helpObj getStrFromDateFormat:@"yyyy-MM-dd" Date:today];
    NSString *endTime = [helpObj getStrFromDateFormat:@"yyyy-MM-dd" Date:tomorrow];
    [self startAPIRequestWithSelector:path
                           parameters:@{
                                        @"startTime" : startTime,
                                        @"endTime" : endTime,
                                        } expectedStatusCodes:nil showHUD:NO showErrorAlert:NO
              errorAlertDismissAction:nil
              additionalSuccessAction:^(NSInteger statusCode, id response) {
                  [weakSelf makelivingWithResponse:response];
              } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
              }];
}

- (void)makelivingWithResponse:(id)response{
    
    if (!ResponseIsOK) {
        return;
    }
    NSArray *result = response[@"result"];
    if (result.count == 0) {
        return;
    }
    NSMutableArray *onLiving_arr = [NSMutableArray array];
    NSArray *Calendar_arr = [YSCalendarCourseModel mj_objectArrayWithKeyValuesArray:result];
    for (YSCalendarCourseModel *item  in Calendar_arr) {
        [onLiving_arr addObjectsFromArray:item.courses];
    }
    
    if (onLiving_arr.count > 0) {
        self.ysModel.living_items = onLiving_arr;
        self.YSHeader.ysModel = self.ysModel;
        self.YSHeader.frame = self.ysModel.header_frame;
        self.tableView.tableHeaderView = self.YSHeader;
    }
}

//分类数据
- (void)makeCategoryData{
    WeakSelf;
    NSString *path = [NSString stringWithFormat:@"GET %@api/v1/ielts/products",DOMAINURL_API];
    [self startAPIRequestWithSelector:path
                           parameters:nil expectedStatusCodes:nil showHUD:NO showErrorAlert:NO
              errorAlertDismissAction:nil
              additionalSuccessAction:^(NSInteger statusCode, id response) {
                  [weakSelf makeCatigoryWithResponse:response];
              } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
              }];
}
- (void)makeCatigoryWithResponse:(id)response{
    
    if (!ResponseIsOK) {
        return;
    }
    NSArray *result = response[@"result"];
    if (result.count == 0) {
        return;
    }
    NSArray *catigorys = [YasiCatigoryModel mj_objectArrayWithKeyValuesArray:result];
    self.ysModel.catigorys = catigorys;
    self.YSHeader.ysModel = self.ysModel;
    self.YSHeader.frame = self.ysModel.header_frame;
    self.tableView.tableHeaderView = self.YSHeader;
    
    [self.tableView reloadData];
}

//签到
- (void)makeUserSigned{
    WeakSelf;
    NSString *path = [NSString stringWithFormat:@"GET %@api/v1/singin",DOMAINURL_API];
    
    [self startAPIRequestWithSelector:path
                           parameters:nil expectedStatusCodes:nil showHUD:NO showErrorAlert:NO
              errorAlertDismissAction:nil
              additionalSuccessAction:^(NSInteger statusCode, id response) {
                  [weakSelf makeUserSignedWithResponse:response];
              } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
              }];
}

- (void)makeUserSignedWithResponse:(id)response{
    
    if (!ResponseIsOK) {
        
        NSNumber *code = response[@"code"];
        if(code.integerValue == 100){
            
            self.YSHeader.score_signed = nil;
            NSString *msg =[NSString stringWithFormat:@"%@",response[@"msg"]];
            [MBProgressHUD showMessage:msg];
        }
        
    }else{
        
        NSDictionary *result = response[@"result"];
        self.YSHeader.score_signed =  result[@"score"];
        [MBProgressHUD showMessage:@"签到成功"];
        self.ysModel.user_coin = result[@"score"];
        
    }
}


#pragma mark : 事件处理
- (void)caseHeaderActionType:(YSHomeHeaderActionType)type{
    
    switch (type) {
        case YSHomeHeaderActionTypeSigned:
            [self caseSigned];
            break;
        case YSHomeHeaderActionTypeLiving:
            [self caseLive];
            break;
        case YSHomeHeaderActionTypeTest:
            [self caseTest];
            break;
        case YSHomeHeaderActionTypeBanner:
            [self caseBanner];
            break;
        case YSHomeHeaderActionTypeBuy:
            [self caseBuy];
            break;
        case YSHomeHeaderActionTypeValueChange:{
            
            self.current_index = 0;
            [self.tableView reloadData];
        }
            break;
        default:
            break;
    }
}
- (void)caseBuy{
    
    if (LOGIN){
        
        ServiceItem *item = [[ServiceItem alloc] init];
        item.price = [NSNumber numberWithFloat:self.ysModel.catigory_Package_current.price.floatValue];
        item.display_price = [NSNumber numberWithFloat:self.ysModel.catigory_Package_current.display_price.floatValue];
        item.service_id = self.ysModel.catigory_Package_current._id;
        item.cover_url = self.ysModel.catigory_Package_current.cover_url;
        item.name  = self.ysModel.catigory_Package_current.name;
        item.fitPerson_hiden = true;
        ServiceItemFrame  *itemFrame = [[ServiceItemFrame alloc] init];
        itemFrame.item = item;
        
        CreateOrderVC *vc  = [[CreateOrderVC alloc] initWithNibName:@"CreateOrderVC" bundle:nil];
        vc.itemFrame =  itemFrame;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        RequireLogin;
    }
 
}

- (void)caseLive{
    
    RequireLogin;
    if (!LOGIN) return;
    YSCalendarVC *vc = [[YSCalendarVC alloc] init];
    PushToViewController(vc);
}

- (void)caseBanner{
    
    WebViewController *vc = [[WebViewController alloc] init];
    vc.path = self.ysModel.banner_target;
    PushToViewController(vc);
}

- (void)caseTest{
    
    [MBProgressHUD showMessage:@"功能即将上线，请持续关注，谢谢！"];
}

- (void)caseSigned{
    
    if (LOGIN) {
        [self makeUserSigned];
        return;
    }
    RequireLogin;
}

//切换分区分类
- (void)caseSectionTitleChange:(NSInteger)index{
    
    self.current_index = index;
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
    CGFloat top_y = self.tableView.mj_offsetY > CGRectGetMaxY(self.YSHeader.frame) ?  CGRectGetMaxY(self.YSHeader.frame) :  self.tableView.mj_offsetY ;
    [UIView performWithoutAnimation:^{
        
        [self.tableView setContentOffset:CGPointMake(0, top_y) animated:false];
        [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationFade];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


