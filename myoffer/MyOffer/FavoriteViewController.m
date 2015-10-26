//
//  FavoriteViewController.m
//  
//
//  Created by Blankwonder on 6/17/15.
//
//  我的关注院校

#import "FavoriteViewController.h"
#import "SearchResultCell.h"

@interface FavoriteViewController () <UITableViewDataSource, UITableViewDelegate> {
    NSArray *_result;
}
@property (weak, nonatomic) IBOutlet UIView *noDataView;
@property (weak, nonatomic) IBOutlet UILabel *notiLabel;

@end

#define kCellIdentifier NSStringFromClass([SearchResultCell class])

@implementation FavoriteViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

//- (void)loadView {
//    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//    _tableView.delegate = self;
//    _tableView.dataSource = self;
//    _tableView.rowHeight = 100;
//    self.view = _tableView;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = GDLocalizedString(@"Setting-002"); //@"我的关注院校";
     self.notiLabel.text =GDLocalizedString(@"Favorite-NOTI");//Duang!请添加您关注的院校吧！
    self.FavoriteTableView.rowHeight = 100;
     self.FavoriteTableView.tableFooterView =[[UIView alloc] init];
     [self.FavoriteTableView registerNib:[UINib nibWithNibName:kCellIdentifier bundle:nil] forCellReuseIdentifier:kCellIdentifier];
   
 }

- (void)reloadData {
    [self
     startAPIRequestUsingCacheWithSelector:@"GET api/account/favorites"
     parameters:@{}
     success:^(NSInteger statusCode, id response) {
         _result = response;
         
         self.noDataView.hidden = _result.count ? YES : NO;
         [self.FavoriteTableView reloadData];
     }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [self reloadData];
    
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _result.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    [cell configureWithInfo:_result[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *info = _result[indexPath.row];
    
    [self.navigationController pushUniversityViewControllerWithID:info[@"_id"] animated:YES];
}

@end
