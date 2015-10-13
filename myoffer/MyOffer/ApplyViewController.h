//
//  ApplyViewController.h
//  MyOffer
//
//  Created by Blankwonder on 6/20/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import "BaseViewController.h"

@interface ApplyViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *_waitingTableView;
    
    IBOutlet UIView *_waitingView, *_submittedView;
    
    IBOutlet UILabel *_selectCountLabel;
}
- (IBAction)applyButtonPressed;




@end
