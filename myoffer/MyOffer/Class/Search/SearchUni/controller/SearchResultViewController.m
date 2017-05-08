//
//  SearchResultViewController.m
//  MyOffer
//
//  Created by Blankwonder on 6/10/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//  查询结果页面   搜索结果页面

#import "SearchResultViewController.h"
#import "NewSearchResultCell.h"
#import "XWGJnodataView.h"
#import "MyOfferUniversityModel.h"

@interface SearchResultViewController () {
    NSString *_text, *_orderBy, *_fieldKey, *_subject, *_country, *_state, *_city;
    BOOL _descending;
    NSMutableArray *_result;
    NSMutableSet *_resultIDSet;
    NSArray *_availableOrderKey;
    
    NSInteger _allResultCount;
    UIView *_loadMoreIndicatorView;
    BOOL _shouldShowLoadMoreIndicator;
    int _nextPage;
    BOOL _loading;
    BOOL _Autralia;
}
@property(nonatomic,strong)KDProgressHUD *progressHub;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)XWGJnodataView *noDataView;

@end

#define kCellIdentifier NSStringFromClass([SearchResultCell class])

@implementation SearchResultViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"page搜索结果"];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];

}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page搜索结果"];
    
}

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
        
        NSLog(@"orderByorderByorderBy %@",orderBy);

        if([key  isEqual: @"subject"]) {
            _subject = value;
        } else if([key  isEqual: @"country"]) {
            _country = value;
        } else if([key  isEqual: @"state"]) {
            _state = value;
        }else if([key  isEqual: @"city"]) {
            _city = value;
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

-(XWGJnodataView *)noDataView
{
    if (!_noDataView) {
        
        _noDataView =[XWGJnodataView noDataView];
        _noDataView.hidden = YES;
        [self.view insertSubview:_noDataView aboveSubview:self.tableView];
    }
    
    return _noDataView;
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
    
    
    _availableOrderKey = @[@"ranking_ti", @"name"];
    
 
    
    [self reloadDataWithPageIndex:0 refresh:false];
    
    _tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);


}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_shouldShowLoadMoreIndicator && !_loading) {
        CGRect rect = [_loadMoreIndicatorView convertRect:_loadMoreIndicatorView.bounds toView:self.view];
        
        if (CGRectIntersectsRect(rect, self.view.bounds)) {
            [self reloadDataWithPageIndex:_nextPage refresh:false];
        }
    }
}

 

- (void)reloadDataWithPageIndex:(int)page refresh:(BOOL)refresh {
    
    _loading = YES;
 
    _descending = self.xby;

    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary: @{_fieldKey: _text ?: [NSNull null],
                                 @"page": @(page),
                                 @"size": @40,
                                 @"desc": @0,
                                 @"order": [_orderBy isEqualToString:RANK_TI] ? RANK_TI : RANK_QS}];
    
    if (_subject) {
        [parameters setValue:@[@{@"name": @"subject", @"value": _subject}] forKey:@"filters"];
    } else if(_country) {
        [parameters setValue:@[@{@"name": @"country", @"value": _country}] forKey:@"filters"];
    } else if(_state) {
        [parameters setValue:@[@{@"name": @"state", @"value": _state}] forKey:@"filters"];
    }else if(_city) {
        [parameters setValue:@[@{@"name": @"city", @"value": _city}] forKey:@"filters"];
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
   
              
                 UniversityFrameNew  *uniFrame = [UniversityFrameNew universityFrameWithUniverstiy:[MyOfferUniversityModel mj_objectWithKeyValues:obj]];
              
              
                 [_result addObject:uniFrame];
   
            
              
         }];
          _allResultCount = [response[@"count"] integerValue];
         
         if (_result.count == 0) {
             _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
             _noResultView.hidden = NO;
         }
         
         self.shouldShowLoadMoreIndicator = _result.count < _allResultCount;
        
  
          [self.progressHub removeFromSuperViewOnHide];
         
         [_tableView reloadData];
         _loading = NO;
     } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
         _loading = NO;
         self.shouldShowLoadMoreIndicator = NO;
         self.noDataView.hidden = NO;
         
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


#pragma mark : UITableViewDataSource UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    UniversityFrameNew  *uni_Frame = _result[indexPath.row];

    return uni_Frame.cell_Height;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    return _result.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
 
    NewSearchResultCell *cell =[NewSearchResultCell CreateCellWithTableView:tableView];
    cell.optionOrderBy = _orderBy;
 
    UniversityFrameNew  *uniFrame = _result[indexPath.row];
    MyOfferUniversityModel *uni =uniFrame.universtiy;
    cell.isStart = [uni.name isEqualToString:GDLocalizedString(@"CategoryVC-AU")];
    cell.uni_Frame = uniFrame;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UniversityFrameNew *uniFrame =  _result[indexPath.row];
    MyOfferUniversityModel *uniObj = uniFrame.universtiy;
    [self.navigationController pushUniversityViewControllerWithID:uniObj.NO_id animated:YES];
}


-(void)dealloc
{
    KDClassLog(@" 英国、世界大学排名  dealloc");
}


@end


