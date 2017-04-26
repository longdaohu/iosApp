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

#define KEY_ALL  @"全部"

@interface SearchUniCenterFilterVController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UIButton *areaBtn;
@property(nonatomic,strong)UIButton *subjectBtn;
@property(nonatomic,strong)UIButton *rankingBtn;
@property(nonatomic,strong)UIButton *currentBtn;
//排名数组
@property(nonatomic,strong)NSArray *rankings;
@property(nonatomic,copy)NSString *current_rank;
//学科领域数组
@property(nonatomic,strong)NSArray *areas;
@property(nonatomic,strong)MyOfferArea *current_area;
@property(nonatomic,copy)MyOfferSubjecct *current_subject;

@property(nonatomic,strong)UITableView *rank_table;
@property(nonatomic,strong)UIView *area_bgView;
@property(nonatomic,strong)UITableView *area_table;
@property(nonatomic,strong)UITableView *subject_table;
@property(nonatomic,strong)UIView *country_bgView;


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

- (NSArray *)areas{

    if (!_areas) {
        
        NSArray *item_subjects = [[NSUserDefaults standardUserDefaults] valueForKey:@"Subject_CN"];
        
        _areas = [MyOfferArea mj_objectArrayWithKeyValuesArray:item_subjects];
        
        if (_areas.count > 0) _current_area = _areas.firstObject;
        
         
    }
    
    return _areas;
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
    
    [self makeTableView];
    
    [self makeAreaOptionView];
    
    [self makeCountryOptionView];
    
    [self makeTopView];
    

    
//    self.current_Level = @"全部";
//    self.current_area = @"全部";
    
}

- (void)makeTopView{
    
    self.view.backgroundColor = XCOLOR(0, 0, 0, 0.1);
    
    [self.view addSubview:self.topView];
    
    
    CGFloat area_X =  0;
    CGFloat area_Y =  0;
    CGFloat area_W =  self.view.bounds.size.width / 3;
    CGFloat area_H =  self.topView.mj_h;
    self.areaBtn = [self senderWithFrame:CGRectMake(area_X, area_Y, area_W, area_H) title:@"地区"];
    
    CGFloat aline_Y = 10;
    CGFloat aline_X = area_W;
    CGFloat aline_W = 1;
    CGFloat aline_H = self.topView.mj_h - 2 * aline_Y;
    UIView *line_left = [[UIView alloc] initWithFrame:CGRectMake(aline_X, aline_Y, aline_W, aline_H)];
    line_left.backgroundColor = XCOLOR_line;
    [self.topView addSubview:line_left];
    
    CGFloat subject_X = area_W;
    CGFloat subject_Y = area_Y;
    CGFloat subject_W = area_W;
    CGFloat subject_H = area_H;
    self.subjectBtn =  [self senderWithFrame:CGRectMake(subject_X, subject_Y, subject_W, subject_H) title:@"专业"];
    
    CGFloat rline_Y = aline_Y;
    CGFloat rline_X =  subject_X + subject_W;
    CGFloat rline_W = aline_W;
    CGFloat rline_H = aline_H;
    UIView *line_right = [[UIView alloc] initWithFrame:CGRectMake(rline_X, rline_Y, rline_W, rline_H)];
    line_right.backgroundColor = XCOLOR_line;
    [self.topView addSubview:line_right];
    
    CGFloat rank_X =  area_W * 2;
    CGFloat rank_Y =  area_Y;
    CGFloat rank_W =  area_W;
    CGFloat rank_H =  area_H;
    self.rankingBtn = [self senderWithFrame:CGRectMake(rank_X, rank_Y, rank_W, rank_H) title:@"排名"];
 
}


- (UIButton *)senderWithFrame:(CGRect)frame title:(NSString *)title{
    
    UIButton *sender = [[UIButton alloc] initWithFrame:frame];
    [sender setTitle:title forState:UIControlStateNormal];
    [sender setTitleColor:XCOLOR_TITLE forState:UIControlStateNormal];
    [sender setTitleColor:XCOLOR_LIGHTBLUE forState:UIControlStateSelected];
    [sender setBackgroundImage:[UIImage KD_imageWithColor:XCOLOR_LIGHTGRAY] forState:UIControlStateHighlighted];
    sender.titleLabel.font  = XFONT(16);
    [sender addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:sender];
    
    return sender;
    
}

- (void)onClick:(UIButton *)sender{

    
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
            self.area_bgView.mj_h = 0;
            self.country_bgView.mj_h = 0;
            
        }];

        
        
        return ;
    }
    
    
    
    
    UIView *selectedView;
    UIView *unSelectedView_A;
    UIView *unSelectedView_B;
 
    if ([sender.currentTitle isEqualToString:@"排名"])
    {
    
        selectedView = self.rank_table;
        unSelectedView_A = self.area_bgView;
        unSelectedView_B = self.country_bgView;
    }
    
    if ([sender.currentTitle isEqualToString:@"专业"])    {
        
        selectedView = self.area_bgView;
        unSelectedView_A = self.rank_table;
        unSelectedView_B = self.country_bgView;
    }
    
    if ([sender.currentTitle isEqualToString:@"地区"]){
        
        selectedView = self.country_bgView;
        unSelectedView_A = self.rank_table;
        unSelectedView_B = self.area_bgView;
    }
    
    
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        
        if ([sender.currentTitle isEqualToString:@"排名"]) {
        
             self.rank_table.mj_h = self.rankings.count * 50;
        }
            
        if ([sender.currentTitle isEqualToString:@"专业"]) {
            
             self.area_bgView.mj_h = XSCREEN_HEIGHT - self.area_bgView.mj_y - XNAV_HEIGHT;
        }
        
        if ([sender.currentTitle isEqualToString:@"地区"]) {
            
            self.country_bgView.mj_h = XSCREEN_HEIGHT - self.country_bgView.mj_y - XNAV_HEIGHT;
        }
        
        
        unSelectedView_A.mj_h = 0;
        unSelectedView_B.mj_h = 0;
        
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


- (void)makeAreaOptionView{
    
    CGFloat area_bg_Y  = 50;
    UIView  *area_bg = [[UIView alloc] initWithFrame:CGRectMake(0, area_bg_Y, XSCREEN_WIDTH, 0)];
    area_bg.backgroundColor = XCOLOR_RED;
    self.area_bgView = area_bg;
    [self.view addSubview:area_bg];
    area_bg.clipsToBounds = YES;
    
    CGFloat area_W  =   XSCREEN_WIDTH /3;
    self.area_table = [self defaultTableViewWithframe:CGRectMake(0, 0, area_W, XSCREEN_HEIGHT - area_bg_Y - XNAV_HEIGHT)];
    [self.area_bgView addSubview:self.area_table];
    self.area_table.backgroundColor = XCOLOR_BG;

    CGFloat subject_X  = area_W;
    CGFloat subject_W  = XSCREEN_WIDTH - area_W;
    self.subject_table = [self defaultTableViewWithframe:CGRectMake(subject_X, 0, subject_W , XSCREEN_HEIGHT - area_bg_Y - XNAV_HEIGHT)];
    [self.area_bgView addSubview:self.subject_table];
    
}

- (void)makeCountryOptionView{
    
    UIView  *country_bg = [[UIView alloc] initWithFrame:CGRectMake(0, 50, XSCREEN_WIDTH, 0)];
    country_bg.backgroundColor = XCOLOR_LIGHTBLUE;
    [self.view addSubview:country_bg];
    self.country_bgView = country_bg;
}


-(void)makeTableView{
    
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.rank_table) return self.rankings.count;
    
    if (tableView == self.area_table) return self.areas.count;
    
    if (tableView == self.subject_table) return self.current_area.subjects.count;

 
    return 0;

}

static NSString *identify = @"uniFilter";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UniversityCourseFilterCell *cell =[tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        
        cell =[[UniversityCourseFilterCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identify];
        
    }
    
    
    if (tableView == self.rank_table){
        
        cell.title =  self.rankings[indexPath.row];
        cell.onSelected = [self.current_rank isEqualToString:self.rankings[indexPath.row]];
        cell.isTextAligmentLeft = NO;
        
    }else{
        
        cell.isTextAligmentLeft = YES;

    }

    
    
    if (tableView == self.area_table) {
        
        MyOfferArea *area = self.areas[indexPath.row];
        cell.title =  area.name;
        cell.contentView.backgroundColor = XCOLOR_BG;
        cell.onSelected = [self.current_area.name isEqualToString:area.name];

        
    }
    
    
    
    if (tableView == self.subject_table) {
        
            MyOfferSubjecct *subject = self.current_area.subjects[indexPath.row];
            cell.title = subject.name;
            cell.onSelected = [self.current_subject.name isEqualToString:subject.name];
        
    }
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (tableView == self.rank_table) {
        
        self.current_rank = self.rankings[indexPath.row];
 
        [self.rank_table reloadData];
        
    }
    
    
    if (tableView == self.subject_table) {
        
        self.current_subject = self.current_area.subjects[indexPath.row];
        
        [self.subject_table reloadData];
        
    }
    
    
    if (tableView == self.area_table) {
        
        self.current_area = self.areas[indexPath.row];
        
        [self.area_table reloadData];

        [self.subject_table reloadData];
        
        self.current_subject = nil;
        
        return ;
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}



@end
