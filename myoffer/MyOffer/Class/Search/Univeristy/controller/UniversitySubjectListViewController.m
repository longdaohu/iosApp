//
//  UniversitySubjectListViewController.m
//  MyOffer
//
//  Created by xuewuguojie on 2017/4/21.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "UniversitySubjectListViewController.h"
#import "UniversityCourse.h"
#import "UniversityCourseFrame.h"
#import "UniversityCourseCell.h"
#import "UniversityCourseFooterView.h"
#import "UniversityCourseFilterViewController.h"

@interface UniversitySubjectListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableDictionary *resquestParameters;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *course_frames;
@property(nonatomic,strong)NSMutableArray *selected_items;
@property(nonatomic,assign)NSInteger nextPage;
@property(nonatomic,assign)BOOL endPage;
@property(nonatomic,strong)UniversityCourseFooterView *footer;
@property(nonatomic,strong)UniversityCourseFilterViewController *filter;
@property(nonatomic,strong)NSArray *groups;
@end

@implementation UniversitySubjectListViewController

#define COURSEPAGE @"page课程列表"

- (instancetype)initWithUniversityID:(NSString *)ID {
    self = [self init];
    if (self) {
        _universityID = ID;
//        _selectedIDs = [NSMutableSet set];
//        _newSelectedIDs = [NSMutableSet set];
        self.resquestParameters = [@{@":id": _universityID, @"page": @0, @"size": @40} mutableCopy];
//        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.title = @"课程详情";
        
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:COURSEPAGE];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:COURSEPAGE];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
    
    [self makeDataSource];
}


- (void)makeUI{

    [self makeTableView];
    
    [self makeFooter];
    
    [self makeFilter];

    
}

- (void)makeTableView
{
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, XSCREEN_HEIGHT - XNAV_HEIGHT - 50) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
    self.tableView.backgroundColor = XCOLOR_BG;
    [self.view addSubview:self.tableView];
    
}

- (void)makeFilter{

    XWeakSelf
    
    UniversityCourseFilterViewController *filter =[[UniversityCourseFilterViewController alloc] initWithActionBlock:^(NSString *value, NSString *key) {
        
        [weakSelf reloadWithValue:value key:key];

    }];
    
    [self addChildViewController:filter];
    self.filter = filter;
    
    CGFloat base_Height = XNAV_HEIGHT + 50;
    filter.base_Height = base_Height;
    filter.view.frame = CGRectMake(0, 0, XSCREEN_WIDTH, base_Height);
    filter.areas = self.groups;
    [self.view addSubview:filter.view];
 
 
}

- (void)reloadWithValue:(NSString *)value key:(NSString *)key{

    
    self.nextPage = 0;
    
    [_resquestParameters setValue:@(self.nextPage) forKey:@"page"];
    [_resquestParameters setValue:value forKey:key];
    
    [self makeDataSource];

}

- (void)makeFooter{

    CGFloat footer_Height = 70;
    
    UniversityCourseFooterView *footer = [[UniversityCourseFooterView alloc] initWithFrame:CGRectMake(0, XSCREEN_HEIGHT - footer_Height - XNAV_HEIGHT, XSCREEN_WIDTH, footer_Height)];
    
    [self.view addSubview:footer];
    self.footer = footer;
    
    XWeakSelf;
    
    footer.actionBlock = ^{
        
        [weakSelf caseSubmit];//提交数据
        
    };
    
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0,footer_Height, 0);

}



- (NSMutableArray *)course_frames{

    if (!_course_frames) {
        
        _course_frames = [NSMutableArray array];
    }
    
    return _course_frames;
}


- (NSMutableArray *)selected_items{
    
    if (!_selected_items) {
        
        _selected_items = [NSMutableArray array];
    }
    
    return _selected_items;
}

-(NSArray *)groups
{
    if (!_groups) {
        
        NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
        NSArray *subjectes = [ud valueForKey:@"Subject_CN"];
        NSMutableArray  *temps = [[subjectes valueForKeyPath:@"name"] mutableCopy];
        [temps insertObject:@"全部"  atIndex:0];

        _groups = [temps copy];
    }
    
    return _groups;
}



- (void)makeDataSource{
    
    XWeakSelf
    [self
     startAPIRequestWithSelector:kAPISelectorUniversityCourses
     parameters:_resquestParameters
     success:^(NSInteger statusCode, id response) {
         
         [weakSelf updateUIWithResponse:response];
         
      }];
    
}


- (void)updateUIWithResponse:(id)response{

    
    
    if (0 == self.nextPage) {
        
        // contentOffset.y 没有上移时，不用回滚到顶部
        if (self.tableView.contentOffset.y > 0) [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        
        // page = 0 时，删除所有数据
        if (self.course_frames.count > 0) [self.course_frames removeAllObjects];

        
        // page = 0 时，删除所有选择项
        if (self.selected_items.count > 0) {
            
            [self.selected_items removeAllObjects];
            
            [self updateFooterViewSelectedCourse:self.selected_items.count];
        }
        
        
     }
    
    
    NSNumber *pageCount  = response[@"pageCount"];
    
    self.endPage =  (self.nextPage == pageCount.integerValue);
    
    self.nextPage += 1;
    
    NSArray *courses = [UniversityCourse mj_objectArrayWithKeyValuesArray:response[@"courses"]];
    
    for (UniversityCourse *course in courses) {
  
        UniversityCourseFrame *courseFrame = [UniversityCourseFrame frameWithCourse:course];
        
        [self.course_frames addObject:courseFrame];
        
    }
    
    [self.tableView reloadData];

}


#pragma mark :  UITableViewDelegate,UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UniversityCourseFrame *courseFrame = self.course_frames[indexPath.row];
    
    return  courseFrame.cell_Height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.course_frames.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UniversityCourseCell *cell = [UniversityCourseCell cellWithTableView:tableView];
    
    cell.course_frame =  self.course_frames[indexPath.row];
    
    
    //下拉到最后indexPath.row  下拉加载
    if (indexPath.row == self.course_frames.count - 1  && !self.endPage) {
        
        [self.resquestParameters setValue:@(self.nextPage) forKey:@"page"];
        
        [self makeDataSource];
    }
    
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UniversityCourseFrame *courseFrame = self.course_frames[indexPath.row];
    
    //已提交的专业不能再被选择
    if (courseFrame.course.applied) return;
        
    
    if ([self.selected_items containsObject:courseFrame.course.course_id]) {
        
        [self.selected_items removeObject:courseFrame.course.course_id];

    }else{
        
        //超过6个不能再选择
        if (self.selected_items.count == 6) return;
        
        [self.selected_items addObject:courseFrame.course.course_id];
    }
    
    //更新footer显示样式
    [self updateFooterViewSelectedCourse:self.selected_items.count];
    
    //更新cell选择样式
    UniversityCourseCell *cell = (UniversityCourseCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell cellDidSelectRowAtIndexPath:indexPath];
        
  
    
}

- (void)updateFooterViewSelectedCourse:(NSInteger)count{

     self.footer.count = count;
  
}


- (void)caseSubmit{

    
    RequireLogin
    
    [self
     startAPIRequestWithSelector:@"POST api/account/apply"
     parameters:@{@"id":self.selected_items}
     success:^(NSInteger statusCode, id response) {
        
         KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
         [hud applySuccessStyle];
         [hud setLabelText:@"加入成功"];
         [hud hideAnimated:YES afterDelay:2];
         [hud setHiddenBlock:^(KDProgressHUD *hud) {
             
             [self dismiss];
             
         }];
     }];
 
    
}


-(void)dealloc{

    KDClassLog(@" 课程详情 dealloc");

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
