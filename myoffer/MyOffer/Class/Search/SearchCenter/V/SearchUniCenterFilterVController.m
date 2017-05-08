//
//  SearchUniCenterFilterVController.m
//  myOffer
//
//  Created by xuewuguojie on 2017/4/25.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "SearchUniCenterFilterVController.h"
#import "UniversityCourseFilterCell.h"
#import "MyOfferArea.h"
#import "MyOfferSubjecct.h"
#import "MyOfferCountry.h"
#import "MyOfferCountryState.h"
#import "FiltContent.h"
#import "FilterContentFrame.h"
#import "FilterTableViewCell.h"
#import "MyOfferRank.h"

#define KEY_ALL  @"全部"

typedef NS_ENUM(NSUInteger, filterButtonStyle) {
    
    filterButtonStyleDefault = 0,
    filterButtonStyleClear,
    filterButtonStyleSubmit,
    filterButtonStyleRank,
    filterButtonStyleOption
};


#define KEY_TEXT_SF  @"text"
#define KEY_NAME_SF  @"name"
#define KEY_VALUE_SF  @"value"
#define KEY_FILTERS_SF  @"filters"
#define KEY_PAGE_SF  @"page"
#define KEY_SIZE_SF  @"size"
#define KEY_DESC_SF  @"desc"
#define KEY_ORDER_SF  @"order"
#define Bottom_Heigh  70
#define Bottom_botton_Heigh  50
#define Top_Heigh  50
#define Cell_Heigh  50


@interface SearchUniCenterFilterVController ()<UITableViewDataSource,UITableViewDelegate,FilterTableViewCellDelegate>
//顶部工具条背景
@property(nonatomic,strong)UIView *topView;
//筛选按钮
@property(nonatomic,strong)UIButton *optionBtn;
//排名按钮
@property(nonatomic,strong)UIButton *rankingBtn;
//当前选中按钮
@property(nonatomic,strong)UIButton *currentBtn;
//学科领域数组
@property(nonatomic,strong)NSArray *areas;
//国家地区数组
@property(nonatomic,strong)NSArray *countries;
//筛选数组
@property(nonatomic,strong)NSMutableArray *FiltItems;
@property(nonatomic,strong)NSMutableArray *FiltItems_origin;
@property(nonatomic,strong)UITableView *rank_table,*option_table;
//清空筛选数据按钮
@property(nonatomic,strong)UIButton *clearBtn;
//提交筛选数据按钮
@property(nonatomic,strong)UIButton *submitBtn;
//清空筛选数据按钮  提交筛选数据按钮 的父容器
@property(nonatomic,strong)UIView *footerView;
//option_table  footerView的父容器
@property(nonatomic,strong)UIView *bgView;
//添加网络请求参数
@property(nonatomic,strong)NSMutableArray *filterParameters;

@end

@implementation SearchUniCenterFilterVController

- (instancetype)initWithActionBlock:(SearchUniCenterFilterViewBlock)actionBlock{
    
    self = [self init];
    
    if (self) {
        
        self.actionBlock = actionBlock;
        
    }
    return self;
    
}

- (NSMutableArray *)filterParameters{

    if (!_filterParameters) {
    
        _filterParameters = [NSMutableArray array];
    }
    
    return _filterParameters;
}


- (NSArray *)areas{

    if (!_areas) {
        
        NSArray *item_subjects = [[NSUserDefaults standardUserDefaults] valueForKey:@"Subject_CN"];
        
        _areas = [MyOfferArea mj_objectArrayWithKeyValuesArray:item_subjects];
        
    }
    
    return _areas;
}


- (NSArray *)countries{

    if (!_countries) {
        
        NSArray *country_temps = [[NSUserDefaults standardUserDefaults] valueForKey:@"Country_CN"];
        
         _countries = [MyOfferCountry mj_objectArrayWithKeyValuesArray:country_temps];
        
    }
    
    return _countries;
}


- (NSMutableArray *)FiltItems_origin{

    if (!_FiltItems_origin) {
        
        _FiltItems_origin = [NSMutableArray array];
    }
    
    return _FiltItems_origin;
}


//获取学科领域
- (MyOfferArea *)makeCurrentSubjectWithArea:(NSString *)areaName{

    NSArray *areas = [self.areas valueForKeyPath:@"name"];
    
    NSInteger index = [areas indexOfObject:areaName];
    
    return self.areas[index];
}

//获取当前国家
- (MyOfferCountry *)makeCurrentStateWithCountry:(NSString *)countryName{
    
    NSArray *countries = [self.countries valueForKeyPath:@"name"];
    
    NSInteger index = [countries indexOfObject:countryName];
    
    return  self.countries[index];
}


//根据条件   获取当前国家地区
-(MyOfferCountryState *)makeCurrentCityWithState:(NSString *)stateName  country:(NSString *)countryName{
    
    MyOfferCountryState *currentState = nil;
    
    if (countryName) {
        
        MyOfferCountry *countryModel = [self makeCurrentStateWithCountry:countryName];
        
        NSArray *states = [countryModel.states valueForKeyPath:@"name"];
        
        NSInteger index = [states indexOfObject:stateName];
        
        currentState = countryModel.states[index];
        
        return  currentState;
    }
    
    
    if(stateName){
        
        for (MyOfferCountry *countryModel in self.countries) {
        
            NSArray *states = [countryModel.states valueForKeyPath:@"name"];
            
            if ([states containsObject:stateName]) {
                
                NSInteger index = [states indexOfObject:stateName];
                
                currentState = countryModel.states[index];
                
                break;
                
            }

        }
        
        return currentState;
        
    }else{
    
    
        return currentState;
    
    }
}


#pragma mark : 筛选表单数据

-(NSMutableArray *)FiltItems
{
    if (!_FiltItems) {
        //选项数据
        
        NSMutableArray *temps =[NSMutableArray arrayWithCapacity:5];
        
        //国家
        FiltContent  *filter_country = [FiltContent filterWithIcon:nil title:@"国家:"  subtitlte:KEY_ALL filterOptionItems:[self.countries valueForKeyPath:@"name"]];
        filter_country.optionStyle = FilterOptionCountry;
        FilterContentFrame *filter_country_Frame = [FilterContentFrame filterFrameWithFilter:filter_country];
        [temps addObject:filter_country_Frame];
        
        NSArray *stateArray = nil;
        if (self.coreCountry) {
            
            filter_country_Frame.cellState = FilterCellStateHeightZero;
            MyOfferCountry *countryModel = [self makeCurrentStateWithCountry:self.coreCountry];
            stateArray =  [countryModel.states valueForKeyPath:@"name"];
            filter_country.selectedValue = self.coreCountry;
        }
        
        //地区
        FiltContent  *filter_state = [FiltContent filterWithIcon:nil title:@"地区:"  subtitlte:KEY_ALL filterOptionItems:stateArray];
        filter_state.optionStyle = FilterOptionState;
        FilterContentFrame *filter_state_Frame = [FilterContentFrame filterFrameWithFilter:filter_state];
        [temps addObject:filter_state_Frame];
        
        
        NSArray *currentCityArr = nil;
        if (self.coreState) {
            
            filter_country_Frame.cellState = FilterCellStateHeightZero;
            filter_state_Frame.cellState = FilterCellStateHeightZero;
            
            MyOfferCountryState  * currentState =[self makeCurrentCityWithState:self.coreState country:self.coreCountry];
            currentCityArr = [currentState.cities valueForKeyPath:@"name"];
            filter_state.selectedValue = self.coreState;

        }
        
        //城市
        FiltContent  *filter_city = [FiltContent filterWithIcon:nil title:@"城市:"  subtitlte:KEY_ALL filterOptionItems:currentCityArr];
        filter_city.optionStyle = FilterOptionCity;
        FilterContentFrame *filter_city_Frame = [FilterContentFrame filterFrameWithFilter:filter_city];
        [temps addObject:filter_city_Frame];
        
        if (self.corecity) {
            
            filter_country_Frame.cellState = FilterCellStateHeightZero;
            filter_state_Frame.cellState = FilterCellStateHeightZero;
            filter_city_Frame.cellState = FilterCellStateHeightZero;
            filter_city.selectedValue = self.corecity;

        }
        
       //学科
        FiltContent *filter_area = [FiltContent filterWithIcon:nil title:@"学科领域:"  subtitlte:KEY_ALL filterOptionItems:[self.areas valueForKeyPath:@"name"]];
        filter_area.optionStyle = FilterOptionArea;
        FilterContentFrame *filter_area_Frame =  [FilterContentFrame filterFrameWithFilter:filter_area];
        [temps addObject:filter_area_Frame];
        
        NSArray *subjectArray = nil;
        
        
        if (self.coreArea) {
            
            filter_area_Frame.cellState = FilterCellStateHeightZero;
            
            MyOfferArea *areaModel = [self makeCurrentSubjectWithArea:self.coreArea];
            
            subjectArray = [areaModel.subjects valueForKeyPath:@"name"];
            
            filter_area.selectedValue = self.coreArea;
            
        }
        
        //专业
        FiltContent *filter_subject = [FiltContent filterWithIcon:nil title:@"专业方向:"  subtitlte:KEY_ALL filterOptionItems:subjectArray];
        filter_subject.optionStyle = FilterOptionSuject;
        FilterContentFrame *filter_subject_frame =  [FilterContentFrame filterFrameWithFilter:filter_subject];
        [temps addObject:filter_subject_frame];
        
        
        _FiltItems = [temps mutableCopy];
        
    }
    
    
    return _FiltItems;
}





- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
    
}

//顶部工具条背景
- (UIView *)topView{
    
    if (!_topView) {
        
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.base_Height - XNAV_HEIGHT)];
        _topView.backgroundColor = XCOLOR_WHITE;
        
        CALayer *line = [CALayer layer];
        line.backgroundColor = XCOLOR_line.CGColor;
        line.frame = CGRectMake(0,_topView.mj_h, _topView.mj_w, 1);
        [_topView.layer addSublayer:line];
        
    }
    
    return _topView;
}


- (void)makeUI{
    
    [self makeRankTableView];
    
    [self makeOptionView];
    
    [self makeTopView];
    
    //添加保存原始筛选数据
    for (FilterContentFrame *filter_Frame in self.FiltItems) {
        
        [self.FiltItems_origin addObject:[filter_Frame copy]];
        
    }
    
}

- (void)setRankings:(NSArray *)rankings{

    _rankings = rankings;
    
    //如果只有一个排序方式，一定是世界排名，设置 self.currentRankType = RANK_QS;
    if (rankings.count == 1) self.currentRankType = RANK_QS;
    
    [self.rank_table reloadData];
    
}

//顶部筛选工具条
- (void)makeTopView{
    
    self.view.backgroundColor = XCOLOR(0, 0, 0, 0.1);
    
    [self.view addSubview:self.topView];
    
    CGFloat area_X =  0;
    CGFloat area_Y =  0;
    CGFloat area_W =  self.view.bounds.size.width * 0.5;
    CGFloat area_H =  self.topView.mj_h;
    self.optionBtn = [self senderWithFrame:CGRectMake(area_X, area_Y, area_W, area_H) title:@"筛选" nomalTitleColor:XCOLOR_SUBTITLE];
    self.optionBtn.tag = filterButtonStyleOption;
    [self.topView addSubview:self.optionBtn];
    
    CGFloat rank_X =  area_W;
    CGFloat rank_Y =  area_Y;
    CGFloat rank_W =  area_W;
    CGFloat rank_H =  area_H;
    self.rankingBtn = [self senderWithFrame:CGRectMake(rank_X, rank_Y, rank_W, rank_H) title:@"排名" nomalTitleColor:XCOLOR_SUBTITLE];
    self.rankingBtn.tag = filterButtonStyleRank;
    [self.topView addSubview:self.rankingBtn];
    
    CGFloat aline_Y = 10;
    CGFloat aline_X = area_W;
    CGFloat aline_W = 1;
    CGFloat aline_H = self.topView.mj_h - 2 * aline_Y;
    UIView *line_left = [[UIView alloc] initWithFrame:CGRectMake(aline_X, aline_Y, aline_W, aline_H)];
    line_left.backgroundColor = XCOLOR_line;
    [self.topView addSubview:line_left];
 
}

- (UIButton *)senderWithFrame:(CGRect)frame title:(NSString *)title nomalTitleColor:(UIColor *)titleColor{
    
    UIButton *sender = [[UIButton alloc] initWithFrame:frame];
    [sender setTitle:title forState:UIControlStateNormal];
    [sender setTitleColor:titleColor forState:UIControlStateNormal];
//    [sender setTitleColor:XCOLOR_TITLE forState:UIControlStateHighlighted];
    [sender setTitleColor:XCOLOR_LIGHTBLUE forState:UIControlStateSelected];
    [sender setBackgroundImage:[UIImage KD_imageWithColor:XCOLOR_BG] forState:UIControlStateHighlighted];
    sender.titleLabel.font  = XFONT(16);
    [sender addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    sender.layer.cornerRadius = CORNER_RADIUS;
    sender.layer.masksToBounds = YES;
    
    return sender;
    
}



- (void)makeOptionView{
    
    //筛选父容器
    CGFloat area_bg_Y  = Top_Heigh;
    CGFloat area_bg_W  = XSCREEN_WIDTH;
    UIView  *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, area_bg_Y, area_bg_W, 0)];
    bgView.backgroundColor = XCOLOR_RED;
    [self.view addSubview:bgView];
    bgView.clipsToBounds = YES;
    self.bgView = bgView;

    CGFloat option_W = area_bg_W;
    CGFloat option_H = XSCREEN_HEIGHT - area_bg_Y - XNAV_HEIGHT;
    self.option_table = [self defaultTableViewWithframe:CGRectMake(0, 0, option_W,option_H)];
    [self.bgView addSubview:self.option_table];
    //筛选列表
    self.option_table.contentInset = UIEdgeInsetsMake(0, 0, Bottom_Heigh, 0);
    
    
    
    //footer 按钮容器
    CGFloat footer_W = area_bg_W;
    CGFloat footer_H = Bottom_Heigh;
    CGFloat footer_Y = option_H - footer_H;
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, footer_Y, footer_W, footer_H)];
    [self.bgView addSubview:footer];
    self.footerView = footer;
    footer.backgroundColor = XCOLOR_WHITE;
    
    
    //清空按钮
    CGFloat clear_X =  15;
    CGFloat clear_Y =  10;
    CGFloat clear_W =  (footer_W - 3 * clear_X) * 0.5;
    CGFloat clear_H =  Bottom_botton_Heigh;
    self.clearBtn = [self senderWithFrame:CGRectMake(clear_X, clear_Y, clear_W, clear_H) title:@"重置"  nomalTitleColor:XCOLOR_RED];
    self.clearBtn.tag = filterButtonStyleClear;
    [self.clearBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.footerView addSubview:self.clearBtn];
    self.clearBtn.layer.borderColor = XCOLOR_RED.CGColor;
    self.clearBtn.layer.borderWidth = 1;
    
    //提交按钮
    CGFloat sub_X =  CGRectGetMaxX(self.clearBtn.frame) + clear_X;
    CGFloat sub_Y =  clear_Y;
    CGFloat sub_W =  clear_W;
    CGFloat sub_H =  clear_H;
    self.submitBtn = [self senderWithFrame:CGRectMake(sub_X, sub_Y, sub_W, sub_H) title:@"确认"  nomalTitleColor:XCOLOR_WHITE];
    self.submitBtn.tag = filterButtonStyleSubmit;
    self.submitBtn.backgroundColor = XCOLOR_RED;
    [self.submitBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.footerView addSubview:self.submitBtn];
}


-(void)makeRankTableView{
    
    //排名列表
    self.rank_table =[self defaultTableViewWithframe:CGRectMake(0, Top_Heigh, XSCREEN_WIDTH,0)];
    [self.view addSubview:self.rank_table];
    
}

- (UITableView *)defaultTableViewWithframe:(CGRect)frame{
    
    UITableView *tableView =[[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.clipsToBounds = YES;
    tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    
    
    return tableView;
}


#pragma mark :  UITableViewDelegate,UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.option_table) {
        
        FilterContentFrame *item = self.FiltItems[indexPath.row];
        
        return item.cellHeigh;
        
    }
    
    return  Cell_Heigh;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.rank_table) return self.rankings.count;
    if (tableView == self.option_table) return self.FiltItems.count;
  
    return 0;

}

static NSString *identify = @"uniFilter";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.option_table) {
        
        FilterTableViewCell *Fcell = [[FilterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        Fcell.delegate = self;
        Fcell.indexPath = indexPath;
        Fcell.selectionStyle = UITableViewCellSelectionStyleNone;
        Fcell.filterFrame = self.FiltItems[indexPath.row];
        
        return Fcell;
        
    }
    
    
   //tableView == self.rank_table)
    UniversityCourseFilterCell *cell =[tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        
        cell =[[UniversityCourseFilterCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identify];
        
    }
    
    MyOfferRank *rank = self.rankings[indexPath.row];
    cell.title =  rank.name;
    cell.onSelected = [self.currentRankType isEqualToString:rank.rankType];
    
     return cell;
    
    
 }

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.option_table) return;
    
    //只有排序功能才有点事件
    MyOfferRank *rank = self.rankings[indexPath.row];

    self.currentRankType = rank.rankType;
    
    [self.rank_table reloadData];
    
    
    if (self.actionBlock) {
        
        NSDictionary *rankDic = @{KEY_ORDER_SF : self.currentRankType };
        
        self.actionBlock(@[rankDic]);
        
    }
    
    
    [self onClick:self.currentBtn];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

//超出cell的bounds范围，不能显示
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.clipsToBounds = YES;
}


#pragma mark :  FilterTableViewCellDelegate

- (void)FilterTableViewCell:(FilterTableViewCell *)tableViewCell  WithButtonItem:(UIButton *)sender WithIndexPath:(NSIndexPath *)indexPath{
    
    FilterContentFrame  *onClickItem_Frame = self.FiltItems[indexPath.row];
    
    //展开、收起按钮
    if (sender.tag == DEFAULT_NUMBER) {
        
        onClickItem_Frame.cellState =  (onClickItem_Frame.cellState == FilterCellStateBaseHeight) ? FilterCellStateRealHeight : FilterCellStateBaseHeight;
        
        [self.option_table reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        return ;
    }
    
    
    switch (onClickItem_Frame.filter.optionStyle) {
            
        case FilterOptionCountry:{
            
            //得到对应国家的state数组
            MyOfferCountry *opiotnCountry= [self makeCurrentStateWithCountry:sender.currentTitle];
            
            FilterContentFrame  *state_Frame = self.FiltItems[indexPath.row + 1];
            FiltContent *filter_state = state_Frame.filter;
            filter_state.optionItems  =  onClickItem_Frame.filter.selectedValue.length > 0 ?  [opiotnCountry.states valueForKeyPath:@"name"] : nil;
            filter_state.selectedValue = nil;
            state_Frame.filter = filter_state;
            
            FilterContentFrame  *city_Frame = self.FiltItems[indexPath.row + 2];
            FiltContent *filter_city = city_Frame.filter;
            filter_city.optionItems = nil;
            filter_city.selectedValue = nil;
            city_Frame.filter = filter_city;
            
            NSIndexPath *state_IndexPath =[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
            NSIndexPath *city_IndexPath =[NSIndexPath indexPathForRow:indexPath.row + 2 inSection:indexPath.section];
            [self.option_table reloadRowsAtIndexPaths:@[state_IndexPath,city_IndexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        }
             break;
            
        case FilterOptionState:{
            
            
            MyOfferCountryState *opiotnState= [self makeCurrentCityWithState:sender.currentTitle country:nil];
          
            FilterContentFrame  *city_Frame = self.FiltItems[indexPath.row + 1];
            FiltContent *filter_city = city_Frame.filter;
            filter_city.optionItems  =  onClickItem_Frame.filter.selectedValue.length > 0 ? [opiotnState.cities valueForKeyPath:@"name"] : nil;
            filter_city.selectedValue = nil;
            city_Frame.filter = filter_city;
            
            NSIndexPath *city_IndexPath =[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
            [self.option_table reloadRowsAtIndexPaths:@[city_IndexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        }
            break;
        
        case FilterOptionCity:{
            
            //  NSLog(@"FilterOptionCity = %@",onClickItem_Frame.content.selectedValue);
        
        }
            break;
        case FilterOptionArea:{
        
            MyOfferArea *opiotnArea= [self makeCurrentSubjectWithArea:sender.currentTitle];
            
            FilterContentFrame  *subject_Frame = self.FiltItems[indexPath.row + 1];
            FiltContent *filter_subject = subject_Frame.filter;
            filter_subject.optionItems  =  onClickItem_Frame.filter.selectedValue.length > 0 ? [opiotnArea.subjects valueForKeyPath:@"name"] : nil;
            filter_subject.selectedValue = nil;
            subject_Frame.filter = filter_subject;
            
            NSIndexPath *subject_IndexPath =[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
            [self.option_table reloadRowsAtIndexPaths:@[subject_IndexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
            break;
            
        case FilterOptionSuject:{
        
            //  NSLog(@"FilterOptionSuject = %@",onClickItem_Frame.content.selectedValue);
        
        }
            break;
        default:
            break;
    }
    
  
    
}

//按钮点击事件
- (void)onClick:(UIButton *)sender{
    
    //footer的按钮
    switch (sender.tag) {
        case filterButtonStyleClear:{
        [self caseClear];
            return;
        }
            break;
        case filterButtonStyleSubmit:{
            [self caseSubmit];
            return;
        }
            break;
            
        default:
            break;
    }
    
    
    // 重复点击同一个按钮时 设置self.currentBtn为空
    if (self.currentBtn == sender) {
        
        self.currentBtn.selected = NO;
        self.currentBtn = nil;
        
        
    }else{
        
        self.currentBtn.selected = NO;
        sender.selected = YES;
        self.currentBtn = sender;
    }
    
    
    
    CGRect realRect = self.view.frame;
    
    realRect.size.height = self.currentBtn ? XSCREEN_HEIGHT : self.base_Height - XNAV_HEIGHT;
    
    
    //当前Button 为空时，
    if (!self.currentBtn) {
        
        //当前Button 为空时，淡化背景色，再收收起 self.view.frame高度
        [UIView animateWithDuration:ANIMATION_DUATION animations:^{
            
            self.view.backgroundColor = XCOLOR(0, 0, 0, 0.1);
            
            self.rank_table.mj_h = 0;
            self.bgView.mj_h = 0;
            
        } completion:^(BOOL finished) {
            
            
            self.view.frame = realRect;
            
        }];
        
        
        return ;
    }
    
    
    
    
    UIView *selectedView = (sender.tag ==  filterButtonStyleOption) ? self.bgView : self.rank_table;
    UIView *unSelectedView = (sender.tag ==  filterButtonStyleOption) ? self.rank_table :  self.bgView;
    
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        
        if (!(sender.tag ==  filterButtonStyleOption)) {
            
            selectedView.mj_h = self.rankings.count * Cell_Heigh;
            
        }else{
            
            selectedView.mj_h = XSCREEN_HEIGHT - self.bgView.mj_y - XNAV_HEIGHT;
        }
        
        
        unSelectedView.mj_h = 0;
        
    }];
    
    
    
    //当self.view已经展开时，不再做展开动作
    if (self.view.mj_h > self.base_Height)  return;
    
    self.view.frame = realRect;
    //当筛选框被点中时，背景色加深
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        
        self.view.backgroundColor = XCOLOR(0, 0, 0, 0.5);
        
    }];
    
}

 //点击黑色背景收起tableView
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self onClick:self.currentBtn];
}


// 清空数据
- (void)caseClear{
    
    
    [self.filterParameters removeAllObjects];
    
    [self.FiltItems removeAllObjects];
    
    for (FilterContentFrame *filter_Frame in self.FiltItems_origin) {
        
        [self.FiltItems addObject:[filter_Frame copy]];
        
    }
    
    [self.option_table reloadData];
    
}

// 提交数据
- (void)caseSubmit{

    //每次清空请求参数，再重新添加
    [self.filterParameters removeAllObjects];
    
    for (FilterContentFrame *filter_Frame in self.FiltItems) {
        
        FiltContent *filter = filter_Frame.filter;
        
        //参数为空时跳过
        if (!filter.selectedValue) continue;
        
        switch (filter.optionStyle) {
            case FilterOptionCountry:
                 [self.filterParameters addObject:@{KEY_NAME_SF: KEY_COUNTRY,KEY_VALUE_SF:filter.selectedValue}];
                 break;
            case FilterOptionState:
                [self.filterParameters addObject:@{KEY_NAME_SF: KEY_STATE,KEY_VALUE_SF:filter.selectedValue}];
                break;
            case FilterOptionCity:
                [self.filterParameters addObject:@{KEY_NAME_SF: KEY_CITY,KEY_VALUE_SF:filter.selectedValue}];
                break;
            case FilterOptionArea:
                [self.filterParameters addObject:@{KEY_NAME_SF: KEY_AREA,KEY_VALUE_SF:filter.selectedValue}];
                break;
            case FilterOptionSuject:
                [self.filterParameters addObject:@{KEY_NAME_SF: KEY_SUBJECT,KEY_VALUE_SF:filter.selectedValue}];
                break;
            default:
                break;
        }
        
    }
    

    if (self.actionBlock) self.actionBlock(@[@{KEY_FILTERS_SF : self.filterParameters}]);
        
    
    //点击黑色背景收起tableView
    [self onClick:self.currentBtn];
    
    
}



-(void)dealloc
{
    KDClassLog(@"搜索结果筛选  dealloc");
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}



@end
