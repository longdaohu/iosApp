//
//  SearchResultViewController.m
//  MyOffer
//
//  Created by Blankwonder on 6/10/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//  查询结果页面   搜索结果页面

#import "SearchResultViewController.h"
#import "SearchResultCell.h"

@interface SearchResultViewController () {
    NSString *_text, *_orderBy, *_fieldKey, *_subject, *_country, *_state;
    BOOL _descending;
    NSMutableArray *_result;
    NSMutableSet *_resultIDSet;
    NSArray *_availableOrderKey;
    
    NSInteger _allResultCount;
    UIView *_loadMoreIndicatorView;
    UIView *_loadingBackView; //在加载数据时的遮罩
     BOOL _shouldShowLoadMoreIndicator;
    int _nextPage;
    BOOL _loading;
}
@property(nonatomic,strong)KDProgressHUD *progressHub;

@end

#define kCellIdentifier NSStringFromClass([SearchResultCell class])

@implementation SearchResultViewController


- (instancetype)initWithSearchText:(NSString *)text orderBy:(NSString *)orderBy {
    return [self initWithSearchText:text key:@"text" orderBy:orderBy];
}

- (instancetype)initWithSearchText:(NSString *)text key:(NSString *)key orderBy:(NSString *)orderBy {
    self = [self init];
    if (self) {
        _text = text;
        _fieldKey = key;
        _orderBy = orderBy;
        self.title = text;
 
        self.hidesBottomBarWhenPushed = YES;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        _result = [NSMutableArray array];
        _resultIDSet = [NSMutableSet set];
    }
    return self;
}

- (instancetype)initWithFilter:(NSString *)key value:(NSString *)value orderBy:(NSString *)orderBy {
    self = [self init];
    if (self) {
        _text = @"";
        _fieldKey = @"text";
        _orderBy = orderBy;
        if([key  isEqual: @"subject"]) {
            _subject = value;
        } else if([key  isEqual: @"country"]) {
            _country = value;
        } else if([key  isEqual: @"state"]) {
            _state = value;
        }
        
        self.title = value;
        self.hidesBottomBarWhenPushed = YES;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        

        
        _result = [NSMutableArray array];
        _resultIDSet = [NSMutableSet set];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    {
        
        UIView *loadMoreIndicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [indicatorView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [loadMoreIndicatorView addSubview:indicatorView];
        [indicatorView startAnimating];
        
        NSLayoutConstraint *centerX = [NSLayoutConstraint
                                       constraintWithItem:indicatorView
                                       attribute:NSLayoutAttributeCenterX
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:loadMoreIndicatorView
                                       attribute:NSLayoutAttributeCenterX
                                       multiplier:1.0f
                                       constant:0.f];
        
        NSLayoutConstraint *centerY = [NSLayoutConstraint
                                       constraintWithItem:indicatorView
                                       attribute:NSLayoutAttributeCenterY
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:loadMoreIndicatorView
                                       attribute:NSLayoutAttributeCenterY
                                       multiplier:1.0f
                                       constant:0.f];
        
        [loadMoreIndicatorView addConstraints:@[centerX, centerY]];
        
        _loadMoreIndicatorView = loadMoreIndicatorView;
    }
    
    [_tableView registerNib:[UINib nibWithNibName:kCellIdentifier bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    
    _availableOrderKey = @[@"ranking_ti", @"name"];
    
    if (_orderBy) {
        _filterViewHeight.constant = 0;
    } else {
        _filterView.items =@[GDLocalizedString(@"SearchResultVC-001"),GDLocalizedString(@"SearchResultVC-002")];  //@[@"TIMES排名", @"按字母排序"];
    }
     NSUInteger orderIndex = [_availableOrderKey indexOfObject:_orderBy];
    if (orderIndex != NSNotFound) {
        _filterView.selectedIndex = orderIndex;
    }
    
    [self reloadDataWithPageIndex:0 refresh:false];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_shouldShowLoadMoreIndicator && !_loading) {
        CGRect rect = [_loadMoreIndicatorView convertRect:_loadMoreIndicatorView.bounds toView:self.view];
        
        if (CGRectIntersectsRect(rect, self.view.bounds)) {
            [self reloadDataWithPageIndex:_nextPage refresh:false];
        }
    }
}

- (void)filterView:(FilterView *)filterView didSelectItemAtIndex:(NSInteger)index descending:(BOOL)descending {
    _orderBy = _availableOrderKey[index];
    _descending = descending;
    
    //在加载时，给filterView工具栏添加上一层遮罩，在加载结束时移除
    _loadingBackView  =[[UIView alloc] initWithFrame:filterView.bounds];
    _loadingBackView.backgroundColor =[UIColor clearColor];
    KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
    [hud hideAnimated:YES afterDelay:1];
    self.progressHub = hud;
 
    [self.view addSubview:_loadingBackView];
    
    [self reloadDataWithPageIndex:0 refresh:true];
    
}

- (void)reloadDataWithPageIndex:(int)page refresh:(BOOL)refresh {
    _loading = YES;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary: @{_fieldKey: _text ?: [NSNull null],
                                 @"page": @(page),
                                 @"size": @40,
                                 @"desc": _descending ? @1: @0,
                                 @"order": _orderBy  ?: @"ranking_ti"}];
    
    if (_subject) {
        [parameters setValue:@[@{@"name": @"subject", @"value": _subject}] forKey:@"filters"];
    } else if(_country) {
        [parameters setValue:@[@{@"name": @"country", @"value": _country}] forKey:@"filters"];
    } else if(_state) {
        [parameters setValue:@[@{@"name": @"state", @"value": _state}] forKey:@"filters"];
    }
    
    [self
     startAPIRequestWithSelector:kAPISelectorSearch
     parameters:parameters
     expectedStatusCodes:nil
     showHUD:_result.count == 0
     showErrorAlert:YES
     errorAlertDismissAction:nil
     additionalSuccessAction:^(NSInteger statusCode, id response) {
         _nextPage = page + 1;
         
         if(refresh) {
              [_resultIDSet removeAllObjects];
             [_result removeAllObjects];
             
         }
          [response[@"universities"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
             NSString *uid = obj[@"_id"];
             
             if (![_resultIDSet containsObject:uid]) {
                 [_resultIDSet addObject:uid];
                 [_result addObject:obj];
              }
         }];
          _allResultCount = [response[@"count"] integerValue];
         
         if (_result.count == 0) {
             _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
             _noResultView.hidden = NO;
         }
         
         self.shouldShowLoadMoreIndicator = _result.count < _allResultCount;
        
         //在加载结束时移除 _loadingBackView
         [_loadingBackView removeFromSuperview];
         _loadingBackView = nil;
          [self.progressHub removeFromSuperViewOnHide];
         
         [_tableView reloadData];
         _loading = NO;
     } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
         _loading = NO;
         self.shouldShowLoadMoreIndicator = NO;
     }];
}


- (void)setShouldShowLoadMoreIndicator:(BOOL)shouldShowLoadMoreIndicator {
    _shouldShowLoadMoreIndicator = shouldShowLoadMoreIndicator;
     
    if (shouldShowLoadMoreIndicator) {
        [_tableView setTableFooterView:_loadMoreIndicatorView];
        
    } else {
        
        [_tableView setTableFooterView:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _result.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    [cell configureWithInfo:_result[indexPath.row] ranking:[_orderBy isEqual: @"ranking_qs"] ? _orderBy : @"ranking_ti"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
      NSDictionary *info = _result[indexPath.row];
     [self.navigationController pushUniversityViewControllerWithID:info[@"_id"] animated:YES];
}

@end


