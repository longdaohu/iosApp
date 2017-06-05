//
//  UniversityCourseFilterViewController.m
//  myOffer
//
//  Created by xuewuguojie on 2017/4/24.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "UniversityCourseFilterViewController.h"
#import "UniversityCourseFilterCell.h"

@interface UniversityCourseFilterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIView *topView;
//学位按钮
@property(nonatomic,strong)UIButton *levelBtn;
//领域按钮
@property(nonatomic,strong)UIButton *areaBtn;
//当前已选中按钮
@property(nonatomic,strong)UIButton *currentBtn;
@property(nonatomic,strong)UITableView *level_tableView;
@property(nonatomic,strong)UITableView *area_tableView;
//tableView 默认Frame
@property(nonatomic,assign)CGRect  level_tableView_defaultFrame;
@property(nonatomic,assign)CGRect area_tableView_defaultFrame;
//学位类型数组
@property(nonatomic,strong)NSArray *levels;
//当前已选择项
@property(nonatomic,copy)NSString *current_Level;
@property(nonatomic,copy)NSString *current_area;

@end

@implementation UniversityCourseFilterViewController

- (instancetype)initWithActionBlock:(UniversityCourseFilterViewBlock)actionBlock{
    
    self = [self init];
    
    if (self) {
    
        self.actionBlock = actionBlock;
    }
    return self;
    
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
        line.frame = CGRectMake(0,_topView.mj_h, _topView.mj_w, LINE_HEIGHT);
        [_topView.layer addSublayer:line];
    }
    
    return _topView;
}

- (NSArray *)levels{

    if (!_levels) {
        
        _levels = @[@"全部",@"本科",@"硕士"];
    }
    
    return _levels;
}

- (void)makeUI{
    
    [self makeTableView];
    
    [self makeTopView];
    
    self.current_Level = @"全部";
    self.current_area = @"全部";
    
}

- (void)makeTopView{
    
    self.view.backgroundColor = XCOLOR(0, 0, 0, 0.1);
    [self.view addSubview:self.topView];
    
    CGFloat level_X = 0;
    CGFloat level_Y = 0;
    CGFloat level_W = self.view.bounds.size.width * 0.5;
    CGFloat level_H = self.topView.mj_h;
      self.levelBtn =  [self senderWithFrame:CGRectMake(level_X, level_Y, level_W, level_H) title:@"学位类型"];
    
    CGFloat area_X =  level_W;
    CGFloat area_Y =  level_Y;
    CGFloat area_W =  level_W;
    CGFloat area_H =  level_H;
    self.areaBtn = [self senderWithFrame:CGRectMake(area_X, area_Y, area_W, area_H) title:@"专业方向"];
    
    
    CGFloat line_Y = 10;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(level_W, line_Y, LINE_HEIGHT, self.topView.mj_h - 2 * line_Y)];
    line.backgroundColor = XCOLOR_line;
    [self.topView addSubview:line];
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

- (void)makeTableView{

    CGFloat level_H =  self.levels.count * 50;
    CGRect level_Rect = CGRectMake(0, -level_H, self.view.bounds.size.width, level_H);
    self.level_tableView = [self defaultTableViewWithframe:level_Rect];
    self.level_tableView_defaultFrame = self.level_tableView.frame;
    self.level_tableView.scrollEnabled = NO;
    
    self.area_tableView = [self defaultTableViewWithframe:CGRectMake(0, 0, XSCREEN_WIDTH, 0)];
    self.area_tableView_defaultFrame = self.area_tableView.frame;

}

- (UITableView *)defaultTableViewWithframe:(CGRect)frame{

    UITableView *tableView =[[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView =[[UIView alloc] init];
    [self.view addSubview:tableView];
    tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;

    return tableView;
}

//传入数据
- (void)setAreas:(NSArray *)areas{

    _areas = areas;
    
    //更新area_tableView 的Frame
    CGFloat  real_Height =  areas.count * 50;
    CGFloat  area_H = real_Height > (XSCREEN_HEIGHT - 50 - XNAV_HEIGHT) ?  (XSCREEN_HEIGHT - 50 - XNAV_HEIGHT)  : real_Height;
    self.area_tableView.mj_h = area_H;
    self.area_tableView.mj_y = -area_H;
    self.area_tableView_defaultFrame = self.area_tableView.frame;
    //判断是不是能够滚动
     self.area_tableView.scrollEnabled = (area_H != real_Height);
    
}



#pragma mark : UITableViewDelegate,UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.level_tableView) {
        
        return _levels.count;
    }
    
    return self.areas.count;
}

static NSString *filter_identify = @"course_filter";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UniversityCourseFilterCell *cell =[tableView dequeueReusableCellWithIdentifier:filter_identify];
    
    if (!cell) {
        
        cell =[[UniversityCourseFilterCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:filter_identify];
    }
    
    
    if (tableView == self.area_tableView) {
        
        cell.title =  self.areas[indexPath.row];
        cell.onSelected = [self.current_area isEqualToString:self.areas[indexPath.row]];
        
        return cell;
    }
    
    
    cell.title = self.levels[indexPath.row];
    cell.onSelected = [self.current_Level isEqualToString:self.levels[indexPath.row]];
    
    return cell;
   
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self onClick:self.currentBtn];
    
    
    if (tableView == self.level_tableView) {
     
        NSString *currentValue =indexPath.row == 0 ? @"": self.levels[indexPath.row];
        
        self.current_Level = indexPath.row == 0 ? @"全部":self.levels[indexPath.row];
        
        if (self.actionBlock) self.actionBlock(currentValue,@"level");
        
        [self.level_tableView reloadData];
        
        return;
    }
    
    
    NSString *currentValue = indexPath.row == 0 ? @"": self.areas[indexPath.row];
    self.current_area = indexPath.row == 0 ? @"全部": self.areas[indexPath.row];
    if (self.actionBlock) self.actionBlock(currentValue,@"area");
    [self.area_tableView reloadData];
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
        
        
        
         /*当前Button 为空时
          *当 self.level_tableView.mj_y >= 0  时， level_tableView 收起
          *当 self.area_tableView.mj_y >= 0  时， area_tableView 收起
          */
        if (self.level_tableView.mj_y >= 0 || self.area_tableView.mj_y >= 0) {
            
            UITableView *tableView = (self.area_tableView.mj_y > 0) ? self.area_tableView : self.level_tableView;
            
            CGRect  tableView_frame = (self.area_tableView.mj_y > 0) ? self.area_tableView_defaultFrame : self.level_tableView_defaultFrame;
          
            [UIView animateWithDuration:ANIMATION_DUATION animations:^{
                
                tableView.frame = tableView_frame;
                
            }];
            
            
        }
        
        
        return ;
        
    }
    
    
    
    
    //当筛选框被点中时
    //一个tableView展开时，另一个tableView要收起
    CGFloat area_y = (self.currentBtn == self.areaBtn) ? 50 : -self.area_tableView.mj_h;
    
    CGFloat level_y = (self.currentBtn == self.areaBtn) ? -self.level_tableView.mj_h : 50;
    
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
    
        self.area_tableView.mj_y = area_y;
        self.level_tableView.mj_y = level_y;
        
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

-(void)dealloc{

    KDClassLog(@" 课程详情 筛选功能 dealloc");
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
