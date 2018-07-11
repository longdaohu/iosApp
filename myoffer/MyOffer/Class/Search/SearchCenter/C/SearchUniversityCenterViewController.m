//
//  SearchUniversityCenterViewController.m
//  MyOffer
//
//  Created by xuewuguojie on 2017/4/25.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "SearchUniversityCenterViewController.h"
#import "MyOfferUniversityModel.h"
#import "UniversityCourseCell.h"
#import "ApplySectionHeaderView.h"
#import "searchSectionFootView.h"
#import "UniversitySubjectListViewController.h"
#import "SearchUniCenterFilterVController.h"
#import "MyOfferCountry.h"
#import "MyOfferCountryState.h"
#import "MyOfferRank.h"
#import "SearchPromptView.h"
#import "SearchUniCourseFrame.h"


#define KEY_TEXT_S  @"text"
#define KEY_NAME_S  @"name"
#define KEY_VALUE_S  @"value"
#define KEY_FILTERS_S  @"filters"
#define KEY_SIZE_S  @"size"
#define KEY_DESC_S  @"desc"
#define KEY_ORDER_S  @"order"

@interface SearchUniversityCenterViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)MyOfferTableView *tableView;
//网络请求参数
@property(nonatomic,strong)NSMutableDictionary *parametersM;
//数组模型
@property(nonatomic,strong)NSMutableArray *UniFrames;
//下一页
@property(nonatomic,assign)NSInteger nextPage;
//是否到最后一条数据
@property(nonatomic,assign)BOOL endPage;
//搜索关键字
@property(nonatomic,copy)NSString *searchValue;
//当前排名方式
@property(nonatomic,copy)NSString *currentRankType;
//筛选工具
@property(nonatomic,strong)SearchUniCenterFilterVController *filter;
//所有国家地区数组
@property(nonatomic,strong)NSArray *countries;
//加载新数据提示框
@property(nonatomic,strong)SearchPromptView *promptView;

@end

@implementation SearchUniversityCenterViewController

- (instancetype)initWithSearchValue:(NSString *)searchValue{

    
    self = [self init];
    
    if (self) {
 
        self.currentRankType = RANK_QS;
        [self.parametersM setValue:searchValue forKey:KEY_TEXT_S];
        [self.parametersM setValue:self.currentRankType forKey:KEY_ORDER_S];
        self.searchValue = searchValue;
        self.title = self.searchValue;
        
    }
    
    
    return self;
}

- (instancetype)initWithKey:(NSString *)key value:(NSString *)value{

    self = [self init];
    
    if (self) {
        
        [self parameterWithKey:key value:value country:nil];
        
    }
    
    return self;
}

- (void)parameterWithKey:(NSString *)key value:(NSString *)value country:(NSString *)country{

    NSString *rankType = RANK_QS;
    
    if ([key isEqualToString:KEY_CITY] || [key isEqualToString:KEY_STATE] || [key isEqualToString:KEY_COUNTRY] ) {
        
        rankType = RANK_TI;
    }
    
    self.currentRankType = rankType;
    
    NSArray *filters;
    if (country) {
        
        self.coreCountry = country;
        
        filters = @[ @{KEY_NAME_S : key, KEY_VALUE_S:value} , @{KEY_NAME_S: KEY_COUNTRY,KEY_VALUE_S:country}];
        
    }else{
    
        filters = @[@{KEY_NAME_S : key, KEY_VALUE_S:value}];
    }
    
    [self.parametersM setValue:filters forKey:KEY_FILTERS_S];
    [self.parametersM setValue:rankType forKey:KEY_ORDER_S];
    self.title = value;
    
    
    if ([key isEqualToString:KEY_COUNTRY]) self.coreCountry =  value;
    if ([key isEqualToString:KEY_STATE])   self.coreState =  value;
    if ([key isEqualToString:KEY_CITY])    self.coreCity =  value;
    if ([key isEqualToString:KEY_AREA])    self.coreArea=  value;
    if ([key isEqualToString:KEY_SUBJECT]) self.coreSubject =  value;

}

- (instancetype)initWithKey:(NSString *)key value:(NSString *)value country:(NSString *)country{

    self = [self init];
    
    if (self) {
        
        [self parameterWithKey:key value:value country:country];
        
    }
    
    return self;
}





-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"page搜索结果"];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page搜索结果"];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeUI];
    //1、 确保先请求网络参数
    [self makeParameterDesc];
    //2、 再请求网络
    [self makeDataSource];
}

- (NSMutableDictionary *)parametersM{

    if (!_parametersM) {
        
        NSDictionary *parameter = @{
                                    KEY_PAGE: @0,
                                    KEY_SIZE: @20,
                                    KEY_DESC_S: @0,
                                    };
 
        _parametersM =  [NSMutableDictionary dictionaryWithDictionary:parameter];
        
    }
    
   return  _parametersM;
}


- (NSArray *)countries{
    
    if (!_countries) {
        
        NSArray *country_temps = [[NSUserDefaults standardUserDefaults] valueForKey:@"Country_CN"];
        
        _countries = [MyOfferCountry mj_objectArrayWithKeyValuesArray:country_temps];
        
    }
    
    return _countries;
}



- (NSMutableArray *)UniFrames{

    if (!_UniFrames) {
        
        _UniFrames = [NSMutableArray array];
    }
    
    return _UniFrames;
}




- (void)makeUI{
    
    [self makeTableView];
    
    [self makeFilter];
 
}



//根据城市名称设置网络请求设置升降序

- (void)makeParameterDesc{

    //如果用关键字搜索 且已经选择了国家选项，判断国家是否是澳大利亚
    if (self.searchValue.length > 0 && self.coreCountry) {
        
        NSNumber *desc = [self.coreCountry containsString:@"澳"] && [self.currentRankType isEqualToString:RANK_TI] ? @1 : @0;
        [self.parametersM setValue:desc  forKey:KEY_DESC_S];
        
        return;
    }
    
    
    //如果用关键字搜索
    if (self.searchValue.length > 0) {
    
        [self.parametersM setValue:@0  forKey:KEY_DESC_S];
        
        [self.parametersM setValue:self.currentRankType forKey:KEY_ORDER_S];
        
        
        return;
    }
    
    
    /*
     *  升 1     5>4>3>2>1
     *  降 0     1>2>3>4>5
     */
    
    //   if(国家、城市都为空) {设置 RankType= 世界排名  desc = 降序}
    if (!self.coreCountry && !self.coreCity) {
        
        self.currentRankType = RANK_QS;
        
        [self.parametersM setValue:@0  forKey:KEY_DESC_S];
        
        [self.parametersM setValue:self.currentRankType forKey:KEY_ORDER_S];
     
        return;
        
    }
    
    
    // if(国家不为空){ 如果（国家 == 澳大利亚）&& （rankstyle == 本国排名 ）则设置  desc = 升序；否则 desc = 降序}
    if (self.coreCountry) {
        
        NSNumber *desc = [self.coreCountry containsString:@"澳"] && [self.currentRankType isEqualToString:RANK_TI] ? @1 : @0;
         [self.parametersM setValue:desc  forKey:KEY_DESC_S];
        
        return;
        
    }
    
    // if (国家为空 && 城市不为空) 先查国家再判断 升降序
    if (!self.coreCountry && self.coreCity) {
        
        NSString *country = [self makeCurrentCountryWithCity:self.coreCity];
        self.coreCountry = country;
        NSNumber *desc = [self.coreCountry containsString:@"澳"] && [self.currentRankType isEqualToString:RANK_TI] ? @1 : @0;
        [self.parametersM setValue:desc  forKey:KEY_DESC_S];
        
    }
    
}


//根据城市名称返回所在国家名称
- (NSString *)makeCurrentCountryWithCity:(NSString *)city{
    
    NSString *countyName = @"英国";
    
    for (MyOfferCountry *country in self.countries) {
        
        for (MyOfferCountryState *state in country.states) {
            
            NSArray *cities =  [state.cities valueForKeyPath:@"name"];
            
            if ([cities containsObject:self.coreCity]) {
                
                countyName = country.name;
                
                break;
            }
            
        }
    }
    
    
    return countyName;
    
}


//网络请求
- (void)makeDataSource{
    
    WeakSelf
    [self startAPIRequestWithSelector:kAPISelectorSearch parameters:self.parametersM expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:^{
        
    } additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        [weakSelf updateUIWithResponse:response];
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        if (0 == weakSelf.UniFrames.count)
        {
            [weakSelf.tableView emptyViewWithError:NetRequest_ConnectError];

        }else{
            
            [weakSelf.tableView emptyViewWithHiden:YES];
        }
        
    }];
    
    
}

#pragma mark :网络请求结果 更新UI

- (void)updateUIWithResponse:(id)response{
   

    if (0 == self.nextPage) {
        
         // contentOffset.y 没有上移时，不用回滚到顶部
        if (self.tableView.contentOffset.y > 0) [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        
        // page = 0 时，删除所有数据
        if (self.UniFrames.count > 0) [self.UniFrames removeAllObjects];
    }
 
    
    
    NSArray *universities = [MyOfferUniversityModel mj_objectArrayWithKeyValuesArray:response[@"universities"]];
    
    //当pageSize 大于请请求结果数量时，结束加载网络
    NSNumber *pageSize = [self.parametersM valueForKey:KEY_SIZE_S];
    self.endPage =  (pageSize.integerValue > universities.count);
    
    
    [universities enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UniversityFrameNew  *uniFrame = [UniversityFrameNew universityFrameWithUniverstiy:(MyOfferUniversityModel *)obj];
        [self.UniFrames addObject:uniFrame];
        
    }];
    
    
    //排名数组
    NSArray *rankTypes  =  [response valueForKeyPath:@"rankTypes"];
    NSMutableArray *rankings = [NSMutableArray array];
    for (NSString *rankType in rankTypes) {
        
         MyOfferRank *rank = [MyOfferRank rankWithName:rankType];
         [rankings addObject:rank];
     }
    self.filter.rankings = rankings;
    
    
    
    [self.tableView reloadData];

    //只有在page == 0 时，才会显示提示信息
    if (0 == self.nextPage) [self promptShowWithCount:[response valueForKeyPath:@"count"]];
    
    
    self.nextPage += 1;
    
    //当数据为空时，提示为空
    [self emptyWithArray:self.UniFrames];
}


- (void)emptyWithArray:(NSArray *)items{
    
    [self.tableView emptyViewWithHiden:!(items.count == 0)];
    
    if (items.count == 0) {
        
        [self.tableView emptyViewWithError:NetRequest_NoDATA];
        
    }else{
        
        [self.tableView emptyViewWithHiden:YES];
        
    }
}

-(void)makeTableView
{
    self.tableView =[[MyOfferTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.contentInset = UIEdgeInsetsMake(50, 0, XNAV_HEIGHT, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}


- (void)makeFilter{
    
    WeakSelf
    SearchUniCenterFilterVController *filter =[[SearchUniCenterFilterVController alloc] initWithActionBlock:^(NSArray *parameters) {
        
        [weakSelf filterWithParameter:parameters];
        
    }];
    
    [self addChildViewController:filter];
    self.filter = filter;
    
    if (self.coreCountry) filter.coreCountry =  self.coreCountry;
    if (self.coreState)   filter.coreState =  self.coreState;
    if (self.coreCity)    filter.corecity =   self.coreCity ;
    if (self.coreArea)    filter.coreArea=  self.coreArea;
    
    filter.currentRankType=  self.currentRankType;
  
    
    CGFloat base_Height = XNAV_HEIGHT + 50;
    filter.base_Height = base_Height;
    filter.view.frame = CGRectMake(0, 0, XSCREEN_WIDTH, base_Height);
    [self.view addSubview:filter.view];
    
}

//根据筛选条件设置 网络请求参数
- (void)filterWithParameter:(NSArray *)parameters{
    
    
    for (NSDictionary *para  in parameters) {
        
            [self.parametersM setValue:para.allValues.firstObject forKey:para.allKeys.firstObject];
        
             self.nextPage = 0;
        
             [self.parametersM setValue:@(self.nextPage) forKey:KEY_PAGE];
        
        
            if ([KEY_ORDER_S isEqualToString:para.allKeys.firstObject]) {
                
                self.currentRankType = para.allValues.firstObject;
            }
        
        
            
            if ([KEY_FILTERS_S isEqualToString:para.allKeys.firstObject]) {
                
                
                NSString *countryName = nil;
                NSString *cityName = nil;
                    for (NSDictionary *filter in (NSArray *)para.allValues.firstObject) {
                        
                        if ([KEY_COUNTRY isEqualToString:filter[KEY_NAME_S]]) countryName = filter[KEY_VALUE_S];
                        if ([KEY_CITY isEqualToString:filter[KEY_NAME_S]]) cityName = filter[KEY_VALUE_S];
                        
                 }
                
                
                self.coreCountry  = countryName;
                self.coreCity  = cityName;
            }
        
        
        
            [self makeParameterDesc];

    }
    
    [self makeDataSource];
}


#pragma mark : UITableViewDelegate  UITableViewDataSoure
//超出cell的bounds范围，不能显示
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.clipsToBounds = YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    UniversityFrameNew *uniFrame = self.UniFrames[section];
    
    return  uniFrame.courseFrames.count > 0 ? 60 : Section_footer_Height_nomal;
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    UniversityFrameNew *uniFrame = self.UniFrames[section];
    
    return uniFrame.cell_Height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UniversityFrameNew *uniFrame = self.UniFrames[indexPath.section];
    
    if (uniFrame.courseFrames.count > 0 ) {
        
        SearchUniCourseFrame *courseFrame = uniFrame.courseFrames[indexPath.row];
        
        return  courseFrame.cell_Height;
        
    }else{
    
        return HEIGHT_ZERO;

    }
 
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    
    WeakSelf
    UniversityFrameNew *uniFrame = self.UniFrames[section];
    
    ApplySectionHeaderView  *sectionView= [ApplySectionHeaderView sectionHeaderViewWithTableView:tableView];
    [sectionView addButtonWithHiden:YES];
    [sectionView showBottomLineHiden:!(uniFrame.courseFrames.count > 0)];
    sectionView.optionOrderBy = self.parametersM[KEY_ORDER_S];
    sectionView.uniFrame = uniFrame;
    sectionView.newActionBlock = ^(NSString *uni_id){
        
        [weakSelf.navigationController pushUniversityViewControllerWithID:uni_id animated:YES];
    };
    
    return sectionView;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    WeakSelf;
    
    UniversityFrameNew *uniFrame = self.UniFrames[section];
    
    if (uniFrame.universtiy.courses.count == 0) return nil;
 
    searchSectionFootView *sectionFooter = [searchSectionFootView footerWithUniversity:uniFrame.universtiy actionBlock:^(NSString *universityID) {
        
        [weakSelf.navigationController pushViewController:[[UniversitySubjectListViewController alloc] initWithUniversityID:universityID] animated:YES];
        
    }];
    
    return sectionFooter;
 
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.UniFrames.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    UniversityFrameNew *uniFrame = self.UniFrames[section];
    
    NSInteger courseCount = uniFrame.courseFrames.count;
    
    return courseCount > 0 ? courseCount : 1;
}


static NSString *identify = @"search_course";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UniversityCourseCell *cell =[tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        
        cell =[[UniversityCourseCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identify];
        
        [cell cellSelectedButtonHiden:YES];
    }
    
    UniversityFrameNew *uniFrame = self.UniFrames[indexPath.section];
    
    if (uniFrame.courseFrames.count > 0)  cell.course_frame = uniFrame.courseFrames[indexPath.row];
    
    
    //下拉到最后indexPath.row  下拉加载
    if (indexPath.section == self.UniFrames.count - 1  && !self.endPage) {
        
        [self.parametersM setValue:@(self.nextPage) forKey:KEY_PAGE];
        
        [self makeDataSource];
    }

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

//显示提示新加载数据
- (void)promptShowWithCount:(NSNumber *)count{
    
    if (!_promptView) {
        
        _promptView = [SearchPromptView promptViewInsertInView:self.tableView];
    }
    
    [self.promptView showWithTitle:[NSString stringWithFormat:@"共 %@ 所学校",count]];
    
}


-(void)dealloc
{
    KDClassLog(@"搜索结果  dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 

@end
