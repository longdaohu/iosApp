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

- (void)loadView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 100;
    self.view = _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = GDLocalizedString(@"Setting-002"); //@"我的关注院校";

    [_tableView registerNib:[UINib nibWithNibName:kCellIdentifier bundle:nil] forCellReuseIdentifier:kCellIdentifier];
}

- (void)reloadData {
    [self
     startAPIRequestUsingCacheWithSelector:@"GET api/account/favorites"
     parameters:@{}
     success:^(NSInteger statusCode, id response) {
         _result = response;
         [_tableView reloadData];
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
