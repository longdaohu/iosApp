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
//收藏学校数据
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
    
    self.title = GDLocalizedString(@"Setting-002");
  
}


- (void)makeTableView{
    
    self.tableView = [[MyOfferTableView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, XSCREEN_HEIGHT - XNAV_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view  addSubview:self.tableView];
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
 }

//请求数据
- (void)makeDataSource {
    
    //网络不连接时，提示网络不连接
    if (![self checkNetworkState]) {
        
        [self.tableView emptyViewWithError:NetRequest_noNetWork];
        
        return;
    }
    
    
    XWeakSelf
    [self startAPIRequestWithSelector:kAPISelectorFavorites parameters:nil expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        [weakSelf updateUIWithResponse:response];

    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        [weakSelf showError];
        
    }];
    
    
}

//根据返回数据配置UI
- (void)updateUIWithResponse:(id)response{

    
    NSArray *universities =  [MyOfferUniversityModel mj_objectArrayWithKeyValuesArray:(NSArray *)response];
    

    NSMutableArray *uni_temps = [NSMutableArray array];
    [universities enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        [uni_temps addObject:[UniversityFrameNew universityFrameWithUniverstiy:(MyOfferUniversityModel *)obj]];
        
    }];
    self.groups = [uni_temps copy];
    
    [self.tableView reloadData];
    
    if (universities.count > 0) {
        
        [self.tableView emptyViewWithHiden:YES];
        
    }else{
    
       [self.tableView emptyViewWithError:GDLocalizedString(@"Favorite-NOTI")];
        
    }
    

}

#pragma mark : UITableViewDataSource, UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return HEIGHT_ZERO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return Section_header_Height_nomal;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    UniversityFrameNew *uniFrame = self.groups[indexPath.section];
    
    return uniFrame.cell_Height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    UniverstityTCell *cell =[UniverstityTCell cellViewWithTableView:tableView];
    
    cell.uniFrame = self.groups[indexPath.section];
    
    [cell separatorLineShow:NO];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UniversityFrameNew *uniFrame = self.groups[indexPath.section];
    
    [self.navigationController pushViewController:[[UniversityViewController alloc] initWithUniversityId:uniFrame.universtiy.NO_id] animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
