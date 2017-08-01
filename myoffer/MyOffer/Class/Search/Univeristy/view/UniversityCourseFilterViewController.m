//
//  UniversityCourseFilterViewController.m
//  myOffer
//
//  Created by xuewuguojie on 2017/4/24.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "UniversityCourseFilterViewController.h"
#import "UniversityCourseFilterCell.h"

#define CELL_HEIGHT_DAFAULT  50

@interface UniversityCourseFilterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIView *topView;
//学位按钮
@property(nonatomic,strong)UIButton *A_Btn;
//领域按钮
@property(nonatomic,strong)UIButton *areaBtn;
//当前已选中按钮
@property(nonatomic,strong)UIButton *currentBtn;
@property(nonatomic,strong)UITableView *A_tableView;
@property(nonatomic,strong)UITableView *area_tableView;

//当前已选择项
@property(nonatomic,copy)NSString *current_A;

@property(nonatomic,copy)NSString *current_area;

@property(nonatomic,strong)NSArray *A_Arr;
//学科领域数组
@property(nonatomic,strong)NSArray *areas;

//tableView 默认Frame
@property(nonatomic,assign)CGRect  A_tableView_defaultFrame;
@property(nonatomic,assign)CGRect area_tableView_defaultFrame;

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


- (void)makeUI{
    
    [self makeTableView];
    
    [self makeTopView];
    
    self.current_A = KEY_ALL;
    
    self.current_area = KEY_ALL;
    
}

- (void)makeTopView{
    
    self.view.backgroundColor = XCOLOR(0, 0, 0, 0.1);
    [self.view addSubview:self.topView];
    
    CGFloat level_X = 0;
    CGFloat level_Y = 0;
    CGFloat level_W = self.view.bounds.size.width * 0.5;
    CGFloat level_H = self.topView.mj_h;
    self.A_Btn =  [self senderWithFrame:CGRectMake(level_X, level_Y, level_W, level_H) title:@"学位类型"];
    
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

    CGRect level_Rect = CGRectMake(0, 0, self.view.bounds.size.width, 0);
    self.A_tableView = [self defaultTableViewWithframe:level_Rect];
    self.A_tableView.scrollEnabled = NO;
    
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
    CGFloat  real_Height =  areas.count * CELL_HEIGHT_DAFAULT;
    CGFloat  area_H = real_Height > (XSCREEN_HEIGHT - CELL_HEIGHT_DAFAULT - XNAV_HEIGHT) ?  (XSCREEN_HEIGHT - CELL_HEIGHT_DAFAULT - XNAV_HEIGHT)  : real_Height;
    self.area_tableView.mj_h = area_H;
    self.area_tableView.mj_y = -area_H;
    self.area_tableView_defaultFrame = self.area_tableView.frame;
    //判断是不是能够滚动
     self.area_tableView.scrollEnabled = (area_H != real_Height);
    
}


- (void)setA_Info:(NSDictionary *)A_Info{

    _A_Info = A_Info;
    
    if (A_Info[@"default_item"]) {
        
        self.current_A = A_Info[@"default_item"];
    }
    
    self.A_Arr = A_Info[@"items"];
    
    [self.A_Btn setTitle:A_Info[@"title"] forState:UIControlStateNormal];
    
    CGFloat level_H =  self.A_Arr.count * CELL_HEIGHT_DAFAULT;
    self.A_tableView.mj_h = level_H;
    self.A_tableView.mj_y = -level_H;
    self.A_tableView_defaultFrame = self.A_tableView.frame;

}


- (void)setRightInfo:(NSDictionary *)rightInfo{
    
    _rightInfo = rightInfo;
    
    if (rightInfo[@"default_item"]) {
        
        self.current_area = rightInfo[@"default_item"];
    }
    
  
    [self.areaBtn setTitle:rightInfo[@"title"] forState:UIControlStateNormal];

    self.areas = rightInfo[@"items"];
    
}




#pragma mark : UITableViewDelegate,UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  CELL_HEIGHT_DAFAULT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.A_tableView) {
        
        return self.A_Arr.count;
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
        
    }else{
    
        cell.title = self.A_Arr[indexPath.row];
        cell.onSelected = [self.current_A isEqualToString:self.A_Arr[indexPath.row]];
  
    }
    
    

    
    return cell;
   
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self onClick:self.currentBtn];
    
    
    if (tableView == self.A_tableView) {
     
        NSString *currentValue = indexPath.row == 0 ? @"": self.A_Arr[indexPath.row];
        
        self.current_A = indexPath.row == 0 ? KEY_ALL:self.A_Arr[indexPath.row];
        
        if (self.actionBlock) self.actionBlock(currentValue,self.A_Info[@"key"]);
        
        [self.A_tableView reloadData];
        
        return;
    }
    
    
    NSString *currentValue = indexPath.row == 0 ? KEY_EMPTY_STRING : self.areas[indexPath.row];
    
    self.current_area = indexPath.row == 0 ? KEY_ALL: self.areas[indexPath.row];
    
    if (self.actionBlock) self.actionBlock(currentValue,self.rightInfo[@"key"]);
    
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
    
    XWeakSelf
    //当前Button 为空时，
    if (!self.currentBtn) {
        
        
        //当前Button 为空时，淡化背景色，再收收起 self.view.frame高度
        [UIView animateWithDuration:ANIMATION_DUATION animations:^{
            
            
            weakSelf.view.backgroundColor = XCOLOR(0, 0, 0, 0.1);
            
            
        } completion:^(BOOL finished) {
            
            
            weakSelf.view.frame = realRect;

        }];
        
        
        
         /*当前Button 为空时
          *当 self.level_tableView.mj_y >= 0  时， level_tableView 收起
          *当 self.area_tableView.mj_y >= 0  时， area_tableView 收起
          */
        
        if (self.A_tableView.mj_y >= 0 || self.area_tableView.mj_y >= 0) {
            
            UITableView *tableView = (self.area_tableView.mj_y > 0) ? self.area_tableView : self.A_tableView;
            
            CGRect  tableView_frame = (self.area_tableView.mj_y > 0) ? self.area_tableView_defaultFrame : self.A_tableView_defaultFrame;
          
            [UIView animateWithDuration:ANIMATION_DUATION animations:^{
                
                tableView.frame = tableView_frame;
                
            }];
            
            
        }
        
        
        return ;
        
    }
    
    
    //当筛选框被点中时
    //一个tableView展开时，另一个tableView要收起
    CGFloat area_y = (self.currentBtn == self.areaBtn) ? CELL_HEIGHT_DAFAULT : -self.area_tableView.mj_h;
    
    CGFloat level_y = (self.currentBtn == self.areaBtn) ? - self.A_tableView.mj_h : CELL_HEIGHT_DAFAULT;
    
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
    
        weakSelf.area_tableView.mj_y = area_y;
        
        weakSelf.A_tableView.mj_y = level_y;
        
    }];
    
    //当self.view已经展开时，不再做展开动作
    if (self.view.mj_h > self.base_Height)  return;
    
    self.view.frame = realRect;
    //当筛选框被点中时，背景色加深
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        
         weakSelf.view.backgroundColor = XCOLOR(0, 0, 0, 0.5);
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
