//
//  SearchViewController.m
//  MyOffer
//
//  Created by Blankwonder on 6/10/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//
#import "XNewSearchViewController.h"
#import "SearchViewController.h"
#import "SearchResultViewController.h"
#import "FiltContent.h"
#import "SearchViewCell.h"
#import "FilterContentFrame.h"
#import "FilterTableViewCell.h"
#import "FilterContentFrame.h"

@interface SearchViewController ()<FilterTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *searchLabel;
@property (strong, nonatomic) IBOutlet UIView *HotSearchView;
@property(nonatomic,strong)NSMutableArray *FiltItems;
@property(nonatomic,strong)NSArray *hotArray;
@property(nonatomic,strong)NSArray *historyArray;
@property(nonatomic,strong)UITableView *FilterTableView;

@end

@implementation SearchViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [MobClick beginLogPageView:@"page搜索"];
    
    [_searchBar becomeFirstResponder];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_searchBar resignFirstResponder];
    
    [MobClick endLogPageView:@"page搜索"];
    
}




-(void)makeUI
{
    if (self.searchTextPlaceholder) {
        _searchBar.text = self.searchTextPlaceholder;
        [self startSearchWithText:_searchBar.text];
    }
    
    self.FilterTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 64,APPSIZE.width, APPSIZE.height ) style:UITableViewStylePlain];
    self.FilterTableView.dataSource = self;
    self.FilterTableView.delegate   = self;
    self.FilterTableView.allowsSelection = NO;
    self.FilterTableView.tableFooterView =[[UIView alloc] init];
    [self.view addSubview: self.FilterTableView];
    
    //用于修改searchBar子控件【取消】按钮名称
    for (UIView *view in [[_searchBar.subviews lastObject] subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *cancelBtn = (UIButton *)view;
            [cancelBtn setTitle:GDLocalizedString(@"Potocol-Cancel") forState:UIControlStateNormal];
            [cancelBtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
        }
    }
}


-(NSMutableArray *)FiltItems
{
    if (!_FiltItems) {
        _FiltItems = [NSMutableArray array];
    }
    return _FiltItems;
}


-(void)getCurrentSearchDaraSourse
{
    //请求推荐数据
    [self startAPIRequestWithSelector:kAPISelectorSearchRecommand parameters:nil success:^(NSInteger statusCode, id response) {
        
        if (self.hotArray.count ==0) {
            
            self.hotArray = [response copy];
            
            FiltContent  *fileritem002 = [FiltContent filterItemWithLogoName:@"search_historyHot"  titleName:GDLocalizedString(@ "SearchVC-hot") detailTitleName:@"" anditems:self.hotArray];
            FilterContentFrame *recommand = [[FilterContentFrame alloc] init];
            recommand.content = fileritem002;
            
            [self.FiltItems addObject:recommand];
            
            [self.FilterTableView reloadData];
        }
        
    }];
    
    
    if (!LOGIN)
    {
        return;
    }
    
    //请求历史数据
    [self startAPIRequestWithSelector:kAPISelectorhistorySearch parameters:nil success:^(NSInteger statusCode, id response) {
        
        
        NSMutableArray *historyes = [NSMutableArray array];
        for (NSDictionary *historyInfo in response) {
            
            [historyes addObject:historyInfo[@"text"]];
        }
        
        if (self.historyArray.count == 0) {
            
            self.historyArray = [historyes copy];
            
            FiltContent  *fileritem001 = [FiltContent filterItemWithLogoName:@"search_history"   titleName:GDLocalizedString(@ "SearchVC-history") detailTitleName:@""  anditems: self.historyArray];
            
            
            FilterContentFrame *histroy = [[FilterContentFrame alloc] init];
            histroy.content = fileritem001;
            
            [self.FiltItems addObject:histroy];
            
            [self.FilterTableView reloadData];
            
        }
        
    }];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeUI];
    [self getCurrentSearchDaraSourse];
    
}



#pragma mark ————  UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    
    if (searchBar.text.length > 0) {
        [self startSearchWithText:searchBar.text];
    }
    
}

- (void)startSearchWithText:(NSString *)text {
    
    XNewSearchViewController *vc = [[XNewSearchViewController alloc] initWithSearchText:text orderBy:RANKQS];
    
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark ————  UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FilterContentFrame *fileritem = self.FiltItems[indexPath.row];
    
    return fileritem.cellHeigh;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return   self.FiltItems.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    FilterTableViewCell *cell =[FilterTableViewCell cellInitWithTableView:tableView];
    cell.upButton.hidden = YES;
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.filterFrame = self.FiltItems[indexPath.row];
    
    return cell;
}

#pragma mark —————————— FilterTableViewCellDelegate
-(void)FilterTableViewCell:(FilterTableViewCell *)tableViewCell  WithButtonItem:(UIButton *)sender WithIndexPath:(NSIndexPath *)indexPath
{
    
    XNewSearchViewController *vc = [[XNewSearchViewController alloc] initWithSearchText:sender.currentTitle orderBy:RANKQS];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark ———— UIScrollViewDelegate
-(void) scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
    //用于修改searchBar 失焦时，取消辽钮仍然可用
    for (UIView *view in [[_searchBar.subviews lastObject] subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            
            UIButton *cancelBtn = (UIButton *)view;
            
            cancelBtn.enabled = YES;
        }
    }
    
}



@end

