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
#import "RoomAppointmentVC.h"
#import "RoomCityVC.h"
#import "HomeRoomSearchVC.h"
#import "RoomItemDetailVC.h"
#import "HomeRoomIndexFlatsObject.h"
#import "MyoffferAlertTableView.h"
#import "MeiqiaServiceCall.h"
#import "RoomMapVC.h"

@interface RoomSearchResultVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)MyoffferAlertTableView *tableView;
@property(nonatomic,strong)RoomSearchFilterVC *searchFilter;
@property(nonatomic,strong)RoomSearchFilterView *filterView;
@property(nonatomic,strong)NSMutableArray *items;
@property(nonatomic,assign)NSInteger next_page;
@property(nonatomic,strong)NSMutableDictionary *parameter;
@property(nonatomic,strong)UIButton *mapBtn;

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
    
    [self makeParameters];
    [self makeNavigationView];
    [self makeTableView];
 
    UIButton *mapBtn =[[UIButton alloc] initWithFrame:CGRectMake(XSCREEN_WIDTH - 85, XSCREEN_HEIGHT - 180, 70, 70)];
    [mapBtn setImage:XImage(@"home_room_map_anchor") forState:UIControlStateNormal];
    [self.view addSubview:mapBtn];
    [mapBtn addTarget:self action:@selector(caseMap) forControlEvents:UIControlEventTouchUpInside];
    self.mapBtn = mapBtn;
}

- (void)makeParameters{
    
    [self makeDefalutParameter];

    if (self.item) {
        [self.parameter setValue: self.item.type forKey:KEY_TYPE];
        [self.parameter setValue: self.item.item_id forKey:KEY_TYPE_ID];
    }
    if (self.city) {
        NSDictionary *parameterItem = @{ KEY_TYPE:@"city",KEY_TYPE_ID:self.city.city_id};
        [self.parameter addEntriesFromDictionary:parameterItem];
    }
    
}

- (void)makeNavigationView{
 
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
    
    
    UIImage *icon = XImage(@"back_arrow_black");
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:icon style:UIBarButtonItemStyleDone target:self action:@selector(casePop)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:XImage(@"maiqia_call") style:UIBarButtonItemStyleDone target:self action:@selector(caseMeiqia)];

}

- (void)makeTableView
{
    self.tableView =[[MyoffferAlertTableView alloc] initWithFrame:self.view.bounds  style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.estimatedRowHeight = 328;//很重要保障滑动流畅性
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = XCOLOR_WHITE;
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
    self.filterView = filterView;
    if (self.city) {
        filterView.city = self.city.name_cn;
    }
    CGFloat high = filterView.mj_h;
    self.tableView.contentInset = UIEdgeInsetsMake(high, 0, 1.7*high, 0);
    
    self.tableView.actionBlock = ^{
        [weakSelf makeData];
    };

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
    [self.parameter setValue:[NSString stringWithFormat:@"%ld",self.next_page] forKey:KEY_PAGE];
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
    [self.parameter setValue:[NSString stringWithFormat:@"%ld",self.next_page] forKey:KEY_PAGE];
    WeakSelf;
    [self property_listWhithParameters:self.parameter additionalSuccessAction:^(id response, int status) {
        [weakSelf updateUIWithResponse:response];
    } additionalFailureAction:^(NSError *error, int status) {
        if (weakSelf.items.count == 0) {
            [weakSelf.tableView alertWithRoloadMessage:nil];
        }
    }];
    
}


- (void)updateUIWithResponse:(id)response{
    
    [self.tableView alertViewHiden];
    
    NSDictionary *result = (NSDictionary *)response;
//    NSString *total_page = result[@"total_page"];
//    NSString *current_page = result[@"current_page"];
    NSString *unit = result[@"unit"];
    NSArray *properties  = result[@"properties"];
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
    if (properties.count == 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    [self.tableView reloadData];
    
    if (self.next_page == 1 && self.items.count > 0) {
        [self.tableView  scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    self.next_page += 1;
    
    if (self.items.count == 0) {
        [self.tableView alertWithNotDataMessage:nil];
    }
    
}

#pragma mark : 事件处理

- (void)makeDefalutParameter{
    
    self.next_page = 1;
    [self.parameter removeAllObjects];
    [self.parameter setValue:@"10" forKey:KEY_PAGESIZE];
}


- (void)caseMeiqia{
    
    [MeiqiaServiceCall callWithController:self];
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
    vc.actionBlock = ^(NSString *type_id,NSString *city_name) {
        [weakSelf caseCity:type_id name:city_name];
    };
    PushToViewController(vc);
}

- (void)caseCity:(NSString *)type_id name:(NSString *)name{
    
    [self makeDefalutParameter];
    [self.parameter setValue:@"city" forKey:KEY_TYPE];
    [self.parameter setValue:type_id forKey:KEY_TYPE_ID];
    [self.items removeAllObjects];
    [self.tableView reloadData];
    self.filterView.city = name;
    [self makeData];
}

- (void)casePrice{

}

- (void)caseMap{
    
    RoomMapVC *vc = [[RoomMapVC alloc] init];
    vc.isUK = YES;
    PushToViewController(vc);
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self caseSearch];
    return NO;
}

- (void)caseSearch{
    
    HomeRoomSearchVC *vc = [[HomeRoomSearchVC alloc] init];
    MyOfferWhiteNV *nav = [[MyOfferWhiteNV alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
    WeakSelf
    vc.actionBlock = ^(RoomSearchResultItemModel *item) {
        [weakSelf caseSearchResultWithItem:item];
    };
}

- (void)caseSearchResultWithItem:(RoomSearchResultItemModel *)item{
    
    self.item = item;
    self.city = nil;
    self.filterView.city = nil;
    self.next_page = 1;
    [self.items removeAllObjects];
    [self.tableView reloadData];
    [self makeParameters];
    [self makeData];
}


//筛选
- (void)caseFilter:(NSDictionary *)parameter{
    
    [self makeParameters];
    [self.parameter addEntriesFromDictionary:parameter];
    self.next_page = 1;
    [self.tableView reloadData];
    [self makeData];
}

- (void)casePop{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)dealloc
{
    KDClassLog(@" 51ROOM筛选页 + RoomSearchResultVC + dealloc");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
