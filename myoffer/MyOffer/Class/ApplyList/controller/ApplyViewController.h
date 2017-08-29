//
//  ApplyViewController.h
//  MyOffer
//
//  Created by Blankwonder on 6/20/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import "BaseViewController.h"

@interface ApplyViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>  
- (IBAction)applyButtonPressed;

@property(nonatomic,assign)NSInteger pop_back_index;

@end
