//
//  InvitationRecordsVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/5/22.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "InvitationRecordsVC.h"
#import "InvitationRecordsCell.h"
#import "InvitationRecordDetailVC.h"
#import "InvitationRecordItem.h"
#import "MyofferOnColumnFilterView.h"

#define StateKey @"state"

@interface InvitationRecordsVC () <UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)MyOfferTableView *tableView;
@property(nonatomic,strong)NSMutableDictionary *parameters;
@property(nonatomic,strong)NSMutableArray *items;
@property(nonatomic,assign)NSInteger page;
@property(nonatomic,strong)NSArray *filter_datas;
@property(nonatomic,strong)MyofferOnColumnFilterView *filterView;

@end

@implementation InvitationRecordsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeUI];
    [self makeData];
    [self makeBaseData];
    
}

- (void)makeUI{
    
    [self makeTableView];

    self.title = @"邀请记录";
}

- (void)makeTableView
{
    self.tableView =[[MyOfferTableView alloc] initWithFrame:CGRectMake(0, 50, XSCREEN_WIDTH, XSCREEN_HEIGHT - NavHeight - 50) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(makeMoreData)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor greenColor];
    self.tableView.emptyY =  (XSCREEN_HEIGHT - self.tableView.mj_y - NavHeight)* 0.5 - 200;
    
    UINib *cell_nib = [UINib nibWithNibName:@"InvitationRecordsCell" bundle:nil];
    [self.tableView registerNib:cell_nib forCellReuseIdentifier:@"InvitationRecordsCell"];
    self.tableView.estimatedRowHeight = 200;//很重要保障滑动流畅性
    [self makeFilterView];
}

- (void)makeFilterView{
    
    CGFloat top_h = 50;
    WeakSelf
    MyofferOnColumnFilterView *filterView = [[MyofferOnColumnFilterView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, top_h)];
    self.filterView = filterView;
    filterView.filterBlock = ^(NSInteger tb_tag, NSInteger index_row) {
        [weakSelf filterWithTag:tb_tag row:index_row];
    };
    [self.view addSubview:filterView];
}

- (void)filterWithTag:(NSInteger)tag row:(NSInteger)row{
    
    self.page = 0;
    if (row == 0) {
        [self.parameters removeObjectForKey:StateKey];
    }else{
        NSDictionary *item = self.filter_datas[row - 1];
        [self.parameters setObject: item[@"code"] forKey:StateKey];
    }
    [self.parameters setObject: @(self.page) forKey:KEY_PAGE];

    if (self.items.count > 0) {
        [self.tableView  scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    [self makeData];
    
    NSLog(@"%@",self.parameters);
    
}

- (NSMutableDictionary *)parameters{
    if (!_parameters) {
        _parameters = [NSMutableDictionary dictionary];
        [_parameters setValue:@0 forKey:KEY_PAGE];
        [_parameters setValue:@Parameter_Size  forKey:KEY_SIZE];
    }
    
    return _parameters;
}

- (NSMutableArray *)items{
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return  _items ;
}

- (void)makeBaseData{
     WeakSelf;
    [self startAPIRequestWithSelector:kAPISelectorPromotionStateItems parameters:self.parameters expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        [weakSelf updateUIWithBaseResponse:response];
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
    }];
    
}

- (void)updateUIWithBaseResponse:(id)response{
    
    //网络请求出错
    if (!ResponseIsOK) {
        return;
    }
    //解析字典
    NSArray *result = response[@"result"];
    self.filter_datas = [result copy];
    NSMutableArray *status_arr = [NSMutableArray arrayWithObject:@"状态"];
    NSArray *names = [result valueForKey:@"name"];
    [status_arr addObjectsFromArray:names];
 
    self.filterView.groups = @[status_arr];
    
}


- (void)makeData{
    WeakSelf;
    [self startAPIRequestWithSelector:kAPISelectorPromotionItems parameters:self.parameters expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        [weakSelf updateUIWithResponse:response];
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
    }];
}

- (void)updateUIWithResponse:(id)response{
    
    //网络请求出错
    if (!ResponseIsOK) {
        [MBProgressHUD showMessage:NetRequest_ConnectError];
        if (self.items.count == 0) {
            self.tableView.mj_footer.hidden = YES;
            [self.tableView emptyViewWithError:NetRequest_noNetWork];
        }
        return;
    }
    
    // page == 0 时清空数据
    if (self.page == 0) {
        [self.items removeAllObjects];
    }

    //解析字典
    NSDictionary *result = response[@"result"];
    NSArray *items = [InvitationRecordItem  mj_objectArrayWithKeyValuesArray:result[@"items"]];
    [self.items addObjectsFromArray:items];

    // mj_footer 状态变化
    NSInteger count = [result[@"count"] integerValue] ;
    if (self.items.count == count) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.tableView.mj_footer resetNoMoreData];
    }
 
    //表格状态变化
    if (self.items.count == 0) {
        self.tableView.mj_footer.hidden = YES;
        [self.tableView emptyViewWithError:@"当前数据为空"];
    }else{
        self.tableView.mj_footer.hidden = NO;
        [self.tableView emptyViewWithHiden:YES];
    }
    
    [self.tableView reloadData];
}


- (void)makeMoreData{
    self.page++;
    [self.parameters setValue:@(self.page) forKey:KEY_PAGE];
    [self makeData];
}

#pragma mark :  UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WeakSelf;
    InvitationRecordsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InvitationRecordsCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = (indexPath.row % 2) ? XCOLOR(239, 242, 245, 1) : XCOLOR_WHITE;
    cell.cellBlock = ^(NSString *detail_id){
        [weakSelf caseDetailWithId:detail_id];
    };
    cell.item = self.items[indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
 
    return   [UIView new];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
 
    return   Bundle(@"InvitationRecordsHeader");
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (void)caseDetailWithId:(NSString *)detail_id{
 
    InvitationRecordDetailVC *vc = [[InvitationRecordDetailVC alloc] init];
    vc.no_id = detail_id;
    PushToViewController(vc);
}

- (void)dealloc{
    
    KDClassLog(@"邀请记录 + InvitationRecordsVC + dealloc");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
