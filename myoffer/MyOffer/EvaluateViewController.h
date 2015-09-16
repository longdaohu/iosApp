//
//  EvaluateViewController.h
//  MyOffer
//
//  Created by Blankwonder on 6/7/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EvaluateViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>{
    IBOutlet UITableView *_tableView;
    IBOutlet UIToolbar *_toolbar;
}

- (IBAction)submit;

@end
