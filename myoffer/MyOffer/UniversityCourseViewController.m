//
//  UniversityCourseViewController.m
//  
//
//  Created by Blankwonder on 6/17/15.
//
//  课程列表页面



#import "UniversityCourseViewController.h"
#import "UniversityCourseCell.h"

@interface UniversityCourseViewController () {
   // NSArray *_result;
    
    NSMutableArray *_result;
    NSArray *_subjectOptions, *_levelOptions, *_levelKeyOptions;
    
    NSMutableSet *_selectedIDs, *_newSelectedIDs;
    
    NSMutableDictionary *_resquestParameters;
    int _nextPage;
    BOOL _endPage;
}
 @property (weak, nonatomic) IBOutlet KDEasyTouchButton *summitBtn;



@end

#define kCellIdentifier NSStringFromClass([UniversityCourseCell class])

@implementation UniversityCourseViewController

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
 - (void)viewDidLoad {
    [super viewDidLoad];
    [self.summitBtn setTitle:GDLocalizedString(@"UniCourseDe-009") forState:UIControlStateNormal];
    [_tableView registerNib:[UINib nibWithNibName:kCellIdentifier bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    
    NSString *lan =[InternationalControl userLanguage];
    NSString *localLan = nil;
    if ([lan containsString:@"en"]) {
        
        localLan = @"en";
        
    }else
    {
        localLan = @"zh-cn";
    }
    
    [self
     startAPIRequestUsingCacheWithSelector:kAPISelectorSubjects
     parameters:@{@":lang": localLan}
     success:^(NSInteger statusCode, NSArray *response) {
        
         //专业类型数组
         NSMutableArray *subjectOptions = [[response KD_arrayUsingMapEnumerateBlock:^id(NSDictionary *obj, NSUInteger idx) {
           
             return obj[@"name"];
         }] mutableCopy];

         
         [subjectOptions insertObject:GDLocalizedString(@"UniCourseDe-002")  atIndex:0];//@"全部" atIndex:0];
         
         _subjectOptions = subjectOptions;
        
         _levelOptions = @[GDLocalizedString(@"UniCourseDe-002"),GDLocalizedString(@"UniCourseDe-003"),GDLocalizedString(@"UniCourseDe-004")];   //@[@"全部", @"本科", @"硕士"];
         //  _levelKeyOptions = @[@"All", @"Undergraduate", @"Graduate"];
         //   _levelKeyOptions = @[@"All", @"本科", @"硕士"];
        
         _filterView.items = @[GDLocalizedString(@"UniCourseDe-005"),GDLocalizedString(@"UniCourseDe-006")]; // @[@"专业方向", @"学位类型"];
         
   
      }];
    
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
         
           _result = [response[@"courses"] mutableCopy];
         
         if (_result.count<40) {
             _endPage = YES;
         }
         else
         {
             _endPage = NO;
         }
         
          [_tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _result.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *info = _result[indexPath.row];
    
    UniversityCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    cell.titleLabel.text = info[@"name"];
    
    cell.subtitleLabel.text = info[@"official_name"];
    //  "专业方向";   "学位类型";
    NSLog(@"cell.detailLabel1cell.detailLabel1 = %@ ",info[@"level"]);
    cell.detailLabel1.text  = [NSString stringWithFormat:@"%@：%@",GDLocalizedString(@"UniCourseDe-006"),info[@"level"]];
    cell.detailLabel2.text = [NSString stringWithFormat:@"%@：%@",GDLocalizedString(@"UniCourseDe-005"), [info[@"areas"] componentsJoinedByString:@","]];
    
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
  
    //_resquestParameters = [@{@":id": _universityID, @"page": @(_nextPage), @"size": @40} mutableCopy];
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
    if (_newSelectedIDs.count == 0) {
        //@"你尚未选择任何课程"  
        [KDAlertView showMessage: GDLocalizedString(@"UniCourseDe-008")  cancelButtonTitle:GDLocalizedString(@"Evaluate-0016")]; //@"好的"];
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

- (NSArray *)filterView:(FilterView *)filterView subtypesForItemAtIndex:(NSInteger)index {
   
    return index == 0 ? _subjectOptions : _levelOptions;
}

- (void)filterView:(FilterView *)filterView didSelectItemAtIndex:(NSInteger)index subtypeIndex:(NSInteger)subtypeIndex {
   
    
    NSString *key = index == 0 ? @"area" : @"level";
    
    [_resquestParameters setValue:@0 forKey:@"page"];
    _nextPage = 0;
    
    if (subtypeIndex != 0) {
        _resquestParameters[key] = index == 0 ? _subjectOptions[subtypeIndex] : _levelOptions[subtypeIndex];
    } else {
        [_resquestParameters removeObjectForKey:key];
    }
    
    [_result removeAllObjects];
    
    [self reloadData];
}



@end
