//
//  RoomCityVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/10.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RoomCityVC.h"
#import "HomeSecView.h"
#import "HttpsApiClient_API_51ROOM.h"
#import "RoomCityModel.h"
#import "HomeRoomSearchCountryView.h"
#import "RoomCountryModel.h"
#import "RoomSearchResultVC.h"
#import "MyoffferAlertTableView.h"

static const NSInteger UK_CODE = 0;
static const NSInteger AU_CODE = 4;

@interface RoomCityVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)HomeRoomSearchCountryView *countryView;
@property(nonatomic,strong)UIButton *countyBtn;
@property(nonatomic,strong)RoomCountryModel *countryModel;
@property(nonatomic,strong)MyoffferAlertTableView *tableView;

@end

@implementation RoomCityVC


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"page51Room城市切换"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"page51Room城市切换"];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self makeUI];
    [self makeData];
}

- (RoomCountryModel *)countryModel{
    if (!_countryModel) {
        _countryModel = [[RoomCountryModel alloc] init];
    }
    return _countryModel;
}

- (HomeRoomSearchCountryView *)countryView{
    
    if (!_countryView) {
        
        WeakSelf
        _countryView = [[HomeRoomSearchCountryView alloc] initWithFrame:self.view.bounds];
        _countryView.actionBlock = ^(NSDictionary *item) {
            [weakSelf caseChangeCountry:item];
        };
        [self.view addSubview:_countryView];
    }
    
    return _countryView;
}

- (void)makeUI{
 
    [self makeTableView];
    self.title = @"城市";
    
    UIView *left_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left_view];
    UIButton *one = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [one setImage:XImage(@"home_room_uk") forState:UIControlStateNormal];
    [left_view addSubview:one];
    self.countyBtn = one;
    [one addTarget:self action:@selector(countryOnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *two = [[UIButton alloc] initWithFrame:CGRectMake(30, 0, 15, 30)];
    two.contentMode = UIViewContentModeScaleAspectFit;
    [two setImage:XImage(@"Trp_Black_Down") forState:UIControlStateNormal];
    [two addTarget:self action:@selector(countryOnClick) forControlEvents:UIControlEventTouchUpInside];
    [left_view addSubview:two];
    
}

- (void)makeTableView
{
    
    self.tableView =[[MyoffferAlertTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.tableFooterView =[[UIView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 200;//很重要保障滑动流畅性
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight= UITableViewAutomaticDimension;
    self.tableView.sectionHeaderHeight = 40;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.sectionFooterHeight = HEIGHT_ZERO;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, XTabBarHeight, 0);
    [self.tableView setSectionIndexBackgroundColor: XCOLOR_CLEAR];
    [self.tableView setSectionIndexColor:XCOLOR_TITLE];
    self.tableView.backgroundColor = XCOLOR_BG;

}

#pragma mark :  UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.countryModel.group.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    myofferGroupModel *group = self.countryModel.group[section];
    
    return group.items.count;
}

static NSString *identify = @"RoomCityModel";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.tintColor = XCOLOR_TITLE;
        cell.textLabel.font = XFONT(12);
    }
    
    myofferGroupModel *group = self.countryModel.group[indexPath.section];
    RoomCityModel *city = group.items[indexPath.row];
    cell.textLabel.text = city.cityName;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    myofferGroupModel *group = self.countryModel.group[indexPath.section];
    RoomCityModel *city = group.items[indexPath.row];
    if (self.actionBlock) {
        self.actionBlock(city.item_id,city.name_cn);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HomeSecView *header = [[HomeSecView alloc] init];
    header.leftMargin = 20;
    header.backgroundColor = XCOLOR_BG;
    header.group = self.countryModel.group[section];
 
    return header;
}
// 索引目录
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.countryModel.titles;
}

#pragma mark : 数据处理
- (void)makeData{
  
    [self makeDataWithCountry:AU_CODE  hub:NO];
    [self makeDataWithCountry:UK_CODE  hub:YES];
}

- (void)makeDataWithCountry:(NSInteger)code hub:(BOOL)hub{
    
    NSString *country = (code == 0) ? KEY_UK : KEY_AU;
    WeakSelf
    [self cities:code showHUD:hub additionalSuccessAction:^(id response, int status) {
        [weakSelf updateUIWithResponse:response country:country];
    } additionalFailureAction:^(NSError *error, int status) {
        [weakSelf.tableView alertWithNetworkFailure];
    }];
}

- (void)updateUIWithResponse:(id)response country:(NSString *)country{
    
    NSDictionary *result = (NSDictionary *)response;
     NSArray *keys = [result.allKeys sortedArrayUsingComparator:^NSComparisonResult/*代码块返回值类型*/(id obj1, id obj2){
          return [obj1 compare:obj2];
     }];
    NSMutableArray *groups_temp = [NSMutableArray array];
    for (NSString *key in keys) {
        NSArray *values = result[key];
        if (values.count > 0) {
            NSArray *items = [RoomCityModel mj_objectArrayWithKeyValuesArray:values];
            myofferGroupModel *group = [myofferGroupModel groupWithItems:items header:key];
            [groups_temp addObject:group];
         }
    }
    if ([country isEqualToString:KEY_UK]) {
        self.countryModel.uk = [groups_temp mutableCopy];
    }else{
        self.countryModel.au = [groups_temp mutableCopy];
    }
    
    if ([self.countryModel.current  isEqualToString:country]){
        
        if (self.countryModel.group.count == 0) {
            [self.tableView  alertWithNotDataMessage:nil];
        }else{
            [self.tableView alertViewHiden];
        }
        [self.tableView reloadData];
    }
}

#pragma mark : 事件处理

- (void)countryOnClick{
    
    if (self.countryView.coverIsHiden) {
        [self.countryView show];
    }else{
        [self.countryView hide];
    }
}

- (void)caseChangeCountry:(NSDictionary *)item{
    
    NSString *name = item[@"name"];
    NSString *icon = item[@"icon"];
    if ([self.countryModel.current isEqualToString:name]) {
        return;
    }
    self.countryModel.current = name;
    [self.countyBtn setImage:XImage(icon) forState:UIControlStateNormal];
 
    if (self.countryModel.group.count > 0) {
        [self.tableView reloadData];
        return;
    }
    
    if ([name isEqualToString:KEY_UK]) {
        [self makeDataWithCountry:UK_CODE hub:YES];
    }else{
        [self makeDataWithCountry:AU_CODE hub:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)dealloc{
    
    KDClassLog(@"51Room城市选择 + RoomCityVC + dealloc");
}

@end
