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


@interface SearchUniCenterFilterVController ()<UITableViewDataSource,UITableViewDelegate,FilterTableViewCellDelegate>
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UIButton *optionBtn;
@property(nonatomic,strong)UIButton *rankingBtn;
@property(nonatomic,strong)UIButton *currentBtn;
@property(nonatomic,strong)UIButton *clearBtn;
@property(nonatomic,strong)UIButton *submitBtn;

//排名数组
@property(nonatomic,strong)NSArray *rankings;
@property(nonatomic,copy)NSString *current_rank;
//学科领域数组
@property(nonatomic,strong)NSArray *areas;
//国家地区数组
@property(nonatomic,strong)NSArray *countries;
//筛选数组
@property(nonatomic,strong)NSMutableArray *FiltItems;
@property(nonatomic,strong)NSMutableArray *FiltItems_origin;

@property(nonatomic,strong)MyOfferArea *current_area;
@property(nonatomic,copy)MyOfferSubjecct *current_subject;

@property(nonatomic,strong)UITableView *rank_table;
@property(nonatomic,strong)UITableView  *option_table;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIView *footerView;
//添加网络请求参数
//@property(nonatomic,strong)NSMutableDictionary *filterParameter;
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
- (NSArray *)rankings{
    
    if (!_rankings) {
        
        
        
        
        _rankings = @[@"世界排名",@"本国排名"];
    }
    
    return _rankings;
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
        
        if (_areas.count > 0) _current_area = _areas.firstObject;
        
         
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


//获取当前国家地区
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
        FiltContent  *filter_country =[FiltContent createItemWithTitle:@"国家:"andDetailTitle:KEY_ALL anditems: [self.countries valueForKeyPath:@"name"]];
        filter_country.optionStyle = FilterOptionCountry;
        FilterContentFrame *filter_country_Frame = [FilterContentFrame FilterContentFrameWithContent:filter_country];
        [temps addObject:filter_country_Frame];
        
        NSArray *stateArray = nil;
        if (self.CoreCountry) {
            
            filter_country_Frame.cellState = XcellStateHeightZero;
            MyOfferCountry *countryModel = [self makeCurrentStateWithCountry:self.CoreCountry];
            stateArray =  [countryModel.states valueForKeyPath:@"name"];
            filter_country.selectedValue = self.CoreCountry;
        }
        
        //地区
        FiltContent  *filter_state =[FiltContent createItemWithTitle:@"地区:"  andDetailTitle:KEY_ALL anditems: stateArray];
        filter_state.optionStyle = FilterOptionState;
        FilterContentFrame *filter_state_Frame = [FilterContentFrame FilterContentFrameWithContent:filter_state];
        [temps addObject:filter_state_Frame];
        
        
        NSArray *currentCityArr = nil;
        if (self.CoreState) {
            filter_country_Frame.cellState = XcellStateHeightZero;
            filter_state_Frame.cellState = XcellStateHeightZero;
            MyOfferCountryState  * currentState =[self makeCurrentCityWithState:self.CoreState country:self.CoreCountry];
            currentCityArr = [currentState.cities valueForKeyPath:@"name"];
            filter_state.selectedValue = self.CoreState;

        }
        
        //城市
        FiltContent  *filter_city =[FiltContent createItemWithTitle:@"城市:" andDetailTitle:KEY_ALL anditems:currentCityArr];
        filter_city.optionStyle = FilterOptionCity;
        FilterContentFrame *filter_city_Frame = [FilterContentFrame FilterContentFrameWithContent:filter_city];
        [temps addObject:filter_city_Frame];
        
        if (self.Corecity) {
            
            filter_country_Frame.cellState = XcellStateHeightZero;
            filter_state_Frame.cellState = XcellStateHeightZero;
            filter_city_Frame.cellState = XcellStateHeightZero;
            filter_city.selectedValue = self.Corecity;

        }
        
       //学科
        FiltContent *filter_area =[FiltContent createItemWithTitle:@"学科领域:"  andDetailTitle:KEY_ALL anditems: [self.areas valueForKeyPath:@"name"]];
        filter_area.optionStyle = FilterOptionArea;
        FilterContentFrame *filter_area_Frame =  [FilterContentFrame FilterContentFrameWithContent:filter_area];
        [temps addObject:filter_area_Frame];
        
        NSArray *subjectArray = nil;
        
        if (self.CoreArea) {
            
            filter_area_Frame.cellState = XcellStateHeightZero;
            
            MyOfferArea *areaModel = [self makeCurrentSubjectWithArea:self.CoreArea];
            
            subjectArray = [areaModel.subjects valueForKeyPath:@"name"];
            
            filter_area.selectedValue = self.CoreArea;

            
        }
        
        //专业
        FiltContent *filter_subject =[FiltContent createItemWithTitle:@"专业方向:" andDetailTitle:KEY_ALL  anditems:subjectArray];
        filter_subject.optionStyle = FilterOptionSuject;
        FilterContentFrame *filter_subject_frame =  [FilterContentFrame FilterContentFrameWithContent:filter_subject];
        [temps addObject:filter_subject_frame];
        
        
        _FiltItems = [temps mutableCopy];
        
    }
    
    
    return _FiltItems;
}





- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
    
    
    
}

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
    
//    self.current_Level = @"全部";
//    self.current_area = @"全部";
    
    
    for (FilterContentFrame *filter_Frame in self.FiltItems) {
        
        
        [self.FiltItems_origin addObject:[filter_Frame copy]];
        
    }
    
    
    
}

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
    [sender setTitleColor:XCOLOR_LIGHTBLUE forState:UIControlStateSelected];
    [sender setBackgroundImage:[UIImage KD_imageWithColor:XCOLOR_LIGHTGRAY] forState:UIControlStateHighlighted];
    sender.titleLabel.font  = XFONT(16);
    [sender addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
  
    
    return sender;
    
}



- (void)makeOptionView{
    
    CGFloat area_bg_Y  = 50;
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
    
    self.option_table.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    
    CGFloat footer_W = area_bg_W;
    CGFloat footer_H = 50;
    CGFloat footer_Y = option_H - footer_H;
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, footer_Y, footer_W, footer_H)];
    [self.bgView addSubview:footer];
    self.footerView = footer;
    footer.backgroundColor = XCOLOR_LIGHTBLUE;
    
    
    CGFloat clear_X =  0;
    CGFloat clear_Y =  0;
    CGFloat clear_W =  footer_W * 0.5;
    CGFloat clear_H =  footer_H;
    self.clearBtn = [self senderWithFrame:CGRectMake(clear_X, clear_Y, clear_W, clear_H) title:@"清空数据"  nomalTitleColor:XCOLOR_SUBTITLE];
    self.clearBtn.tag = filterButtonStyleClear;
    self.clearBtn.backgroundColor = XCOLOR_BG;
    [self.clearBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.footerView addSubview:self.clearBtn];
    
    CGFloat sub_X =  clear_W;
    CGFloat sub_Y =  0;
    CGFloat sub_W =  clear_W;
    CGFloat sub_H =  footer_H;
    self.submitBtn = [self senderWithFrame:CGRectMake(sub_X, sub_Y, sub_W, sub_H) title:@"确认"  nomalTitleColor:XCOLOR_WHITE];
    self.submitBtn.tag = filterButtonStyleSubmit;
    self.submitBtn.backgroundColor = XCOLOR_RED;
    [self.submitBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.footerView addSubview:self.submitBtn];
}


-(void)makeRankTableView{
    
    self.rank_table =[self defaultTableViewWithframe:CGRectMake(0, 50, XSCREEN_WIDTH,0)];
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
    
    return  50;
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
//        switch (indexPath.row) {
//            case 0:
//                Fcell.selectItem =[self.filerParameters valueForKey:KEY_COUNTRY];
//                break;
//            case 1:
//                Fcell.selectItem =[self.filerParameters valueForKey:KEY_STATE];
//                break;
//            case 2:
//                Fcell.selectItem =[self.filerParameters valueForKey:KEY_CITY];
//                break;
//            case 3:
//                Fcell.selectItem =[self.filerParameters valueForKey:KEY_AREA];
//                break;
//            case 4:
//                Fcell.selectItem =[self.filerParameters valueForKey:KEY_SUBJECT];
//                break;
//            default:
//                break;
//        }
        Fcell.filterFrame = self.FiltItems[indexPath.row];
        
        return Fcell;
        
        
    }
    
    
   //tableView == self.rank_table)
    UniversityCourseFilterCell *cell =[tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        
        cell =[[UniversityCourseFilterCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identify];
        
    }
    
    cell.title =  self.rankings[indexPath.row];
    cell.onSelected = [self.current_rank isEqualToString:self.rankings[indexPath.row]];
    
     return cell;
    
    
 }

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //只有排序功能才有点事件
    self.current_rank = self.rankings[indexPath.row];

    [self.rank_table reloadData];
    
    
    if (self.actionBlock) {
        
        self.actionBlock(self.current_rank, KEY_ORDER_SF);
    }
        
    
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
        
        onClickItem_Frame.cellState =  (onClickItem_Frame.cellState == XcellStateBaseHeight) ? XcellStateRealHeight : XcellStateBaseHeight;
        
        [self.option_table reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        return ;
    }
    
    
    switch (onClickItem_Frame.content.optionStyle) {
            
        case FilterOptionCountry:{
            
            //得到对应国家的state数组
            MyOfferCountry *opiotnCountry= [self makeCurrentStateWithCountry:sender.currentTitle];
            
            FilterContentFrame  *state_Frame = self.FiltItems[indexPath.row + 1];
            FiltContent *filter_state = state_Frame.content;
            filter_state.buttonArray  =  onClickItem_Frame.content.selectedValue.length > 0 ?  [opiotnCountry.states valueForKeyPath:@"name"] : nil;
            filter_state.selectedValue = nil;
            state_Frame.content = filter_state;
            
            FilterContentFrame  *city_Frame = self.FiltItems[indexPath.row + 2];
            FiltContent *filter_city = city_Frame.content;
            filter_city.buttonArray = nil;
            filter_city.selectedValue = nil;
            city_Frame.content = filter_city;
            
            NSIndexPath *state_IndexPath =[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
            NSIndexPath *city_IndexPath =[NSIndexPath indexPathForRow:indexPath.row + 2 inSection:indexPath.section];
            [self.option_table reloadRowsAtIndexPaths:@[state_IndexPath,city_IndexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        }
             break;
            
        case FilterOptionState:{
            
            
            MyOfferCountryState *opiotnState= [self makeCurrentCityWithState:sender.currentTitle country:nil];
          
            FilterContentFrame  *city_Frame = self.FiltItems[indexPath.row + 1];
            FiltContent *filter_city = city_Frame.content;
            filter_city.buttonArray  =  onClickItem_Frame.content.selectedValue.length > 0 ? [opiotnState.cities valueForKeyPath:@"name"] : nil;
            filter_city.selectedValue = nil;
            city_Frame.content = filter_city;
            
            NSIndexPath *city_IndexPath =[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
            [self.option_table reloadRowsAtIndexPaths:@[city_IndexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        }
            break;
        
        case FilterOptionCity:{
            
//            NSLog(@"FilterOptionCity = %@",onClickItem_Frame.content.selectedValue);
        
        }
            break;
        case FilterOptionArea:{
        
            MyOfferArea *opiotnArea= [self makeCurrentSubjectWithArea:sender.currentTitle];
            
            FilterContentFrame  *subject_Frame = self.FiltItems[indexPath.row + 1];
            FiltContent *filter_subject = subject_Frame.content;
            filter_subject.buttonArray  =  onClickItem_Frame.content.selectedValue.length > 0 ? [opiotnArea.subjects valueForKeyPath:@"name"] : nil;
            filter_subject.selectedValue = nil;
            subject_Frame.content = filter_subject;
            
            NSIndexPath *subject_IndexPath =[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
            [self.option_table reloadRowsAtIndexPaths:@[subject_IndexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
            break;
            
        case FilterOptionSuject:{
        
//            NSLog(@"FilterOptionSuject = %@",onClickItem_Frame.content.selectedValue);
        
        }
            break;
        default:
            break;
    }
    
  
    
}


- (void)onClick:(UIButton *)sender{
    
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
            
        } completion:^(BOOL finished) {
            
            
            self.view.frame = realRect;
            
        }];
        
        
        
        [UIView animateWithDuration:ANIMATION_DUATION animations:^{
            
            self.rank_table.mj_h = 0;
            self.bgView.mj_h = 0;
            
        }];
        
        
        
        return ;
    }
    
    
    
    
    UIView *selectedView = (sender.tag ==  filterButtonStyleOption) ? self.bgView : self.rank_table;
    UIView *unSelectedView = (sender.tag ==  filterButtonStyleOption) ? self.rank_table :  self.bgView;
    
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        
        if (!(sender.tag ==  filterButtonStyleOption)) {
            
            selectedView.mj_h = self.rankings.count * 50;
            
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //点击黑色背景收起tableView
    [self onClick:self.currentBtn];
    
}



- (void)caseClear{
    
    
    [self.filterParameters removeAllObjects];
    
    [self.FiltItems removeAllObjects];
    
    for (FilterContentFrame *filter_Frame in self.FiltItems_origin) {
        
        [self.FiltItems addObject:[filter_Frame copy]];
        
    }
    
    [self.option_table reloadData];
   
    
}

- (void)caseSubmit{

    
    [self.filterParameters removeAllObjects];
    
    for (FilterContentFrame *filter_Frame in self.FiltItems) {
        
        FiltContent *filter = filter_Frame.content;
        
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
    
    
    
    if (self.actionBlock) {
        
        self.actionBlock(self.filterParameters, KEY_FILTERS_SF);
    }
    
    
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
