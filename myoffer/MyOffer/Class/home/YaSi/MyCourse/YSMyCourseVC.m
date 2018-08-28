//
//  YSMyCourseVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/28.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "YSMyCourseVC.h"
#import "YasiCourseCell.h"
#import "YasiHeaderView.h"
#import "YasiCourseOnLivingCell.h"
#import "YasiCourseTextCell.h"

@interface YSMyCourseVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)MyOfferTableView *tableView;
@property(nonatomic,strong)YasiHeaderView *toolView;
@end

@implementation YSMyCourseVC

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    NavigationBarHidden(NO);
    [MobClick beginLogPageView:@"page我的课程"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"page我的课程"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeUI];
 }

- (void)makeUI{
    
    self.title = @"我的课程";
     [self makeTableView];
 }

- (void)makeTableView
{
    self.tableView =[[MyOfferTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
    self.tableView.estimatedRowHeight = 200;//很重要保障滑动流畅性
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    [self makeToolView];
    self.tableView.contentInset = UIEdgeInsetsMake(self.toolView.mj_h, 0, XNAV_HEIGHT, 0);
    [self.tableView setMj_offsetY:-self.toolView.mj_h];
}

- (void)makeToolView{
    
    YasiHeaderView *toolView  = [[YasiHeaderView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, 60)];
    self.toolView = toolView;
    [self.view addSubview:toolView];
}


#pragma mark :  UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 111;//72;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 30;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    
//        YasiCourseTextCell  *cell =[tableView dequeueReusableCellWithIdentifier:@"YasiCourseTextCell"];
//        if (!cell) {
//            cell =[[YasiCourseTextCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"YasiCourseTextCell"];
//        }
    
    YasiCourseOnLivingCell  *cell =[tableView dequeueReusableCellWithIdentifier:@"YasiCourseOnLivingCell"];
    if (!cell) {
        cell =[[YasiCourseOnLivingCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"YasiCourseOnLivingCell"];
    }
    
//    YasiCourseCell  *cell =[tableView dequeueReusableCellWithIdentifier:@"YasiCourseCell"];
//    if (!cell) {
//        cell =[[YasiCourseCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"YasiCourseCell"];
//    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSLog(@"mj_offsetY = %lf",scrollView.mj_offsetY);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
