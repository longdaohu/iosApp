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
#import "TKEduClassRoom.h"
#import "YSUserCommentView.h"

@interface YSCalendarVC ()<UITableViewDelegate,UITableViewDataSource,TKEduRoomDelegate>
@property(nonatomic,strong)MyOfferTableView *tableView;
@property (nonatomic, strong) YXCalendarView *calendar;
@property(nonatomic,strong)NSMutableArray *eventArray;
@property(nonatomic,strong)NSMutableArray *livingArray;
@property(nonatomic,strong)YXDateHelpObject *helpObj;
@property(nonatomic,strong)NSArray *cousesArr;
@property(nonatomic,copy)NSString *current_year;
@property(nonatomic,strong)NSMutableArray *years;
@property(nonatomic,strong)YSScheduleModel *vedio_selected;
@property(nonatomic,strong)YSUserCommentView *commentView;

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
- (NSMutableArray *)years{
    
    if (!_years) {
        
        _years = [NSMutableArray array];
    }
    
    return _years;
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

- (YSUserCommentView *)commentView{
    
    if (!_commentView) {
        
        WeakSelf
        _commentView =  [YSUserCommentView commentView];
        _commentView.actionBlock = ^(NSArray *items) {
            [weakSelf caseCommitResult:items];
        };
     
    }
    
    return _commentView;
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
    [self makeTKInitialization];
}

//初始化拓课
- (void)makeTKInitialization{
    
    [TXSakuraManager registerLocalSakuraWithNames:@[TKDefaultSkin,TKBlackSkin, TKOriginSkin]];
    //切换到默认主题
    NSString *name = [TXSakuraManager getSakuraCurrentName];
    NSInteger type = [TXSakuraManager getSakuraCurrentType];
    [TXSakuraManager shiftSakuraWithName:name type:type];
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
    _calendar.actionBlock = ^(NSInteger year) {
        [weakSelf caseYearData:year];
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
    
    YSScheduleModel *item = self.cousesArr[indexPath.row];
    if (item.type == YSScheduleVideoStateBefore) {
        return;
    }
    if (item.type == YSScheduleVideoStateDefault) {
        [MBProgressHUD showMessage:@"课程已过期"];
        return;
    }
    
    self.vedio_selected = item;
    [self makeRoomDataWithRoomId:item.item_id];
}

#pragma mark TKEduEnterClassRoomDelegate
//error.code  Description:error.description
- (void) onEnterRoomFailed:(int)result Description:(NSString*)desc{
    TKLog(@"TKEduEnterClassRoomDelegate-----onEnterRoomFailed");
}
- (void) onKitout:(EKickOutReason)reason{
    TKLog(@"TKEduEnterClassRoomDelegate-----onKitout");
}
- (void) joinRoomComplete{
    TKLog(@"TKEduEnterClassRoomDelegate-----joinRoomComplete");
}

- (void) leftRoomComplete{
    
    if(self.vedio_selected.type == YSScheduleVideoStateLiving){
        [self.commentView show];
    }
}
- (void) onClassBegin{
    TKLog(@"TKEduEnterClassRoomDelegate-----onClassBegin");
}
- (void) onClassDismiss{
    TKLog(@"TKEduEnterClassRoomDelegate-----onClassDismiss");
}
- (void) onCameraDidOpenError{
    TKLog(@"TKEduEnterClassRoomDelegate-----onCameraDidOpenError");
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
    
    [self.years addObject:self.current_year];
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
            [self.tableView emptyViewWithHiden:YES];
            return;
        }
    }
    
    self.cousesArr = nil;
    [self.tableView reloadData];
    [self.tableView emptyViewWithError:@"今日暂无课程"];
    
}


#pragma mark : 事件处理

- (void)caseCommitResult:(NSArray *)values{
    
    NSMutableDictionary *ratings = [NSMutableDictionary dictionary];
    NSArray *keyes = @[@"fluency",@"practicability",@"teachingAbility",@"punctuality",@"interaction"];
    for (NSInteger index  = 0; index < values.count; index++) {
        [ratings setValue:values[index] forKey:keyes[index]];
    }
    NSDictionary *parameter = @{ @"id":self.vedio_selected.item_id,@"ratings":ratings};
    NSString *path = [NSString stringWithFormat:@"POST %@api/v1/ielts/calendar-appraise",DOMAINURL_API];
    WeakSelf
    [self startAPIRequestWithSelector:path  parameters:parameter success:^(NSInteger statusCode, id response) {
        [weakSelf updateCommentResponse:response];
    }];
}

- (void)updateCommentResponse:(id)response{
    
    NSLog(@"updateCommentResponse == %@",response);
   
}
 
- (void)caseYearData:(NSInteger)year{

    NSString *year_text = [NSString stringWithFormat:@"%ld",year];
    if ([self.years containsObject:year_text]) return;
    self.current_year = year_text;
    [self makeTodayOnliveData];
}

//请求房间号
- (void)makeRoomDataWithRoomId:(NSString *)item_id{
    
    
    NSString *path = [NSString stringWithFormat:@"GET %@api/v1/ielts/courses-room-password?id=%@",DOMAINURL_API,item_id];
    WeakSelf
    [self startAPIRequestWithSelector:path
                           parameters:nil expectedStatusCodes:nil
                              showHUD:YES showErrorAlert:YES
              errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
                  [weakSelf makeVedioWithResponse:response];
              } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
                  [MBProgressHUD showMessage:NetRequest_noNetWork];
              }];
    
}

- (void)makeVedioWithResponse:(id)response{
    
    if (!ResponseIsOK) {
        [MBProgressHUD showMessage:NetRequest_noNetWork];
        return;
    }
    NSDictionary *result = response[@"result"];
    NSString *roomId = result[@"roomId"];
    //直播
    if (self.vedio_selected.type == YSScheduleVideoStateLiving) {
        NSString *studentPassword = result[@"studentPassword"];
        [self caseLivingWithRoom:roomId student:studentPassword];
    }
       //录播
    if (self.vedio_selected.type == YSScheduleVideoStateAfter) {
        [self makeRecordpathWithRoom:roomId];
    }
}

//请求录播路径
- (void)makeRecordpathWithRoom:(NSString *)room{
    
    room = @"856837414";
    NSString *path = [NSString stringWithFormat:@"GET http://global.talk-cloud.net/WebAPI/getrecordlist/key/VGSeGEq2TOmuht7I/serial/%@",room];
    WeakSelf
    [self startAPIRequestWithSelector:path parameters:nil success:^(NSInteger statusCode, id response) {
        [weakSelf updateRecordpathWithResponse:response room:room];
    }];
    
}
//请求录播路径
- (void)updateRecordpathWithResponse:(id)response room:(NSString *)room{
    
    NSArray *recordlist = [response valueForKey:@"recordlist"];
    if (recordlist.count > 0) {
        NSDictionary *record = recordlist.firstObject;
        NSString *recordpath = record[@"recordpath"];
        NSString *path = [NSString stringWithFormat:@"global.talk-cloud.net:8081%@",recordpath];
        NSDictionary *td= @{
                            @"serial"  : room,
                            @"path" : path,//@"global.talk-cloud.net:8081/d817d3b7-d0ab-447b-9b0f-37147d280943-856837414/",
                            @"playback":@(YES),
                            @"type":@"3",//房间类型 0 1v1 3 1v多 10直播 11伪直播 12 旁路直播
                            @"clientType" :@(3),
                            };
        [TKEduClassRoom joinPlaybackRoomWithParamDic:td ViewController:self Delegate:self isFromWeb:YES];
        
        return;
    }
}
//直播
- (void)caseLivingWithRoom:(NSString *)room student:(NSString *)student{
    
    MyofferUser *user = [MyofferUser defaultUser];
 
    NSString *roomId = @"1463031541";
    NSString *studentPassword = @"9766";
    NSDictionary *tDict = @{
                            @"serial"  :roomId,
                            @"host"    :sHost,
                            @"port"    :sPort,
                            @"password":studentPassword,//可选
                            @"clientType":@(3),
                            @"nickname":@"正在测试中xxxx学生A"
                            };
    [TKEduClassRoom joinRoomWithParamDic:tDict ViewController:self Delegate:self isFromWeb:NO];
}


- (void)dealloc{
    
    KDClassLog(@"日历 + YSCalendarVC + dealloc");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end


/*
 - (void)makeRoomDataWithRoomId:(NSString *)item_id{
 
 NSString *path = [NSString stringWithFormat:@"GET %@api/v1/ielts/courses-room-password?id=%@",DOMAINURL_API,item_id];
 WeakSelf
 [self startAPIRequestWithSelector:path
 parameters:nil expectedStatusCodes:nil
 showHUD:YES showErrorAlert:YES
 errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
 [weakSelf makeVedioWithResponse:response];
 } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
 [MBProgressHUD showMessage:NetRequest_noNetWork];
 }];
 }
 
 - (void)makeVedioWithResponse:(id)response{
 
 if (!ResponseIsOK) {
 [MBProgressHUD showMessage:NetRequest_noNetWork];
 return;
 }
 NSDictionary *result = response[@"result"];
 NSLog(@"result == %@",result); //roomId = 856837414 studentPassword = 000;
 }
 
 
 */




