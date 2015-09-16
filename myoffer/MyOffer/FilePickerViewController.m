//
//  FilePickerViewController.m
//  MyOffer
//
//  Created by Blankwonder on 6/23/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import "FilePickerViewController.h"

@interface FilePickerViewController () {
    NSArray *_files;
    BOOL _multipleSelection;
    NSArray *_cells;
    
    NSMutableSet *_selectedIDSet;
}

@end

@implementation FilePickerViewController

- (instancetype)initWithFiles:(NSArray *)files allowMultipleSelection:(BOOL)multipleSelection selectedIDSet:(NSMutableSet *)selectedIDSet {
    self = [self init];
    if (self) {
        _files = files;
        _multipleSelection = multipleSelection;
        _selectedIDSet = selectedIDSet;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cells = [_files KD_arrayUsingMapEnumerateBlock:^id(id obj, NSUInteger idx) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.textLabel.text = obj[@"title"] ?: obj[@"doc_title"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        NSString *id = cell.textLabel.text;
        if ([_selectedIDSet containsObject:id]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
        return cell;
    }];
    
    _noDataView.hidden = _cells.count > 0;
    
    if (!_selectedIDSet) {
        _selectedIDSet = [NSMutableSet set];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_cells count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _cells[indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *info = _files[indexPath.row];
    NSString *id = info[@"title"] ?: info[@"doc_title"];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if ([_selectedIDSet containsObject:id]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [_selectedIDSet removeObject:id];
    } else {
        if (!_multipleSelection) {
            [_selectedIDSet removeAllObjects];
            for (UITableViewCell *cell in _cells) {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }

        [_selectedIDSet addObject:id];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

@end
