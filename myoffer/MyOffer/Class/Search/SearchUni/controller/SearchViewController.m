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
//@property(nonatomic,strong)NSMutableArray *FiltItems;//搜索数据
@property(nonatomic,strong)NSMutableArray *groups;//搜索数据
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBarConstant;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

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

//-(NSMutableArray *)FiltItems
//{
//    if (!_FiltItems) {
//
//        _FiltItems = [NSMutableArray array];
//    }
//    return _FiltItems;
//}

-(NSMutableArray *)groups
{
    if (!_groups) {
        
        _groups = [NSMutableArray array];
    }
    return _groups;
}



-(void)makeUI
{

    [self makeSearchBar];
    
    [self makeTableView];
    
    self.topBarConstant.constant = XNAV_HEIGHT;
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

    self.tableView.allowsSelection = NO;
    self.tableView.tableFooterView =[[UIView alloc] init];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}

-(void)SearchDaraSourse{
    
    FiltContent  *historyHot = [FiltContent filterWithIcon:@"search_historyHot"  title:GDLocalizedString(@ "SearchVC-hot") subtitlte:@"" filterOptionItems:nil];
    FilterContentFrame *historyHotFrame = [FilterContentFrame filterFrameWithFilter:historyHot];
    [self.groups addObject:historyHotFrame];

    XWeakSelf
    //请求推荐数据
    [self startAPIRequestWithSelector:kAPISelectorSearchRecommand parameters:nil success:^(NSInteger statusCode, id response) {
        
        NSArray *items = (NSArray *)response;
        
        if (items.count > 0){
            
            historyHot.optionItems = items;
            historyHotFrame.filter = historyHot;
            
        }else{
            
            [weakSelf.groups removeObject:historyHotFrame];
        }
        
         [weakSelf.tableView reloadData];
        
    }];
    
    
    if (!LOGIN)return; //未登录不加载下一步
    
    FiltContent  *history = [FiltContent filterWithIcon:@"search_history"  title:GDLocalizedString(@ "SearchVC-history") subtitlte:@"" filterOptionItems:nil];
    FilterContentFrame *historyFrame = [FilterContentFrame filterFrameWithFilter:history];
    [self.groups addObject:historyFrame];
    
    //请求历史数据
    [self startAPIRequestWithSelector:kAPISelectorhistorySearch parameters:nil success:^(NSInteger statusCode, id response) {
        
        NSArray *text_arr =  [response valueForKeyPath:@"text"];
        
        if (text_arr.count > 0){
            
            history.optionItems = text_arr;
            historyFrame.filter = history;
        
        }else{
        
            [weakSelf.groups removeObject:historyFrame];
        }
        
        [weakSelf.tableView reloadData];
        
    }];
    
    
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
    
    [self SearchDaraSourse];
    
}

#pragma mark : UITableViewDelegate  UITableViewDATA

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FilterContentFrame *fileritem = self.groups[indexPath.row];
    
    return fileritem.cellHeigh;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return   self.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FilterTableViewCell *cell =[FilterTableViewCell cellInitWithTableView:tableView];
    cell.upButton.hidden = YES;
    cell.delegate   = self;
    cell.indexPath   = indexPath;
    cell.filterFrame    = self.groups[indexPath.row];
    
    return cell;
}



#pragma mark: FilterTableViewCellDelegate
-(void)FilterTableViewCell:(FilterTableViewCell *)tableViewCell  WithButtonItem:(UIButton *)sender WithIndexPath:(NSIndexPath *)indexPath
{
    [self startSearchWithText:sender.currentTitle];
}


#pragma mark: UIScrollViewDelegate
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


#pragma mark : UISearchBarDelegate
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

