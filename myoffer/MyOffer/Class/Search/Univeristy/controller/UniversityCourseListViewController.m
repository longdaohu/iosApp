//
//  UniversityCourseListViewController.m
//  myOffer
//
//  Created by xuewuguojie on 16/8/12.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "UniversityCourseListViewController.h"
#import "UniversityCourse.h"
#import "UniversityCourseCell.h"
#import "XuFilerView.h"


@interface UniversityCourseListViewController ()<UITableViewDelegate,UITableViewDataSource,XuFilerViewDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *courseList;
@property(nonatomic,strong)NSMutableArray *selectedcourses;
@property(nonatomic,strong)NSMutableDictionary *parameters;
@property(nonatomic,strong)XuFilerView *filer;
@property(nonatomic,strong)NSArray *groups;
@property(nonatomic,assign)NSInteger nextPage;
@property(nonatomic,strong)UIView   *bottomView;
@property(nonatomic,strong)UILabel  *showLab;
@property(nonatomic,strong)UIButton *submitBtn;

@end

@implementation UniversityCourseListViewController
- (instancetype)initWithUniversityID:(NSString *)ID {
    self = [self init];
    if (self) {
        _universityID = ID;
        
        
        self.parameters = [@{@":id": _universityID, @"page": @0, @"size": @20} mutableCopy];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.title = GDLocalizedString(@"UniCourseDe-001"); //@"课程详情";
    }
    return self;
}

-(NSMutableArray *)courseList{

    if (!_courseList) {
        
        _courseList =[NSMutableArray array];
    }
    return _courseList;
}
-(NSMutableArray *)selectedcourses{
    
    if (!_selectedcourses) {
        
        _selectedcourses =[NSMutableArray array];
    }
    return _selectedcourses;
}

-(NSMutableDictionary *)parameters{
    
    if (!_parameters) {
        
        _parameters =[NSMutableDictionary dictionary];
    }
    return _parameters;
}

-(NSArray *)groups
{
    if (!_groups) {
        
        NSUserDefaults *ud     = [NSUserDefaults standardUserDefaults];
        NSString *subjectKey   = USER_EN ? @"Subject_EN":@"Subject_CN";
        NSArray *subjectes     = [ud valueForKey:subjectKey];
        NSMutableArray  *temps = [[subjectes valueForKeyPath:@"name"] mutableCopy];
        [temps insertObject:GDLocalizedString(@"UniCourseDe-002")  atIndex:0];
        NSArray *subjectArr = [temps copy];
        NSArray *rightArr   = @[GDLocalizedString(@"UniCourseDe-002"),GDLocalizedString(@"UniCourseDe-003"),GDLocalizedString(@"UniCourseDe-004")];
        
        _groups = @[subjectArr ,rightArr];
    }
    return _groups;
}

-(UIView *)bottomView{

    if (!_bottomView) {
        
        CGFloat bottomH = 50;
        CGFloat bottomW = XScreenWidth;
        
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, XScreenHeight - 64 - 50, bottomW, bottomH)];
        
        self.showLab =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, bottomW * 0.5, bottomH)];
        self.showLab.text = @"xxxx";
        self.showLab.textAlignment =  NSTextAlignmentCenter;
        self.showLab.backgroundColor =  XCOLOR_DARKGRAY;
        self.showLab.textColor = XCOLOR_WHITE;
        [_bottomView addSubview:self.showLab];
        
        self.submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(bottomW * 0.5,  0, bottomW * 0.5, bottomH)];
        [self.submitBtn setTitle:@"加入申请意向" forState:UIControlStateNormal];
        self.submitBtn.backgroundColor = XCOLOR_RED;
        [self.submitBtn setTitleColor:XCOLOR_WHITE forState:UIControlStateNormal];
        [self.submitBtn setTitleColor:XCOLOR_LIGHTGRAY forState:UIControlStateHighlighted];
        [self.submitBtn addTarget:self action:@selector(onclick) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:self.submitBtn];
        
        _bottomView.backgroundColor = XCOLOR_RED;
    }
    return _bottomView;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self makeUI];
    
    [self setNewDataSourse];
    
 
}

-(void)makeUI{

    [self makeTableView];
    
    [self makeFilerView];
    
    
    [self.view addSubview:self.bottomView];

}

-(void)makeFilerView{

    
    XuFilerView *filer =[[XuFilerView alloc] init];
    [self addChildViewController:filer];
    
    self.filer       = filer;
    filer.delegate   = self;
    filer.view.frame = CGRectMake(0, 0, XScreenWidth, 0);
    filer.filerRect  = CGRectMake(0, 0, XScreenWidth, 0);
    filer.groups = self.groups;
    
    [self.view addSubview:filer.view];
    
}


-(void)makeTableView
{
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,40, XScreenWidth, XScreenHeight - NAV_HEIGHT - 40) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.mj_footer       = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    

}
-(void)loadMoreData{

  
    [self.parameters setValue:@(self.nextPage) forKey:@"page"];
    
    [self setNewDataSourse];
   
}

-(void)setNewDataSourse{
 
    
    
    [self
     startAPIRequestWithSelector:@"GET api/university/:id/courses"
     parameters:self.parameters
     success:^(NSInteger statusCode, id response) {
         
         if (0 == self.nextPage) {
             
             [self.courseList removeAllObjects];
             
              self.tableView.contentOffset = CGPointMake(0, 0);
         }
         
          ++self.nextPage;
         
         for (NSDictionary *info in response[@"courses"]) {
             
             [self.courseList addObject: [UniversityCourse mj_objectWithKeyValues:info]];
          }
         
         [_tableView reloadData];
         
         
         
         [self.tableView.mj_footer endRefreshing];
         
         if ([self.parameters[@"size"] integerValue] > [response[@"courses"] count]) {
            
             [self.tableView.mj_footer endRefreshingWithNoMoreData];
         }
         
     }];
}



#pragma mark ——— UITableViewDelegate  UITableViewDataSoure
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UniversityCourse *course = self.courseList[indexPath.row];
    
    CGFloat  high = [course.official_name boundingRectWithSize:CGSizeMake(XScreenWidth - 60, 999) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:15.0]  }context:nil].size.height;
    
    return  high > 50 ? 50 + high:100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.courseList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UniversityCourseCell *cell =[UniversityCourseCell cellWithTableView:tableView];

    UniversityCourse *course = self.courseList[indexPath.row];
    
    cell.course = course;
    
    [cell cellDidSelectRowSelected:[self.selectedcourses containsObject:course.NO_id]];
    
    
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UniversityCourseCell *cell =[tableView cellForRowAtIndexPath:indexPath];
    [cell cellDidSelectRowAtIndexPath:indexPath];
    
    
    UniversityCourse *course = self.courseList[indexPath.row];
    if (!course.applied) {
      [self.selectedcourses containsObject:course.NO_id] ? [self.selectedcourses removeObject:course.NO_id] : [self.selectedcourses addObject:course.NO_id];
     }
}


#pragma mark ——— filerViewDelegate
-(void)filerViewItemClick:(FilerButtonItem *)sender
{
    
    
    NSString *key = sender.tag == 11 ? @"level": @"area";
    
    [self.parameters setValue:@0 forKey:@"page"];
    
    
     self.nextPage = 0;
    
    
    if ([sender.titleLab.text isEqualToString:self.groups[0][0]] || [sender.titleLab.text isEqualToString:self.groups[1][0]]) {
        
        [self.parameters removeObjectForKey:key];
        
    } else {
        
        self.parameters [key] =  sender.titleLab.text;
        
    }
    
    [self setNewDataSourse];
    
}

-(void)onclick{

    
}



@end
