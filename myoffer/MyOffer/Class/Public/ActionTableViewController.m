//
//  ActionTableViewController.m
//  zhonghaijinchao
//
//  Created by Blankwonder on 3/30/15.
//  Copyright (c) 2015 Blankwonder. All rights reserved.
//

#import "ActionTableViewController.h"

@interface ActionTableViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ActionTableViewController

- (void)loadView {
    if (self.nibName) {
        [super loadView];
    } else {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        self.view = _tableView;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ActionTableViewCell *cell = _cells[indexPath.section][indexPath.row];
    if (cell.action) cell.action();
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    ActionTableViewCell *cell = _cells[indexPath.section][indexPath.row];
    return cell.action != nil;
}

@end

@implementation ActionTableViewCell
@end
