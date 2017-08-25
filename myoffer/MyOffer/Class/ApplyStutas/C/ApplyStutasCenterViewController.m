//
//  ApplyStutasCenterViewController.m
//  myOffer
//
//  Created by xuewuguojie on 2017/8/14.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "ApplyStutasCenterViewController.h"
#import "ApplyStutasModel.h"
#import "ApplyStatusNewCell.h"
#import "ApplyStatusModelFrame.h"
#import "ApplyStatusHistoryViewController.h"

@interface ApplyStutasCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)MyOfferTableView *tableView;
@end

@implementation ApplyStutasCenterViewController

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (self.groups.count == 0) {
     
        [self makeDataSourse];
    }
    
    [self makeUI];
}


#pragma mark : 网络请求

- (void)makeDataSourse{

    XWeakSelf
    
    [self startAPIRequestWithSelector:kAPISelectorStatusList  parameters:nil expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        [weakSelf updateUIWithResponse:response];
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        [weakSelf.tableView emptyViewWithError:NetRequest_ConnectError];
        
    }];
}


- (void)updateUIWithResponse:(id)response{

    NSArray *status_Arr = [ApplyStutasModel mj_objectArrayWithKeyValuesArray:response];
    
    NSMutableArray *status_temps = [NSMutableArray array];
    
    [status_Arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
         ApplyStatusModelFrame *frameModel = [ApplyStatusModelFrame frameWithStatusModel:(ApplyStutasModel*)obj];
        
        [status_temps addObject:@[frameModel]];
        
     }];
    
    self.groups = [status_temps copy];
    
    if (self.groups.count > 0) {
    
        [self.tableView emptyViewWithHiden:YES];
        
    }else{
        
        [self.tableView emptyViewWithError:NetRequest_NoDATA];
    }
    
    
    [self.tableView reloadData];
}

#pragma mark : 新建 UI
- (void)makeUI{

    self.title = @"服务状态列表";

    [self makeTableView];
}

-(void)makeTableView
{
    self.tableView =[[MyOfferTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
    [self.view addSubview:self.tableView];
}


#pragma mark :  UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *items = self.groups[section];
    
    return items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ApplyStatusNewCell *cell = [ApplyStatusNewCell cellWithTableView:tableView];
 
    NSArray *items = self.groups[indexPath.section];

    cell.statusFrame = items[indexPath.row];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *items = self.groups[indexPath.section];

    ApplyStatusModelFrame *status_frame = items[indexPath.row];
    
    return  status_frame.cell_Height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return Section_footer_Height_nomal;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return HEIGHT_ZERO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *items = self.groups[indexPath.section];
    
     ApplyStatusHistoryViewController  *historyVC = [[ApplyStatusHistoryViewController alloc] init];
    
     historyVC.status_frame = items[indexPath.row];
    
     [self.navigationController pushViewController:historyVC animated:YES];
    
}

#pragma mark : 事件处理

- (void)dealloc{
    
    KDClassLog(@"服务状态列表 dealloc");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
