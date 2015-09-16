//
//  FilePickerViewController.h
//  MyOffer
//
//  Created by Blankwonder on 6/23/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import "BaseViewController.h"

@interface FilePickerViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *_tableView;
    IBOutlet UIView *_noDataView;
}

- (instancetype)initWithFiles:(NSArray *)files allowMultipleSelection:(BOOL)multipleSelection selectedIDSet:(NSMutableSet *)selectedIDSet;

@property (nonatomic) id userInfo;

@end
