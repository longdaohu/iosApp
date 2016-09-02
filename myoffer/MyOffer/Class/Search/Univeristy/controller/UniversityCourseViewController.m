//
//  UniversityCourseViewController.m
//  
//
//  Created by Blankwonder on 6/17/15.
//
//  课程详情



#import "UniversityCourseViewController.h"
#import "UniversityCourseCell.h"
#import "XuFilerView.h"
#import "XWGJnodataView.h"

#define COURSEPAGE @"page课程列表"

@interface UniversityCourseViewController ()<XuFilerViewDelegate> {
   // NSArray *_result;
    
    NSMutableArray *_result;
    NSArray *_subjectOptions, *_levelOptions, *_levelKeyOptions;
    
    NSMutableSet *_selectedIDs, *_newSelectedIDs;
    
    NSMutableDictionary *_resquestParameters;
    int _nextPage;
    BOOL _endPage;
}

 @property (weak, nonatomic) IBOutlet KDEasyTouchButton *summitBtn;
@property(nonatomic,strong)XuFilerView *filer;
@property(nonatomic,strong)NSArray *groups;
@property(nonatomic,strong)XWGJnodataView *NoDataView;

@end

#define kCellIdentifier NSStringFromClass([UniversityCourseCell class])
@implementation UniversityCourseViewController
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


- (instancetype)initWithUniversityID:(NSString *)ID {
    self = [self init];
    if (self) {
        _universityID = ID;
        _selectedIDs = [NSMutableSet set];
        _newSelectedIDs = [NSMutableSet set];

        _resquestParameters = [@{@":id": _universityID, @"page": @0, @"size": @40} mutableCopy];
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.title = GDLocalizedString(@"UniCourseDe-001"); //@"课程详情";
        
    }
    return self;
}

-(NSArray *)groups
{
    if (!_groups) {
        
        NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
        NSString *subjectKey = USER_EN ? @"Subject_EN":@"Subject_CN";
        NSArray *subjectes = [ud valueForKey:subjectKey];
        NSMutableArray  *temps = [[subjectes valueForKeyPath:@"name"] mutableCopy];
        [temps insertObject:GDLocalizedString(@"UniCourseDe-002")  atIndex:0];
         NSArray *subjectArr = [temps copy];
        
        NSArray *rightArr = @[GDLocalizedString(@"UniCourseDe-002"),GDLocalizedString(@"UniCourseDe-003"),GDLocalizedString(@"UniCourseDe-004")];

        _groups = @[subjectArr ,rightArr];
    }
    return _groups;
}


-(XWGJnodataView *)NoDataView
{
    if (!_NoDataView) {
        
        _NoDataView =[XWGJnodataView noDataView];
        _NoDataView.hidden = YES;
        _NoDataView.contentLabel.text = GDLocalizedString(@"Evaluate-noDataSubject");
        
        [self.view insertSubview:_NoDataView aboveSubview:_tableView];
    }
    
    return _NoDataView;
}


-(void)makeUI
{
   
    [self.summitBtn setTitle:GDLocalizedString(@"UniCourseDe-009") forState:UIControlStateNormal];
    _selectedCountLabel.text = [NSString stringWithFormat:@"%@ : 0",GDLocalizedString(@"ApplicationList-003")];
    
    [_tableView registerNib:[UINib nibWithNibName:kCellIdentifier bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    _tableView.tableFooterView =[[UIView alloc] init];
    
    [self makeTopView];
    
}

-(void)makeTopView
{
  
    XuFilerView *filer =[[XuFilerView alloc] init];
    [self addChildViewController:filer];
    self.filer = filer;
    filer.delegate = self;
    filer.view.frame = CGRectMake(0, 0, XScreenWidth, 0);
    filer.filerRect = CGRectMake(0, 0, XScreenWidth, 0);
    filer.groups = self.groups;
    
    [self.view addSubview:filer.view];

}


 - (void)viewDidLoad {
   
     [super viewDidLoad];
   
     
     [self makeUI];
     
     
    [self reloadData];
}

- (void)reloadData {
    
    [self
     startAPIRequestWithSelector:@"GET api/university/:id/courses"
     parameters:_resquestParameters
     success:^(NSInteger statusCode, id response) {
      
         for (NSDictionary *info in response[@"courses"]) {
             
            BOOL applied = [info[@"applied"] boolValue];
            
            if (applied)  {
         
                [_selectedIDs addObject:info[@"_id"]];
            }
        }
         
         NSLog(@"courses---courses- %@",response[@"courses"]);
         
           _result = [response[@"courses"] mutableCopy];
         
         if (_result.count<40) {
             
             _endPage = YES;
         }
         else
         {
             _endPage = NO;
         }
         
         
          self.NoDataView.hidden = !(_result.count == 0);
         
          [_tableView reloadData];
    }];
}


#pragma mark ———————— UItableViewData uitableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSDictionary *info = _result[indexPath.row];

    CGFloat  high = [info[@"official_name"] boundingRectWithSize:CGSizeMake(XScreenWidth - 60, 999) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:15.0]  }context:nil].size.height;

     return  high > 50 ? 50 + high:100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    return _result.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    NSDictionary *info = _result[indexPath.row];
    
    UniversityCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.info =  info;
    
    
    [self configureCellSelectionView:cell id:info[@"_id"]];
    
    if (indexPath.row == _result.count-1 && !_endPage) {
        
        _nextPage = ++_nextPage;
        
        [_resquestParameters setValue:@(_nextPage) forKey:@"page"];
        
        [self loadMoreData];
     }
    
    
    return cell;
}

-(void)loadMoreData
{
  
     [self
     startAPIRequestWithSelector:@"GET api/university/:id/courses"
     parameters:_resquestParameters
     success:^(NSInteger statusCode, id response) {
         for (NSDictionary *info in response[@"courses"]) {
             BOOL applied = [info[@"applied"] boolValue];
             
             if (applied)  {
                 [_selectedIDs addObject:info[@"_id"]];
             }
         }
         NSArray  *moreResultArray = response[@"courses"];
         
  
             for (NSDictionary *test in moreResultArray) {
                 [_result addObject:test];

                 
             }
         if (moreResultArray.count >= 40) {
             
             _endPage = NO;
         }
      
         if (moreResultArray.count < 40) {
            
             _endPage = YES;
         }
         
          [_tableView reloadData];
     }];

 
}


- (void)configureCellSelectionView:(UniversityCourseCell *)cell id:(NSString *)id {
    if ([_selectedIDs containsObject:id]) {// @"已添加"
        [cell.selectionView setTitle:GDLocalizedString(@"UniCourseDe-007")  forState:UIControlStateNormal];
        [cell.selectionView setImage:nil forState:UIControlStateNormal];
    } else if ([_newSelectedIDs containsObject:id]) {
        [cell.selectionView setTitle:nil forState:UIControlStateNormal];
        [cell.selectionView setImage:[UIImage imageNamed:@"check-icons-yes"] forState:UIControlStateNormal];
      } else {
        [cell.selectionView setTitle:nil forState:UIControlStateNormal];
        [cell.selectionView setImage:[UIImage imageNamed:@"check-icons"] forState:UIControlStateNormal];
     }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSDictionary *info = _result[indexPath.row];
    NSString *id = info[@"_id"];
    
    if ([_selectedIDs containsObject:id]) {
        return;
    }
    if ([_newSelectedIDs containsObject:id]) {
        [_newSelectedIDs removeObject:id];
    } else {
        [_newSelectedIDs addObject:id];
    }
    
    UniversityCourseCell *cell = (UniversityCourseCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self configureCellSelectionView:cell id:id];
    //已选择:
    _selectedCountLabel.text = [NSString stringWithFormat:@"%@：%d", GDLocalizedString(@"ApplicationList-003"),(int)_newSelectedIDs.count];
}


- (IBAction)addSelectedCourse {
    
 
    RequireLogin
    
    if (_newSelectedIDs.count == 0) {
        //@"你尚未选择任何课程"  
         AlerMessage(GDLocalizedString(@"UniCourseDe-008") );
        
        return;
    }
    
    [self
     startAPIRequestWithSelector:@"POST api/account/apply"
     parameters:@{@"id": _newSelectedIDs.allObjects}
     success:^(NSInteger statusCode, id response) {
         KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:self.view animated:NO];
         [hud applySuccessStyle];
         [hud setLabelText:GDLocalizedString(@"ApplicationProfile-0015")];//@"加入成功"];
         [hud hideAnimated:YES afterDelay:2];
         [hud setHiddenBlock:^(KDProgressHUD *hud) {
             [self dismiss];
         }];
     }];
    
}



-(void)filerViewItemClick:(FilerButtonItem *)sender
{
    
    
    NSString *key = sender.tag == 11 ? @"level": @"area";
    
    [_resquestParameters setValue:@0 forKey:@"page"];
    
    
    _nextPage = 0;
    
    
    
    if ([sender.titleLab.text isEqualToString:self.groups[0][0]] || [sender.titleLab.text isEqualToString:self.groups[1][0]]) {
        
        [_resquestParameters removeObjectForKey:key];
        
    } else {
        
        _resquestParameters[key] =  sender.titleLab.text;
        
    }
    
    
    [_result removeAllObjects];
    
    [self reloadData];
    
}



@end
