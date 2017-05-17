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

@property (strong, nonatomic) DefaultTableView *tableView;
//收藏学校数据
@property (strong, nonatomic) NSArray *favor_Unies;

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
    
    self.tableView = [[DefaultTableView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, XSCREEN_HEIGHT - XNAV_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view  addSubview:self.tableView];
    self.tableView.backgroundColor = XCOLOR_BG;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
 }

//请求数据
- (void)makeDataSource {
    
    //网络不连接时，提示网络不连接
    if (![self checkNetworkState]) {
        
        
        [self.tableView emptyViewWithError:GDLocalizedString(@"NetRequest-noNetWork")];
        
        return;
    }
    
    XWeakSelf
    [self
     startAPIRequestUsingCacheWithSelector:kAPISelectorFavorites
     parameters:nil
     success:^(NSInteger statusCode, id response) {
         
         [weakSelf updateUIWithResponse:response];
         
     }];
}

//根据返回数据配置UI
- (void)updateUIWithResponse:(id)response{

    
    NSArray *universities =  [MyOfferUniversityModel mj_objectArrayWithKeyValuesArray:(NSArray *)response];
    
    NSMutableArray *uni_temps = [NSMutableArray array];
    
    [universities enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        [uni_temps addObject:[UniversityFrameNew universityFrameWithUniverstiy:(MyOfferUniversityModel *)obj]];
        
    }];
   
    self.favor_Unies = [uni_temps copy];
    
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
    
    return PADDING_TABLEGROUP;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    UniversityFrameNew *uniFrame = self.favor_Unies[indexPath.section];
    
    return uniFrame.cell_Height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.favor_Unies.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    UniverstityTCell *uni_cell =[UniverstityTCell cellViewWithTableView:tableView];
    
    uni_cell.uniFrame = self.favor_Unies[indexPath.section];
    
    return uni_cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UniversityFrameNew *uniFrame = self.favor_Unies[indexPath.section];
    
     [self.navigationController pushViewController:[[UniversityViewController alloc] initWithUniversityId:uniFrame.universtiy.NO_id] animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


-(void)dealloc
{
    KDClassLog(@" 收藏院校  dealloc");
}

@end
