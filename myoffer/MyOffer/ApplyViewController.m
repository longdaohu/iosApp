//
//  ApplyViewController.m
//  MyOffer
//
//  Created by Blankwonder on 6/20/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import "ApplyViewController.h"
#import "SearchResultCell.h"
#import "AgreementViewController.h"
#import "SubmitViewController.h"

@interface ApplyViewController () {
    NSArray *_waitingCells, *_submittedCells;
    NSArray *_info;
    
    NSMutableSet *_selectedIDs;
    NSArray *_courseInfos;
}

@end

@implementation ApplyViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if ([_waitingTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_waitingTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([_submittedTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_submittedTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
//    _waitingTableView.contentInset = UIEdgeInsetsMake(-20, 0, 50, 0);
//    _submittedTableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    
    _waitingTableView.tableFooterView = [[UIView alloc] init];
    _submittedTableView.tableFooterView = [[UIView alloc] init];

    
    self.title = @"申请意向";
    
    _submittedButton.adjustAllRectWhenHighlighted = YES;
    _waitingButton.adjustAllRectWhenHighlighted = YES;
    
    [self reloadData];
}

- (void)reloadData {
    [self startAPIRequestWithSelector:@"GET api/account/applies" parameters:nil success:^(NSInteger statusCode, NSArray *response) {
        _info = response;
        
        NSMutableArray *courseInfos = [NSMutableArray array];
        
        _selectedIDs = [NSMutableSet set];
        
        _waitingCells = [response KD_arrayUsingMapEnumerateBlock:^id(id obj, NSUInteger idx) {
            SearchResultCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SearchResultCell class]) owner:nil options:nil][0];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell configureWithInfo:obj];
            
            NSArray *courses = [obj[@"applies"] KD_arrayUsingMapEnumerateBlock:^id(id obj, NSUInteger idx) {
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
                
                cell.textLabel.text = obj[@"name"] ?: obj[@"official_name"];
                cell.detailTextLabel.text = obj[@"subject"];
                
                cell.textLabel.font = [UIFont systemFontOfSize:14];
                cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
                
                cell.accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
                [(UIImageView *)cell.accessoryView setContentMode:UIViewContentModeCenter];
                [(UIImageView *)cell.accessoryView setImage:[UIImage imageNamed:@"check-icons-yes"]];
                
                cell.tag = courseInfos.count;
                
                [courseInfos addObject:obj];
                [_selectedIDs addObject:obj[@"_id"]];
                
                return cell;
            }];
            
            NSMutableArray *cells = [NSMutableArray arrayWithObject:cell];
            [cells addObjectsFromArray:courses];
            
            return cells;
        }];
        
        _courseInfos = courseInfos;
        [self configureSelectAllButton];
        
        [_waitingTableView reloadData];
        _waitingCountLabel.text = [NSString stringWithFormat:@"%d", (int)courseInfos.count];
    }];
    
    [self startAPIRequestWithSelector:@"GET api/account/checklist" parameters:nil success:^(NSInteger statusCode, id response) {
        __block int count = 0;
        _submittedCells = [response KD_arrayUsingMapEnumerateBlock:^id(id obj, NSUInteger idx) {
            SearchResultCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SearchResultCell class]) owner:nil options:nil][0];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell configureWithInfo:obj];
            
            NSArray *courses = [obj[@"applications"] KD_arrayUsingMapEnumerateBlock:^id(id obj, NSUInteger idx) {
                UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
                
                cell.textLabel.text = obj[@"name"] ?: obj[@"official_name"];
                cell.detailTextLabel.text = obj[@"stateText"];
                
                cell.textLabel.font = [UIFont systemFontOfSize:14];
                cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
                
                count++;
                
                return cell;
            }];
            
            NSMutableArray *cells = [NSMutableArray arrayWithObject:cell];
            [cells addObjectsFromArray:courses];
            
            return cells;
        }];
        
        [_submittedTableView reloadData];
        
        _submitedCountLabel.text = [NSString stringWithFormat:@"%d", count];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return tableView == _waitingTableView ? _waitingCells.count : _submittedCells.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableView == _waitingTableView ? [_waitingCells[section] count] : [_submittedCells[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView == _waitingTableView ? _waitingCells[indexPath.section][indexPath.row] : _submittedCells[indexPath.section][indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView == _waitingTableView ? [_waitingCells[indexPath.section][indexPath.row] frame].size.height : [_submittedCells[indexPath.section][indexPath.row] frame].size.height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (IBAction)applyButtonPressed {
    if (_selectedIDs.count == 0) {
        [KDAlertView showMessage:@"请至少选择一门课程" cancelButtonTitle:@"好的"];
        return;
    }
    
    if (![UserDefaults sharedDefault].agreementAccepted.boolValue) {
        AgreementViewController *vc = [[AgreementViewController alloc] init];
        [vc setDismissCompletion:^(BaseViewController *vc) {
            [UserDefaults sharedDefault].agreementAccepted = @YES;
            [self applyButtonPressed];
        }];
        
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nvc animated:YES completion:^{}];
        
        return;
    }
    
    SubmitViewController *vc = [[SubmitViewController alloc] initWithApplyInfo:_info selectedIDs:_selectedIDs];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)waitingButton {
    _waitingView.hidden = NO;
    _submittedView.hidden = YES;
}

- (IBAction)submittedButton {
    _waitingView.hidden = YES;
    _submittedView.hidden = NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _waitingTableView && indexPath.row > 0) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        int index = (int)cell.tag;
        
        NSDictionary *info = _courseInfos[index];
        NSString *id = info[@"_id"];
        
        if ([_selectedIDs containsObject:id]) {
            [_selectedIDs removeObject:id];
            [(UIImageView *)cell.accessoryView setImage:[UIImage imageNamed:@"check-icons"]];
        } else {
            [_selectedIDs addObject:id];
            [(UIImageView *)cell.accessoryView setImage:[UIImage imageNamed:@"check-icons-yes"]];
        }
        [self configureSelectAllButton];
    }
}

- (void)reconfigureWaittingCells {
    for (NSArray *cells in _waitingCells) {
        for (int i = 1; i < cells.count; i++) {
            UITableViewCell *cell = cells[i];
            NSDictionary *info = _courseInfos[cell.tag];
            NSString *id = info[@"_id"];

            if ([_selectedIDs containsObject:id]) {
                [(UIImageView *)cell.accessoryView setImage:[UIImage imageNamed:@"check-icons-yes"]];
            } else {
                [(UIImageView *)cell.accessoryView setImage:[UIImage imageNamed:@"check-icons"]];
            }
        }
    }
}

- (IBAction)selectAllButtonPressed {
    if (_courseInfos.count != _selectedIDs.count) {
        for (NSDictionary *info in _courseInfos) {
            NSString *id = info[@"_id"];
            [_selectedIDs addObject:id];
        }
    } else {
        [_selectedIDs removeAllObjects];
    }
    
    [self configureSelectAllButton];
    [self reconfigureWaittingCells];
}

- (void)configureSelectAllButton {
    if (_courseInfos.count != _selectedIDs.count) {
        _selectAllButton.selected = NO;
    } else {
        _selectAllButton.selected = YES;
    }
    
    _selectCountLabel.text = [NSString stringWithFormat:@"已选择：%d个\n共：%d个", (int)_selectedIDs.count, (int)_courseInfos.count];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        int index = (int)cell.tag;
        
        NSDictionary *info = _courseInfos[index];
        NSString *courseID = info[@"course_id"];
        
        [self startAPIRequestWithSelector:@"GET api/account/unapply/:id" parameters:@{@":id": courseID} success:^(NSInteger statusCode, id response) {
            [self reloadData];
        }];
    }
}

-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
