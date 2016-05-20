
//
//  XNewSearchViewController.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/14.
//  Copyright © 2016年 UVIC. All rights reserved.
//
#define FILTERBACKORGIN_Y   (APPSIZE.height - 64)
#define PageSize 20
#define StatusYes @"yes"
#define StatusNo @"no"
#import "XNewSearchViewController.h"
#import "NewSearchResultCell.h"
#import "searchSectionHeadView.h"
#import "NewSearchRstTableViewCell.h"
#import "XSearchSectionHeaderView.h"
#import "XUCountry.h"
#import "CountryState.h"
#import "FiltContent.h"
#import "searchToolView.h"
#include "OptionItem.h"
#import "RankTypeTableViewCell.h"
#import "FilterSection.h"
#import "FilterTableViewCell.h"
#import "BottomBackgroudView.h"
#import "UniversityDetailViewController.h"
#import "UniversityCourseViewController.h"
#import "searchSectionFootView.h"
#import "UniversityFrameObj.h"
#import "FilterContentFrame.h"

@interface XNewSearchViewController ()<UITableViewDataSource,UITableViewDelegate,BottomBackgroudViewDelegate,FilterTableViewCellDelegate>
//判断是否是澳大利亚国家，是否需要带星号
@property(nonatomic,assign)BOOL IsStar;
//请求数据第几页
@property(nonatomic,assign)NSInteger NextPage;
//排名选择项
@property(nonatomic,assign)NSInteger selectRankTypeIndex;
//搜索关键字
@property(nonatomic,copy)NSString *SearchValue;
//本国或世界排名
@property(nonatomic,copy)NSString *RankType;
//保存最后一次搜索科目、专业、城市、国家、地区参数
@property(nonatomic,copy)NSString *Pre_area;
@property(nonatomic,copy)NSString *Pre_city;
@property(nonatomic,copy)NSString *Pre_state;
@property(nonatomic,copy)NSString *Pre_country;
@property(nonatomic,copy)NSString *Pre_subJect;
//顶部筛选工具条
@property(nonatomic,strong)searchToolView *ToolView;
//排名tableView出现时蒙版背景
@property(nonatomic,strong)UIView *CoverBgView;
//排名tableView出现时蒙版
@property(nonatomic,strong)UIButton  *cover;
//排名tableView数据数组
@property(nonatomic,strong)NSMutableArray *RankTypeList;
//搜索结果数组
@property(nonatomic,strong)NSMutableArray *UniversityList;
//筛选数组原始数据
@property(nonatomic,strong)NSMutableArray *coreFiltItems;
//筛选数据数组
@property(nonatomic,strong)NSMutableArray *FiltItems;
//筛选科目名称数组
@property(nonatomic,strong)NSArray *areaNameArr;
//筛选国家名称数组
@property(nonatomic,strong)NSArray *countryNameArr;
//英国地区数组
@property(nonatomic,strong)NSArray *states_UK;
//澳大利亚地区数组
@property(nonatomic,strong)NSArray *states_AU;
//科目专业字典（包含二级科目数据）数组
@property(nonatomic,strong)NSArray *filterAreas;
//用于判断用户是否放弃筛选，保持原有搜索参数
@property(nonatomic,copy)NSString *status;
//国家及国家二三级数据数组
@property(nonatomic,strong)NSArray *CountriesArray;
//搜索结果tableView
@property(nonatomic,strong)UITableView *ResultTableView;
//排名选项tableView
@property(nonatomic,strong)UITableView *RankTypeTableView;
//筛选tableView
@property(nonatomic,strong)UITableView *FilterTableView;
//筛选背景View
@property(nonatomic,strong)UIView *FiltbackView;
//搜索结果提示数据
@property(nonatomic,strong)UILabel *headerTitleLabel;
//筛选底部提交、取消工具条
@property(nonatomic,strong)BottomBackgroudView *bottomToolView;
//没有数据提示View
@property(nonatomic,strong)XWGJnodataView *NoDataView;
//筛选参数
@property(nonatomic,strong)NSMutableDictionary *filerParameters;

@end

@implementation XNewSearchViewController
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


- (instancetype)initWithSearchText:(NSString *)text orderBy:(NSString *)orderBy {
    
    return [self initWithSearchText:text key:@"text" orderBy:orderBy];
}

- (instancetype)initWithSearchText:(NSString *)text key:(NSString *)key orderBy:(NSString *)orderBy {
    self = [self init];
    if (self) {
        
        self.SearchValue = text;
        self.RankType = orderBy.length ? orderBy : RANKQS;
        self.title = text;
        self.hidesBottomBarWhenPushed = YES;
        
    }
    return self;
}

- (instancetype)initWithFilter:(NSString *)key value:(NSString *)value orderBy:(NSString *)orderBy {
    self = [self init];
    if (self) {
        
        self.title = value;
        
        self.hidesBottomBarWhenPushed = YES;
        
        self.SearchValue = @"";
        
        self.RankType = orderBy.length ? orderBy : RANKQS;
        
        
        if([key  isEqualToString: KEY_AREA]) {
            
            
            [self.filerParameters  setValue:value forKey:KEY_AREA];
            
        } else if([key  isEqualToString: KEY_COUNTRY]) {
            
            
        } else if([key  isEqualToString: KEY_STATE]) {
            
            
            [self.filerParameters  setValue:value forKey:KEY_STATE];
            self.selectRankTypeIndex = 1;
            
        }else if([key  isEqualToString: KEY_CITY]) {
            
            [self.filerParameters  setValue:value forKey:KEY_CITY];
            self.selectRankTypeIndex = 1;
        }
        
    }
    return self;
}


-(NSMutableDictionary *)filerParameters
{
    if (!_filerParameters) {
        
        _filerParameters =[NSMutableDictionary dictionary];
    }
    return   _filerParameters;
}

-(NSMutableArray *)UniversityList
{
    if (!_UniversityList) {
        
        _UniversityList =[NSMutableArray array];
    }
    return _UniversityList;
}

-(NSMutableArray *)RankTypeList
{
    if (!_RankTypeList) {
        
        _RankTypeList =[NSMutableArray array];
    }
    return _RankTypeList;
}


-(NSArray *)filterAreas{
    
    if (!_filterAreas) {
        
        //从本地存储数据中加载科目专业数据
        NSString *keyWord  = USER_EN ? @"Subject_EN" :@"Subject_CN";
        NSArray *values = [[NSUserDefaults standardUserDefaults] valueForKey:keyWord];
        
        NSMutableArray *temps = [NSMutableArray array];
        
        for (NSDictionary *itemInfo in values) {
            
            FilterSection *filtSection = [FilterSection FilterSectionWithDictionary:itemInfo];
            
            [temps addObject:filtSection];
        }
        
        _filterAreas = [temps copy];
        
    }
    return _filterAreas;
}



-(NSArray *)areaNameArr
{
    if (!_areaNameArr) {
        //从本地存储数据中加载科目名称数据
        _areaNameArr = [self.filterAreas valueForKeyPath:@"areaName"];
    }
    return _areaNameArr;
}


#pragma mark ———————— 筛选表单数据
-(NSMutableArray *)FiltItems
{
    if (!_FiltItems) {
        //选项数据
        
        
        NSMutableArray *temps =[NSMutableArray arrayWithCapacity:5];
        
        FiltContent  *fileritemCountry =[FiltContent createItemWithTitle:GDLocalizedString(@"SearchResult_Country") andDetailTitle:GDLocalizedString(@"SearchResult_All") anditems: [self.CountriesArray valueForKey:@"countryName"]];
        FilterContentFrame *country = [[FilterContentFrame alloc] init];
        country.content = fileritemCountry;
        [temps addObject:country];
        
        NSArray *stateArray = nil;
        if (self.CoreCountry) {
            
            country.cellState = 2;
            
            stateArray = [self makeCurrentStateWithCountry:self.CoreCountry];
        }
        
        FiltContent  *fileritemState =[FiltContent createItemWithTitle:GDLocalizedString(@"SearchResult_State") andDetailTitle:GDLocalizedString(@"SearchResult_All") anditems: stateArray];
        FilterContentFrame *state = [[FilterContentFrame alloc] init];
        state.content = fileritemState;
        [temps addObject:state];
        
        
        
        NSArray *currentCityArr = nil;
        if (self.CoreState) {
            
            state.cellState = 2;
            
            CountryState  * currentState =[self makeCurrentCityWithState:self.CoreState country:self.CoreCountry];
            
            currentCityArr = currentState.cities;
        }
        
        
        FiltContent  *fileritemCity =[FiltContent createItemWithTitle:GDLocalizedString(@"SearchResult_city") andDetailTitle:GDLocalizedString(@"SearchResult_All") anditems:currentCityArr];
        FilterContentFrame *city = [[FilterContentFrame alloc] init];
        city.content = fileritemCity;
        [temps addObject:city];
        if (self.Corecity) {
            
            country.cellState = 2;
            state.cellState = 2;
            city.cellState = 2;
            
        }
        
        
        FiltContent *fileritemArea =[FiltContent createItemWithTitle:GDLocalizedString(@"SearchResult_subjectArea")  andDetailTitle:GDLocalizedString(@"SearchResult_All")anditems: [self.filterAreas valueForKeyPath:@"areaName"]];
        FilterContentFrame *area = [[FilterContentFrame alloc] init];
        area.content = fileritemArea;
        [temps addObject:area];
        
        NSArray *subjectArray = nil;
        if (self.CoreArea) {
            
            area.cellState = 2;
            
            subjectArray =[self makeCurrentSubjectWithArea:self.CoreArea];
        }
        
        FiltContent *fileritemSubject =[FiltContent createItemWithTitle:GDLocalizedString(@"SearchResult_subject") andDetailTitle:GDLocalizedString(@"SearchResult_All")  anditems:subjectArray];
        FilterContentFrame *subject = [[FilterContentFrame alloc] init];
        subject.content = fileritemSubject;
        [temps addObject:subject];
        
        
        _FiltItems = [temps mutableCopy];
        
    }
    return _FiltItems;
}




//获取当前国家地区数组
-(NSArray *)makeCurrentStateWithCountry:(NSString *)countryName
{
    
    NSInteger  countryIndex = [self.countryNameArr indexOfObject:countryName];
    XUCountry *country  =  self.CountriesArray[countryIndex];
    return [country.states valueForKeyPath:@"stateName"];
    
}
//获取当前国家地区
-(CountryState *)makeCurrentCityWithState:(NSString *)stateName  country:(NSString *)CountryName;
{
    
    
    NSInteger  countryIndex = [self.countryNameArr indexOfObject:CountryName];
    XUCountry *country  =  self.CountriesArray[countryIndex];
    NSArray *stateNameArr = [country.states valueForKeyPath:@"stateName"];
    
    NSInteger  stateIndex =  [stateNameArr indexOfObject: stateName];
    
    return country.states[stateIndex];
}


//获取当前科目数组
-(NSArray *)makeCurrentSubjectWithArea:(NSString *)AreaName
{
    NSInteger  areaIndex = [self.areaNameArr indexOfObject:AreaName];
    FilterSection *area  =  self.filterAreas[areaIndex];
    
    return [area.subjectArray valueForKeyPath:@"subjectName"];
}




- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //判断是否是澳大利亚国家选项
    NSString *para_state = [self.filerParameters valueForKey:KEY_STATE];
    
    if (para_state.length > 0 ) {
        
        [self checkIsStar:para_state];
        
    }
    NSString *country =[self.filerParameters valueForKey:KEY_COUNTRY];
    if (country.length > 0 ) {
        
        [self checkIsStar:country];
        
    }
    
    
    [self makeUI];
    
    [self makeData:0];
    
}

/**
 * 国家数组
 */
-(NSArray *)CountriesArray
{
    if (!_CountriesArray) {
        
        NSString *lang = [InternationalControl userLanguage];
        NSString *keyWord  = [lang containsString:@"en"] ? @"Country_EN" :@"Country_CN";
        NSArray *values = [[NSUserDefaults standardUserDefaults] valueForKey:keyWord];
        NSMutableArray *temps =[NSMutableArray array];
        for (NSDictionary *countryDic  in values) {
            XUCountry *country = [XUCountry countryInitWithCountryDictionary:countryDic];
            [temps addObject:country];
        }
        self.countryNameArr  = [temps valueForKeyPath:@"countryName"];
        
        NSInteger index_UK =[self.countryNameArr indexOfObject:GDLocalizedString(@"CategoryVC-UK")];
        NSInteger index_AU =[self.countryNameArr indexOfObject:GDLocalizedString(@"CategoryVC-AU")];
        XUCountry *UK = temps[index_UK];
        XUCountry *AU = temps[index_AU];
        
        self.states_UK =UK.states;
        self.states_AU =AU.states;
        
        _CountriesArray = [temps copy];
        
    }
    return _CountriesArray;
}

/**
 * 判断是不是澳大利亚国家
 */
-(void)checkIsStar:(NSString *)StateName
{
    
    self.IsStar = NO;
    
    if ([self.RankType isEqualToString:RANKQS]) {
        
        self.IsStar = NO;
        
        return;
    }
    
    //这个好像不需要，暂时先放着
    NSInteger index_AU =[self.countryNameArr  indexOfObject:GDLocalizedString(@"CategoryVC-AU")];
    
    NSString *country =[self.filerParameters valueForKey:KEY_COUNTRY];
    if (country.length) {
        
        //如果self.country 存在，判断是不是澳大利亚
        if ([country isEqualToString:self.countryNameArr[index_AU]]) {
            
            self.IsStar = YES;
            
            return;
        }
    }
    
    if (self.CoreCountry.length) {
        
        //如果self.country 存在，判断是不是澳大利亚
        if ([self.CoreCountry isEqualToString:self.countryNameArr[index_AU]]) {
            
            self.IsStar = YES;
            
            return;
        }
    }
    
    NSString *para_state = [self.filerParameters valueForKey:KEY_STATE];
    
    if (para_state.length) {
        
        NSArray *AU = [self.states_AU valueForKeyPath:@"stateName"];
        
        if ([AU containsObject:para_state]) {
            
            self.IsStar = YES;
            
            return;
        }
    }
    
    if (self.CoreState.length) {
        
        NSArray *AU = [self.states_AU valueForKeyPath:@"stateName"];
        
        if ([AU containsObject:self.CoreState]) {
            
            self.IsStar = YES;
            
            return;
        }
    }
    
    
    NSString *para_city = [self.filerParameters valueForKey:KEY_CITY];
    
    if (para_city.length) {
        
        for (CountryState *state in self.states_AU) {
            
            if ([state.cities  containsObject:para_city]) {
                
                self.IsStar = YES;
                
                return;
                
            }else {
                
                self.IsStar = NO;
            }
        }
        
    }
    
}


-(void)checkIsStar_Pre
{
    
    self.IsStar = NO;
    
    if ([self.RankType isEqualToString:RANKQS]) {
        
        self.IsStar = NO;
        
        return;
    }
    
    NSInteger index_AU =[self.countryNameArr  indexOfObject:GDLocalizedString(@"CategoryVC-AU")];
    
    if (self.Pre_country.length) {
        
        if ([self.Pre_country isEqualToString:self.countryNameArr[index_AU]]) {
            
            self.IsStar = YES;
            
            return;
        }
    }
    
    if (self.CoreCountry.length) {
        
        //如果self.country 存在，判断是不是澳大利亚
        if ([self.CoreCountry isEqualToString:self.countryNameArr[index_AU]]) {
            
            self.IsStar = YES;
            
            return;
        }
    }
    
    
    if (self.Pre_state.length) {
        
        NSArray *AU = [self.states_AU valueForKeyPath:@"stateName"];
        
        if ([AU containsObject:self.Pre_state]) {
            
            self.IsStar = YES;
            
            return;
        }
    }
    
    if (self.CoreState.length) {
        
        NSArray *AU = [self.states_AU valueForKeyPath:@"stateName"];
        
        if ([AU containsObject:self.CoreState]) {
            
            self.IsStar = YES;
            
            return;
        }
    }
    
    
    if (self.Pre_city.length) {
        
        for (CountryState *state in self.states_AU) {
            
            if ([state.cities  containsObject: self.Pre_city]) {
                
                self.IsStar = YES;
                
                return;
                
            }else {
                
                self.IsStar = NO;
            }
        }
        
    }
    
}


-(void)makeUI
{
    
    [self makeResultTableView];
    
    [self makeTopToolView];
    
    [self makeRankTypeTableView];
    
    [self makeFiltbackView];
    
    
}


//用于显示表头搜索结果数量
-(void)fixHeaderTitleLabelWithCount:(NSString *)countStr
{
    NSString *title  =  [NSString stringWithFormat:@"%@ %@ %@",GDLocalizedString(@"ApplicationList-004"),countStr,GDLocalizedString(@"SearchResult_university")];
    //富文本处理
    NSRange keyRange = [title rangeOfString:countStr];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:title];
    [AttributedStr addAttribute:NSForegroundColorAttributeName  value:XCOLOR_RED   range:keyRange];
    self.headerTitleLabel.attributedText =  AttributedStr ;
}



//搜索结果tableView
-(void)makeResultTableView
{
    self.ResultTableView =[[UITableView alloc] initWithFrame:CGRectMake(0,50, XScreenWidth, XScreenHeight - 114) style:UITableViewStyleGrouped];
    self.ResultTableView.delegate = self;
    self.ResultTableView.dataSource = self;
    [self.view addSubview:self.ResultTableView];
    self.ResultTableView.tableFooterView =[[UIView alloc] init];
    
    UIView  *headerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, APPSIZE.width, 30)];
    self.ResultTableView.tableHeaderView = headerView;
    self.headerTitleLabel =[[UILabel alloc] initWithFrame:CGRectMake(15, 0, APPSIZE.width, 30)];
    [headerView addSubview:self.headerTitleLabel];
    
    self.ResultTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    
    self.NoDataView =[XWGJnodataView noDataView];
    self.NoDataView.contentLabel.text = GDLocalizedString(@"Evaluate-noData");
    self.NoDataView.hidden = YES;
    [self.view addSubview:self.NoDataView];
    
}
//排名tableView
-(void)makeRankTypeTableView
{
    //加蒙版
    self.CoverBgView =[[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.ToolView.frame), XScreenWidth, XScreenHeight)];
    self.CoverBgView.hidden = YES;
    [self.view insertSubview:self.CoverBgView belowSubview:self.ToolView];
    UIButton  *cover =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, APPSIZE.width, APPSIZE.height)];
    self.cover = cover;
    [cover addTarget:self action:@selector(coverButtonClickRemoveOptionView:) forControlEvents:UIControlEventTouchUpInside];
    cover.backgroundColor =[UIColor blackColor];
    cover.alpha = 0;
    [self.CoverBgView addSubview:cover];
    
    self.RankTypeTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, -88, XScreenWidth, 88) style:UITableViewStylePlain];
    self.RankTypeTableView.scrollEnabled = NO;
    self.RankTypeTableView.dataSource = self;
    self.RankTypeTableView.delegate = self;
    [self.CoverBgView addSubview:self.RankTypeTableView];
    
}
#pragma mark ———————— 顶部工具条
-(void)makeTopToolView
{
    XJHUtilDefineWeakSelfRef;
    
    self.ToolView =[[searchToolView alloc] initWithFrame:CGRectMake(0, 0, APPSIZE.width, 50)];
    
    NSString  *toolTitle = [self.RankType isEqualToString:RANKTI] ? GDLocalizedString(@"SearchResult_countryxxxRank"):GDLocalizedString(@"SearchResult_worldxxxRank");
    
    [self.ToolView.leftButton setTitle:toolTitle  forState:UIControlStateNormal];
    
    [self.view addSubview:self.ToolView];
    
    self.ToolView.actionBlock = ^(UIButton *sender){
        
        if (11 == sender.tag) {
            
            //用于实现RankTypeView出现、隐藏
            [weakSelf rankTypeViewDown:NO];
            
            //用于实现 筛选页面的出现、隐藏
            [weakSelf FiltbackViewDown:self.FiltbackView.alpha == 0];
            
            
        }else{
            
            [weakSelf FiltbackViewDown:NO];
            
            [weakSelf rankTypeViewDown:weakSelf.cover.alpha == 0];
            
        }
        
    };
    
}

//筛选页面
-(void)makeFiltbackView
{
    self.FiltbackView =[[UIView alloc] initWithFrame:CGRectMake(0,-FILTERBACKORGIN_Y, XScreenWidth, FILTERBACKORGIN_Y)];
    self.FiltbackView.backgroundColor = XCOLOR_RED;
    self.FiltbackView.alpha = 0;
    [self.view  insertSubview:self.FiltbackView belowSubview:self.ToolView];
    
    
    self.FilterTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 50 ,APPSIZE.width, APPSIZE.height -164) style:UITableViewStylePlain];
    self.FilterTableView.dataSource = self;
    self.FilterTableView.delegate   = self;
    self.FilterTableView.allowsSelection = NO;
    self.FilterTableView.tableFooterView =[[UIView alloc] init];
    [self.FiltbackView addSubview: self.FilterTableView];
    
    self.bottomToolView = [[BottomBackgroudView alloc] initWithFrame:CGRectMake(0, self.FiltbackView.bounds.size.height - 50, XScreenWidth, 50)];
    self.bottomToolView.delegate = self;
    [self.FiltbackView addSubview:self.bottomToolView];
    
    
}
/**
 * 加载更多
 */
-(void)loadMoreData
{
    [self makeData:self.NextPage];
}


#pragma mark ———————————— 网络数据请求
-(void)makeData:(NSInteger)page{
    
    //通过判断是不是澳大利亚城市正序或倒序
    if ([self.status isEqualToString:StatusYes]) {
        
        KDClassLog(@"--------checkIsStar_Pre------if---");
        
        [self checkIsStar_Pre];
        
    }else{
        
        KDClassLog(@"--------checkIsStar----else-----");
        
        [self checkIsStar:self.RankType];
        
    }
    
    
    NSNumber *desc = self.IsStar? @1:@0;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary: @{@"text": self.SearchValue,
                                                                                       @"page": [NSNumber numberWithInteger:page],
                                                                                       @"size": [NSNumber numberWithInteger:PageSize],
                                                                                       @"desc": desc,
                                                                                       @"order": self.RankType}];
    
    if ([self.status isEqualToString:StatusYes]) {
        
        KDClassLog(@"----filtersM----if--------");
        
        NSMutableArray *filtersM =[NSMutableArray array];
        
        if (self.Pre_area.length) {
            
            [filtersM addObject:@{@"name": KEY_AREA, @"value": self.Pre_area}];
            
        }
        
        if(self.Pre_country.length) {
            
            [filtersM addObject:@{@"name": KEY_COUNTRY, @"value": self.Pre_country}];
        }
        
        
        if(self.Pre_state.length) {
            
            [filtersM addObject:@{@"name": KEY_STATE, @"value": self.Pre_state}];
            
        }
        
        if (self.Pre_city.length) {
            
            [filtersM addObject:@{@"name": KEY_CITY, @"value": self.Pre_city}];
            
        }
        
        
        if (self.Pre_subJect.length) {
            
            [filtersM addObject:@{@"name": KEY_SUBJECT, @"value": self.Pre_subJect}];
        }
        
        
        if(self.CoreCountry) {
            
            [filtersM addObject:@{@"name": KEY_COUNTRY, @"value": self.CoreCountry}];
        }
        
        if (self.CoreState) {
            
            [filtersM addObject:@{@"name": KEY_STATE, @"value": self.CoreState}];
        }
        
        if (self.CoreArea) {
            
            [filtersM addObject:@{@"name": KEY_AREA, @"value": self.CoreArea}];
            
        }
        
        [parameters setValue:filtersM forKey:@"filters"];
        
        
        
    }else{
        
        KDClassLog(@"----filtersM----else--------");
        self.Pre_area =@"";
        self.Pre_subJect =@"";
        self.Pre_city =@"";
        self.Pre_state =@"";
        self.Pre_country =@"";
        
        NSMutableArray *filtersM =[NSMutableArray array];
        
        NSString *parameter_area =[self.filerParameters valueForKey:KEY_AREA];
        if (parameter_area.length) {
            
            [filtersM addObject:@{@"name": KEY_AREA, @"value": parameter_area}];
            
            self.Pre_area = parameter_area;
        }
        if (self.CoreArea) {
            
            [filtersM addObject:@{@"name": KEY_AREA, @"value": self.CoreArea}];
            self.Pre_area = self.CoreArea;
            
        }
        NSString *country =[self.filerParameters valueForKey:KEY_COUNTRY];
        if(country.length) {
            
            [filtersM addObject:@{@"name": KEY_COUNTRY, @"value": country}];
            
            self.Pre_country = country;
        }
        
        if(self.CoreCountry.length) {
            
            [filtersM addObject:@{@"name": KEY_COUNTRY, @"value": self.CoreCountry}];
            self.Pre_country = self.CoreCountry;
        }
        
        
        if (self.CoreState) {
            
            [filtersM addObject:@{@"name": KEY_STATE, @"value": self.CoreState}];
            self.Pre_state = self.CoreState;
        }
        
        
        NSString *para_state = [self.filerParameters valueForKey:KEY_STATE];
        
        if(para_state.length) {
            
            [filtersM addObject:@{@"name": KEY_STATE, @"value": para_state}];
            self.Pre_state = para_state;
            
        }
        
        NSString *para_city = [self.filerParameters valueForKey:KEY_CITY];
        
        if (para_city.length) {
            
            [filtersM addObject:@{@"name": KEY_CITY, @"value": para_city}];
            self.Pre_city = para_city;
            
        }
        
        
        NSString *parameter_subject = [self.filerParameters valueForKey:KEY_SUBJECT];
        
        if (parameter_subject.length) {
            
            [filtersM addObject:@{@"name": KEY_SUBJECT, @"value": parameter_subject}];
            self.Pre_subJect = parameter_subject;
        }
        
        
        [parameters setValue:filtersM forKey:@"filters"];
        
    }
    
    
    [self
     startAPIRequestWithSelector:kAPISelectorSearch
     parameters:parameters
     expectedStatusCodes:nil
     showHUD:YES
     showErrorAlert:YES
     errorAlertDismissAction:nil
     additionalSuccessAction:^(NSInteger statusCode, id response) {
         
         
         self.status = StatusYes;
         
         if (page == 0) {
             
             [self.UniversityList removeAllObjects];
             
         }
         
         
         //添加数据源
         [response[@"universities"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
             
             UniversityObj *uni = [UniversityObj createUniversityWithUniversityInfo:obj];
             UniversityFrameObj *uniFrame = [[UniversityFrameObj alloc] init];
             uniFrame.uniObj = uni;
             [self.UniversityList addObject:uniFrame];
             
         }];
         
         
         [self.ResultTableView reloadData];
         
         //每一次重新请求时，回到tableView顶部
         if (page == 0) {
             
             [self.ResultTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
             
         }
         
         
         self.NextPage = page + 1; //加载下一页PageNumber
         
         //数据请求为0是显示或隐藏关于控件
         self.NoDataView.hidden = self.UniversityList.count == 0 ? NO : YES;
         
         
         //筛选时先删除optionTabel的数据源，重新添加数据源
         [self.RankTypeList removeAllObjects];
         
         
         for (NSString *typeName in response[@"rankTypes"]) {
             OptionItem *Option_item = [OptionItem CreateOpitonItemWithRank:typeName];
             NSString *QSRank = [GDLocalizedString(@"SearchRank_World") lowercaseString];
             if([typeName isEqualToString:QSRank])
             {
                 [self.RankTypeList insertObject:Option_item atIndex:0];
                 
             }else{
                 [self.RankTypeList addObject:Option_item];
                 
             }
             
             CGRect newRect = self.RankTypeTableView.frame;
             newRect.size.height = self.RankTypeList.count * 44;
             self.RankTypeTableView.frame = newRect;
         }
         
         
         //显示ToolView左侧按钮Title
         int index = [self.RankType isEqualToString:RANKTI] ? 1 : 0;
         OptionItem *rank = self.RankTypeList[index];
         [self.ToolView.leftButton setTitle:rank.RankTypeName forState:UIControlStateNormal];
         //记住是第几个排序
         self.selectRankTypeIndex = index;
         
         //  加载更多是否显示
         if ([response[@"universities"] count] < PageSize) {
             
             [self.ResultTableView.mj_footer endRefreshingWithNoMoreData];
             
         }else{
             
             [self.ResultTableView.mj_footer endRefreshing];
             
         }
         
         
         NSString *countStr =[NSString stringWithFormat:@"%@",response[@"count"]];
         
         //显示搜索结果数量
         [self fixHeaderTitleLabelWithCount:countStr];
         
     } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
         
         self.status = StatusYes;
         
         [self.ResultTableView.mj_footer endRefreshing];
         
     }];
    
}

#pragma mark ———————— tableViewData tableViewDelegate
//超出cell的bounds范围，不能显示
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.clipsToBounds = YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (tableView == self.ResultTableView) {
        
        return University_HEIGHT;
        
    }else{
        
        return 0;
        
    }
    
}


- (UITableViewHeaderFooterView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.ResultTableView) {
        
        XJHUtilDefineWeakSelfRef;
        XSearchSectionHeaderView *sectionHeader =[XSearchSectionHeaderView SectionHeaderViewWithTableView:tableView];
        sectionHeader.IsStar = self.IsStar;
        sectionHeader.RANKTYPE = self.RankType;
        UniversityFrameObj *uniFrame = self.UniversityList[section];
        sectionHeader.uni_Frame =  uniFrame;
        
        /**
         * 实现页面跳转，查看学校详情
         */
        sectionHeader.actionBlock = ^(NSString *universityID){
            UniversityDetailViewController *detail = [[UniversityDetailViewController alloc] initWithUniversityID:universityID];
            [weakSelf.navigationController pushViewController:detail animated:YES];
        };
        
        return sectionHeader;
        
    }else{
        
        
        return nil;
        
    }
    
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    XJHUtilDefineWeakSelfRef;
    UniversityFrameObj *uniFrame = self.UniversityList[section];
    UniversityObj *uniObj = uniFrame.uniObj;
    NSArray *items = uniObj.resultSubjectArray;
    if (items.count) {
        searchSectionFootView  *sectionFooter =[[searchSectionFootView alloc] init];
        sectionFooter.uniObj = uniObj;
        sectionFooter.actionBlock = ^(NSString *universityID){
            UniversityCourseViewController *vc = [[UniversityCourseViewController alloc] initWithUniversityID:universityID];
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        };
        return sectionFooter;
    }else{
        
        return nil;
        
    }
    
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (tableView == self.FilterTableView) {
        
        FilterContentFrame *item = self.FiltItems[indexPath.row];
        return item.cellHeigh;
        
    }else if (tableView == self.RankTypeTableView) {
        
        return 44;
        
    }else{
        
        UniversityFrameObj *uniFrame = self.UniversityList[indexPath.section];
        UniversityObj *uniOBJ = uniFrame.uniObj;
        NSArray *items = uniOBJ.resultSubjectArray;
        
        return  items.count > 0 ? 70 : 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == self.RankTypeTableView || tableView == self.FilterTableView) {
        
        return 0;
        
    }else{
        
        UniversityFrameObj *uniFrame = self.UniversityList[section];
        UniversityObj *uniOBJ = uniFrame.uniObj;
        NSArray *items = uniOBJ.resultSubjectArray;
        
        if (items.count) {
            
            return 60;
            
        }else{
            
            return 10;
        }
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.ResultTableView) {
        
        return self.self.UniversityList.count;
        
    }else{
        
        return 1;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.RankTypeTableView) {
        
        return self.RankTypeList.count;
        
    }else if(tableView == self.FilterTableView){
        
        return self.FiltItems.count;
        
    }else{
        
        UniversityFrameObj *uniFrame = self.UniversityList[section];
        UniversityObj *uniOBJ = uniFrame.uniObj;
        NSArray *items = uniOBJ.resultSubjectArray;
        if (items.count > 0) {
            
            //只显示部分数据
            return  items.count > 3 ? 3:items.count;
            
        }else{
            
            return 1;
        }
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.FilterTableView) {
        
        
        FilterTableViewCell *Fcell =[[FilterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        Fcell.delegate = self;
        Fcell.indexPath = indexPath;
        switch (indexPath.row) {
            case 0:
                Fcell.selectItem =[self.filerParameters valueForKey:KEY_COUNTRY];
                break;
            case 1:
                Fcell.selectItem =[self.filerParameters valueForKey:KEY_STATE];
                break;
            case 2:
                Fcell.selectItem =[self.filerParameters valueForKey:KEY_CITY];
                break;
            case 3:
                Fcell.selectItem =[self.filerParameters valueForKey:KEY_AREA];
                break;
            case 4:
                Fcell.selectItem =[self.filerParameters valueForKey:KEY_SUBJECT];
                break;
            default:
                break;
        }
        Fcell.filterFrame = self.FiltItems[indexPath.row];
        
        return Fcell;
        
        
    }else if (tableView == self.RankTypeTableView) {
        
        OptionItem *option_item = self.RankTypeList[indexPath.row];
        
        RankTypeTableViewCell *cell =[RankTypeTableViewCell cellInitWithTableView:tableView];
        
        cell.title =  option_item.RankTypeShowName;
        
        
        if (self.selectRankTypeIndex == indexPath.row) {
            
            cell.TitleLab.textColor = XCOLOR_RED;
            
            cell.accessoryMV.image = [UIImage imageNamed:@"check-icons-yes"];
            
        }else{
            
            cell.accessoryMV.image = nil;
        }
        
        
        return cell;
        
        
    }else {
        
        
        NewSearchRstTableViewCell *cell =[NewSearchRstTableViewCell  cellWithTableView:tableView];
        UniversityFrameObj *uniFrame = self.UniversityList[indexPath.section];
        UniversityObj *uniOBJ = uniFrame.uniObj;
        NSArray *items = uniOBJ.resultSubjectArray;
        NSDictionary *itemInfo =items[indexPath.row];
        if (items.count > 0) {
            cell.itemInfo = itemInfo;
            
        }
        
        return cell;
        
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.RankTypeTableView) {
        
        self.ToolView.LeftView.image = [UIImage imageNamed:@"arrow_down"];
        
        if (self.selectRankTypeIndex != indexPath.row) {
            
            RankTypeTableViewCell *Rcell =  [tableView cellForRowAtIndexPath:indexPath];
            Rcell.accessoryMV.image = [UIImage imageNamed:@"check-icons-yes"];
            Rcell.textLabel.textColor = XCOLOR_RED;
            
            NSIndexPath *lastPath =[NSIndexPath indexPathForRow:self.selectRankTypeIndex inSection:0];
            RankTypeTableViewCell *lastCell =[tableView cellForRowAtIndexPath:lastPath];
            lastCell.textLabel.textColor = XCOLOR_BLACK;
            lastCell.accessoryMV.image = nil;
            self.selectRankTypeIndex = indexPath.row;
            
            UIButton *leftButton = self.ToolView.subviews[0];
            [leftButton setTitle:Rcell.TitleLab.text  forState:UIControlStateNormal];
            
            OptionItem *option_item = self.RankTypeList[indexPath.row];
            //记住当前排序方式
            self.RankType = option_item.RankType;
            
            if (self.UniversityList.count == 0) {
                
                return ;
                
            }else{
                
                [self makeData:0];
                
            }
        }
        //移除排序列表
        [self coverButtonClickRemoveOptionView:nil];
        
    }
    
}


#pragma mark —————————— BottomBackgroudViewDelegate
-(void)BottomBackgroudView:(BottomBackgroudView *)bgView andButtonItem:(UIButton *)sender
{
    
    if (100  == sender.tag) {
        
        //移除选项列表
        [self FiltbackViewDown:NO];
        
        NSString *country =[self.filerParameters valueForKey:KEY_COUNTRY];
        NSString *state = [self.filerParameters valueForKey:KEY_STATE];
        NSString *para_city = [self.filerParameters valueForKey:KEY_CITY];
        
        if (country.length == 0 &&state.length == 0 &&para_city.length == 0 &&self.CoreState == 0) {
            
            //如果国家、地区选项为空时排序方式设置为 RANKQS
            self.RankType = RANKQS;
        }
        
        
        //清空上一次的数据，重新加载
        [self.UniversityList removeAllObjects];
        
        self.status = StatusNo;
        
        [self makeData:0];
        
        
    }else{
        
        //清空参数选项数据
        [self.filerParameters removeObjectForKey:KEY_COUNTRY];
        [self.filerParameters removeObjectForKey:KEY_STATE];
        [self.filerParameters removeObjectForKey:KEY_CITY];
        [self.filerParameters removeObjectForKey:KEY_AREA];
        [self.filerParameters removeObjectForKey:KEY_SUBJECT];
        [self.FiltItems removeAllObjects];
        self.FiltItems = [self.coreFiltItems mutableCopy];
        [self.FilterTableView reloadData];
    }
    
}

//用于FilterTableView局部刷新
-(void)FilterTableViewReloadWithIndex:(NSInteger)index andfiltItem:(FiltContent *)filtItem
{
    [self.FiltItems replaceObjectAtIndex:index withObject:filtItem];
    [self.FilterTableView reloadData];
}

#pragma mark —————————— FilterTableViewCellDelegate
-(void)FilterTableViewCell:(FilterTableViewCell *)tableViewCell  WithButtonItem:(UIButton *)sender WithIndexPath:(NSIndexPath *)indexPath
{
    
    
    FilterContentFrame  *filterFrame = self.FiltItems[indexPath.row];
    
    if (sender.tag == 999) {
        
        if (filterFrame.cellState == 1) {
            filterFrame.cellState = 0;
        }else if(filterFrame.cellState == 0){
            filterFrame.cellState = 1;
        }else{
            
        }
        
        [self.FilterTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        return ;
        
    }
    
    
    
    
    switch (indexPath.row) {
        case 0:
        {
            NSString *para_country = [self.filerParameters valueForKey:KEY_COUNTRY];
            BOOL Equal = [para_country isEqualToString:sender.currentTitle];
            
            [self.filerParameters removeObjectForKey:KEY_STATE];
            [self.filerParameters removeObjectForKey:KEY_CITY];
            
            if (Equal) {
                
                [self.filerParameters removeObjectForKey:KEY_COUNTRY];
                
                FilterContentFrame  *stateFilterFrame = self.FiltItems[indexPath.row + 1];
                stateFilterFrame.cellState =  2;
                
                
            }else{
                
                [self.filerParameters  setValue:sender.currentTitle forKey:KEY_COUNTRY];
                
                
                NSArray *states = [self makeCurrentStateWithCountry:sender.currentTitle];
                
                FilterContentFrame  *stateFilterFrame = self.FiltItems[indexPath.row + 1];
                stateFilterFrame.items =  states;
                stateFilterFrame.cellState =  0;
                
                FiltContent *stateFiltItem = stateFilterFrame.content;
                stateFiltItem.buttonArray = states;
                
            }
            
            
            NSIndexPath *stateIndexPath =[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
            
            
            FilterContentFrame  *cityFilterFrame = self.FiltItems[indexPath.row + 2];
            cityFilterFrame.cellState =  2;
            NSIndexPath *cityIndexPath =[NSIndexPath indexPathForRow:indexPath.row + 2 inSection:indexPath.section];
            [self.FilterTableView reloadRowsAtIndexPaths:@[cityIndexPath,stateIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            
        }
            break;
            
        case 1:
        {
            
            NSString *para_state = [self.filerParameters valueForKey:KEY_STATE];
            BOOL Equal = [para_state isEqualToString:sender.currentTitle];
            
            [self.filerParameters removeObjectForKey:KEY_CITY];
            
            if (Equal) {
                
                [self.filerParameters removeObjectForKey:KEY_STATE];
                
                FilterContentFrame  *cityFilterFrame = self.FiltItems[indexPath.row + 1];
                cityFilterFrame.cellState =  2;
                
                
                
            }else{
                
                [self.filerParameters  setValue:sender.currentTitle forKey:KEY_STATE];
                
                NSString *countryName = self.CoreCountry ? self.CoreCountry :[self.filerParameters valueForKey:KEY_COUNTRY];
                
                CountryState *state =[self makeCurrentCityWithState:sender.currentTitle country:countryName];
                
                FilterContentFrame  *cityFilterFrame = self.FiltItems[indexPath.row + 1];
                cityFilterFrame.items =  state.cities;
                cityFilterFrame.cellState =  0;
                
                FiltContent *cityFiltItem = cityFilterFrame.content;
                cityFiltItem.buttonArray = state.cities;
                
            }
            
            NSIndexPath *cityIndexPath =[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
            [self.FilterTableView reloadRowsAtIndexPaths:@[cityIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
            break;
            
        case 2:
        {
            
            NSString *para_city = [self.filerParameters valueForKey:KEY_CITY];
            BOOL Equal = [para_city isEqualToString:sender.currentTitle];
            
            if (Equal) {
                
                [self.filerParameters removeObjectForKey:KEY_CITY];
            }else{
                [self.filerParameters  setValue:sender.currentTitle forKey:KEY_CITY];
            }
            
        }
            break;
            
        case 3:
        {
            
            NSString *para_area = [self.filerParameters valueForKey:KEY_AREA];
            BOOL Equal = [para_area isEqualToString:sender.currentTitle];
            
            [self.filerParameters removeObjectForKey:KEY_SUBJECT];
            
            if (Equal) {
                
                [self.filerParameters removeObjectForKey:KEY_AREA];
                FilterContentFrame  *subjectFilterFrame = self.FiltItems[indexPath.row + 1];
                subjectFilterFrame.cellState =  2;
                
                
            }else{
                
                [self.filerParameters  setValue:sender.currentTitle forKey:KEY_AREA];
                
                
                NSArray *subjectes = [self makeCurrentSubjectWithArea:sender.currentTitle];
                
                FilterContentFrame  *subjectFilterFrame = self.FiltItems[indexPath.row + 1];
                subjectFilterFrame.items =  subjectes;
                subjectFilterFrame.cellState =  0;
                
                FiltContent *subjectFiltItem = subjectFilterFrame.content;
                subjectFiltItem.buttonArray = subjectes;
                
            }
            
            NSIndexPath *subjectIndexPath =[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
            [self.FilterTableView reloadRowsAtIndexPaths:@[subjectIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            
        }
            break;
            
        case 4:{
            
            
            NSString *parameter_subject = [self.filerParameters valueForKey:KEY_SUBJECT];
            BOOL Equal = [parameter_subject isEqualToString:sender.currentTitle];
            
            if (Equal) {
                
                [self.filerParameters removeObjectForKey:KEY_SUBJECT];
                
            }else{
                
                [self.filerParameters  setValue:sender.currentTitle forKey:KEY_SUBJECT];
                
            }
            
        }
            break;
        default:
            break;
    }
    
}
//移除黑色Cover
-(void)coverButtonClickRemoveOptionView:(UIButton *)sender
{
    
    [self rankTypeViewDown:NO];
    
}


//用于实现RankTypeView出现、隐藏
-(void)rankTypeViewDown:(BOOL)down
{
    
    if (down) {
        //当学校数组数量为0时，不显示排列选择表单
        self.CoverBgView.hidden = self.UniversityList.count == 0 ? YES : NO;
        self.cover.alpha = 0.5;
        [UIView animateWithDuration:0.25 animations:^{
            
            CGRect newRect = self.RankTypeTableView.frame;
            newRect.origin.y = 0;
            self.RankTypeTableView.frame = newRect;
            [self.RankTypeTableView reloadData];
        }];
        
        
    }else{
        
        
        [UIView animateWithDuration:0.25 animations:^{
            self.cover.alpha = 0;
            CGRect newRect = self.RankTypeTableView.frame;
            newRect.origin.y = -88;
            self.RankTypeTableView.frame = newRect;
            
        } completion:^(BOOL finished) {
            
            self.CoverBgView.hidden = YES;
            
        }];
        
        
    }
}


//用于实现FiltbackView出现、隐藏
-(void)FiltbackViewDown:(BOOL)down
{
    
    XJHUtilDefineWeakSelfRef;
    __block CGRect newRect  = self.FiltbackView.frame;
    
    if (!down) {
        
        
        newRect.origin.y = - FILTERBACKORGIN_Y;
        
        weakSelf.FiltbackView.frame = newRect;
        
        weakSelf.FiltbackView.alpha = 0;
        
        return;
        
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        
        newRect.origin.y = 0;
        
        weakSelf.FiltbackView.frame = newRect;
        
        weakSelf.FiltbackView.alpha = 1;
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

