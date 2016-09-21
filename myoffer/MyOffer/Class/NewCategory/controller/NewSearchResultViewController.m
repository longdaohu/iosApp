//
//  NewSearchResultViewController.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/7.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "NewSearchResultViewController.h"
#import "NewSearchResultCell.h"
#import "UniversitySearchHeaderView.h"
#import "UniversityObj.h"
#import "UniversityFrameObj.h"
#import "XWGJnodataView.h"

@interface NewSearchResultViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *_text, *_orderBy, *_fieldKey, *_subject, *_country, *_state;
     BOOL _descending;
     BOOL _loading;
     BOOL _Autralia;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *Restults;
@property(nonatomic,strong)NSArray *sectionTitleList;
@property(nonatomic,assign)NSInteger nextPage;
@property(nonatomic,assign)NSInteger rankNumber;
@property(nonatomic,strong)UIImageView *navImageView;
@property(nonatomic,strong)XWGJnodataView *noDataView;
@end

@implementation NewSearchResultViewController
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




-(XWGJnodataView *)noDataView
{
    if (!_noDataView) {
        
        _noDataView =[XWGJnodataView noDataView];
        _noDataView.hidden = YES;
        [self.view insertSubview:_noDataView aboveSubview:self.tableView];
    }
    
    return _noDataView;
}

-(NSArray *)Restults
{
    if (!_Restults) {
        
        NSMutableArray *five = [NSMutableArray array];
        NSMutableArray *four = [NSMutableArray array];
        NSMutableArray *three = [NSMutableArray array];
        NSMutableArray *two = [NSMutableArray array];
        NSMutableArray *one = [NSMutableArray array];
        
        _Restults =@[five,four,three,two,one];

    }
    return _Restults;
}

-(NSArray *)sectionTitleList
{
    if (!_sectionTitleList) {
        _sectionTitleList = @[GDLocalizedString(@"CategoryNew-fiveStar"),GDLocalizedString(@"CategoryNew-fourStar"),GDLocalizedString(@"CategoryNew-threeStar"),GDLocalizedString(@"CategoryNew-twoStar"),GDLocalizedString(@"CategoryNew-oneStar")];
    }
    return _sectionTitleList;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self makeTableView];
    
    self.rankNumber = 0;
    
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
         
          for (NSDictionary *dic in response[@"universities"]) {
            
              
              UniversityFrameObj *uniFrame =[self makeUniversityFrameWithDictionary:dic];

             if ([dic[RANKTI] integerValue] ==  (5 - self.rankNumber)) {
                 
                 NSMutableArray *temp = self.Restults[self.rankNumber];
                 [temp addObject:uniFrame];
                 
             }else{
             
                 self.rankNumber +=1;

                 NSMutableArray *temp = self.Restults[self.rankNumber];
  
                 [temp addObject:uniFrame];
                 
              }
          }
         
         [self.tableView reloadData];

     } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
         
         self.noDataView.hidden = NO;

     }];
}


-(UniversityFrameObj *)makeUniversityFrameWithDictionary:(NSDictionary *)uniInfor
{
    UniversityObj *uniObj = [UniversityObj createUniversityWithUniversityInfo:uniInfor];
    
    UniversityFrameObj *uniFrame = [UniversityFrameObj UniversityFrameWithUniversity:uniObj];

    return uniFrame;
}

-(void)makeTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, XScreenWidth, XScreenHeight-64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view  addSubview:self.tableView];
    self.tableView.backgroundColor = XCOLOR_BG;
}


#pragma mark —————— UITableViewDelegate  UITableViewDataSource
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UniversitySearchHeaderView *header =[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    
    if (!header) {
        header =[[UniversitySearchHeaderView alloc] initWithReuseIdentifier:@"header"];
    }
    header.title = self.sectionTitleList[section];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    NSArray *temp = self.Restults[section];

    return temp.count > 0 ? 50 : 0;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.Restults.count;
 }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *temp = self.Restults[section];
    
    return temp.count;
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
    
     NSArray *temp = self.Restults[indexPath.section];
     UniversityFrameObj   *uni_Frame = temp[indexPath.row];
     UniversityObj *university = uni_Frame.uniObj;
     [self.navigationController pushUniversityViewControllerWithID:university.universityID animated:YES];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return University_HEIGHT;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
