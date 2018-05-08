//
//  RankFilterViewController.m
//  MyOffer
//
//  Created by xuewuguojie on 2017/10/13.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "RankFilterViewController.h"
#import "UniversityCourseFilterCell.h"

typedef NS_ENUM(NSInteger,filterTableType) {
    filterTableTypeCountry = 0,
    filterTableTypeRank,
    filterTableTypeTime
};

typedef NS_ENUM(NSInteger,filterButtonType) {
    filterButtonTypeCountry = 0,
    filterButtonTypeRank,
    filterButtonTypeTime,
    filterButtonTypeCover

};



@interface RankFilterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIButton *countryBtn;
@property(nonatomic,strong)UIButton *rankBtn;
@property(nonatomic,strong)UIButton *timeBtn;
@property(nonatomic,strong)UIButton *coverBtn;
@property(nonatomic,strong)UITableView *time_tableView;
@property(nonatomic,strong)UITableView *country_tableView;
@property(nonatomic,strong)UITableView *rank_tableView;
@property(nonatomic,strong)UITableView *current_tableView;
@property(nonatomic,strong)UIButton *current_button;
@property(nonatomic,assign)BOOL onShow;

@end

@implementation RankFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setupter loading the view.
    [self makeUI];
    
}

- (void)makeUI{
    
    [self makeTableView];
    
    CGFloat top_h = 50;
    UIView *topToolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, top_h)];
    topToolView.backgroundColor = XCOLOR_WHITE;
    [self.view addSubview:topToolView];
    
    CGFloat btn_w =  topToolView.mj_w / 3;
    CGFloat country_x = 0;
    CGFloat country_y = 0;
    CGFloat country_w = btn_w;
    CGFloat country_h = top_h;
    self.countryBtn = [self createButtonWithFrame:CGRectMake(country_x, country_y, country_w, country_h) title:@"全部国家" superView:topToolView];
    self.countryBtn.tag = filterButtonTypeCountry;

    CGFloat rank_x = btn_w;
    self.rankBtn = [self createButtonWithFrame:CGRectMake(rank_x, country_y, country_w, country_h) title:@"全部排名" superView:topToolView];
    self.rankBtn.tag = filterButtonTypeRank;
    [self createPaddingViewWithX:rank_x superView:topToolView];
    
    CGFloat time_x = btn_w * 2;
    self.timeBtn = [self createButtonWithFrame:CGRectMake(time_x, country_y, country_w, country_h) title:@"全部时间" superView:topToolView];
    self.timeBtn.tag = filterButtonTypeTime;
    [self createPaddingViewWithX:time_x superView:topToolView];

    [self.view insertSubview:self.coverBtn  atIndex:0];
    
    UIView *btmView = [[UIView alloc] initWithFrame:CGRectMake(0, top_h,XSCREEN_WIDTH , 1)];
    btmView.backgroundColor = XCOLOR_line;
    [topToolView  addSubview:btmView];
    

}

- (UIButton *)coverBtn{
    
    if (!_coverBtn) {
        
         _coverBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, 0)];
         _coverBtn.tag = filterButtonTypeCover;
        [_coverBtn addTarget:self action:@selector(caseSenderView:) forControlEvents:UIControlEventTouchUpInside];
 
    }
    
    return _coverBtn;
}

- (UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title superView:(UIView *)spView{
    
    UIButton *sender = [[UIButton alloc] initWithFrame:frame];
    [sender setTitleColor:XCOLOR_LIGHTBLUE forState:UIControlStateSelected];
    [sender setTitleColor:XCOLOR_TITLE forState:UIControlStateNormal];
    [spView addSubview:sender];
    [sender setTitle:title forState:UIControlStateNormal];
    [sender addTarget:self action:@selector(caseSenderView:) forControlEvents:UIControlEventTouchUpInside];
    sender.titleLabel.font  = XFONT(16);

    return  sender;
}


- (void)makeTableView{
    
    self.country_tableView = [self createTableView];
    self.country_tableView.tag = filterTableTypeCountry;
 
    self.rank_tableView = [self createTableView];
    self.rank_tableView.tag = filterTableTypeRank;
 
    self.time_tableView = [self createTableView];
    self.time_tableView.tag = filterTableTypeTime;
    
 }

- (UITableView *)createTableView{
    
    UITableView *tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 50, XSCREEN_WIDTH, 0) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView =[[UIView alloc] init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    
    return tableView;
}

- (UIView *)createPaddingViewWithX:(CGFloat)x superView:(UIView *)spView{
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x, 10, 1, 30)];
    line.backgroundColor = XCOLOR_line;
    [spView addSubview:line];

    return line;
}

- (void)setRankFilterModel:(rankFilter *)rankFilterModel{
    
    _rankFilterModel = rankFilterModel;
 
    self.rankFilterModel.countryName = self.countryBtn.currentTitle;
    self.rankFilterModel.typeName = self.rankBtn.currentTitle;
    self.rankFilterModel.yearName = self.timeBtn.currentTitle;
    
    [self.time_tableView reloadData];
    [self.rank_tableView reloadData];
    [self.country_tableView reloadData];
}

#pragma mark :  UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    NSInteger count = 0;
    switch (tableView.tag) {
        case filterTableTypeRank:
            count = self.rankFilterModel.type_arr.count;
            break;
        case filterTableTypeTime:
            count = self.rankFilterModel.year_arr.count;
            break;
        default:
            count = self.rankFilterModel.countri_arr.count;
            break;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"RankFilterViewController";
    UniversityCourseFilterCell *cell =[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell =[[UniversityCourseFilterCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identify];
    }
 
    NSString *name = @"";
    NSString *selected_name = @"";
    switch (tableView.tag) {
        case filterTableTypeRank:{
            NSDictionary *type_item = self.rankFilterModel.type_arr[indexPath.row];
            name = type_item[@"name"];
            selected_name = self.rankFilterModel.typeName;
         }
            break;
        case filterTableTypeTime:{
            NSDictionary *time_item = self.rankFilterModel.year_arr[indexPath.row];
            name = time_item[@"name"];
            selected_name = self.rankFilterModel.yearName;
        }
            break;
        default:{
            NSDictionary *cn_item = self.rankFilterModel.countri_arr[indexPath.row];
            name = cn_item[@"name"];
            selected_name = self.rankFilterModel.countryName;
        }
            break;
    }
    
    cell.title = name;
    cell.onSelected = (name  == selected_name);

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    NSString *name;
    NSString *key = @"";
    NSDictionary *filter_item;
    switch (tableView.tag) {
        case filterTableTypeRank:{
            filter_item = self.rankFilterModel.type_arr[indexPath.row];
            self.rankFilterModel.typeName = filter_item[@"name"];
            key = @"type";
        }
            break;
        case filterTableTypeTime:{
            filter_item = self.rankFilterModel.year_arr[indexPath.row];
            self.rankFilterModel.yearName = filter_item[@"name"];
            key = @"year";
        }
            break;
        default:{
          filter_item = self.rankFilterModel.countri_arr[indexPath.row];
         self.rankFilterModel.countryName = filter_item[@"name"];
          key = @"country";
        }
            break;
    }
 
     name = filter_item[@"name"];
    
    if ([name isEqualToString:self.current_button.currentTitle]) {
        
        [self caseSenderView:self.coverBtn];  return;
    }
    
    NSString *value = indexPath.row == 0 ? @"":filter_item[@"code"];
    [self.rankFilterModel.papa_m setValue:value forKey:key];
    
    [tableView reloadData];
    [self.current_button setTitle:name forState:UIControlStateNormal];
    
    if (self.actionBlock) self.actionBlock();
 
    [self caseSenderView:self.coverBtn];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  CELL_HEIGHT_DAFAULT;
}

#pragma mark : 事件处理
- (void)caseSenderView:(UIButton *)sender{
 
    if (!self.rankFilterModel){return;}
 
    CGFloat current_table_show =  0;
    CGFloat current_table_hiden = 0;
    CGFloat bgView_height_show = XSCREEN_HEIGHT;
    CGFloat bgView_height_hiden = 50;
    UIColor *bgView_color_show = XCOLOR_COVER;
    UIColor *bgView_color_hiden = XCOLOR_ZERO;
    UITableView *tmp_table = nil;
    
    //隐藏筛选功能
    //    2 有背景情况
    //    2-1   点击原有按钮  A  背景渐隐藏  B hiden当前表格  设置为当前表格为nil C 完成hidenn时删除cover  D sender 设置为正常状态
    if (sender.tag == filterButtonTypeCover || sender == self.current_button) {
        
        self.current_button.selected = NO;
        self.current_button = nil;
        
        [UIView animateWithDuration:ANIMATION_DUATION animations:^{
 
            self.view.backgroundColor = bgView_color_hiden;
            self.current_tableView.mj_h = current_table_hiden;
            
        } completion:^(BOOL finished) {
 
            self.view.mj_h = bgView_height_hiden;
            self.coverBtn.mj_h = bgView_height_hiden;
            self.current_tableView = nil;
            self.onShow = NO;
 
        }];
        
        return;
    }
    
    //    1 没有背景情况    A  背景渐现  B show表格  设置为为前表格 C 添加cover  D sender 设置为select状态
    //    2-2   点击其他按钮  A  当前按钮设置为正常状态   被点击按钮为select状态 B（背景还存在）当前表格隐藏   show所选项对应表格 动画完成是设置为当前表格  C 添加cover

    switch (sender.tag) {
            
        case filterButtonTypeTime:{
            tmp_table = self.time_tableView;
            current_table_show = self.rankFilterModel.year_arr.count * CELL_HEIGHT_DAFAULT;
        }
            break;
        case filterButtonTypeRank:{
            tmp_table = self.rank_tableView;
            current_table_show =  self.rankFilterModel.type_arr.count * CELL_HEIGHT_DAFAULT;
        }
            break;
        case filterButtonTypeCountry:{
            tmp_table = self.country_tableView;
            current_table_show =  self.rankFilterModel.countri_arr.count * CELL_HEIGHT_DAFAULT;
            
        }
            break;
        default:
            
            break;
    }
    
    
    
    if (self.onShow) {
        
        self.current_button.selected = NO;
        sender.selected = YES;
        self.current_button = sender;
        self.onShow = YES;
        
    }else{
        
        self.coverBtn.mj_h = bgView_height_show;
        self.view.mj_h = bgView_height_show;
        self.view.backgroundColor = bgView_color_hiden;
        
    }
    
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        
        if (self.onShow) {
            self.current_tableView.mj_h = current_table_hiden;
        }else{
            self.view.backgroundColor = bgView_color_show;
        }
        tmp_table.mj_h = current_table_show;
 
    } completion:^(BOOL finished) {
        
        self.current_tableView = tmp_table;
        if (!self.onShow) {
            sender.selected = true;
            self.current_button  = sender;
            self.onShow = YES;
        }
    }];
    
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end








