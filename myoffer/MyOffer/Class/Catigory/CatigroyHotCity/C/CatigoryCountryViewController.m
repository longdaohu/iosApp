//
//  CatigoryCountryViewController.m
//  MyOffer
//
//  Created by xuewuguojie on 2017/10/13.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "CatigoryCountryViewController.h"
#import "CatigaryCountry.h"
#import "CatigaryHotCity.h"
#import "HomeSectionHeaderView.h"
#import "CatigaryHotCityCell.h"
#import "SearchUniversityCenterViewController.h"
#import "CountryStateViewController.h"

@interface CatigoryCountryViewController ()<UITableViewDelegate,UITableViewDataSource>
//热门城市数组
@property(nonatomic,strong)NSArray  *country_Hotes;
//热门城市collectionView
@property(nonatomic,strong)UITableView *city_tableView;

@end

@implementation CatigoryCountryViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
    
    [self makeDataSource];
}

//获取热门城市数组
-(void)makeDataSource{
    
    XWeakSelf
    [self startAPIRequestUsingCacheWithSelector:kAPISelectorCatigoryHotCities parameters:nil success:^(NSInteger statusCode, id response) {
        
        [weakSelf updateCityUIWithResponse:response];
        
    }];
    
}

//更新热门留学目的地
- (void)updateCityUIWithResponse:(id)response{
    
    self.country_Hotes =[CatigaryCountry mj_objectArrayWithKeyValuesArray:response[@"hot"]];
    
    for (CatigaryCountry *country in self.country_Hotes) {
        
        //给每组添加最后一个数据
        CatigaryHotCity *last_city = [[CatigaryHotCity alloc] init];
        last_city.country = country.country;
        
        NSString *imageName = @"nzl_more.jpg";
        if ([country.country containsString:@"英"]) imageName = @"uk_more.jpg";
        if ([country.country containsString:@"美"]) imageName = @"usa_more.jpg";
        if ([country.country containsString:@"澳"]) imageName = @"ao_more.jpg";
        
        last_city.imageName = imageName;
        
        [country.hot_cities addObject:last_city];
    }
    
    [self.city_tableView reloadData];
}

//热门城市
- (void)makeUI{
    
    self.city_tableView =[self tableViewWithUITableViewStyle:UITableViewStyleGrouped frame:self.view.bounds];
    self.city_tableView .estimatedSectionFooterHeight = 0;
    self.city_tableView .estimatedSectionHeaderHeight = 0;
    self.city_tableView.contentInset = UIEdgeInsetsMake(0, 0, 50 + XNAV_HEIGHT, 0);
    [self.view addSubview:self.city_tableView];
    
}

- (UITableView *)tableViewWithUITableViewStyle:(UITableViewStyle)type frame:(CGRect)frame{
    
    UITableView *tableView =[[UITableView alloc] initWithFrame:frame style:type];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView =[[UIView alloc] init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return tableView;
}


#pragma mark : UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return  self.country_Hotes.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

static NSString *rankIdentify = @"rankStyle";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CatigaryHotCityCell *cell =[CatigaryHotCityCell cellInitWithTableView:tableView];
    
    CatigaryCountry *country  = self.country_Hotes[indexPath.section];
    
    cell.hot_cities = country.hot_cities;
    
    [cell bottomLineShow: (self.country_Hotes.count - 1) != indexPath.section];
    
    cell.actionBlock = ^(NSString *city){
        
        //设置一个更多城市，城市名称为空，城市名称是否为空，做为跳转判断的标准
        city ? [self CaseHotCityWithCityName:city belongCountry:country.country] :  [self CaseStateWithSection:indexPath.section];
        
    };
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section; {
    
    NSString *title;
    if (tableView == self.city_tableView) {
        
        CatigaryCountry *group = self.country_Hotes[section];
        title = group.country;
    }
    
    HomeSectionHeaderView *SectionView =[HomeSectionHeaderView sectionHeaderViewWithTitle:title];
    SectionView.backgroundColor = XCOLOR_WHITE;
    [SectionView arrowButtonHiden:!(tableView == self.city_tableView)];
    SectionView.actionBlock = ^{
        
        [self CaseStateWithSection:section];
    };
    
    
    return SectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return tableView == self.city_tableView ? FLOWLAYOUT_CityW + 20 : 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return (tableView == self.city_tableView ) ?  Section_header_Height_nomal : 12;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return HEIGHT_ZERO;
}


#pragma mark : 事件处理

//热门留学城市
-(void)CaseHotCityWithCityName:(NSString *)CityName belongCountry:(NSString *)country
{
    
    
    SearchUniversityCenterViewController *vc = [[SearchUniversityCenterViewController alloc] initWithKey:KEY_CITY value:CityName country:country];
    
    [self.navigationController pushViewController:vc animated:YES];
}


//英国、澳大利亚地区列表
-(void)CaseStateWithSection:(NSInteger)section{
    
    CatigaryCountry *country = self.country_Hotes[section];
    
    CountryStateViewController *country_state= [[CountryStateViewController alloc] init];
    
    country_state.countryName = country.country;
    
    [self.navigationController pushViewController:country_state animated:YES];
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
