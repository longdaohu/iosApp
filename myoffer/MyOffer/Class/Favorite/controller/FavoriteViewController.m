//
//  FavoriteViewController.m
//  
//
//  Created by Blankwonder on 6/17/15.
//
//  我的关注院校

#import "FavoriteViewController.h"
#import "UniversityViewController.h"
#import "MyOfferUniversityModel.h"
#import "UniverstityTCell.h"

@interface FavoriteViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) MyOfferTableView *tableView;
@property (strong, nonatomic) NSArray *groups;

@end


@implementation FavoriteViewController


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page收藏"];
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"page收藏"];

    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self makeDataSource];
}


-(void)makeUI
{
    [self makeTableView];
    self.title = @"收藏院校";
}


- (void)makeTableView{
    
    self.tableView = [[MyOfferTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view  addSubview:self.tableView];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, XNAV_HEIGHT, 0);
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
 }

//请求数据
- (void)makeDataSource {
    
    //网络不连接时，提示网络不连接
    if (![self checkNetworkState]) {
        if (self.groups == 0) [self.tableView emptyViewWithError:NetRequest_noNetWork];
        return;
    }
 
    XWeakSelf;
    [self startAPIRequestWithSelector:kAPISelectorFavorites parameters:nil expectedStatusCodes:nil showHUD:(self.groups.count == 0) showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        [weakSelf updateWithResponse:response];
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        [weakSelf showError];
    }];
 
}



//根据返回数据配置UI
- (void)updateWithResponse:(id)response{

    
    NSArray *universities =  [MyOfferUniversityModel mj_objectArrayWithKeyValuesArray:(NSArray *)response];
    

    NSMutableArray *groups_tmp = [NSMutableArray array];
    [universities enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
 
        MyOfferUniversityModel *uni = (MyOfferUniversityModel *)obj;
        UniversityFrameNew *uniFrame = [UniversityFrameNew universityFrameWithUniverstiy:uni];
        
        [groups_tmp addObject:@[uniFrame]];
    }];
    
    
    self.groups = [groups_tmp copy];
    [self.tableView reloadData];
    
    if (universities.count > 0) {
       [self.tableView emptyViewWithHiden:YES];
    }else{
       [self.tableView emptyViewWithError:@"Duang!请添加您关注的院校吧！"];
    }
    

}

#pragma mark : UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *group = self.groups[section];
    return group.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    UniverstityTCell *cell =[UniverstityTCell cellViewWithTableView:tableView];
    NSArray *group =  self.groups[indexPath.section];
    cell.uniFrame = group[indexPath.row];
    [cell separatorLineShow:NO];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *group =  self.groups[indexPath.section];
    UniversityFrameNew *uniFrame = group[indexPath.row];
    [self.navigationController pushViewController:[[UniversityViewController alloc] initWithUniversityId:uniFrame.universtiy.NO_id] animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *group =  self.groups[indexPath.section];
    UniversityFrameNew *uniFrame = group[indexPath.row];

    return uniFrame.cell_Height;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
   return  HEIGHT_ZERO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return  Section_footer_Height_nomal;
}

//显示错误提示
- (void)showError{
    
    if (self.groups.count == 0) {
        [self.tableView emptyViewWithError:NetRequest_ConnectError];
    }
}


-(void)dealloc
{
    KDClassLog(@" 收藏院校  dealloc");
}

@end
