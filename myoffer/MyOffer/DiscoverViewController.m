//
//  DiscoverViewController.m
//  MyOffer
//
//  Created by Blankwonder on 6/7/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import "DiscoverViewController.h"
#import "DiscoveryCell.h"
#import "SearchViewController.h"

@interface DiscoverViewController  (){
    BOOL _searchBarExpanded;
    CGFloat _dragStartContentOffsetY;
    
    NSArray *_items;
    
    NSArray *_cells;
}

@end

#define kCellIdentifier NSStringFromClass([DiscoveryCell class])

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _searchBarTextField.placeholder = GDLocalizedString(@"Discover_search");
    
    self.view.backgroundColor = [UIColor redColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, self.tabBarController.tabBar.frame.size.height, 0);
//    _searchBar.layer.borderWidth = 2;
//    _searchBar.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.1].CGColor;
    _searchBar.layer.masksToBounds = NO;
    _searchBar.layer.shadowColor = [UIColor blackColor].CGColor;
    _searchBar.layer.shadowOffset = CGSizeMake(1, 1);
    _searchBar.layer.shadowRadius = 1;
    _searchBar.layer.shadowOpacity = 0.2;
    
    [self startAPIRequestUsingCacheWithSelector:kAPISelectorHomepage parameters:nil success:^(NSInteger statusCode, NSDictionary *response) {
        _items = (id)response;
        
        
        [self.tableView reloadData];
        
        NSMutableArray *cells = [NSMutableArray array];
        [_items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
          
            DiscoveryCell *cell = [[NSBundle mainBundle] loadNibNamed:kCellIdentifier owner:nil options:nil].firstObject;
            [cells addObject:cell];
            
//            [cell KD_setFrameSizeWidth:KDUtilScreenWidth()];
//            [cell KD_setFrameSizeHeight:100];
            
            cell.backgroundImageView.image = nil;
            [[KDImageCache sharedInstance]
             loadImageWithURL:obj[@"image"]
             completion:^(UIImage *image, NSString *imageURL) {
                 if (image) {
                     cell.backgroundImageView.image = image;
                     
                     [cell KD_setFrameSizeHeight:ceilf(KDUtilScreenWidth() * image.size.height / image.size.width)];
                     [_tableView reloadData];
                 }
             }];
        }];
        _cells = cells;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSearchBarExpanded:(BOOL)expanded animated:(BOOL)animated {
    if (_searchBarExpanded == expanded) return;
    _searchBarExpanded = expanded;
    void (^action)() = ^{
        if (expanded) {
            _searchBarTextField.alpha = 1;
            _searchBarWidth.constant = self.view.frame.size.width - 80.0;
            _searchBarTextFieldWidth.constant = _searchBarWidth.constant - 71.0 + 10.0;
        } else {
            _searchBarTextField.alpha = 0;
            _searchBarWidth.constant = 45.0;
        }
        [self.view layoutIfNeeded];
    };
    
    [self.view layoutIfNeeded];
    if (animated) {
        [UIView animateWithDuration:0.5 animations:action];
    } else {
        action();
    }
    
    if (!expanded) {
        [_searchBarTextField resignFirstResponder];
    }
    
    if (animated) {
        if (!expanded) {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
            animation.duration = 0.5;
            animation.fromValue = @(5.0f);
            animation.toValue = @(45.0f / 2.0f);
            animation.removedOnCompletion = NO;
            animation.fillMode = kCAFillModeForwards;
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            
            [_searchBar.layer addAnimation:animation forKey:@"animation"];
        } else {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
            animation.duration = 0.5;
            animation.toValue = @(5.0f);
            animation.fromValue = @(45.0f / 2.0f);
            animation.removedOnCompletion = NO;
            animation.fillMode = kCAFillModeForwards;
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            
            [_searchBar.layer addAnimation:animation forKey:@"animation"];
        }
    } else {
        _searchBar.layer.cornerRadius = expanded ? 5 : 45.0 / 2.0;
    }
}

- (IBAction)searchButtonPressed {
    SearchViewController *vc = [[SearchViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _dragStartContentOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y - _dragStartContentOffsetY > 100.0) {
        [self setSearchBarExpanded:NO animated:YES];
    } else if (scrollView.contentOffset.y - _dragStartContentOffsetY < 0.0) {
        [self setSearchBarExpanded:YES animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];

    [self setSearchBarExpanded:YES animated:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _cells[indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DiscoveryCell *cell = _cells[indexPath.row];
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *info = _items[indexPath.row];
    
    if (info[@"university"]) {
        [self.navigationController pushUniversityViewControllerWithID:info[@"university"] animated:YES];
    } else if (info[@"search"])  {
        SearchResultViewController *vc = [[SearchResultViewController alloc] initWithSearchText:info[@"search"] orderBy:nil];
        [self.navigationController pushViewController:vc animated:YES];

    }
}

@end
