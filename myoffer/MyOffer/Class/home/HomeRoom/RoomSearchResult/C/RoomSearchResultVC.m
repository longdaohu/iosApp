//
//  RoomSearchResultVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/7/30.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RoomSearchResultVC.h"
#import "RoomSearchCell.h"
#import "RoomSearchFilterView.h"
#import "RoomSearchFilterVC.h"
#import "RoomItemBookVC.h"
#import "RoomAppointmentResultVC.h"
#import "RoomAppointmentVC.h"
#import "RoomCityVC.h"
#import "HomeRoomSearchVC.h"
#import "RoomItemDetailVC.h"
#import "HttpsApiClient_API_51ROOM.h"
#import "HomeRoomIndexFlatsObject.h"

@interface RoomSearchResultVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)MyOfferTableView *tableView;
@property(nonatomic,strong)RoomSearchFilterVC *searchFilter;
@property(nonatomic,strong)NSMutableArray *items;
@property(nonatomic,assign)NSInteger next_page;
@property(nonatomic,strong)NSMutableDictionary *parameter;
@property(nonatomic,strong)UIView *header;
@end

@implementation RoomSearchResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self makeUI];
    [self makeData];
}

- (RoomSearchFilterVC *)searchFilter{
    
    if (!_searchFilter) {
        
        _searchFilter = [[RoomSearchFilterVC alloc] init];
        _searchFilter.view.frame = CGRectMake(0, 0, XSCREEN_WIDTH, XSCREEN_HEIGHT);
        [[UIApplication sharedApplication].keyWindow addSubview:_searchFilter.view];
        WeakSelf;
        _searchFilter.actionBlock = ^(NSDictionary *parameter) {
            [weakSelf caseFilter:parameter];
        };
    }
    
    return _searchFilter;
}

- (NSMutableDictionary *)parameter{
    
    if (!_parameter) {
        _parameter = [NSMutableDictionary dictionary];
    }
    
    return _parameter;
}

- (NSMutableArray *)items{
    
    if (!_items) {
        _items = [NSMutableArray array];
    }
    
    return _items;
}

- (void)makeUI{
    
    [self makeDefalutParameter];
    
    if (self.item) {
        [self.parameter setValue: self.item.type forKey:@"type"];
        [self.parameter setValue: self.item.item_id forKey:@"type_id"];
    }
    [self makeNavigationView];
    [self makeTableView];
}

- (void)makeNavigationView{
 
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:XImage(@"maiqia_call") style:UIBarButtonItemStyleDone target:self action:@selector(caseMeiqia)];
    
    UITextField *searchTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH , 26)];
    searchTF.font = XFONT(10);
    searchTF.backgroundColor = XCOLOR(243, 246, 249, 1);
    searchTF.layer.cornerRadius = 13;
    searchTF.layer.masksToBounds = YES;
    searchTF.placeholder = @"输入关键字搜索城市，大学，公寓";
    self.navigationItem.titleView = searchTF;
    searchTF.clearButtonMode =  UITextFieldViewModeAlways;
    
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 13)];
    leftView.contentMode = UIViewContentModeScaleAspectFit;
    [leftView setImage:XImage(@"home_application_search_icon")];
    searchTF.leftView = leftView;
    searchTF.leftViewMode =  UITextFieldViewModeUnlessEditing;
    searchTF.delegate = self;
    
}

- (void)makeTableView
{
    self.tableView =[[MyOfferTableView alloc] initWithFrame:self.view.bounds  style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.estimatedRowHeight = 328;//很重要保障滑动流畅性
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    WeakSelf
    RoomSearchFilterView *filterView = [[RoomSearchFilterView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, 40)];
    filterView.RoomSearchFilterViewBlock = ^(RoomFilterType type){
        [weakSelf caseParameterType:type];
    };
    [self.view addSubview:filterView];
    CGFloat high = filterView.mj_h;
    self.tableView.contentInset = UIEdgeInsetsMake(high, 0, 1.5*high, 0);

}

- (UIView *)header{
    
    if (!_header) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, 30)];
        header.backgroundColor = XCOLOR_WHITE;
        _header = header;
    }
   return  _header;
}


#pragma mark :  UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return   self.items.count;
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *class_name = @"RoomSearchCell";
    RoomSearchCell *cell  = [tableView dequeueReusableCellWithIdentifier:class_name];
    if (!cell) {
        cell = Bundle(class_name);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.item = self.items[indexPath.row];
 
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return   UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HomeRoomIndexFlatsObject *room = self.items[indexPath.row];
    
    RoomItemDetailVC *vc = [[RoomItemDetailVC alloc] init];
    vc.room_id = room.no_id;
    PushToViewController(vc);
}

#pragma mark : 数据请求

- (void)loadMoreData{
    
    [self makeData];
    [self.parameter setValue:[NSString stringWithFormat:@"%ld",self.next_page] forKey:@"page"];
}

- (void)makeData{
    /*
     page    Int     = 1
     pagesize    int    =10
     type    string    City, university
     type_id    string    19
     max    string    租金区间 最多
     min    srting    租金区间 最少
     lease    Int     最大租期，租多少周  如：52
     */
    [self.parameter setValue:[NSString stringWithFormat:@"%ld",self.next_page] forKey:@"page"];
    WeakSelf;
    [[HttpsApiClient_API_51ROOM instance] property_listWhithParameters:self.parameter  completionBlock:^(CACommonResponse *response) {

                NSString *status = [NSString stringWithFormat:@"%d",response.statusCode];
                if (![status isEqualToString:@"200"]) {
                    NSLog(@"property_listWhithParameters 网络请求错误 ");
                    return ;
                }
                id result = [response.body KD_JSONObject];
                [weakSelf updateUIWithResponse:result];
    }];
}


- (void)updateUIWithResponse:(id)response{
    
    NSDictionary *result = (NSDictionary *)response;
    NSString *total_page = result[@"total_page"];
    NSString *current_page = result[@"current_page"];
    NSString *unit = result[@"unit"];
    NSArray *properties  = result[@"properties"];
    
    if (self.next_page == 1) {
        self.tableView.tableHeaderView = self.header;
        [self.tableView setContentOffset:CGPointMake(0, -self.header.mj_h) animated:YES];
    }
    if (self.items.count > 0 && self.next_page == 1) {
        [self.items removeAllObjects];
    }
 
    NSArray *items  = [HomeRoomIndexFlatsObject  mj_objectArrayWithKeyValuesArray:properties];
    [items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HomeRoomIndexFlatsObject *it = (HomeRoomIndexFlatsObject *)obj;
        it.unit = unit;
    }];
    
    [self.items addObjectsFromArray:items];
    
    [self.tableView.mj_footer endRefreshing];
    if (total_page.integerValue <= current_page.integerValue) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    self.next_page += 1;
    
    [self.tableView reloadData];
}

#pragma mark : 事件处理

- (void)makeDefalutParameter{
    
    self.next_page = 1;
    [self.parameter removeAllObjects];
    [self.parameter setValue:@"5" forKey:@"pagesize"];
}


- (void)caseMeiqia{

    
}

- (void)caseParameterType:(RoomFilterType)type{
    
    switch (type) {
        case RoomFilterTypeCity:
            [self caseCity];
            break;
        case RoomFilterTypePrice:
            [self casePrice];
            break;
        default:
            [self.searchFilter show];
            break;
    }
}

- (void)caseCity{
    
    WeakSelf
    RoomCityVC *vc = [[RoomCityVC alloc] init];
    vc.actionBlock = ^(NSString *type_id) {
        [weakSelf caseCity:type_id];
    };
    PushToViewController(vc);
}

- (void)caseCity:(NSString *)type_id{
    
    [self makeDefalutParameter];
    [self.parameter setValue:@"city" forKey:@"type"];
    [self.parameter setValue:type_id forKey:@"type_id"];
    [self makeData];
}

- (void)casePrice{

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [self.navigationController popViewControllerAnimated:YES];

    return NO;
}
//- (void)caseSearch:(UITextField *)textField{
//    HomeRoomSearchVC *vc = [[HomeRoomSearchVC alloc] init];
//    vc.actionBlock = ^(NSString *value) {
//        NSLog(@"搜索返回结果，再次网络请求！！！%@",value);
//    };
//    MyOfferWhiteNV *nav = [[MyOfferWhiteNV alloc] initWithRootViewController:vc];
//    [self presentViewController:nav animated:YES completion:^{
//    }];
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)caseFilter:(NSDictionary *)parameter{
    
    [self.parameter addEntriesFromDictionary:parameter];
    self.next_page = 1;
    [self makeData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
