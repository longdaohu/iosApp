//
//  FavoriteViewController.m
//  
//
//  Created by Blankwonder on 6/17/15.
//
//  我的关注院校
#define kCellIdentifier NSStringFromClass([SearchResultCell class])

#import "FavoriteViewController.h"
#import "UniversityViewController.h"
#import "UniversityItemNew.h"
#import "UniItemFrame.h"
#import "UniversityCell.h"

@interface FavoriteViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) XWGJnodataView *noDataView;
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
    
    [self reloadData];
}


-(void)makeUI
{
    [self makeTableView];
    
    [self makeOtherView];
  
 
}


-(void)makeTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, XScreenWidth, XScreenHeight - XNav_Height) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view  addSubview:self.tableView];
    self.tableView.backgroundColor = XCOLOR_BG;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
}


-(void)makeOtherView{

    self.title = GDLocalizedString(@"Setting-002");
}


-(XWGJnodataView *)noDataView{

    if (!_noDataView) {

        _noDataView =[XWGJnodataView noDataView];
        _noDataView.contentLabel.text = GDLocalizedString(@"Favorite-NOTI");
        _noDataView.hidden = YES;
        [self.view insertSubview:_noDataView aboveSubview:self.tableView];
    }
    
    return _noDataView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
 }

//请求数据
- (void)reloadData {
    
    if (![self checkNetworkState]) {
        
        self.noDataView.hidden = NO;
        self.noDataView.contentLabel.text = GDLocalizedString(@"NetRequest-noNetWork") ;
        
        return;
    }
    
    XWeakSelf
    [self
     startAPIRequestUsingCacheWithSelector:kAPISelectorFavorites
     parameters:nil
     success:^(NSInteger statusCode, id response) {
         
        
         [weakSelf configrationUIWithresponse:response];
         
     }];
}

//根据返回数据配置UI
- (void)configrationUIWithresponse:(id)response{

    
    NSArray *universities = (NSArray *)response;
    
    NSMutableArray *uni_temps = [NSMutableArray array];
    
    [universities enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        [uni_temps addObject: [UniItemFrame frameWithUniversity:[UniversityItemNew mj_objectWithKeyValues:obj]]];
        
    }];
    
   
    self.favor_Unies = [uni_temps copy];
    
    self.noDataView.hidden = self.favor_Unies.count == 0 ? NO : YES;
    
    [self.tableView reloadData];

}


#pragma mark ———————— UITableViewDataSource, UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return HEIGHT_ZERO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return PADDING_TABLEGROUP;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return University_HEIGHT;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.favor_Unies.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    UniversityCell *uni_cell =[UniversityCell cellWithTableView:tableView];
    
    uni_cell.itemFrame = self.favor_Unies[indexPath.section];
    
    return uni_cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UniItemFrame *uniFrame = self.favor_Unies[indexPath.section];
    
     [self.navigationController pushViewController:[[UniversityViewController alloc] initWithUniversityId:uniFrame.item.NO_id] animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


-(void)dealloc
{
    KDClassLog(@" 收藏院校  dealloc");
}

@end
