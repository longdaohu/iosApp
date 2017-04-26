//
//  SearchUniversityCenterViewController.m
//  MyOffer
//
//  Created by xuewuguojie on 2017/4/25.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "SearchUniversityCenterViewController.h"
#import "UniversityNew.h"
#import "UniversityFrameNew.h"
#import "UniversityCourseFrame.h"
#import "UniversityCourseCell.h"
#import "ApplySectionHeaderView.h"
#import "searchSectionFootView.h"
#import "UniversitySubjectListViewController.h"
#import "SearchUniCenterFilterVController.h"

#define KEY_TEXT_S  @"text"
#define KEY_NAME_S  @"name"
#define KEY_VALUE_S  @"value"
#define KEY_FILTERS_S  @"filters"
#define KEY_PAGE_S  @"page"
#define KEY_SIZE_S  @"size"
#define KEY_DESC_S  @"desc"
#define KEY_ORDER_S  @"order"

@interface SearchUniversityCenterViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableDictionary *parametersM;
@property(nonatomic,strong)NSMutableArray *UniFrames;
@property(nonatomic,assign)NSInteger nextPage;
@property(nonatomic,assign)BOOL endPage;
@property(nonatomic,copy)NSString *searchValue;
//筛选工具
@property(nonatomic,strong)SearchUniCenterFilterVController *filter;
@end

@implementation SearchUniversityCenterViewController

- (instancetype)initWithSearchValue:(NSString *)searchValue{

    
    self = [self init];
    
    if (self) {
 
        [self.parametersM setValue:searchValue forKey:KEY_TEXT_S];
        [self.parametersM setValue:RANK_QS forKey:KEY_ORDER_S];
        self.searchValue = searchValue;
        self.title = self.searchValue;
        
    }
    
    
    return self;
}

- (instancetype)initWithKey:(NSString *)key value:(NSString *)value orderBy:(NSNumber *)desc{

    self = [self init];
    
    if (self) {
        
        NSString *rankType = RANK_QS;
        
        if ([key isEqualToString:KEY_CITY] || [key isEqualToString:KEY_STATE] || [key isEqualToString:KEY_COUNTRY] ) {
            
            rankType = RANK_TI;
        }
        
        NSDictionary *filter = @{KEY_NAME_S : key, KEY_VALUE_S:value};
        [self.parametersM setValue:@[filter] forKey:KEY_FILTERS_S];
        [self.parametersM setValue:rankType forKey:KEY_ORDER_S];
        [self.parametersM setValue:desc forKey:KEY_DESC_S];
        
        self.title = value;
        
    }
    
    return self;
}


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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeUI];
    
    [self makeData];
}

- (NSMutableDictionary *)parametersM{

    if (!_parametersM) {
        
        NSDictionary *parameter = @{
                                    KEY_PAGE_S: @0,
                                    KEY_SIZE_S: @20,
                                    KEY_DESC_S: @0,
                                    };

 
        _parametersM =  [NSMutableDictionary dictionaryWithDictionary:parameter];
        
    }
    
   return  _parametersM;
}


- (NSMutableArray *)UniFrames{

    if (!_UniFrames) {
        
        _UniFrames = [NSMutableArray array];
    }
    
    return _UniFrames;
}

- (void)makeUI{
    
    [self makeTableView];
    
    [self makeFilter];
}

- (void)makeData{
    
    //        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary: @{@"text": self.SearchValue,
    //                                                                                           @"page": [NSNumber numberWithInteger:page],
    //                                                                                           @"size": [NSNumber numberWithInteger:PageSize],
    //                                                                                           @"desc": desc,
    //                                                                                           @"order": self.RankType}];
  
    /*
    155733  [APIClient] Request body: {"size":20,"page":0,"order":"ranking_ti","filters":[{"name":"city","value":"伦敦"}],"desc":0,"text":""}
     160753 [APIClient] Request body: {"size":20,"order":"ranking_qs",         "filters":[{"name":"city","value":"伯明翰"}],"desc":0,"page":0}
 */
    
    
    
    XWeakSelf
    [self startAPIRequestWithSelector:kAPISelectorSearch parameters:self.parametersM expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:^{
        
        
    } additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        [weakSelf updateUIWithResponse:response];
        
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        
    }];
    
    
}

- (void)updateUIWithResponse:(id)response{

  
    if (0 == self.nextPage) {
        
        // contentOffset.y 没有上移时，不用回滚到顶部
        if (self.tableView.contentOffset.y > 0) [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        
        // page = 0 时，删除所有数据
        if (self.UniFrames.count > 0) [self.UniFrames removeAllObjects];
        
    }
 
    self.nextPage += 1;
    
    
    NSArray *universities = [UniversityNew mj_objectArrayWithKeyValuesArray:response[@"universities"]];
    

    //当pageSize 大于请请求结果数量时，结束加载网络
    NSNumber *pageSize = [self.parametersM valueForKey:KEY_SIZE_S];
    self.endPage =  (pageSize.integerValue > universities.count);
/*
    count = 396,
	pageCount = 20,
    pageIndex = 17
 */
    
    [universities enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UniversityFrameNew  *uniFrame = [UniversityFrameNew universityFrameWithUniverstiy:(UniversityNew *)obj];
        
        [self.UniFrames addObject:uniFrame];
        
    }];
    
    
    
    [self.tableView reloadData];
}


-(void)makeTableView
{
    self.tableView =[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.contentInset = UIEdgeInsetsMake(50, 0, XNAV_HEIGHT, 0);
}


- (void)makeFilter{
    
    XWeakSelf
    SearchUniCenterFilterVController *filter =[[SearchUniCenterFilterVController alloc] initWithActionBlock:^(NSString *value, NSString *key) {
        
//        [weakSelf reloadWithValue:value key:key];
        
    }];
    
    [self addChildViewController:filter];
    self.filter = filter;
    
    CGFloat base_Height = XNAV_HEIGHT + 50;
    filter.base_Height = base_Height;
    filter.view.frame = CGRectMake(0, 0, XSCREEN_WIDTH, base_Height);
//    filter.areas = self.areas;
    [self.view addSubview:filter.view];
    
    
}


#pragma mark : UITableViewDelegate  UITableViewDataSoure
//超出cell的bounds范围，不能显示
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.clipsToBounds = YES;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    UniversityFrameNew *uniFrame = self.UniFrames[section];
    
    return  uniFrame.universtiy.courses.count > 0 ? 60 : 10;
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    #warning 这里可能修改一下 通过FRAME 设置 cell 高度
    
    return Uni_Cell_Height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UniversityFrameNew *uniFrame = self.UniFrames[indexPath.section];

    NSInteger courseCount = uniFrame.universtiy.courseFrames.count;
    
    if (courseCount > 0 ) {
        
        UniversityCourseFrame *courseFrame = uniFrame.universtiy.courseFrames[indexPath.row];
        
        return  courseFrame.cell_Height;
        
    }else{
    
        return HEIGHT_ZERO;

    }
 
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    XWeakSelf
    
    UniversityFrameNew *uniFrame = self.UniFrames[section];
    
    ApplySectionHeaderView  *sectionView= [ApplySectionHeaderView sectionHeaderViewWithTableView:tableView];
    [sectionView addButtonHiden];
    sectionView.optionOrderBy = [self.parametersM valueForKey:KEY_ORDER_S];
    sectionView.uniFrame = uniFrame;
    sectionView.newActionBlock = ^(NSString *uni_id){
        
        [weakSelf.navigationController pushUniversityViewControllerWithID:uni_id animated:YES];
    };
    
    return sectionView;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    XWeakSelf;
    
    UniversityFrameNew *uniFrame = self.UniFrames[section];
    
    if (uniFrame.universtiy.courses.count > 0) {
        
        searchSectionFootView  *sectionFooter =[[searchSectionFootView alloc] init];
        sectionFooter.uniObj = uniFrame.universtiy;
        sectionFooter.actionBlock = ^(NSString *universityID){
            
            [weakSelf.navigationController pushViewController:[[UniversitySubjectListViewController alloc] initWithUniversityID:universityID] animated:YES];
            
        };
        
        return sectionFooter;
        
    }else{
        
        return nil;
        
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.UniFrames.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    UniversityFrameNew *uniFrame = self.UniFrames[section];
    
    NSInteger courseCount = uniFrame.universtiy.courseFrames.count;
    
    return courseCount > 0 ? courseCount : 1;
}

static NSString *identify = @"search_course";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UniversityCourseCell *cell =[tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        
        cell =[[UniversityCourseCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identify];
    }
    
    UniversityFrameNew *uniFrame = self.UniFrames[indexPath.section];
    
    NSInteger courseCount = uniFrame.universtiy.courseFrames.count;
    
    if (courseCount > 0) {
       
        cell.course_frame = uniFrame.universtiy.courseFrames[indexPath.row];
    }
    
    
    //下拉到最后indexPath.row  下拉加载
    if (indexPath.section == self.UniFrames.count - 1  && !self.endPage) {
        
        [self.parametersM setValue:@(self.nextPage) forKey:KEY_PAGE_S];
        
        [self makeData];
    }

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 

@end
