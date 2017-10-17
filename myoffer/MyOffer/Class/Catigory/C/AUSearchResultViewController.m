//
//  AUSearchResultViewController.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/7.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "AUSearchResultViewController.h"
#import "NewSearchResultCell.h"
#import "NomalTableSectionHeaderView.h"
#import "MyOfferUniversityModel.h"


@interface AUSearchResultViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *_text, *_orderBy, *_fieldKey, *_subject, *_country, *_state;
     BOOL _descending;
     BOOL _loading;
     BOOL _Autralia;
}
@property(nonatomic,strong)MyOfferTableView *tableView;
@property(nonatomic,strong)NSArray *Restults;
@property(nonatomic,strong)NSArray *sectionTitleList;
@property(nonatomic,assign)NSInteger nextPage;
@property(nonatomic,strong)UIImageView *navImageView;

@end

@implementation AUSearchResultViewController
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
            _descending = [value containsString:GDLocalizedString(@"CategoryVC-AU")]? YES : NO;
        } else if([key  isEqual: @"state"]) {
            _state = value;
        }
        self.title = value;
        self.hidesBottomBarWhenPushed = YES;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        
}
    return self;
}






-(NSArray *)Restults
{
    if (!_Restults) {
        
        NSMutableArray *five = [NSMutableArray array];
        NSMutableArray *four = [NSMutableArray array];
        NSMutableArray *three = [NSMutableArray array];
        NSMutableArray *two = [NSMutableArray array];
        NSMutableArray *one = [NSMutableArray array];
        NSMutableArray *zero = [NSMutableArray array];

        _Restults =@[five,four,three,two,one,zero];

    }
    return _Restults;
}

-(NSArray *)sectionTitleList
{
    if (!_sectionTitleList) {
        
        _sectionTitleList = @[GDLocalizedString(@"CategoryNew-fiveStar"),GDLocalizedString(@"CategoryNew-fourStar"),GDLocalizedString(@"CategoryNew-threeStar"),GDLocalizedString(@"CategoryNew-twoStar"),GDLocalizedString(@"CategoryNew-oneStar"),@"无星院校"];
        
    }
    return _sectionTitleList;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self makeTableView];
    
    
    [self reloadDataWithPageIndex:0 refresh:NO];
    
}


- (void)reloadDataWithPageIndex:(int)page refresh:(BOOL)refresh {
    
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary: @{
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
     showHUD:YES
     showErrorAlert:YES
     errorAlertDismissAction:nil
     additionalSuccessAction:^(NSInteger statusCode, id response) {
         
         
          for (NSDictionary *obj in response[@"universities"]) {
              
              UniversityFrameNew  *uniFrame = [UniversityFrameNew universityFrameWithUniverstiy:[MyOfferUniversityModel mj_objectWithKeyValues:obj]];
              
              NSInteger index =  [obj[RANK_TI] integerValue] == DEFAULT_NUMBER ?  self.Restults.count - 1 : 5 - [obj[RANK_TI] integerValue];
              
              NSMutableArray *temps = self.Restults[index];
              
              [temps addObject:uniFrame];
              
          }
         
         
         [self.tableView reloadData];

     } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
         
         [self.tableView emptyViewWithError:NetRequest_ConnectError];

     }];
}




-(void)makeTableView
{
    self.tableView = [[MyOfferTableView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, XSCREEN_HEIGHT-64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view  addSubview:self.tableView];
    self.tableView.backgroundColor = XCOLOR_BG;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

}


#pragma mark —————— UITableViewDelegate  UITableViewDataSource
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NomalTableSectionHeaderView *header =[NomalTableSectionHeaderView sectionViewWithTableView:tableView];
    
    [header sectionHeaderWithTitle:self.sectionTitleList[section] FontSize: 20.0f];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    NSArray *items = self.Restults[section];

    return items.count > 0 ? Section_header_Height_nomal : 0;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.Restults.count;
 }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *items = self.Restults[section];
    
    return items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewSearchResultCell *cell =[NewSearchResultCell  CreateCellWithTableView:tableView];
    NSArray *temp = self.Restults[indexPath.section];
    cell.isStart = YES;
    cell.uni_Frame = temp[indexPath.row];
    
  
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
     NSArray *unies = self.Restults[indexPath.section];
     UniversityFrameNew   *uni_Frame = unies[indexPath.row];
     MyOfferUniversityModel *university = uni_Frame.universtiy;
     [self.navigationController pushUniversityViewControllerWithID:university.NO_id animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *unies = self.Restults[indexPath.section];
    
    UniversityFrameNew   *uni_Frame = unies[indexPath.row];
    
    return uni_Frame.cell_Height;
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];

}


-(void)dealloc
{
    KDClassLog(@" 澳大利亚大学排名  dealloc");
}



@end
