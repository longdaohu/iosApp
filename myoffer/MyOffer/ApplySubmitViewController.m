//
//  ApplySubmitViewController.m
//  MyOffer
//
//  Created by xuewuguojie on 15/10/8.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "ApplySubmitViewController.h"
#import "SearchResultCell.h"

@interface ApplySubmitViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray  *_submittedCells;
}
@property (weak, nonatomic) IBOutlet UITableView *submittedTableView;
@property (weak, nonatomic) IBOutlet UIView *noDataView;

@end

 @implementation ApplySubmitViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"已提交申请";
     self.automaticallyAdjustsScrollViewInsets = NO;
     self.submittedTableView.tableFooterView = [[UIView alloc] init];
    
     [self reloadData];
}


- (void)reloadData {
   
    
    [self startAPIRequestWithSelector:@"GET api/account/checklist" parameters:nil success:^(NSInteger statusCode, id response) {
     //   __block int count = 0;
        
        
        NSArray *items = response;
        if (items.count == 0) {
            self.noDataView.hidden = NO;
        }
        
        
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
                
            //    count++;
                
                return cell;
            }];
            
            NSMutableArray *cells = [NSMutableArray arrayWithObject:cell];
            [cells addObjectsFromArray:courses];
            
            return cells;
        }];
        
        [self.submittedTableView reloadData];
        
     }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _submittedCells.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_submittedCells[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  _submittedCells[indexPath.section][indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_submittedCells[indexPath.section][indexPath.row] frame].size.height;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
