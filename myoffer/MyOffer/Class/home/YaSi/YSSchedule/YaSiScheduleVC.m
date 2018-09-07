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
#import "YSScheduleModel.h"
#import "YSUserCommentView.h"
#import "TKEduClassRoom.h"

@interface YaSiScheduleVC ()<UITableViewDelegate,UITableViewDataSource,TKEduRoomDelegate>
@property(nonatomic,strong)MyOfferTableView *tableView;
@property(nonatomic,strong)NSArray *items;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)YSScheduleModel *vedio_selected;
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
    [self makeTKInitialization];
    [self makeCoursesData];
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
    
    self.title = @"课程表";
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
    [iconView sd_setImageWithURL:[NSURL URLWithString:self.item.productImg] placeholderImage:XImage(@"placeholderImage")];
 
    CGFloat title_y =  icon_h;
    CGFloat title_h =  60;
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, title_y, XSCREEN_WIDTH, title_h)];
    titleLab.textColor = XCOLOR_TITLE;
    titleLab.font = XFONT(18);
    self.titleLab = titleLab;
    [header addSubview:titleLab];
    header.mj_h = title_y + title_h;

    self.tableView.tableHeaderView = header;
 }



#pragma mark :  UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    YSScheduleCell  *cell =[tableView dequeueReusableCellWithIdentifier:@"YSScheduleCell"];
    if (!cell) {
        cell = Bundle(@"YSScheduleCell");
    }
    cell.row = indexPath.row;
    cell.item = self.items[indexPath.row];

    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YSScheduleModel *item = self.items[indexPath.row];
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

#pragma mark : 数据加载
- (void)makeCoursesData{
    
    
    NSString *path = [NSString stringWithFormat:@"GET %@api/v1/ielts/schedule?id=%@",DOMAINURL_API,self.item.classId];
    WeakSelf
    [self startAPIRequestWithSelector:path
                           parameters:nil expectedStatusCodes:nil
                              showHUD:YES showErrorAlert:YES
              errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
                  [weakSelf makeUIWithResponse:response];
              } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
                  weakSelf.tableView.tableHeaderView = [UIView new];
                  [weakSelf.tableView emptyViewWithError:NetRequest_noNetWork];
     }];
}

- (void)makeUIWithResponse:(id)response{
    
    if (!ResponseIsOK) {
        self.tableView.tableHeaderView = [UIView new];
        [self.tableView emptyViewWithError:NetRequest_noNetWork];
        return;
    }
    
    NSArray *result = response[@"result"];
    if (result.count == 0)  {
        self.tableView.tableHeaderView = [UIView new];
        [self.tableView emptyViewWithError:NetRequest_NoDATA];
        return;
    }
    self.items = [YSScheduleModel mj_objectArrayWithKeyValuesArray:result];
    
    [self.tableView reloadData];
 
    NSString *count = [NSString stringWithFormat:@" %ld ",result.count];
    self.titleLab.text = [NSString stringWithFormat:@"共%@次课程",count];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:self.titleLab.text];
    [attr addAttribute:NSForegroundColorAttributeName value:XCOLOR_LIGHTBLUE  range: NSMakeRange (1,count.length)];
    self.titleLab.attributedText = attr;
    
}

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
//    if (self.vedio_selected.type == YSScheduleVideoStateLiving) {
        NSString *studentPassword = result[@"studentPassword"];
        roomId = @"429790210";
        studentPassword = @"9490";
        //                                @"host"    :sHost,
        //                                @"port"    :sPort,
        //                                //@"domain"   :sDomain,
        //                                @"userrole":@(_role),
        NSDictionary *tDict = @{
                                @"serial"  :roomId,
                                @"host"    :@"global.talk-cloud.net",
                                @"port"    :@"80",
                                //@"userid"  : @"1111",//可选
                                @"password":studentPassword,//可选
                                @"clientType":@(3),
                                @"nickname":@"正在测试中徐金辉"
                                };
        [TKEduClassRoom joinRoomWithParamDic:tDict ViewController:self Delegate:self isFromWeb:NO];
        
//    }

    return;
    if (self.vedio_selected.type == YSScheduleVideoStateAfter) {
        [self makeRecordpathWithRoom:roomId];
    }
}

- (void)makeRecordpathWithRoom:(NSString *)room{
 
    room = @"856837414";
    NSString *path = [NSString stringWithFormat:@"GET http://global.talk-cloud.net/WebAPI/getrecordlist/key/VGSeGEq2TOmuht7I/serial/%@",room];
    WeakSelf
    [self startAPIRequestWithSelector:path parameters:nil success:^(NSInteger statusCode, id response) {
        [weakSelf updateRecordpathWithResponse:response room:room];
    }];
    
}

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


