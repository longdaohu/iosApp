//
//  UniversityCourseViewController.m
//  
//
//  Created by Blankwonder on 6/17/15.
//
//

#import "UniversityCourseViewController.h"
#import "UniversityCourseCell.h"

@interface UniversityCourseViewController () {
    NSArray *_result;
    NSArray *_subjectOptions, *_levelOptions, *_levelKeyOptions;
    
    NSMutableSet *_selectedIDs, *_newSelectedIDs;
    
    NSMutableDictionary *_resquestParameters;
}

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
        
        self.title = @"课程详情";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [_tableView registerNib:[UINib nibWithNibName:kCellIdentifier bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    
    [self
     startAPIRequestUsingCacheWithSelector:kAPISelectorSubjects
     parameters:@{@":lang": @"zh-cn"}
     success:^(NSInteger statusCode, NSArray *response) {
         NSMutableArray *subjectOptions = [[response KD_arrayUsingMapEnumerateBlock:^id(NSDictionary *obj, NSUInteger idx) {
             return obj[@"name"];
         }] mutableCopy];
         
         [subjectOptions insertObject:@"全部" atIndex:0];
         
         _subjectOptions = subjectOptions;
         _levelOptions = @[@"全部", @"本科", @"研究生"];
         _levelKeyOptions = @[@"All", @"Undergraduate", @"Graduate"];
         _filterView.items = @[@"专业方向", @"学位类型"];
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
        
        _result = response[@"courses"];
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
    
    cell.detailLabel1.text = [NSString stringWithFormat:@"学位类型：%@", info[@"level"]];
    cell.detailLabel2.text = [NSString stringWithFormat:@"专业方向：%@", [info[@"areas"] componentsJoinedByString:@","]];
    
    [self configureCellSelectionView:cell id:info[@"_id"]];
    
    return cell;
}

- (void)configureCellSelectionView:(UniversityCourseCell *)cell id:(NSString *)id {
    if ([_selectedIDs containsObject:id]) {
        [cell.selectionView setTitle:@"已添加" forState:UIControlStateNormal];
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
    
    _selectedCountLabel.text = [NSString stringWithFormat:@"已选择：%d个", (int)_newSelectedIDs.count];
}


- (IBAction)addSelectedCourse {
    if (_newSelectedIDs.count == 0) {
        [KDAlertView showMessage:@"你尚未选择任何课程" cancelButtonTitle:@"好的"];
        return;
    }
    
    [self
     startAPIRequestWithSelector:@"POST api/account/apply"
     parameters:@{@"id": _newSelectedIDs.allObjects}
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

- (NSArray *)filterView:(FilterView *)filterView subtypesForItemAtIndex:(NSInteger)index {
    return index == 0 ? _subjectOptions : _levelOptions;
}

- (void)filterView:(FilterView *)filterView didSelectItemAtIndex:(NSInteger)index subtypeIndex:(NSInteger)subtypeIndex {
    NSString *key = index == 0 ? @"area" : @"level";
    if (subtypeIndex != 0) {
        _resquestParameters[key] = index == 0 ? _subjectOptions[subtypeIndex] : _levelKeyOptions[subtypeIndex];
    } else {
        [_resquestParameters removeObjectForKey:key];
    }
    [self reloadData];
}


@end
