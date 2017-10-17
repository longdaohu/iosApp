//
//  RankItemViewController.m
//  MyOffer
//
//  Created by xuewuguojie on 2017/10/12.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "RankItemViewController.h"
#import "MyOfferUniversityModel.h"
#import "RankTypeModel.h"
#import "RankTypeHeaderView.h"
#import "RankItemFrameModel.h"
#import "UniversityFrameModel.h"
#import "UniverstityTCell.h"
#import "UniversityViewController.h"

@interface RankItemViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)MyOfferTableView *tableView;
@property(nonatomic,strong)RankItemFrameModel *typeFrameModel;


@end

@implementation RankItemViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [MobClick beginLogPageView:@"page排名子页"];
 
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page排名子页"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self makeData];
    
    [self makeTableView];

}

- (void)makeData{
    
    NSString *path = [NSString stringWithFormat:@"%@%@",kAPISelectorCatigoryRankItem,self.type_id];
    XWeakSelf
    [self startAPIRequestWithSelector:path parameters:nil expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        [weakSelf updateViewWithResponse:response];

    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        [self dismiss];
        
    }];

}

- (void)updateViewWithResponse:(id)response{
   
     RankItemFrameModel  *typeFrame = [[RankItemFrameModel alloc] init];
     self.typeFrameModel  = typeFrame;
     typeFrame.rankItem = [RankTypeModel mj_objectWithKeyValues:response];
    
    RankTypeHeaderView *header = [[RankTypeHeaderView alloc] initWithFrame:typeFrame.header_frame];
    header.typeFrame = typeFrame;
    self.tableView.tableHeaderView = header;
    self.title = typeFrame.rankItem.name;

    [self.tableView reloadData];
 
}


- (void)makeTableView
{
    self.tableView =[[MyOfferTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, XNAV_HEIGHT, 0);
    [self.view addSubview:self.tableView];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}


#pragma mark :  UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.typeFrameModel.university_frames.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UniverstityTCell *uni_cell =[UniverstityTCell cellViewWithTableView:tableView];
 
    uni_cell.uniFrameModel = self.typeFrameModel.university_frames[indexPath.section];
    
    [uni_cell separatorLineShow:NO];
    
    return uni_cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
 
    return   [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return  HEIGHT_ZERO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UniversityFrameModel *uniFrameModel =  self.typeFrameModel.university_frames[indexPath.section];
    
    return  uniFrameModel.cell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UniversityFrameModel *uniFrameModel =  self.typeFrameModel.university_frames[indexPath.section];
    
    UniversityViewController *vc = [[UniversityViewController alloc] initWithUniversityId:uniFrameModel.universityModel.short_id] ;

    [self.navigationController pushViewController:vc animated:YES];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
