//
//  SearchViewController.m
//  MyOffer
//
//  Created by Blankwonder on 6/10/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//
#import "SearchViewController.h"
#import "FiltContent.h"
#import "FilterContentFrame.h"
#import "FilterTableViewCell.h"
#import "FilterContentFrame.h"
#import "SearchUniversityCenterViewController.h"

#define SEARCHPAGE @"page搜索"

@interface SearchViewController ()<FilterTableViewCellDelegate>
@property(nonatomic,strong)UITableView *tableView;
//搜索数据
@property(nonatomic,strong)NSMutableArray *FiltItems;
//热门搜索
@property(nonatomic,strong)NSArray *recommentArray;
//历史搜索
@property(nonatomic,strong)NSArray *historyArray;

@end

@implementation SearchViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:SEARCHPAGE];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    
    [_searchBar becomeFirstResponder];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    _searchBar.text = @"";
    
    [_searchBar resignFirstResponder];
    
    [MobClick endLogPageView:SEARCHPAGE];
    
}

-(NSMutableArray *)FiltItems
{
    if (!_FiltItems) {
        
        _FiltItems = [NSMutableArray array];
    }
    return _FiltItems;
}


-(void)makeUI
{

    [self makeSearchBar];
    
    [self makeTableView];

}

-(void)makeSearchBar{

    _searchBar.placeholder = @"搜索名校";
    
    //用于修改searchBar子控件【取消】按钮名称
    for (UIView *view in [[_searchBar.subviews lastObject] subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *cancelBtn = (UIButton *)view;
            [cancelBtn setTitle:GDLocalizedString(@"Potocol-Cancel") forState:UIControlStateNormal];
            [cancelBtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
        }
    }
}

-(void)makeTableView{

    self.tableView            = [[UITableView alloc] initWithFrame:CGRectMake(0, XNAV_HEIGHT,XSCREEN_WIDTH, XSCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    self.tableView.allowsSelection = NO;
    self.tableView.tableFooterView =[[UIView alloc] init];
    [self.view addSubview: self.tableView];
}




-(void)setDataSourceWithContent:(FiltContent *)filter{
    
    FilterContentFrame *filterFrame = [FilterContentFrame filterFrameWithFilter:filter];
    
    [self.FiltItems addObject:filterFrame];
    
    [self.tableView reloadData];

}

-(void)SearchDaraSourse
{
    
    XWeakSelf
    //请求推荐数据
    [self startAPIRequestWithSelector:kAPISelectorSearchRecommand parameters:nil success:^(NSInteger statusCode, id response) {
        
        if (weakSelf.recommentArray.count ==0) {
            
            weakSelf.recommentArray = [response copy];
            
            FiltContent  *recomment = [FiltContent filterWithIcon:@"search_historyHot"  title:GDLocalizedString(@ "SearchVC-hot") subtitlte:@"" filterOptionItems:self.recommentArray];
             [weakSelf setDataSourceWithContent:recomment];
            
        }
        
    }];
    
    
    if (!LOGIN) return; //未登录不加载下一步
    
    //请求历史数据
    [self startAPIRequestWithSelector:kAPISelectorhistorySearch parameters:nil success:^(NSInteger statusCode, id response) {
        
        
        NSMutableArray *histories = [NSMutableArray array];
        
        for (NSDictionary *historyInfo in response) {
            
            [histories addObject:historyInfo[@"text"]];
        }
        
        if (weakSelf.historyArray.count == 0) {
            
            weakSelf.historyArray = [histories copy];
            
            FiltContent  *histroy = [FiltContent filterWithIcon:@"search_history"  title:GDLocalizedString(@ "SearchVC-history") subtitlte:@"" filterOptionItems:self.historyArray];
   
            [weakSelf setDataSourceWithContent:histroy];

        }
        
    }];
    
    
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
    
    [self SearchDaraSourse];
    
}

#pragma mark ——— UITableViewDelegate  UITableViewDATA

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
    cell.delegate        = self;
    cell.indexPath       = indexPath;
    cell.filterFrame     = self.FiltItems[indexPath.row];
    
    return cell;
}



#pragma mark ——— FilterTableViewCellDelegate
-(void)FilterTableViewCell:(FilterTableViewCell *)tableViewCell  WithButtonItem:(UIButton *)sender WithIndexPath:(NSIndexPath *)indexPath
{
    
    [self startSearchWithText:sender.currentTitle];
    
}


#pragma mark ——— UIScrollViewDelegate
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
    
    SearchUniversityCenterViewController *search = [[SearchUniversityCenterViewController alloc] initWithSearchValue:text];
    
    [self.navigationController pushViewController:search animated:YES];
}

-(void)dealloc
{
    KDClassLog(@"搜索页  dealloc");
}
@end

