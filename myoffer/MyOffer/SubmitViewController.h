//
//  SubmitViewController.h
//  MyOffer
//
//  Created by Blankwonder on 6/22/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import "BaseViewController.h"

@interface SubmitViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>{
    IBOutlet UITableView *_tableView;
}

- (instancetype)initWithApplyInfo:(NSArray *)info selectedIDs:(NSSet *)ids;

- (IBAction)submit;

@end
