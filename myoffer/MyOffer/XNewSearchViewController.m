
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
@property(nonatomic,assign)NSInteger SelectIndex_area;
@property(nonatomic,assign)NSInteger SelectIndex_city;
@property(nonatomic,assign)NSInteger SelectIndex_state;
@property(nonatomic,assign)NSInteger SelectIndex_country;
@property(nonatomic,assign)NSInteger SelectIndex_subJect;
//搜索科目、专业、城市、国家、地区参数
@property(nonatomic,copy)NSString *area;
@property(nonatomic,copy)NSString *city;
@property(nonatomic,copy)NSString *state;
@property(nonatomic,copy)NSString *country;
@property(nonatomic,copy)NSString *subJect;
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
@property(nonatomic,strong)NSArray *areas;
//筛选国家名称数组
@property(nonatomic,strong)NSArray *countryNameArr;
//英国地区数组
@property(nonatomic,strong)NSArray *states_UK;
//澳大利亚地区数组
@property(nonatomic,strong)NSArray *states_AU;
//科目专业字典（包含二级科目数据）数组
@property(nonatomic,strong)NSArray *subjectInfores;
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
            
            self.area = value;
            
        } else if([key  isEqualToString: KEY_COUNTRY]) {
            
            
        } else if([key  isEqualToString: KEY_STATE]) {
            
            self.state = value;
            
            self.selectRankTypeIndex = 1;
        }
        
    }
    return self;
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


-(NSArray *)subjectInfores{
    
    if (!_subjectInfores) {
        
        //从本地存储数据中加载科目专业数据
         NSString *keyWord  = USER_EN ? @"Subject_EN" :@"Subject_CN";
         NSArray *values = [[NSUserDefaults standardUserDefaults] valueForKey:keyWord];
        
        NSMutableArray *temps = [NSMutableArray array];
        
        for (NSDictionary *itemInfo in values) {
            
            FilterSection *filtSection = [FilterSection FilterSectionWithDictionary:itemInfo];
            
            [temps addObject:filtSection];
        }
        
        _subjectInfores = [temps copy];
        
    }
    return _subjectInfores;
}

-(NSArray *)areas
{
    if (!_areas) {
                 //从本地存储数据中加载科目名称数据
        _areas = [self.subjectInfores valueForKeyPath:@"subjectName"];
    }
    return _areas;
}


#pragma mark ———————— 筛选表单数据
-(NSMutableArray *)FiltItems
{
    if (!_FiltItems) {
        //选项数据
        
        FiltContent  *fileritemCountry =[FiltContent createItemWithTitle:GDLocalizedString(@"SearchResult_Country") andDetailTitle:GDLocalizedString(@"SearchResult_All") anditems: [self.CountriesArray valueForKey:@"countryName"]];
        
        if (self.CoreCountry) {
            //如果用户选择地区进搜索页，则隐藏国家cell
            fileritemCountry.cellHiden = YES;
        }
        
        
        if (self.CoreState) {
        //如果用户选择地区进搜索页，则隐藏国家cell
             fileritemCountry.cellHiden = YES;
        }
        
        NSArray *stateArr = nil;
        if (self.CoreCountry) {
              stateArr = [self.CoreCountry isEqualToString:GDLocalizedString(@"CategoryVC-AU")] ? [self.states_AU valueForKeyPath:@"stateName"]:[self.states_UK valueForKeyPath:@"stateName"];
         }
        
        FiltContent  *fileritemState =[FiltContent createItemWithTitle:GDLocalizedString(@"SearchResult_State") andDetailTitle:GDLocalizedString(@"SearchResult_All") anditems: stateArr];
        fileritemState.cellHiden = self.CoreCountry ? NO :YES;
        
        
        
        FiltContent  *fileritemCity =[FiltContent createItemWithTitle:GDLocalizedString(@"SearchResult_city") andDetailTitle:GDLocalizedString(@"SearchResult_All") anditems: nil];
        fileritemCity.cellHiden = YES;
        
        
        FiltContent *fileritemArea =[FiltContent createItemWithTitle:GDLocalizedString(@"SearchResult_subjectArea")  andDetailTitle:GDLocalizedString(@"SearchResult_All")anditems: self.areas];
        
        NSArray *subjectes = nil;
        if (self.CoreArea) {
            //如果用户选择专业进搜索页面，则隐藏一级科目CEll,出现对应二级科目专业
            fileritemArea.cellHiden = YES;
            NSInteger index = [self.areas indexOfObject:self.CoreArea];
            FilterSection *filtSection = self.subjectInfores[index];
            subjectes = [filtSection.subjectArray valueForKeyPath:@"courseName"];
        }
        
        FiltContent *fileritemSubject =[FiltContent createItemWithTitle:GDLocalizedString(@"SearchResult_subject") andDetailTitle:GDLocalizedString(@"SearchResult_All")  anditems:subjectes];
        fileritemSubject.cellHiden = YES;
        if (self.CoreArea) {
            fileritemSubject.cellHiden = NO;
        }
        
        
        if (!self.CoreState) {
            NSArray *temps = @[fileritemCountry,fileritemState,fileritemCity,fileritemArea,fileritemSubject];
            _FiltItems = [temps mutableCopy];
            
        }else{
            
            //如果用户选择地区进搜索页面，筛选tableView，出现相应地区选项所有城市
            NSArray *UK = [self.states_UK valueForKeyPath:@"stateName"];
            NSArray *AU = [self.states_AU valueForKeyPath:@"stateName"];
            
            NSArray *cities;
            if ([UK containsObject:self.CoreState]) {
                
                NSInteger index = [UK indexOfObject:self.state];
                 CountryState *state = self.states_UK[index];
                cities = state.cities;
                
            }else{
                
                NSInteger index = [AU indexOfObject:self.state];
                CountryState *state = self.states_AU[index];
                cities = state.cities;
             }
            
            FiltContent  *CoreCity =[FiltContent createItemWithTitle:GDLocalizedString(@"SearchResult_city") andDetailTitle:GDLocalizedString(@"SearchResult_All") anditems: cities];
            CoreCity.cellHiden = cities.count == 0 ? YES : NO;
            
            NSArray *temps = @[fileritemCountry,fileritemState,CoreCity,fileritemArea,fileritemSubject];
            
            _FiltItems = [temps mutableCopy];
            
            _coreFiltItems = [temps mutableCopy];

            
        }
        
    }
    return _FiltItems;
}




- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //判断是否是澳大利亚国家选项
    if (self.state.length > 0 ) {
        
        [self checkIsStar:self.state];
        
    }
    if (self.country.length > 0 ) {
        
        [self checkIsStar:self.country];
        
    }
    
    [self makeOther];
    
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
    
    if (self.country.length) {
        
        //如果self.country 存在，判断是不是澳大利亚
        if ([self.country isEqualToString:self.countryNameArr[index_AU]]) {
            
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
    
    if (self.state.length) {
        
        NSArray *AU = [self.states_AU valueForKeyPath:@"stateName"];
        
        if ([AU containsObject:self.state]) {
            
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
    
    if (self.city.length) {
        
        for (CountryState *state in self.states_AU) {
            
            if ([state.cities  containsObject: self.city]) {
                
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

-(void)makeOther
{
    //初始化
    self.SelectIndex_country = DefaultNumber;
    self.SelectIndex_state = DefaultNumber;
    self.SelectIndex_area = DefaultNumber;
    self.SelectIndex_subJect = DefaultNumber;
    self.SelectIndex_city = DefaultNumber;
    
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
    
    
}

-(XWGJnodataView *)NoDataView
{
    if (!_NoDataView) {
        
        _NoDataView =[XWGJnodataView noDataView];
        _NoDataView.hidden = YES;
        _NoDataView.contentLabel.text = GDLocalizedString(@"Evaluate-noData");
        [self.view insertSubview:_NoDataView aboveSubview:self.ToolView];
    }
    
    return _NoDataView;
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
            
            [filtersM addObject:@{@"name": @"area", @"value": self.Pre_area}];
            
        }
        
        if(self.Pre_country.length) {
            
            [filtersM addObject:@{@"name": @"country", @"value": self.Pre_country}];
        }
        
        
        if(self.Pre_state.length) {
            
            [filtersM addObject:@{@"name": @"state", @"value": self.Pre_state}];
            
        }
        
        if (self.Pre_city.length) {
            
            [filtersM addObject:@{@"name": @"city", @"value": self.Pre_city}];
            
        }
        
        
        if (self.Pre_subJect.length) {
            
            [filtersM addObject:@{@"name": @"subject", @"value": self.Pre_subJect}];
        }
        
        
        if(self.CoreCountry) {
            
            [filtersM addObject:@{@"name": @"country", @"value": self.CoreCountry}];
        }
        
        if (self.CoreState) {
            
            [filtersM addObject:@{@"name": @"state", @"value": self.CoreState}];
        }
        
        if (self.CoreArea) {
            
            [filtersM addObject:@{@"name": @"area", @"value": self.CoreArea}];
            
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
        
        if (self.area.length) {
            
            [filtersM addObject:@{@"name": @"area", @"value": self.area}];
            
            self.Pre_area = self.area;
        }
        if (self.CoreArea) {
            
            [filtersM addObject:@{@"name": @"area", @"value": self.CoreArea}];
            self.Pre_area = self.CoreArea;
            
        }
        
        if(self.country.length) {
            
            [filtersM addObject:@{@"name": @"country", @"value": self.country}];
            self.Pre_country = self.country;
        }
        
        if(self.CoreCountry.length) {
            
            [filtersM addObject:@{@"name": @"country", @"value": self.CoreCountry}];
            self.Pre_country = self.CoreCountry;
        }

        
        if (self.CoreState) {
            
            [filtersM addObject:@{@"name": @"state", @"value": self.CoreState}];
            self.Pre_state = self.CoreState;
        }
        
        
        
        if(self.state.length) {
            
            [filtersM addObject:@{@"name": @"state", @"value": self.state}];
            self.Pre_state = self.state;
            
        }
        
        if (self.city.length) {
            
            [filtersM addObject:@{@"name": @"city", @"value": self.city}];
            self.Pre_city = self.city;
            
        }
        
        
        if (self.subJect.length) {
            
            [filtersM addObject:@{@"name": @"subject", @"value": self.subJect}];
            self.Pre_subJect = self.subJect;
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
         NSInteger index = [self.RankType isEqualToString:RANKTI] ? 1 : 0;
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
         
         self.NoDataView.hidden = NO;
         self.NoDataView.contentLabel.text = GDLocalizedString(@"NetRequest-noNetWork");
         
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
        
        FiltContent *fileritem = self.FiltItems[indexPath.row];
        
        if (fileritem.cellHiden ) {
            
            return 0;
            
        }else{
            
            return fileritem.contentheigh + 30;
            
        }
        
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
        FiltContent *fileritem = self.FiltItems[indexPath.row];
        switch (indexPath.row) {
            case 0:
            {
                if (DefaultNumber != self.SelectIndex_country) {
                    
                    Fcell.selectButtonTag =  self.SelectIndex_country;
                }
            }
                break;
            case 1:
            {
                if (DefaultNumber != self.SelectIndex_state) {
                    
                    Fcell.selectButtonTag = self.SelectIndex_state;
                }
            }
                break;
            case 2:
            {
                if (DefaultNumber != self.SelectIndex_city) {
                    
                    Fcell.selectButtonTag = self.SelectIndex_city;
                }
            }
                break;
            case 3:
            {
                
                if (DefaultNumber != self.SelectIndex_area) {
                    
                    Fcell.selectButtonTag = self.SelectIndex_area;
                }
            }
                break;
            case 4:
            {
                
                if (DefaultNumber != self.SelectIndex_subJect) {
                    
                    Fcell.selectButtonTag = self.SelectIndex_subJect;
                }
            }
                break;
                
            default:
                
                break;
        }
        
        Fcell.fileritem = fileritem.cellHiden ? nil:fileritem;
        
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
        
        
        //        UITableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
        
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
        
        if (self.country.length == 0 &&self.state.length == 0 &&self.city.length == 0 &&self.CoreState == 0) {
            
            //如果国家、地区选项为空时排序方式设置为 RANKQS
            self.RankType = RANKQS;
        }
  
        
        //清空上一次的数据，重新加载
        [self.UniversityList removeAllObjects];
        
        self.status = StatusNo;
        
        [self makeData:0];
        
        
    }else{
        
        //清空参数选项数据
        self.country = @"";
        self.subJect = @"";
        self.state = @"";
        self.area = @"";
        self.city = @"";
        [self makeOther];
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
    
    KDClassLog(@"---FilterTableViewCellDelegate-------%d--%d--",sender.tag,indexPath.row);
    
    switch (indexPath.row) {
        case 0:
        {
            
            BOOL Equal = [self.country isEqualToString:sender.currentTitle];
            
            
            if (!Equal) {
                
                self.country = sender.currentTitle;
                
                XUCountry *Country =   self.CountriesArray[sender.tag];
                NSArray *states = [Country.states valueForKeyPath:@"stateName"];
                FiltContent *fileriteState =[FiltContent createItemWithTitle:GDLocalizedString(@"SearchResult_State")  andDetailTitle:GDLocalizedString(@"SearchResult_All") anditems:states];
                //给对应国家的地区选项添加数据
                [self FilterTableViewReloadWithIndex:indexPath.row + 1 andfiltItem:fileriteState];
                
                
                self.state = @""; //当点击国家选项时，地区选项工清空
                self.city = @""; //当点击国家选项时，地区选项工清空
                
                self.SelectIndex_country = sender.tag;
                
                self.SelectIndex_state = DefaultNumber;
                
                FiltContent *Fcity = self.FiltItems[2];
                
                Fcity.cellHiden = YES;
                
                
                [self.FilterTableView reloadData];
                
            }else {
                
                self.country = @"";
                self.SelectIndex_country = DefaultNumber;
                
                self.state = @"";
                self.SelectIndex_state = DefaultNumber;
                FiltContent *fileriteState = self.FiltItems[1];
                fileriteState.cellHiden = YES;
                
                
                self.city = @"";
                self.SelectIndex_city = DefaultNumber;
                FiltContent *fileriteCity = self.FiltItems[2];
                fileriteCity.cellHiden = YES;
                [self.FilterTableView reloadData];
                
            }
            
            
        }
            break;
            
        case 1:
        {
            
            
            BOOL Equal = [self.state isEqualToString:sender.currentTitle];
            
            if (!Equal) {
                
                self.state = sender.currentTitle;
                self.SelectIndex_state = sender.tag;
                self.SelectIndex_city = DefaultNumber;
                self.city = @"";
                
                NSArray *UK = [self.states_UK valueForKeyPath:@"stateName"];
                NSArray *AU = [self.states_AU valueForKeyPath:@"stateName"];
                
                if ([AU containsObject:self.state]) {
                    
                    NSInteger index = [AU indexOfObject:self.state];
                    CountryState *state = self.states_AU[index];
                    FiltContent  *fileritemCity =[FiltContent createItemWithTitle:GDLocalizedString(@"SearchResult_city") andDetailTitle:GDLocalizedString(@"SearchResult_All") anditems: state.cities];
                    fileritemCity.cellHiden = state.cities.count == 0 ? YES : NO;
                    [self FilterTableViewReloadWithIndex:2 andfiltItem:fileritemCity];
                    
                    
                }else if([UK containsObject:self.state]){
                    
                    NSInteger index = [UK indexOfObject:self.state];
                    CountryState *state = self.states_UK[index];
                    FiltContent  *fileritemCity =[FiltContent createItemWithTitle:GDLocalizedString(@"SearchResult_city") andDetailTitle:GDLocalizedString(@"SearchResult_All") anditems: state.cities];
                    fileritemCity.cellHiden = state.cities.count == 0 ? YES : NO;
                    [self FilterTableViewReloadWithIndex:2 andfiltItem:fileritemCity];
                    
                }
                
            }else{
                
                self.state = @"";
                self.SelectIndex_state = DefaultNumber;
                
                self.city = @"";
                self.SelectIndex_city = DefaultNumber;
                FiltContent  *fileritemCity = self.FiltItems[2];
                fileritemCity.cellHiden = YES;
                [self.FilterTableView reloadData];
            }
            
        }
            break;
            
        case 2:
        {
            
            self.city =  [self.city isEqualToString:sender.currentTitle] ? @"" : sender.currentTitle;
            
            //是否记住已选择项
            self.SelectIndex_city = self.city.length > 0 ? sender.tag : DefaultNumber;
            
        }
            break;
            
        case 3:
        {
            
            BOOL Equal =  [self.area isEqualToString:sender.currentTitle];
            
            
            if (!Equal) {
                
                self.area =   sender.currentTitle;
                
                FilterSection *filtSection = self.subjectInfores[sender.tag];
                
                NSArray *Subjectes = [filtSection.subjectArray valueForKeyPath:@"courseName"];
                FiltContent *fileritemSubject =[FiltContent createItemWithTitle:GDLocalizedString(@"SearchResult_subject") andDetailTitle:GDLocalizedString(@"SearchResult_All")  anditems:Subjectes];
                
                [self FilterTableViewReloadWithIndex:indexPath.row + 1 andfiltItem:fileritemSubject];
                
                self.subJect = @""; //当点击科目选项时，专业选项清空
                
                self.SelectIndex_area = sender.tag;
                
                self.SelectIndex_subJect = DefaultNumber;
                
            }else {
                
                self.area = @"";
                self.SelectIndex_area = DefaultNumber;
                
                
                self.subJect = @"";
                self.SelectIndex_subJect = DefaultNumber;
                FiltContent *fileritemSubject = self.FiltItems[4];
                fileritemSubject.cellHiden = YES;
                [self.FilterTableView reloadData];
                
                
            }
            
            
            
        }
            break;
            
        case 4:{
            
            self.subJect =  [self.subJect isEqualToString:sender.currentTitle] ? @"" : sender.currentTitle;
            //是否记住已选择项
            self.SelectIndex_subJect = self.subJect.length > 0 ? sender.tag : DefaultNumber;
            
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
     self.ToolView.leftButton.selected = NO;

    
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

