//
//  RoomItemBookVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/7/31.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RoomItemBookVC.h"
#import "RoomItemBookCell.h"
#import "RoomItemBookSV.h"
#import "RoomItemBookHeaderView.h"
#import "RoomNavigationView.h"
#import "RoomAppointmentVC.h"

@interface RoomItemBookVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)RoomItemBookHeaderView *header;
@property(nonatomic,strong)RoomNavigationView *nav;

@end

@implementation RoomItemBookVC

- (void)viewWillAppear:(BOOL)animated{

    NavigationBarHidden(YES);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
}

- (void)makeUI{
    
    self.title = @"房源详情";
    [self makeTableView];
    RoomNavigationView *nav = [RoomNavigationView nav];
    self.nav = nav;
    [self.view addSubview:nav];
    nav.title = @"房源详情";
    WeakSelf
    nav.acitonBlock = ^(BOOL isBackButton) {
        if (isBackButton) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
}

- (RoomItemBookHeaderView *)header{
    
    if (!_header) {
         _header = [[RoomItemBookHeaderView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, 136)];
    }
    
    return _header;
}


- (void)makeTableView
{
    self.tableView =[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    
    UINib *xib = [UINib nibWithNibName:@"RoomItemBookCell" bundle:nil];
    [self.tableView registerNib:xib forCellReuseIdentifier:@"RoomItemBookCell"];
    self.tableView.estimatedRowHeight = 200;//很重要保障滑动流畅性
//    self.tableView.estimatedSectionHeaderHeight = 58;
//    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionFooterHeight = 1;
    self.tableView.sectionFooterHeight = HEIGHT_ZERO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.header.itemFrameModel = self.itemFrameModel;
    if (self.itemFrameModel.item.pictures.count > 0) {
        self.header.mj_h += XSCREEN_WIDTH;
    }
    self.tableView.tableHeaderView = self.header;
    self.nav.alpha_height = XSCREEN_WIDTH;
}


#pragma mark :  UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.itemFrameModel.item.prices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    RoomItemBookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RoomItemBookCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.item = self.itemFrameModel.item.prices[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RoomTypeBookItemModel *item = self.itemFrameModel.item.prices[indexPath.row];
    if (item.state.boolValue) return;
    [self caseBookWithRooomID:item.roomtype_id];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    RoomItemBookSV *sv = [[RoomItemBookSV alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, 58)];
   
    return sv;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
 
    return 58;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.nav scrollViewDidScroll:scrollView];
}

- (void)caseBookWithRooomID:(NSString *)room_id{
 
    WeakSelf
    RoomAppointmentVC *vc = [[RoomAppointmentVC alloc] init];
    vc.room_id = room_id;
    vc.actionBlock = ^{
        [weakSelf caseHome];
    };
    
    if ([self.navigationController isKindOfClass:[MyofferNavigationController class]]) {
        MyOfferWhiteNV *nav = [[MyOfferWhiteNV alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }else{
        PushToViewController(vc);
    }
}

- (void)caseHome{
 
    WeakSelf
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    KDClassLog(@" 房源预订 + RoomItemBookVC + dealloc");
}


@end
