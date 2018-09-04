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
#import "YXCalendarView.h"
#import "YSScheduleModel.h"
#import "YSCalendarCourseModel.h"

@interface YSCalendarVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)MyOfferTableView *tableView;
@property (nonatomic, strong) YXCalendarView *calendar;
@property(nonatomic,strong)NSMutableArray *eventArray;
@property(nonatomic,strong)NSMutableArray *livingArray;
@property(nonatomic,strong)YXDateHelpObject *helpObj;
@property(nonatomic,strong)NSArray *cousesArr;
@property(nonatomic,copy)NSString *current_year;

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

- (NSMutableArray *)eventArray{
    if (!_eventArray) {
        
        _eventArray = [NSMutableArray array];
    }
    
    return _eventArray;
}

- (NSMutableArray *)livingArray{
    if (!_livingArray) {
        _livingArray = [NSMutableArray array];
    }
    return _livingArray;
}

- (YXDateHelpObject *)helpObj{
    
    if (!_helpObj) {
        
        _helpObj = [YXDateHelpObject manager];
    }
    
    return _helpObj;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeUI];
    [self makeTodayOnliveData];
}

- (void)makeUI{
    
    self.title = @"课程日历";
    [self makeTableView];
    [self makeCalendar];
    self.current_year = [self.helpObj getStrFromDateFormat:@"yyyy" Date:[NSDate date]];
}

- (void)makeCalendar{
    
    WeakSelf;
    _calendar = [[YXCalendarView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [YXCalendarView getMonthTotalHeight:[NSDate date] type:CalendarType_Week]) Date:[NSDate date] Type:CalendarType_Week];
    _calendar.sendSelectDate = ^(NSDate *selDate) {
        NSString *date_time = [weakSelf.helpObj getStrFromDateFormat:@"yyyy-MM-dd" Date:selDate];
        [weakSelf makeDataWithSelectedDate:date_time];
    };
    _calendar.actionBlock = ^(BOOL next, NSDate *current_date) {
        [weakSelf caseCurrentDateChange:current_date next:next];
    };
    [self.view addSubview:_calendar];
    self.tableView.contentInset = UIEdgeInsetsMake(self.calendar.mj_h, 0, XNAV_HEIGHT, 0);
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
    self.tableView.sectionHeaderHeight = HEIGHT_ZERO;
    self.tableView.sectionFooterHeight= HEIGHT_ZERO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = XCOLOR_WHITE;
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    header.backgroundColor = XCOLOR_BG;
    self.tableView.tableHeaderView = header;
}

#pragma mark : UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.cousesArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YaSiScheduleOnLivingCell  *cell =[tableView dequeueReusableCellWithIdentifier:@"YaSiScheduleOnLivingCell"];
    if (!cell) {
        cell = Bundle(@"YaSiScheduleOnLivingCell");
    }
    cell.item = self.cousesArr[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark : 数据请求
//    NSString *startTime = [helpObj getStrFromDateFormat:@"yyyy-MM-dd" Date:today];
//今日直播
- (void)makeTodayOnliveData{
 
    NSString *startTime =  [NSString stringWithFormat:@"%@-01-01",self.current_year];
    NSString *endTime =  [NSString stringWithFormat:@"%@-12-31",self.current_year];
    WeakSelf;
    NSString *path = [NSString stringWithFormat:@"GET %@api/v1/ielts/calendar-course",DOMAINURL_API];
    [self startAPIRequestWithSelector:path
                           parameters:@{
                                        @"startTime" : startTime,
                                        @"endTime" : endTime,
                                        } expectedStatusCodes:nil showHUD:NO showErrorAlert:NO
              errorAlertDismissAction:nil
              additionalSuccessAction:^(NSInteger statusCode, id response) {
                  [weakSelf updateUIWithResponse:response];
              } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
       }];
    
}

- (void)updateUIWithResponse:(id)response{
    
    if (!ResponseIsOK) {
        return;
    }
    NSArray *result = response[@"result"];
    if (result.count == 0) {
        return;
    }
    NSArray *Calendar_arr = [YSCalendarCourseModel mj_objectArrayWithKeyValuesArray:result];
    [self.livingArray addObjectsFromArray:Calendar_arr];
    
    NSArray *times = [self.livingArray valueForKeyPath:@"date"];
    self.calendar.eventArray = times;
    if (self.cousesArr.count == 0) {
        NSString *date = [self.helpObj getStrFromDateFormat:@"yyyy-MM-dd" Date:[NSDate date]];
        [self makeDataWithSelectedDate:date];
    }

}

- (void)makeDataWithSelectedDate:(NSString *)date_string{
 
    for (YSCalendarCourseModel *item in self.livingArray) {
        
        if ([item.date isEqualToString:date_string]) {
            self.cousesArr = item.courses;
            [self.tableView reloadData];
            return;
        }
    }
    self.cousesArr = nil;
    [self.tableView reloadData];
    
}

#pragma mark : 事件处理
- (void)caseCurrentDateChange:(NSDate *)date   next:(BOOL)next{
    
    if (next) {
        NSString *current_year = [NSString stringWithFormat:@"%ld",(self.current_year.integerValue +1)];
        self.current_year = current_year;
    }else{
        NSString *current_year = [NSString stringWithFormat:@"%ld",(self.current_year.integerValue -1)];
        self.current_year = current_year;
    }
    
    [self makeTodayOnliveData];
}

- (void)dealloc{
    
    KDClassLog(@"日历 + YSCalendarVC + dealloc");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end



