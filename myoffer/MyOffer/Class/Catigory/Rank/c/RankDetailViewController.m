//
//  RankDetailViewController.m
//  MyOffer
//
//  Created by xuewuguojie on 2017/10/19.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "RankDetailViewController.h"
#import "MyOfferUniversityModel.h"
#import "RankTypeModel.h"
#import "RankTypeHeaderView.h"
#import "RankItemFrameModel.h"
#import "UniversityFrameModel.h"
#import "UniverstityTCell.h"
#import "UniversityViewController.h"

@interface RankDetailViewController ()
@property (weak, nonatomic) IBOutlet MyOfferTableView *tableView;
@property(nonatomic,strong)RankItemFrameModel *typeFrameModel;
@end

@implementation RankDetailViewController
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
}

- (void)makeData{
    
    NSString *path = [NSString stringWithFormat:@"%@%@",kAPISelectorCatigoryRankItem,self.type_id];
    WeakSelf
    [self startAPIRequestWithSelector:path parameters:nil expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:^{
        
    } additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        [weakSelf updateViewWithResponse:response];
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        [weakSelf dismiss];
        
    }];
    
}

- (void)updateViewWithResponse:(id)response{
    
    RankItemFrameModel  *typeFrame = [[RankItemFrameModel alloc] init];
    self.typeFrameModel  = typeFrame;
    typeFrame.rankItem = [RankTypeModel mj_objectWithKeyValues:response];
    
    if (typeFrame.rankItem.descrpt.length > 0) {
        
        RankTypeHeaderView *header = [[RankTypeHeaderView alloc] initWithFrame:typeFrame.header_frame];
        header.typeFrame = typeFrame;
        self.tableView.tableHeaderView = header;
    }
    
    self.title = typeFrame.rankItem.name;
    
    [self.tableView reloadData];
    
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
    
    return Section_headerter_Height_mini;
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
    PushToViewController(vc);
    
}

- (void)dealloc{
    
    KDClassLog(@"排名子项 dealloc");
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
