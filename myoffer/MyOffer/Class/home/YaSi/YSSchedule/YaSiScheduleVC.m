//
//  YaSiScheduleVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/28.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "YaSiScheduleVC.h"
#import "YSScheduleCell.h"
#import "YaSiScheduleOnLivingCell.h"
#import "YSCalendarVC.h"

@interface YaSiScheduleVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)MyOfferTableView *tableView;

@end

@implementation YaSiScheduleVC
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    NavigationBarHidden(NO);
    [MobClick beginLogPageView:@"page课程表"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"page课程表"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeUI];
}

- (void)makeUI{
    
    self.title = @"我的课程";
    [self makeTableView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:XImage(@"recommend_history") style:UIBarButtonItemStyleDone target:self action:@selector(caseCalendar)];
}

- (void)makeTableView
{
    self.tableView =[[MyOfferTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
    self.tableView.estimatedRowHeight = 123;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, XNAV_HEIGHT, 0);
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, 0)];
    header.backgroundColor = XCOLOR_WHITE;

    CGFloat icon_w = XSCREEN_WIDTH;
    CGFloat icon_h =  icon_w * 190.0/375;
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, icon_w, icon_h)];
    iconView.backgroundColor = XCOLOR_RANDOM;
    [header addSubview:iconView];
 
    CGFloat title_y =  icon_h;
    CGFloat title_h =  60;
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, title_y, XSCREEN_WIDTH, title_h)];
    titleLab.textColor = XCOLOR_TITLE;
    titleLab.font = XFONT(18);
    titleLab.text = @"共20次课程";
    [header addSubview:titleLab];
    header.mj_h = title_y + title_h;
 
    self.tableView.tableHeaderView = header;
 }



#pragma mark :  UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    YaSiScheduleOnLivingCell  *cell =[tableView dequeueReusableCellWithIdentifier:@"YaSiScheduleOnLivingCell"];
    if (!cell) {
        cell = Bundle(@"YaSiScheduleOnLivingCell");
    }
 
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark : 事件处理

- (void)caseCalendar{
    
    YSCalendarVC *vc = [[YSCalendarVC alloc] init];
    PushToViewController(vc);
}

- (void)dealloc{
    
    KDClassLog(@"课程表 + YaSiScheduleVC + dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


