
//
//  XNewSearchViewController.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/14.
//  Copyright © 2016年 UVIC. All rights reserved.
//

typedef enum {
    XReLoadStateNothing,
    XReLoadStateFail,
    XReLoadStateNomal
} XReLoadState;
//筛选参数提交状态  nomal - 确认   fail - 清空，或提交失败、或不提交   nothing - 不做任何操作、默认

#define FILTERBACKORGIN_Y   (XSCREEN_HEIGHT - 64)
#define PageSize 20

#import "XNewSearchViewController.h"
#import "NewSearchRstTableViewCell.h"
#import "XUCountry.h"
#import "CountryState.h"
#import "FiltContent.h"
#import "searchToolView.h"
#include "OptionItem.h"
#import "RankTypeTableViewCell.h"
#import "FilterSection.h"
#import "FilterTableViewCell.h"
#import "BottomBackgroudView.h"
//#import "UniversityCourseViewController.h"
#import "UniversitySubjectListViewController.h"
#import "searchSectionFootView.h"
#import "FilterContentFrame.h"
#import "UniversityFrameNew.h"
#import "UniversityNew.h"
#import "ApplySectionHeaderView.h"


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
//@property(nonatomic,copy)NSString *status;
@property(nonatomic,assign)XReLoadState ReloadStatus;
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
//用于保存筛选参数
@property(nonatomic,strong)NSMutableDictionary *filerParameters;
//用于保存最后一次提交筛选参数
@property(nonatomic,strong)NSMutableDictionary *lastFilerParameters;
//用于保存原始筛选参数，当在删除手动选项参数时，返回原始参数
@property(nonatomic,strong)NSDictionary *oldFilerParameters;

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
        self.RankType = orderBy.length ? orderBy : RANK_QS;
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
        
        self.RankType = orderBy.length ? orderBy : RANK_QS;
        
        
        if([key  isEqualToString: KEY_AREA]) {
            
            [self.filerParameters  setValue:value forKey:KEY_AREA];
            
        } else if([key  isEqualToString: KEY_COUNTRY]) {
            
            [self.filerParameters  setValue:value forKey:KEY_COUNTRY];
            
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

-(NSMutableDictionary *)lastFilerParameters
{
    if (!_lastFilerParameters) {
        
        _lastFilerParameters =[NSMutableDictionary dictionary];
    }
    return   _lastFilerParameters;
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
        //国家
        FiltContent  *fileritemCountry =[FiltContent createItemWithTitle:@"国家："andDetailTitle:@"全部" anditems: [self.CountriesArray valueForKey:@"countryName"]];
        FilterContentFrame *countryFrame = [FilterContentFrame FilterContentFrameWithContent:fileritemCountry];
        [temps addObject:countryFrame];
        
        NSArray *stateArray = nil;
        if (self.CoreCountry) {
            countryFrame.cellState = XcellStateHeightZero;
            stateArray = [self makeCurrentStateWithCountry:self.CoreCountry];
        }
 
        //地区
        FiltContent  *fileritemState =[FiltContent createItemWithTitle:GDLocalizedString(@"SearchResult_State") andDetailTitle:GDLocalizedString(@"SearchResult_All") anditems: stateArray];
        FilterContentFrame *stateFrame = [FilterContentFrame FilterContentFrameWithContent:fileritemState];
        [temps addObject:stateFrame];
        
        
        NSArray *currentCityArr = nil;
        if (self.CoreState) {
            countryFrame.cellState = XcellStateHeightZero;
            stateFrame.cellState = XcellStateHeightZero;
            CountryState  * currentState =[self makeCurrentCityWithState:self.CoreState country:self.CoreCountry];
            currentCityArr = currentState.cities;
        }
        
        //城市
        FiltContent  *fileritemCity =[FiltContent createItemWithTitle:GDLocalizedString(@"SearchResult_city") andDetailTitle:GDLocalizedString(@"SearchResult_All") anditems:currentCityArr];
        FilterContentFrame *cityFrame = [FilterContentFrame FilterContentFrameWithContent:fileritemCity];
        [temps addObject:cityFrame];
        
        if (self.Corecity) {
            countryFrame.cellState = XcellStateHeightZero;
            stateFrame.cellState = XcellStateHeightZero;
            cityFrame.cellState = XcellStateHeightZero;
        }
        
        //学科
        FiltContent *fileritemArea =[FiltContent createItemWithTitle:GDLocalizedString(@"SearchResult_subjectArea")  andDetailTitle:GDLocalizedString(@"SearchResult_All")anditems: [self.filterAreas valueForKeyPath:@"areaName"]];
        FilterContentFrame *areaFrame =  [FilterContentFrame FilterContentFrameWithContent:fileritemArea];
        [temps addObject:areaFrame];
        
        NSArray *subjectArray = nil;
        if (self.CoreArea) {
            areaFrame.cellState = XcellStateHeightZero;
            subjectArray =[self makeCurrentSubjectWithArea:self.CoreArea];
        }
        
        //专业
        FiltContent *fileritemSubject =[FiltContent createItemWithTitle:GDLocalizedString(@"SearchResult_subject") andDetailTitle:GDLocalizedString(@"SearchResult_All")  anditems:subjectArray];
        FilterContentFrame *subject =  [FilterContentFrame FilterContentFrameWithContent:fileritemSubject];
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
//    NSString *para_state = [self.filerParameters valueForKey:KEY_STATE];
//    
//    if (para_state.length > 0 ) {
//        
//        [self checkIsStar:para_state];
//        
//    }
//    NSString *country =[self.filerParameters valueForKey:KEY_COUNTRY];
//    if (country.length > 0 ) {
//        
//        [self checkIsStar:country];
//        
//    }
    
    
    [self makeUI];
    
    [self makeData:0];
    
     self.oldFilerParameters =[self.filerParameters copy];
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
 *  parameters 用于不同条件下参数判断
*/
-(void)checkIsStar:(NSDictionary *)parameters
{
    self.IsStar = NO;
    
    if ([self.RankType isEqualToString:RANK_QS]) {
        
        return;
    }
   
    
    NSString *country =[parameters valueForKey:KEY_COUNTRY];
    if (country.length) {
        
        if ([country isEqualToString:GDLocalizedString(@"CategoryVC-AU")]) {
            
            self.IsStar = YES;
            
            return;
        }
    }
    
    
    NSString *state =[parameters valueForKey:KEY_STATE];
    if (state.length) {
        
        NSArray *AU = [self.states_AU valueForKeyPath:@"stateName"];
        
        if ([AU containsObject:state]) {
            
            self.IsStar = YES;
            
            return;
        }
    }

    
    NSString *city =[parameters valueForKey:KEY_CITY];
    if (city.length) {
        for (CountryState *state in self.states_AU) {
            if ([state.cities  containsObject: city]) {
                
                self.IsStar = YES;
                
                return;
                
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
    self.ResultTableView =[[UITableView alloc] initWithFrame:CGRectMake(0,50, XSCREEN_WIDTH, XSCREEN_HEIGHT - 114) style:UITableViewStyleGrouped];
    self.ResultTableView.delegate = self;
    self.ResultTableView.dataSource = self;
    [self.view addSubview:self.ResultTableView];
    self.ResultTableView.tableFooterView =[[UIView alloc] init];
    
    UIView  *headerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, 30)];
    self.ResultTableView.tableHeaderView = headerView;
    self.headerTitleLabel =[[UILabel alloc] initWithFrame:CGRectMake(15, 0, XSCREEN_WIDTH, 30)];
    [headerView addSubview:self.headerTitleLabel];
    
    self.ResultTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    
    self.NoDataView =[XWGJnodataView noDataView];
    self.NoDataView.errorStr = GDLocalizedString(@"Evaluate-noData");
    self.NoDataView.hidden = YES;
    [self.view addSubview:self.NoDataView];
    
}
//排名tableView
-(void)makeRankTypeTableView
{
    //加蒙版
    self.CoverBgView =[[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.ToolView.frame), XSCREEN_WIDTH, XSCREEN_HEIGHT)];
    self.CoverBgView.hidden = YES;
    [self.view insertSubview:self.CoverBgView belowSubview:self.ToolView];
    UIButton  *cover =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, XSCREEN_HEIGHT)];
    self.cover = cover;
    [cover addTarget:self action:@selector(coverButtonClickRemoveOptionView:) forControlEvents:UIControlEventTouchUpInside];
    cover.backgroundColor =[UIColor blackColor];
    cover.alpha = 0;
    [self.CoverBgView addSubview:cover];
    
    self.RankTypeTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, -88, XSCREEN_WIDTH, 88) style:UITableViewStylePlain];
    self.RankTypeTableView.scrollEnabled = NO;
    self.RankTypeTableView.dataSource = self;
    self.RankTypeTableView.delegate = self;
    [self.CoverBgView addSubview:self.RankTypeTableView];
    
}


#pragma mark ———————— 顶部工具条
-(void)makeTopToolView
{
    XWeakSelf;
    
    self.ToolView =[[searchToolView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, 50)];
    
    NSString  *toolTitle = [self.RankType isEqualToString:RANK_TI] ?  @"本国排名":@"世界排名";
    
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
    self.FiltbackView =[[UIView alloc] initWithFrame:CGRectMake(0,-FILTERBACKORGIN_Y, XSCREEN_WIDTH, FILTERBACKORGIN_Y)];
    self.FiltbackView.backgroundColor = XCOLOR_RED;
    self.FiltbackView.alpha = 0;
    [self.view  insertSubview:self.FiltbackView belowSubview:self.ToolView];
    
    
    self.FilterTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 50 ,XSCREEN_WIDTH, XSCREEN_HEIGHT -164) style:UITableViewStylePlain];
    self.FilterTableView.dataSource = self;
    self.FilterTableView.delegate   = self;
    self.FilterTableView.allowsSelection = NO;
    self.FilterTableView.tableFooterView =[[UIView alloc] init];
    [self.FiltbackView addSubview: self.FilterTableView];
    
    self.bottomToolView = [[BottomBackgroudView alloc] initWithFrame:CGRectMake(0, self.FiltbackView.bounds.size.height - 50, XSCREEN_WIDTH, 50)];
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
    
    
   XWeakSelf
    //通过判断是不是澳大利亚城市正序或倒序
    if (XReLoadStateFail == self.ReloadStatus) {
        
        
        [self checkIsStar:self.lastFilerParameters];
        
    }else{
        
        
        [self checkIsStar:self.filerParameters];
        
    }
    
    
    
    NSNumber *desc = self.IsStar? @1:@0;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary: @{@"text": self.SearchValue,
                                                                                       @"page": [NSNumber numberWithInteger:page],
                                                                                       @"size": [NSNumber numberWithInteger:PageSize],
                                                                                       @"desc": desc,
                                                                                       @"order": self.RankType}];
    
 
    if (XReLoadStateFail == self.ReloadStatus) {
        //网络请求失败，使用最后一次请求参数，再次请求
   
        
        NSArray *filtes = [self getParameterArrayWithDictionary:self.lastFilerParameters];
        
        [parameters setValue:filtes forKey:@"filters"];
        
        
    }else{
 
        
        [self.lastFilerParameters removeAllObjects];
        
        NSArray *filtes = [self getParameterArrayWithDictionary:self.filerParameters];
        
        self.lastFilerParameters = [self.filerParameters mutableCopy];
        
        [parameters setValue:filtes forKey:@"filters"];
        
    }
    
    [self
     startAPIRequestWithSelector:kAPISelectorSearch
     parameters:parameters
     expectedStatusCodes:nil
     showHUD:YES
     showErrorAlert:YES
     errorAlertDismissAction:nil
     additionalSuccessAction:^(NSInteger statusCode, id response) {
         
         
         weakSelf.ReloadStatus = XReLoadStateFail;
         
         if (page == 0)  [weakSelf.UniversityList removeAllObjects];
         
         
         //添加数据源
         [response[@"universities"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
           
             UniversityFrameNew  *uniFrame = [UniversityFrameNew universityFrameWithUniverstiy:[UniversityNew mj_objectWithKeyValues:obj]];
  
             [weakSelf.UniversityList addObject:uniFrame];
             
         }];
         
         
         [weakSelf.ResultTableView reloadData];
         
         //每一次重新请求时，回到tableView顶部
         if (page == 0)  [weakSelf.ResultTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
             
         
         weakSelf.NextPage = page + 1; //加载下一页PageNumber
         
         //数据请求为0是显示或隐藏关于控件
         weakSelf.NoDataView.hidden = weakSelf.UniversityList.count == 0 ? NO : YES;
         
         
         //筛选时先删除optionTabel的数据源，重新添加数据源
         [weakSelf.RankTypeList removeAllObjects];
         
         
         for (NSString *typeName in response[@"rankTypes"]) {
             OptionItem *Option_item = [OptionItem CreateOpitonItemWithRank:typeName];
             NSString *QSRank = [GDLocalizedString(@"SearchRank_World") lowercaseString];
             if([typeName isEqualToString:QSRank])
             {
                 [weakSelf.RankTypeList insertObject:Option_item atIndex:0];
                 
             }else{
                 [weakSelf.RankTypeList addObject:Option_item];
                 
             }
             
             weakSelf.RankTypeTableView.height =  weakSelf.RankTypeList.count * 44;
         }
         
         
         //显示ToolView左侧按钮Title
         int index = [weakSelf.RankType isEqualToString:RANK_TI] ? 1 : 0;
         OptionItem *rank = weakSelf.RankTypeList[index];
         [weakSelf.ToolView.leftButton setTitle:rank.RankTypeName forState:UIControlStateNormal];
         //记住是第几个排序
         weakSelf.selectRankTypeIndex = index;
         
         //  加载更多是否显示
         if ([response[@"universities"] count] < PageSize) {
             
             [weakSelf.ResultTableView.mj_footer endRefreshingWithNoMoreData];
             
         }else{
             
             [weakSelf.ResultTableView.mj_footer endRefreshing];
             
         }
         
         
         NSString *countStr =[NSString stringWithFormat:@"%@",response[@"count"]];
         
         //显示搜索结果数量
         [weakSelf fixHeaderTitleLabelWithCount:countStr];
         
     } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
         
         weakSelf.ReloadStatus = XReLoadStateFail;
         
         [weakSelf.ResultTableView.mj_footer endRefreshing];
         
     }];
}
//用于网络请求  根据筛选参数字典得到相着参数数组
-(NSArray *)getParameterArrayWithDictionary:(NSDictionary *)parameters
{
    
    NSMutableArray *temps =[NSMutableArray array];
    NSString *parameter_area =[parameters valueForKey:KEY_AREA];
    if (parameter_area.length) {
        [temps addObject:@{@"name": KEY_AREA, @"value": parameter_area}];
    }
    
    NSString *parameter_subject = [parameters valueForKey:KEY_SUBJECT];
    if (parameter_subject.length) {
        [temps addObject:@{@"name": KEY_SUBJECT, @"value": parameter_subject}];
    }
    
    
    NSString *country =[parameters valueForKey:KEY_COUNTRY];
    if(country.length) {
        [temps addObject:@{@"name": KEY_COUNTRY, @"value": country}];
    }
    
    
    NSString *para_state = [parameters valueForKey:KEY_STATE];
    
    if(para_state.length) {
        [temps addObject:@{@"name": KEY_STATE, @"value": para_state}];
    }
    
    NSString *para_city = [parameters valueForKey:KEY_CITY];
    if (para_city.length) {
        [temps addObject:@{@"name": KEY_CITY, @"value": para_city}];
    }
    
    return [temps copy];
    
}

#pragma mark ——— UITableViewDelegate  UITableViewDataSoure
//超出cell的bounds范围，不能显示
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.clipsToBounds = YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (tableView == self.ResultTableView) {
        
        return Uni_Cell_Height;
        
    }else{
        
        return 0;
        
    }
    
}


- (UITableViewHeaderFooterView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.ResultTableView) {
        
        XWeakSelf
        
        UniversityFrameNew *uniFrame = self.UniversityList[section];
        ApplySectionHeaderView  *sectionView= [ApplySectionHeaderView sectionHeaderViewWithTableView:tableView];
        [sectionView addButtonHiden];
        sectionView.optionOrderBy = self.RankType;
        sectionView.uniFrame = uniFrame;
        sectionView.newActionBlock = ^(NSString *uni_id){
        
              [weakSelf.navigationController pushUniversityViewControllerWithID:uni_id animated:YES];
        };
        
        return sectionView;
        
    }else{
        
        
        return nil;
        
    }
    
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    XWeakSelf;
    
    UniversityFrameNew *uniFrame = self.UniversityList[section];
    if (uniFrame.universtiy.courses.count) {
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

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (tableView == self.FilterTableView) {
        
        FilterContentFrame *item = self.FiltItems[indexPath.row];
        
        return item.cellHeigh;
        
    }else if (tableView == self.RankTypeTableView) {
        
        return 44;
        
    }else{
        
        UniversityFrameNew *uniFrame = self.UniversityList[indexPath.section];
        
        return  uniFrame.universtiy.courses.count > 0 ? 70 : 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == self.RankTypeTableView || tableView == self.FilterTableView) {
        
        return 0;
        
    }else{
        

        UniversityFrameNew *uniFrame = self.UniversityList[section];
        
        if ( uniFrame.universtiy.courses.count) {
            
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
        
        
        UniversityFrameNew *uniFrame = self.UniversityList[section];
        
        if (uniFrame.universtiy.courses.count > 0) {
             //只显示部分数据
            return  uniFrame.universtiy.courses.count > 3 ? 3 : uniFrame.universtiy.courses.count;
            
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

        
        UIImage *accessoryImage = indexPath.row == self.selectRankTypeIndex ? [UIImage imageNamed:@"check-icons-yes"] : nil;
        cell.accessoryMV.image = accessoryImage;
        UIColor *textColor = indexPath.row == self.selectRankTypeIndex ? XCOLOR_RED : XCOLOR_BLACK;
        cell.TitleLab.textColor = textColor;

        
        
        return cell;
        
        
    }else {
        
        
        NewSearchRstTableViewCell *cell =[NewSearchRstTableViewCell  cellWithTableView:tableView];
        UniversityFrameNew *uniFrame = self.UniversityList[indexPath.section];
        NSDictionary *itemInfo =uniFrame.universtiy.courses[indexPath.row];
  
        if (uniFrame.universtiy.courses.count > 0) {
            
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
        
        
        if (country.length == 0 && state.length == 0 &&para_city.length == 0 && self.CoreState.length == 0) {
            
            //如果国家、地区选项为空时排序方式设置为 RANK_QS
            self.RankType = RANK_QS;
        }
        
        
        //清空上一次的数据，重新加载
        [self.UniversityList removeAllObjects];
        
        self.ReloadStatus = XReLoadStateNomal;
        
        [self makeData:0];
        
        self.ToolView.rightButton.selected = NO;
        
        
    }else{
        
        //清空参数选项数据
        [self.filerParameters removeAllObjects];
        self.filerParameters = [self.oldFilerParameters mutableCopy];
        [self.FiltItems removeAllObjects];
         self.FiltItems = [self.coreFiltItems mutableCopy];
        [self.FilterTableView reloadData];
    }
    
    
}


#pragma mark —————————— FilterTableViewCellDelegate
-(void)FilterTableViewCell:(FilterTableViewCell *)tableViewCell  WithButtonItem:(UIButton *)sender WithIndexPath:(NSIndexPath *)indexPath
{
    
    
    FilterContentFrame  *filterFrame = self.FiltItems[indexPath.row];
    
    if (sender.tag == 999) {
        
        if (filterFrame.cellState == XcellStateBaseHeight) {
            
            filterFrame.cellState = XcellStateRealHeight;
            
        }else if(filterFrame.cellState == XcellStateRealHeight){
            
            filterFrame.cellState = XcellStateBaseHeight;
            
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
            
            //当用户选择或取消国家时，移除state 、city 参数
            [self.filerParameters removeObjectForKey:KEY_STATE];
            [self.filerParameters removeObjectForKey:KEY_CITY];
            
            if (Equal) {
                
                [self.filerParameters removeObjectForKey:KEY_COUNTRY];
                FilterContentFrame  *stateFilterFrame = self.FiltItems[indexPath.row + 1];
                stateFilterFrame.cellState =  XcellStateHeightZero;
                
                
            }else{
                
                [self.filerParameters  setValue:sender.currentTitle forKey:KEY_COUNTRY];
                
                //得到对应国家的state数组
                NSArray *states = [self makeCurrentStateWithCountry:sender.currentTitle];
                
                FilterContentFrame  *stateFilterFrame = self.FiltItems[indexPath.row + 1];
                stateFilterFrame.items =  states;
                stateFilterFrame.cellState =  XcellStateRealHeight;
                
                FiltContent *stateFiltItem = stateFilterFrame.content;
                stateFiltItem.buttonArray = states;
                
            }
            
            
            NSIndexPath *stateIndexPath =[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
            
            FilterContentFrame  *cityFilterFrame = self.FiltItems[indexPath.row + 2];
            cityFilterFrame.cellState =  XcellStateHeightZero;
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
                cityFilterFrame.cellState =  XcellStateHeightZero;
                
                
                
            }else{
                
                [self.filerParameters  setValue:sender.currentTitle forKey:KEY_STATE];
                
                NSString *countryName = self.CoreCountry ? self.CoreCountry :[self.filerParameters valueForKey:KEY_COUNTRY];
                
                CountryState *state =[self makeCurrentCityWithState:sender.currentTitle country:countryName];
                
                FilterContentFrame  *cityFilterFrame = self.FiltItems[indexPath.row + 1];
                cityFilterFrame.items =  state.cities;
//                cityFilterFrame.cellState =  XcellStateRealHeight;
                
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
                subjectFilterFrame.cellState =  XcellStateHeightZero;
                
                
            }else{
                
                [self.filerParameters  setValue:sender.currentTitle forKey:KEY_AREA];
                
                
                NSArray *subjectes = [self makeCurrentSubjectWithArea:sender.currentTitle];
                
                FilterContentFrame  *subjectFilterFrame = self.FiltItems[indexPath.row + 1];
                subjectFilterFrame.items =  subjectes;
                subjectFilterFrame.cellState =  XcellStateRealHeight;
                
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
    
    self.ToolView.leftButton.selected = NO;
    self.ToolView.rightButton.selected = NO;
    self.ToolView.LeftView.image = [UIImage imageNamed:@"arrow_down"];

    [self rankTypeViewDown:NO];
    
}


//用于实现RankTypeView出现、隐藏
-(void)rankTypeViewDown:(BOOL)down
{
    XWeakSelf
    if (down) {
        //当学校数组数量为0时，不显示排列选择表单
        self.CoverBgView.hidden = self.UniversityList.count == 0 ? YES : NO;
        self.cover.alpha = 0.5;
      
        [UIView animateWithDuration:ANIMATION_DUATION animations:^{
            
            CGRect newRect = weakSelf.RankTypeTableView.frame;
            newRect.origin.y = 0;
            weakSelf.RankTypeTableView.frame = newRect;
            [weakSelf.RankTypeTableView reloadData];
        }];
        
        
    }else{
        
        
        [UIView animateWithDuration:0.25 animations:^{
           
            weakSelf.cover.alpha = 0;
            CGRect newRect = weakSelf.RankTypeTableView.frame;
            newRect.origin.y = -88;
            weakSelf.RankTypeTableView.frame = newRect;
            
        } completion:^(BOOL finished) {
            
            weakSelf.CoverBgView.hidden = YES;
            
        }];
        
    }
    
    
    
}


//用于实现FiltbackView出现、隐藏
-(void)FiltbackViewDown:(BOOL)down
{
    
    XWeakSelf;
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

-(void)dealloc
{
    KDClassLog(@"搜索结果  dealloc");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end

