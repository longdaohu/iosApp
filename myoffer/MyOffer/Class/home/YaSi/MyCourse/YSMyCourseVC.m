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
#import "YSCourseModel.h"
#import "YSCourseGroupModel.h"
#import "YaSiScheduleVC.h"
#import "YSCalendarVC.h"

@interface YSMyCourseVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)MyOfferTableView *tableView;
@property(nonatomic,strong)YasiHeaderView *toolView;
@property(nonatomic,strong)YSCourseGroupModel *groupModel;

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
    [self makeCoursesData];
 }

- (YSCourseGroupModel *)groupModel{
    
    if (!_groupModel) {
        _groupModel = [[YSCourseGroupModel alloc] init];
    }
    return _groupModel;
}

- (void)makeUI{
    
    self.title = @"我的课程";
     [self makeTableView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:XImage(@"YS_calendar") style:UIBarButtonItemStyleDone target:self action:@selector(caseCalendar)];
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
    
    WeakSelf;
    toolView.actionBlock = ^(UIButton *sender) {
        [weakSelf onClick:sender];
    };
}


#pragma mark :  UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.groupModel.cell_height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.groupModel.curent_items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    

    
     YSCourseModel *item = self.groupModel.curent_items[indexPath.row];
 
    if (self.groupModel.type == YSCourseGroupTypeDefault) {
        
        if (item.classId.length == 0) {
            
            YasiCourseTextCell  *cell =[tableView dequeueReusableCellWithIdentifier:@"YasiCourseTextCell"];
            if (!cell) {
                cell =[[YasiCourseTextCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"YasiCourseTextCell"];
            }
            
            return cell;
        }
        
        YasiCourseOnLivingCell  *cell =[tableView dequeueReusableCellWithIdentifier:@"YasiCourseOnLivingCell"];
        if (!cell) {
            cell =[[YasiCourseOnLivingCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"YasiCourseOnLivingCell"];
        }
        cell.item = item;
        return cell;
     }

        YasiCourseCell  *cell =[tableView dequeueReusableCellWithIdentifier:@"YasiCourseCell"];
        if (!cell) {
                cell =[[YasiCourseCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"YasiCourseCell"];
            }
        return cell;
 
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YSCourseModel *item = self.groupModel.curent_items[indexPath.row];
    YaSiScheduleVC *vc = [[YaSiScheduleVC alloc] init];
    vc.item = item;
    PushToViewController(vc);
}


#pragma mark : 数据加载
- (void)makeCoursesData{
    
    NSString *path = [NSString stringWithFormat:@"GET %@api/v1/ielts/courses",DOMAINURL_API];
    
    WeakSelf
    [self startAPIRequestWithSelector:path
                           parameters:nil expectedStatusCodes:nil
                              showHUD:YES showErrorAlert:YES
              errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
                                [weakSelf makeUIWithResponse:response];
                           } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
                               [self.tableView emptyViewWithError:NetRequest_noNetWork];
                           }];
}


- (void)makeUIWithResponse:(id)response{
    
    if (!ResponseIsOK) {
        [self.tableView emptyViewWithError:NetRequest_noNetWork];
        return;
    }
    
    NSArray *result = response[@"result"];
    if (result.count == 0)  {
        [self.tableView emptyViewWithError:NetRequest_NoDATA];
        return;
    }
    self.groupModel.items = [YSCourseModel mj_objectArrayWithKeyValuesArray:result];
    [self.tableView reloadData];
}

#pragma mark :  事件处理

- (void)onClick:(UIButton *)sender{
    
    if ([sender.currentTitle isEqualToString:@"进行中"]) {
        self.groupModel.type = YSCourseGroupTypeDefault;
    }else{
        
        self.groupModel.type = YSCourseGroupTypeFinished;
    }
    [self.tableView reloadData];
    
   if (self.groupModel.curent_items.count == 0) {
       [self.tableView emptyViewWithError:NetRequest_NoDATA];
   }else{
       [self.tableView emptyViewWithHiden:YES];
   }
 
}

- (void)caseCalendar{
    
    YSCalendarVC *vc = [[YSCalendarVC alloc] init];
    PushToViewController(vc);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
