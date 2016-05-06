//
//  SearchViewController.m
//  MyOffer
//
//  Created by Blankwonder on 6/10/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchRecommandCell.h"
#import "SearchResultViewController.h"
#import "NewSearchRstViewController.h"

@interface SearchViewController () {
    NSArray *_recommandWords;
}
@property (weak, nonatomic) IBOutlet UILabel *searchLabel;

@end

#define kCollectionCellIdentifier NSStringFromClass([SearchRecommandCell class])

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchLabel.text = GDLocalizedString(@"SearchVC-hot"); // 热门搜索
    
    [_recommandCollectionView registerNib:[UINib nibWithNibName:kCollectionCellIdentifier bundle:nil] forCellWithReuseIdentifier:kCollectionCellIdentifier];

    [self startAPIRequestUsingCacheWithSelector:kAPISelectorSearchRecommand parameters:nil success:^(NSInteger statusCode, NSDictionary *response) {
        _recommandWords = (id)response;
        [_recommandCollectionView reloadData];
    }];
    
    if (self.searchTextPlaceholder) {
        _searchBar.text = self.searchTextPlaceholder;
        [self startSearchWithText:_searchBar.text];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_searchBar becomeFirstResponder];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_searchBar resignFirstResponder];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _recommandWords.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SearchRecommandCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionCellIdentifier forIndexPath:indexPath];
    cell.label.layer.borderColor = [UIColor KD_colorWithCode:0xffbfbfbf].CGColor;
    cell.label.layer.borderWidth = 0.5;
    cell.label.layer.cornerRadius = 2;
    cell.label.text = _recommandWords[indexPath.row];
    return cell;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [self dismissViewControllerAnimated:YES completion:^{}];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = _recommandWords[indexPath.row];
    
    CGSize size = [text KD_sizeWithAttributeFont:[UIFont systemFontOfSize:14]];
    size.width += 10;
    size.height = 23;
    
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = _recommandWords[indexPath.row];

    _searchBar.text = text;
    [self startSearchWithText:text];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    if (searchBar.text.length > 0) {
        [self startSearchWithText:searchBar.text];
    }
}

- (void)startSearchWithText:(NSString *)text {
    NewSearchRstViewController *vc = [[NewSearchRstViewController alloc] initWithSearchText:text orderBy:nil];
    [self.navigationController pushViewController:vc animated:YES];    
}

@end

