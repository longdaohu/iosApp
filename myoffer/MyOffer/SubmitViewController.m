//
//  SubmitViewController.m
//  MyOffer
//
//  Created by Blankwonder on 6/22/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import "SubmitViewController.h"
#import "SearchResultCell.h"
#import "FilePickerViewController.h"

@interface SubmitViewController () {
    NSArray *_info;
    NSArray *_cells;
    
    NSArray *_oiList;
    NSArray *_psList;
    NSArray *_rlList;
    
    NSArray *_selectedIDs;
    
    NSSet *_selectedCourseIDs;
}

@end

@implementation SubmitViewController

- (instancetype)initWithApplyInfo:(NSArray *)info selectedIDs:(NSSet *)ids {
    self = [self init];
    if (self) {
        _info = info;
        _selectedCourseIDs = ids;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择申请文件";
        
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    NSMutableArray *sections = [NSMutableArray array];
    NSMutableArray *selectedIDs = [NSMutableArray array];
    _selectedIDs = selectedIDs;
    
    [_info enumerateObjectsUsingBlock:^(id uobj, NSUInteger idx, BOOL *stop) {
        
        [uobj[@"applies"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (![_selectedCourseIDs containsObject:obj[@"_id"]]) {
                return;
            }
            
            NSMutableArray *cells = [NSMutableArray array];

            SearchResultCell *ucell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SearchResultCell class]) owner:nil options:nil][0];
            ucell.accessoryType = UITableViewCellAccessoryNone;
            ucell.selectionStyle = UITableViewCellSelectionStyleNone;
            [ucell configureWithInfo:uobj];
            
            UITableViewCell *ccell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            
            ccell.textLabel.text = obj[@"name"];
            ccell.detailTextLabel.text = obj[@"subject"];
            ccell.selectionStyle = UITableViewCellSelectionStyleNone;
            [ccell KD_setFrameSizeHeight:30];
            ccell.textLabel.font = [UIFont boldSystemFontOfSize:14];
            ccell.detailTextLabel.font = [UIFont boldSystemFontOfSize:14];

            [cells addObject:ucell];
            [cells addObject:ccell];
            
            UITableViewCell *pscell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            pscell.textLabel.text = @"个人陈述";
            pscell.textLabel.font = [UIFont systemFontOfSize:14];
            pscell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            pscell.detailTextLabel.textColor = [UIColor KD_colorWithCode:0xffED2E7C];
            pscell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            UITableViewCell *rlcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            rlcell.textLabel.text = @"推荐信1";
            rlcell.textLabel.font = [UIFont systemFontOfSize:14];
            rlcell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            rlcell.detailTextLabel.textColor = [UIColor KD_colorWithCode:0xffED2E7C];
            rlcell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            UITableViewCell *rlcell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            rlcell2.textLabel.text = @"推荐信2";
            rlcell2.textLabel.font = [UIFont systemFontOfSize:14];
            rlcell2.detailTextLabel.font = [UIFont systemFontOfSize:14];
            rlcell2.detailTextLabel.textColor = [UIColor KD_colorWithCode:0xffED2E7C];
            rlcell2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            
            UITableViewCell *otcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            otcell.textLabel.text = @"其他文档";
            otcell.textLabel.font = [UIFont systemFontOfSize:14];
            otcell.detailTextLabel.font = [UIFont systemFontOfSize:14];
            otcell.detailTextLabel.textColor = [UIColor KD_colorWithCode:0xffED2E7C];
            otcell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            [cells addObject:pscell];
            [cells addObject:rlcell];
            [cells addObject:rlcell2];
            [cells addObject:otcell];
            
            [sections addObject:cells];
            
            NSMutableSet *set1 = [NSMutableSet set];
            NSMutableSet *set2 = [NSMutableSet set];
            NSMutableSet *set3 = [NSMutableSet set];
            NSMutableSet *set4 = [NSMutableSet set];

            [selectedIDs addObject:@[set1, set2, set3, set4]];
        }];
        
    }];
    
    _cells = sections;
    [_tableView reloadData];
    
    [self startAPIRequestWithSelector:@"GET api/account/docs" parameters:nil success:^(NSInteger statusCode, id response) {
        KDClassLog(@"%@", response);
        
        _oiList = response[@"oiList"];
        _psList = response[@"psList"];
        _rlList = response[@"rlList"];
        
        for (NSDictionary *info in _oiList) {
            [_selectedIDs enumerateObjectsUsingBlock:^(NSArray *obj, NSUInteger idx, BOOL *stop) {
                NSMutableSet *set = obj[3];
                [set addObject:info[@"title"]];
            }];
        }

        [self reconfigureCells];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reconfigureCells];
}

- (void)reconfigureCells {
    [_cells enumerateObjectsUsingBlock:^(NSArray *cells, NSUInteger idx, BOOL *stop) {
        for (int i = 2; i < cells.count; i++) {
            UITableViewCell *cell = cells[i];
            NSSet *idSet = _selectedIDs[idx][i - 2];
            
            if (idSet.count == 0) {
                cell.detailTextLabel.text = nil;
            } else if (idSet.count == 1) {
                cell.detailTextLabel.text = idSet.anyObject;
            } else {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"已选择%d项文档", (int)idSet.count];
            }
        }
    }];
    [_tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _cells.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_cells[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _cells[indexPath.section][indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_cells[indexPath.section][indexPath.row] frame].size.height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.row == 0 || indexPath.row == 1) ? nil : indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FilePickerViewController *vc;
    
    NSArray *idSets = _selectedIDs[indexPath.section];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row == 5) {
        vc = [[FilePickerViewController alloc] initWithFiles:_oiList allowMultipleSelection:YES selectedIDSet:idSets[3]];
    } else if (indexPath.row == 4) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *obj in _rlList) {
            if (![idSets[1] containsObject:obj[@"doc_title"]]) {
                [array addObject:obj];
            }
        }
        vc = [[FilePickerViewController alloc] initWithFiles:array allowMultipleSelection:NO selectedIDSet:idSets[2]];
    } else if (indexPath.row == 3) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *obj in _rlList) {
            if (![idSets[2] containsObject:obj[@"doc_title"]]) {
                [array addObject:obj];
            }
        }
        vc = [[FilePickerViewController alloc] initWithFiles:array allowMultipleSelection:NO selectedIDSet:idSets[1]];
    } else if (indexPath.row == 2) {
        vc = [[FilePickerViewController alloc] initWithFiles:_psList allowMultipleSelection:NO selectedIDSet:idSets[0]];
    }
    
    vc.title = cell.textLabel.text;
    vc.userInfo = indexPath;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)submit {
    __block BOOL shouldReturn;
    [_selectedIDs enumerateObjectsUsingBlock:^(NSArray *sets, NSUInteger idx1, BOOL *stop1) {
        [sets enumerateObjectsUsingBlock:^(NSSet *set, NSUInteger idx2, BOOL *stop2) {
            if (set.count == 0) {
                NSArray *title = @[@"个人陈述", @"推荐信", @"推荐信", @"其他文档"];
                
                [KDAlertView showMessage:[NSString stringWithFormat:@"请选择%@", title[idx2]]
                       cancelButtonTitle:@"好的"];
                
                shouldReturn = YES;
                *stop1 = YES;
                *stop2 = YES;
            }
        }];
    }];
    
    if (shouldReturn) {
        return;
    }
    
    
    NSMutableArray *datas = [NSMutableArray array];
    __block int index = 0;
    [_info enumerateObjectsUsingBlock:^(id uobj, NSUInteger idx, BOOL *stop) {
        [uobj[@"applies"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (![_selectedCourseIDs containsObject:obj[@"_id"]]) {
                return;
            }
            NSArray *sets = _selectedIDs[index];
            index++;
            
            NSDictionary *payload = @{@"courseId": obj[@"course_id"],
                                      @"ps_name": [sets[0] anyObject],
                                          @"rl_name_list":@[[sets[1] anyObject], [sets[2] anyObject]],
                                      @"ou_name_list":[sets[0] allObjects]};
            [datas addObject:payload];
        }];
    }];

    [self startAPIRequestWithSelector:@"POST api/account/checkin" parameters:@{@"checkInData": datas} success:^(NSInteger statusCode, id response) {
        KDProgressHUD *hud = [KDProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud applySuccessStyle];
        [hud hideAnimated:YES afterDelay:2];
        [hud setHiddenBlock:^(KDProgressHUD *hud) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }];
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
