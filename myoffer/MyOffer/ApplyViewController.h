//
//  ApplyViewController.h
//  MyOffer
//
//  Created by Blankwonder on 6/20/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import "BaseViewController.h"

@interface ApplyViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *_waitingTableView, *_submittedTableView;
    
    IBOutlet KDEasyTouchButton *_waitingButton, *_submittedButton;
    IBOutlet UILabel *_waitingCountLabel, *_submitedCountLabel;
    
    IBOutlet UIView *_waitingView, *_submittedView;
    
    IBOutlet UILabel *_selectCountLabel;
    IBOutlet UIButton *_selectAllButton;
}

- (IBAction)applyButtonPressed;

- (IBAction)waitingButton;
- (IBAction)submittedButton;

- (IBAction)selectAllButtonPressed;


@end
