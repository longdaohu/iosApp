//
//  SearchUniversityCenterViewController.m
//  MyOffer
//
//  Created by xuewuguojie on 2017/4/25.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "SearchUniversityCenterViewController.h"
#import "UniversityNew.h"
#import "UniversityFrameNew.h"
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
#define KEY_PAGE_S  @"page"
#define KEY_SIZE_S  @"size"
#define KEY_DESC_S  @"desc"
#define KEY_ORDER_S  @"order"

@interface SearchUniversityCenterViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableDictionary *parametersM;
@property(nonatomic,strong)NSMutableArray *UniFrames;
@property(nonatomic,assign)NSInteger nextPage;
@property(nonatomic,assign)BOOL endPage;
@property(nonatomic,copy)NSString *searchValue;
@property(nonatomic,copy)NSString *currentRankType;
@property(nonatomic,copy)NSString *current_Country;
//筛选工具
@property(nonatomic,strong)SearchUniCenterFilterVController *filter;
//所有国家地区数组
@property(nonatomic,strong)NSArray *countries;
@property(nonatomic,strong)SearchPromptView *promptView;

@end

@implementation SearchUniversityCenterViewController

- (instancetype)initWithSearchValue:(NSString *)searchValue{

    
    self = [self init];
    
    if (self) {
 
        self.currentRankType = RANK_QS;
        [self.parametersM setValue:searchValue forKey:KEY_TEXT_S];
        [self.parametersM setValue:RANK_QS forKey:KEY_ORDER_S];
        self.searchValue = searchValue;
        self.title = self.searchValue;
        
    }
    
    
    return self;
}

//- (instancetype)initWithKey:(NSString *)key value:(NSString *)value orderBy:(NSNumber *)desc{
- (instancetype)initWithKey:(NSString *)key value:(NSString *)value{

    self = [self init];
    
    if (self) {
        
        NSString *rankType = RANK_QS;
        
        if ([key isEqualToString:KEY_CITY] || [key isEqualToString:KEY_STATE] || [key isEqualToString:KEY_COUNTRY] ) {
            
            rankType = RANK_TI;
        }
        
        self.currentRankType = rankType;
        
        NSDictionary *filter = @{KEY_NAME_S : key, KEY_VALUE_S:value};
        [self.parametersM setValue:@[filter] forKey:KEY_FILTERS_S];
        [self.parametersM setValue:rankType forKey:KEY_ORDER_S];
        self.title = value;
        
        if ([key isEqualToString:KEY_COUNTRY]) self.coreCountry =  value;
        if ([key isEqualToString:KEY_STATE])   self.coreState =  value;
        if ([key isEqualToString:KEY_CITY])    self.coreCity =  value;
        if ([key isEqualToString:KEY_AREA])    self.coreArea=  value;
        if ([key isEqualToString:KEY_SUBJECT]) self.coreSubject =  value;

        
        
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
                                    KEY_PAGE_S: @0,
                                    KEY_SIZE_S: @20,
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


- (SearchPromptView *)promptView{

    if (!_promptView) {
    
        _promptView = [[SearchPromptView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, 50)];
        
    }
    
    return _promptView;
}


- (void)makeUI{
    
    [self makeTableView];
    
    [self makeFilter];
    
    [self.view insertSubview:self.promptView  belowSubview:self.filter.view];
 
}



//根据城市名称设置网络请求设置升降序

- (void)makeParameterDesc{

    
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



/*
 155733  [APIClient] Request body: {"size":20,"page":0,"order":"ranking_ti","filters":[{"name":"city","value":"伦敦"}],"desc":0,"text":""}
 160753 [APIClient] Request body: {"size":20,"order":"ranking_qs",         "filters":[{"name":"city","value":"伯明翰"}],"desc":0,"page":0}
 */

//网络请求
- (void)makeDataSource{
    
    XWeakSelf
    [self startAPIRequestWithSelector:kAPISelectorSearch parameters:self.parametersM expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:^{
        
        
    } additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        [weakSelf updateUIWithResponse:response];
        
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        
    }];
    
    
}

//更新UI
- (void)updateUIWithResponse:(id)response{
   
    if (0 == self.nextPage) {
        
        // contentOffset.y 没有上移时，不用回滚到顶部
        if (self.tableView.contentOffset.y > 0) [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        
        // page = 0 时，删除所有数据
        if (self.UniFrames.count > 0) [self.UniFrames removeAllObjects];
    }
 
    
    NSArray *universities = [UniversityNew mj_objectArrayWithKeyValuesArray:response[@"universities"]];
 
    
    //当pageSize 大于请请求结果数量时，结束加载网络
    NSNumber *pageSize = [self.parametersM valueForKey:KEY_SIZE_S];
    self.endPage =  (pageSize.integerValue > universities.count);
    
    
    [universities enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UniversityFrameNew  *uniFrame = [UniversityFrameNew universityFrameWithUniverstiy:(UniversityNew *)obj];
        
        [self.UniFrames addObject:uniFrame];
        
    }];
    
    
    NSArray *rankTypes  =  [response valueForKeyPath:@"rankTypes"];
    NSMutableArray *rankings = [NSMutableArray array];
    for (NSString *rankType in rankTypes) {
        
         MyOfferRank *rank = [MyOfferRank rankWithName:rankType];
        
        [rankings addObject:rank];
     }
   
    self.filter.rankings = rankings;
    
    [self.tableView reloadData];

    
     if (0 == self.nextPage) [self promptShowWithCount:[response valueForKeyPath:@"count"]];
    
    self.nextPage += 1;
    
}



-(void)makeTableView
{
    self.tableView =[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.contentInset = UIEdgeInsetsMake(50, 0, XNAV_HEIGHT, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


- (void)makeFilter{
    
    XWeakSelf
    SearchUniCenterFilterVController *filter =[[SearchUniCenterFilterVController alloc] initWithActionBlock:^(NSArray *parameters) {
        
        [weakSelf filterWithParameter:parameters];
        
    }];
    
    if (self.coreCountry) filter.coreCountry =  self.coreCountry;
    if (self.coreState)   filter.coreState =  self.coreState;
    if (self.coreCity)    filter.corecity =   self.coreCity ;
    if (self.coreArea)    filter.coreArea=  self.coreArea;
    
    filter.currentRankType=  self.currentRankType;
    
    [self addChildViewController:filter];
    self.filter = filter;
    
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
        
             [self.parametersM setValue:@(self.nextPage) forKey:KEY_PAGE_S];
        
        
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
    
    return  uniFrame.universtiy.courses.count > 0 ? 60 : 10;
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    #warning 这里可能修改一下 通过FRAME 设置 cell 高度
    
    return Uni_Cell_Height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UniversityFrameNew *uniFrame = self.UniFrames[indexPath.section];

    NSInteger courseCount = uniFrame.universtiy.courseFrames.count;
    
    if (courseCount > 0 ) {
        
        SearchUniCourseFrame *courseFrame = uniFrame.universtiy.courseFrames[indexPath.row];
        
        return  courseFrame.cell_Height;
        
    }else{
    
        return HEIGHT_ZERO;

    }
 
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    XWeakSelf
    
    UniversityFrameNew *uniFrame = self.UniFrames[section];
    
    ApplySectionHeaderView  *sectionView= [ApplySectionHeaderView sectionHeaderViewWithTableView:tableView];
    [sectionView addButtonWithHiden:YES];
    [sectionView showBottomLineHiden:NO];
    sectionView.optionOrderBy = [self.parametersM valueForKey:KEY_ORDER_S];
    sectionView.uniFrame = uniFrame;
    sectionView.newActionBlock = ^(NSString *uni_id){
        
        [weakSelf.navigationController pushUniversityViewControllerWithID:uni_id animated:YES];
    };
    
    return sectionView;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    XWeakSelf;
    
    UniversityFrameNew *uniFrame = self.UniFrames[section];
    
    if (uniFrame.universtiy.courses.count > 0) {
        
        searchSectionFootView  *sectionFooter =[[searchSectionFootView alloc] init];
        sectionFooter.uniObj = uniFrame.universtiy;
        sectionFooter.actionBlock = ^(NSString *universityID){
            
            [weakSelf.navigationController pushViewController:[[UniversitySubjectListViewController alloc] initWithUniversityID:universityID] animated:YES];
            
        };
        
        return sectionFooter;
        
    }else{
        
        return nil;
        
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.UniFrames.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    UniversityFrameNew *uniFrame = self.UniFrames[section];
    
    NSInteger courseCount = uniFrame.universtiy.courseFrames.count;
    
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
    
    NSInteger courseCount = uniFrame.universtiy.courseFrames.count;
    
    if (courseCount > 0)  cell.course_frame = uniFrame.universtiy.courseFrames[indexPath.row];
    
    
    //下拉到最后indexPath.row  下拉加载
    if (indexPath.section == self.UniFrames.count - 1  && !self.endPage) {
        
        [self.parametersM setValue:@(self.nextPage) forKey:KEY_PAGE_S];
        
        [self makeDataSource];
    }

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

//显示提示数据
- (void)promptShowWithCount:(NSNumber *)count{
    
    [self.promptView promptShowWithCount:count.integerValue];

    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        
        self.promptView.mj_y = 50;
        
    } completion:^(BOOL finished) {
        
        
        [UIView animateWithDuration:ANIMATION_DUATION delay:2 options:UIViewAnimationOptionCurveEaseInOut  animations:^{
            
            self.promptView.mj_y = 0;
            
        } completion:^(BOOL finished) {
            
        }];
        
    }];
    
    
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
