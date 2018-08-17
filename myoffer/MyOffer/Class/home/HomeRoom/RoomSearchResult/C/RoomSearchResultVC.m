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

@interface RoomSearchResultVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)MyOfferTableView *tableView;
@property(nonatomic,strong)RoomSearchFilterVC *searchFilter;

@end

@implementation RoomSearchResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self makeUI];
}

- (RoomSearchFilterVC *)searchFilter{
    
    if (!_searchFilter) {
        
        _searchFilter = [[RoomSearchFilterVC alloc] init];
        _searchFilter.view.frame = CGRectMake(0, 0, XSCREEN_WIDTH, XSCREEN_HEIGHT);
        [[UIApplication sharedApplication].keyWindow addSubview:_searchFilter.view];
    }
    
    return _searchFilter;
}

- (void)makeUI{
    
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
    [searchTF addTarget:self action:@selector(caseSearch:) forControlEvents:UIControlEventTouchDown];
}

- (void)makeTableView
{
    self.tableView =[[MyOfferTableView alloc] initWithFrame:self.view.bounds  style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.estimatedRowHeight = 150;//很重要保障滑动流畅性
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    WeakSelf
    RoomSearchFilterView *filterView = [[RoomSearchFilterView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, 40)];
    filterView.RoomSearchFilterViewBlock = ^(RoomFilterType type){
        [weakSelf caseParameterType:type];
    };
    [self.view addSubview:filterView];
    self.tableView.contentInset = UIEdgeInsetsMake(filterView.mj_h, 0, XTabBarHeight, 0);
}

#pragma mark :  UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return   10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *class_name = @"RoomSearchCell";
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:class_name];
    if (!cell) {
        cell = Bundle(class_name);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
 
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return   UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RoomItemDetailVC *vc = [[RoomItemDetailVC alloc] init];
    PushToViewController(vc);
}


#pragma mark : 事件处理
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
    
    RoomCityVC *vc = [[RoomCityVC alloc] init];
    PushToViewController(vc);
}

- (void)casePrice{

}

- (void)caseSearch:(UITextField *)textField{
    
    HomeRoomSearchVC *vc = [[HomeRoomSearchVC alloc] init];
    vc.actionBlock = ^(NSString *value) {
        NSLog(@"搜索返回结果，再次网络请求！！！%@",value);
    };
    MyOfferWhiteNV *nav = [[MyOfferWhiteNV alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:^{
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
