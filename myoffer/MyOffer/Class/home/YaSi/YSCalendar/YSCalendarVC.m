//
//  YSCalendarVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/28.
//  Copyright © 2018年 UVIC. All rights reserved.
//





#import "YSCalendarVC.h"
#import "YSScheduleCell.h"
#import "YaSiScheduleOnLivingCell.h"

@interface YSCalendarVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)MyOfferTableView *tableView;

@end

@implementation YSCalendarVC

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    NavigationBarHidden(NO);
    [MobClick beginLogPageView:@"page课程表日历"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"page课程表日历"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeUI];
}

- (void)makeUI{
    
    self.title = @"课程日历";
    [self makeTableView];
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

- (void)dealloc{
    
    KDClassLog(@"日历 + YSCalendarVC + dealloc");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end



