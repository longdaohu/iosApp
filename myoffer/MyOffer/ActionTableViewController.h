//
//  ActionTableViewController.h
//  zhonghaijinchao
//
//  Created by Blankwonder on 3/30/15.
//  Copyright (c) 2015 Blankwonder. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActionTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *countLabel;
@property (nonatomic, copy) void (^action)();
@end


@interface ActionTableViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *cells;

@end
