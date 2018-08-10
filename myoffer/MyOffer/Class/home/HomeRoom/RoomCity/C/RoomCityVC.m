//
//  RoomCityVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/10.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RoomCityVC.h"
#import "HomeSecView.h"
#import "HttpApiClient_API_51ROOM.h"
#import "HttpsApiClient_API_51ROOM.h"
#import "RoomCityModel.h"

@interface RoomCityVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,copy)NSString *current_country;
@property(nonatomic,strong)NSArray *groups_uk;
@property(nonatomic,strong)NSArray *groups_au;
@property(nonatomic,strong)NSArray *groups;
@property(nonatomic,strong)NSArray *index_keys;

@end

@implementation RoomCityVC
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NavigationBarHidden(NO);
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
}

- (void)makeUI{

    self.title = @"城市";
    self.current_country = @"澳大利亚";
    self.view.backgroundColor = XCOLOR_BG;
    [self makeTableView];
    [self makeData];
    
    
}

- (void)makeTableView
{
    self.tableView =[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
    [self.view addSubview:self.tableView];

    self.tableView.estimatedRowHeight = 200;//很重要保障滑动流畅性
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.sectionHeaderHeight = 40;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, XNAV_HEIGHT, 0);
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.tableView setSectionIndexBackgroundColor: XCOLOR_CLEAR];
    [self.tableView setSectionIndexColor:XCOLOR_TITLE];
}

#pragma mark :  UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    myofferGroupModel *group = self.groups[section];
    
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
    myofferGroupModel *group = self.groups[indexPath.section];
    RoomCityModel *city = group.items[indexPath.row];
    cell.textLabel.text = city.cityName;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HomeSecView *header = [[HomeSecView alloc] init];
    header.leftMargin = 20;
    header.backgroundColor = XCOLOR_BG;
    header.group = self.groups[section];
 
    return header;
}

// 索引目录
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.index_keys;
}

#pragma mark : 数据处理
- (void)makeData{
 
 
    WeakSelf
    if ([self.current_country isEqualToString:@"英国"]) {
        
        
        if (self.groups_uk.count > 0) {
            self.groups = self.groups_uk;
            return;
        }
 
        [[HttpsApiClient_API_51ROOM instance] cities:0 completionBlock:^(CACommonResponse *response) {
            
            NSString *status = [NSString stringWithFormat:@"%d",response.statusCode];
            if (![status isEqualToString:@"200"]) {
                NSLog(@" 网络请求错误 ");
                return ;
            }
            id result = [response.body KD_JSONObject];
            [weakSelf updateUIWithResponse:result country:@"英国"];
        }];
    }else{
        
        if (self.groups_au.count > 0) {
            self.groups = self.groups_au;
            return;
        }
        
        [[HttpsApiClient_API_51ROOM instance] cities:4 completionBlock:^(CACommonResponse *response) {
            
            NSString *status = [NSString stringWithFormat:@"%d",response.statusCode];
            if (![status isEqualToString:@"200"]) {
                NSLog(@" 网络请求错误 ");
                return ;
            }
            id result = [response.body KD_JSONObject];
            
            [weakSelf updateUIWithResponse:result country:@"澳大利亚"];
        }];
    }
 
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
    
    if ([country isEqualToString:@"uk"]) {
        
        self.groups_uk =  [groups_temp mutableCopy];
        self.groups = self.groups_uk;
        
    }else{
        
        self.groups_au =  [groups_temp mutableCopy];
        self.groups = self.groups_au;
    }
    
     NSArray *index_keys = [self.groups valueForKey:@"header_title"];
    self.index_keys = index_keys;
    if ([self.current_country  isEqualToString:country]){
        [self.tableView reloadData];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
