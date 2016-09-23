//
//  FavoriteViewController.m
//  
//
//  Created by Blankwonder on 6/17/15.
//
//  我的关注院校
#define kCellIdentifier NSStringFromClass([SearchResultCell class])

#import "FavoriteViewController.h"
#import "UniversityFrameObj.h"
#import "UniversityObj.h"
#import "NewSearchResultCell.h"
#import "UniversityViewController.h"

@interface FavoriteViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *FavoriteTableView;
@property (strong, nonatomic) XWGJnodataView *noDataView;
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
    
    [self makeNodataView];
 
}


-(void)makeTableView
{
    self.FavoriteTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, XScreenWidth, XScreenHeight - NAV_HEIGHT) style:UITableViewStyleGrouped];
    self.FavoriteTableView.dataSource = self;
    self.FavoriteTableView.delegate = self;
    [self.view  addSubview:self.FavoriteTableView];
    self.FavoriteTableView.backgroundColor = XCOLOR_BG;
    self.FavoriteTableView.tableFooterView = [[UIView alloc] init];
    
}


-(void)makeOtherView{

    self.title = GDLocalizedString(@"Setting-002");
}

-(void)makeNodataView
{
    self.noDataView =[XWGJnodataView noDataView];
    self.noDataView.contentLabel.text = GDLocalizedString(@"Favorite-NOTI");
    self.noDataView.hidden = YES;
    [self.view insertSubview:self.noDataView aboveSubview:self.FavoriteTableView];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
 }

- (void)reloadData {
    
    if (![self checkNetworkState]) {
        
        self.noDataView.hidden = NO;
        
        self.noDataView.contentLabel.text = GDLocalizedString(@"NetRequest-noNetWork") ;
        
        return;
    }
    
    XJHUtilDefineWeakSelfRef
    [self
     startAPIRequestUsingCacheWithSelector:@"GET api/account/favorites"
     parameters:@{}
     success:^(NSInteger statusCode, id response) {
         
         [weakSelf configrationUIWithresponse:response];
         
         [weakSelf.FavoriteTableView reloadData];
     }];
}


- (void)configrationUIWithresponse:(id)response{

    NSArray *universities = (NSArray *)response;
    
    NSMutableArray *uni_temps = [NSMutableArray array];
    
    [universities enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UniversityObj *uni = [UniversityObj createUniversityWithUniversityInfo:obj];
        
        UniversityFrameObj *uniFrame = [UniversityFrameObj UniversityFrameWithUniversity:uni];
        
        [uni_temps addObject:uniFrame];
        
    }];
    
    self.favor_Unies = [uni_temps copy];
    
    self.noDataView.hidden = self.favor_Unies.count == 0 ? NO : YES;

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
   
    NewSearchResultCell *cell =[NewSearchResultCell CreateCellWithTableView:tableView];
  
    UniversityFrameObj *uniFrame = self.favor_Unies[indexPath.section];
  
    UniversityObj *uni =uniFrame.uniObj;
    
    cell.isStart = [uni.countryName isEqualToString:GDLocalizedString(@"CategoryVC-AU")];
    
    cell.uni_Frame = uniFrame;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    UniversityFrameObj *uniFrame = self.favor_Unies[indexPath.section];
    UniversityObj *uni =uniFrame.uniObj;
    UniversityViewController *University = [[UniversityViewController alloc] init];
    University.uni_id = uni.universityID;
    [self.navigationController pushViewController:University animated:YES];
    
}


-(void)dealloc
{
    KDClassLog(@" 收藏院校  dealloc");
}

@end
